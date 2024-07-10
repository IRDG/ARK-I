------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Proyect:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                                                                      --
--                                                                                      --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY ALTERA;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;

USE WORK.BasicPackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY ControlFiniteStateMachine IS
    
    PORT     (  Instruction     : IN  uint32;
                MNEV            : IN  uint32;
                Mie             : IN  uint32;
                Mps             : IN  uint32;
                MipRd           : IN  uint32;
                BranchResult    : IN  uint01;
                BranchFail      : IN  uint01;
                DataDependency  : IN  uint01;
                CacheMiss       : IN  uint01;
                IrqX            : IN  uint04;
                UnknownInst     : IN  uint01;
                Rst             : IN  uint01;
                Clk             : IN  uint01;
                PcMode          : OUT uint02;
                CycleMePc       : OUT uint02;
                CsrExcWrEna     : OUT uint02;
                ExcCsrWrAddress : OUT uint32;
                ExcCsrData      : OUT uint32;
                ExcMemRd        : OUT uint01;
                AluExcOp        : OUT uint04;
                ExcPcWrEna      : OUT uint01;
                ClkConfig       : OUT uint01;
                PipelineMode    : OUT uint02;
                ForceNoOp       : OUT uint01;
                MipWr           : OUT uint32;
                ExcMipWrEna     : OUT uint01;
                AckX            : OUT uint04 
             );
    
END ENTITY ControlFiniteStateMachine;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE FsmArch OF ControlFiniteStateMachine IS

CONSTANT MaxCount    : UNSIGNED(2 DOWNTO 0) := TO_UNSIGNED(4,3);
CONSTANT MaxJalCount : UNSIGNED(2 DOWNTO 0) := TO_UNSIGNED(3,3);

TYPE StateType IS (NormalOperation   ,
                   ExcStart          ,
                   ExcBubbleStd      ,
                   ExcBubbleDfu      ,
                   ExcBubbleCacheMiss,
                   ExcFetchAddress   ,
                   ExcWriteCause     ,
                   ExcLoadNewPc      ,
                   ExcCacheMiss      ,
                   ExcFinal          ,
                   RtnStart          ,
                   RtnBubbleStd      ,
                   RtnBubbleDfu      ,
                   RtnBubbleCacheMiss,
                   RtnNoNested       ,
                   RtnNested         ,
                   RtnFinal          ,
                   JalStart          ,
                   JalBubble         ,
                   JalCacheMiss      ,
                   JalBubbleDfu      ,
                   JalFinal          ,
                   PipStart          ,
                   PipBubbleStd      ,
                   PipBubbleDfu      ,
                   PipBubbleCacheMiss,
                   PipStall          ,
                   PipClkToggle      ,
                   PipFinal          ,
                   CacheMissState    ,
                   BranchMiss        ,
                   BranchRecovery     
                  );

SIGNAL NextState        : StateType           ;
SIGNAL PrevState        : StateType           ;

SIGNAL MipRdOrException : uint05              ;
SIGNAL MipUpdate        : uint32              ;
SIGNAL MipUpdateClr     : uint32              ;
SIGNAL ExceptionFound   : uint01              ;
SIGNAL Exception        : UNSIGNED(4 DOWNTO 0);
SIGNAL IdleCounter      : UNSIGNED(2 DOWNTO 0);
SIGNAL Counter          : uint03              ;
SIGNAL RstCounter       : uint01              ;
SIGNAL EnaCounter       : uint01              ;
SIGNAL NextClkConfig    : uint01              ;
SIGNAL PrevClkConfig    : uint01              ;
SIGNAL NewClkConfig     : uint01              ;
SIGNAL PrevPipelineMode : uint02              ;
SIGNAL ClearMpsMsb      : uint32              ;
SIGNAL ToggleMpsLsb     : uint32              ;
SIGNAL PPM              : uint02              ;
SIGNAL NextPipelineMode : uint02              ;
SIGNAL PrevTempCause    : uint03              ;
SIGNAL NextTempCause    : uint03              ;
SIGNAL CauseSelect      : uint05              ;
SIGNAL Cause            : uint03              ;
SIGNAL Cause32          : uint32              ;
SIGNAL CausePriority    : uint03              ;
SIGNAL PrevPriority0    : uint03              ;
SIGNAL PrevPriority1    : uint03              ;
SIGNAL PrevPriority2    : uint03              ;
SIGNAL PrevPriority3    : uint03              ;
SIGNAL RealAck          : uint04              ;
SIGNAL PushNestLvl      : uint03              ;
SIGNAL PushMnev         : uint32              ;
SIGNAL PopNestLvl       : uint03              ;
SIGNAL PopMnev          : uint32              ;
SIGNAL PipelineToggle   : uint02              ;
SIGNAL MnevLevel        : UNSIGNED(2 DOWNTO 0);
SIGNAL CurrentPriority  : UNSIGNED(2 DOWNTO 0);

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

CounterBlock: ENTITY WORK.GralCounter(MainArch)
GENERIC MAP(Size => 3
           )
PORT MAP   (Ena      => EnaCounter ,
            MR       => Rst        ,
            SR       => RstCounter ,
            Clk      => Clk        ,
            MaxCount => OPEN       ,
            Count    => Counter     
           );

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

SignalsMemory: PROCESS (Rst, Clk, NextClkConfig, NextPipelineMode, NextTempCause)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevClkConfig    <=   '1';
        PrevPipelineMode <=  "01";
        PrevTempCause    <= "000";
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        PrevClkConfig    <= NextClkConfig   ;
        PrevPipelineMode <= NextPipelineMode;
        PrevTempCause    <= NextTempCause   ;
        
    END IF;
    
END PROCESS SignalsMemory;

------------------------------------------------------------
-- 
-- definition of multiple signals used in the FSM
-- 
------------------------------------------------------------
MipRdUpdateGenerator: FOR I IN 0 TO 4 GENERATE
    
    MipRdOrException(I) <= ((MipRd(I) OR Exception(I)) AND (Mie(11)));
    
END GENERATE MipRdUpdateGenerator;

MipUpdate        <= MipRd(31 DOWNTO 5) & MipRdOrException;
ToggleMpsLsb     <= Mps(31 DOWNTO 1) & (NOT Mps(0));
ClearMpsMsb      <= '0' & Mps(30 DOWNTO 0)         ;
ClkConfig        <=  PrevClkConfig                 ;
CauseSelect      <= MipRd(4 DOWNTO 0)              ;
NewClkConfig     <= (    PrevClkConfig XOR '1')    ;
PipelineToggle   <= (PPM(1)) & (PPM(0) XOR '1')    ;

MnevLevel        <= UNSIGNED(Mnev( 3 DOWNTO  1))   ;
IdleCounter      <= UNSIGNED(           Counter)   ;
Exception        <= UNSIGNED(IrqX & UnknownInst)   ;
CurrentPriority  <= UNSIGNED(Mnev(31 DOWNTO 29))   ;

ExceptionFound   <= '1' WHEN (Exception > 0) ELSE
                    '0';

WITH CauseSelect SELECT
Cause <= "111" WHEN "00000", -- CAMBIAR ERROR A +0
         "000" WHEN "00001",
         "001" WHEN "00010",
         "000" WHEN "00011",
         "010" WHEN "00100",
         "000" WHEN "00101",
         "001" WHEN "00110",
         "000" WHEN "00111",
         "011" WHEN "01000",
         "000" WHEN "01001",
         "001" WHEN "01010",
         "000" WHEN "01011",
         "010" WHEN "01100",
         "000" WHEN "01101",
         "001" WHEN "01110",
         "000" WHEN "01111",
         "100" WHEN "10000",
         "000" WHEN "10001",
         "001" WHEN "10010",
         "000" WHEN "10011",
         "010" WHEN "10100",
         "000" WHEN "10101",
         "001" WHEN "10110",
         "000" WHEN "10111",
         "011" WHEN "11000",
         "000" WHEN "11001",
         "001" WHEN "11010",
         "000" WHEN "11011",
         "010" WHEN "11100",
         "000" WHEN "11101",
         "001" WHEN "11110",
         "000" WHEN "11111",
         "111" WHEN OTHERS ;

WITH Cause SELECT
MipUpdateClr <= (MipRd(31 DOWNTO 5) & MipRd(4 DOWNTO 1) & "0"                    ) WHEN "000",
                (MipRd(31 DOWNTO 5) & MipRd(4 DOWNTO 2) & "0" & MipRd(         0)) WHEN "001",
                (MipRd(31 DOWNTO 5) & MipRd(4 DOWNTO 3) & "0" & MipRd(1 DOWNTO 0)) WHEN "010",
                (MipRd(31 DOWNTO 5) & MipRd(4         ) & "0" & MipRd(2 DOWNTO 0)) WHEN "011",
                (MipRd(31 DOWNTO 5) &                     "0" & MipRd(3 DOWNTO 0)) WHEN "100",
                (MipUpdate          ) WHEN OTHERS;


PPM     <= PrevPipelineMode        ;
Cause32 <= x"0000000" & '0' & Cause;


WITH Cause SELECT
CausePriority <= "101" WHEN "000", -- Error
                 "001" WHEN "001", -- Irq0
                 "010" WHEN "010", -- Irq1
                 "011" WHEN "011", -- Irq2
                 "100" WHEN "100", -- Irq3
                 "000" WHEN "111", -- None
                 "000" WHEN OTHERS;

PushNestLvl   <= (Int2Slv(Slv2Int(MNEV(3 DOWNTO 1)) + 1,3));

PushMnev      <= (CausePriority & MNEV(31 DOWNTO 23) & MNEV(19 DOWNTO 4) & PushNestLvl & MNEV(0));

PopNestLvl    <= (Int2Slv(Slv2Int(MNEV(3 DOWNTO 1)) - 1,3));

PopMnev       <= (MNEV(28 DOWNTO 17) & MNEV(19 DOWNTO 4) & PopNestLvl & MNEV(0));

WITH PrevState SELECT
PipelineMode <= ('1' & PPM(0))     WHEN CacheMissState,
                (PrevPipelineMode) WHEN OTHERS;

WITH Cause SELECT
RealAck <= "0001" WHEN "001",
           "0010" WHEN "010",
           "0100" WHEN "011",
           "1000" WHEN "100",
           "0000" WHEN OTHERS;

------------------------------------------------------------
-- 
-- Priority Level for nested interruptions
-- 
------------------------------------------------------------

PrevPriority0 <= MNEV(31 DOWNTO 29);
PrevPriority1 <= MNEV(28 DOWNTO 26);
PrevPriority2 <= MNEV(25 DOWNTO 23);
PrevPriority3 <= MNEV(22 DOWNTO 20);

------------------------------------------------------------
-- 
-- State machine logic and memory
-- 
------------------------------------------------------------

StateMemory: PROCESS (Rst, Clk,NextState)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevState <= NormalOperation;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        PrevState <= NextState;
        
    END IF;
    
END PROCESS StateMemory;

StateChange: PROCESS (PrevState    , PrevClkConfig  , PrevPipelineMode, Exception      , Mnev        ,
                      MnevLevel    , CurrentPriority, CausePriority   , Instruction    , Cause       ,
                      Mps          , DataDependency , IdleCounter     , PopMnev        , RealAck     ,
                      CacheMiss    , PPM            , Cause32         , NextTempCause  , PushMnev    ,
                      PrevTempCause, NewClkConfig   , PipelineToggle  , Mie            , ClearMpsMsb ,
                      ToggleMpsLsb , BranchFail     , MipUpdate       , ExceptionFound , MipRd       ,
                      MipUpdateClr )
BEGIN
    
    CASE PrevState IS
    ----------------------------------------------------------
        WHEN NormalOperation =>
            
            PcMode           <=                "01";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '0' & PPM(0);
            ForceNoOp        <=                 '0';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            IF    ((Slv2Int(MipRd) > 0) AND (Mnev(0) = '0')                                                                      AND (Mie(11) = '1') AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= ExcStart;
                
            ELSIF ((Slv2Int(MipRd) > 0) AND (Mnev(0) = '1') AND (MnevLevel < 4) AND (CurrentPriority <= UNSIGNED(CausePriority)) AND (Mie(11) = '1') AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= ExcStart;
                
            ELSIF ((Instruction(14 DOWNTO 12) = "000") AND (MnevLevel > 0) AND (Instruction(6 DOWNTO 2) = "11100")                                   AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= RtnStart;
                
            ELSIF ((Mps(31) = '1')                                                                                                                   AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= PipStart;
                
            ELSIF (((Instruction(6 DOWNTO 2) = "11011")  OR                    (Instruction(6 DOWNTO 2) = "11001"))              AND (PPM( 0) = '1') AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalStart;
                
            ELSIF(                                                                                                                                       (CacheMiss = '1') AND (BranchFail = '0')) THEN
                
                NextState <= CacheMissState;
                
            ELSIF(                                                                                                                                                             (BranchFail = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSE
                
                NextState <= NormalOperation;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcStart =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               Cause;
            
            IF    (Mps(0) = '0') THEN
                NextState <= ExcFetchAddress;
                
            ELSIF (Mps(0) = '1') THEN
                
                NextState <= ExcBubbleStd;
                
            ELSE
                
                NextState <= ExcStart;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcBubbleStd =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=       PrevTempCause;
            
            IF    ((DataDependency = '0') AND (IdleCounter = MaxCount)                     AND (CacheMiss = '0')) THEN
                
                NextState <= ExcFetchAddress;
                
            ELSIF ((DataDependency = '1')                                                  AND (CacheMiss = '0')) THEN
                
                NextState <= ExcBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel = 0) AND (CacheMiss = '0')) THEN
                
                NextState <= ExcFetchAddress;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel > 0) AND (CacheMiss = '0')) THEN
                
                NextState <= ExcFetchAddress;
                
            ELSIF (                                                                            (CacheMiss = '1')) THEN
                
                NextState <= ExcBubbleCacheMiss;
                
            ELSE
                
                NextState <= ExcBubbleStd;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcBubbleDfu =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=       PrevTempCause;
            
            IF    ((DataDependency = '0') AND (IdleCounter < MaxCount)                     AND (CacheMiss = '0')) THEN
                
                NextState <= ExcBubbleStd;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel = 0) AND (CacheMiss = '0')) THEN
                
                NextState <= ExcFetchAddress;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel > 0) AND (CacheMiss = '0')) THEN
                
                NextState <= ExcFetchAddress;
                
            ELSIF ((DataDependency = '1')                                                  AND (CacheMiss = '0')) THEN
                
                NextState <= ExcBubbleDfu;
                
            ELSIF (                                                                            (CacheMiss = '1')) THEN
                
                NextState <= ExcBubbleCacheMiss;
                
            ELSE
                
                NextState <= ExcBubbleDfu;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcBubbleCacheMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '1' & PPM(0);
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=       PrevTempCause;
            
            IF    ((CacheMiss = '0') AND (DataDependency = '0')) THEN
                
                NextState <= ExcBubbleStd;
                
            ELSIF ((CacheMiss = '0') AND (DataDependency = '1')) THEN
                
                NextState <= ExcBubbleDfu;
                
            ELSIF ((CacheMiss = '1')                           ) THEN
                
                NextState <= ExcBubbleCacheMiss;
                
            ELSE
                
                NextState <= ExcBubbleCacheMiss;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcFetchAddress =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "01";
            CsrExcWrEna      <=                "11";
            ExcCsrWrAddress  <=         x"00000342"; -- MCause Address
            ExcCsrData       <=             Cause32; -- Cause in 32 bits
            ExcMemRd         <=                 '0';
            AluExcOp         <= NextTempCause & '1';
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=       PrevTempCause;
            
            IF    ((PrevTempCause = "111")) THEN
                
                NextState <= ExcWriteCause;
                
            ELSE
                
                NextState <= ExcCacheMiss;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcWriteCause =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "01";
            ExcCsrWrAddress  <=         x"00000343"; -- Mtval Address
            ExcCsrData       <=         Instruction;
            ExcMemRd         <=                 '1';
            AluExcOp         <= NextTempCause & '1';
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=       PrevTempCause;
            
            IF (CacheMiss = '1') THEN
                
                NextState <= ExcCacheMiss;
                
            ELSE
                
                NextState <= ExcLoadNewPc; -- Prev Cache miss
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcCacheMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '1';
            AluExcOp         <= NextTempCause & '1';
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=       PrevTempCause;
            
            IF (CacheMiss = '1') THEN
                
                NextState <= ExcCacheMiss;
                
            ELSE
                
                NextState <= ExcLoadNewPc;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ExcLoadNewPc =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '1';
            AluExcOp         <= NextTempCause & '1';
            ExcPcWrEna       <=                 '1';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=       PrevTempCause;
            
            NextState <= ExcFinal;
            
    ----------------------------------------------------------
        WHEN ExcFinal =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "01";
            ExcCsrWrAddress  <=         x"00000FFB"; -- MNEV
            ExcCsrData       <=            PushMnev; -- Priority lvl and nesting lvl
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=        MipUpdateClr; -- CLEAR CAUSE
            ExcMipWrEna      <=                 '1';
            
            AckX             <=             RealAck;
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000"; -- Rst NextTempCause
            
            IF (CacheMiss = '1') THEN
                
                NextState <= CacheMissState;
                
            ELSE
                
                NextState <= NormalOperation;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN RtnStart =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            IF    ((Mps(0) = '0') AND (MnevLevel = 1)) THEN
                
                NextState <= RtnNoNested;
                
            ELSIF ((Mps(0) = '0') AND (MnevLevel > 1)) THEN
                
                NextState <= RtnNested;
                
            ELSIF ((Mps(0) = '1')                    ) THEN
                
                NextState <= RtnBubbleStd;
                
            ELSE
                
                NextState <= RtnStart;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN RtnBubbleStd =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter < MaxCount)                     AND (CacheMiss = '0')) THEN
                
                NextState <= RtnBubbleStd;
                
            ELSIF ((DataDependency = '1')                                                  AND (CacheMiss = '0')) THEN
                
                NextState <= RtnBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel = 1) AND (CacheMiss = '0')) THEN
                
                NextState <= RtnNoNested;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel > 1) AND (CacheMiss = '0')) THEN
                
                NextState <= RtnNested;
                
            ELSIF (                                                                            (CacheMiss = '1')) THEN
                
                NextState <= RtnBubbleCacheMiss;
                
            ELSE
                
                NextState <= RtnBubbleStd;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN RtnBubbleDfu =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter < MaxCount)                     AND (CacheMiss = '0')) THEN
                
                NextState <= RtnBubbleStd;
                
            ELSIF ((DataDependency = '1')                                                  AND (CacheMiss = '0')) THEN
                
                NextState <= RtnBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel = 1) AND (CacheMiss = '0')) THEN
                
                NextState <= RtnNoNested;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (MnevLevel > 1) AND (CacheMiss = '0')) THEN
                
                NextState <= RtnNested;
                
            ELSIF (                                                                            (CacheMiss = '1')) THEN
                
                NextState <= RtnBubbleCacheMiss;
                
            ELSE
                
                NextState <= RtnBubbleDfu;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN RtnBubbleCacheMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '1' & PPM(0);
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((CacheMiss = '0') AND (DataDependency = '1')) THEN
                
                NextState <= RtnBubbleDfu;
                
            ELSIF ((CacheMiss = '0') AND (DataDependency = '0')) THEN
                
                NextState <= RtnBubbleStd;
                
            ELSIF ((CacheMiss = '1')                           ) THEN
                
                NextState <= RtnBubbleCacheMiss;
                
            ELSE
                
                NextState <= RtnBubbleCacheMiss;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN RtnNoNested =>
            
            PcMode           <=                "11";
            CycleMePc        <=                "10";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= RtnFinal;
            
    ----------------------------------------------------------
        WHEN RtnNested =>
            
            PcMode           <=                "11";
            CycleMePc        <=                "10";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= RtnFinal;
            
    ----------------------------------------------------------
        WHEN RtnFinal =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "01";
            ExcCsrWrAddress  <=         x"00000FFB";
            ExcCsrData       <=             PopMnev;
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= NormalOperation;
            
    ----------------------------------------------------------
        WHEN JalStart =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter <  MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0') AND (PPM(0) = '1')) THEN
                
                NextState <= JalBubble;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter >= MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0') AND (PPM(0) = '1')) THEN
                
                NextState <= JalFinal;
                
            ELSIF ((DataDependency = '1')                                  AND (CacheMiss = '0') AND (BranchFail = '0') AND (PPM(0) = '1')) THEN
                
                NextState <= JalBubbleDfu;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '0') AND (PPM(0) = '1')) THEN
                
                NextState <= JalCacheMiss;
                
            ELSIF (                                                            (CacheMiss = '0') AND (BranchFail = '1') AND (PPM(0) = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '1') AND (PPM(0) = '1')) THEN
                
                NextState <= CacheMissState;
                
            ELSIF (                                                                                                         (PPM(0) = '0')) THEN
                
                NextState <= JalFinal;
                
            ELSE
                
                NextState <= JalStart;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN JalBubble =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter <  MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubble;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter >= MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalFinal;
                
            ELSIF ((DataDependency = '1')                                  AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubbleDfu;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '0')) THEN
                
                NextState <= JalCacheMiss;
                
            ELSIF (                                                            (CacheMiss = '0') AND (BranchFail = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '1')) THEN
                
                NextState <= CacheMissState;
                
            ELSE
                
                NextState <= JalBubble;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN JalBubbleDfu =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter <  MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubble;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter >= MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalFinal;
                
            ELSIF ((DataDependency = '1')                                  AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubbleDfu;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '0')) THEN
                
                NextState <= JalCacheMiss;
                
            ELSIF (                                                            (CacheMiss = '0') AND (BranchFail = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '1')) THEN
                
                NextState <= CacheMissState;
                
            ELSE
                
                NextState <= JalBubbleDfu;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN JalCacheMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter <  MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubble;
                
            ELSIF ((DataDependency = '1') AND (IdleCounter <  MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter >= MaxJalCount) AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalFinal;
                
            ELSIF ((CacheMiss = '1')                           ) THEN
                
                NextState <= JalCacheMiss;
                
            ELSIF (                                                            (CacheMiss = '0') AND (BranchFail = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSIF (                                                            (CacheMiss = '1') AND (BranchFail = '1')) THEN
                
                NextState <= CacheMissState;
                
            ELSE
                
                NextState <= JalCacheMiss;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN JalFinal =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= NormalOperation;
            
    ----------------------------------------------------------
        WHEN PipStart =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "01"; -- Write Csr
            ExcCsrWrAddress  <=         x"00000FFA"; -- Mps
            ExcCsrData       <=         ClearMpsMsb; -- Clear MSB
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            NextState <= PiPBubbleStd;
            
    ----------------------------------------------------------
        WHEN PipBubbleStd =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '1';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter < MaxCount) AND (CacheMiss = '0')) THEN
                
                NextState <= PipBubbleStd;
                
            ELSIF ((DataDependency = '1')                              AND (CacheMiss = '0')) THEN
                
                NextState <= PipBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (CacheMiss = '0')) THEN
                
                NextState <= PipStall;
                
            ELSIF (                                                        (CacheMiss = '1')) THEN
                
                NextState <= PipBubbleCacheMiss;
                
            ELSE
                
                NextState <= PipBubbleStd;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN PipBubbleDfu =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((DataDependency = '0') AND (IdleCounter < MaxCount) AND (CacheMiss = '0')) THEN
                
                NextState <= PipBubbleStd;
                
            ELSIF ((DataDependency = '1')                              AND (CacheMiss = '0')) THEN
                
                NextState <= PipBubbleDfu;
                
            ELSIF ((DataDependency = '0') AND (IdleCounter = MaxCount) AND (CacheMiss = '0')) THEN
                
                NextState <= PipStall;
                
            ELSIF (                                                        (CacheMiss = '1')) THEN
                
                NextState <= PipBubbleCacheMiss;
                
            ELSE
                
                NextState <= PipBubbleDfu;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN PipBubbleCacheMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '1' & PPM(0);
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '0';
            NextTempCause    <=               "000";
            
            IF    ((CacheMiss = '0') AND (DataDependency = '0')) THEN
                
                NextState <= PipBubbleStd;
                
            ELSIF ((CacheMiss = '0') AND (DataDependency = '1')) THEN
                
                NextState <= PipBubbleDfu;
                
            ELSIF ((CacheMiss = '1')                           ) THEN
                
                NextState <= PipBubbleCacheMiss;
                
            ELSE
                
                NextState <= PipBubbleCacheMiss;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN PipStall =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= PipClkToggle;
            
    ----------------------------------------------------------
        WHEN PipClkToggle =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "01"; -- CsrWrite
            ExcCsrWrAddress  <=         x"00000FFA"; -- MIP
            ExcCsrData       <=        ToggleMpsLsb; -- Toggle MIP LSB
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=        NewClkConfig;
            NextPipelineMode <=      PipelineToggle;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            NextState <= PipFinal;
            
    ----------------------------------------------------------
        WHEN PipFinal =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=    PrevPipelineMode;
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            
            IF (Mps(31) = '1') THEN
                
                NextState <= PipStart;
                
            ELSE
                
                NextState <= NormalOperation;
                
            END IF;
    
    ----------------------------------------------------------
        WHEN CacheMissState =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '0' & PPM(0);
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            IF    (CacheMiss = '0') THEN
                
                NextState <= NormalOperation;
                
            ELSIF (CacheMiss = '1') THEN
                
                NextState <= CacheMissState;
                
            ELSE
                
                NextState <= CacheMissState;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN BranchMiss =>
            
            PcMode           <=                "00";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '1' & PPM(0);
            ForceNoOp        <=                 '1';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            
            NextState <= BranchRecovery;
            
            
    ----------------------------------------------------------
        WHEN BranchRecovery =>
            
            PcMode           <=                "01";
            CycleMePc        <=                "00";
            CsrExcWrEna      <=                "00";
            ExcCsrWrAddress  <=         x"00000000";
            ExcCsrData       <=         x"00000000";
            ExcMemRd         <=                 '0';
            AluExcOp         <=              "0000";
            ExcPcWrEna       <=                 '0';
            NextClkConfig    <=       PrevClkConfig;
            NextPipelineMode <=        '0' & PPM(0);
            ForceNoOp        <=                 '0';
            MipWr            <=           MipUpdate;
            ExcMipWrEna      <=      ExceptionFound;
            
            AckX             <=              "0000";
            EnaCounter       <=                 '0';
            RstCounter       <=                 '1';
            NextTempCause    <=               "000";
            
            IF    ((Slv2Int(MipRd) > 0) AND (Mnev(0) = '0')                                                                      AND (Mie(11) = '1') AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= ExcStart;
                
            ELSIF ((Slv2Int(MipRd) > 0) AND (Mnev(0) = '1') AND (MnevLevel < 4) AND (CurrentPriority <= UNSIGNED(CausePriority)) AND (Mie(11) = '1') AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= ExcStart;
                
            ELSIF ((Instruction(14 DOWNTO 12) = "000") AND (MnevLevel > 0) AND (Instruction(6 DOWNTO 2) = "11100")                                   AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= RtnStart;
                
            ELSIF ((Mps(31) = '1')                                                                                                                   AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= PipStart;
                
            ELSIF (((Instruction(6 DOWNTO 2) = "11011")  OR                    (Instruction(6 DOWNTO 2) = "11001"))                                  AND (CacheMiss = '0') AND (BranchFail = '0')) THEN
                
                NextState <= JalStart;
                
            ELSIF(                                                                                                                                       (CacheMiss = '1') AND (BranchFail = '0')) THEN
                
                NextState <= CacheMissState;
                
            ELSIF(                                                                                                                                                             (BranchFail = '1')) THEN
                
                NextState <= BranchMiss;
                
            ELSE
                
                NextState <= NormalOperation;
                
            END IF;
            
    ----------------------------------------------------------
    END CASE;
    
END PROCESS StateChange;

END FsmArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ControlFiniteStateMachine(FsmArch)
--PORT MAP   (Instruction     => SLV,
--            MNEV            => SLV,
--            Mie             => SLV,
--            Mps             => SLV,
--            BranchResult    => SLV,
--            DataDependency  => SLV,
--            CacheMiss       => SLV,
--            IrqX            => SLV,
--            UnknownInst     => SLV,
--            Rst             => SLV,
--            Clk             => SLV,
--            PcMode          => SLV,
--            CycleMePc       => SLV,
--            CsrExcWrEna     => SLV,
--            ExcCsrWrAddress => SLV,
--            ExcCsrData      => SLV,
--            ExcMemRd        => SLV,
--            AluExcOp        => SLV,
--            ExcPcWrEna      => SLV,
--            ClkConfig       => SLV,
--            PipelineMode    => SLV,
--            ForceNoOp       => SLV,
--            AckX            => SLV 
--           );
------------------------------------------------------------------------------------------
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

USE WORK.BasicPackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY BranchPredictionUnit IS
    
    PORT   (BranchType    : IN  uint04;
            CmpRes        : IN  uint06;
            PcPlusImm     : IN  uint32;
            Pc            : IN  uint32;
            BpuMode       : IN  uint01;
            CacheMiss     : IN  uint01;
            Dependency    : IN  uint01;
            PipelineStall : IN  uint01;
            OpCode        : IN  uint05;
            Rst           : IN  uint01;
            Clk           : IN  uint01;
            NewPc         : OUT uint32;
            EnaLoad       : OUT uint01;
            ClrPipeline   : OUT uint01;
            BranchFail    : OUT uint01;
            BranchResult  : OUT uint01 
           );
    
END ENTITY BranchPredictionUnit;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF BranchPredictionUnit IS

CONSTANT Zero           : uint32 := (OTHERS => ('0'));

SIGNAL   Jump           : uint01;
SIGNAL   BranchRes      : uint01;

SIGNAL   NewDiscardedPc : uint32;
SIGNAL   Predict        : uint01;
SIGNAL   Correct        : uint01;
SIGNAL   CmpMask        : uint06;
SIGNAL   Cmp            : uint01;
SIGNAL   Load           : uint01;
SIGNAL   PcSel          : uint02;
SIGNAL   NewPcSel       : uint02;
SIGNAL   SelectedPc     : uint32;
SIGNAL   PcPlusOne      : uint32;

SIGNAL   Stall          : uint01;

SIGNAL   ImmCmpMask     : uint06;
SIGNAL   ImmLoad        : uint01;
SIGNAL   ImmCmp         : uint01;
SIGNAL   PipNewPc       : uint32;
SIGNAL   ImmNewPc       : uint32;
SIGNAL   ImmPcSelected  : uint32;

SIGNAL   ActiveBranch0  : uint01;
SIGNAL   ActiveBranch1  : uint01;
SIGNAL   BranchType0    : uint04;
SIGNAL   BranchType1    : uint04;
SIGNAL   DiscardedPc0   : uint32;
SIGNAL   DiscardedPc1   : uint32;

BEGIN

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

Stall      <= CacheMiss OR Dependency OR (PipelineStall AND BpuMode);

ImmLoad    <= BranchType(3);

WITH BranchType(2 DOWNTO 0) SELECT
ImmCmpMask <= "000100" WHEN "000", --  =  
              "001000" WHEN "001", -- /=  
              "000010" WHEN "100", -- <   
              "000101" WHEN "101", -- >=  
              "100000" WHEN "110", -- <  u
              "010100" WHEN "111", -- >= u
              "000000" WHEN OTHERS;

ImmCmp     <= (ImmCmpMask(0) AND CmpRes(0)) OR
              (ImmCmpMask(1) AND CmpRes(1)) OR
              (ImmCmpMask(2) AND CmpRes(2)) OR
              (ImmCmpMask(3) AND CmpRes(3)) OR
              (ImmCmpMask(4) AND CmpRes(4)) OR
              (ImmCmpMask(5) AND CmpRes(5))  ;

WITH ImmCmp SELECT
ImmPcSelected <= PcPlusOne WHEN '0',
                 PcPlusImm WHEN '1',
                 Zero      WHEN OTHERS;

WITH ImmLoad SELECT
ImmNewPc <= ImmPcSelected WHEN '1',
            Zero          WHEN OTHERS;

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

WITH BranchType1(2 DOWNTO 0) SELECT
CmpMask <= "000100" WHEN "000", --  =  
           "001000" WHEN "001", -- /=  
           "000010" WHEN "100", -- <   
           "000101" WHEN "101", -- >=  
           "100000" WHEN "110", -- <  u
           "010100" WHEN "111", -- >= u
           "000000" WHEN OTHERS;

Cmp     <= (CmpMask(0) AND CmpRes(0)) OR
           (CmpMask(1) AND CmpRes(1)) OR
           (CmpMask(2) AND CmpRes(2)) OR
           (CmpMask(3) AND CmpRes(3)) OR
           (CmpMask(4) AND CmpRes(4)) OR
           (CmpMask(5) AND CmpRes(5))  ;

WITH Jump SELECT
Correct <= ((NOT Cmp ) AND BranchType1(3)) WHEN '1',
           ((    Cmp ) AND BranchType1(3)) WHEN '0',
           ('0'                          ) WHEN OTHERS;

Predict <= (    Jump) AND BranchType (3);

Load    <= Correct OR Predict;

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

BranchReg:PROCESS(Clk, Rst, NewDiscardedPc, DiscardedPc0, DiscardedPc1)
BEGIN
    
    IF(Rst = '1') THEN
        
        DiscardedPc0 <= Zero;
        DiscardedPc1 <= Zero;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF    ((BpuMode = '0') OR (Correct = '1')) THEN
            
            DiscardedPc0 <= Zero;
            DiscardedPc1 <= Zero;
            
        ELSIF (Stall   = '1') THEN
            
            DiscardedPc0 <= DiscardedPc0;
            DiscardedPc1 <= DiscardedPc1;
            
        ELSE
            DiscardedPc0 <= NewDiscardedPc;
            DiscardedPc1 <= DiscardedPc0  ;
            
        END IF;
        
    END IF;
    
END PROCESS BranchReg;

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

PcPlusOne      <= Int2Slv((Slv2Int(Pc) + 1),32);

PcSel          <= BranchType(3) & Jump   ;

NewPcSel       <= Correct       & Predict;

WITH PcSel SELECT
NewDiscardedPc <= Zero      WHEN "00",
                  Zero      WHEN "01",
                  PcPlusImm WHEN "10",
                  PcPlusOne WHEN "11",
                  Zero      WHEN OTHERS;

WITH PcSel SELECT
SelectedPc     <= Zero      WHEN "00",
                  Zero      WHEN "01",
                  Pc        WHEN "10",
                  PcPlusImm WHEN "11",
                  Zero      WHEN OTHERS;

WITH NewPcSel SELECT
PipNewPc       <= Zero         WHEN "00",
                  SelectedPc   WHEN "01",
                  DiscardedPc1 WHEN "10",
                  Zero         WHEN "11",
                  Zero         WHEN OTHERS;

BranchRes      <= (NOT Correct) AND BpuMode;

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

PcReg:PROCESS(Clk, Rst, BranchType, BranchType0, BranchType1)
BEGIN
    
    IF(Rst = '1') THEN
        
        BranchType0   <= "0000";
        BranchType1   <= "0000";
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF    ((BpuMode = '0') OR (Correct = '1')) THEN
            
            BranchType0   <= "0000";
            BranchType1   <= "0000";
            
        ELSIF (Stall   = '1') THEN
            
            BranchType0   <= BranchType0;
            BranchType1   <= BranchType1;
            
        ELSE
            
            BranchType0   <= BranchType   ;
            BranchType1   <= BranchType0  ;
            
        END IF;
        
    END IF;
    
END PROCESS PcReg;

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

BpuFSM: ENTITY WORK.BpuFiniteStateMachine(MainArch)
PORT MAP   (BranchResult => BranchRes     ,
            Enable       => BranchType1(3),
            Rst          => Rst           ,
            Clk          => Clk           ,
            Jump         => Jump           
           );

----------------------------------------------------------
-- 
-- 
-- 
----------------------------------------------------------

WITH BpuMode SELECT
EnaLoad      <= Load    WHEN '1',
                ImmLoad WHEN '0',
                '0'     WHEN OTHERS;

WITH BpuMode SELECT
BranchResult <= (BranchRes AND Load) WHEN '1',
                 BranchRes           WHEN '0',
                 '0'                 WHEN OTHERS;

ClrPipeline  <=  Correct AND BpuMode;

BranchFail   <=  Correct;

WITH BpuMode SELECT
NewPc        <= PipNewPc WHEN '1',
                ImmNewPc WHEN '0',
                Zero     WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.BranchPredictionUnit(MainArch)
--PORT MAP   (BranchType    => SLV,
--            CmpRes        => SLV,
--            PcPlusImm     => SLV,
--            Pc            => SLV,
--            BpuMode       => SLV,
--            CacheMiss     => SLV,
--            Dependency    => SLV,
--            PipelineStall => SLV,
--            OpCode        => SLV,
--            Rst           => SLV,
--            Clk           => SLV,
--            NewPc         => SLV,
--            EnaLoad       => SLV,
--            ClrPipeline   => SLV,
--            BranchFail    => SLV,
--            BranchResult  => SLV 
--           );
------------------------------------------------------------------------------------------
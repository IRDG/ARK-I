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

ENTITY ControlUnit IS
    
    PORT   (Instruction       : IN  uint32           ;
            Pc                : IN  uint32           ;
            Mps               : IN  uint32           ;
            Mie               : IN  uint32           ;
            Mnev              : IN  uint32           ;
            MipRd             : IN  uint32           ;
            DfuDataDependency : IN  uint01           ;
            BranchResult      : IN  uint01           ;
            BranchFail        : IN  uint01           ;
            IrqX              : IN  uint04           ;
            CacheMiss         : IN  uint01           ;
            Rst               : IN  uint01           ;
            Clk               : IN  uint01           ;
            ControlWord       : OUT ControlWordDecode;
            PcMode            : OUT uint02           ;
            ClkConfig         : OUT uint01           ;
            ExcCtrlWord       : OUT CtrlExcT         ;
            BranchType        : OUT uint04           ;
            BpuMode           : OUT uint01           ;
            GprAddress        : OUT RegAddressT      ;
            DfuMode           : OUT uint01           ;
            MipWr             : OUT uint32           ;
            ExcMipWrEna       : OUT uint01           ;
            PipelineMode      : OUT uint02           ;
            AckX              : OUT uint04            
           );
    
END ENTITY ControlUnit;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ControlUnit IS

CONSTANT NoBranch           : uint04 := (OTHERS => ('0'));

SIGNAL   OpCode             : uint07           ;
SIGNAL   Funct3             : uint03           ;
SIGNAL   Funct7             : uint07           ;
SIGNAL   UnknownInst        : uint01           ;
SIGNAL   TempUnknownInstI   : uint01           ;
SIGNAL   TempUnknownInstII  : uint01           ;
SIGNAL   TempUnknownInstIII : uint01           ;
SIGNAL   FsmPcMode          : uint02           ;
SIGNAL   TmpPcModeI         : uint02           ;
SIGNAL   TmpPcModeII        : uint02           ;
SIGNAL   TmpPcModeIII       : uint02           ;
SIGNAL   TmpPcModeIV        : uint02           ;
SIGNAL   GprUsed            : uint03           ;
SIGNAL   ForceNoOp          : uint01           ;

SIGNAL   FinalControlWord   : ControlWordDecode;
SIGNAL   TempControlWord    : ControlWordDecode;
SIGNAL   TempBranchType     : uint04           ;
SIGNAL   TempPipelineMode   : uint02           ;
SIGNAL   FinalPipelineMode  : uint02           ;

BEGIN

------------------------------------------------------------
-- 
-- Summon micro memory to handle all common instructions
-- 
------------------------------------------------------------

OpCode             <= Instruction ( 6 DOWNTO  0);
Funct3             <= Instruction (14 DOWNTO 12);
Funct7             <= Instruction (31 DOWNTO 25);

ControlWord        <= FinalControlWord;

WITH CacheMiss   SELECT
UnknownInst        <= TempUnknownInstIII WHEN '0',
                      '0'                WHEN OTHERS;

WITH TmpPcModeIV SELECT
TempUnknownInstIII <= '0'                WHEN "00",
                      TempUnknownInstII  WHEN OTHERS;

WITH ForceNoOp   SELECT
TempUnknownInstII  <= TempUnknownInstI   WHEN '0',
                      '0'                WHEN OTHERS;

WITH ForceNoOp   SELECT
BranchType         <= TempBranchType     WHEN '0',
                      NoBranch           WHEN OTHERS;

WITH ForceNoOp   SELECT
FinalControlWord   <= TempControlWord    WHEN '0',
                      NoOpControlWord    WHEN OTHERS;

uPM: ENTITY WORK.MicroProgramMemory(MainArch)
PORT MAP   (OpCode      => OpCode          ,
            Funct3      => Funct3          ,
            Funct7      => Funct7          ,
            ControlWord => TempControlWord ,
            UnknownInst => TempUnknownInstI,
            BranchType  => TempBranchType  ,
            GprUsed     => GprUsed          
           );

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

PipelineMode <= FinalPipelineMode;

WITH CacheMiss SELECT
FinalPipelineMode <= TempPipelineMode          WHEN '0',
                     '1' & TempPipelineMode(0) WHEN OTHERS;

DfuMode           <= TempPipelineMode(0);
BpuMode           <= TempPipelineMode(0);
PcMode            <= TmpPcModeIV        ;

WITH FinalPipelineMode(0) SELECT
TmpPcModeIV       <= TmpPcModeIII WHEN '1',
                     TmpPcModeII  WHEN OTHERS;

WITH FinalControlWord.InstId SELECT
TmpPcModeIII      <= "00"         WHEN InstJal ,
                     "00"         WHEN InstJalr,
                     TmpPcModeII  WHEN OTHERS  ;

WITH CacheMiss SELECT
TmpPcModeII       <= "00"         WHEN '1',
                     TmpPcModeI   WHEN OTHERS;

WITH DfuDataDependency SELECT
TmpPcModeI        <= "00"         WHEN '1',
                     FsmPcMode    WHEN OTHERS;

CtrlFsm: ENTITY WORK.ControlFiniteStateMachine(FsmArch)
PORT MAP   (Instruction     => Instruction              ,
            MNEV            => Mnev                     ,
            Mie             => Mie                      ,
            Mps             => Mps                      ,
            MipRd           => MipRd                    ,
            BranchResult    => BranchResult             ,
            BranchFail      => BranchFail               ,
            DataDependency  => DfuDataDependency        ,
            CacheMiss       => CacheMiss                ,
            IrqX            => IrqX                     ,
            UnknownInst     => UnknownInst              ,
            Rst             => Rst                      ,
            Clk             => Clk                      ,
            PcMode          => FsmPcMode                ,
            CycleMePc       => ExcCtrlWord.CycleMePc    ,
            CsrExcWrEna     => ExcCtrlWord.ExcCsrWrEna  ,
            ExcCsrWrAddress => ExcCtrlWord.ExcCsrAddress,
            ExcCsrData      => ExcCtrlWord.ExcCsrData   ,
            ExcMemRd        => ExcCtrlWord.ExcMemRd     ,
            AluExcOp        => ExcCtrlWord.ExcAluOp     ,
            ExcPcWrEna      => ExcCtrlWord.ExcPcWrEna   ,
            ClkConfig       => ClkConfig                ,
            PipelineMode    => TempPipelineMode         ,
            ForceNoOp       => ForceNoOp                ,
            MipWr           => MipWr                    ,
            ExcMipWrEna     => ExcMipWrEna              ,
            AckX            => AckX                      
           );

------------------------------------------------------------
-- 
-- Detect which GPR are being used and send their address
-- to the dfu
-- 
------------------------------------------------------------

GprAddress.Pc <= Pc;

WITH GprUsed(0) SELECT
GprAddress.Rs1 <= Instruction(19 DOWNTO 15) WHEN '1',
                  "00000"                   WHEN OTHERS;

WITH GprUsed(1) SELECT
GprAddress.Rs2 <= Instruction(24 DOWNTO 20) WHEN '1',
                  "00000"                   WHEN OTHERS;

WITH GprUsed(2) SELECT
GprAddress.Rd <= Instruction(11 DOWNTO  7) WHEN '1',
                 "00000"                   WHEN OTHERS;

END MainArch;
------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ControlUnit(MainArch)
--PORT MAP   (Instruction       => SLV,
--            Pc                => SLV,
--            Mps               => SLV,
--            Mie               => SLV,
--            Mnev              => SLV,
--            DfuDataDependency => SLV,
--            BranchResult      => SLV,
--            BranchFail        => SLV,
--            IrqX              => SLV,
--            CacheMiss         => SLV,
--            Rst               => SLV,
--            Clk               => SLV,
--            ControlWord       => SLV,
--            PcMode            => SLV,
--            ClkConfig         => SLV,
--            ExcCtrlWord       => SLV,
--            BranchType        => SLV,
--            BpuMode           => SLV,
--            GprAddress        => SLV,
--            DfuMode           => SLV,
--            Mip               => SLV,
--            ExcMipWrEna       => SLV,
--            PipelineMode      => SLV,
--            AckX              => SLV 
--           );
------------------------------------------------------------------------------------------
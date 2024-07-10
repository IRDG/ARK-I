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

ENTITY AluStage IS
    
    PORT   (RegisterData   : IN  RegisterStageDataT;
            ControlWordIn  : IN  ControlWordAlu    ;
            MtVec          : IN  uint32            ;
            ExcAluOp       : IN  uint04            ;
            PipelineMode   : IN  uint04            ;
            Rst            : IN  uint01            ;
            Clk            : IN  uint01            ;
            AluData        : OUT AluStageDataT     ;
            ControlWordOut : OUT ControlWordMemory ;
            CsrOperation   : OUT uint03            ;
            CsrWrAddress   : OUT uint32            ;
            GprData        : OUT uint32            ;
            ImmData        : OUT uint05            ;
            AluResult      : OUT uint32            ;
            CmpRes         : OUT uint06             
           );
    
END ENTITY AluStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF AluStage IS

SIGNAL AluFlags          : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL TempAluResult     : uint32                      ;

SIGNAL RegisterDataLocal : AluStageDataT               ;
SIGNAL ControlWordLocal  : ControlWordMemory           ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

AluResult                            <= TempAluResult                      ;
CmpRes                               <= RegisterData.CmpRes                ;
CsrOperation                         <= ControlWordIn.AluStage.CsrOperation;
CsrWrAddress                         <= RegisterData.ImmData               ;
GprData                              <= RegisterData.GprData1              ;
ImmData                              <= RegisterData.CsrImmData            ;

RegisterDataLocal.AluResult          <= TempAluResult                      ;
RegisterDataLocal.GprData2           <= RegisterData.GprData2              ;
RegisterDataLocal.ImmData            <= RegisterData.ImmData               ;
RegisterDataLocal.RdAddress          <= RegisterData.RdAddress             ;
RegisterDataLocal.CsrData            <= RegisterData.CsrData               ;
RegisterDataLocal.Negative           <= AluFlags(0)                        ;
RegisterDataLocal.PcNext             <= RegisterData.PcNext                ;

ControlWordLocal.MStage.PcEnaLoadAlu <= ControlWordIn.MStage.PcEnaLoadAlu  ;
ControlWordLocal.MStage.MdrOperation <= ControlWordIn.MStage.MdrOperation  ;
ControlWordLocal.WbStage.WbDataSrc   <= ControlWordIn.WbStage.WbDataSrc    ;
ControlWordLocal.WbStage.GprWrEna    <= ControlWordIn.WbStage.GprWrEna     ;
ControlWordLocal.InstId              <= ControlWordIn.InstId               ;

ALU: ENTITY WORK.ArithmeticLogicUnit(MainArch)
PORT MAP   (Operation => ControlWordIn.AluStage.AluOperation,
            Source    => ControlWordIn.AluStage.AluSource   ,
            CmpRes    => RegisterData.CmpRes                ,
            Shamt     => RegisterData.Shamt                 ,
            ImmData   => RegisterData.ImmData               ,
            GprData1  => RegisterData.GprData1              ,
            GprData2  => RegisterData.GprData2              ,
            Pc        => RegisterData.Pc                    ,
            Mtvec     => MtVec                              ,
            ExcOp     => ExcAluOp                           ,
            AluResult => TempAluResult                      ,
            AluFlags  => AluFlags                            
           );

AsMs: ENTITY WORK.AluStageToMemoryStage(MainArch)
PORT MAP   (DataIn  => RegisterDataLocal,
            CtrlIn  => ControlWordLocal ,
            Mode    => PipelineMode     ,
            Rst     => Rst              ,
            Clk     => Clk              ,
            DataOut => AluData          ,
            CtrlOut => ControlWordOut    
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.AluStage(MainArchitecture)
--PORT MAP   (RegisterData   => SLV,
--            ControlWordIn  => SLV,
--            MtVec          => SLV,
--            ExcAluOp       => SLV,
--            PipelineMode   => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            AluData        => SLV,
--            ControlWordOut => SLV,
--            CsrOperation   => SLV,
--            CsrWrAddress   => SLV,
--            GprData        => SLV,
--            ImmData        => SLV,
--            AluResult      => SLV,
--            CmpRes         => SLV
--           );
------------------------------------------------------------------------------------------
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

ENTITY DecodeStage IS
    
    PORT   (Instruction    : IN  uint32           ;
            ControlWordIn  : IN  ControlWordDecode;
            PcMode         : IN  uint02           ;
            NewPc          : IN  uint32           ;
            MePcRd         : IN  uint32           ;
            AluResult      : IN  uint32           ;
            PcEnableLoad   : IN  uint01           ;
            PcEnableLoadMS : IN  uint01           ;
            PcExcCtrl      : IN  PcExcControlT    ;
            PipelineMode   : IN  uint04           ;
            CoreId         : IN  uint01           ;
            Rst            : IN  uint01           ;
            Clk            : IN  uint01           ;
            DecodeData     : OUT DecodeStageDataT ;
            ControlWordOut : OUT ControlWordReg   ;
            MePcWr         : OUT uint32           ;
            Pc             : OUT uint32           ;
            PcPlusImm      : OUT uint32            
           );
    
END ENTITY DecodeStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF DecodeStage IS

SIGNAL ImmUData         : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL ImmIData         : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL ImmSData         : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL SextImmSData     : uint32                       ;

SIGNAL TempPc           : uint32                       ;

SIGNAL DecodeDataLocal  : DecodeStageDataT             ;
SIGNAL ControlWordLocal : ControlWordReg               ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

MePcWr                                 <= TempPc                             ;
Pc                                     <= TempPc                             ;
DecodeDataLocal .Pc                    <= TempPc                             ;

ControlWordLocal.AluStage.AluOperation <= ControlWordIn.AluStage.AluOperation;
ControlWordLocal.AluStage.AluSource    <= ControlWordIn.AluStage.AluSource   ;
ControlWordLocal.AluStage.CsrOperation <= ControlWordIn.AluStage.CsrOperation;
ControlWordLocal.MStage  .PcEnaLoadAlu <= ControlWordIn.MStage  .PcEnaLoadAlu;
ControlWordLocal.MStage  .MdrOperation <= ControlWordIn.MStage  .MdrOperation;
ControlWordLocal.WbStage .WbDataSrc    <= ControlWordIn.WbStage .WbDataSrc   ;
ControlWordLocal.WbStage .GprWrEna     <= ControlWordIn.WbStage .GprWrEna    ;
ControlWordLocal.InstId                <= ControlWordIn.InstId               ;

IR: ENTITY WORK.InstructionRegister(MainArch)
PORT MAP   (Instruction => Instruction               ,
            ImmUData    => ImmUData                  ,
            ImmIData    => ImmIData                  ,
            ImmSData    => ImmSData                  ,
            RdAddress   => DecodeDataLocal.RdAddress ,
            Rs1Address  => DecodeDataLocal.Rs1Address,
            Rs2Address  => DecodeDataLocal.Rs2Address 
           );

ISB: ENTITY WORK.ImmediateSelectionBlock(MainArch)
PORT MAP   (ImmUData    => ImmUData                      ,
            ImmIData    => ImmIData                      ,
            ImmSDataIn  => ImmSData                      ,
            ImmSext     => ControlWordIn.DecStage.ImmSext,
            Format      => ControlWordIn.DecStage.Format ,
            ImmData     => DecodeDataLocal.ImmData       ,
            ImmSDataOut => SextImmSData                   
           );

PCR: ENTITY WORK.ProgramCounter(MainArch)
PORT MAP   (ImmData    => SextImmSData          ,
            NewPc      => NewPc                 ,
            MePcRd     => MePcRd                ,
            EnaLoad    => PcEnableLoad          ,
            EnaLoadMS  => PcEnableLoadMS        ,
            AluResult  => AluResult             ,
            NewExcPc   => PcExcCtrl.NewExcPc    ,
            PcMode     => PcMode                ,
            ExcPcWrEna => PcExcCtrl.ExcPcWrEna  ,
            CoreId     => CoreId                ,
            Rst        => Rst                   ,
            Clk        => Clk                   ,
            Pc         => TempPc                ,
            NextPc     => DecodeDataLocal.PcNext,
            PcPlusImm  => PcPlusImm              
           );

DsRs: ENTITY WORK.DecodeStageToRegisterStage(MainArch)
PORT MAP   (DataIn  => DecodeDataLocal ,
            CtrlIn  => ControlWordLocal,
            Mode    => PipelineMode    ,
            Rst     => Rst             ,
            Clk     => Clk             ,
            DataOut => DecodeData      ,
            CtrlOut => ControlWordOut   
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.DecodeStage(MainArchitecture)
--PORT MAP   (Instruction    => SLV,
--            ControlWordIn  => SLV,
--            PcMode         => SLV,
--            NewPc          => SLV,
--            MePcRd         => SLV,
--            AluResult      => SLV,
--            PcEnableLoad   => SLV,
--            PcEnableLoadMS => SLV,
--            PcExcCtrl      => SLV,
--            PipelineMode   => SLV,
--            CoreId         => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            DecodeData     => SLV,
--            ControlWordOut => SLV,
--            MePcWr         => SLV,
--            Pc             => SLV,
--            PcPlusImm      => SLV
--           );
------------------------------------------------------------------------------------------
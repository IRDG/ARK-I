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

ENTITY PipelineRegisters IS
    
    PORT   (DataIn         : IN  DecodeStageDataT ;
            ControlWordIn  : IN  ControlWordReg   ;
            PipelineMode   : IN  uint04           ;
            Rst            : IN  uint01           ;
            Clk            : IN  uint01           ;
            DataOut        : OUT MemStageDataT    ;
            ControlWordOut : OUT ControlWordWb     
           );
    
END ENTITY PipelineRegisters;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF PipelineRegisters IS

SIGNAL DecodeData    : DecodeStageDataT  ;
SIGNAL DecodeCtrl    : ControlWordReg    ;
SIGNAL DecodeDataOut : DecodeStageDataT  ;
SIGNAL DecodeCtrlOut : ControlWordReg    ;

SIGNAL RegData       : RegisterStageDataT;
SIGNAL RegCtrl       : ControlWordAlu    ;
SIGNAL RegDataOut    : RegisterStageDataT;
SIGNAL RegCtrlOut    : ControlWordAlu    ;

SIGNAL AluData       : AluStageDataT     ;
SIGNAL AluCtrl       : ControlWordMemory ;
SIGNAL AluDataOut    : AluStageDataT     ;
SIGNAL AluCtrlOut    : ControlWordMemory ;

SIGNAL MemData       : MemStageDataT     ;
SIGNAL MemCtrl       : ControlWordWb     ;
SIGNAL MemDataOut    : MemStageDataT     ;
SIGNAL MemCtrlOut    : ControlWordWb     ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

DecodeData                    <= DataIn                             ;
DecodeCtrl                    <= ControlWordIn                      ;

DsRs: ENTITY WORK.DecodeStageToRegisterStage(MainArch)
PORT MAP   (DataIn  => DecodeData   ,
            CtrlIn  => DecodeCtrl   ,
            Mode    => PipelineMode ,
            Rst     => Rst          ,
            Clk     => Clk          ,
            DataOut => DecodeDataOut,
            CtrlOut => DecodeCtrlOut 
           );

RegData.CmpRes                <=               "111111"             ;
RegData.GprData1              <=              x"10000001"           ;
RegData.GprData2              <=              x"20000002"           ;
RegData.ImmData               <= DecodeDataOut.ImmData              ;
RegData.RdAddress             <= DecodeDataOut.RdAddress            ;
RegData.CsrImmData            <= DecodeDataOut.Rs1Address           ;
RegData.Shamt                 <= DecodeDataOut.Rs2Address           ;
RegData.PcNext                <= DecodeDataOut.PcNext               ;
RegData.Pc                    <= DecodeDataOut.Pc                   ;
RegData.CsrData               <=              x"30000003"           ;

RegCtrl.AluStage.AluOperation <= DecodeCtrlOut.AluStage.AluOperation;
RegCtrl.AluStage.AluSource    <= DecodeCtrlOut.AluStage.AluSource   ;
RegCtrl.AluStage.CsrOperation <= DecodeCtrlOut.AluStage.CsrOperation;
RegCtrl.MStage.MdrOperation   <= DecodeCtrlOut.MStage.MdrOperation  ;
RegCtrl.WbStage.WbDataSrc     <= DecodeCtrlOut.WbStage.WbDataSrc    ;
RegCtrl.WbStage.GprWrEna      <= DecodeCtrlOut.WbStage.GprWrEna     ;
RegCtrl.InstId                <= DecodeCtrlOut.InstId               ;

RsAs: ENTITY WORK.RegisterStageToAluStage(MainArch)
PORT MAP   (DataIn  => RegData      ,
            CtrlIn  => RegCtrl      ,
            Mode    => PipelineMode ,
            Rst     => Rst          ,
            Clk     => Clk          ,
            DataOut => RegDataOut   ,
            CtrlOut => RegCtrlOut    
           );

AluData.AluResult             <=            x"12121212"             ;
AluData.GprData2              <= RegDataOut.GprData2                ;
AluData.ImmData               <= RegDataOut.ImmData                 ;
AluData.RdAddress             <= RegDataOut.RdAddress               ;
AluData.CsrData               <= RegDataOut.CsrData                 ;
AluData.Negative              <=            '1'                     ;
AluData.PcNext                <= RegDataOut.PcNext                  ;

AluCtrl.MStage.MdrOperation   <= RegCtrlOut.MStage.MdrOperation     ;
AluCtrl.WbStage.WbDataSrc     <= RegCtrlOut.WbStage.WbDataSrc       ;
AluCtrl.WbStage.GprWrEna      <= RegCtrlOut.WbStage.GprWrEna        ;
AluCtrl.InstId                <= RegCtrlOut.InstId                  ;

AsMs: ENTITY WORK.AluStageToMemoryStage(MainArch)
PORT MAP   (DataIn  => AluData      ,
            CtrlIn  => AluCtrl      ,
            Mode    => PipelineMode ,
            Rst     => Rst          ,
            Clk     => Clk          ,
            DataOut => AluDataOut   ,
            CtrlOut => AluCtrlOut    
           );

MemData.AluResult             <= AluDataOut.AluResult               ;
MemData.ImmData               <= AluDataOut.ImmData                 ;
MemData.RdAddress             <= AluDataOut.RdAddress               ;
MemData.CsrData               <= AluDataOut.CsrData                 ;
MemData.Negative              <= AluDataOut.Negative                ;
MemData.PcNext                <= AluDataOut.PcNext                  ;
MemData.MemData               <=            x"23232323"             ;

MemCtrl.WbStage.WbDataSrc     <= AluCtrlOut.WbStage.WbDataSrc       ;
MemCtrl.WbStage.GprWrEna      <= AluCtrlOut.WbStage.GprWrEna        ;
MemCtrl.InstId                <= AluCtrlOut.InstId                  ;

MsWs: ENTITY WORK.MemoryStageToWriteBackStage(MainArch)
PORT MAP   (DataIn  => MemData      ,
            CtrlIn  => MemCtrl      ,
            Mode    => PipelineMode ,
            Rst     => Rst          ,
            Clk     => Clk          ,
            DataOut => MemDataOut   ,
            CtrlOut => MemCtrlOut    
           );

DataOut        <= MemDataOut   ;
ControlWordOut <= MemCtrlOut   ;

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.PipelineRegisters(MainArchitecture)
--PORT MAP   (DataIn         => SLV,
--            ControlWordIn  => SLV,
--            PipelineMode   => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            DataOut        => SLV,
--            ControlWordOut => SLV
--           );
------------------------------------------------------------------------------------------
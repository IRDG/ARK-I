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

ENTITY RegisterReadStage IS
    
    PORT   (DecodeData     : IN  DecodeStageDataT  ;
            ControlWordIn  : IN  ControlWordReg    ;
            GprWrEna       : IN  uint01            ;
            WbData         : IN  uint32            ;
            RdAddress      : IN  uint05            ;
            DfuWrite       : IN  DfuOutBusT        ;
            MePcWr         : IN  uint32            ;
            MipWr          : IN  uint32            ;
            ExcMipWrEna    : IN  uint01            ;
            CsrOperation   : IN  uint03            ;
            CsrExcBus      : IN  CsrExcBusT        ;
            CycleMePc      : IN  uint02            ;
            CsrWrAddress   : IN  uint32            ;
            GprData        : IN  uint32            ;
            ImmData        : IN  uint05            ;
            CoreId         : IN  uint01            ;
            PipelineMode   : IN  uint04            ;
            Rst            : IN  uint01            ;
            Clk            : IN  uint01            ;
            RegisterData   : OUT RegisterStageDataT;
            ControlWordOut : OUT ControlWordAlu    ;
            Mnev           : OUT uint32            ;
            Mie            : OUT uint32            ;
            Mps            : OUT uint32            ;
            MipRd          : OUT uint32            ;
            MtVec          : OUT uint32            ;
            MePcRd         : OUT uint32             
           );
    
END ENTITY RegisterReadStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF RegisterReadStage IS

SIGNAL GprData1          : uint32            ;
SIGNAL GprData2          : uint32            ;

SIGNAL RegisterDataLocal : RegisterStageDataT;
SIGNAL ControlWordLocal  : ControlWordAlu    ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RegisterDataLocal.GprData1             <=            GprData1  ;
RegisterDataLocal.GprData2             <=            GprData2  ;
RegisterDataLocal.ImmData              <= DecodeData.ImmData   ;
RegisterDataLocal.RdAddress            <= DecodeData.RdAddress ;
RegisterDataLocal.CsrImmData           <= DecodeData.Rs1Address;
RegisterDataLocal.Shamt                <= DecodeData.Rs2Address;
RegisterDataLocal.PcNext               <= DecodeData.PcNext    ;
RegisterDataLocal.Pc                   <= DecodeData.Pc        ;

ControlWordLocal.AluStage.AluOperation <= ControlWordIn.AluStage.AluOperation;
ControlWordLocal.AluStage.AluSource    <= ControlWordIn.AluStage.AluSource   ;
ControlWordLocal.AluStage.CsrOperation <= ControlWordIn.AluStage.CsrOperation;
ControlWordLocal.MStage.PcEnaLoadAlu   <= ControlWordIn.MStage.PcEnaLoadAlu  ;
ControlWordLocal.MStage.MdrOperation   <= ControlWordIn.MStage.MdrOperation  ;
ControlWordLocal.WbStage.WbDataSrc     <= ControlWordIn.WbStage.WbDataSrc    ;
ControlWordLocal.WbStage.GprWrEna      <= ControlWordIn.WbStage.GprWrEna     ;
ControlWordLocal.InstId                <= ControlWordIn.InstId               ;

GPR: ENTITY WORK.GeneralPurposeRegisters(MainArch)
PORT MAP   (R1Address  => DecodeData.Rs1Address,
            R2Address  => DecodeData.Rs2Address,
            RdAddress  => RdAddress            ,
            WbData     => WbData               ,
            WrEna      => GprWrEna             ,
            DfuAddress => DfuWrite.DfuAddress  ,
            DfuData    => DfuWrite.DfuData     ,
            DfuWrEna   => DfuWrite.DfuWrEna    ,
            Rst        => Rst                  ,
            Clk        => Clk                  ,
            GprData1   => GprData1             ,
            GprData2   => GprData2              
           );

Cmp: ENTITY WORK.Comparator(MainArch)
PORT MAP   (A           => GprData1                ,
            B           => GprData2                ,
            Comparisson => RegisterDataLocal.CmpRes 
           );

CSR: ENTITY WORK.ControlAndStatusRegisters(MainArch)
PORT MAP   (RdAddress   => DecodeData.ImmData       ,
            MepcWr      => MePcWr                   ,
            MipWr       => MipWr                    ,
            ExcMipWrEna => ExcMipWrEna              ,
            WrOperation => CsrOperation             ,
            ExcWrEna    => CsrExcBus.ExcCsrWrEna    ,
            ExcData     => CsrExcBus.ExcCsrData     ,
            ExcAddress  => CsrExcBus.ExcCsrAddress  ,
            CycleMepc   => CycleMePc                ,
            WrAddress   => CsrWrAddress             ,
            GprData     => GprData                  ,
            ImmData     => ImmData                  ,
            CoreId      => CoreId                   ,
            Rst         => Rst                      ,
            Clk         => Clk                      ,
            MepcRd      => MepcRd                   ,
            Mtvec       => Mtvec                    ,
            Mnev        => Mnev                     ,
            Mie         => Mie                      ,
            Mps         => Mps                      ,
            MipRd       => MipRd                    ,
            CsrData     => RegisterDataLocal.CsrData 
           );

RsAs: ENTITY WORK.RegisterStageToAluStage(MainArch)
PORT MAP   (DataIn  => RegisterDataLocal,
            CtrlIn  => ControlWordLocal ,
            Mode    => PipelineMode     ,
            Rst     => Rst              ,
            Clk     => Clk              ,
            DataOut => RegisterData     ,
            CtrlOut => ControlWordOut    
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.RegisterReadStage(MainArchitecture)
--PORT MAP   (DecodeData     => SLV,
--            ControlWordIn  => SLV,
--            GprWrEna       => SLV,
--            WbData         => SLV,
--            RdAddress      => SLV,
--            DfuWrite       => SLV,
--            MePcWr         => SLV,
--            MipWr          => SLV,
--            ExcMipWrEna    => SLV,
--            Mtval          => SLV,
--            CsrOperation   => SLV,
--            CsrExcBus      => SLV,
--            CycleMePc      => SLV,
--            CsrWrAddress   => SLV,
--            GprData        => SLV,
--            ImmData        => SLV,
--            CoreId         => SLV,
--            PipelineMode   => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            RegisterData   => SLV,
--            ControlWordOut => SLV,
--            Mnev           => SLV,
--            Mie            => SLV,
--            Mps            => SLV,
--            MipRd          => SLV,
--            MtVec          => SLV,
--            MePcRd         => SLV
--           );
------------------------------------------------------------------------------------------
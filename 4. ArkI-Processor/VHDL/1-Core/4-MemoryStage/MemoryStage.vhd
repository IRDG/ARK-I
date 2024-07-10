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

ENTITY MemoryStage IS
    
    PORT   (AluData        : IN  AluStageDataT    ;
            ControlWordIn  : IN  ControlWordMemory;
            ExcMemRd       : IN  uint01           ;
            AluResult      : IN  uint32           ;
            PipelineMode   : IN  uint04           ;
            RdData         : IN  uint32           ;
            Rst            : IN  uint01           ;
            Clk            : IN  uint01           ;
            WrData         : OUT uint32           ;
            MemoryData     : OUT MemStageDataT    ;
            ControlWordOut : OUT ControlWordWb    ;
            BusAddress     : OUT uint32           ;
            BusRdWrEna     : OUT uint02           ;
            NewExcPc       : OUT uint32           ;
            PcEnaLoad      : OUT uint01           ;
            FwdData        : OUT DfuInBusT         
           );
    
END ENTITY MemoryStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF MemoryStage IS

SIGNAL RegisterDataLocal : MemStageDataT;
SIGNAL ControlWordLocal  : ControlWordWb;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

FwdData.AluResult                  <= AluData.AluResult                ;
FwdData.ImmData                    <= AluData.ImmData                  ;
FwdData.RdAddress                  <= AluData.RdAddress                ;
FwdData.CsrData                    <= AluData.CsrData                  ;
FwdData.Negative                   <= AluData.Negative                 ;
FwdData.PcNext                     <= AluData.PcNext                   ;

RegisterDataLocal.AluResult        <= AluData.AluResult                ;
RegisterDataLocal.ImmData          <= AluData.ImmData                  ;
RegisterDataLocal.RdAddress        <= AluData.RdAddress                ;
RegisterDataLocal.CsrData          <= AluData.CsrData                  ;
RegisterDataLocal.Negative         <= AluData.Negative                 ;
RegisterDataLocal.PcNext           <= AluData.PcNext                   ;

ControlWordLocal.WbStage.WbDataSrc <= ControlWordIn.WbStage.WbDataSrc  ;
ControlWordLocal.WbStage.GprWrEna  <= ControlWordIn.WbStage.GprWrEna   ;
ControlWordLocal.InstId            <= ControlWordIn.InstId             ;

PcEnaLoad                          <= ControlWordIn.MStage.PcEnaLoadAlu;

MdrMar: ENTITY WORK.MemoryDataRegisterAndMemoryAddressRegister(MainArch)
PORT MAP   (AddressIn    => AluData.AluResult                ,
            DataWr       => AluData.GprData2                 ,
            ExcVTable    => AluResult                        ,
            ExcMemRd     => ExcMemRd                         ,
            MdrOperation => ControlWordIn.MStage.MdrOperation,
            RdDataBus    => RdData                           ,
            WrDataBus    => WrData                           ,
            AddressOut   => BusAddress                       ,
            RdWrEna      => BusRdWrEna                       ,
            DataRd       => RegisterDataLocal.MemData        ,
            NewExcPc     => NewExcPc                          
           );

MsWs: ENTITY WORK.MemoryStageToWriteBackStage(MainArch)
PORT MAP   (DataIn  => RegisterDataLocal,
            CtrlIn  => ControlWordLocal ,
            Mode    => PipelineMode     ,
            Rst     => Rst              ,
            Clk     => Clk              ,
            DataOut => MemoryData       ,
            CtrlOut => ControlWordOut    
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.MemoryStage(MainArchitecture)
--PORT MAP   (AluData        => SLV,
--            ControlWordIn  => SLV,
--            ExcMemRd       => SLV,
--            AluResult      => SLV,
--            PipelineMode   => SLV,
--            RdData         => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            WrData         => SLV,
--            MemoryData     => SLV,
--            ControlWordOut => SLV,
--            BusAddress     => SLV,
--            BusRdWrN       => SLV,
--            NewExcPc       => SLV,
--            PcEnaLoad      => SLV,
--            FwdData        => SLV
--           );
------------------------------------------------------------------------------------------
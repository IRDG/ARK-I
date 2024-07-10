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

ENTITY RiscVCore IS
    
    PORT   (Instruction : IN  uint32;
            RdData      : IN  uint32;
            IRQ         : IN  uint04;
            CacheMiss   : IN  uint01;
            CoreId      : IN  uint01;
            Rst         : IN  uint01;
            ClkIn       : IN  uint01;
            WrData      : OUT uint32;
            PcAddress   : OUT uint32;
            DataAddress : OUT uint32;
            RdWrEna     : OUT uint02;
            Ack         : OUT uint04 
           );
    
END ENTITY RiscVCore;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF RiscVCore IS

SIGNAL DecodeControlWord    : ControlWordDecode ;
SIGNAL RegisterControlWord  : ControlWordReg    ;
SIGNAL AluControlWord       : ControlWordAlu    ;
SIGNAL MemoryControlWord    : ControlWordMemory ;
SIGNAL WriteBackControlWord : ControlWordWb     ;

SIGNAL PcMode               : uint02            ;
SIGNAL NewPc                : uint32            ;
SIGNAL AluResult            : uint32            ;
SIGNAL PcEnableLoad         : uint01            ;
SIGNAL PcEnableLoadMS       : uint01            ;
SIGNAL PipelineMode         : uint04            ;
SIGNAL LoaclClk             : uint01            ;
SIGNAL MePcWr               : uint32            ;
SIGNAL Pc                   : uint32            ;
SIGNAL PcPlusImm            : uint32            ;

SIGNAL GprWrEna             : uint01            ;
SIGNAL WbData               : uint32            ;
SIGNAL RdAddress            : uint05            ;
SIGNAL DfuWrite             : DfuOutBusT        ;
SIGNAL CsrOperation         : uint03            ;
SIGNAL CycleMePc            : uint02            ;
SIGNAL CsrWrAddress         : uint32            ;
SIGNAL GprData              : uint32            ;
SIGNAL ImmData              : uint05            ;
SIGNAL Mnev                 : uint32            ;
SIGNAL Mie                  : uint32            ;
SIGNAL Mps                  : uint32            ;
SIGNAL MtVec                : uint32            ;
SIGNAL MePcRd               : uint32            ;
SIGNAL MipRd                : uint32            ;
SIGNAL MipWr                : uint32            ;
SIGNAL ExcMipWrEna          : uint01            ;

SIGNAL ExcAluOp             : uint04            ;
SIGNAL CmpRes               : uint06            ;

SIGNAL ExcMemRd             : uint01            ;
SIGNAL GprAddress           : RegAddressT       ;
SIGNAL FwdData              : DfuInBusT         ;

SIGNAL DfuDataDependency    : uint01            ;
SIGNAL ClkConfig            : uint01            ;
SIGNAL BranchType           : uint04            ;
SIGNAL BpuMode              : uint01            ;
SIGNAL GprRsX1              : uint05            ;
SIGNAL GprRsX2              : uint05            ;
SIGNAL GprRdX               : uint05            ;
SIGNAL DfuMode              : uint01            ;
SIGNAL WbDataSrc            : uint03            ;
SIGNAL DsOpCode             : uint05            ;

SIGNAL BranchResult         : uint01            ;
SIGNAL BranchFail           : uint01            ;

SIGNAL LocalClk             : uint01            ;

SIGNAL DecodeData           : DecodeStageDataT  ;
SIGNAL RegisterData         : RegisterStageDataT;
SIGNAL AluData              : AluStageDataT     ;
SIGNAL MemoryData           : MemStageDataT     ;

SIGNAL PcExcCtrl            : PcExcControlT     ;
SIGNAL CsrExcBus            : CsrExcBusT        ;
SIGNAL CtrlExc              : CtrlExcT          ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

PcAddress <= Pc;

PcExcCtrl.ExcPcWrEna    <= CtrlExc.ExcPcWrEna   ;

CsrExcBus.ExcCsrWrEna   <= CtrlExc.ExcCsrWrEna  ;
CsrExcBus.ExcCsrData    <= CtrlExc.ExcCsrData   ;
CsrExcBus.ExcCsrAddress <= CtrlExc.ExcCsrAddress;

ExcAluOp                <= CtrlExc.ExcAluOp     ;
CycleMePc               <= CtrlExc.CycleMePc    ;
ExcMemRd                <= CtrlExc.ExcMemRd     ;

WbDataSrc               <= MemoryControlWord.WbStage.WbDataSrc;
DsOpCode                <= Instruction(6 DOWNTO 2);

DS: ENTITY WORK.DecodeStage(MainArchitecture)
PORT MAP   (Instruction       => Instruction             ,
            ControlWordIn     => DecodeControlWord       ,
            PcMode            => PcMode                  ,
            NewPc             => NewPc                   ,
            MePcRd            => MePcRd                  ,
            AluResult         => FwdData.AluResult       ,
            PcEnableLoad      => PcEnableLoad            ,
            PcEnableLoadMS    => PcEnableLoadMS          ,
            PcExcCtrl         => PcExcCtrl               ,
            PipelineMode      => PipelineMode            ,
            CoreId            => CoreId                  ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            DecodeData        => DecodeData              ,
            ControlWordOut    => RegisterControlWord     ,
            MePcWr            => MePcWr                  ,
            Pc                => Pc                      ,
            PcPlusImm         => PcPlusImm                
           );

RRS: ENTITY WORK.RegisterReadStage(MainArchitecture)
PORT MAP   (DecodeData        => DecodeData              ,
            ControlWordIn     => RegisterControlWord     ,
            GprWrEna          => GprWrEna                ,
            WbData            => WbData                  ,
            RdAddress         => RdAddress               ,
            DfuWrite          => DfuWrite                ,
            MePcWr            => MePcWr                  ,
            MipWr             => MipWr                   ,
            ExcMipWrEna       => ExcMipWrEna             ,
            CsrOperation      => CsrOperation            ,
            CsrExcBus         => CsrExcBus               ,
            CycleMePc         => CycleMePc               ,
            CsrWrAddress      => CsrWrAddress            ,
            GprData           => GprData                 ,
            ImmData           => ImmData                 ,
            CoreId            => CoreId                  ,
            PipelineMode      => PipelineMode            ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            RegisterData      => RegisterData            ,
            ControlWordOut    => AluControlWord          ,
            Mnev              => Mnev                    ,
            Mie               => Mie                     ,
            Mps               => Mps                     ,
            MipRd             => MipRd                   ,
            MtVec             => MtVec                   ,
            MePcRd            => MePcRd                  
           );

AS: ENTITY WORK.AluStage(MainArchitecture)
PORT MAP   (RegisterData      => RegisterData            ,
            ControlWordIn     => AluControlWord          ,
            MtVec             => MtVec                   ,
            ExcAluOp          => ExcAluOp                ,
            PipelineMode      => PipelineMode            ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            AluData           => AluData                 ,
            ControlWordOut    => MemoryControlWord       ,
            CsrOperation      => CsrOperation            ,
            CsrWrAddress      => CsrWrAddress            ,
            GprData           => GprData                 ,
            ImmData           => ImmData                 ,
            AluResult         => AluResult               ,
            CmpRes            => CmpRes                  
           );

MS: ENTITY WORK.MemoryStage(MainArchitecture)
PORT MAP   (AluData           => AluData                 ,
            ControlWordIn     => MemoryControlWord       ,
            ExcMemRd          => ExcMemRd                ,
            AluResult         => AluResult               ,
            PipelineMode      => PipelineMode            ,
            RdData            => RdData                  ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            WrData            => WrData                  ,
            MemoryData        => MemoryData              ,
            ControlWordOut    => WriteBackControlWord    ,
            BusAddress        => DataAddress             ,
            BusRdWrEna        => RdWrEna                 ,
            NewExcPc          => PcExcCtrl.NewExcPc      ,
            PcEnaLoad         => PcEnableLoadMS          ,
            FwdData           => FwdData                  
           );

WBS: ENTITY WORK.WriteBackStage(MainArchitecture)
PORT MAP   (MemoryData        => MemoryData              ,
            ControlWordIn     => WriteBackControlWord    ,
            WbData            => WbData                  ,
            RdAddress         => RdAddress               ,
            GprWrEna          => GprWrEna                
           );

Ctrl: ENTITY WORK.ControlUnit(MainArch)
PORT MAP   (Instruction       => Instruction             ,
            Pc                => Pc                      ,
            Mps               => Mps                     ,
            Mie               => Mie                     ,
            Mnev              => Mnev                    ,
            MipRd             => MipRd                   ,
            DfuDataDependency => DfuDataDependency       ,
            BranchResult      => BranchResult            ,
            BranchFail        => BranchFail              ,
            IrqX              => Irq                     ,
            CacheMiss         => CacheMiss               ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            ControlWord       => DecodeControlWord       ,
            PcMode            => PcMode                  ,
            ClkConfig         => ClkConfig               ,
            ExcCtrlWord       => CtrlExc                 ,
            BranchType        => BranchType              ,
            BpuMode           => BpuMode                 ,
            GprAddress        => GprAddress              ,
            DfuMode           => DfuMode                 ,
            MipWr             => MipWr                   ,
            ExcMipWrEna       => ExcMipWrEna             ,
            PipelineMode      => PipelineMode(1 DOWNTO 0),
            AckX              => Ack                      
           );

BPU: ENTITY WORK.BranchPredictionUnit(MainArch)
PORT MAP   (BranchType        => BranchType              ,
            CmpRes            => CmpRes                  ,
            PcPlusImm         => PcPlusImm               ,
            Pc                => Pc                      ,
            BpuMode           => BpuMode                 ,
            CacheMiss         => CacheMiss               ,
            Dependency        => DfuDataDependency       ,
            PipelineStall     => PipelineMode(1)         ,
            OpCode            => Instruction(6 DOWNTO 2) ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            NewPc             => NewPc                   ,
            EnaLoad           => PcEnableLoad            ,
            ClrPipeline       => PipelineMode(3)         ,
            BranchFail        => BranchFail              ,
            BranchResult      => BranchResult             
           );

DFU: ENTITY WORK.DataForwardingUnit(MainArch)
PORT MAP   (DfuDataIn         => FwdData                 ,
            DfuMode           => DfuMode                 ,
            CacheMiss         => CacheMiss               ,
            GprAddress        => GprAddress              ,
            PipelineMode      => PipelineMode(0)         ,
            WbDataSrc         => WbDataSrc               ,
            DsOpCode          => DsOpCode                ,
            Rst               => Rst                     ,
            Clk               => LocalClk                ,
            DfuDataOut        => DfuWrite                ,
            DisablePipeline   => PipelineMode(2)         ,
            DataDependency    => DfuDataDependency        
           );

LCM: ENTITY WORK.LocalClockModule(MainArch)
PORT MAP   (ClkConfig         => ClkConfig               ,
            Rst               => Rst                     ,
            Clk               => ClkIn                   ,
            LocalClk          => LocalClk                 
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.RiscVCore(MainArchitecture)
--GENERIC MAP(CoreId => #
--           )
--PORT MAP   (Instruction => SLV,
--            RdData      => SLV,
--            IRQ         => SLV,
--            CacheMiss   => SLV,
--            Rst         => SLV,
--            ClkIn       => SLV,
--            WrData      => SLV,
--            PcAddress   => SLV,
--            DataAddress => SLV,
--            RdWrEna     => SLV,
--            Ack         => SLV
--           );
------------------------------------------------------------------------------------------

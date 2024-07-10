quietly WaveActivateNextPane
add wave -noupdate -divider Memory
add wave -noupdate -color Orange -label DataRd -radix hexadecimal /coretestprotocol/X1/Memory/DataRd2
add wave -noupdate -color Orange -label Address -radix hexadecimal /coretestprotocol/X1/Memory/Address2
add wave -noupdate -color Orange -label RdWrEnable /coretestprotocol/X1/Memory/RdWrEnable2
add wave -noupdate -color Orange -label DataWr -radix hexadecimal /coretestprotocol/X1/Memory/DataWr2
add wave -noupdate -divider Cache
add wave -noupdate -color Turquoise -label Pc -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/Pc
add wave -noupdate -color Turquoise -label Instruction -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/Instruction
add wave -noupdate -color Turquoise -label CacheMiss /coretestprotocol/X1/ArkI2/Cache/CacheMiss
add wave -noupdate -color Turquoise -label RdWrAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/RdWrAddress
add wave -noupdate -color Turquoise -label WrData -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/WrData
add wave -noupdate -color Turquoise -label RdWrEnable /coretestprotocol/X1/ArkI2/Cache/RdWrEnable
add wave -noupdate -color Turquoise -label RdData -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/RdData
add wave -noupdate -divider Core-DS
add wave -noupdate -color {Cornflower Blue} -label InstId /coretestprotocol/X1/ArkI2/ArkI/DS/ControlWordIn.InstId
add wave -noupdate -color {Cornflower Blue} -label Pc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/Pc
add wave -noupdate -divider Core-RRS
add wave -noupdate -color {Medium Spring Green} -label InstId /coretestprotocol/X1/ArkI2/ArkI/RRS/ControlWordIn.InstId
add wave -noupdate -color {Medium Spring Green} -label Rs1Address -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/DecodeData.Rs1Address
add wave -noupdate -color {Medium Spring Green} -label Rs2Address -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/DecodeData.Rs2Address
add wave -noupdate -color {Medium Spring Green} -label RdAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/DecodeData.RdAddress
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MIsa -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMisa
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MIE -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMie
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MTVec -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMtvec
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MCause -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMcause
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MTVal -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMtval
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MarchId -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMarchid
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MImpId -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMimpid
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MHartId -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMhartid
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MPS -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMps
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MNev -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMnev
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MePc0 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMepc0
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MePc1 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMepc1
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MePc2 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMepc2
add wave -noupdate -group CsrRegisters -color {Medium Spring Green} -label MePc3 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/CSR/PrevMepc3
add wave -noupdate -divider Core-AS
add wave -noupdate -color {Slate Blue} -label InstId /coretestprotocol/X1/ArkI2/ArkI/AS/ControlWordIn.InstId
add wave -noupdate -color {Slate Blue} -label AluOperation /coretestprotocol/X1/ArkI2/ArkI/AS/ALU/Operation
add wave -noupdate -color {Slate Blue} -label AluSource /coretestprotocol/X1/ArkI2/ArkI/AS/ALU/Source
add wave -noupdate -color {Slate Blue} -label CmpRes /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.CmpRes
add wave -noupdate -group AluInput -color {Slate Blue} -label GprData1 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.GprData1
add wave -noupdate -group AluInput -color {Slate Blue} -label GprData2 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.GprData2
add wave -noupdate -group AluInput -color {Slate Blue} -label ImmData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.ImmData
add wave -noupdate -group AluInput -color {Slate Blue} -label CsrImmData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.CsrImmData
add wave -noupdate -group AluInput -color {Slate Blue} -label Shamt -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.Shamt
add wave -noupdate -group AluInput -color {Slate Blue} -label Pc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/AS/RegisterData.Pc
add wave -noupdate -divider Core-MS
add wave -noupdate -color Tan -label InstId /coretestprotocol/X1/ArkI2/ArkI/MS/ControlWordIn.InstId
add wave -noupdate -color Tan -label AluResult -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/MS/AluData.AluResult
add wave -noupdate -color Tan -label GprData2 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/MS/AluData.GprData2
add wave -noupdate -divider Core-WBS
add wave -noupdate -color Sienna -label InstId /coretestprotocol/X1/ArkI2/ArkI/WBS/ControlWordIn.InstId
add wave -noupdate -group WriteBackInput -color Sienna -label AluResult -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.AluResult
add wave -noupdate -group WriteBackInput -color Sienna -label MemData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.MemData
add wave -noupdate -group WriteBackInput -color Sienna -label ImmData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.ImmData
add wave -noupdate -group WriteBackInput -color Sienna -label RdAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.RdAddress
add wave -noupdate -group WriteBackInput -color Sienna -label CsrData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.CsrData
add wave -noupdate -group WriteBackInput -color Sienna -label Negative /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.Negative
add wave -noupdate -group WriteBackInput -color Sienna -label PcNext -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/WBS/MemoryData.PcNext
add wave -noupdate -color Sienna -label RegData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/RRS/GPR/RegData
add wave -noupdate -divider Core-Ctrl
add wave -noupdate -color {Medium Orchid} -label PcMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/PcMode
add wave -noupdate -color {Medium Orchid} -label CtrlWord -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/ControlWord
add wave -noupdate -color {Medium Orchid} -label ExcCtrlWord -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/ExcCtrlWord
add wave -noupdate -group OtherCtrlSignals -color {Medium Orchid} -label BranchType /coretestprotocol/X1/ArkI2/ArkI/Ctrl/BranchType
add wave -noupdate -group OtherCtrlSignals -color {Medium Orchid} -label BpuMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/BpuMode
add wave -noupdate -group OtherCtrlSignals -color {Medium Orchid} -label GprAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/GprAddress
add wave -noupdate -group OtherCtrlSignals -color {Medium Orchid} -label DfuMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/DfuMode
add wave -noupdate -group OtherCtrlSignals -color {Medium Orchid} -label PipelineMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/PipelineMode
add wave -noupdate -divider Ctrl-FSM
add wave -noupdate -color {Blue Violet} -label PipelineMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/PipelineMode
add wave -noupdate -color {Blue Violet} -label PrevState /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/PrevState
add wave -noupdate -color {Blue Violet} -label IdleCounter /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/IdleCounter
add wave -noupdate -color {Blue Violet} -label Counter /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/Counter
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label MNEV -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/MNEV
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label Mie -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/Mie
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label Mps -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/Mps
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label PcMode /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/PcMode
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label CycleMePc /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/CycleMePc
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label CsrExcWrEna /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/CsrExcWrEna
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label ExcCsrWrAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/ExcCsrWrAddress
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label ExcCsrData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/ExcCsrData
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label ExcMemRd /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/ExcMemRd
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label AluExcOp /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/AluExcOp
add wave -noupdate -group CtrlFsmSignals -color {Blue Violet} -label ExcPcWrEna /coretestprotocol/X1/ArkI2/ArkI/Ctrl/CtrlFsm/ExcPcWrEna
add wave -noupdate -divider Core-BPU
add wave -noupdate -color {Sea Green} -label NewPc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/BPU/NewPc
add wave -noupdate -color {Sea Green} -label EnaLoad /coretestprotocol/X1/ArkI2/ArkI/BPU/EnaLoad
add wave -noupdate -color {Sea Green} -label ClrPipeline /coretestprotocol/X1/ArkI2/ArkI/BPU/ClrPipeline
add wave -noupdate -color {Sea Green} -label BranchResult /coretestprotocol/X1/ArkI2/ArkI/BPU/BranchResult
add wave -noupdate -color {Sea Green} -label CmpRes /coretestprotocol/X1/ArkI2/ArkI/BPU/CmpRes
add wave -noupdate -color {Sea Green} -label CmpMask /coretestprotocol/X1/ArkI2/ArkI/BPU/CmpMask
add wave -noupdate -color {Sea Green} -label Stall /coretestprotocol/X1/ArkI2/ArkI/BPU/Stall
add wave -noupdate -color {Sea Green} -label BranchFail /coretestprotocol/X1/ArkI2/ArkI/BPU/BranchFail
add wave -noupdate -color {Sea Green} -label State /coretestprotocol/X1/ArkI2/ArkI/BPU/BpuFSM/PrevState
add wave -noupdate -group BpuData0 -color {Sea Green} -label BranchType0 /coretestprotocol/X1/ArkI2/ArkI/BPU/BranchType0
add wave -noupdate -group BpuData0 -color {Sea Green} -label ActiveBranch0 /coretestprotocol/X1/ArkI2/ArkI/BPU/ActiveBranch0
add wave -noupdate -group BpuData0 -color {Sea Green} -label DiscardedPc0 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/BPU/DiscardedPc0
add wave -noupdate -group BpuData1 -color {Sea Green} -label BranchType1 /coretestprotocol/X1/ArkI2/ArkI/BPU/BranchType1
add wave -noupdate -group BpuData1 -color {Sea Green} -label ActiveBranch1 /coretestprotocol/X1/ArkI2/ArkI/BPU/ActiveBranch1
add wave -noupdate -group BpuData1 -color {Sea Green} -label DiscardedPc1 -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/BPU/DiscardedPc1
add wave -noupdate -divider Core-DFU
add wave -noupdate -color Blue -label DfuDataOut -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DFU/DfuDataOut
add wave -noupdate -color Blue -label DisablePipeline /coretestprotocol/X1/ArkI2/ArkI/DFU/DisablePipeline
add wave -noupdate -color Blue -label DataDepenedency /coretestprotocol/X1/ArkI2/ArkI/DFU/DataDependency
add wave -noupdate -divider ProgramCounter
add wave -noupdate -group PcSignals -color Salmon -label ImmData -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/ImmData
add wave -noupdate -group PcSignals -color Salmon -label NewPc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/NewPc
add wave -noupdate -group PcSignals -color Salmon -label MepcRd -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/MepcRd
add wave -noupdate -group PcSignals -color Salmon -label EnaLoad /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/EnaLoad
add wave -noupdate -group PcSignals -color Salmon -label EnaLoadMS /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/EnaLoadMS
add wave -noupdate -group PcSignals -color Salmon -label AluResult -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/AluResult
add wave -noupdate -group PcSignals -color Salmon -label NewExcPc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/NewExcPc
add wave -noupdate -group PcSignals -color Salmon -label PcMode /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/PcMode
add wave -noupdate -group PcSignals -color Salmon -label ExcPcWrEna /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/ExcPcWrEna
add wave -noupdate -color Salmon -label Pc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/Pc
add wave -noupdate -color Salmon -label NextPc -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/NextPc
add wave -noupdate -color Salmon -label PcPlusImm -radix hexadecimal /coretestprotocol/X1/ArkI2/ArkI/DS/PCR/PcPlusImm
TreeUpdate [SetDefaultTree]
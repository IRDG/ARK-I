onerror {resume}
vsim work.s7bputestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label BranchType -radix hexadecimal -childformat {{/s7bputestprotocol/X1/BranchType(3) -radix hexadecimal} {/s7bputestprotocol/X1/BranchType(2) -radix hexadecimal} {/s7bputestprotocol/X1/BranchType(1) -radix hexadecimal} {/s7bputestprotocol/X1/BranchType(0) -radix hexadecimal}} -expand -subitemconfig {/s7bputestprotocol/X1/BranchType(3) {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s7bputestprotocol/X1/BranchType(2) {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s7bputestprotocol/X1/BranchType(1) {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s7bputestprotocol/X1/BranchType(0) {-color {Cornflower Blue} -height 15 -radix hexadecimal}} /s7bputestprotocol/X1/BranchType
add wave -noupdate -color {Cornflower Blue} -label CmpRes -radix hexadecimal /s7bputestprotocol/X1/CmpRes
add wave -noupdate -color {Cornflower Blue} -label PcPlusImm -radix hexadecimal /s7bputestprotocol/X1/PcPlusImm
add wave -noupdate -color {Cornflower Blue} -label Pc -radix hexadecimal /s7bputestprotocol/X1/Pc
add wave -noupdate -color {Cornflower Blue} -label BpuMode -radix hexadecimal /s7bputestprotocol/X1/BpuMode
add wave -noupdate -color {Cornflower Blue} -label CacheMiss -radix hexadecimal /s7bputestprotocol/X1/CacheMiss
add wave -noupdate -color {Cornflower Blue} -label Dependency -radix hexadecimal /s7bputestprotocol/X1/Dependency
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal /s7bputestprotocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal /s7bputestprotocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label NewPc -radix hexadecimal /s7bputestprotocol/X1/NewPc
add wave -noupdate -color Orange -label EnaLoad -radix hexadecimal /s7bputestprotocol/X1/EnaLoad
add wave -noupdate -color Orange -label ClrPipeline -radix hexadecimal /s7bputestprotocol/X1/ClrPipeline
add wave -noupdate -color Orange -label BranchResult -radix hexadecimal /s7bputestprotocol/X1/BranchResult
add wave -noupdate -divider Fsm
add wave -noupdate -color {Medium Orchid} -label BranchResult -radix hexadecimal /s7bputestprotocol/X1/BpuFSM/BranchResult
add wave -noupdate -color {Medium Orchid} -label Enable -radix hexadecimal /s7bputestprotocol/X1/BpuFSM/Enable
add wave -noupdate -color {Medium Orchid} -label Jump -radix hexadecimal /s7bputestprotocol/X1/BpuFSM/Jump
add wave -noupdate -color {Medium Orchid} -label State /s7bputestprotocol/X1/BpuFSM/PrevState
add wave -noupdate -divider Registers
add wave -noupdate -color {Medium Aquamarine} -label BranchType0 -radix hexadecimal /s7bputestprotocol/X1/BranchType0
add wave -noupdate -color {Medium Aquamarine} -label BranchType1 -radix hexadecimal /s7bputestprotocol/X1/BranchType1
add wave -noupdate -color {Medium Aquamarine} -label BranchType2 -radix hexadecimal /s7bputestprotocol/X1/BranchType2
add wave -noupdate -color {Medium Aquamarine} -label DiscardedPc0 -radix hexadecimal /s7bputestprotocol/X1/DiscardedPc0
add wave -noupdate -color {Medium Aquamarine} -label DiscardedPc1 -radix hexadecimal /s7bputestprotocol/X1/DiscardedPc1
add wave -noupdate -color {Medium Aquamarine} -label DiscardedPc2 -radix hexadecimal /s7bputestprotocol/X1/DiscardedPc2
add wave -noupdate -divider {Pipelined Signals}
add wave -noupdate -color Navy -label Predict -radix hexadecimal /s7bputestprotocol/X1/Predict
add wave -noupdate -color Navy -label Correct -radix hexadecimal /s7bputestprotocol/X1/Correct
add wave -noupdate -color Navy -label CmpMask -radix hexadecimal /s7bputestprotocol/X1/CmpMask
add wave -noupdate -color Navy -label Cmp -radix hexadecimal /s7bputestprotocol/X1/Cmp
add wave -noupdate -divider {SingCycle Signals}
add wave -noupdate -color Gray60 -label ImmCmpMask -radix hexadecimal /s7bputestprotocol/X1/ImmCmpMask
add wave -noupdate -color Gray60 -label ImmLoad -radix hexadecimal /s7bputestprotocol/X1/ImmLoad
add wave -noupdate -color Gray60 -label ImmCmp -radix hexadecimal /s7bputestprotocol/X1/ImmCmp
add wave -noupdate -color Gray60 -label ImmNewPc -radix hexadecimal /s7bputestprotocol/X1/ImmNewPc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {649188 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 127
configure wave -valuecolwidth 66
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {408082 ps} {1066321 ps}
run 1460ns
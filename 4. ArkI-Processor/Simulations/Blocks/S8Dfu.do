onerror {resume}
vsim work.s8dfutestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label DfuDataIn -radix hexadecimal -childformat {{/s8dfutestprotocol/X1/DfuDataIn.AluResult -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataIn.ImmData -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataIn.RdAddress -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataIn.CsrData -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataIn.Negative -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataIn.PcNext -radix hexadecimal}} -expand -subitemconfig {/s8dfutestprotocol/X1/DfuDataIn.AluResult {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataIn.ImmData {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataIn.RdAddress {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataIn.CsrData {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataIn.Negative {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataIn.PcNext {-color {Cornflower Blue} -height 15 -radix hexadecimal}} /s8dfutestprotocol/X1/DfuDataIn
add wave -noupdate -color {Cornflower Blue} -label DfuMode -radix hexadecimal /s8dfutestprotocol/X1/DfuMode
add wave -noupdate -color {Cornflower Blue} -label CacheMiss -radix hexadecimal /s8dfutestprotocol/X1/CacheMiss
add wave -noupdate -color {Cornflower Blue} -label GprRsX1 -radix unsigned /s8dfutestprotocol/X1/GprRsX1
add wave -noupdate -color {Cornflower Blue} -label GprRsX2 -radix unsigned /s8dfutestprotocol/X1/GprRsX2
add wave -noupdate -color {Cornflower Blue} -label GprRdX -radix unsigned /s8dfutestprotocol/X1/GprRdX
add wave -noupdate -color {Cornflower Blue} -label Inst -radix hexadecimal /s8dfutestprotocol/X1/Inst
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal /s8dfutestprotocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal /s8dfutestprotocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label DfuDataOut -radix hexadecimal -childformat {{/s8dfutestprotocol/X1/DfuDataOut.DfuWrEna -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataOut.DfuAddress -radix hexadecimal} {/s8dfutestprotocol/X1/DfuDataOut.DfuData -radix hexadecimal}} -expand -subitemconfig {/s8dfutestprotocol/X1/DfuDataOut.DfuWrEna {-color Orange -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataOut.DfuAddress {-color Orange -height 15 -radix hexadecimal} /s8dfutestprotocol/X1/DfuDataOut.DfuData {-color Orange -height 15 -radix hexadecimal}} /s8dfutestprotocol/X1/DfuDataOut
add wave -noupdate -color Orange -label EnaPipeline -radix hexadecimal /s8dfutestprotocol/X1/EnaPipeline
add wave -noupdate -color Orange -label DataDependency -radix hexadecimal /s8dfutestprotocol/X1/DataDependency
add wave -noupdate -divider {Address Registers}
add wave -noupdate -color {Medium Aquamarine} -label PrevRs1 -radix unsigned -childformat {{/s8dfutestprotocol/X1/PrevReg.Rs1(0) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rs1(1) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rs1(2) -radix unsigned}} -expand -subitemconfig {/s8dfutestprotocol/X1/PrevReg.Rs1(0) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rs1(1) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rs1(2) {-color {Medium Aquamarine} -height 15 -radix unsigned}} /s8dfutestprotocol/X1/PrevReg.Rs1
add wave -noupdate -color {Medium Aquamarine} -label PrevRs2 -radix unsigned -childformat {{/s8dfutestprotocol/X1/PrevReg.Rs2(0) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rs2(1) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rs2(2) -radix unsigned}} -expand -subitemconfig {/s8dfutestprotocol/X1/PrevReg.Rs2(0) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rs2(1) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rs2(2) {-color {Medium Aquamarine} -height 15 -radix unsigned}} /s8dfutestprotocol/X1/PrevReg.Rs2
add wave -noupdate -color {Medium Aquamarine} -label PrevRd -radix unsigned -childformat {{/s8dfutestprotocol/X1/PrevReg.Rd(0) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rd(1) -radix unsigned} {/s8dfutestprotocol/X1/PrevReg.Rd(2) -radix unsigned}} -expand -subitemconfig {/s8dfutestprotocol/X1/PrevReg.Rd(0) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rd(1) {-color {Medium Aquamarine} -height 15 -radix unsigned} /s8dfutestprotocol/X1/PrevReg.Rd(2) {-color {Medium Aquamarine} -height 15 -radix unsigned}} /s8dfutestprotocol/X1/PrevReg.Rd
add wave -noupdate -divider Dependency
add wave -noupdate -color Yellow -label Rs1Dependency -radix hexadecimal /s8dfutestprotocol/X1/Rs1Dep
add wave -noupdate -color Yellow -label Rs2Dependency -radix hexadecimal /s8dfutestprotocol/X1/Rs2Dep
add wave -noupdate -color Yellow -label PrevDependency -radix hexadecimal /s8dfutestprotocol/X1/PrevDependency
add wave -noupdate -color Yellow -label NextDependency -radix hexadecimal /s8dfutestprotocol/X1/NextDependency
add wave -noupdate -color Yellow -label DfuActive -radix hexadecimal /s8dfutestprotocol/X1/DfuActive
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {280000 ps} 0} {{Cursor 2} {420000 ps} 0} {{Cursor 3} {570000 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 155
configure wave -valuecolwidth 82
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
WaveRestoreZoom {201 ns} {621 ns}
run 600ns
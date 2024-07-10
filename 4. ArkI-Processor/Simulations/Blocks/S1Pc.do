onerror {resume}
vsim work.S1PcTestProtocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label ImmData -radix hexadecimal /S1PcTestProtocol/X1/ImmData
add wave -noupdate -color {Cornflower Blue} -label NewPc -radix hexadecimal /S1PcTestProtocol/X1/NewPc
add wave -noupdate -color {Cornflower Blue} -label MePcRd -radix hexadecimal /S1PcTestProtocol/X1/MePcRd
add wave -noupdate -color {Cornflower Blue} -label EnaLoad -radix hexadecimal /S1PcTestProtocol/X1/EnaLoad
add wave -noupdate -color {Cornflower Blue} -label AluResult -radix hexadecimal /S1PcTestProtocol/X1/AluResult
add wave -noupdate -color {Cornflower Blue} -label NewExcPc -radix hexadecimal /S1PcTestProtocol/X1/NewExcPc
add wave -noupdate -color {Cornflower Blue} -label PcMode -radix hexadecimal /S1PcTestProtocol/X1/PcMode
add wave -noupdate -color {Cornflower Blue} -label ExcPcWrEna -radix hexadecimal /S1PcTestProtocol/X1/ExcPcWrEna
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal /S1PcTestProtocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal /S1PcTestProtocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Pc -radix hexadecimal /S1PcTestProtocol/X1/Pc
add wave -noupdate -color Orange -label NextPc -radix hexadecimal /S1PcTestProtocol/X1/NextPc
add wave -noupdate -color Orange -label PcPlusImm -radix hexadecimal /S1PcTestProtocol/X1/PcPlusImm
add wave -noupdate -divider CounterSignals
add wave -noupdate -color {Medium Orchid} -label PcNextCounter -radix hexadecimal /S1PcTestProtocol/X1/PcNextCounter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {580000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {237406 ps} {757406 ps}
run 720ns
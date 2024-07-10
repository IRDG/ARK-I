onerror {resume}
vsim work.countertestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label Ena /countertestprotocol/X1/Ena
add wave -noupdate -color {Cornflower Blue} -label Up /countertestprotocol/X1/Up
add wave -noupdate -color {Cornflower Blue} -label MR /countertestprotocol/X1/MR
add wave -noupdate -color {Cornflower Blue} -label SR /countertestprotocol/X1/SR
add wave -noupdate -color {Cornflower Blue} -label Clk /countertestprotocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label MaxCount /countertestprotocol/X1/MaxCount
add wave -noupdate -color Orange -label Count -radix hexadecimal /countertestprotocol/X1/Count
add wave -noupdate -divider {Other Signals}
add wave -noupdate -color {Sky Blue} -label TempCount -radix hexadecimal /countertestprotocol/X1/TempCount
add wave -noupdate -color {Sky Blue} -label NextCount -radix hexadecimal /countertestprotocol/X1/NextCount
add wave -noupdate -color {Sky Blue} -label Number -radix hexadecimal /countertestprotocol/X1/Number
add wave -noupdate -color {Sky Blue} -label Sign /countertestprotocol/X1/Sign
add wave -noupdate -color {Sky Blue} -label Overflow /countertestprotocol/X1/Overflow
add wave -noupdate -color {Sky Blue} -label MinCount /countertestprotocol/X1/MinCount
add wave -noupdate -color {Sky Blue} -label LowerLimit /countertestprotocol/X1/LowerLimit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40000 ps} 0}
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
WaveRestoreZoom {0 ps} {525 ns}

run 1000ns
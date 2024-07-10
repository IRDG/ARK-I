onerror {resume}
vsim work.S3ShifterTestProtocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label Input -radix hexadecimal /S3ShifterTestProtocol/X1/Input
add wave -noupdate -color {Cornflower Blue} -label Shamt -radix hexadecimal /S3ShifterTestProtocol/X1/Shamt
add wave -noupdate -color {Cornflower Blue} -label ArithRlN -radix hexadecimal /S3ShifterTestProtocol/X1/ArithRlN
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Output -radix hexadecimal /S3ShifterTestProtocol/X1/Output
add wave -noupdate -divider Internal
add wave -noupdate -color {Medium Orchid} -label SLL -radix hexadecimal /S3ShifterTestProtocol/X1/ShiftLeftLogic
add wave -noupdate -color {Medium Orchid} -label SRL -radix hexadecimal /S3ShifterTestProtocol/X1/ShiftRghtLogic
add wave -noupdate -color {Medium Orchid} -label SRA -radix hexadecimal /S3ShifterTestProtocol/X1/ShiftRghtArith
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 85
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {317260 ps}
run 1960ns
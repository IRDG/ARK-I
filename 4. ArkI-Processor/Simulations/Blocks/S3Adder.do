onerror {resume}
vsim work.S3AdderTestProtocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label NumA -radix hexadecimal /S3AdderTestProtocol/NumA
add wave -noupdate -color {Cornflower Blue} -label NumB -radix hexadecimal /S3AdderTestProtocol/NumB
add wave -noupdate -color {Cornflower Blue} -label CarryIn -radix hexadecimal /S3AdderTestProtocol/CarryIn
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Result -radix hexadecimal /S3AdderTestProtocol/Result
add wave -noupdate -color Orange -label CarryOut -radix hexadecimal /S3AdderTestProtocol/CarryOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 91
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
WaveRestoreZoom {0 ps} {530432 ps}
run 440ns
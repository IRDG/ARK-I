onerror {resume}
vsim work.s3addersubtractortestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label NumA -radix hexadecimal -radixshowbase 0 /s3addersubtractortestprotocol/NumA
add wave -noupdate -color {Cornflower Blue} -label NumB -radix hexadecimal -radixshowbase 0 /s3addersubtractortestprotocol/NumB
add wave -noupdate -color {Cornflower Blue} -label Subtract -radix hexadecimal -radixshowbase 0 /s3addersubtractortestprotocol/Subtract
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Result -radix hexadecimal -radixshowbase 0 /s3addersubtractortestprotocol/Result
add wave -noupdate -color Orange -label Overflow -radix hexadecimal -radixshowbase 0 /s3addersubtractortestprotocol/Overflow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {420000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 130
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {525056 ps}
run 460ns
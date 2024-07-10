onerror {resume}
vsim work.s2comparatortestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label A -radix hexadecimal /s2comparatortestprotocol/A
add wave -noupdate -color {Cornflower Blue} -label B -radix hexadecimal /s2comparatortestprotocol/B
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Comparisson /s2comparatortestprotocol/Comparisson
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 115
configure wave -valuecolwidth 64
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
WaveRestoreZoom {0 ps} {615616 ps}
run 260ns
onerror {resume}
vsim work.s5wbtestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label AluResult -radix hexadecimal /s5wbtestprotocol/AluResult
add wave -noupdate -color {Cornflower Blue} -label MemData -radix hexadecimal /s5wbtestprotocol/MemData
add wave -noupdate -color {Cornflower Blue} -label ImmData -radix hexadecimal /s5wbtestprotocol/ImmData
add wave -noupdate -color {Cornflower Blue} -label CsrData -radix hexadecimal /s5wbtestprotocol/CsrData
add wave -noupdate -color {Cornflower Blue} -label Negative -radix hexadecimal /s5wbtestprotocol/Negative
add wave -noupdate -color {Cornflower Blue} -label PcNext -radix hexadecimal /s5wbtestprotocol/PcNext
add wave -noupdate -color {Cornflower Blue} -label WbDataSrc -radix hexadecimal /s5wbtestprotocol/WbDataSrc
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label WbData -radix hexadecimal /s5wbtestprotocol/WbData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 164
configure wave -valuecolwidth 53
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
WaveRestoreZoom {0 ps} {300912 ps}
run 200ns
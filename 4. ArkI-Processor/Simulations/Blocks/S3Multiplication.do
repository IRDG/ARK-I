onerror {resume}
vsim work.s3multiplicationtestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label A -radix hexadecimal /s3multiplicationtestprotocol/X1/A
add wave -noupdate -color {Cornflower Blue} -label B -radix hexadecimal /s3multiplicationtestprotocol/X1/B
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label ResultL -radix hexadecimal /s3multiplicationtestprotocol/X1/ResultL
add wave -noupdate -color Orange -label ResultH -radix hexadecimal /s3multiplicationtestprotocol/X1/ResultH
add wave -noupdate -color Orange -label Overflow -radix hexadecimal /s3multiplicationtestprotocol/X1/Overflow
add wave -noupdate -divider 1stLayer
add wave -noupdate -color {Dark Orchid} -label PsA0 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(0)
add wave -noupdate -color {Dark Orchid} -label PsA1 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(1)
add wave -noupdate -color {Dark Orchid} -label PsA2 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(2)
add wave -noupdate -color {Dark Orchid} -label PsA3 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(3)
add wave -noupdate -color {Dark Orchid} -label PsA4 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(4)
add wave -noupdate -color {Dark Orchid} -label PsA5 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(5)
add wave -noupdate -color {Dark Orchid} -label PsA6 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(6)
add wave -noupdate -color {Dark Orchid} -label PsA7 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(7)
add wave -noupdate -color {Dark Orchid} -label PsA8 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(8)
add wave -noupdate -color {Dark Orchid} -label PsA9 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(9)
add wave -noupdate -color {Dark Orchid} -label PsA10 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(10)
add wave -noupdate -color {Dark Orchid} -label PsA11 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(11)
add wave -noupdate -color {Dark Orchid} -label PsA12 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(12)
add wave -noupdate -color {Dark Orchid} -label PsA13 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(13)
add wave -noupdate -color {Dark Orchid} -label PsA14 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(14)
add wave -noupdate -color {Dark Orchid} -label PsA15 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsA(15)
add wave -noupdate -divider 2ndLayer
add wave -noupdate -color Yellow -label PsB0 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(0)
add wave -noupdate -color Yellow -label PsB1 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(1)
add wave -noupdate -color Yellow -label PsB2 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(2)
add wave -noupdate -color Yellow -label PsB3 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(3)
add wave -noupdate -color Yellow -label PsB4 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(4)
add wave -noupdate -color Yellow -label PsB5 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(5)
add wave -noupdate -color Yellow -label PsB6 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(6)
add wave -noupdate -color Yellow -label PsB7 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsB(7)
add wave -noupdate -divider 3rdLayer
add wave -noupdate -color Blue -label PsC0 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsC(0)
add wave -noupdate -color Blue -label PsC1 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsC(1)
add wave -noupdate -color Blue -label PsC2 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsC(2)
add wave -noupdate -color Blue -label PsC3 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsC(3)
add wave -noupdate -divider 4thLayer
add wave -noupdate -color Gray55 -label PsD0 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsD(0)
add wave -noupdate -color Gray55 -label PsD1 -radix hexadecimal /s3multiplicationtestprotocol/X1/PsD(1)
add wave -noupdate -divider 5thLayer
add wave -noupdate -color Violet -label PsE -radix hexadecimal /s3multiplicationtestprotocol/X1/PsE(0)
add wave -noupdate -divider 6thLayer
add wave -noupdate -color Aquamarine -label PsF -radix hexadecimal /s3multiplicationtestprotocol/X1/PsF(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 90
configure wave -valuecolwidth 54
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
WaveRestoreZoom {0 ps} {314184 ps}
run 260ns
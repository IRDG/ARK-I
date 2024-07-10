onerror {resume}
vsim work.s2gprtestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label R1Address -radix unsigned -radixshowbase 0 /s2gprtestprotocol/X1/R1Address
add wave -noupdate -color {Cornflower Blue} -label R2Address -radix unsigned -radixshowbase 0 /s2gprtestprotocol/X1/R2Address
add wave -noupdate -color {Cornflower Blue} -label RdAddress -radix unsigned -radixshowbase 0 /s2gprtestprotocol/X1/RdAddress
add wave -noupdate -color {Cornflower Blue} -label WbData -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/WbData
add wave -noupdate -color {Cornflower Blue} -label WrEna -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/WrEna
add wave -noupdate -color {Cornflower Blue} -label DfuAddress -radix unsigned -radixshowbase 0 /s2gprtestprotocol/X1/DfuAddress
add wave -noupdate -color {Cornflower Blue} -label DfuData -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/DfuData
add wave -noupdate -color {Cornflower Blue} -label DfuWrEna -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/DfuWrEna
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label Gprdata1 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/GprData1
add wave -noupdate -color Orange -label GprData2 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/GprData2
add wave -noupdate -divider Registers
add wave -noupdate -color Gray60 -label R00 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(0)
add wave -noupdate -color Gray60 -label R01 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(1)
add wave -noupdate -color Gray60 -label R02 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(2)
add wave -noupdate -color Gray60 -label R03 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(3)
add wave -noupdate -color Gray60 -label R04 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(4)
add wave -noupdate -color Gray60 -label R05 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(5)
add wave -noupdate -color Gray60 -label R06 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(6)
add wave -noupdate -color Gray60 -label R07 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(7)
add wave -noupdate -color Gray60 -label R08 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(8)
add wave -noupdate -color Gray60 -label R09 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(9)
add wave -noupdate -color Gray60 -label R10 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(10)
add wave -noupdate -color Gray60 -label R11 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(11)
add wave -noupdate -color Gray60 -label R12 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(12)
add wave -noupdate -color Gray60 -label R13 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(13)
add wave -noupdate -color Gray60 -label R14 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(14)
add wave -noupdate -color Gray60 -label R15 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(15)
add wave -noupdate -color Gray60 -label R16 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(16)
add wave -noupdate -color Gray60 -label R17 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(17)
add wave -noupdate -color Gray60 -label R18 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(18)
add wave -noupdate -color Gray60 -label R19 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(19)
add wave -noupdate -color Gray60 -label R20 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(20)
add wave -noupdate -color Gray60 -label R21 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(21)
add wave -noupdate -color Gray60 -label R22 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(22)
add wave -noupdate -color Gray60 -label R23 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(23)
add wave -noupdate -color Gray60 -label R24 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(24)
add wave -noupdate -color Gray60 -label R25 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(25)
add wave -noupdate -color Gray60 -label R26 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(26)
add wave -noupdate -color Gray60 -label R27 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(27)
add wave -noupdate -color Gray60 -label R28 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(28)
add wave -noupdate -color Gray60 -label R29 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(29)
add wave -noupdate -color Gray60 -label R30 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(30)
add wave -noupdate -color Gray60 -label R31 -radix hexadecimal -radixshowbase 0 /s2gprtestprotocol/X1/RegData(31)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {260000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 114
configure wave -valuecolwidth 94
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
WaveRestoreZoom {0 ps} {1144832 ps}
run 500ns
onerror {resume}
vsim work.s2csrtestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label RdAddress -radix hexadecimal /s2csrtestprotocol/X1/RdAddress
add wave -noupdate -color {Cornflower Blue} -label MepcWr -radix hexadecimal /s2csrtestprotocol/X1/MepcWr
add wave -noupdate -color {Cornflower Blue} -label WrOperation -radix hexadecimal /s2csrtestprotocol/X1/WrOperation
add wave -noupdate -color {Cornflower Blue} -label ExcWrEna -radix hexadecimal /s2csrtestprotocol/X1/ExcWrEna
add wave -noupdate -color {Cornflower Blue} -label ExcData -radix hexadecimal /s2csrtestprotocol/X1/ExcData
add wave -noupdate -color {Cornflower Blue} -label ExcAddress -radix hexadecimal /s2csrtestprotocol/X1/ExcAddress
add wave -noupdate -color {Cornflower Blue} -label CycleMepc -radix hexadecimal /s2csrtestprotocol/X1/CycleMepc
add wave -noupdate -color {Cornflower Blue} -label WrAddress -radix hexadecimal /s2csrtestprotocol/X1/WrAddress
add wave -noupdate -color {Cornflower Blue} -label GprData -radix hexadecimal /s2csrtestprotocol/X1/GprData
add wave -noupdate -color {Cornflower Blue} -label ImmData -radix hexadecimal /s2csrtestprotocol/X1/ImmData
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal /s2csrtestprotocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal /s2csrtestprotocol/X1/Clk
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label MepcRd -radix hexadecimal /s2csrtestprotocol/X1/MepcRd
add wave -noupdate -color Orange -label Mtvec -radix hexadecimal /s2csrtestprotocol/X1/Mtvec
add wave -noupdate -color Orange -label Mnev -radix hexadecimal /s2csrtestprotocol/X1/Mnev
add wave -noupdate -color Orange -label Mie -radix hexadecimal /s2csrtestprotocol/X1/Mie
add wave -noupdate -color Orange -label Mps -radix hexadecimal /s2csrtestprotocol/X1/Mps
add wave -noupdate -color Orange -label CsrData -radix hexadecimal /s2csrtestprotocol/X1/CsrData
add wave -noupdate -divider Registers
add wave -noupdate -color Gray60 -label Misa -radix hexadecimal /s2csrtestprotocol/X1/PrevMisa
add wave -noupdate -color Gray60 -label Mie -radix hexadecimal /s2csrtestprotocol/X1/PrevMie
add wave -noupdate -color Gray60 -label Mtvec -radix hexadecimal /s2csrtestprotocol/X1/PrevMtvec
add wave -noupdate -color Gray60 -label Mcause -radix hexadecimal /s2csrtestprotocol/X1/PrevMcause
add wave -noupdate -color Gray60 -label Mtval -radix hexadecimal /s2csrtestprotocol/X1/PrevMtval
add wave -noupdate -color Gray60 -label Marchid -radix hexadecimal /s2csrtestprotocol/X1/PrevMarchid
add wave -noupdate -color Gray60 -label Mimpid -radix hexadecimal /s2csrtestprotocol/X1/PrevMimpid
add wave -noupdate -color Gray60 -label Mhartid -radix hexadecimal /s2csrtestprotocol/X1/PrevMhartid
add wave -noupdate -color Gray60 -label Mps -radix hexadecimal /s2csrtestprotocol/X1/PrevMps
add wave -noupdate -color Gray60 -label Mnev -radix hexadecimal /s2csrtestprotocol/X1/PrevMnev
add wave -noupdate -color Gray60 -label Mepc0 -radix hexadecimal /s2csrtestprotocol/X1/PrevMepc0
add wave -noupdate -color Gray60 -label Mepc1 -radix hexadecimal /s2csrtestprotocol/X1/PrevMepc1
add wave -noupdate -color Gray60 -label Mepc2 -radix hexadecimal /s2csrtestprotocol/X1/PrevMepc2
add wave -noupdate -color Gray60 -label Mepc3 -radix hexadecimal /s2csrtestprotocol/X1/PrevMepc3
add wave -noupdate -color Gray60 -label PrevRd -radix hexadecimal /s2csrtestprotocol/X1/PrevRd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {680000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 129
configure wave -valuecolwidth 58
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
WaveRestoreZoom {350813 ps} {963517 ps}
run 1120ns
onerror {resume}
vsim work.s4marmdrtestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label AddressIn -radix hexadecimal /s4marmdrtestprotocol/X1/AddressIn
add wave -noupdate -color {Cornflower Blue} -label DataWr -radix hexadecimal /s4marmdrtestprotocol/X1/DataWr
add wave -noupdate -color {Cornflower Blue} -label ExcVectorTable -radix hexadecimal /s4marmdrtestprotocol/X1/ExcVTable
add wave -noupdate -color {Cornflower Blue} -label ExcMemRd -radix hexadecimal /s4marmdrtestprotocol/X1/ExcMemRd
add wave -noupdate -color {Cornflower Blue} -label MdrOperation -radix hexadecimal /s4marmdrtestprotocol/X1/MdrOperation
add wave -noupdate -divider In/Out
add wave -noupdate -color {Medium Aquamarine} -label BusData -radix hexadecimal /s4marmdrtestprotocol/X1/BusData
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label AddressOut -radix hexadecimal /s4marmdrtestprotocol/X1/AddressOut
add wave -noupdate -color Orange -label RdWrEna -radix hexadecimal /s4marmdrtestprotocol/X1/RdWrEna
add wave -noupdate -color Orange -label DataRd -radix hexadecimal /s4marmdrtestprotocol/X1/DataRd
add wave -noupdate -color Orange -label NewExcPc -radix hexadecimal /s4marmdrtestprotocol/X1/NewExcPc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {300500 ps}
run 300ns
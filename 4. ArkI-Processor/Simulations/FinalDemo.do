do compileWorkspace.do
vsim work.coretestprotocol
do Simulations/AddCoreSignalsDemo.do
do Simulations/AddSecondCoreSignalsDemo.do
WaveRestoreCursors {{Pipeline} {2300 ns} 1 default {Pink}} {{Mode Toggle} {1080 ns} 1 default {Medium Spring Green}} {{Exceptions} {28460 ns} 1 default {Sky Blue}} {{Cursor 4} {17220 ns} 0}
quietly wave cursor active 4
configure wave -namecolwidth 140
configure wave -valuecolwidth 60
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
run 34440ns
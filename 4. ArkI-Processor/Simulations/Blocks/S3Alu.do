onerror {resume}
vsim work.S3AluTestProtocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Control
add wave -noupdate -color Orchid -label Operation /S3AluTestProtocol/Operation
add wave -noupdate -color Orchid -label Source /S3AluTestProtocol/Source
add wave -noupdate -color Orchid -label ExcOp /S3AluTestProtocol/ExcOp
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label CmpRes /S3AluTestProtocol/CmpRes
add wave -noupdate -color {Cornflower Blue} -label Shamt -radix hexadecimal /S3AluTestProtocol/Shamt
add wave -noupdate -color {Cornflower Blue} -label ImmData -radix hexadecimal /S3AluTestProtocol/ImmData
add wave -noupdate -color {Cornflower Blue} -label GprData1 -radix hexadecimal /S3AluTestProtocol/GprData1
add wave -noupdate -color {Cornflower Blue} -label GprData2 -radix hexadecimal /S3AluTestProtocol/GprData2
add wave -noupdate -color {Cornflower Blue} -label Pc -radix hexadecimal /S3AluTestProtocol/Pc
add wave -noupdate -color {Cornflower Blue} -label Mtvec -radix hexadecimal /S3AluTestProtocol/Mtvec
add wave -noupdate -divider Ouput
add wave -noupdate -color Orange -label AluResult -radix hexadecimal /S3AluTestProtocol/AluResult
add wave -noupdate -color Orange -label AluFlags /S3AluTestProtocol/AluFlags
add wave -noupdate -divider Modules
add wave -noupdate -color Gray55 -label AddrResult -radix hexadecimal /S3AluTestProtocol/X1/AddrResult
add wave -noupdate -color Gray55 -label MultResultL -radix hexadecimal /S3AluTestProtocol/X1/MultResultL
add wave -noupdate -color Gray55 -label MultResultH -radix hexadecimal /S3AluTestProtocol/X1/MultResultH
add wave -noupdate -color Gray55 -label DivResultQuo -radix hexadecimal /S3AluTestProtocol/X1/DivResultQuo
add wave -noupdate -color Gray55 -label DivResultRem -radix hexadecimal /S3AluTestProtocol/X1/DivResultRem
add wave -noupdate -color Gray55 -label ShftResult -radix hexadecimal /S3AluTestProtocol/X1/ShftResult
add wave -noupdate -color Gray55 -label AndResult -radix hexadecimal /S3AluTestProtocol/X1/AndResult
add wave -noupdate -color Gray55 -label XorResult -radix hexadecimal /S3AluTestProtocol/X1/XorResult
add wave -noupdate -color Gray55 -label OrResult -radix hexadecimal /S3AluTestProtocol/X1/OrResult
add wave -noupdate -divider RealInput
add wave -noupdate -color {Medium Aquamarine} -label RealA -radix hexadecimal /S3AluTestProtocol/X1/RealA
add wave -noupdate -color {Medium Aquamarine} -label RealB -radix hexadecimal /S3AluTestProtocol/X1/RealB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {131250 ps}
run 1320ns
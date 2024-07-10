quietly WaveActivateNextPane
add wave -noupdate -divider Arcu
add wave -noupdate -color {Dark Slate Blue} -label ReplaceAddress -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/Arcu/ReplaceAddress
add wave -noupdate -color {Dark Slate Blue} -label MemoryRdWrEna /coretestprotocol/X1/ArkI1/Cache/Arcu/MemoryRdWrEna
add wave -noupdate -color {Dark Slate Blue} -label ReplaceEnaInstWr /coretestprotocol/X1/ArkI1/Cache/Arcu/ReplaceEnaInstWr
add wave -noupdate -color {Dark Slate Blue} -label ReplaceEnaDataWr /coretestprotocol/X1/ArkI1/Cache/Arcu/ReplaceEnaDataWr
add wave -noupdate -color {Dark Slate Blue} -label ReplaceEnaDataRd /coretestprotocol/X1/ArkI1/Cache/Arcu/ReplaceEnaDataRd
add wave -noupdate -color {Dark Slate Blue} -label PrevSliceAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/Arcu/PrevSliceAddress
add wave -noupdate -color {Dark Slate Blue} -label PrevSliceValid /coretestprotocol/X1/ArkI2/Cache/Arcu/PrevSliceValid
add wave -noupdate -color {Dark Slate Blue} -label MemoryAddress -radix hexadecimal /coretestprotocol/X1/ArkI2/Cache/Arcu/MemoryAddress
add wave -noupdate -color {Dark Slate Blue} -label FieldCount -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/Arcu/FieldCount
add wave -noupdate -color {Dark Slate Blue} -label MaxFields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/Arcu/MaxFields
add wave -noupdate -color {Dark Slate Blue} -label MaxDelayCount /coretestprotocol/X1/ArkI1/Cache/Arcu/MaxDelayCount
add wave -noupdate -color {Dark Slate Blue} -label State /coretestprotocol/X1/ArkI1/Cache/Arcu/PrevState
add wave -noupdate -divider InstCache
add wave -noupdate -color Aquamarine -label RdAddress -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/RdAddress
add wave -noupdate -color Aquamarine -label ReplaceData -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/ReplaceData
add wave -noupdate -color Aquamarine -label ReplaceAddress -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/ReplaceAddress
add wave -noupdate -color Aquamarine -label InstMiss /coretestprotocol/X1/ArkI1/Cache/InsCache/Miss
add wave -noupdate -color Aquamarine -label RatingArray -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/RatingArray
add wave -noupdate -color Aquamarine -label MissVector -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/MissVector
add wave -noupdate -color Aquamarine -label ReplaceEnableWr -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/ReplaceEnaWr
add wave -noupdate -divider InstSlices
add wave -noupdate -group SliceI00 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(0)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI00 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(0)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI00 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(0)/SliceN/UsageRating
add wave -noupdate -group SliceI00 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(0)/SliceN/PrevFields
add wave -noupdate -group SliceI01 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(1)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI01 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(1)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI01 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(1)/SliceN/UsageRating
add wave -noupdate -group SliceI01 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(1)/SliceN/PrevFields
add wave -noupdate -group SliceI02 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(2)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI02 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(2)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI02 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(2)/SliceN/UsageRating
add wave -noupdate -group SliceI02 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(2)/SliceN/PrevFields
add wave -noupdate -group SliceI03 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(3)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI03 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(3)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI03 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(3)/SliceN/UsageRating
add wave -noupdate -group SliceI03 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(3)/SliceN/PrevFields
add wave -noupdate -group SliceI04 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(4)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI04 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(4)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI04 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(4)/SliceN/UsageRating
add wave -noupdate -group SliceI04 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(4)/SliceN/PrevFields
add wave -noupdate -group SliceI05 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(5)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI05 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(5)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI05 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(5)/SliceN/UsageRating
add wave -noupdate -group SliceI05 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(5)/SliceN/PrevFields
add wave -noupdate -group SliceI06 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(6)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI06 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(6)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI06 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(6)/SliceN/UsageRating
add wave -noupdate -group SliceI06 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(6)/SliceN/PrevFields
add wave -noupdate -group SliceI07 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(7)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI07 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(7)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI07 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(7)/SliceN/UsageRating
add wave -noupdate -group SliceI07 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(7)/SliceN/PrevFields
add wave -noupdate -group SliceI08 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(8)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI08 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(8)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI08 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(8)/SliceN/UsageRating
add wave -noupdate -group SliceI08 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(8)/SliceN/PrevFields
add wave -noupdate -group SliceI09 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(9)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI09 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(9)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI09 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(9)/SliceN/UsageRating
add wave -noupdate -group SliceI09 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(9)/SliceN/PrevFields
add wave -noupdate -group SliceI10 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(10)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI10 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(10)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI10 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(10)/SliceN/UsageRating
add wave -noupdate -group SliceI10 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(10)/SliceN/PrevFields
add wave -noupdate -group SliceI11 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(11)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI11 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(11)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI11 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(11)/SliceN/UsageRating
add wave -noupdate -group SliceI11 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(11)/SliceN/PrevFields
add wave -noupdate -group SliceI12 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(12)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI12 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(12)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI12 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(12)/SliceN/UsageRating
add wave -noupdate -group SliceI12 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(12)/SliceN/PrevFields
add wave -noupdate -group SliceI13 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(13)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI13 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(13)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI13 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(13)/SliceN/UsageRating
add wave -noupdate -group SliceI13 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(13)/SliceN/PrevFields
add wave -noupdate -group SliceI14 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(14)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI14 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(14)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI14 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(14)/SliceN/UsageRating
add wave -noupdate -group SliceI14 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(14)/SliceN/PrevFields
add wave -noupdate -group SliceI15 -color Magenta -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(15)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceI15 -color Magenta -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(15)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceI15 -color Magenta -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(15)/SliceN/UsageRating
add wave -noupdate -group SliceI15 -color Magenta -label Fields -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/InsCache/SliceGenerate(15)/SliceN/PrevFields
add wave -noupdate -divider DataCache
add wave -noupdate -color {Sky Blue} -label RdWrAddress -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/RdWrAddress
add wave -noupdate -color {Sky Blue} -label WrData -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/WrData
add wave -noupdate -color {Sky Blue} -label RdWrEnable /coretestprotocol/X1/ArkI1/Cache/DatCache/RdWrEnable
add wave -noupdate -color {Sky Blue} -label ReplaceData -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/ReplaceData
add wave -noupdate -color {Sky Blue} -label ReplaceAddress -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/ReplaceAddress
add wave -noupdate -color {Sky Blue} -label Miss /coretestprotocol/X1/ArkI1/Cache/DatCache/Miss
add wave -noupdate -color {Sky Blue} -label MissVector -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/MissVector
add wave -noupdate -color {Sky Blue} -label ReplaceEnaWr -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/ReplaceEnaWr
add wave -noupdate -divider DataSlices
add wave -noupdate -group SliceD00 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(0)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD00 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(0)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD00 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(0)/SliceN/WrEnable
add wave -noupdate -group SliceD00 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(0)/SliceN/UsageRating
add wave -noupdate -group SliceD00 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(0)/SliceN/PrevFields
add wave -noupdate -group SliceD01 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(1)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD01 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(1)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD01 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(1)/SliceN/WrEnable
add wave -noupdate -group SliceD01 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(1)/SliceN/UsageRating
add wave -noupdate -group SliceD01 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(1)/SliceN/PrevFields
add wave -noupdate -group SliceD02 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(2)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD02 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(2)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD02 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(2)/SliceN/WrEnable
add wave -noupdate -group SliceD02 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(2)/SliceN/UsageRating
add wave -noupdate -group SliceD02 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(2)/SliceN/PrevFields
add wave -noupdate -group SliceD03 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(3)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD03 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(3)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD03 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(3)/SliceN/WrEnable
add wave -noupdate -group SliceD03 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(3)/SliceN/UsageRating
add wave -noupdate -group SliceD03 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(3)/SliceN/PrevFields
add wave -noupdate -group SliceD04 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(4)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD04 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(4)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD04 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(4)/SliceN/WrEnable
add wave -noupdate -group SliceD04 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(4)/SliceN/UsageRating
add wave -noupdate -group SliceD04 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(4)/SliceN/PrevFields
add wave -noupdate -group SliceD05 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(5)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD05 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(5)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD05 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(5)/SliceN/WrEnable
add wave -noupdate -group SliceD05 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(5)/SliceN/UsageRating
add wave -noupdate -group SliceD05 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(5)/SliceN/PrevFields
add wave -noupdate -group SliceD06 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(6)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD06 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(6)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD06 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(6)/SliceN/WrEnable
add wave -noupdate -group SliceD06 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(6)/SliceN/UsageRating
add wave -noupdate -group SliceD06 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(6)/SliceN/PrevFields
add wave -noupdate -group SliceD07 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(7)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD07 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(7)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD07 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(7)/SliceN/WrEnable
add wave -noupdate -group SliceD07 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(7)/SliceN/UsageRating
add wave -noupdate -group SliceD07 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(7)/SliceN/PrevFields
add wave -noupdate -group SliceD08 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(8)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD08 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(8)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD08 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(8)/SliceN/WrEnable
add wave -noupdate -group SliceD08 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(8)/SliceN/UsageRating
add wave -noupdate -group SliceD08 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(8)/SliceN/PrevFields
add wave -noupdate -group SliceD09 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(9)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD09 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(9)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD09 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(9)/SliceN/WrEnable
add wave -noupdate -group SliceD09 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(9)/SliceN/UsageRating
add wave -noupdate -group SliceD09 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(9)/SliceN/PrevFields
add wave -noupdate -group SliceD10 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(10)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD10 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(10)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD10 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(10)/SliceN/WrEnable
add wave -noupdate -group SliceD10 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(10)/SliceN/UsageRating
add wave -noupdate -group SliceD10 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(10)/SliceN/PrevFields
add wave -noupdate -group SliceD11 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(11)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD11 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(11)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD11 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(11)/SliceN/WrEnable
add wave -noupdate -group SliceD11 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(11)/SliceN/UsageRating
add wave -noupdate -group SliceD11 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(11)/SliceN/PrevFields
add wave -noupdate -group SliceD12 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(12)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD12 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(12)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD12 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(12)/SliceN/WrEnable
add wave -noupdate -group SliceD12 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(12)/SliceN/UsageRating
add wave -noupdate -group SliceD12 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(12)/SliceN/PrevFields
add wave -noupdate -group SliceD13 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(13)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD13 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(13)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD13 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(13)/SliceN/WrEnable
add wave -noupdate -group SliceD13 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(13)/SliceN/UsageRating
add wave -noupdate -group SliceD13 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(13)/SliceN/PrevFields
add wave -noupdate -group SliceD14 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(14)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD14 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(14)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD14 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(14)/SliceN/WrEnable
add wave -noupdate -group SliceD14 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(14)/SliceN/UsageRating
add wave -noupdate -group SliceD14 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(14)/SliceN/PrevFields
add wave -noupdate -group SliceD15 -color {Slate Blue} -label {Address Start} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(15)/SliceN/AddressMem/PrevAddress
add wave -noupdate -group SliceD15 -color {Slate Blue} -label {Address Final} -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(15)/SliceN/AddressMem/FinalAddress
add wave -noupdate -group SliceD15 -color {Slate Blue} -label WrEnable /coretestprotocol/X1/ArkI2/Cache/DatCache/SliceGenerate(15)/SliceN/WrEnable
add wave -noupdate -group SliceD15 -color {Slate Blue} -label UsageRating -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(15)/SliceN/UsageRating
add wave -noupdate -group SliceD15 -color {Slate Blue} -label Fields0 -radix hexadecimal /coretestprotocol/X1/ArkI1/Cache/DatCache/SliceGenerate(15)/SliceN/PrevFields
TreeUpdate [SetDefaultTree]
onerror {resume}
vsim work.s9pipelineregistertestprotocol
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -color {Cornflower Blue} -label DataIn -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DataIn.ImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataIn.RdAddress -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataIn.Rs1Address -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataIn.Rs2Address -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataIn.PcNext -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataIn.Pc -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/DataIn.ImmData {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataIn.RdAddress {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataIn.Rs1Address {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataIn.Rs2Address {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataIn.PcNext {-color {Cornflower Blue} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataIn.Pc {-color {Cornflower Blue} -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/DataIn
add wave -noupdate -color {Cornflower Blue} -label CtrlIn -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.CsrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/ControlWordIn.MStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.MStage.MdrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.GprWrEna -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/ControlWordIn.InstId -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage {-color {Cornflower Blue} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.CsrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluOperation {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.AluSource {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.AluStage.CsrOperation {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.MStage {-color {Cornflower Blue} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.MStage.MdrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/ControlWordIn.MStage.MdrOperation {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage {-color {Cornflower Blue} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.GprWrEna -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.WbDataSrc {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.WbStage.GprWrEna {-color {Cornflower Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordIn.InstId {-color {Cornflower Blue} -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/ControlWordIn
add wave -noupdate -color {Cornflower Blue} -label PipelineMode -radix hexadecimal /s9pipelineregistertestprotocol/X1/PipelineMode
add wave -noupdate -color {Cornflower Blue} -label Rst -radix hexadecimal /s9pipelineregistertestprotocol/X1/Rst
add wave -noupdate -color {Cornflower Blue} -label Clk -radix hexadecimal /s9pipelineregistertestprotocol/X1/Clk
add wave -noupdate -divider {DecodeStage Output}
add wave -noupdate -color {Medium Orchid} -label DecodeData -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeDataOut.ImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeDataOut.RdAddress -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeDataOut.Rs1Address -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeDataOut.Rs2Address -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeDataOut.PcNext -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeDataOut.Pc -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/DecodeDataOut.ImmData {-color {Medium Orchid} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeDataOut.RdAddress {-color {Medium Orchid} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeDataOut.Rs1Address {-color {Medium Orchid} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeDataOut.Rs2Address {-color {Medium Orchid} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeDataOut.PcNext {-color {Medium Orchid} -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeDataOut.Pc {-color {Medium Orchid} -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/DecodeDataOut
add wave -noupdate -color {Medium Orchid} -label DecodeCtrl -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.CsrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.MStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.MStage.MdrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.GprWrEna -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.InstId -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage {-color {Medium Orchid} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.CsrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluOperation {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.AluSource {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.AluStage.CsrOperation {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.MStage {-color {Medium Orchid} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.MStage.MdrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.MStage.MdrOperation {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage {-color {Medium Orchid} -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.GprWrEna -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.WbDataSrc {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.WbStage.GprWrEna {-color {Medium Orchid} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut.InstId {-color {Medium Orchid} -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/DecodeCtrlOut
add wave -noupdate -divider {RegisterStage Output}
add wave -noupdate -color {Medium Aquamarine} -label RegData -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegDataOut.CmpRes -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.GprData1 -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.GprData2 -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.ImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.RdAddress -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.CsrImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.Shamt -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.PcNext -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.Pc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegDataOut.CsrData -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/RegDataOut.CmpRes {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.GprData1 {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.GprData2 {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.ImmData {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.RdAddress {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.CsrImmData {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.Shamt {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.PcNext {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.Pc {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegDataOut.CsrData {-color {Medium Aquamarine} -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/RegDataOut
add wave -noupdate -color {Medium Aquamarine} -label RegCtrl -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.CsrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.MStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.MStage.MdrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.GprWrEna -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.InstId -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage {-color {Medium Aquamarine} -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluOperation -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluSource -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.CsrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluOperation {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.AluSource {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.AluStage.CsrOperation {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.MStage {-color {Medium Aquamarine} -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.MStage.MdrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/RegCtrlOut.MStage.MdrOperation {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage {-color {Medium Aquamarine} -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.GprWrEna -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.WbDataSrc {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.WbStage.GprWrEna {-color {Medium Aquamarine} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/RegCtrlOut.InstId {-color {Medium Aquamarine} -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/RegCtrlOut
add wave -noupdate -divider AluStage
add wave -noupdate -color {Dark Slate Blue} -label AluData -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluDataOut.AluResult -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.GprData2 -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.ImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.RdAddress -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.CsrData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.Negative -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluDataOut.PcNext -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/AluDataOut.AluResult {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.GprData2 {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.ImmData {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.RdAddress {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.CsrData {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.Negative {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluDataOut.PcNext {-color {Dark Slate Blue} -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/AluDataOut
add wave -noupdate -color {Dark Slate Blue} -label AluCtrl -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluCtrlOut.MStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluCtrlOut.MStage.MdrOperation -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.GprWrEna -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/AluCtrlOut.InstId -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/AluCtrlOut.MStage {-color {Dark Slate Blue} -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluCtrlOut.MStage.MdrOperation -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/AluCtrlOut.MStage.MdrOperation {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage {-color {Dark Slate Blue} -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.GprWrEna -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.WbDataSrc {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluCtrlOut.WbStage.GprWrEna {-color {Dark Slate Blue} -radix hexadecimal} /s9pipelineregistertestprotocol/X1/AluCtrlOut.InstId {-color {Dark Slate Blue} -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/AluCtrlOut
add wave -noupdate -divider Output
add wave -noupdate -color Orange -label DataOut -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/DataOut.AluResult -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.MemData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.ImmData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.RdAddress -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.CsrData -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.Negative -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/DataOut.PcNext -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/DataOut.AluResult {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.MemData {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.ImmData {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.RdAddress {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.CsrData {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.Negative {-color Orange -height 15 -radix hexadecimal} /s9pipelineregistertestprotocol/X1/DataOut.PcNext {-color Orange -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/DataOut
add wave -noupdate -color Orange -label CtrlOut -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.GprWrEna -radix hexadecimal}}} {/s9pipelineregistertestprotocol/X1/ControlWordOut.InstId -radix hexadecimal}} -expand -subitemconfig {/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage {-color Orange -height 15 -radix hexadecimal -childformat {{/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.WbDataSrc -radix hexadecimal} {/s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.GprWrEna -radix hexadecimal}} -expand} /s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.WbDataSrc {-color Orange -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordOut.WbStage.GprWrEna {-color Orange -radix hexadecimal} /s9pipelineregistertestprotocol/X1/ControlWordOut.InstId {-color Orange -height 15 -radix hexadecimal}} /s9pipelineregistertestprotocol/X1/ControlWordOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26541 ps} 0}
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
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {525 ns}
run 640ns
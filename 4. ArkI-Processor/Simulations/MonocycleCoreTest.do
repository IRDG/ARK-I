do compileWorkspace.do
add wave -noupdate -color Gray60 -label Core1Id /coretestprotocol/X1/ArkI1/CoreId
vsim work.coretestprotocol
do Simulations/AddCoreSignals.do
do Simulations/AddSecondCoreSignals.do
do Simulations/AddFinalConfigurations.do
run 27760ns
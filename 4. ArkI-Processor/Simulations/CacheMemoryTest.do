do compileWorkspace.do
vsim work.coretestprotocol
do Simulations/AddCoreSignals.do
do Simulations/AddCacheSignals.do
do Simulations/AddFinalConfigurations.do
run 27760ns
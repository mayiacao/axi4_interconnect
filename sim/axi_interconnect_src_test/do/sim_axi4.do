file copy -force i:/sim_lib/MODELSIM10_5/vivado22_2/modelsim.ini ./modelsim.ini 

vlib work
vmap work work


vlog -incr -work work "../../../src/*.v"  
vlog -incr -work work "../tb/*.v"  
vlog -sv -incr -work work "../tb/axi4_mdl/*.sv"  
vlog -incr -work work "../../../ip/AXI4_BRAM/AXI4_BRAM_sim_netlist.v" 
vlog -incr -work work "../../../ip/AXI_BRAM1/AXI_BRAM1_sim_netlist.v" 

vsim \
-novopt \
-L secureip \
-L unisims_ver \
-L unimacro_ver \
-L unifast_ver \
-L simprims_ver \
-L xpm \
glbl axi_interconnect_tb

add log -r /*

do wave.do

run 5us

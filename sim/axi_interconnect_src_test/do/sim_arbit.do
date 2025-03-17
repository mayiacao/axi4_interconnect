vlib work
vmap work work

vlog -incr -work work "../../../src/axi_interconnect_crossbar_arbit_polling.v"  
vlog -incr -work work "../tb/arbit_tb.v"  

vsim \
-voptargs="+acc" \
work.axi_interconnect_tb

add log -r /*
do wave.do
run 5us

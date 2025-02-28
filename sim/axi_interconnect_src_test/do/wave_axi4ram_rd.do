onerror {resume}
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/s_wdata_info[42:0]} u0
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/s_wdata_info[85:43]} u1
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split/addr_info[36:5]} addr
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split/m_wdata_info[171:129]} wdata
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split/m_wdata_info[42:0]} wdata3
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split/m_addr_info[66:0]} waddr3
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_mreq_split/m_addr_info[267:201]} waddr1
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_sreq_arbit { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_sreq_arbit/s_addr_info[66:0]} waddr0
quietly virtual signal -install /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_sreq_arbit { /axi_interconnect_tb/u0_axi_interconnect_crossbar/u0_axi_interconnect_crossbar_switch/u_axi_interconnect_crossbar_sreq_arbit/s_addr_info[133:67]} waddr1
quietly WaveActivateNextPane {} 0
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_araddr}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arburst}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arlen}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arsize}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_arvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rdata}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rresp}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rlast}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[3]/U0_AXI4_BRAM/s_axi_rvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_araddr}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arburst}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arlen}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arsize}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_arvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rdata}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rresp}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rlast}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[2]/U0_AXI4_BRAM/s_axi_rvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_araddr}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arburst}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arlen}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arsize}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_arvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rdata}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rresp}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rlast}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[1]/U0_AXI4_BRAM/s_axi_rvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_araddr}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arburst}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arlen}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arsize}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_arvalid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rdata}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rid}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rresp}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rlast}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rready}
add wave -noupdate {/axi_interconnect_tb/ram_loop[0]/U0_AXI4_BRAM/s_axi_rvalid}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {677385 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 177
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {4647308 ps}

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
add wave -noupdate /axi_interconnect_tb/axi4_s0_awid
add wave -noupdate /axi_interconnect_tb/axi4_s0_awaddr
add wave -noupdate /axi_interconnect_tb/axi4_s0_awburst
add wave -noupdate /axi_interconnect_tb/axi4_s0_awlen
add wave -noupdate /axi_interconnect_tb/axi4_s0_awsize
add wave -noupdate /axi_interconnect_tb/axi4_s0_awready
add wave -noupdate /axi_interconnect_tb/axi4_s0_awvalid
add wave -noupdate /axi_interconnect_tb/axi4_s0_wdata
add wave -noupdate /axi_interconnect_tb/axi4_s0_wstrb
add wave -noupdate /axi_interconnect_tb/axi4_s0_wlast
add wave -noupdate /axi_interconnect_tb/axi4_s0_wvalid
add wave -noupdate /axi_interconnect_tb/axi4_s0_wready
add wave -noupdate /axi_interconnect_tb/axi4_s0_bresp
add wave -noupdate /axi_interconnect_tb/axi4_s0_bready
add wave -noupdate /axi_interconnect_tb/axi4_s0_bvalid
add wave -noupdate /axi_interconnect_tb/axi4_s1_awid
add wave -noupdate /axi_interconnect_tb/axi4_s1_awaddr
add wave -noupdate /axi_interconnect_tb/axi4_s1_awburst
add wave -noupdate /axi_interconnect_tb/axi4_s1_awlen
add wave -noupdate /axi_interconnect_tb/axi4_s1_awsize
add wave -noupdate /axi_interconnect_tb/axi4_s1_awready
add wave -noupdate /axi_interconnect_tb/axi4_s1_awvalid
add wave -noupdate /axi_interconnect_tb/axi4_s1_wdata
add wave -noupdate /axi_interconnect_tb/axi4_s1_wstrb
add wave -noupdate /axi_interconnect_tb/axi4_s1_wlast
add wave -noupdate /axi_interconnect_tb/axi4_s1_wvalid
add wave -noupdate /axi_interconnect_tb/axi4_s1_wready
add wave -noupdate /axi_interconnect_tb/axi4_s1_bresp
add wave -noupdate /axi_interconnect_tb/axi4_s1_bready
add wave -noupdate /axi_interconnect_tb/axi4_s1_bvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {481800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {4154386 ps}

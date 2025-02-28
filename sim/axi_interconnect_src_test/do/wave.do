onerror {resume}
quietly virtual signal -install /axi_interconnect_tb { /axi_interconnect_tb/axi4_s0_rdata[63:0]} rdata
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_interconnect_tb/axi4_s0_araddr
add wave -noupdate /axi_interconnect_tb/axi4_s0_arburst
add wave -noupdate /axi_interconnect_tb/axi4_s0_arid
add wave -noupdate /axi_interconnect_tb/axi4_s0_arlen
add wave -noupdate /axi_interconnect_tb/axi4_s0_arready
add wave -noupdate /axi_interconnect_tb/axi4_s0_arsize
add wave -noupdate /axi_interconnect_tb/axi4_s0_arvalid
add wave -noupdate /axi_interconnect_tb/rdata
add wave -noupdate /axi_interconnect_tb/axi4_s0_rid
add wave -noupdate /axi_interconnect_tb/axi4_s0_rlast
add wave -noupdate /axi_interconnect_tb/axi4_s0_rready
add wave -noupdate /axi_interconnect_tb/axi4_s0_rresp
add wave -noupdate /axi_interconnect_tb/axi4_s0_rvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43416000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 137
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
WaveRestoreZoom {43127747 ps} {43737621 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/user_req
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/last_user
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/current_user
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/last_user_temp
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/user_base
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/double_req
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/double_gnt
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/gnt
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/cuer_tmp0
add wave -noupdate /axi_interconnect_tb/u_axi_interconnect_crossbar_arbit_polling/cuer_tmp1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1285683 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 148
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
WaveRestoreZoom {1158536 ps} {1326890 ps}

############################################################################
# Source Clock
############################################################################
create_clock -period 25.000 -name clk_sys_40m [get_ports clk_sys_p]
create_clock -period 10.000 -name sys_clk [get_ports pcie_clk_p]
############################################################################
# CDC
############################################################################

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins u0_xdma_wraper/xdma_0/inst/pcie3_ip_i/inst/xdma_wraper_xdma_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins u_clk_wraper/xcus_if.u0_MMCME3_ADV/CLKOUT4]] 4.0
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins u0_xdma_wraper/xdma_0/inst/pcie3_ip_i/inst/xdma_wraper_xdma_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins u_clk_wraper/xcus_if.u0_MMCME3_ADV/CLKOUT1]] 4.0



set_clock_groups -name async20 -asynchronous -group [get_clocks sys_clk] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gthe3_channel_inst[*].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -name async21 -asynchronous -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gthe3_channel_inst[*].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks sys_clk]
#set_false_path -through [get_pins xdma_0_i/inst/pcie3_ip_i/inst/xdma_0_pcie3_ip_pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst/CFGMAX*]
#set_false_path -through [get_nets xdma_0_i/inst/cfg_max*]


set_false_path -from [get_ports pcie_rst_n]






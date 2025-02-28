#########################################################################################################################
# SYSTEM CLOCK
#########################################################################################################################
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DATA_RATE DDR} [get_ports clk_sys_p]
#########################################################################################################################
# PCIE
#########################################################################################################################
set_property -dict {PACKAGE_PIN P6} [get_ports pcie_clk_p]

set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS25 DATA_RATE SDR} [get_ports pcie_rst_n]

set_property -dict {PACKAGE_PIN N4} [get_ports {pcie_tx_p[0]}]
set_property -dict {PACKAGE_PIN L4} [get_ports {pcie_tx_p[1]}]
set_property -dict {PACKAGE_PIN J4} [get_ports {pcie_tx_p[2]}]
set_property -dict {PACKAGE_PIN G4} [get_ports {pcie_tx_p[3]}]
set_property -dict {PACKAGE_PIN F6} [get_ports {pcie_tx_p[4]}]
set_property -dict {PACKAGE_PIN D6} [get_ports {pcie_tx_p[5]}]
set_property -dict {PACKAGE_PIN C4} [get_ports {pcie_tx_p[6]}]
set_property -dict {PACKAGE_PIN B6} [get_ports {pcie_tx_p[7]}]

set_property -dict {PACKAGE_PIN M2} [get_ports {pcie_rx_p[0]}]
set_property -dict {PACKAGE_PIN K2} [get_ports {pcie_rx_p[1]}]
set_property -dict {PACKAGE_PIN H2} [get_ports {pcie_rx_p[2]}]
set_property -dict {PACKAGE_PIN F2} [get_ports {pcie_rx_p[3]}]
set_property -dict {PACKAGE_PIN E4} [get_ports {pcie_rx_p[4]}]
set_property -dict {PACKAGE_PIN D2} [get_ports {pcie_rx_p[5]}]
set_property -dict {PACKAGE_PIN B2} [get_ports {pcie_rx_p[6]}]
set_property -dict {PACKAGE_PIN A4} [get_ports {pcie_rx_p[7]}]



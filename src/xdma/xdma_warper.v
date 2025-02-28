// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2024/09/04 09:42:11
// File Name    : xdma_warper.v
// Module Ver   : Vx.x
//
//
// All Rights Reserved
//
// ---------------------------------------------------------------------------------/
//
// Modification History:
// V1.0         initial
//
// -FHDR============================================================================/
// 
// xdma_warper
//    |---
// 
`timescale 1ns/1ps

module xdma_warper #
(
    parameter                           FPGA_DEV = "XCUS"           ,   
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// Pcie
// ---------------------------------------------------------------------------------
    input                               pcie_clk_p                  , 
    input                               pcie_clk_n                  , 
    input                               pcie_rst_n                  , 
    output                              pcie_rsto_n                 , 

    output                        [7:0] pci_exp_txp                 , 
    output                        [7:0] pci_exp_txn                 , 
    input                         [7:0] pci_exp_rxp                 , 
    input                         [7:0] pci_exp_rxn                 , 
// ---------------------------------------------------------------------------------
// Irq
// ---------------------------------------------------------------------------------
    input                               usr_irq_req                 , 
    output                              usr_irq_ack                 , 
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    output                              axi_aclk                    , 
    input                               axi4_m0_aclk                , 
    input                               axi4_m0_arstn               , 

    output                       [63:0] axi4_m0_awaddr              , 
    output                        [1:0] axi4_m0_awburst             , 
    output                        [3:0] axi4_m0_awcache             , 
    output                        [3:0] axi4_m0_awid                , 
    output                        [7:0] axi4_m0_awlen               , 
    output                        [0:0] axi4_m0_awlock              , 
    output                        [2:0] axi4_m0_awprot              , 
    output                        [3:0] axi4_m0_awqos               , 
    input                         [0:0] axi4_m0_awready             , 
    output                        [2:0] axi4_m0_awsize              , 
    output                        [0:0] axi4_m0_awvalid             , 
                                                                      
    output                      [127:0] axi4_m0_wdata               , 
    output                        [0:0] axi4_m0_wlast               , 
    input                         [0:0] axi4_m0_wready              , 
    output                       [15:0] axi4_m0_wstrb               , 
    output                        [0:0] axi4_m0_wvalid              , 
                                                                      
    input                         [3:0] axi4_m0_bid                 , 
    output                        [0:0] axi4_m0_bready              , 
    input                         [1:0] axi4_m0_bresp               , 
    input                         [0:0] axi4_m0_bvalid              , 
                         
    output                       [63:0] axi4_m0_araddr              , 
    output                        [1:0] axi4_m0_arburst             , 
    output                        [3:0] axi4_m0_arcache             , 
    output                        [3:0] axi4_m0_arid                , 
    output                        [7:0] axi4_m0_arlen               , 
    output                        [0:0] axi4_m0_arlock              , 
    output                        [2:0] axi4_m0_arprot              , 
    output                        [3:0] axi4_m0_arqos               , 
    input                         [0:0] axi4_m0_arready             , 
    output                        [2:0] axi4_m0_arsize              , 
    output                        [0:0] axi4_m0_arvalid             , 
                                                                      
    input                       [127:0] axi4_m0_rdata               , 
    input                         [3:0] axi4_m0_rid                 , 
    input                         [0:0] axi4_m0_rlast               , 
    output                        [0:0] axi4_m0_rready              , 
    input                         [1:0] axi4_m0_rresp               , 
    input                         [0:0] axi4_m0_rvalid              , 
// ---------------------------------------------------------------------------------
// Slave AXI-stream
// ---------------------------------------------------------------------------------
    input                               axis_s0_aclk                , 
    input                               axis_s0_arstn               ,     

    output                              axis_s0_tready              , 
    input                               axis_s0_tvalid              , 
    input                       [255:0] axis_s0_tdata               , 
    input                        [31:0] axis_s0_tkeep               , 
    input                        [31:0] axis_s0_tstrb               , 
    input                               axis_s0_tlast               , 


    input                               axis_s1_aclk                , 
    input                               axis_s1_arstn               ,     

    output                              axis_s1_tready              , 
    input                               axis_s1_tvalid              , 
    input                       [127:0] axis_s1_tdata               , 
    input                        [15:0] axis_s1_tkeep               , 
    input                        [15:0] axis_s1_tstrb               , 
    input                               axis_s1_tlast               , 
// ---------------------------------------------------------------------------------
// Debug
// ---------------------------------------------------------------------------------
    output                              dbg_pcie_linkup             , 
    output                        [1:0] dbg_axisfifo_empty            
);

wire                                    pcie_clk                    ; 
wire                                    pcie_clk_div2               ; 


wire                                    axi_aresetn                 ; 

wire                              [3:0] m_axib_awid                 ; 
wire                             [63:0] m_axib_awaddr               ; 
wire                              [7:0] m_axib_awlen                ; 
wire                              [2:0] m_axib_awsize               ; 
wire                              [1:0] m_axib_awburst              ; 
wire                              [2:0] m_axib_awprot               ; 
wire                                    m_axib_awvalid              ; 
wire                                    m_axib_awready              ; 
wire                                    m_axib_awlock               ; 
wire                              [3:0] m_axib_awcache              ; 

wire                            [255:0] m_axib_wdata                ; 
wire                             [31:0] m_axib_wstrb                ; 
wire                                    m_axib_wlast                ; 
wire                                    m_axib_wvalid               ; 
wire                                    m_axib_wready               ; 

wire                              [3:0] m_axib_bid                  ; 
wire                              [1:0] m_axib_bresp                ; 
wire                                    m_axib_bvalid               ; 
wire                                    m_axib_bready               ; 

wire                              [3:0] m_axib_arid                 ; 
wire                             [63:0] m_axib_araddr               ; 
wire                              [7:0] m_axib_arlen                ; 
wire                              [2:0] m_axib_arsize               ; 
wire                              [1:0] m_axib_arburst              ; 
wire                              [2:0] m_axib_arprot               ; 
wire                                    m_axib_arvalid              ; 
wire                                    m_axib_arready              ; 
wire                                    m_axib_arlock               ; 
wire                              [3:0] m_axib_arcache              ; 

wire                              [3:0] m_axib_rid                  ; 
wire                            [255:0] m_axib_rdata                ; 
wire                              [1:0] m_axib_rresp                ; 
wire                                    m_axib_rlast                ; 
wire                                    m_axib_rvalid               ; 
wire                                    m_axib_rready               ; 


wire                              [3:0] m_axicdc_awid               ; 
wire                             [63:0] m_axicdc_awaddr             ; 
wire                              [7:0] m_axicdc_awlen              ; 
wire                              [2:0] m_axicdc_awsize             ; 
wire                              [1:0] m_axicdc_awburst            ; 
wire                              [2:0] m_axicdc_awprot             ; 
wire                                    m_axicdc_awvalid            ; 
wire                                    m_axicdc_awready            ; 
wire                                    m_axicdc_awlock             ; 
wire                              [3:0] m_axicdc_awcache            ; 

wire                            [255:0] m_axicdc_wdata              ; 
wire                             [31:0] m_axicdc_wstrb              ; 
wire                                    m_axicdc_wlast              ; 
wire                                    m_axicdc_wvalid             ; 
wire                                    m_axicdc_wready             ; 

wire                              [3:0] m_axicdc_bid                ; 
wire                              [1:0] m_axicdc_bresp              ; 
wire                                    m_axicdc_bvalid             ; 
wire                                    m_axicdc_bready             ; 

wire                              [3:0] m_axicdc_arid               ; 
wire                             [63:0] m_axicdc_araddr             ; 
wire                              [7:0] m_axicdc_arlen              ; 
wire                              [2:0] m_axicdc_arsize             ; 
wire                              [1:0] m_axicdc_arburst            ; 
wire                              [2:0] m_axicdc_arprot             ; 
wire                                    m_axicdc_arvalid            ; 
wire                                    m_axicdc_arready            ; 
wire                                    m_axicdc_arlock             ; 
wire                              [3:0] m_axicdc_arcache            ; 

wire                              [3:0] m_axicdc_rid                ; 
wire                            [255:0] m_axicdc_rdata              ; 
wire                              [1:0] m_axicdc_rresp              ; 
wire                                    m_axicdc_rlast              ; 
wire                                    m_axicdc_rvalid             ; 
wire                                    m_axicdc_rready             ; 


wire                            [255:0] s_axis_c2h_tdata_0          ; 
wire                                    s_axis_c2h_tlast_0          ; 
wire                                    s_axis_c2h_tvalid_0         ; 
wire                                    s_axis_c2h_tready_0         ; 
wire                             [31:0] s_axis_c2h_tkeep_0          ; 
                                      

wire                            [255:0] s_axis_dw_tdata_1           ; 
wire                                    s_axis_dw_tlast_1           ; 
wire                                    s_axis_dw_tvalid_1          ; 
wire                                    s_axis_dw_tready_1          ; 
wire                             [31:0] s_axis_dw_tkeep_1           ; 
wire                             [31:0] s_axis_dw_tstrb_1           ; 


wire                            [255:0] s_axis_c2h_tdata_1          ; 
wire                                    s_axis_c2h_tlast_1          ; 
wire                                    s_axis_c2h_tvalid_1         ; 
wire                                    s_axis_c2h_tready_1         ; 
wire                             [31:0] s_axis_c2h_tkeep_1          ; 


generate 
if(FPGA_DEV == "XCUS") begin:xcus_if

IBUFDS_GTE3 #
(
    .REFCLK_EN_TX_PATH              (1'b0                       ), // Refer to Transceiver User Guide.
    .REFCLK_HROW_CK_SEL             (2'b00                      ), // Refer to Transceiver User Guide.
    .REFCLK_ICNTL_RX                (2'b00                      )  // Refer to Transceiver User Guide.
)
u0_IBUFDS_GTE3
(
    .I                              (pcie_clk_p                 ), // 1-bit input: Refer to Transceiver User Guide.
    .IB                             (pcie_clk_n                 ), // 1-bit input: Refer to Transceiver User Guide.
    .CEB                            (1'b0                       ), // 1-bit input: Refer to Transceiver User Guide.
    .O                              (pcie_clk                   ), // 1-bit output: Refer to Transceiver User Guide.
    .ODIV2                          (pcie_clk_div2              )  // 1-bit output: Refer to Transceiver User Guide.
);    

end
endgenerate

axi_stream_dfifo u0_axi_stream_dfifo
(
    .s_axis_aclk                    (axis_s0_aclk               ), // input wire s_axis_aclk
    .s_axis_aresetn                 (axis_s0_arstn              ), // input wire s_axis_aresetn

    .s_axis_tvalid                  (axis_s0_tvalid             ), // input wire s_axis_tvalid
    .s_axis_tready                  (axis_s0_tready             ), // output wire s_axis_tready
    .s_axis_tdata                   (axis_s0_tdata              ), // input wire [255 : 0] s_axis_tdata
    .s_axis_tstrb                   (axis_s0_tstrb              ), // input wire [31 : 0] s_axis_tstrb
    .s_axis_tkeep                   (axis_s0_tkeep              ), // input wire [31 : 0] s_axis_tkeep
    .s_axis_tlast                   (axis_s0_tlast              ), // input wire s_axis_tlast

    .m_axis_aclk                    (axi_aclk                   ), // input wire m_axis_aclk

    .m_axis_tvalid                  (s_axis_c2h_tvalid_0        ), // output wire m_axis_tvalid
    .m_axis_tready                  (s_axis_c2h_tready_0        ), // input wire m_axis_tready
    .m_axis_tdata                   (s_axis_c2h_tdata_0         ), // output wire [255 : 0] m_axis_tdata
    .m_axis_tstrb                   (                           ), // output wire [31 : 0] m_axis_tstrb
    .m_axis_tkeep                   (s_axis_c2h_tkeep_0         ), // output wire [31 : 0] m_axis_tkeep
    .m_axis_tlast                   (s_axis_c2h_tlast_0         )  // output wire m_axis_tlast
);

assign dbg_axisfifo_empty[0] = s_axis_c2h_tvalid_0;

axi_stream_dwtrans u0_axi_stream_dwtrans
(
    .aclk                           (axis_s1_aclk               ), // input wire aclk
    .aresetn                        (axis_s1_arstn              ), // input wire aresetn

    .s_axis_tvalid                  (axis_s1_tvalid             ), // input wire s_axis_tvalid
    .s_axis_tready                  (axis_s1_tready             ), // output wire s_axis_tready
    .s_axis_tdata                   (axis_s1_tdata              ), // input wire [127 : 0] s_axis_tdata
    .s_axis_tstrb                   (axis_s1_tstrb              ), // input wire [15 : 0] s_axis_tstrb
    .s_axis_tkeep                   (axis_s1_tkeep              ), // input wire [15 : 0] s_axis_tkeep
    .s_axis_tlast                   (axis_s1_tlast              ), // input wire s_axis_tlast

    .m_axis_tvalid                  (s_axis_dw_tvalid_1         ), // output wire m_axis_tvalid
    .m_axis_tready                  (s_axis_dw_tready_1         ), // input wire m_axis_tready
    .m_axis_tdata                   (s_axis_dw_tdata_1          ), // output wire [255 : 0] m_axis_tdata
    .m_axis_tstrb                   (s_axis_dw_tstrb_1          ), // output wire [31 : 0] m_axis_tstrb
    .m_axis_tkeep                   (s_axis_dw_tkeep_1          ), // output wire [31 : 0] m_axis_tkeep
    .m_axis_tlast                   (s_axis_dw_tlast_1          )  // output wire m_axis_tlast
);

axi_stream_dfifo u1_axi_stream_dfifo
(
    .s_axis_aclk                    (axis_s1_aclk               ), // input wire s_axis_aclk
    .s_axis_aresetn                 (axis_s1_arstn              ), // input wire s_axis_aresetn

    .s_axis_tvalid                  (s_axis_dw_tvalid_1         ), // input wire s_axis_tvalid
    .s_axis_tready                  (s_axis_dw_tready_1         ), // output wire s_axis_tready
    .s_axis_tdata                   (s_axis_dw_tdata_1          ), // input wire [255 : 0] s_axis_tdata
    .s_axis_tstrb                   (s_axis_dw_tstrb_1          ), // input wire [31 : 0] s_axis_tstrb
    .s_axis_tkeep                   (s_axis_dw_tkeep_1          ), // input wire [31 : 0] s_axis_tkeep
    .s_axis_tlast                   (s_axis_dw_tlast_1          ), // input wire s_axis_tlast

    .m_axis_aclk                    (axi_aclk                   ), // input wire m_axis_aclk

    .m_axis_tvalid                  (s_axis_c2h_tvalid_1        ), // output wire m_axis_tvalid
    .m_axis_tready                  (s_axis_c2h_tready_1        ), // input wire m_axis_tready
    .m_axis_tdata                   (s_axis_c2h_tdata_1         ), // output wire [255 : 0] m_axis_tdata
    .m_axis_tstrb                   (                           ), // output wire [31 : 0] m_axis_tstrb
    .m_axis_tkeep                   (s_axis_c2h_tkeep_1         ), // output wire [31 : 0] m_axis_tkeep
    .m_axis_tlast                   (s_axis_c2h_tlast_1         )  // output wire m_axis_tlast
);

assign dbg_axisfifo_empty[1] = s_axis_c2h_tvalid_1;

xdma_x8gen3 u0xdma_x8gen3
(
    .sys_clk                        (pcie_clk_div2              ), // input wire sys_clk
    .sys_clk_gt                     (pcie_clk                   ), // input wire sys_clk_gt
    .sys_rst_n                      (pcie_rst_n                 ), // input wire sys_rst_n

    .user_lnk_up                    (dbg_pcie_linkup            ), // output wire user_lnk_up

    .pci_exp_txp                    (pci_exp_txp                ), // output wire [7 : 0] pci_exp_txp
    .pci_exp_txn                    (pci_exp_txn                ), // output wire [7 : 0] pci_exp_txn
    .pci_exp_rxp                    (pci_exp_rxp                ), // input wire [7 : 0] pci_exp_rxp
    .pci_exp_rxn                    (pci_exp_rxn                ), // input wire [7 : 0] pci_exp_rxn

    .axi_aclk                       (axi_aclk                   ), // output wire axi_aclk
    .axi_aresetn                    (axi_aresetn                ), // output wire axi_aresetn

    .usr_irq_req                    (usr_irq_req                ), // input wire [0 : 0] usr_irq_req
    .usr_irq_ack                    (usr_irq_ack                ), // output wire [0 : 0] usr_irq_ack

    .msi_enable                     (                           ), // output wire msi_enable
    .msix_enable                    (                           ), // output wire msix_enable
    .msi_vector_width               (                           ), // output wire [2 : 0] msi_vector_width

    .cfg_mgmt_addr                  (19'd0                      ), // input wire [18 : 0] cfg_mgmt_addr
    .cfg_mgmt_write                 (1'd0                       ), // input wire cfg_mgmt_write
    .cfg_mgmt_write_data            (32'd0                      ), // input wire [31 : 0] cfg_mgmt_write_data
    .cfg_mgmt_byte_enable           (4'd0                       ), // input wire [3 : 0] cfg_mgmt_byte_enable
    .cfg_mgmt_read                  (1'd0                       ), // input wire cfg_mgmt_read
    .cfg_mgmt_read_data             (                           ), // output wire [31 : 0] cfg_mgmt_read_data
    .cfg_mgmt_read_write_done       (                           ), // output wire cfg_mgmt_read_write_done
    .cfg_mgmt_type1_cfg_reg_access  (1'b0                       ), // input wire cfg_mgmt_type1_cfg_reg_access

    .m_axib_awid                    (m_axib_awid                ), // output wire [3 : 0] m_axib_awid
    .m_axib_awaddr                  (m_axib_awaddr              ), // output wire [63 : 0] m_axib_awaddr
    .m_axib_awlen                   (m_axib_awlen               ), // output wire [7 : 0] m_axib_awlen
    .m_axib_awsize                  (m_axib_awsize              ), // output wire [2 : 0] m_axib_awsize
    .m_axib_awburst                 (m_axib_awburst             ), // output wire [1 : 0] m_axib_awburst
    .m_axib_awprot                  (m_axib_awprot              ), // output wire [2 : 0] m_axib_awprot
    .m_axib_awvalid                 (m_axib_awvalid             ), // output wire m_axib_awvalid
    .m_axib_awready                 (m_axib_awready             ), // input wire m_axib_awready
    .m_axib_awlock                  (m_axib_awlock              ), // output wire m_axib_awlock
    .m_axib_awcache                 (m_axib_awcache             ), // output wire [3 : 0] m_axib_awcache
  
    .m_axib_wdata                   (m_axib_wdata               ), // output wire [255 : 0] m_axib_wdata
    .m_axib_wstrb                   (m_axib_wstrb               ), // output wire [31 : 0] m_axib_wstrb
    .m_axib_wlast                   (m_axib_wlast               ), // output wire m_axib_wlast
    .m_axib_wvalid                  (m_axib_wvalid              ), // output wire m_axib_wvalid
    .m_axib_wready                  (m_axib_wready              ), // input wire m_axib_wready
   
    .m_axib_bid                     (m_axib_bid                 ), // input wire [3 : 0] m_axib_bid
    .m_axib_bresp                   (m_axib_bresp               ), // input wire [1 : 0] m_axib_bresp
    .m_axib_bvalid                  (m_axib_bvalid              ), // input wire m_axib_bvalid
    .m_axib_bready                  (m_axib_bready              ), // output wire m_axib_bready
   
    .m_axib_arid                    (m_axib_arid                ), // output wire [3 : 0] m_axib_arid
    .m_axib_araddr                  (m_axib_araddr              ), // output wire [63 : 0] m_axib_araddr
    .m_axib_arlen                   (m_axib_arlen               ), // output wire [7 : 0] m_axib_arlen
    .m_axib_arsize                  (m_axib_arsize              ), // output wire [2 : 0] m_axib_arsize
    .m_axib_arburst                 (m_axib_arburst             ), // output wire [1 : 0] m_axib_arburst
    .m_axib_arprot                  (m_axib_arprot              ), // output wire [2 : 0] m_axib_arprot
    .m_axib_arvalid                 (m_axib_arvalid             ), // output wire m_axib_arvalid
    .m_axib_arready                 (m_axib_arready             ), // input wire m_axib_arready
    .m_axib_arlock                  (m_axib_arlock              ), // output wire m_axib_arlock
    .m_axib_arcache                 (m_axib_arcache             ), // output wire [3 : 0] m_axib_arcache
 
    .m_axib_rid                     (m_axib_rid                 ), // input wire [3 : 0] m_axib_rid
    .m_axib_rdata                   (m_axib_rdata               ), // input wire [255 : 0] m_axib_rdata
    .m_axib_rresp                   (m_axib_rresp               ), // input wire [1 : 0] m_axib_rresp
    .m_axib_rlast                   (m_axib_rlast               ), // input wire m_axib_rlast
    .m_axib_rvalid                  (m_axib_rvalid              ), // input wire m_axib_rvalid
    .m_axib_rready                  (m_axib_rready              ), // output wire m_axib_rready

    .m_axis_h2c_tdata_0             (                           ), // output wire [255 : 0] m_axis_h2c_tdata_0
    .m_axis_h2c_tlast_0             (                           ), // output wire m_axis_h2c_tlast_0
    .m_axis_h2c_tvalid_0            (                           ), // output wire m_axis_h2c_tvalid_0
    .m_axis_h2c_tready_0            (1'b1                       ), // input wire m_axis_h2c_tready_0
    .m_axis_h2c_tkeep_0             (                           ), // output wire [31 : 0] m_axis_h2c_tkeep_0

    .s_axis_c2h_tdata_0             (s_axis_c2h_tdata_0         ), // input wire [255 : 0] s_axis_c2h_tdata_0
    .s_axis_c2h_tlast_0             (s_axis_c2h_tlast_0         ), // input wire s_axis_c2h_tlast_0
    .s_axis_c2h_tvalid_0            (s_axis_c2h_tvalid_0        ), // input wire s_axis_c2h_tvalid_0
    .s_axis_c2h_tready_0            (s_axis_c2h_tready_0        ), // output wire s_axis_c2h_tready_0
    .s_axis_c2h_tkeep_0             (s_axis_c2h_tkeep_0         ), // input wire [31 : 0] s_axis_c2h_tkeep_0

    .s_axis_c2h_tdata_1             (s_axis_c2h_tdata_1         ), // input wire [255 : 0] s_axis_c2h_tdata_1
    .s_axis_c2h_tlast_1             (s_axis_c2h_tlast_1         ), // input wire s_axis_c2h_tlast_1
    .s_axis_c2h_tvalid_1            (s_axis_c2h_tvalid_1        ), // input wire s_axis_c2h_tvalid_1
    .s_axis_c2h_tready_1            (s_axis_c2h_tready_1        ), // output wire s_axis_c2h_tready_1
    .s_axis_c2h_tkeep_1             (s_axis_c2h_tkeep_1         ), // input wire [31 : 0] s_axis_c2h_tkeep_1
    .int_qpll1lock_out              (                           ), // output wire [1 : 0] int_qpll1lock_out
    .int_qpll1outrefclk_out         (                           ), // output wire [1 : 0] int_qpll1outrefclk_out
    .int_qpll1outclk_out            (                           )  // output wire [1 : 0] int_qpll1outclk_out
);

assign pcie_rsto_n = axi_aresetn;

axi4_cdc u0_axi4_cdc
(
    .s_axi_aclk                     (axi_aclk                   ), // input wire s_axi_aclk
    .s_axi_aresetn                  (axi_aresetn                ), // input wire s_axi_aresetn

    .s_axi_awid                     (m_axib_awid                ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr                   (m_axib_awaddr              ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awlen                    (m_axib_awlen               ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize                   (m_axib_awsize              ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst                  (m_axib_awburst             ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock                   (m_axib_awlock              ), // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache                  (m_axib_awcache             ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot                   (m_axib_awprot              ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion                 ('d0                        ), // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos                    ('d0                        ), // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid                  (m_axib_awvalid             ), // input wire s_axi_awvalid
    .s_axi_awready                  (m_axib_awready             ), // output wire s_axi_awready

    .s_axi_wdata                    (m_axib_wdata               ), // input wire [255 : 0] s_axi_wdata
    .s_axi_wstrb                    (m_axib_wstrb               ), // input wire [31 : 0] s_axi_wstrb
    .s_axi_wlast                    (m_axib_wlast               ), // input wire s_axi_wlast
    .s_axi_wvalid                   (m_axib_wvalid              ), // input wire s_axi_wvalid
    .s_axi_wready                   (m_axib_wready              ), // output wire s_axi_wready

    .s_axi_bid                      (m_axib_bid                 ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp                    (m_axib_bresp               ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid                   (m_axib_bvalid              ), // output wire s_axi_bvalid
    .s_axi_bready                   (m_axib_bready              ), // input wire s_axi_bready

    .s_axi_arid                     (m_axib_arid                ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr                   (m_axib_araddr              ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arlen                    (m_axib_arlen               ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize                   (m_axib_arsize              ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst                  (m_axib_arburst             ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock                   (m_axib_arlock              ), // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache                  (m_axib_arcache             ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot                   (m_axib_arprot              ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion                 ('d0                        ), // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos                    ('d0                        ), // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid                  (m_axib_arvalid             ), // input wire s_axi_arvalid
    .s_axi_arready                  (m_axib_arready             ), // output wire s_axi_arready

    .s_axi_rid                      (m_axib_rid                 ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata                    (m_axib_rdata               ), // output wire [255 : 0] s_axi_rdata
    .s_axi_rresp                    (m_axib_rresp               ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                    (m_axib_rlast               ), // output wire s_axi_rlast
    .s_axi_rvalid                   (m_axib_rvalid              ), // output wire s_axi_rvalid
    .s_axi_rready                   (m_axib_rready              ), // input wire s_axi_rready

    .m_axi_aclk                     (axi4_m0_aclk               ), // input wire m_axi_aclk
    .m_axi_aresetn                  (axi4_m0_arstn              ), // input wire m_axi_aresetn

    .m_axi_awid                     (m_axicdc_awid              ), // output wire [3 : 0] m_axi_awid
    .m_axi_awaddr                   (m_axicdc_awaddr            ), // output wire [63 : 0] m_axi_awaddr
    .m_axi_awlen                    (m_axicdc_awlen             ), // output wire [7 : 0] m_axi_awlen
    .m_axi_awsize                   (m_axicdc_awsize            ), // output wire [2 : 0] m_axi_awsize
    .m_axi_awburst                  (m_axicdc_awburst           ), // output wire [1 : 0] m_axi_awburst
    .m_axi_awlock                   (m_axicdc_awlock            ), // output wire [0 : 0] m_axi_awlock
    .m_axi_awcache                  (m_axicdc_awcache           ), // output wire [3 : 0] m_axi_awcache
    .m_axi_awprot                   (m_axicdc_awprot            ), // output wire [2 : 0] m_axi_awprot
    .m_axi_awregion                 (                           ), // output wire [3 : 0] m_axi_awregion
    .m_axi_awqos                    (                           ), // output wire [3 : 0] m_axi_awqos
    .m_axi_awvalid                  (m_axicdc_awvalid           ), // output wire m_axi_awvalid
    .m_axi_awready                  (m_axicdc_awready           ), // input wire m_axi_awready
                                          
    .m_axi_wdata                    (m_axicdc_wdata             ), // output wire [255 : 0] m_axi_wdata
    .m_axi_wstrb                    (m_axicdc_wstrb             ), // output wire [31 : 0] m_axi_wstrb
    .m_axi_wlast                    (m_axicdc_wlast             ), // output wire m_axi_wlast
    .m_axi_wvalid                   (m_axicdc_wvalid            ), // output wire m_axi_wvalid
    .m_axi_wready                   (m_axicdc_wready            ), // input wire m_axi_wready
                                          
    .m_axi_bid                      (m_axicdc_bid               ), // input wire [3 : 0] m_axi_bid
    .m_axi_bresp                    (m_axicdc_bresp             ), // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid                   (m_axicdc_bvalid            ), // input wire m_axi_bvalid
    .m_axi_bready                   (m_axicdc_bready            ), // output wire m_axi_bready
                                          
    .m_axi_arid                     (m_axicdc_arid              ), // output wire [3 : 0] m_axi_arid
    .m_axi_araddr                   (m_axicdc_araddr            ), // output wire [63 : 0] m_axi_araddr
    .m_axi_arlen                    (m_axicdc_arlen             ), // output wire [7 : 0] m_axi_arlen
    .m_axi_arsize                   (m_axicdc_arsize            ), // output wire [2 : 0] m_axi_arsize
    .m_axi_arburst                  (m_axicdc_arburst           ), // output wire [1 : 0] m_axi_arburst
    .m_axi_arlock                   (m_axicdc_arlock            ), // output wire [0 : 0] m_axi_arlock
    .m_axi_arcache                  (m_axicdc_arcache           ), // output wire [3 : 0] m_axi_arcache
    .m_axi_arprot                   (m_axicdc_arprot            ), // output wire [2 : 0] m_axi_arprot
    .m_axi_arregion                 (                           ), // output wire [3 : 0] m_axi_arregion
    .m_axi_arqos                    (                           ), // output wire [3 : 0] m_axi_arqos
    .m_axi_arvalid                  (m_axicdc_arvalid           ), // output wire m_axi_arvalid
    .m_axi_arready                  (m_axicdc_arready           ), // input wire m_axi_arready
                                          
    .m_axi_rid                      (m_axicdc_rid               ), // input wire [3 : 0] m_axi_rid
    .m_axi_rdata                    (m_axicdc_rdata             ), // input wire [255 : 0] m_axi_rdata
    .m_axi_rresp                    (m_axicdc_rresp             ), // input wire [1 : 0] m_axi_rresp
    .m_axi_rlast                    (m_axicdc_rlast             ), // input wire m_axi_rlast
    .m_axi_rvalid                   (m_axicdc_rvalid            ), // input wire m_axi_rvalid
    .m_axi_rready                   (m_axicdc_rready            )  // output wire m_axi_rready
);

axi4_dwtrans u0_axi4_dwtrans
(
    .s_axi_aclk                     (axi4_m0_aclk               ), // input wire s_axi_aclk
    .s_axi_aresetn                  (axi4_m0_arstn              ), // input wire s_axi_aresetn

    .s_axi_awid                     (m_axicdc_awid              ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr                   (m_axicdc_awaddr            ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awlen                    (m_axicdc_awlen             ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize                   (m_axicdc_awsize            ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst                  (m_axicdc_awburst           ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock                   (m_axicdc_awlock            ), // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache                  (m_axicdc_awcache           ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot                   (m_axicdc_awprot            ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion                 ('d0                        ), // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos                    ('d0                        ), // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid                  (m_axicdc_awvalid           ), // input wire s_axi_awvalid
    .s_axi_awready                  (m_axicdc_awready           ), // output wire s_axi_awready

    .s_axi_wdata                    (m_axicdc_wdata             ), // input wire [255 : 0] s_axi_wdata
    .s_axi_wstrb                    (m_axicdc_wstrb             ), // input wire [31 : 0] s_axi_wstrb
    .s_axi_wlast                    (m_axicdc_wlast             ), // input wire s_axi_wlast
    .s_axi_wvalid                   (m_axicdc_wvalid            ), // input wire s_axi_wvalid
    .s_axi_wready                   (m_axicdc_wready            ), // output wire s_axi_wready

    .s_axi_bid                      (m_axicdc_bid               ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp                    (m_axicdc_bresp             ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid                   (m_axicdc_bvalid            ), // output wire s_axi_bvalid
    .s_axi_bready                   (m_axicdc_bready            ), // input wire s_axi_bready

    .s_axi_arid                     (m_axicdc_arid              ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr                   (m_axicdc_araddr            ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arlen                    (m_axicdc_arlen             ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize                   (m_axicdc_arsize            ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst                  (m_axicdc_arburst           ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock                   (m_axicdc_arlock            ), // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache                  (m_axicdc_arcache           ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot                   (m_axicdc_arprot            ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion                 ('d0                        ), // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos                    ('d0                        ), // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid                  (m_axicdc_arvalid           ), // input wire s_axi_arvalid
    .s_axi_arready                  (m_axicdc_arready           ), // output wire s_axi_arready

    .s_axi_rid                      (m_axicdc_rid               ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata                    (m_axicdc_rdata             ), // output wire [255 : 0] s_axi_rdata
    .s_axi_rresp                    (m_axicdc_rresp             ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                    (m_axicdc_rlast             ), // output wire s_axi_rlast
    .s_axi_rvalid                   (m_axicdc_rvalid            ), // output wire s_axi_rvalid
    .s_axi_rready                   (m_axicdc_rready            ), // input wire s_axi_rready

    .m_axi_awaddr                   (axi4_m0_awaddr             ), // output wire [63 : 0] m_axi_awaddr
    .m_axi_awlen                    (axi4_m0_awlen              ), // output wire [7 : 0] m_axi_awlen
    .m_axi_awsize                   (axi4_m0_awsize             ), // output wire [2 : 0] m_axi_awsize
    .m_axi_awburst                  (axi4_m0_awburst            ), // output wire [1 : 0] m_axi_awburst
    .m_axi_awlock                   (axi4_m0_awlock             ), // output wire [0 : 0] m_axi_awlock
    .m_axi_awcache                  (axi4_m0_awcache            ), // output wire [3 : 0] m_axi_awcache
    .m_axi_awprot                   (axi4_m0_awprot             ), // output wire [2 : 0] m_axi_awprot
    .m_axi_awregion                 (                           ), // output wire [3 : 0] m_axi_awregion
    .m_axi_awqos                    (axi4_m0_awqos              ), // output wire [3 : 0] m_axi_awqos
    .m_axi_awvalid                  (axi4_m0_awvalid            ), // output wire m_axi_awvalid
    .m_axi_awready                  (axi4_m0_awready            ), // input wire m_axi_awready

    .m_axi_wdata                    (axi4_m0_wdata              ), // output wire [127 : 0] m_axi_wdata
    .m_axi_wstrb                    (axi4_m0_wstrb              ), // output wire [15 : 0] m_axi_wstrb
    .m_axi_wlast                    (axi4_m0_wlast              ), // output wire m_axi_wlast
    .m_axi_wvalid                   (axi4_m0_wvalid             ), // output wire m_axi_wvalid
    .m_axi_wready                   (axi4_m0_wready             ), // input wire m_axi_wready

    .m_axi_bresp                    (axi4_m0_bresp              ), // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid                   (axi4_m0_bvalid             ), // input wire m_axi_bvalid
    .m_axi_bready                   (axi4_m0_bready             ), // output wire m_axi_bready

    .m_axi_araddr                   (axi4_m0_araddr             ), // output wire [63 : 0] m_axi_araddr
    .m_axi_arlen                    (axi4_m0_arlen              ), // output wire [7 : 0] m_axi_arlen
    .m_axi_arsize                   (axi4_m0_arsize             ), // output wire [2 : 0] m_axi_arsize
    .m_axi_arburst                  (axi4_m0_arburst            ), // output wire [1 : 0] m_axi_arburst
    .m_axi_arlock                   (axi4_m0_arlock             ), // output wire [0 : 0] m_axi_arlock
    .m_axi_arcache                  (axi4_m0_arcache            ), // output wire [3 : 0] m_axi_arcache
    .m_axi_arprot                   (axi4_m0_arprot             ), // output wire [2 : 0] m_axi_arprot
    .m_axi_arregion                 (                           ), // output wire [3 : 0] m_axi_arregion
    .m_axi_arqos                    (axi4_m0_arqos              ), // output wire [3 : 0] m_axi_arqos
    .m_axi_arvalid                  (axi4_m0_arvalid            ), // output wire m_axi_arvalid
    .m_axi_arready                  (axi4_m0_arready            ), // input wire m_axi_arready

    .m_axi_rdata                    (axi4_m0_rdata              ), // input wire [127 : 0] m_axi_rdata
    .m_axi_rresp                    (axi4_m0_rresp              ), // input wire [1 : 0] m_axi_rresp
    .m_axi_rlast                    (axi4_m0_rlast              ), // input wire m_axi_rlast
    .m_axi_rvalid                   (axi4_m0_rvalid             ), // input wire m_axi_rvalid
    .m_axi_rready                   (axi4_m0_rready             )  // output wire m_axi_rready
);

assign axi4_m0_arid = 0;
assign axi4_m0_awid = 0;


endmodule





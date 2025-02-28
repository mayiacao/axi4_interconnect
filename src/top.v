// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/07 15:40:13
// File Name    : top.v
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
// top
//    |---
// 
`timescale 1ns/1ps

module top #
(
    parameter                           U_DLY = 1                     // 
)
(
    input                               clk_sys_p                   , 
    input                               clk_sys_n                   , 
    
    input                               pcie_clk_p                  , 
    input                               pcie_clk_n                  , 
    input                               pcie_rst_n                  , 

    output                        [7:0] pcie_tx_p                   , 
    output                        [7:0] pcie_tx_n                   , 
    input                         [7:0] pcie_rx_p                   , 
    input                         [7:0] pcie_rx_n                     
);

localparam [4*32-1:0] ADDR_BASE = {32'h8003_0000,
                                   32'h8002_0000,
                                   32'h8001_0000,
                                   32'h8000_0000};

localparam [4*32-1:0] ADDR_HIGH = {32'h8003_ffff,
                                   32'h8002_ffff,
                                   32'h8001_ffff,
                                   32'h8000_ffff};

wire                                    clk_sys_ibuf                ; 
wire                              [3:0] clk_sys                     ; 
wire                                    axi_aclk                    ; 

wire                                    resetn                      ; 
wire                                    rst_n                       ; 

(*keep = "true",mark_debug = "true"*)wire                             [63:0] axi4_s0_awaddr              ; 
(*keep = "true",mark_debug = "true"*)wire                              [1:0] axi4_s0_awburst             ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_awcache             ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_awid                ; 
(*keep = "true",mark_debug = "true"*)wire                              [7:0] axi4_s0_awlen               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_awlock              ; 
(*keep = "true",mark_debug = "true"*)wire                              [2:0] axi4_s0_awprot              ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_awqos               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_awready             ; 
(*keep = "true",mark_debug = "true"*)wire                              [2:0] axi4_s0_awsize              ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_awvalid             ; 
                                                                    
(*keep = "true",mark_debug = "true"*)wire                            [127:0] axi4_s0_wdata               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_wlast               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_wready              ; 
(*keep = "true",mark_debug = "true"*)wire                             [15:0] axi4_s0_wstrb               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_wvalid              ; 
                                                                    
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_bid                 ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_bready              ; 
(*keep = "true",mark_debug = "true"*)wire                              [1:0] axi4_s0_bresp               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_bvalid              ; 
                        
(*keep = "true",mark_debug = "true"*)wire                             [63:0] axi4_s0_araddr              ; 
(*keep = "true",mark_debug = "true"*)wire                              [1:0] axi4_s0_arburst             ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_arcache             ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_arid                ; 
(*keep = "true",mark_debug = "true"*)wire                              [7:0] axi4_s0_arlen               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_arlock              ; 
(*keep = "true",mark_debug = "true"*)wire                              [2:0] axi4_s0_arprot              ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_arqos               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_arready             ; 
(*keep = "true",mark_debug = "true"*)wire                              [2:0] axi4_s0_arsize              ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_arvalid             ; 
                                                                     
(*keep = "true",mark_debug = "true"*)wire                            [127:0] axi4_s0_rdata               ; 
(*keep = "true",mark_debug = "true"*)wire                              [3:0] axi4_s0_rid                 ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_rlast               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_rready              ; 
(*keep = "true",mark_debug = "true"*)wire                              [1:0] axi4_s0_rresp               ; 
(*keep = "true",mark_debug = "true"*)wire                              [0:0] axi4_s0_rvalid              ; 


wire                          [4*4-1:0] m_axi4_arid                 ; 
wire                         [4*32-1:0] m_axi4_araddr               ; 
wire                          [4*8-1:0] m_axi4_arlen                ; 
wire                          [4*3-1:0] m_axi4_arsize               ; 
wire                          [4*2-1:0] m_axi4_arburst              ; 
wire                          [4*4-1:0] m_axi4_arion                ; 
wire                            [4-1:0] m_axi4_arlock               ; 
wire                          [4*4-1:0] m_axi4_arcache              ; 
wire                          [4*3-1:0] m_axi4_arprot               ; 
wire                          [4*4-1:0] m_axi4_arqos                ; 
wire                          [4*2-1:0] m_axi4_aruser               ; 
wire                            [4-1:0] m_axi4_arvalid              ; 
wire                            [4-1:0] m_axi4_arready              ; 

wire                          [4*4-1:0] m_axi4_rid                  ; 
wire                        [4*128-1:0] m_axi4_rdata                ; 
wire                          [4*2-1:0] m_axi4_rresp                ; 
wire                            [4-1:0] m_axi4_rlast                ; 
wire                          [4*2-1:0] m_axi4_ruser                ; 
wire                            [4-1:0] m_axi4_rvalid               ; 
wire                            [4-1:0] m_axi4_rready               ; 

wire                          [4*4-1:0] m_axi4_awid                 ; 
wire                         [4*32-1:0] m_axi4_awaddr               ; 
wire                          [4*8-1:0] m_axi4_awlen                ; 
wire                          [4*3-1:0] m_axi4_awsize               ; 
wire                          [4*2-1:0] m_axi4_awburst              ; 
wire                          [4*4-1:0] m_axi4_awion                ; 
wire                            [4-1:0] m_axi4_awlock               ; 
wire                          [4*4-1:0] m_axi4_awcache              ; 
wire                          [4*3-1:0] m_axi4_awprot               ; 
wire                          [4*4-1:0] m_axi4_awqos                ; 
wire                          [4*2-1:0] m_axi4_awuser               ; 
wire                            [4-1:0] m_axi4_awvalid              ; 
wire                            [4-1:0] m_axi4_awready              ; 

wire                          [4*4-1:0] m_axi4_wid                  ; 
wire                        [4*128-1:0] m_axi4_wdata                ; 
wire                         [4*16-1:0] m_axi4_wstrob               ; 
wire                            [4-1:0] m_axi4_wlast                ; 
wire                          [4*2-1:0] m_axi4_wuser                ; 
wire                            [4-1:0] m_axi4_wvalid               ; 
wire                            [4-1:0] m_axi4_wready               ; 

wire                          [4*4-1:0] m_axi4_bid                  ; 
wire                          [4*2-1:0] m_axi4_bresp                ; 
wire                          [4*2-1:0] m_axi4_buser                ; 
wire                            [4-1:0] m_axi4_bvalid               ; 
wire                            [4-1:0] m_axi4_bready               ; 

genvar                                  i                           ;

clk_wiz_0 u_clk_wiz_0
(
    // Clock out ports
    .clk_out1                       (clk_sys[0]                 ), // output clk_out1
    .clk_out2                       (clk_sys[1]                 ), // output clk_out2
    .clk_out3                       (clk_sys[2]                 ), // output clk_out3
    .clk_out4                       (clk_sys[3]                 ), // output clk_out4
// Status and control signals
    .resetn                         (resetn                     ), // input resetn
    .locked                         (rst_n                      ), // output locked
// Clock in ports
    .clk_in1_p                      (clk_sys_p                  ), // input clk_in1_p
    .clk_in1_n                      (clk_sys_n                  )  // input clk_in1_n
);


xdma_warper #
(
    .FPGA_DEV                       ("XCUS"                     ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_xdma_warper
(
// ---------------------------------------------------------------------------------
// Pcie
// ---------------------------------------------------------------------------------
    .pcie_clk_p                     (pcie_clk_p                 ), // (input )
    .pcie_clk_n                     (pcie_clk_n                 ), // (input )
    .pcie_rst_n                     (pcie_rst_n                 ), // (input )
    .pcie_rsto_n                    (rst_n                      ), // (output)

    .pci_exp_txp                    (pcie_tx_p[7:0]             ), // (output)
    .pci_exp_txn                    (pcie_tx_n[7:0]             ), // (output)
    .pci_exp_rxp                    (pcie_rx_p[7:0]             ), // (input )
    .pci_exp_rxn                    (pcie_rx_n[7:0]             ), // (input )
// ---------------------------------------------------------------------------------
// Irq
// ---------------------------------------------------------------------------------
    .usr_irq_req                    (1'b0                       ), // (input )
    .usr_irq_ack                    (                           ), // (output)
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .axi_aclk                       (axi_aclk                   ), // (output)
    .axi4_m0_aclk                   (clk_sys[1]                 ), // (input )
    .axi4_m0_arstn                  (resetn                     ), // (input )

    .axi4_m0_awaddr                 (axi4_s0_awaddr[63:0]       ), // (output)
    .axi4_m0_awburst                (axi4_s0_awburst[1:0]       ), // (output)
    .axi4_m0_awcache                (axi4_s0_awcache[3:0]       ), // (output)
    .axi4_m0_awid                   (axi4_s0_awid[3:0]          ), // (output)
    .axi4_m0_awlen                  (axi4_s0_awlen[7:0]         ), // (output)
    .axi4_m0_awlock                 (axi4_s0_awlock[0:0]        ), // (output)
    .axi4_m0_awprot                 (axi4_s0_awprot[2:0]        ), // (output)
    .axi4_m0_awqos                  (axi4_s0_awqos[3:0]         ), // (output)
    .axi4_m0_awready                (axi4_s0_awready[0:0]       ), // (input )
    .axi4_m0_awsize                 (axi4_s0_awsize[2:0]        ), // (output)
    .axi4_m0_awvalid                (axi4_s0_awvalid[0:0]       ), // (output)
                                                                    
    .axi4_m0_wdata                  (axi4_s0_wdata[127:0]       ), // (output)
    .axi4_m0_wlast                  (axi4_s0_wlast[0:0]         ), // (output)
    .axi4_m0_wready                 (axi4_s0_wready[0:0]        ), // (input )
    .axi4_m0_wstrb                  (axi4_s0_wstrb[15:0]        ), // (output)
    .axi4_m0_wvalid                 (axi4_s0_wvalid[0:0]        ), // (output)
                                                          
    .axi4_m0_bid                    (axi4_s0_bid[3:0]           ), // (input )
    .axi4_m0_bready                 (axi4_s0_bready[0:0]        ), // (output)
    .axi4_m0_bresp                  (axi4_s0_bresp[1:0]         ), // (input )
    .axi4_m0_bvalid                 (axi4_s0_bvalid[0:0]        ), // (input )
                        
    .axi4_m0_araddr                 (axi4_s0_araddr[63:0]       ), // (output)
    .axi4_m0_arburst                (axi4_s0_arburst[1:0]       ), // (output)
    .axi4_m0_arcache                (axi4_s0_arcache[3:0]       ), // (output)
    .axi4_m0_arid                   (axi4_s0_arid[3:0]          ), // (output)
    .axi4_m0_arlen                  (axi4_s0_arlen[7:0]         ), // (output)
    .axi4_m0_arlock                 (axi4_s0_arlock[0:0]        ), // (output)
    .axi4_m0_arprot                 (axi4_s0_arprot[2:0]        ), // (output)
    .axi4_m0_arqos                  (axi4_s0_arqos[3:0]         ), // (output)
    .axi4_m0_arready                (axi4_s0_arready[0:0]       ), // (input )
    .axi4_m0_arsize                 (axi4_s0_arsize[2:0]        ), // (output)
    .axi4_m0_arvalid                (axi4_s0_arvalid[0:0]       ), // (output)
                                                                    
    .axi4_m0_rdata                  (axi4_s0_rdata[127:0]       ), // (input )
    .axi4_m0_rid                    (axi4_s0_rid[3:0]           ), // (input )
    .axi4_m0_rlast                  (axi4_s0_rlast[0:0]         ), // (input )
    .axi4_m0_rready                 (axi4_s0_rready[0:0]        ), // (output)
    .axi4_m0_rresp                  (axi4_s0_rresp[1:0]         ), // (input )
    .axi4_m0_rvalid                 (axi4_s0_rvalid[0:0]        ), // (input )
// ---------------------------------------------------------------------------------
// Slave AXI-stream
// ---------------------------------------------------------------------------------
    .axis_s0_aclk                   (clk_sys[1]                 ), // (input )
    .axis_s0_arstn                  (rst_n                      ), // (input )

    .axis_s0_tready                 (                           ), // (output)
    .axis_s0_tvalid                 ('d0                        ), // (input )
    .axis_s0_tdata                  ('d0                        ), // (input )
    .axis_s0_tkeep                  ('d0                        ), // (input )
    .axis_s0_tstrb                  ('d0                        ), // (input )
    .axis_s0_tlast                  ('d0                        ), // (input )


    .axis_s1_aclk                   (clk_sys[1]                 ), // (input )
    .axis_s1_arstn                  (rst_n                      ), // (input )

    .axis_s1_tready                 (                           ), // (output)
    .axis_s1_tvalid                 ('d0                        ), // (input )
    .axis_s1_tdata                  ('d0                        ), // (input )
    .axis_s1_tkeep                  ('d0                        ), // (input )
    .axis_s1_tstrb                  ('d0                        ), // (input )
    .axis_s1_tlast                  ('d0                        ), // (input )
// ---------------------------------------------------------------------------------
// Debug
// ---------------------------------------------------------------------------------
    .dbg_pcie_linkup                (                           ), // (output)
    .dbg_axisfifo_empty             (                           )  // (output)
);

axi_interconnect # 
(
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys[1]                 ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave Interface 
// ---------------------------------------------------------------------------------
    .s00_axi4_arid                  (axi4_s0_arid               ), // (input ) [63:0]
    .s00_axi4_araddr                (axi4_s0_araddr[31:0]       ), // (input ) [1:0]
    .s00_axi4_arlen                 (axi4_s0_arlen              ), // (input ) [3:0]
    .s00_axi4_arsize                (axi4_s0_arsize             ), // (input ) [3:0]   
    .s00_axi4_arburst               (axi4_s0_arburst            ), // (input ) [7:0]  
    .s00_axi4_arregion              (                           ), // (input ) [0:0] 
    .s00_axi4_arlock                (axi4_s0_arlock             ), // (input ) [2:0] 
    .s00_axi4_arcache               (axi4_s0_arcache            ), // (input ) [3:0]  
    .s00_axi4_arprot                (axi4_s0_arprot             ), // (input ) [0:0]
    .s00_axi4_arqos                 (axi4_s0_arqos              ), // (input ) [2:0] 
    .s00_axi4_arvalid               (axi4_s0_arvalid            ), // (input ) [0:0]
    .s00_axi4_arready               (axi4_s0_arready            ), // (output)                     
                                                                              
    .s00_axi4_rid                   (axi4_s0_rid                ), // (output) [3:0]    
    .s00_axi4_rdata                 (axi4_s0_rdata              ), // (output) [0:0]  
    .s00_axi4_rresp                 (axi4_s0_rresp              ), // (output) [0:0] 
    .s00_axi4_rlast                 (axi4_s0_rlast              ), // (output) [1:0]  
    .s00_axi4_rvalid                (axi4_s0_rvalid             ), // (output) [0:0] 
    .s00_axi4_rready                (axi4_s0_rready             ), // (input )

    .s00_axi4_awid                  (axi4_s0_awid               ), // (input ) [127:0] 
    .s00_axi4_awaddr                (axi4_s0_awaddr[31:0]       ), // (input ) [0:0]   
    .s00_axi4_awlen                 (axi4_s0_awlen              ), // (input ) [0:0]  
    .s00_axi4_awsize                (axi4_s0_awsize             ), // (input ) [15:0]  
    .s00_axi4_awburst               (axi4_s0_awburst            ), // (input ) [0:0]  
    .s00_axi4_awregion              (                           ), // (input )                      
    .s00_axi4_awlock                (axi4_s0_awlock             ), // (input ) [3:0]     
    .s00_axi4_awcache               (axi4_s0_awcache            ), // (input ) [0:0]  
    .s00_axi4_awprot                (axi4_s0_awprot             ), // (input ) [1:0]   
    .s00_axi4_awqos                 (axi4_s0_awqos              ), // (input ) [0:0]  
    .s00_axi4_awvalid               (axi4_s0_awvalid            ), // (input )
    .s00_axi4_awready               (axi4_s0_awready            ), // (output)

    .s00_axi4_wdata                 (axi4_s0_wdata              ), // (input ) 
    .s00_axi4_wstrob                (axi4_s0_wstrb              ), // (input )
    .s00_axi4_wlast                 (axi4_s0_wlast              ), // (input )
    .s00_axi4_wvalid                (axi4_s0_wvalid             ), // (input )
    .s00_axi4_wready                (axi4_s0_wready             ), // (output)

    .s00_axi4_bid                   (axi4_s0_bid                ), // (output)
    .s00_axi4_bresp                 (axi4_s0_bresp              ), // (output)
    .s00_axi4_bvalid                (axi4_s0_bvalid             ), // (output)
    .s00_axi4_bready                (axi4_s0_bready             ), // (input )
// ---------------------------------------------------------------------------------
// Master Interface 
// ---------------------------------------------------------------------------------
    .m00_axi4_clk                   (clk_sys[0]                 ), // (input )
    .m00_axi4_arid                  (m_axi4_arid[0*4+:4]         ), // (output)
    .m00_axi4_araddr                (m_axi4_araddr[0*32+:32]     ), // (output)
    .m00_axi4_arlen                 (m_axi4_arlen[0*8+:8]        ), // (output)
    .m00_axi4_arsize                (m_axi4_arsize[0*3+:3]       ), // (output)
    .m00_axi4_arburst               (m_axi4_arburst[0*2+:2]      ), // (output)
    .m00_axi4_arregion              (                            ), // (output)
    .m00_axi4_arlock                (                            ), // (output)
    .m00_axi4_arcache               (                            ), // (output)
    .m00_axi4_arprot                (                            ), // (output)
    .m00_axi4_arqos                 (                            ), // (output)
    .m00_axi4_arvalid               (m_axi4_arvalid[0]           ), // (output)
    .m00_axi4_arready               (m_axi4_arready[0]           ), // (input )
                                                              
    .m00_axi4_rid                   (m_axi4_rid[0*4+:4]          ), // (input )
    .m00_axi4_rdata                 (m_axi4_rdata[0*32+:32]      ), // (input )
    .m00_axi4_rresp                 (m_axi4_rresp[0*2+:2]        ), // (input )
    .m00_axi4_rlast                 (m_axi4_rlast[0]             ), // (input )
    .m00_axi4_rvalid                (m_axi4_rvalid[0]            ), // (input )
    .m00_axi4_rready                (m_axi4_rready[0]            ), // (output)
                                                              
    .m00_axi4_awid                  (m_axi4_awid[0*4+:4]         ), // (output)
    .m00_axi4_awaddr                (m_axi4_awaddr[0*32+:32]     ), // (output)
    .m00_axi4_awlen                 (m_axi4_awlen[0*8+:8]        ), // (output)
    .m00_axi4_awsize                (m_axi4_awsize[0*3+:3]       ), // (output)
    .m00_axi4_awburst               (m_axi4_awburst[0*2+:2]      ), // (output)
    .m00_axi4_awregion              (                            ), // (output)
    .m00_axi4_awlock                (                            ), // (output)
    .m00_axi4_awcache               (                            ), // (output)
    .m00_axi4_awprot                (                            ), // (output)
    .m00_axi4_awqos                 (                            ), // (output)
    .m00_axi4_awvalid               (m_axi4_awvalid[0]           ), // (output)
    .m00_axi4_awready               (m_axi4_awready[0]           ), // (input )
                                                              
    .m00_axi4_wdata                 (m_axi4_wdata[0*32+:32]      ), // (output)
    .m00_axi4_wstrob                (m_axi4_wstrob[0*4+:4]       ), // (output)
    .m00_axi4_wlast                 (m_axi4_wlast[0]             ), // (output)
    .m00_axi4_wvalid                (m_axi4_wvalid[0]            ), // (output)
    .m00_axi4_wready                (m_axi4_wready[0]            ), // (input )
                                                              
    .m00_axi4_bid                   (m_axi4_bid[0*4+:4]          ), // (input )
    .m00_axi4_bresp                 (m_axi4_bresp[0*2+:2]        ), // (input )
    .m00_axi4_bvalid                (m_axi4_bvalid[0]            ), // (input )
    .m00_axi4_bready                (m_axi4_bready[0]            ), // (output)


    .m01_axi4_clk                   (clk_sys[1]                 ), // (input )      
    .m01_axi4_arid                  (m_axi4_arid[1*4+:4]        ), // (output) {16'd0,
    .m01_axi4_araddr                (m_axi4_araddr[1*32+:32]    ), // (output)        
    .m01_axi4_arlen                 (m_axi4_arlen[1*8+:8]       ), // (output)      
    .m01_axi4_arsize                (m_axi4_arsize[1*3+:3]      ), // (output)     
    .m01_axi4_arburst               (m_axi4_arburst[1*2+:2]     ), // (output)          
    .m01_axi4_arregion              (                           ), // (output)         
    .m01_axi4_arlock                (                           ), // (output)    
    .m01_axi4_arcache               (                           ), // (output)    
    .m01_axi4_arprot                (                           ), // (output)             
    .m01_axi4_arqos                 (                           ), // (output)           
    .m01_axi4_arvalid               (m_axi4_arvalid[1]          ), // (output)           
    .m01_axi4_arready               (m_axi4_arready[1]          ), // (input )          
                                                                                      
    .m01_axi4_rid                   (m_axi4_rid[1*4+:4]         ), // (input )            
    .m01_axi4_rdata                 (m_axi4_rdata[1*32+:32]     ), // (input )            
    .m01_axi4_rresp                 (m_axi4_rresp[1*2+:2]       ), // (input ) 
    .m01_axi4_rlast                 (m_axi4_rlast[1]            ), // (input ) 
    .m01_axi4_rvalid                (m_axi4_rvalid[1]           ), // (input ) 
    .m01_axi4_rready                (m_axi4_rready[1]           ), // (output) 
                                                                               
    .m01_axi4_awid                  (m_axi4_awid[1*4+:4]        ), // (output) 
    .m01_axi4_awaddr                (m_axi4_awaddr[1*32+:32]    ), // (output) 
    .m01_axi4_awlen                 (m_axi4_awlen[1*8+:8]       ), // (output)          
    .m01_axi4_awsize                (m_axi4_awsize[1*3+:3]      ), // (output)    
    .m01_axi4_awburst               (m_axi4_awburst[1*2+:2]     ), // (output)       
    .m01_axi4_awregion              (                           ), // (output)            
    .m01_axi4_awlock                (                           ), // (output)            
    .m01_axi4_awcache               (                           ), // (output)          
    .m01_axi4_awprot                (                           ), // (output)
    .m01_axi4_awqos                 (                           ), // (output)
    .m01_axi4_awvalid               (m_axi4_awvalid[1]          ), // (output)
    .m01_axi4_awready               (m_axi4_awready[1]          ), // (input )

    .m01_axi4_wdata                 (m_axi4_wdata[1*32+:32]     ), // (output)
    .m01_axi4_wstrob                (m_axi4_wstrob[1*4+:4]      ), // (output)
    .m01_axi4_wlast                 (m_axi4_wlast[1]            ), // (output)
    .m01_axi4_wvalid                (m_axi4_wvalid[1]           ), // (output)
    .m01_axi4_wready                (m_axi4_wready[1]           ), // (input )

    .m01_axi4_bid                   (m_axi4_bid[1*4+:4]         ), // (input )
    .m01_axi4_bresp                 (m_axi4_bresp[1*2+:2]       ), // (input )
    .m01_axi4_bvalid                (m_axi4_bvalid[1]           ), // (input )
    .m01_axi4_bready                (m_axi4_bready[1]           ), // (output)


    .m02_axi4_clk                   (clk_sys[2]                 ), // (input )
    .m02_axi4_arid                  (m_axi4_arid[2*4+:4]        ), // (output)
    .m02_axi4_araddr                (m_axi4_araddr[2*32+:32]    ), // (output)
    .m02_axi4_arlen                 (m_axi4_arlen[2*8+:8]       ), // (output)
    .m02_axi4_arsize                (m_axi4_arsize[2*3+:3]      ), // (output)
    .m02_axi4_arburst               (m_axi4_arburst[2*2+:2]     ), // (output)
    .m02_axi4_arregion              (                           ), // (output)
    .m02_axi4_arlock                (                           ), // (output)
    .m02_axi4_arcache               (                           ), // (output)
    .m02_axi4_arprot                (                           ), // (output)
    .m02_axi4_arqos                 (                           ), // (output)
    .m02_axi4_arvalid               (m_axi4_arvalid[2]          ), // (output)
    .m02_axi4_arready               (m_axi4_arready[2]          ), // (input )
                                                               
    .m02_axi4_rid                   (m_axi4_rid[2*4+:4]         ), // (input )
    .m02_axi4_rdata                 (m_axi4_rdata[2*32+:32]     ), // (input )
    .m02_axi4_rresp                 (m_axi4_rresp[2*2+:2]       ), // (input )
    .m02_axi4_rlast                 (m_axi4_rlast[2]            ), // (input )
    .m02_axi4_rvalid                (m_axi4_rvalid[2]           ), // (input )
    .m02_axi4_rready                (m_axi4_rready[2]           ), // (output)
                                                               
    .m02_axi4_awid                  (m_axi4_awid[2*4+:4]        ), // (output)
    .m02_axi4_awaddr                (m_axi4_awaddr[2*32+:32]    ), // (output)
    .m02_axi4_awlen                 (m_axi4_awlen[2*8+:8]       ), // (output)
    .m02_axi4_awsize                (m_axi4_awsize[2*3+:3]      ), // (output)
    .m02_axi4_awburst               (m_axi4_awburst[2*2+:2]     ), // (output)
    .m02_axi4_awregion              (                           ), // (output)
    .m02_axi4_awlock                (                           ), // (output)
    .m02_axi4_awcache               (                           ), // (output)
    .m02_axi4_awprot                (                           ), // (output)
    .m02_axi4_awqos                 (                           ), // (output)
    .m02_axi4_awvalid               (m_axi4_awvalid[2]          ), // (output)
    .m02_axi4_awready               (m_axi4_awready[2]          ), // (input )
                                                               
    .m02_axi4_wdata                 (m_axi4_wdata[2*32+:32]     ), // (output)
    .m02_axi4_wstrob                (m_axi4_wstrob[2*4+:4]      ), // (output)
    .m02_axi4_wlast                 (m_axi4_wlast[2]            ), // (output)
    .m02_axi4_wvalid                (m_axi4_wvalid[2]           ), // (output)
    .m02_axi4_wready                (m_axi4_wready[2]           ), // (input )
                                                               
    .m02_axi4_bid                   (m_axi4_bid[2*4+:4]         ), // (input )
    .m02_axi4_bresp                 (m_axi4_bresp[2*2+:2]       ), // (input )
    .m02_axi4_bvalid                (m_axi4_bvalid[2]           ), // (input )
    .m02_axi4_bready                (m_axi4_bready[2]           ), // (output)


    .m03_axi4_clk                   (clk_sys[3]                 ), // (input )
    .m03_axi4_arid                  (m_axi4_arid[3*4+:4]        ), // (output)
    .m03_axi4_araddr                (m_axi4_araddr[3*32+:32]    ), // (output)
    .m03_axi4_arlen                 (m_axi4_arlen[3*8+:8]       ), // (output)
    .m03_axi4_arsize                (m_axi4_arsize[3*3+:3]      ), // (output)
    .m03_axi4_arburst               (m_axi4_arburst[3*2+:2]     ), // (output)
    .m03_axi4_arregion              (                           ), // (output)
    .m03_axi4_arlock                (                           ), // (output)
    .m03_axi4_arcache               (                           ), // (output)
    .m03_axi4_arprot                (                           ), // (output)
    .m03_axi4_arqos                 (                           ), // (output)
    .m03_axi4_arvalid               (m_axi4_arvalid[3]          ), // (output)
    .m03_axi4_arready               (m_axi4_arready[3]          ), // (input )
                                                               
    .m03_axi4_rid                   (m_axi4_rid[3*4+:4]         ), // (input )
    .m03_axi4_rdata                 (m_axi4_rdata[3*32+:32]     ), // (input )
    .m03_axi4_rresp                 (m_axi4_rresp[3*2+:2]       ), // (input )
    .m03_axi4_rlast                 (m_axi4_rlast[3]            ), // (input )
    .m03_axi4_rvalid                (m_axi4_rvalid[3]           ), // (input )
    .m03_axi4_rready                (m_axi4_rready[3]           ), // (output)
                                                               
    .m03_axi4_awid                  (m_axi4_awid[3*4+:4]        ), // (output)
    .m03_axi4_awaddr                (m_axi4_awaddr[3*32+:32]    ), // (output)
    .m03_axi4_awlen                 (m_axi4_awlen[3*8+:8]       ), // (output)
    .m03_axi4_awsize                (m_axi4_awsize[3*3+:3]      ), // (output)
    .m03_axi4_awburst               (m_axi4_awburst[3*2+:2]     ), // (output)
    .m03_axi4_awregion              (                           ), // (output)
    .m03_axi4_awlock                (                           ), // (output)
    .m03_axi4_awcache               (                           ), // (output)
    .m03_axi4_awprot                (                           ), // (output)
    .m03_axi4_awqos                 (                           ), // (output)
    .m03_axi4_awvalid               (m_axi4_awvalid[3]          ), // (output)
    .m03_axi4_awready               (m_axi4_awready[3]          ), // (input )
                                                               
    .m03_axi4_wdata                 (m_axi4_wdata[3*32+:32]     ), // (output)
    .m03_axi4_wstrob                (m_axi4_wstrob[3*4+:4]      ), // (output)
    .m03_axi4_wlast                 (m_axi4_wlast[3]            ), // (output)
    .m03_axi4_wvalid                (m_axi4_wvalid[3]           ), // (output)
    .m03_axi4_wready                (m_axi4_wready[3]           ), // (input )
                                                               
    .m03_axi4_bid                   (m_axi4_bid[3*4+:4]         ), // (input )
    .m03_axi4_bresp                 (m_axi4_bresp[3*2+:2]       ), // (input )
    .m03_axi4_bvalid                (m_axi4_bvalid[3]           ), // (input )
    .m03_axi4_bready                (m_axi4_bready[3]           )  // (output)
);

generate
for(i=0;i<4;i=i+1)begin:ram_loop
AXI4_BRAM U0_AXI4_BRAM
(
    .s_aclk                         (clk_sys[i]                 ), // input wire s_aclk
    .s_aresetn                      (rst_n                      ), // input wire s_aresetn
    .s_axi_awid                     (m_axi4_awid[i*4+:4]        ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr                   ({16'd0,m_axi4_awaddr[i*32+:16]}), // input wire [31 : 0] s_axi_awaddr
    .s_axi_awlen                    (m_axi4_awlen[i*8+:8]       ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize                   (m_axi4_awsize[i*3+:3]      ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst                  (m_axi4_awburst[i*2+:2]     ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awvalid                  (m_axi4_awvalid[i]          ), // input wire s_axi_awvalid
    .s_axi_awready                  (m_axi4_awready[i]          ), // output wire s_axi_awready
    .s_axi_wdata                    (m_axi4_wdata[i*128+:128]   ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb                    (m_axi4_wstrob[i*16+:16]    ), // input wire [3 : 0] s_axi_wstrb
    .s_axi_wlast                    (m_axi4_wlast[i]            ), // input wire s_axi_wlast
    .s_axi_wvalid                   (m_axi4_wvalid[i]           ), // input wire s_axi_wvalid
    .s_axi_wready                   (m_axi4_wready[i]           ), // output wire s_axi_wready
    .s_axi_bid                      (m_axi4_bid[i*4+:4]         ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp                    (m_axi4_bresp[i*2+:2]       ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid                   (m_axi4_bvalid[i]           ), // output wire s_axi_bvalid
    .s_axi_bready                   (m_axi4_bready[i]           ), // input wire s_axi_bready
    .s_axi_arid                     (m_axi4_arid[i*4+:4]        ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr                   ({16'd0,m_axi4_araddr[i*32+:16]}), // input wire [31 : 0] s_axi_araddr
    .s_axi_arlen                    (m_axi4_arlen[i*8+:8]       ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize                   (m_axi4_arsize[i*3+:3]      ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst                  (m_axi4_arburst[i*2+:2]     ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arvalid                  (m_axi4_arvalid[i]          ), // input wire s_axi_arvalid
    .s_axi_arready                  (m_axi4_arready[i]          ), // output wire s_axi_arready
    .s_axi_rid                      (m_axi4_rid[i*4+:4]         ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata                    (m_axi4_rdata[i*128+:128]   ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                    (m_axi4_rresp[i*2+:2]       ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                    (m_axi4_rlast[i]            ), // output wire s_axi_rlast
    .s_axi_rvalid                   (m_axi4_rvalid[i]           ), // output wire s_axi_rvalid
    .s_axi_rready                   (m_axi4_rready[i]           ), // input wire s_axi_rready
    .rsta_busy                      (                           ), // output wire rsta_busy
    .rstb_busy                      (                           )  // output wire rstb_busy
);
end
endgenerate


endmodule





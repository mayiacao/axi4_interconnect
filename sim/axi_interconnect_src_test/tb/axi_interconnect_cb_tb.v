// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/19 09:22:21
// File Name    : axi_interconnect_cb_tb.v
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
// axi_interconnect_cb_tb
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_cb_tb #
(
    parameter                           U_DLY = 1                     // 
);

localparam [4*32-1:0] ADDR_BASE = {32'h8003_0000,
                                   32'h8002_0000,
                                   32'h8001_0000,
                                   32'h8000_0000};

localparam [4*32-1:0] ADDR_HIGH = {32'h8003_ffff,
                                   32'h8002_ffff,
                                   32'h8001_ffff,
                                   32'h8000_ffff};

reg                               [3:0] clk_sys                     ; 
reg                                     rst_n                       ; 

reg                        [256*128-1:0] axi_wrmem                  ; 

wire                              [3:0] axi4_s0_awid                ; 
wire                           [32-1:0] axi4_s0_awaddr              ; 
wire                            [8-1:0] axi4_s0_awlen               ; 
wire                            [3-1:0] axi4_s0_awsize              ; 
wire                            [2-1:0] axi4_s0_awburst             ; 
wire                                    axi4_s0_awvalid             ; 
wire                                    axi4_s0_awready             ; 

wire                          [128-1:0] axi4_s0_wdata               ; 
wire                           [16-1:0] axi4_s0_wstrb               ; 
wire                                    axi4_s0_wlast               ; 
wire                                    axi4_s0_wvalid              ; 
wire                                    axi4_s0_wready              ; 

wire                            [2-1:0] axi4_s0_bresp               ; 
wire                                    axi4_s0_bvalid              ; 
wire                                    axi4_s0_bready              ; 

wire                            [4-1:0] axi4_s0_arid                ; 
wire                           [32-1:0] axi4_s0_araddr              ; 
wire                            [8-1:0] axi4_s0_arlen               ; 
wire                            [3-1:0] axi4_s0_arsize              ; 
wire                            [2-1:0] axi4_s0_arburst             ; 
wire                                    axi4_s0_arvalid             ; 
wire                                    axi4_s0_arready             ; 

wire                          [128-1:0] axi4_s0_rdata               ; 
wire                            [2-1:0] axi4_s0_rresp               ; 
wire                                    axi4_s0_rlast               ; 
wire                                    axi4_s0_rvalid              ; 
wire                                    axi4_s0_rready              ; 

//wire                              [3:0] axi4_s1_awid                ; 
//wire                           [32-1:0] axi4_s1_awaddr              ; 
//wire                            [8-1:0] axi4_s1_awlen               ; 
//wire                            [3-1:0] axi4_s1_awsize              ; 
//wire                            [2-1:0] axi4_s1_awburst             ; 
//wire                                    axi4_s1_awvalid             ; 
//wire                                    axi4_s1_awready             ; 
//
//wire                           [32-1:0] axi4_s1_wdata               ; 
//wire                            [4-1:0] axi4_s1_wstrb               ; 
//wire                                    axi4_s1_wlast               ; 
//wire                                    axi4_s1_wvalid              ; 
//wire                                    axi4_s1_wready              ; 
//
//wire                            [2-1:0] axi4_s1_bresp               ; 
//wire                                    axi4_s1_bvalid              ; 
//wire                                    axi4_s1_bready              ; 
//
//wire                            [4-1:0] axi4_s1_arid                ; 
//wire                           [32-1:0] axi4_s1_araddr              ; 
//wire                            [8-1:0] axi4_s1_arlen               ; 
//wire                            [3-1:0] axi4_s1_arsize              ; 
//wire                            [2-1:0] axi4_s1_arburst             ; 
//wire                                    axi4_s1_arvalid             ; 
//wire                                    axi4_s1_arready             ; 
//
//wire                           [32-1:0] axi4_s1_rdata               ; 
//wire                            [2-1:0] axi4_s1_rresp               ; 
//wire                                    axi4_s1_rlast               ; 
//wire                                    axi4_s1_rvalid              ; 
//wire                                    axi4_s1_rready              ; 


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
wire                         [4*32-1:0] m_axi4_rdata                ; 
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
wire                         [4*32-1:0] m_axi4_wdata                ; 
wire                          [4*4-1:0] m_axi4_wstrob               ; 
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


initial begin
    clk_sys = 0;
    rst_n = 0;

    # 200 rst_n = 1;
end

always #5 clk_sys[0] = ~clk_sys[0];
always #6 clk_sys[1] = ~clk_sys[1];
always #7 clk_sys[2] = ~clk_sys[2];
always #4 clk_sys[3] = ~clk_sys[3];


initial begin
    
    axi_wrmem[0*32+:32] = 32'h1111_1111; //sleep time ->3*2048;
    axi_wrmem[1*32+:32] = 32'h2222_2222;
    axi_wrmem[2*32+:32] = 32'h3333_3333; //sleep time ->3*2048;
    axi_wrmem[3*32+:32] = 32'h4444_4444; 
    axi_wrmem[4*32+:32] = 32'h5555_5555; //linepb->0,rfnum->NUM_RF_LENGTH;
    axi_wrmem[5*32+:32] = 32'h6666_6666; //feof -> 1;
    axi_wrmem[6*32+:32] = 32'h7777_7777; 
    axi_wrmem[7*32+:32] = 32'h8888_8888; 
    axi_wrmem[8*32+:32] = 32'h9999_9999; 
    axi_wrmem[9*32+:32] = 32'h0000_8888; 
    axi_wrmem[10*32+:32] = 32'haaaa_aaaa; 
    axi_wrmem[11*32+:32] = 32'hbbbb_bbbb; 
    axi_wrmem[12*32+:32] = 32'hcccc_cccc; 
    axi_wrmem[13*32+:32] = 32'hdddd_dddd; 
    axi_wrmem[14*32+:32] = 32'heeee_eeee; 
    axi_wrmem[15*32+:32] = 32'hffff_ffff; 

    #1000;
    axi_wrmem[0*32+:32] = 32'h1111_1111; //sleep time ->3*2048;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0000,8'd1,3'h2);
    axi_wrmem[0*32+:32] = 32'h2222_2222;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0004,8'd0,3'h2);
     axi_wrmem[0*32+:32] = 32'h3333_3333; //sleep time ->3*2048;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0008,8'd0,3'h2);
     axi_wrmem[0*32+:32] = 32'h4444_4444;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_000c,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'h5555_5555; //linepb->0,rfnum->NUM_RF_LENGTH;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0010,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'h6666_6666; //feof -> 1;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0014,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'h7777_7777; 
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0018,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'h8888_8888;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_001c,8'd0,3'h2);
     axi_wrmem[0*32+:32] = 32'h9999_9999; 
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0020,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'haaaa_aaaa; 
    u0_axi4_mdl.axi4_write('h2,2'b1,32'h8003_0024,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'hbbbb_bbbb; 
    u0_axi4_mdl.axi4_write('h3,2'b1,32'h8003_0028,8'd0,3'h2);
    axi_wrmem[0*32+:32] = 32'hcccc_cccc; 
    u0_axi4_mdl.axi4_write('h4,2'b1,32'h8003_002c,8'd0,3'h2);

    u0_axi4_mdl.axi4_write('h10,2'b1,32'h8000_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_write('h10,2'b1,32'h8001_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_write('h10,2'b1,32'h8002_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_write('h10,2'b1,32'h8003_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_read('h10,2'b1,32'h8000_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_read('h10,2'b1,32'h8001_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_read('h10,2'b1,32'h8002_0040,8'd2,3'h4);
    u0_axi4_mdl.axi4_read('h10,2'b1,32'h8003_0040,8'd2,3'h4);


#10000;

    u0_axi4_mdl.axi4_read('h4,2'b1,32'h8003_0000,8'd15,3'h2);

end

//initial begin
//    #1000;
//    u1_axi4_mdl.axi4_write('h10,2'b1,32'h4000_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_write('h10,2'b1,32'h4001_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_write('h10,2'b1,32'h4002_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_write('h10,2'b1,32'h4003_0040,8'd5,3'h2);
//
//#10000;
//    u1_axi4_mdl.axi4_read('h10,2'b1,32'h4000_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_read('h10,2'b1,32'h4001_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_read('h10,2'b1,32'h4002_0040,8'd5,3'h2);
//    u1_axi4_mdl.axi4_read('h10,2'b1,32'h4003_0040,8'd5,3'h2);
//
//end

axi4_mdl #
(
    .IDW                            (4                          ), 
    .DW                             (128                        ), 
    .DEW                            (16                         ), 
    .AW                             (32                         ), 
    .MAX_BURST_LEN                  (256                        ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_axi4_mdl
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_axi                        (clk_sys[0]                 ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// User Data
// ---------------------------------------------------------------------------------
    .axi_wrmem                      (axi_wrmem                  ), // (input )
// ---------------------------------------------------------------------------------
// AXI4
// ---------------------------------------------------------------------------------
    .axi4_awid                      (axi4_s0_awid                  ), // (output)
    .axi4_awaddr                    (axi4_s0_awaddr                ), // (output)
    .axi4_awlen                     (axi4_s0_awlen[8-1:0]          ), // (output)
    .axi4_awsize                    (axi4_s0_awsize[3-1:0]         ), // (output)
    .axi4_awburst                   (axi4_s0_awburst[2-1:0]        ), // (output)
    .axi4_awvalid                   (axi4_s0_awvalid               ), // (output)
    .axi4_awready                   (axi4_s0_awready               ), // (input )
                                             
    .axi4_wdata                     (axi4_s0_wdata                 ), // (output)
    .axi4_wstrb                     (axi4_s0_wstrb                 ), // (output)
    .axi4_wlast                     (axi4_s0_wlast                 ), // (output)
    .axi4_wvalid                    (axi4_s0_wvalid                ), // (output)
    .axi4_wready                    (axi4_s0_wready                ), // (input )
                                             
    .axi4_bresp                     (axi4_s0_bresp[2-1:0]          ), // (input )
    .axi4_bvalid                    (axi4_s0_bvalid                ), // (input )
    .axi4_bready                    (axi4_s0_bready                ), // (output)
                                           
    .axi4_arid                      (axi4_s0_arid                  ), // (output)
    .axi4_araddr                    (axi4_s0_araddr                ), // (output)
    .axi4_arlen                     (axi4_s0_arlen[8-1:0]          ), // (output)
    .axi4_arsize                    (axi4_s0_arsize[3-1:0]         ), // (output)
    .axi4_arburst                   (axi4_s0_arburst[2-1:0]        ), // (output)
    .axi4_arvalid                   (axi4_s0_arvalid               ), // (output)
    .axi4_arready                   (axi4_s0_arready               ), // (input )
                                             
    .axi4_rdata                     (axi4_s0_rdata                 ), // (input )
    .axi4_rresp                     (axi4_s0_rresp[2-1:0]          ), // (input )
    .axi4_rlast                     (axi4_s0_rlast                 ), // (input )
    .axi4_rvalid                    (axi4_s0_rvalid                ), // (input )
    .axi4_rready                    (axi4_s0_rready                )  // (output)
);

//axi4_mdl #
//(
//    .IDW                            (5                          ), 
//    .DW                             (32                         ), 
//    .DEW                            (4                          ), 
//    .AW                             (32                         ), 
//    .MAX_BURST_LEN                  (256                        ), 
//    .U_DLY                          (U_DLY                      )  // 
//)
//u1_axi4_mdl
//(
//// ---------------------------------------------------------------------------------
//// CLock & Reset
//// ---------------------------------------------------------------------------------
//    .clk_axi                        (clk_sys                    ), // (input )
//    .rst_n                          (rst_n                      ), // (input )
//// ---------------------------------------------------------------------------------
//// User Data
//// ---------------------------------------------------------------------------------
//    .axi_wrmem                      (axi_wrmem                  ), // (input )
//// ---------------------------------------------------------------------------------
//// AXI4
//// ---------------------------------------------------------------------------------
//    .axi4_awid                      (axi4_s1_awid                  ), // (output)
//    .axi4_awaddr                    (axi4_s1_awaddr                ), // (output)
//    .axi4_awlen                     (axi4_s1_awlen[8-1:0]          ), // (output)
//    .axi4_awsize                    (axi4_s1_awsize[3-1:0]         ), // (output)
//    .axi4_awburst                   (axi4_s1_awburst[2-1:0]        ), // (output)
//    .axi4_awvalid                   (axi4_s1_awvalid               ), // (output)
//    .axi4_awready                   (axi4_s1_awready               ), // (input )
//                                            
//    .axi4_wdata                     (axi4_s1_wdata                 ), // (output)
//    .axi4_wstrb                     (axi4_s1_wstrb                 ), // (output)
//    .axi4_wlast                     (axi4_s1_wlast                 ), // (output)
//    .axi4_wvalid                    (axi4_s1_wvalid                ), // (output)
//    .axi4_wready                    (axi4_s1_wready                ), // (input )
//                                            
//    .axi4_bresp                     (axi4_s1_bresp[2-1:0]          ), // (input )
//    .axi4_bvalid                    (axi4_s1_bvalid                ), // (input )
//    .axi4_bready                    (axi4_s1_bready                ), // (output)
//                                           
//    .axi4_arid                      (axi4_s1_arid                  ), // (output)
//    .axi4_araddr                    (axi4_s1_araddr                ), // (output)
//    .axi4_arlen                     (axi4_s1_arlen[8-1:0]          ), // (output)
//    .axi4_arsize                    (axi4_s1_arsize[3-1:0]         ), // (output)
//    .axi4_arburst                   (axi4_s1_arburst[2-1:0]        ), // (output)
//    .axi4_arvalid                   (axi4_s1_arvalid               ), // (output)
//    .axi4_arready                   (axi4_s1_arready               ), // (input )
//
//    .axi4_rdata                     (axi4_s1_rdata                 ), // (input )
//    .axi4_rresp                     (axi4_s1_rresp[2-1:0]          ), // (input )
//    .axi4_rlast                     (axi4_s1_rlast                 ), // (input )
//    .axi4_rvalid                    (axi4_s1_rvalid                ), // (input )
//    .axi4_rready                    (axi4_s1_rready                )  // (output)
//);

axi_interconnect_crossbar #
(
    .NUM_SLAVE                      (1                          ), // 0 ~ 4
    .NUM_MASTER                     (4                          ), // 0 ~ 4
    .WIDTH_ID                       (4                          ), 
    .WIDTH_ADDR                     (32                         ), 
    .WIDTH_DATA                     (128                        ), 
    .WIDTH_AWUSER                   (0                          ), 
    .WIDTH_ARUSER                   (0                          ), 
    .WIDTH_WUSER                    (0                          ), 
    .WIDTH_RUSER                    (0                          ), 
    .WIDTH_BUSER                    (0                          ), 
    .NUM_OUTSTANDING                (16                         ), 
    .ADDR_BASE                      (ADDR_BASE                  ), 
    .ADDR_HIGH                      (ADDR_HIGH                  ), 
    .HAS_LOCK                       (0                          ), 
    .HAS_CACHE                      (0                          ), 
    .HAS_PROT                       (0                          ), 
    .HAS_QOS                        (0                          ), 
    .HAS_REGION                     (0                          ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_crossbar
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (axi4_s0_arid               ), // (input )               
    .s_axi4_araddr                  (axi4_s0_araddr             ), // (input )             
    .s_axi4_arlen                   (axi4_s0_arlen              ), // (input ) [8-1:0]      
    .s_axi4_arsize                  (axi4_s0_arsize             ), // (input ) [3-1:0]     
    .s_axi4_arburst                 (axi4_s0_arburst            ), // (input ) [2-1:0]    
    .s_axi4_arregion                ('d0                        ), // (input )            
    .s_axi4_arlock                  ('d0                        ), // (input )            
    .s_axi4_arcache                 ('d0                        ), // (input )         
    .s_axi4_arprot                  ('d0                        ), // (input )              
    .s_axi4_arqos                   ('d0                        ), // (input )              
    .s_axi4_aruser                  ('d0                        ), // (input )              
    .s_axi4_arvalid                 (axi4_s0_arvalid            ), // (input )             
    .s_axi4_arready                 (axi4_s0_arready            ), // (output)             
                                                                                       
    .s_axi4_rid                     (                           ), // (output) [2-1:0]      
    .s_axi4_rdata                   (axi4_s0_rdata              ), // (output)             
    .s_axi4_rresp                   (axi4_s0_rresp              ), // (output)             
    .s_axi4_rlast                   (axi4_s0_rlast              ), // (output)       
    .s_axi4_ruser                   (                           ), // (output)               
    .s_axi4_rvalid                  (axi4_s0_rvalid             ), // (output)             
    .s_axi4_rready                  (axi4_s0_rready             ), // (input ) [8-1:0]      
                                                                              
    .s_axi4_awid                    (axi4_s0_awid               ), // (input ) [2-1:0]    
    .s_axi4_awaddr                  (axi4_s0_awaddr             ), // (input )            
    .s_axi4_awlen                   (axi4_s0_awlen              ), // (input )            
    .s_axi4_awsize                  (axi4_s0_awsize             ), // (input )         
    .s_axi4_awburst                 (axi4_s0_awburst            ), // (input )              
    .s_axi4_awregion                ('d0                        ), // (input ) [2-1:0]      
    .s_axi4_awlock                  ('d0                        ), // (input )              
    .s_axi4_awcache                 ('d0                        ), // (input )             
    .s_axi4_awprot                  ('d0                        ), // (input )             
    .s_axi4_awqos                   ('d0                        ), // (input )
    .s_axi4_awuser                  ('d0                        ), // (input )
    .s_axi4_awvalid                 (axi4_s0_awvalid            ), // (input )
    .s_axi4_awready                 (axi4_s0_awready            ), // (output)

    .s_axi4_wid                     ('d0                        ), // (input )
    .s_axi4_wdata                   (axi4_s0_wdata              ), // (input )
    .s_axi4_wstrob                  (axi4_s0_wstrb              ), // (input )
    .s_axi4_wlast                   (axi4_s0_wlast              ), // (input )
    .s_axi4_wuser                   ('d0                        ), // (input )
    .s_axi4_wvalid                  (axi4_s0_wvalid             ), // (input )
    .s_axi4_wready                  (axi4_s0_wready             ), // (output)

    .s_axi4_bid                     (                           ), // (output)
    .s_axi4_bresp                   (axi4_s0_bresp              ), // (output)
    .s_axi4_buser                   (                           ), // (output)
    .s_axi4_bvalid                  (axi4_s0_bvalid             ), // (output)
    .s_axi4_bready                  (axi4_s0_bready             ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m_axi4_arid                ), // (output)
    .m_axi4_araddr                  (m_axi4_araddr              ), // (output)
    .m_axi4_arlen                   (m_axi4_arlen               ), // (output)
    .m_axi4_arsize                  (m_axi4_arsize              ), // (output)
    .m_axi4_arburst                 (m_axi4_arburst             ), // (output)
    .m_axi4_arregion                (m_axi4_arion               ), // (output)
    .m_axi4_arlock                  (m_axi4_arlock              ), // (output)
    .m_axi4_arcache                 (m_axi4_arcache             ), // (output)
    .m_axi4_arprot                  (m_axi4_arprot              ), // (output)
    .m_axi4_arqos                   (m_axi4_arqos               ), // (output)
    .m_axi4_aruser                  (m_axi4_aruser              ), // (output)
    .m_axi4_arvalid                 (m_axi4_arvalid             ), // (output)
    .m_axi4_arready                 (m_axi4_arready             ), // (input )
                                                      
    .m_axi4_rid                     (m_axi4_rid                 ), // (input )
    .m_axi4_rdata                   (m_axi4_rdata               ), // (input )
    .m_axi4_rresp                   (m_axi4_rresp               ), // (input )
    .m_axi4_rlast                   (m_axi4_rlast               ), // (input )
    .m_axi4_ruser                   (m_axi4_ruser               ), // (input )
    .m_axi4_rvalid                  (m_axi4_rvalid              ), // (input )
    .m_axi4_rready                  (m_axi4_rready              ), // (output)
                                                      
    .m_axi4_awid                    (m_axi4_awid                ), // (output)
    .m_axi4_awaddr                  (m_axi4_awaddr              ), // (output)
    .m_axi4_awlen                   (m_axi4_awlen               ), // (output)
    .m_axi4_awsize                  (m_axi4_awsize              ), // (output)
    .m_axi4_awburst                 (m_axi4_awburst             ), // (output)
    .m_axi4_awregion                (m_axi4_awion               ), // (output)
    .m_axi4_awlock                  (m_axi4_awlock              ), // (output)
    .m_axi4_awcache                 (m_axi4_awcache             ), // (output)
    .m_axi4_awprot                  (m_axi4_awprot              ), // (output)
    .m_axi4_awqos                   (m_axi4_awqos               ), // (output)
    .m_axi4_awuser                  (m_axi4_awuser              ), // (output)
    .m_axi4_awvalid                 (m_axi4_awvalid             ), // (output)
    .m_axi4_awready                 (m_axi4_awready             ), // (input )
                                                      
    .m_axi4_wid                     (m_axi4_wid                 ), // (output)
    .m_axi4_wdata                   (m_axi4_wdata               ), // (output)
    .m_axi4_wstrob                  (m_axi4_wstrob              ), // (output)
    .m_axi4_wlast                   (m_axi4_wlast               ), // (output)
    .m_axi4_wuser                   (m_axi4_wuser               ), // (output)
    .m_axi4_wvalid                  (m_axi4_wvalid              ), // (output)
    .m_axi4_wready                  (m_axi4_wready              ), // (input )
                                                      
    .m_axi4_bid                     (m_axi4_bid                 ), // (input )
    .m_axi4_bresp                   (m_axi4_bresp               ), // (input )
    .m_axi4_buser                   (m_axi4_buser               ), // (input )
    .m_axi4_bvalid                  (m_axi4_bvalid              ), // (input )
    .m_axi4_bready                  (m_axi4_bready              )  // (output)
);



generate
for(i=0;i<3;i=i+1)begin:ram_loop
AXI4_BRAM U0_AXI4_BRAM
(
    .s_aclk                         (clk_sys[0]                 ), // input wire s_aclk
    .s_aresetn                      (rst_n                      ), // input wire s_aresetn
    .s_axi_awid                     (m_axi4_awid[i*4+:4]        ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr                   ({16'd0,m_axi4_awaddr[i*32+:16]}), // input wire [31 : 0] s_axi_awaddr
    .s_axi_awlen                    (m_axi4_awlen[i*8+:8]       ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize                   (m_axi4_awsize[i*3+:3]      ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst                  (m_axi4_awburst[i*2+:2]     ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awvalid                  (m_axi4_awvalid[i]          ), // input wire s_axi_awvalid
    .s_axi_awready                  (m_axi4_awready[i]          ), // output wire s_axi_awready
    .s_axi_wdata                    (m_axi4_wdata[i*32+:32]     ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb                    (m_axi4_wstrob[i*4+:4]      ), // input wire [3 : 0] s_axi_wstrb
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
    .s_axi_rdata                    (m_axi4_rdata[i*32+:32]     ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                    (m_axi4_rresp[i*2+:2]       ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                    (m_axi4_rlast[i]            ), // output wire s_axi_rlast
    .s_axi_rvalid                   (m_axi4_rvalid[i]           ), // output wire s_axi_rvalid
    .s_axi_rready                   (m_axi4_rready[i]           ), // input wire s_axi_rready
    .rsta_busy                      (                           ), // output wire rsta_busy
    .rstb_busy                      (                           )  // output wire rstb_busy
);
end
endgenerate

axi4_wrrd_test #
(
    .IDW                            (4                          ), 
    .DW                             (32                         ), 
    .DEW                            (4                          ), 
    .AW                             (32                         ), 
    .MEM_AW                         (10                         ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi4_wrrd_test
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys[0]                 ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// AXI-4
// ---------------------------------------------------------------------------------
    .axi4_awid                      (m_axi4_awid[3*4+:4]        ), // (input )       
    .axi4_awaddr                    (m_axi4_awaddr[3*32+:32]    ), // (input ) 
    .axi4_awlen                     (m_axi4_awlen[3*8+:8]       ), // (input )        
    .axi4_awsize                    (m_axi4_awsize[3*3+:3]      ), // (input )    
    .axi4_awburst                   ( m_axi4_awburst[3*2+:2]    ), // (input )
    .axi4_awvalid                   (m_axi4_awvalid[3]          ), // (input )           
    .axi4_awready                   (m_axi4_awready[3]          ), // (output)      
                                                                                   
    .axi4_wdata                     (m_axi4_wdata[3*32+:32]     ), // (input )       
    .axi4_wstrb                     (m_axi4_wstrob[3*4+:4]      ), // (input )          
    .axi4_wlast                     (m_axi4_wlast[3]            ), // (input )        
    .axi4_wvalid                    (m_axi4_wvalid[3]           ), // (input )        
    .axi4_wready                    (m_axi4_wready[3]           ), // (output)       
                                                                                    
    .axi4_bresp                     (m_axi4_bresp[3*2+:2]       ), // (output)            
    .axi4_bvalid                    (m_axi4_bvalid[3]           ), // (output)       
    .axi4_bready                    (m_axi4_bready[3]           ), // (input )        
                                                                       
    .axi4_arid                      (m_axi4_arid[3*4+:4]        ), // (input )    
    .axi4_araddr                    (m_axi4_araddr[3*32+:32]    ), // (input )  
    .axi4_arlen                     (m_axi4_arlen[3*8+:8]       ), // (input ) 
    .axi4_arsize                    (m_axi4_arsize[3*3+:3]      ), // (input )       
    .axi4_arburst                   (m_axi4_arburst[3*2+:2]     ), // (input )          
    .axi4_arvalid                   (m_axi4_arvalid[3]          ), // (input )          
    .axi4_arready                   (m_axi4_arready[3]          ), // (output)    
                                                                                      
    .axi4_rdata                     (m_axi4_rdata[3*32+:32]     ), // (output)             
    .axi4_rresp                     (m_axi4_rresp[3*2+:2]       ), // (output)           
    .axi4_rlast                     (m_axi4_rlast[3]            ), // (output)            
    .axi4_rvalid                    (m_axi4_rvalid[3]           ), // (output)
    .axi4_rready                    (m_axi4_rready[3]           )  // (input )
);

endmodule






// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/23 11:23:47
// File Name    : axi_interconnect_tb.v
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
// axi_interconnect_tb
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_tb #
(
    parameter                           U_DLY = 1                     // 
);

localparam [4*32-1:0] ADDR_BASE = {32'h8000_0000,
                                   32'h8001_0000,
                                   32'h8002_0000,
                                   32'h8003_0000};

localparam [4*32-1:0] ADDR_HIGH = {32'h8000_ffff,
                                   32'h8001_ffff,
                                   32'h8002_ffff,
                                   32'h8003_ffff};

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

wire                            [4-1:0] axi4_s0_bid                 ; 
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

wire                            [4-1:0] axi4_s0_rid                 ; 
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


initial begin
    clk_sys = 0;
    rst_n = 0;

    # 200 rst_n = 1;
end

always #5 clk_sys[0] = ~clk_sys[0];
always #6 clk_sys[1] = ~clk_sys[1];
always #7 clk_sys[2] = ~clk_sys[2];
always #4 clk_sys[3] = ~clk_sys[3];

integer m;

initial begin
    
    for (m=0;m<2048;m=m+1) begin
        axi_wrmem[m*32+:32] = {m[15:0],m[15:0]};
    end
    #1000;
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8000_0008,8'd1,3'h3);
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8003_0008,8'd1,3'h3);
    u0_axi4_mdl.axi4_write('h2,2'b1,32'h8000_0010,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h2,2'b1,32'h8003_0010,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h3,2'b1,32'h8000_0018,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h3,2'b1,32'h8003_0018,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h4,2'b1,32'h8000_001c,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h4,2'b1,32'h8003_001c,8'd0,3'h3);
    u0_axi4_mdl.axi4_write('h5,2'b1,32'h8000_0020,8'd0,3'h2);
    u0_axi4_mdl.axi4_write('h5,2'b1,32'h8003_0020,8'd0,3'h2);
    u0_axi4_mdl.axi4_write('h6,2'b1,32'h8000_0028,8'd0,3'h1);
    u0_axi4_mdl.axi4_write('h6,2'b1,32'h8003_0028,8'd0,3'h1);
    u0_axi4_mdl.axi4_write('h7,2'b1,32'h8000_002c,8'd0,3'h0);
    u0_axi4_mdl.axi4_write('h7,2'b1,32'h8003_002c,8'd0,3'h0);

    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8000_0000,8'hff,3'h3);
    u0_axi4_mdl.axi4_write('h2,2'b1,32'h8003_0000,8'hff,3'h3);
    u0_axi4_mdl.axi4_write('h1,2'b1,32'h8000_0010,8'h10,3'h3);
    u0_axi4_mdl.axi4_write('h2,2'b1,32'h8003_0010,8'h10,3'h3);
    #10000;
    u0_axi4_mdl.axi4_read('h1,2'b1,32'h8000_0000,8'hff,3'h2);
    u0_axi4_mdl.axi4_read('h2,2'b1,32'h8003_0000,8'hff,3'h2);
    u0_axi4_mdl.axi4_read('h1,2'b1,32'h8000_0010,8'h10,3'h2);
    u0_axi4_mdl.axi4_read('h2,2'b1,32'h8003_0010,8'h10,3'h2);

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
    .DW                             (64                         ), 
    .DEW                            (8                          ), 
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


axi_interconnect # 
(
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys[0]                 ), // (input )
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
    .m00_axi4_arid                  (m_axi4_arid[0*4+:4]        ), // (output)
    .m00_axi4_araddr                (m_axi4_araddr[0*32+:32]    ), // (output)
    .m00_axi4_arlen                 (m_axi4_arlen[0*8+:8]       ), // (output)
    .m00_axi4_arsize                (m_axi4_arsize[0*3+:3]      ), // (output)
    .m00_axi4_arburst               (m_axi4_arburst[0*2+:2]     ), // (output)
    .m00_axi4_arregion              (                           ), // (output)
    .m00_axi4_arlock                (                           ), // (output)
    .m00_axi4_arcache               (                           ), // (output)
    .m00_axi4_arprot                (                           ), // (output)
    .m00_axi4_arqos                 (                           ), // (output)
    .m00_axi4_arvalid               (m_axi4_arvalid[0]          ), // (output)
    .m00_axi4_arready               (m_axi4_arready[0]          ), // (input )
                                                              
    .m00_axi4_rid                   (m_axi4_rid[0*4+:4]         ), // (input )
    .m00_axi4_rdata                 (m_axi4_rdata[0*128+:32]    ), // (input )
    .m00_axi4_rresp                 (m_axi4_rresp[0*2+:2]       ), // (input )
    .m00_axi4_rlast                 (m_axi4_rlast[0]            ), // (input )
    .m00_axi4_rvalid                (m_axi4_rvalid[0]           ), // (input )
    .m00_axi4_rready                (m_axi4_rready[0]           ), // (output)
                                                              
    .m00_axi4_awid                  (m_axi4_awid[0*4+:4]        ), // (output)
    .m00_axi4_awaddr                (m_axi4_awaddr[0*32+:32]    ), // (output)
    .m00_axi4_awlen                 (m_axi4_awlen[0*8+:8]       ), // (output)
    .m00_axi4_awsize                (m_axi4_awsize[0*3+:3]      ), // (output)
    .m00_axi4_awburst               (m_axi4_awburst[0*2+:2]     ), // (output)
    .m00_axi4_awregion              (                           ), // (output)
    .m00_axi4_awlock                (                           ), // (output)
    .m00_axi4_awcache               (                           ), // (output)
    .m00_axi4_awprot                (                           ), // (output)
    .m00_axi4_awqos                 (                           ), // (output)
    .m00_axi4_awvalid               (m_axi4_awvalid[0]          ), // (output)
    .m00_axi4_awready               (m_axi4_awready[0]          ), // (input )
                                                              
    .m00_axi4_wdata                 (m_axi4_wdata[0*128+:32]    ), // (output)
    .m00_axi4_wstrob                (m_axi4_wstrob[0*16+:4]     ), // (output)
    .m00_axi4_wlast                 (m_axi4_wlast[0]            ), // (output)
    .m00_axi4_wvalid                (m_axi4_wvalid[0]           ), // (output)
    .m00_axi4_wready                (m_axi4_wready[0]           ), // (input )
                                                              
    .m00_axi4_bid                   (m_axi4_bid[0*4+:4]         ), // (input )
    .m00_axi4_bresp                 (m_axi4_bresp[0*2+:2]       ), // (input )
    .m00_axi4_bvalid                (m_axi4_bvalid[0]           ), // (input )
    .m00_axi4_bready                (m_axi4_bready[0]           ), // (output)


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
    .m01_axi4_rdata                 (m_axi4_rdata[1*128+:32]    ), // (input )            
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

    .m01_axi4_wdata                 (m_axi4_wdata[1*128+:32]    ), // (output)
    .m01_axi4_wstrob                (m_axi4_wstrob[1*16+:4]     ), // (output)
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
    .m02_axi4_rdata                 (m_axi4_rdata[2*128+:128]   ), // (input )
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
                                                               
    .m02_axi4_wdata                 (m_axi4_wdata[2*128+:128]   ), // (output)
    .m02_axi4_wstrob                (m_axi4_wstrob[2*16+:16]    ), // (output)
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
    .m03_axi4_rdata                 (m_axi4_rdata[3*128+:128]   ), // (input )
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
                                                               
    .m03_axi4_wdata                 (m_axi4_wdata[3*128+:128]   ), // (output)
    .m03_axi4_wstrob                (m_axi4_wstrob[3*16+:16]    ), // (output)
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

if(i<2) begin:bit32_if

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
    .s_axi_wdata                    (m_axi4_wdata[i*128+:32]    ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb                    (m_axi4_wstrob[i*16+:4]     ), // input wire [3 : 0] s_axi_wstrb
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
    .s_axi_rdata                    (m_axi4_rdata[i*128+:32]    ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                    (m_axi4_rresp[i*2+:2]       ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                    (m_axi4_rlast[i]            ), // output wire s_axi_rlast
    .s_axi_rvalid                   (m_axi4_rvalid[i]           ), // output wire s_axi_rvalid
    .s_axi_rready                   (m_axi4_rready[i]           ), // input wire s_axi_rready
    .rsta_busy                      (                           ), // output wire rsta_busy
    .rstb_busy                      (                           )  // output wire rstb_busy
);
end else begin:bit128_if

AXI_BRAM1 U1_AXI4_BRAM_inst
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
end end
endgenerate


endmodule






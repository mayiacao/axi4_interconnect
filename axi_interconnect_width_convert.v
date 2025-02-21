// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/10 15:05:03
// File Name    : axi_interconnect_width_convert.v
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
// axi_interconnect_width_convert
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_width_convert #
(
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDR          = 32    ,
    parameter                           WIDTH_SDATA         = 64    ,
    parameter                           WIDTH_MDATA         = 32    ,
    parameter                           WIDTH_AWUSER        = 1     ,
    parameter                           WIDTH_ARUSER        = 1     ,
    parameter                           WIDTH_WUSER         = 1     ,
    parameter                           WIDTH_RUSER         = 1     ,
    parameter                           WIDTH_BUSER         = 1     ,
    parameter                           NUM_OUTSTANDING     = 4     ,

    parameter                           W_ID                = (WIDTH_ID > 0) ? WIDTH_ID : 'd1,
    parameter                           W_AWUSER            = (WIDTH_AWUSER > 0) ? WIDTH_AWUSER : 'd1,
    parameter                           W_ARUSER            = (WIDTH_ARUSER > 0) ? WIDTH_ARUSER : 'd1,
    parameter                           W_WUSER             = (WIDTH_WUSER > 0) ? WIDTH_WUSER : 'd1,
    parameter                           W_RUSER             = (WIDTH_RUSER > 0) ? WIDTH_RUSER : 'd1,
    parameter                           W_BUSER             = (WIDTH_BUSER > 0) ? WIDTH_BUSER : 'd1,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    input                    [W_ID-1:0] s_axi4_arid                 , 
    input              [WIDTH_ADDR-1:0] s_axi4_araddr               , 
    input                       [8-1:0] s_axi4_arlen                , 
    input                       [3-1:0] s_axi4_arsize               , 
    input                       [2-1:0] s_axi4_arburst              , 
    input                       [4-1:0] s_axi4_arregion             , 
    input                               s_axi4_arlock               , 
    input                       [4-1:0] s_axi4_arcache              , 
    input                       [3-1:0] s_axi4_arprot               , 
    input                       [4-1:0] s_axi4_arqos                , 
    input                [W_ARUSER-1:0] s_axi4_aruser               , 
    input                               s_axi4_arvalid              , 
    output                              s_axi4_arready              , 

    output                   [W_ID-1:0] s_axi4_rid                  , 
    output            [WIDTH_SDATA-1:0] s_axi4_rdata                , 
    output                      [2-1:0] s_axi4_rresp                , 
    output                              s_axi4_rlast                , 
    output                [W_RUSER-1:0] s_axi4_ruser                , 
    output                              s_axi4_rvalid               , 
    input                               s_axi4_rready               , 

    input                    [W_ID-1:0] s_axi4_awid                 , 
    input              [WIDTH_ADDR-1:0] s_axi4_awaddr               , 
    input                       [8-1:0] s_axi4_awlen                , 
    input                       [3-1:0] s_axi4_awsize               , 
    input                       [2-1:0] s_axi4_awburst              , 
    input                       [4-1:0] s_axi4_awregion             , 
    input                               s_axi4_awlock               , 
    input                       [4-1:0] s_axi4_awcache              , 
    input                       [3-1:0] s_axi4_awprot               , 
    input                       [4-1:0] s_axi4_awqos                , 
    input                [W_AWUSER-1:0] s_axi4_awuser               , 
    input                               s_axi4_awvalid              , 
    output                              s_axi4_awready              , 

    input             [WIDTH_SDATA-1:0] s_axi4_wdata                , 
    input           [WIDTH_SDATA/8-1:0] s_axi4_wstrob               , 
    input                               s_axi4_wlast                , 
    input                 [W_WUSER-1:0] s_axi4_wuser                , 
    input                               s_axi4_wvalid               , 
    output                              s_axi4_wready               , 

    output                   [W_ID-1:0] s_axi4_bid                  , 
    output                      [2-1:0] s_axi4_bresp                , 
    output                [W_BUSER-1:0] s_axi4_buser                , 
    output                              s_axi4_bvalid               , 
    input                               s_axi4_bready               , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    output                   [W_ID-1:0] m_axi4_arid                 , 
    output             [WIDTH_ADDR-1:0] m_axi4_araddr               , 
    output                      [8-1:0] m_axi4_arlen                , 
    output                      [3-1:0] m_axi4_arsize               , 
    output                      [2-1:0] m_axi4_arburst              , 
    output                      [4-1:0] m_axi4_arregion             , 
    output                              m_axi4_arlock               , 
    output                      [4-1:0] m_axi4_arcache              , 
    output                      [3-1:0] m_axi4_arprot               , 
    output                      [4-1:0] m_axi4_arqos                , 
    output               [W_ARUSER-1:0] m_axi4_aruser               , 
    output                              m_axi4_arvalid              , 
    input                               m_axi4_arready              , 

    input                    [W_ID-1:0] m_axi4_rid                  , 
    input             [WIDTH_MDATA-1:0] m_axi4_rdata                , 
    input                       [2-1:0] m_axi4_rresp                , 
    input                               m_axi4_rlast                , 
    input                 [W_RUSER-1:0] m_axi4_ruser                , 
    input                               m_axi4_rvalid               , 
    output                              m_axi4_rready               , 

    output                   [W_ID-1:0] m_axi4_awid                 , 
    output             [WIDTH_ADDR-1:0] m_axi4_awaddr               , 
    output                      [8-1:0] m_axi4_awlen                , 
    output                      [3-1:0] m_axi4_awsize               , 
    output                      [2-1:0] m_axi4_awburst              , 
    output                      [4-1:0] m_axi4_awregion             , 
    output                              m_axi4_awlock               , 
    output                      [4-1:0] m_axi4_awcache              , 
    output                      [3-1:0] m_axi4_awprot               , 
    output                      [4-1:0] m_axi4_awqos                , 
    output               [W_AWUSER-1:0] m_axi4_awuser               , 
    output                              m_axi4_awvalid              , 
    input                               m_axi4_awready              , 

    output            [WIDTH_MDATA-1:0] m_axi4_wdata                , 
    output          [WIDTH_MDATA/8-1:0] m_axi4_wstrob               , 
    output                              m_axi4_wlast                , 
    output                [W_WUSER-1:0] m_axi4_wuser                , 
    output                              m_axi4_wvalid               , 
    input                               m_axi4_wready               , 

    input                    [W_ID-1:0] m_axi4_bid                  , 
    input                       [2-1:0] m_axi4_bresp                , 
    input                 [W_BUSER-1:0] m_axi4_buser                , 
    input                               m_axi4_bvalid               , 
    output                              m_axi4_bready                 
);

localparam WIDTH_OUTSTANDING = LOG2(NUM_OUTSTANDING-1);

wire                                    rdsplit_en                  ; 
wire                              [7:0] rdsplit_offset              ; 
wire                              [2:0] rdsplit_size                ; 
wire                                    rdsplit_tlast               ; 

wire                                    wrsplit_en                  ; 
wire                              [7:0] wrsplit_len                 ; 
wire                              [7:0] wrsplit_offset              ; 
wire                              [2:0] wrsplit_size                ; 
wire                                    wrsplit_tlast               ; 


axi_interconnect_width_convert_reqaddr #
(
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_ADDR                     (WIDTH_ADDR                 ), 
    .WIDTH_MDATA                    (WIDTH_MDATA                ), 
    .WIDTH_AUSER                    (WIDTH_ARUSER               ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_axi_interconnect_width_convert_reqaddr
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------------
    .split_en                       (rdsplit_en                 ), // (output)
    .split_len                      (                           ), // (output)
    .split_offset                   (rdsplit_offset[7:0]        ), // (output)
    .split_size                     (rdsplit_size[2:0]          ), // (output)
    .split_tlast                    (rdsplit_tlast              ), // (output)
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_reqaid                       (s_axi4_arid                ), // (input )
    .s_reqaaddr                     (s_axi4_araddr              ), // (input )
    .s_reqalen                      (s_axi4_arlen               ), // (input )
    .s_reqasize                     (s_axi4_arsize              ), // (input )
    .s_reqaburst                    (s_axi4_arburst             ), // (input )
    .s_reqaregion                   (s_axi4_arregion            ), // (input )
    .s_reqalock                     (s_axi4_arlock              ), // (input )
    .s_reqacache                    (s_axi4_arcache             ), // (input )
    .s_reqaprot                     (s_axi4_arprot              ), // (input )
    .s_reqaqos                      (s_axi4_arqos               ), // (input )
    .s_reqauser                     (s_axi4_aruser              ), // (input )
    .s_reqavalid                    (s_axi4_arvalid             ), // (input )
    .s_reqaready                    (s_axi4_arready             ), // (output)
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_reqaid                       (m_axi4_arid                ), // (output)
    .m_reqaaddr                     (m_axi4_araddr              ), // (output)
    .m_reqalen                      (m_axi4_arlen               ), // (output)
    .m_reqasize                     (m_axi4_arsize              ), // (output)
    .m_reqaburst                    (m_axi4_arburst             ), // (output)
    .m_reqaregion                   (m_axi4_arregion            ), // (output)
    .m_reqalock                     (m_axi4_arlock              ), // (output)
    .m_reqacache                    (m_axi4_arcache             ), // (output)
    .m_reqaprot                     (m_axi4_arprot              ), // (output)
    .m_reqaqos                      (m_axi4_arqos               ), // (output)
    .m_reqauser                     (m_axi4_aruser              ), // (output)
    .m_reqavalid                    (m_axi4_arvalid             ), // (output)
    .m_reqaready                    (m_axi4_arready             )  // (input )
);

axi_interconnect_width_convert_rresp #
(
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_SDATA                    (WIDTH_SDATA                ), 
    .WIDTH_MDATA                    (WIDTH_MDATA                ), 
    .WIDTH_RUSER                    (WIDTH_RUSER                ), 
    .WIDTH_OUTSTANDING              (WIDTH_OUTSTANDING          ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_axi_interconnect_width_convert_rresp
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------------
    .req_en                         (rdsplit_en                 ), // (input )
    .req_size                       (rdsplit_size               ), // (input )
    .req_offset                     (rdsplit_offset             ), // (input )
    .req_last                       (rdsplit_tlast              ), // (input )
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_respid                       (s_axi4_rid                 ), // (output)
    .s_respdata                     (s_axi4_rdata               ), // (output)
    .s_respresp                     (s_axi4_rresp               ), // (output)
    .s_resplast                     (s_axi4_rlast               ), // (output)
    .s_respuser                     (s_axi4_ruser               ), // (output)
    .s_respvalid                    (s_axi4_rvalid              ), // (output)
    .s_respready                    (s_axi4_rready              ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_respid                       (m_axi4_rid                 ), // (input )
    .m_respdata                     (m_axi4_rdata               ), // (input )
    .m_respresp                     (m_axi4_rresp               ), // (input )
    .m_resplast                     (m_axi4_rlast               ), // (input )
    .m_respuser                     (m_axi4_ruser               ), // (input )
    .m_respvalid                    (m_axi4_rvalid              ), // (input )
    .m_respready                    (m_axi4_rready              )  // (output)
);

axi_interconnect_width_convert_reqaddr #
(
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_ADDR                     (WIDTH_ADDR                 ), 
    .WIDTH_AUSER                    (WIDTH_AWUSER               ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_axi_interconnect_width_convert_reqaddr
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------------
    .split_en                       (wrsplit_en                 ), // (output)
    .split_len                      (wrsplit_len[7:0]           ), // (output)
    .split_offset                   (wrsplit_offset[7:0]        ), // (output)
    .split_size                     (wrsplit_size[2:0]          ), // (output)
    .split_tlast                    (wrsplit_tlast              ), // (output)
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_reqaid                       (s_axi4_awid                ), // (input )
    .s_reqaaddr                     (s_axi4_awaddr              ), // (input )
    .s_reqalen                      (s_axi4_awlen               ), // (input )
    .s_reqasize                     (s_axi4_awsize              ), // (input )
    .s_reqaburst                    (s_axi4_awburst             ), // (input )
    .s_reqaregion                   (s_axi4_awregion            ), // (input )
    .s_reqalock                     (s_axi4_awlock              ), // (input )
    .s_reqacache                    (s_axi4_awcache             ), // (input )
    .s_reqaprot                     (s_axi4_awprot              ), // (input )
    .s_reqaqos                      (s_axi4_awqos               ), // (input )
    .s_reqauser                     (s_axi4_awuser              ), // (input )
    .s_reqavalid                    (s_axi4_awvalid             ), // (input )
    .s_reqaready                    (s_axi4_awready             ), // (output)
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_reqaid                       (m_axi4_awid                ), // (output)
    .m_reqaaddr                     (m_axi4_awaddr              ), // (output)
    .m_reqalen                      (m_axi4_awlen               ), // (output)
    .m_reqasize                     (m_axi4_awsize              ), // (output)
    .m_reqaburst                    (m_axi4_awburst             ), // (output)
    .m_reqaregion                   (m_axi4_awregion            ), // (output)
    .m_reqalock                     (m_axi4_awlock              ), // (output)
    .m_reqacache                    (m_axi4_awcache             ), // (output)
    .m_reqaprot                     (m_axi4_awprot              ), // (output)
    .m_reqaqos                      (m_axi4_awqos               ), // (output)
    .m_reqauser                     (m_axi4_awuser              ), // (output)
    .m_reqavalid                    (m_axi4_awvalid             ), // (output)
    .m_reqaready                    (m_axi4_awready             )  // (input )
);

axi_interconnect_width_convert_reqdata #
(
    .WIDTH_SDATA                    (WIDTH_SDATA                ), 
    .WIDTH_MDATA                    (WIDTH_MDATA                ), 
    .WIDTH_DUSER                    (WIDTH_WUSER                ), 
    .WIDTH_OUTSTANDING              (WIDTH_OUTSTANDING          ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_width_convert_reqdata
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Info
// ---------------------------------------------------------------------------------
    .split_en                       (wrsplit_en                 ), // (input )
    .split_len                      (wrsplit_len[7:0]           ), // (input )
    .split_offset                   (wrsplit_offset[7:0]        ), // (input )
    .split_size                     (wrsplit_size[2:0]          ), // (input )
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_reqddata                     (s_axi4_wdata               ), // (input )
    .s_reqdstrob                    (s_axi4_wstrob              ), // (input )
    .s_reqdlast                     (s_axi4_wlast               ), // (input )
    .s_reqduser                     (s_axi4_wuser               ), // (input )
    .s_reqdvalid                    (s_axi4_wvalid              ), // (input )
    .s_reqdready                    (s_axi4_wready              ), // (output)
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_reqdwdata                    (m_axi4_wdata               ), // (output)
    .m_reqdwstrob                   (m_axi4_wstrob              ), // (output)
    .m_reqdwlast                    (m_axi4_wlast               ), // (output)
    .m_reqdwuser                    (m_axi4_wuser               ), // (output)
    .m_reqdwvalid                   (m_axi4_wvalid              ), // (output)
    .m_reqdwready                   (m_axi4_wready              )  // (input )
);


axi_interconnect_width_convert_bresp #
(
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_RUSER                    (WIDTH_RUSER                ), 
    .WIDTH_OUTSTANDING              (WIDTH_OUTSTANDING          ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_width_convert_bresp
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------------
    .req_en                         (wrsplit_en                 ), // (input )
    .req_last                       (wrsplit_tlast              ), // (input )
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    .s_respid                       (s_axi4_bid                 ), // (output)
    .s_respresp                     (s_axi4_bresp               ), // (output)
    .s_respuser                     (s_axi4_buser               ), // (output)
    .s_respvalid                    (s_axi4_bvalid              ), // (output)
    .s_respready                    (s_axi4_bready              ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    .m_respid                       (m_axi4_bid                 ), // (input )
    .m_respresp                     (m_axi4_bresp               ), // (input )
    .m_respuser                     (m_axi4_buser               ), // (input )
    .m_respvalid                    (m_axi4_bvalid              ), // (input )
    .m_respready                    (m_axi4_bready              )  // (output)
);

function integer LOG2 ;
input integer d;
begin
    LOG2 = 1;
    while((2**LOG2-1) < d)
        LOG2 = LOG2 + 1;
end
endfunction

endmodule







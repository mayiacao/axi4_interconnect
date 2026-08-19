// +FHDR------------------------------------------------------------------------
// Author       : CodeGenV
// Creat Time   : 2026/08/18
// File Name    : axi_interconnect_axi4_adapter.v
// Module Ver   : V1.0
// Description  : AXI4 ADDR/ID width adapter for generated top-level wrappers.
// -FHDR------------------------------------------------------------------------
`timescale 1ns/1ps

module axi_interconnect_axi4_adapter #
(
    parameter                           WIDTH_S_ID = 4              ,
    parameter                           WIDTH_M_ID = 4              ,
    parameter                           WIDTH_S_ADDR = 32           ,
    parameter                           WIDTH_M_ADDR = 32           ,
    parameter                           WIDTH_DATA = 256            ,
    parameter                           U_DLY = 1
)
(
    input              [WIDTH_S_ID-1:0] s_axi4_arid                 ,
    input            [WIDTH_S_ADDR-1:0] s_axi4_araddr               ,
    input                         [7:0] s_axi4_arlen                ,
    input                         [2:0] s_axi4_arsize               ,
    input                         [1:0] s_axi4_arburst              ,
    input                         [3:0] s_axi4_arregion             ,
    input                               s_axi4_arlock               ,
    input                         [3:0] s_axi4_arcache              ,
    input                         [2:0] s_axi4_arprot               ,
    input                         [3:0] s_axi4_arqos                ,
    input                               s_axi4_arvalid              ,
    output                              s_axi4_arready              ,
    output             [WIDTH_S_ID-1:0] s_axi4_rid                  ,
    output             [WIDTH_DATA-1:0] s_axi4_rdata                ,
    output                        [1:0] s_axi4_rresp                ,
    output                              s_axi4_rlast                ,
    output                              s_axi4_rvalid               ,
    input                               s_axi4_rready               ,
    input              [WIDTH_S_ID-1:0] s_axi4_awid                 ,
    input            [WIDTH_S_ADDR-1:0] s_axi4_awaddr               ,
    input                         [7:0] s_axi4_awlen                ,
    input                         [2:0] s_axi4_awsize               ,
    input                         [1:0] s_axi4_awburst              ,
    input                         [3:0] s_axi4_awregion             ,
    input                               s_axi4_awlock               ,
    input                         [3:0] s_axi4_awcache              ,
    input                         [2:0] s_axi4_awprot               ,
    input                         [3:0] s_axi4_awqos                ,
    input                               s_axi4_awvalid              ,
    output                              s_axi4_awready              ,
    input              [WIDTH_DATA-1:0] s_axi4_wdata                ,
    input            [WIDTH_DATA/8-1:0] s_axi4_wstrob               ,
    input                               s_axi4_wlast                ,
    input                               s_axi4_wvalid               ,
    output                              s_axi4_wready               ,
    output             [WIDTH_S_ID-1:0] s_axi4_bid                  ,
    output                        [1:0] s_axi4_bresp                ,
    output                              s_axi4_bvalid               ,
    input                               s_axi4_bready               ,
    output             [WIDTH_M_ID-1:0] m_axi4_arid                 ,
    output           [WIDTH_M_ADDR-1:0] m_axi4_araddr               ,
    output                        [7:0] m_axi4_arlen                ,
    output                        [2:0] m_axi4_arsize               ,
    output                        [1:0] m_axi4_arburst              ,
    output                        [3:0] m_axi4_arregion             ,
    output                              m_axi4_arlock               ,
    output                        [3:0] m_axi4_arcache              ,
    output                        [2:0] m_axi4_arprot               ,
    output                        [3:0] m_axi4_arqos                ,
    output                              m_axi4_arvalid              ,
    input                               m_axi4_arready              ,
    input              [WIDTH_M_ID-1:0] m_axi4_rid                  ,
    input              [WIDTH_DATA-1:0] m_axi4_rdata                ,
    input                         [1:0] m_axi4_rresp                ,
    input                               m_axi4_rlast                ,
    input                               m_axi4_rvalid               ,
    output                              m_axi4_rready               ,
    output             [WIDTH_M_ID-1:0] m_axi4_awid                 ,
    output           [WIDTH_M_ADDR-1:0] m_axi4_awaddr               ,
    output                        [7:0] m_axi4_awlen                ,
    output                        [2:0] m_axi4_awsize               ,
    output                        [1:0] m_axi4_awburst              ,
    output                        [3:0] m_axi4_awregion             ,
    output                              m_axi4_awlock               ,
    output                        [3:0] m_axi4_awcache              ,
    output                        [2:0] m_axi4_awprot               ,
    output                        [3:0] m_axi4_awqos                ,
    output                              m_axi4_awvalid              ,
    input                               m_axi4_awready              ,
    output             [WIDTH_DATA-1:0] m_axi4_wdata                ,
    output           [WIDTH_DATA/8-1:0] m_axi4_wstrob               ,
    output                              m_axi4_wlast                ,
    output                              m_axi4_wvalid               ,
    input                               m_axi4_wready               ,
    input              [WIDTH_M_ID-1:0] m_axi4_bid                  ,
    input                         [1:0] m_axi4_bresp                ,
    input                               m_axi4_bvalid               ,
    output                              m_axi4_bready               
);

generate
if (WIDTH_M_ID >= WIDTH_S_ID) begin : gen_arid_extend
    assign m_axi4_arid = {{(WIDTH_M_ID-WIDTH_S_ID){1'b0}}, s_axi4_arid};
    assign m_axi4_awid = {{(WIDTH_M_ID-WIDTH_S_ID){1'b0}}, s_axi4_awid};
end else begin : gen_arid_trunc
    assign m_axi4_arid = s_axi4_arid[WIDTH_M_ID-1:0];
    assign m_axi4_awid = s_axi4_awid[WIDTH_M_ID-1:0];
end
if (WIDTH_S_ID >= WIDTH_M_ID) begin : gen_rid_extend
    assign s_axi4_rid = {{(WIDTH_S_ID-WIDTH_M_ID){1'b0}}, m_axi4_rid};
    assign s_axi4_bid = {{(WIDTH_S_ID-WIDTH_M_ID){1'b0}}, m_axi4_bid};
end else begin : gen_rid_trunc
    assign s_axi4_rid = m_axi4_rid[WIDTH_S_ID-1:0];
    assign s_axi4_bid = m_axi4_bid[WIDTH_S_ID-1:0];
end
if (WIDTH_M_ADDR >= WIDTH_S_ADDR) begin : gen_addr_extend
    assign m_axi4_araddr = {{(WIDTH_M_ADDR-WIDTH_S_ADDR){1'b0}}, s_axi4_araddr};
    assign m_axi4_awaddr = {{(WIDTH_M_ADDR-WIDTH_S_ADDR){1'b0}}, s_axi4_awaddr};
end else begin : gen_addr_trunc
    assign m_axi4_araddr = s_axi4_araddr[WIDTH_M_ADDR-1:0];
    assign m_axi4_awaddr = s_axi4_awaddr[WIDTH_M_ADDR-1:0];
end
endgenerate

assign m_axi4_arlen    = s_axi4_arlen;
assign m_axi4_arsize   = s_axi4_arsize;
assign m_axi4_arburst  = s_axi4_arburst;
assign m_axi4_arregion = s_axi4_arregion;
assign m_axi4_arlock   = s_axi4_arlock;
assign m_axi4_arcache  = s_axi4_arcache;
assign m_axi4_arprot   = s_axi4_arprot;
assign m_axi4_arqos    = s_axi4_arqos;
assign m_axi4_arvalid  = s_axi4_arvalid;
assign s_axi4_arready  = m_axi4_arready;
assign s_axi4_rdata    = m_axi4_rdata;
assign s_axi4_rresp    = m_axi4_rresp;
assign s_axi4_rlast    = m_axi4_rlast;
assign s_axi4_rvalid   = m_axi4_rvalid;
assign m_axi4_rready   = s_axi4_rready;
assign m_axi4_awlen    = s_axi4_awlen;
assign m_axi4_awsize   = s_axi4_awsize;
assign m_axi4_awburst  = s_axi4_awburst;
assign m_axi4_awregion = s_axi4_awregion;
assign m_axi4_awlock   = s_axi4_awlock;
assign m_axi4_awcache  = s_axi4_awcache;
assign m_axi4_awprot   = s_axi4_awprot;
assign m_axi4_awqos    = s_axi4_awqos;
assign m_axi4_awvalid  = s_axi4_awvalid;
assign s_axi4_awready  = m_axi4_awready;
assign m_axi4_wdata    = s_axi4_wdata;
assign m_axi4_wstrob   = s_axi4_wstrob;
assign m_axi4_wlast    = s_axi4_wlast;
assign m_axi4_wvalid   = s_axi4_wvalid;
assign s_axi4_wready   = m_axi4_wready;
assign s_axi4_bresp    = m_axi4_bresp;
assign s_axi4_bvalid   = m_axi4_bvalid;
assign m_axi4_bready   = s_axi4_bready;

endmodule

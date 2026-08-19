// +FHDR------------------------------------------------------------------------
// Author       : CodeGenV
// Creat Time   : 2026/08/19 10:34:26
// File Name    : axi_interconnect.v
// Module Ver   : V1.1
// Description  : Generated AXI4 interconnect with per-interface ADDR/ID/DATA widths.
// Modification History:
// V1.0         initial
// V1.1         add independent ADDR/ID/DATA width adapters
// -FHDR------------------------------------------------------------------------
`timescale 1ns/1ps

module axi_interconnect #
(
    parameter                           U_DLY = 1
)
(
    input                               clk_sys                     , // system clock
    input                               rst_n                       , // active-low reset
    input                         [3:0] s00_axi4_arid               , // read address ID
    input                        [31:0] s00_axi4_araddr             , // read address
    input                         [7:0] s00_axi4_arlen              , // read burst length
    input                         [2:0] s00_axi4_arsize             , // read burst size
    input                         [1:0] s00_axi4_arburst            , // read burst type
    input                         [3:0] s00_axi4_arregion           , // read region
    input                               s00_axi4_arlock             , // read lock
    input                         [3:0] s00_axi4_arcache            , // read cache
    input                         [2:0] s00_axi4_arprot             , // read protection
    input                         [3:0] s00_axi4_arqos              , // read QoS
    input                               s00_axi4_arvalid            , // read address valid
    output                              s00_axi4_arready            , // read address ready
    output                        [3:0] s00_axi4_rid                , // read response ID
    output                      [255:0] s00_axi4_rdata              , // read data
    output                        [1:0] s00_axi4_rresp              , // read response
    output                              s00_axi4_rlast              , // read last
    output                              s00_axi4_rvalid             , // read valid
    input                               s00_axi4_rready             , // read ready
    input                         [3:0] s00_axi4_awid               , // write address ID
    input                        [31:0] s00_axi4_awaddr             , // write address
    input                         [7:0] s00_axi4_awlen              , // write burst length
    input                         [2:0] s00_axi4_awsize             , // write burst size
    input                         [1:0] s00_axi4_awburst            , // write burst type
    input                         [3:0] s00_axi4_awregion           , // write region
    input                               s00_axi4_awlock             , // write lock
    input                         [3:0] s00_axi4_awcache            , // write cache
    input                         [2:0] s00_axi4_awprot             , // write protection
    input                         [3:0] s00_axi4_awqos              , // write QoS
    input                               s00_axi4_awvalid            , // write address valid
    output                              s00_axi4_awready            , // write address ready
    input                       [255:0] s00_axi4_wdata              , // write data
    input                        [31:0] s00_axi4_wstrob             , // write strobe
    input                               s00_axi4_wlast              , // write last
    input                               s00_axi4_wvalid             , // write valid
    output                              s00_axi4_wready             , // write ready
    output                        [3:0] s00_axi4_bid                , // write response ID
    output                        [1:0] s00_axi4_bresp              , // write response
    output                              s00_axi4_bvalid             , // write response valid
    input                               s00_axi4_bready             , // write response ready
    input                               s01_axi4_clk                , // slave independent clock
    input                         [7:0] s01_axi4_arid               , // read address ID
    input                        [39:0] s01_axi4_araddr             , // read address
    input                         [7:0] s01_axi4_arlen              , // read burst length
    input                         [2:0] s01_axi4_arsize             , // read burst size
    input                         [1:0] s01_axi4_arburst            , // read burst type
    input                         [3:0] s01_axi4_arregion           , // read region
    input                               s01_axi4_arlock             , // read lock
    input                         [3:0] s01_axi4_arcache            , // read cache
    input                         [2:0] s01_axi4_arprot             , // read protection
    input                         [3:0] s01_axi4_arqos              , // read QoS
    input                               s01_axi4_arvalid            , // read address valid
    output                              s01_axi4_arready            , // read address ready
    output                        [7:0] s01_axi4_rid                , // read response ID
    output                      [127:0] s01_axi4_rdata              , // read data
    output                        [1:0] s01_axi4_rresp              , // read response
    output                              s01_axi4_rlast              , // read last
    output                              s01_axi4_rvalid             , // read valid
    input                               s01_axi4_rready             , // read ready
    input                         [7:0] s01_axi4_awid               , // write address ID
    input                        [39:0] s01_axi4_awaddr             , // write address
    input                         [7:0] s01_axi4_awlen              , // write burst length
    input                         [2:0] s01_axi4_awsize             , // write burst size
    input                         [1:0] s01_axi4_awburst            , // write burst type
    input                         [3:0] s01_axi4_awregion           , // write region
    input                               s01_axi4_awlock             , // write lock
    input                         [3:0] s01_axi4_awcache            , // write cache
    input                         [2:0] s01_axi4_awprot             , // write protection
    input                         [3:0] s01_axi4_awqos              , // write QoS
    input                               s01_axi4_awvalid            , // write address valid
    output                              s01_axi4_awready            , // write address ready
    input                       [127:0] s01_axi4_wdata              , // write data
    input                        [15:0] s01_axi4_wstrob             , // write strobe
    input                               s01_axi4_wlast              , // write last
    input                               s01_axi4_wvalid             , // write valid
    output                              s01_axi4_wready             , // write ready
    output                        [7:0] s01_axi4_bid                , // write response ID
    output                        [1:0] s01_axi4_bresp              , // write response
    output                              s01_axi4_bvalid             , // write response valid
    input                               s01_axi4_bready             , // write response ready
    output                        [5:0] m00_axi4_arid               , // read address ID
    output                       [35:0] m00_axi4_araddr             , // read address
    output                        [7:0] m00_axi4_arlen              , // read burst length
    output                        [2:0] m00_axi4_arsize             , // read burst size
    output                        [1:0] m00_axi4_arburst            , // read burst type
    output                        [3:0] m00_axi4_arregion           , // read region
    output                              m00_axi4_arlock             , // read lock
    output                        [3:0] m00_axi4_arcache            , // read cache
    output                        [2:0] m00_axi4_arprot             , // read protection
    output                        [3:0] m00_axi4_arqos              , // read QoS
    output                              m00_axi4_arvalid            , // read address valid
    input                               m00_axi4_arready            , // read address ready
    input                         [5:0] m00_axi4_rid                , // read response ID
    input                       [511:0] m00_axi4_rdata              , // read data
    input                         [1:0] m00_axi4_rresp              , // read response
    input                               m00_axi4_rlast              , // read last
    input                               m00_axi4_rvalid             , // read valid
    output                              m00_axi4_rready             , // read ready
    output                        [5:0] m00_axi4_awid               , // write address ID
    output                       [35:0] m00_axi4_awaddr             , // write address
    output                        [7:0] m00_axi4_awlen              , // write burst length
    output                        [2:0] m00_axi4_awsize             , // write burst size
    output                        [1:0] m00_axi4_awburst            , // write burst type
    output                        [3:0] m00_axi4_awregion           , // write region
    output                              m00_axi4_awlock             , // write lock
    output                        [3:0] m00_axi4_awcache            , // write cache
    output                        [2:0] m00_axi4_awprot             , // write protection
    output                        [3:0] m00_axi4_awqos              , // write QoS
    output                              m00_axi4_awvalid            , // write address valid
    input                               m00_axi4_awready            , // write address ready
    output                      [511:0] m00_axi4_wdata              , // write data
    output                       [63:0] m00_axi4_wstrob             , // write strobe
    output                              m00_axi4_wlast              , // write last
    output                              m00_axi4_wvalid             , // write valid
    input                               m00_axi4_wready             , // write ready
    input                         [5:0] m00_axi4_bid                , // write response ID
    input                         [1:0] m00_axi4_bresp              , // write response
    input                               m00_axi4_bvalid             , // write response valid
    output                              m00_axi4_bready             , // write response ready
    input                               m01_axi4_clk                , // master independent clock
    output                        [3:0] m01_axi4_arid               , // read address ID
    output                       [31:0] m01_axi4_araddr             , // read address
    output                        [7:0] m01_axi4_arlen              , // read burst length
    output                        [2:0] m01_axi4_arsize             , // read burst size
    output                        [1:0] m01_axi4_arburst            , // read burst type
    output                        [3:0] m01_axi4_arregion           , // read region
    output                              m01_axi4_arlock             , // read lock
    output                        [3:0] m01_axi4_arcache            , // read cache
    output                        [2:0] m01_axi4_arprot             , // read protection
    output                        [3:0] m01_axi4_arqos              , // read QoS
    output                              m01_axi4_arvalid            , // read address valid
    input                               m01_axi4_arready            , // read address ready
    input                         [3:0] m01_axi4_rid                , // read response ID
    input                        [63:0] m01_axi4_rdata              , // read data
    input                         [1:0] m01_axi4_rresp              , // read response
    input                               m01_axi4_rlast              , // read last
    input                               m01_axi4_rvalid             , // read valid
    output                              m01_axi4_rready             , // read ready
    output                        [3:0] m01_axi4_awid               , // write address ID
    output                       [31:0] m01_axi4_awaddr             , // write address
    output                        [7:0] m01_axi4_awlen              , // write burst length
    output                        [2:0] m01_axi4_awsize             , // write burst size
    output                        [1:0] m01_axi4_awburst            , // write burst type
    output                        [3:0] m01_axi4_awregion           , // write region
    output                              m01_axi4_awlock             , // write lock
    output                        [3:0] m01_axi4_awcache            , // write cache
    output                        [2:0] m01_axi4_awprot             , // write protection
    output                        [3:0] m01_axi4_awqos              , // write QoS
    output                              m01_axi4_awvalid            , // write address valid
    input                               m01_axi4_awready            , // write address ready
    output                       [63:0] m01_axi4_wdata              , // write data
    output                        [7:0] m01_axi4_wstrob             , // write strobe
    output                              m01_axi4_wlast              , // write last
    output                              m01_axi4_wvalid             , // write valid
    input                               m01_axi4_wready             , // write ready
    input                         [3:0] m01_axi4_bid                , // write response ID
    input                         [1:0] m01_axi4_bresp              , // write response
    input                               m01_axi4_bvalid             , // write response valid
    output                              m01_axi4_bready               // write response ready
);

localparam                              NUM_SLAVE = 2;
localparam                              NUM_MASTER = 2;
localparam                              CORE_ID_WIDTH = 8;
localparam                              CORE_ADDR_WIDTH = 40;
localparam                              CORE_DATA_WIDTH = 512;

localparam [NUM_MASTER*CORE_ADDR_WIDTH-1:0] ADDR_BASE = {
    40'h0010000000,
    40'h0000000000
};

localparam [NUM_MASTER*CORE_ADDR_WIDTH-1:0] ADDR_HIGH = {
    40'h001FFFFFFF,
    40'h000FFFFFFF
};

wire                               [7:0] s00_adp_axi4_arid;
wire                              [39:0] s00_adp_axi4_araddr;
wire                               [7:0] s00_adp_axi4_arlen;
wire                               [2:0] s00_adp_axi4_arsize;
wire                               [1:0] s00_adp_axi4_arburst;
wire                               [3:0] s00_adp_axi4_arregion;
wire                                     s00_adp_axi4_arlock;
wire                               [3:0] s00_adp_axi4_arcache;
wire                               [2:0] s00_adp_axi4_arprot;
wire                               [3:0] s00_adp_axi4_arqos;
wire                                     s00_adp_axi4_arvalid;
wire                                     s00_adp_axi4_arready;
wire                               [7:0] s00_adp_axi4_rid;
wire                             [255:0] s00_adp_axi4_rdata;
wire                               [1:0] s00_adp_axi4_rresp;
wire                                     s00_adp_axi4_rlast;
wire                                     s00_adp_axi4_rvalid;
wire                                     s00_adp_axi4_rready;
wire                               [7:0] s00_adp_axi4_awid;
wire                              [39:0] s00_adp_axi4_awaddr;
wire                               [7:0] s00_adp_axi4_awlen;
wire                               [2:0] s00_adp_axi4_awsize;
wire                               [1:0] s00_adp_axi4_awburst;
wire                               [3:0] s00_adp_axi4_awregion;
wire                                     s00_adp_axi4_awlock;
wire                               [3:0] s00_adp_axi4_awcache;
wire                               [2:0] s00_adp_axi4_awprot;
wire                               [3:0] s00_adp_axi4_awqos;
wire                                     s00_adp_axi4_awvalid;
wire                                     s00_adp_axi4_awready;
wire                             [255:0] s00_adp_axi4_wdata;
wire                              [31:0] s00_adp_axi4_wstrob;
wire                                     s00_adp_axi4_wlast;
wire                                     s00_adp_axi4_wvalid;
wire                                     s00_adp_axi4_wready;
wire                               [7:0] s00_adp_axi4_bid;
wire                               [1:0] s00_adp_axi4_bresp;
wire                                     s00_adp_axi4_bvalid;
wire                                     s00_adp_axi4_bready;

wire                               [7:0] s00_cdc_axi4_arid;
wire                              [39:0] s00_cdc_axi4_araddr;
wire                               [7:0] s00_cdc_axi4_arlen;
wire                               [2:0] s00_cdc_axi4_arsize;
wire                               [1:0] s00_cdc_axi4_arburst;
wire                               [3:0] s00_cdc_axi4_arregion;
wire                                     s00_cdc_axi4_arlock;
wire                               [3:0] s00_cdc_axi4_arcache;
wire                               [2:0] s00_cdc_axi4_arprot;
wire                               [3:0] s00_cdc_axi4_arqos;
wire                                     s00_cdc_axi4_arvalid;
wire                                     s00_cdc_axi4_arready;
wire                               [7:0] s00_cdc_axi4_rid;
wire                             [255:0] s00_cdc_axi4_rdata;
wire                               [1:0] s00_cdc_axi4_rresp;
wire                                     s00_cdc_axi4_rlast;
wire                                     s00_cdc_axi4_rvalid;
wire                                     s00_cdc_axi4_rready;
wire                               [7:0] s00_cdc_axi4_awid;
wire                              [39:0] s00_cdc_axi4_awaddr;
wire                               [7:0] s00_cdc_axi4_awlen;
wire                               [2:0] s00_cdc_axi4_awsize;
wire                               [1:0] s00_cdc_axi4_awburst;
wire                               [3:0] s00_cdc_axi4_awregion;
wire                                     s00_cdc_axi4_awlock;
wire                               [3:0] s00_cdc_axi4_awcache;
wire                               [2:0] s00_cdc_axi4_awprot;
wire                               [3:0] s00_cdc_axi4_awqos;
wire                                     s00_cdc_axi4_awvalid;
wire                                     s00_cdc_axi4_awready;
wire                             [255:0] s00_cdc_axi4_wdata;
wire                              [31:0] s00_cdc_axi4_wstrob;
wire                                     s00_cdc_axi4_wlast;
wire                                     s00_cdc_axi4_wvalid;
wire                                     s00_cdc_axi4_wready;
wire                               [7:0] s00_cdc_axi4_bid;
wire                               [1:0] s00_cdc_axi4_bresp;
wire                                     s00_cdc_axi4_bvalid;
wire                                     s00_cdc_axi4_bready;

wire                               [7:0] s00_dcv_axi4_arid;
wire                              [39:0] s00_dcv_axi4_araddr;
wire                               [7:0] s00_dcv_axi4_arlen;
wire                               [2:0] s00_dcv_axi4_arsize;
wire                               [1:0] s00_dcv_axi4_arburst;
wire                               [3:0] s00_dcv_axi4_arregion;
wire                                     s00_dcv_axi4_arlock;
wire                               [3:0] s00_dcv_axi4_arcache;
wire                               [2:0] s00_dcv_axi4_arprot;
wire                               [3:0] s00_dcv_axi4_arqos;
wire                                     s00_dcv_axi4_arvalid;
wire                                     s00_dcv_axi4_arready;
wire                               [7:0] s00_dcv_axi4_rid;
wire                             [511:0] s00_dcv_axi4_rdata;
wire                               [1:0] s00_dcv_axi4_rresp;
wire                                     s00_dcv_axi4_rlast;
wire                                     s00_dcv_axi4_rvalid;
wire                                     s00_dcv_axi4_rready;
wire                               [7:0] s00_dcv_axi4_awid;
wire                              [39:0] s00_dcv_axi4_awaddr;
wire                               [7:0] s00_dcv_axi4_awlen;
wire                               [2:0] s00_dcv_axi4_awsize;
wire                               [1:0] s00_dcv_axi4_awburst;
wire                               [3:0] s00_dcv_axi4_awregion;
wire                                     s00_dcv_axi4_awlock;
wire                               [3:0] s00_dcv_axi4_awcache;
wire                               [2:0] s00_dcv_axi4_awprot;
wire                               [3:0] s00_dcv_axi4_awqos;
wire                                     s00_dcv_axi4_awvalid;
wire                                     s00_dcv_axi4_awready;
wire                             [511:0] s00_dcv_axi4_wdata;
wire                              [63:0] s00_dcv_axi4_wstrob;
wire                                     s00_dcv_axi4_wlast;
wire                                     s00_dcv_axi4_wvalid;
wire                                     s00_dcv_axi4_wready;
wire                               [7:0] s00_dcv_axi4_bid;
wire                               [1:0] s00_dcv_axi4_bresp;
wire                                     s00_dcv_axi4_bvalid;
wire                                     s00_dcv_axi4_bready;

wire                               [7:0] s01_adp_axi4_arid;
wire                              [39:0] s01_adp_axi4_araddr;
wire                               [7:0] s01_adp_axi4_arlen;
wire                               [2:0] s01_adp_axi4_arsize;
wire                               [1:0] s01_adp_axi4_arburst;
wire                               [3:0] s01_adp_axi4_arregion;
wire                                     s01_adp_axi4_arlock;
wire                               [3:0] s01_adp_axi4_arcache;
wire                               [2:0] s01_adp_axi4_arprot;
wire                               [3:0] s01_adp_axi4_arqos;
wire                                     s01_adp_axi4_arvalid;
wire                                     s01_adp_axi4_arready;
wire                               [7:0] s01_adp_axi4_rid;
wire                             [127:0] s01_adp_axi4_rdata;
wire                               [1:0] s01_adp_axi4_rresp;
wire                                     s01_adp_axi4_rlast;
wire                                     s01_adp_axi4_rvalid;
wire                                     s01_adp_axi4_rready;
wire                               [7:0] s01_adp_axi4_awid;
wire                              [39:0] s01_adp_axi4_awaddr;
wire                               [7:0] s01_adp_axi4_awlen;
wire                               [2:0] s01_adp_axi4_awsize;
wire                               [1:0] s01_adp_axi4_awburst;
wire                               [3:0] s01_adp_axi4_awregion;
wire                                     s01_adp_axi4_awlock;
wire                               [3:0] s01_adp_axi4_awcache;
wire                               [2:0] s01_adp_axi4_awprot;
wire                               [3:0] s01_adp_axi4_awqos;
wire                                     s01_adp_axi4_awvalid;
wire                                     s01_adp_axi4_awready;
wire                             [127:0] s01_adp_axi4_wdata;
wire                              [15:0] s01_adp_axi4_wstrob;
wire                                     s01_adp_axi4_wlast;
wire                                     s01_adp_axi4_wvalid;
wire                                     s01_adp_axi4_wready;
wire                               [7:0] s01_adp_axi4_bid;
wire                               [1:0] s01_adp_axi4_bresp;
wire                                     s01_adp_axi4_bvalid;
wire                                     s01_adp_axi4_bready;

wire                               [7:0] s01_cdc_axi4_arid;
wire                              [39:0] s01_cdc_axi4_araddr;
wire                               [7:0] s01_cdc_axi4_arlen;
wire                               [2:0] s01_cdc_axi4_arsize;
wire                               [1:0] s01_cdc_axi4_arburst;
wire                               [3:0] s01_cdc_axi4_arregion;
wire                                     s01_cdc_axi4_arlock;
wire                               [3:0] s01_cdc_axi4_arcache;
wire                               [2:0] s01_cdc_axi4_arprot;
wire                               [3:0] s01_cdc_axi4_arqos;
wire                                     s01_cdc_axi4_arvalid;
wire                                     s01_cdc_axi4_arready;
wire                               [7:0] s01_cdc_axi4_rid;
wire                             [127:0] s01_cdc_axi4_rdata;
wire                               [1:0] s01_cdc_axi4_rresp;
wire                                     s01_cdc_axi4_rlast;
wire                                     s01_cdc_axi4_rvalid;
wire                                     s01_cdc_axi4_rready;
wire                               [7:0] s01_cdc_axi4_awid;
wire                              [39:0] s01_cdc_axi4_awaddr;
wire                               [7:0] s01_cdc_axi4_awlen;
wire                               [2:0] s01_cdc_axi4_awsize;
wire                               [1:0] s01_cdc_axi4_awburst;
wire                               [3:0] s01_cdc_axi4_awregion;
wire                                     s01_cdc_axi4_awlock;
wire                               [3:0] s01_cdc_axi4_awcache;
wire                               [2:0] s01_cdc_axi4_awprot;
wire                               [3:0] s01_cdc_axi4_awqos;
wire                                     s01_cdc_axi4_awvalid;
wire                                     s01_cdc_axi4_awready;
wire                             [127:0] s01_cdc_axi4_wdata;
wire                              [15:0] s01_cdc_axi4_wstrob;
wire                                     s01_cdc_axi4_wlast;
wire                                     s01_cdc_axi4_wvalid;
wire                                     s01_cdc_axi4_wready;
wire                               [7:0] s01_cdc_axi4_bid;
wire                               [1:0] s01_cdc_axi4_bresp;
wire                                     s01_cdc_axi4_bvalid;
wire                                     s01_cdc_axi4_bready;

wire                               [7:0] s01_dcv_axi4_arid;
wire                              [39:0] s01_dcv_axi4_araddr;
wire                               [7:0] s01_dcv_axi4_arlen;
wire                               [2:0] s01_dcv_axi4_arsize;
wire                               [1:0] s01_dcv_axi4_arburst;
wire                               [3:0] s01_dcv_axi4_arregion;
wire                                     s01_dcv_axi4_arlock;
wire                               [3:0] s01_dcv_axi4_arcache;
wire                               [2:0] s01_dcv_axi4_arprot;
wire                               [3:0] s01_dcv_axi4_arqos;
wire                                     s01_dcv_axi4_arvalid;
wire                                     s01_dcv_axi4_arready;
wire                               [7:0] s01_dcv_axi4_rid;
wire                             [511:0] s01_dcv_axi4_rdata;
wire                               [1:0] s01_dcv_axi4_rresp;
wire                                     s01_dcv_axi4_rlast;
wire                                     s01_dcv_axi4_rvalid;
wire                                     s01_dcv_axi4_rready;
wire                               [7:0] s01_dcv_axi4_awid;
wire                              [39:0] s01_dcv_axi4_awaddr;
wire                               [7:0] s01_dcv_axi4_awlen;
wire                               [2:0] s01_dcv_axi4_awsize;
wire                               [1:0] s01_dcv_axi4_awburst;
wire                               [3:0] s01_dcv_axi4_awregion;
wire                                     s01_dcv_axi4_awlock;
wire                               [3:0] s01_dcv_axi4_awcache;
wire                               [2:0] s01_dcv_axi4_awprot;
wire                               [3:0] s01_dcv_axi4_awqos;
wire                                     s01_dcv_axi4_awvalid;
wire                                     s01_dcv_axi4_awready;
wire                             [511:0] s01_dcv_axi4_wdata;
wire                              [63:0] s01_dcv_axi4_wstrob;
wire                                     s01_dcv_axi4_wlast;
wire                                     s01_dcv_axi4_wvalid;
wire                                     s01_dcv_axi4_wready;
wire                               [7:0] s01_dcv_axi4_bid;
wire                               [1:0] s01_dcv_axi4_bresp;
wire                                     s01_dcv_axi4_bvalid;
wire                                     s01_dcv_axi4_bready;

wire                              [15:0] s_cbr_axi4_arid;
wire                              [79:0] s_cbr_axi4_araddr;
wire                              [15:0] s_cbr_axi4_arlen;
wire                               [5:0] s_cbr_axi4_arsize;
wire                               [3:0] s_cbr_axi4_arburst;
wire                               [7:0] s_cbr_axi4_arregion;
wire                               [1:0] s_cbr_axi4_arlock;
wire                               [7:0] s_cbr_axi4_arcache;
wire                               [5:0] s_cbr_axi4_arprot;
wire                               [7:0] s_cbr_axi4_arqos;
wire                               [1:0] s_cbr_axi4_arvalid;
wire                               [1:0] s_cbr_axi4_arready;
wire                              [15:0] s_cbr_axi4_rid;
wire                            [1023:0] s_cbr_axi4_rdata;
wire                               [3:0] s_cbr_axi4_rresp;
wire                               [1:0] s_cbr_axi4_rlast;
wire                               [1:0] s_cbr_axi4_rvalid;
wire                               [1:0] s_cbr_axi4_rready;
wire                              [15:0] s_cbr_axi4_awid;
wire                              [79:0] s_cbr_axi4_awaddr;
wire                              [15:0] s_cbr_axi4_awlen;
wire                               [5:0] s_cbr_axi4_awsize;
wire                               [3:0] s_cbr_axi4_awburst;
wire                               [7:0] s_cbr_axi4_awregion;
wire                               [1:0] s_cbr_axi4_awlock;
wire                               [7:0] s_cbr_axi4_awcache;
wire                               [5:0] s_cbr_axi4_awprot;
wire                               [7:0] s_cbr_axi4_awqos;
wire                               [1:0] s_cbr_axi4_awvalid;
wire                               [1:0] s_cbr_axi4_awready;
wire                            [1023:0] s_cbr_axi4_wdata;
wire                             [127:0] s_cbr_axi4_wstrob;
wire                               [1:0] s_cbr_axi4_wlast;
wire                               [1:0] s_cbr_axi4_wvalid;
wire                               [1:0] s_cbr_axi4_wready;
wire                              [15:0] s_cbr_axi4_bid;
wire                               [3:0] s_cbr_axi4_bresp;
wire                               [1:0] s_cbr_axi4_bvalid;
wire                               [1:0] s_cbr_axi4_bready;

wire                              [15:0] m_cbr_axi4_arid;
wire                              [79:0] m_cbr_axi4_araddr;
wire                              [15:0] m_cbr_axi4_arlen;
wire                               [5:0] m_cbr_axi4_arsize;
wire                               [3:0] m_cbr_axi4_arburst;
wire                               [7:0] m_cbr_axi4_arregion;
wire                               [1:0] m_cbr_axi4_arlock;
wire                               [7:0] m_cbr_axi4_arcache;
wire                               [5:0] m_cbr_axi4_arprot;
wire                               [7:0] m_cbr_axi4_arqos;
wire                               [1:0] m_cbr_axi4_arvalid;
wire                               [1:0] m_cbr_axi4_arready;
wire                              [15:0] m_cbr_axi4_rid;
wire                            [1023:0] m_cbr_axi4_rdata;
wire                               [3:0] m_cbr_axi4_rresp;
wire                               [1:0] m_cbr_axi4_rlast;
wire                               [1:0] m_cbr_axi4_rvalid;
wire                               [1:0] m_cbr_axi4_rready;
wire                              [15:0] m_cbr_axi4_awid;
wire                              [79:0] m_cbr_axi4_awaddr;
wire                              [15:0] m_cbr_axi4_awlen;
wire                               [5:0] m_cbr_axi4_awsize;
wire                               [3:0] m_cbr_axi4_awburst;
wire                               [7:0] m_cbr_axi4_awregion;
wire                               [1:0] m_cbr_axi4_awlock;
wire                               [7:0] m_cbr_axi4_awcache;
wire                               [5:0] m_cbr_axi4_awprot;
wire                               [7:0] m_cbr_axi4_awqos;
wire                               [1:0] m_cbr_axi4_awvalid;
wire                               [1:0] m_cbr_axi4_awready;
wire                            [1023:0] m_cbr_axi4_wdata;
wire                             [127:0] m_cbr_axi4_wstrob;
wire                               [1:0] m_cbr_axi4_wlast;
wire                               [1:0] m_cbr_axi4_wvalid;
wire                               [1:0] m_cbr_axi4_wready;
wire                              [15:0] m_cbr_axi4_bid;
wire                               [3:0] m_cbr_axi4_bresp;
wire                               [1:0] m_cbr_axi4_bvalid;
wire                               [1:0] m_cbr_axi4_bready;

wire                               [7:0] m00_cbr_axi4_arid;
wire                              [39:0] m00_cbr_axi4_araddr;
wire                               [7:0] m00_cbr_axi4_arlen;
wire                               [2:0] m00_cbr_axi4_arsize;
wire                               [1:0] m00_cbr_axi4_arburst;
wire                               [3:0] m00_cbr_axi4_arregion;
wire                                     m00_cbr_axi4_arlock;
wire                               [3:0] m00_cbr_axi4_arcache;
wire                               [2:0] m00_cbr_axi4_arprot;
wire                               [3:0] m00_cbr_axi4_arqos;
wire                                     m00_cbr_axi4_arvalid;
wire                                     m00_cbr_axi4_arready;
wire                               [7:0] m00_cbr_axi4_rid;
wire                             [511:0] m00_cbr_axi4_rdata;
wire                               [1:0] m00_cbr_axi4_rresp;
wire                                     m00_cbr_axi4_rlast;
wire                                     m00_cbr_axi4_rvalid;
wire                                     m00_cbr_axi4_rready;
wire                               [7:0] m00_cbr_axi4_awid;
wire                              [39:0] m00_cbr_axi4_awaddr;
wire                               [7:0] m00_cbr_axi4_awlen;
wire                               [2:0] m00_cbr_axi4_awsize;
wire                               [1:0] m00_cbr_axi4_awburst;
wire                               [3:0] m00_cbr_axi4_awregion;
wire                                     m00_cbr_axi4_awlock;
wire                               [3:0] m00_cbr_axi4_awcache;
wire                               [2:0] m00_cbr_axi4_awprot;
wire                               [3:0] m00_cbr_axi4_awqos;
wire                                     m00_cbr_axi4_awvalid;
wire                                     m00_cbr_axi4_awready;
wire                             [511:0] m00_cbr_axi4_wdata;
wire                              [63:0] m00_cbr_axi4_wstrob;
wire                                     m00_cbr_axi4_wlast;
wire                                     m00_cbr_axi4_wvalid;
wire                                     m00_cbr_axi4_wready;
wire                               [7:0] m00_cbr_axi4_bid;
wire                               [1:0] m00_cbr_axi4_bresp;
wire                                     m00_cbr_axi4_bvalid;
wire                                     m00_cbr_axi4_bready;

wire                               [7:0] m00_dcv_axi4_arid;
wire                              [39:0] m00_dcv_axi4_araddr;
wire                               [7:0] m00_dcv_axi4_arlen;
wire                               [2:0] m00_dcv_axi4_arsize;
wire                               [1:0] m00_dcv_axi4_arburst;
wire                               [3:0] m00_dcv_axi4_arregion;
wire                                     m00_dcv_axi4_arlock;
wire                               [3:0] m00_dcv_axi4_arcache;
wire                               [2:0] m00_dcv_axi4_arprot;
wire                               [3:0] m00_dcv_axi4_arqos;
wire                                     m00_dcv_axi4_arvalid;
wire                                     m00_dcv_axi4_arready;
wire                               [7:0] m00_dcv_axi4_rid;
wire                             [511:0] m00_dcv_axi4_rdata;
wire                               [1:0] m00_dcv_axi4_rresp;
wire                                     m00_dcv_axi4_rlast;
wire                                     m00_dcv_axi4_rvalid;
wire                                     m00_dcv_axi4_rready;
wire                               [7:0] m00_dcv_axi4_awid;
wire                              [39:0] m00_dcv_axi4_awaddr;
wire                               [7:0] m00_dcv_axi4_awlen;
wire                               [2:0] m00_dcv_axi4_awsize;
wire                               [1:0] m00_dcv_axi4_awburst;
wire                               [3:0] m00_dcv_axi4_awregion;
wire                                     m00_dcv_axi4_awlock;
wire                               [3:0] m00_dcv_axi4_awcache;
wire                               [2:0] m00_dcv_axi4_awprot;
wire                               [3:0] m00_dcv_axi4_awqos;
wire                                     m00_dcv_axi4_awvalid;
wire                                     m00_dcv_axi4_awready;
wire                             [511:0] m00_dcv_axi4_wdata;
wire                              [63:0] m00_dcv_axi4_wstrob;
wire                                     m00_dcv_axi4_wlast;
wire                                     m00_dcv_axi4_wvalid;
wire                                     m00_dcv_axi4_wready;
wire                               [7:0] m00_dcv_axi4_bid;
wire                               [1:0] m00_dcv_axi4_bresp;
wire                                     m00_dcv_axi4_bvalid;
wire                                     m00_dcv_axi4_bready;

wire                               [7:0] m00_cdc_axi4_arid;
wire                              [39:0] m00_cdc_axi4_araddr;
wire                               [7:0] m00_cdc_axi4_arlen;
wire                               [2:0] m00_cdc_axi4_arsize;
wire                               [1:0] m00_cdc_axi4_arburst;
wire                               [3:0] m00_cdc_axi4_arregion;
wire                                     m00_cdc_axi4_arlock;
wire                               [3:0] m00_cdc_axi4_arcache;
wire                               [2:0] m00_cdc_axi4_arprot;
wire                               [3:0] m00_cdc_axi4_arqos;
wire                                     m00_cdc_axi4_arvalid;
wire                                     m00_cdc_axi4_arready;
wire                               [7:0] m00_cdc_axi4_rid;
wire                             [511:0] m00_cdc_axi4_rdata;
wire                               [1:0] m00_cdc_axi4_rresp;
wire                                     m00_cdc_axi4_rlast;
wire                                     m00_cdc_axi4_rvalid;
wire                                     m00_cdc_axi4_rready;
wire                               [7:0] m00_cdc_axi4_awid;
wire                              [39:0] m00_cdc_axi4_awaddr;
wire                               [7:0] m00_cdc_axi4_awlen;
wire                               [2:0] m00_cdc_axi4_awsize;
wire                               [1:0] m00_cdc_axi4_awburst;
wire                               [3:0] m00_cdc_axi4_awregion;
wire                                     m00_cdc_axi4_awlock;
wire                               [3:0] m00_cdc_axi4_awcache;
wire                               [2:0] m00_cdc_axi4_awprot;
wire                               [3:0] m00_cdc_axi4_awqos;
wire                                     m00_cdc_axi4_awvalid;
wire                                     m00_cdc_axi4_awready;
wire                             [511:0] m00_cdc_axi4_wdata;
wire                              [63:0] m00_cdc_axi4_wstrob;
wire                                     m00_cdc_axi4_wlast;
wire                                     m00_cdc_axi4_wvalid;
wire                                     m00_cdc_axi4_wready;
wire                               [7:0] m00_cdc_axi4_bid;
wire                               [1:0] m00_cdc_axi4_bresp;
wire                                     m00_cdc_axi4_bvalid;
wire                                     m00_cdc_axi4_bready;

wire                               [7:0] m01_cbr_axi4_arid;
wire                              [39:0] m01_cbr_axi4_araddr;
wire                               [7:0] m01_cbr_axi4_arlen;
wire                               [2:0] m01_cbr_axi4_arsize;
wire                               [1:0] m01_cbr_axi4_arburst;
wire                               [3:0] m01_cbr_axi4_arregion;
wire                                     m01_cbr_axi4_arlock;
wire                               [3:0] m01_cbr_axi4_arcache;
wire                               [2:0] m01_cbr_axi4_arprot;
wire                               [3:0] m01_cbr_axi4_arqos;
wire                                     m01_cbr_axi4_arvalid;
wire                                     m01_cbr_axi4_arready;
wire                               [7:0] m01_cbr_axi4_rid;
wire                             [511:0] m01_cbr_axi4_rdata;
wire                               [1:0] m01_cbr_axi4_rresp;
wire                                     m01_cbr_axi4_rlast;
wire                                     m01_cbr_axi4_rvalid;
wire                                     m01_cbr_axi4_rready;
wire                               [7:0] m01_cbr_axi4_awid;
wire                              [39:0] m01_cbr_axi4_awaddr;
wire                               [7:0] m01_cbr_axi4_awlen;
wire                               [2:0] m01_cbr_axi4_awsize;
wire                               [1:0] m01_cbr_axi4_awburst;
wire                               [3:0] m01_cbr_axi4_awregion;
wire                                     m01_cbr_axi4_awlock;
wire                               [3:0] m01_cbr_axi4_awcache;
wire                               [2:0] m01_cbr_axi4_awprot;
wire                               [3:0] m01_cbr_axi4_awqos;
wire                                     m01_cbr_axi4_awvalid;
wire                                     m01_cbr_axi4_awready;
wire                             [511:0] m01_cbr_axi4_wdata;
wire                              [63:0] m01_cbr_axi4_wstrob;
wire                                     m01_cbr_axi4_wlast;
wire                                     m01_cbr_axi4_wvalid;
wire                                     m01_cbr_axi4_wready;
wire                               [7:0] m01_cbr_axi4_bid;
wire                               [1:0] m01_cbr_axi4_bresp;
wire                                     m01_cbr_axi4_bvalid;
wire                                     m01_cbr_axi4_bready;

wire                               [7:0] m01_dcv_axi4_arid;
wire                              [39:0] m01_dcv_axi4_araddr;
wire                               [7:0] m01_dcv_axi4_arlen;
wire                               [2:0] m01_dcv_axi4_arsize;
wire                               [1:0] m01_dcv_axi4_arburst;
wire                               [3:0] m01_dcv_axi4_arregion;
wire                                     m01_dcv_axi4_arlock;
wire                               [3:0] m01_dcv_axi4_arcache;
wire                               [2:0] m01_dcv_axi4_arprot;
wire                               [3:0] m01_dcv_axi4_arqos;
wire                                     m01_dcv_axi4_arvalid;
wire                                     m01_dcv_axi4_arready;
wire                               [7:0] m01_dcv_axi4_rid;
wire                              [63:0] m01_dcv_axi4_rdata;
wire                               [1:0] m01_dcv_axi4_rresp;
wire                                     m01_dcv_axi4_rlast;
wire                                     m01_dcv_axi4_rvalid;
wire                                     m01_dcv_axi4_rready;
wire                               [7:0] m01_dcv_axi4_awid;
wire                              [39:0] m01_dcv_axi4_awaddr;
wire                               [7:0] m01_dcv_axi4_awlen;
wire                               [2:0] m01_dcv_axi4_awsize;
wire                               [1:0] m01_dcv_axi4_awburst;
wire                               [3:0] m01_dcv_axi4_awregion;
wire                                     m01_dcv_axi4_awlock;
wire                               [3:0] m01_dcv_axi4_awcache;
wire                               [2:0] m01_dcv_axi4_awprot;
wire                               [3:0] m01_dcv_axi4_awqos;
wire                                     m01_dcv_axi4_awvalid;
wire                                     m01_dcv_axi4_awready;
wire                              [63:0] m01_dcv_axi4_wdata;
wire                               [7:0] m01_dcv_axi4_wstrob;
wire                                     m01_dcv_axi4_wlast;
wire                                     m01_dcv_axi4_wvalid;
wire                                     m01_dcv_axi4_wready;
wire                               [7:0] m01_dcv_axi4_bid;
wire                               [1:0] m01_dcv_axi4_bresp;
wire                                     m01_dcv_axi4_bvalid;
wire                                     m01_dcv_axi4_bready;

wire                               [7:0] m01_cdc_axi4_arid;
wire                              [39:0] m01_cdc_axi4_araddr;
wire                               [7:0] m01_cdc_axi4_arlen;
wire                               [2:0] m01_cdc_axi4_arsize;
wire                               [1:0] m01_cdc_axi4_arburst;
wire                               [3:0] m01_cdc_axi4_arregion;
wire                                     m01_cdc_axi4_arlock;
wire                               [3:0] m01_cdc_axi4_arcache;
wire                               [2:0] m01_cdc_axi4_arprot;
wire                               [3:0] m01_cdc_axi4_arqos;
wire                                     m01_cdc_axi4_arvalid;
wire                                     m01_cdc_axi4_arready;
wire                               [7:0] m01_cdc_axi4_rid;
wire                              [63:0] m01_cdc_axi4_rdata;
wire                               [1:0] m01_cdc_axi4_rresp;
wire                                     m01_cdc_axi4_rlast;
wire                                     m01_cdc_axi4_rvalid;
wire                                     m01_cdc_axi4_rready;
wire                               [7:0] m01_cdc_axi4_awid;
wire                              [39:0] m01_cdc_axi4_awaddr;
wire                               [7:0] m01_cdc_axi4_awlen;
wire                               [2:0] m01_cdc_axi4_awsize;
wire                               [1:0] m01_cdc_axi4_awburst;
wire                               [3:0] m01_cdc_axi4_awregion;
wire                                     m01_cdc_axi4_awlock;
wire                               [3:0] m01_cdc_axi4_awcache;
wire                               [2:0] m01_cdc_axi4_awprot;
wire                               [3:0] m01_cdc_axi4_awqos;
wire                                     m01_cdc_axi4_awvalid;
wire                                     m01_cdc_axi4_awready;
wire                              [63:0] m01_cdc_axi4_wdata;
wire                               [7:0] m01_cdc_axi4_wstrob;
wire                                     m01_cdc_axi4_wlast;
wire                                     m01_cdc_axi4_wvalid;
wire                                     m01_cdc_axi4_wready;
wire                               [7:0] m01_cdc_axi4_bid;
wire                               [1:0] m01_cdc_axi4_bresp;
wire                                     m01_cdc_axi4_bvalid;
wire                                     m01_cdc_axi4_bready;

axi_interconnect_axi4_adapter #
(
    .WIDTH_S_ID                     (4                          ),
    .WIDTH_M_ID                     (8                          ),
    .WIDTH_S_ADDR                   (32                         ),
    .WIDTH_M_ADDR                   (40                         ),
    .WIDTH_DATA                     (256                        ),
    .U_DLY                          (U_DLY                      )
)
u_s00_axi4_addr_id_adapter
(
    .s_axi4_arid                    (s00_axi4_arid              ),
    .s_axi4_araddr                  (s00_axi4_araddr            ),
    .s_axi4_arlen                   (s00_axi4_arlen             ),
    .s_axi4_arsize                  (s00_axi4_arsize            ),
    .s_axi4_arburst                 (s00_axi4_arburst           ),
    .s_axi4_arregion                (s00_axi4_arregion          ),
    .s_axi4_arlock                  (s00_axi4_arlock            ),
    .s_axi4_arcache                 (s00_axi4_arcache           ),
    .s_axi4_arprot                  (s00_axi4_arprot            ),
    .s_axi4_arqos                   (s00_axi4_arqos             ),
    .s_axi4_arvalid                 (s00_axi4_arvalid           ),
    .s_axi4_arready                 (s00_axi4_arready           ),
    .s_axi4_rid                     (s00_axi4_rid               ),
    .s_axi4_rdata                   (s00_axi4_rdata             ),
    .s_axi4_rresp                   (s00_axi4_rresp             ),
    .s_axi4_rlast                   (s00_axi4_rlast             ),
    .s_axi4_rvalid                  (s00_axi4_rvalid            ),
    .s_axi4_rready                  (s00_axi4_rready            ),
    .s_axi4_awid                    (s00_axi4_awid              ),
    .s_axi4_awaddr                  (s00_axi4_awaddr            ),
    .s_axi4_awlen                   (s00_axi4_awlen             ),
    .s_axi4_awsize                  (s00_axi4_awsize            ),
    .s_axi4_awburst                 (s00_axi4_awburst           ),
    .s_axi4_awregion                (s00_axi4_awregion          ),
    .s_axi4_awlock                  (s00_axi4_awlock            ),
    .s_axi4_awcache                 (s00_axi4_awcache           ),
    .s_axi4_awprot                  (s00_axi4_awprot            ),
    .s_axi4_awqos                   (s00_axi4_awqos             ),
    .s_axi4_awvalid                 (s00_axi4_awvalid           ),
    .s_axi4_awready                 (s00_axi4_awready           ),
    .s_axi4_wdata                   (s00_axi4_wdata             ),
    .s_axi4_wstrob                  (s00_axi4_wstrob            ),
    .s_axi4_wlast                   (s00_axi4_wlast             ),
    .s_axi4_wvalid                  (s00_axi4_wvalid            ),
    .s_axi4_wready                  (s00_axi4_wready            ),
    .s_axi4_bid                     (s00_axi4_bid               ),
    .s_axi4_bresp                   (s00_axi4_bresp             ),
    .s_axi4_bvalid                  (s00_axi4_bvalid            ),
    .s_axi4_bready                  (s00_axi4_bready            ),
    .m_axi4_arid                    (s00_adp_axi4_arid          ),
    .m_axi4_araddr                  (s00_adp_axi4_araddr        ),
    .m_axi4_arlen                   (s00_adp_axi4_arlen         ),
    .m_axi4_arsize                  (s00_adp_axi4_arsize        ),
    .m_axi4_arburst                 (s00_adp_axi4_arburst       ),
    .m_axi4_arregion                (s00_adp_axi4_arregion      ),
    .m_axi4_arlock                  (s00_adp_axi4_arlock        ),
    .m_axi4_arcache                 (s00_adp_axi4_arcache       ),
    .m_axi4_arprot                  (s00_adp_axi4_arprot        ),
    .m_axi4_arqos                   (s00_adp_axi4_arqos         ),
    .m_axi4_arvalid                 (s00_adp_axi4_arvalid       ),
    .m_axi4_arready                 (s00_adp_axi4_arready       ),
    .m_axi4_rid                     (s00_adp_axi4_rid           ),
    .m_axi4_rdata                   (s00_adp_axi4_rdata         ),
    .m_axi4_rresp                   (s00_adp_axi4_rresp         ),
    .m_axi4_rlast                   (s00_adp_axi4_rlast         ),
    .m_axi4_rvalid                  (s00_adp_axi4_rvalid        ),
    .m_axi4_rready                  (s00_adp_axi4_rready        ),
    .m_axi4_awid                    (s00_adp_axi4_awid          ),
    .m_axi4_awaddr                  (s00_adp_axi4_awaddr        ),
    .m_axi4_awlen                   (s00_adp_axi4_awlen         ),
    .m_axi4_awsize                  (s00_adp_axi4_awsize        ),
    .m_axi4_awburst                 (s00_adp_axi4_awburst       ),
    .m_axi4_awregion                (s00_adp_axi4_awregion      ),
    .m_axi4_awlock                  (s00_adp_axi4_awlock        ),
    .m_axi4_awcache                 (s00_adp_axi4_awcache       ),
    .m_axi4_awprot                  (s00_adp_axi4_awprot        ),
    .m_axi4_awqos                   (s00_adp_axi4_awqos         ),
    .m_axi4_awvalid                 (s00_adp_axi4_awvalid       ),
    .m_axi4_awready                 (s00_adp_axi4_awready       ),
    .m_axi4_wdata                   (s00_adp_axi4_wdata         ),
    .m_axi4_wstrob                  (s00_adp_axi4_wstrob        ),
    .m_axi4_wlast                   (s00_adp_axi4_wlast         ),
    .m_axi4_wvalid                  (s00_adp_axi4_wvalid        ),
    .m_axi4_wready                  (s00_adp_axi4_wready        ),
    .m_axi4_bid                     (s00_adp_axi4_bid           ),
    .m_axi4_bresp                   (s00_adp_axi4_bresp         ),
    .m_axi4_bvalid                  (s00_adp_axi4_bvalid        ),
    .m_axi4_bready                  (s00_adp_axi4_bready        )
);

assign s00_cdc_axi4_arid = s00_adp_axi4_arid;
assign s00_cdc_axi4_araddr = s00_adp_axi4_araddr;
assign s00_cdc_axi4_arlen = s00_adp_axi4_arlen;
assign s00_cdc_axi4_arsize = s00_adp_axi4_arsize;
assign s00_cdc_axi4_arburst = s00_adp_axi4_arburst;
assign s00_cdc_axi4_arregion = s00_adp_axi4_arregion;
assign s00_cdc_axi4_arlock = s00_adp_axi4_arlock;
assign s00_cdc_axi4_arcache = s00_adp_axi4_arcache;
assign s00_cdc_axi4_arprot = s00_adp_axi4_arprot;
assign s00_cdc_axi4_arqos = s00_adp_axi4_arqos;
assign s00_cdc_axi4_arvalid = s00_adp_axi4_arvalid;
assign s00_adp_axi4_arready = s00_cdc_axi4_arready;
assign s00_adp_axi4_rid = s00_cdc_axi4_rid;
assign s00_adp_axi4_rdata = s00_cdc_axi4_rdata;
assign s00_adp_axi4_rresp = s00_cdc_axi4_rresp;
assign s00_adp_axi4_rlast = s00_cdc_axi4_rlast;
assign s00_adp_axi4_rvalid = s00_cdc_axi4_rvalid;
assign s00_cdc_axi4_rready = s00_adp_axi4_rready;
assign s00_cdc_axi4_awid = s00_adp_axi4_awid;
assign s00_cdc_axi4_awaddr = s00_adp_axi4_awaddr;
assign s00_cdc_axi4_awlen = s00_adp_axi4_awlen;
assign s00_cdc_axi4_awsize = s00_adp_axi4_awsize;
assign s00_cdc_axi4_awburst = s00_adp_axi4_awburst;
assign s00_cdc_axi4_awregion = s00_adp_axi4_awregion;
assign s00_cdc_axi4_awlock = s00_adp_axi4_awlock;
assign s00_cdc_axi4_awcache = s00_adp_axi4_awcache;
assign s00_cdc_axi4_awprot = s00_adp_axi4_awprot;
assign s00_cdc_axi4_awqos = s00_adp_axi4_awqos;
assign s00_cdc_axi4_awvalid = s00_adp_axi4_awvalid;
assign s00_adp_axi4_awready = s00_cdc_axi4_awready;
assign s00_cdc_axi4_wdata = s00_adp_axi4_wdata;
assign s00_cdc_axi4_wstrob = s00_adp_axi4_wstrob;
assign s00_cdc_axi4_wlast = s00_adp_axi4_wlast;
assign s00_cdc_axi4_wvalid = s00_adp_axi4_wvalid;
assign s00_adp_axi4_wready = s00_cdc_axi4_wready;
assign s00_adp_axi4_bid = s00_cdc_axi4_bid;
assign s00_adp_axi4_bresp = s00_cdc_axi4_bresp;
assign s00_adp_axi4_bvalid = s00_cdc_axi4_bvalid;
assign s00_cdc_axi4_bready = s00_adp_axi4_bready;

axi_interconnect_width_convert #
(
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_SDATA                    (256                        ),
    .WIDTH_MDATA                    (512                        ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .NUM_OUTSTANDING                (4                          ),
    .U_DLY                          (U_DLY                      )
)
u_s00_axi4_width_convert
(
    .clk_sys                        (clk_sys                    ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (s00_cdc_axi4_arid          ),
    .s_axi4_araddr                  (s00_cdc_axi4_araddr        ),
    .s_axi4_arlen                   (s00_cdc_axi4_arlen         ),
    .s_axi4_arsize                  (s00_cdc_axi4_arsize        ),
    .s_axi4_arburst                 (s00_cdc_axi4_arburst       ),
    .s_axi4_arregion                (s00_cdc_axi4_arregion      ),
    .s_axi4_arlock                  (s00_cdc_axi4_arlock        ),
    .s_axi4_arcache                 (s00_cdc_axi4_arcache       ),
    .s_axi4_arprot                  (s00_cdc_axi4_arprot        ),
    .s_axi4_arqos                   (s00_cdc_axi4_arqos         ),
    .s_axi4_arvalid                 (s00_cdc_axi4_arvalid       ),
    .s_axi4_arready                 (s00_cdc_axi4_arready       ),
    .s_axi4_rid                     (s00_cdc_axi4_rid           ),
    .s_axi4_rdata                   (s00_cdc_axi4_rdata         ),
    .s_axi4_rresp                   (s00_cdc_axi4_rresp         ),
    .s_axi4_rlast                   (s00_cdc_axi4_rlast         ),
    .s_axi4_rvalid                  (s00_cdc_axi4_rvalid        ),
    .s_axi4_rready                  (s00_cdc_axi4_rready        ),
    .s_axi4_awid                    (s00_cdc_axi4_awid          ),
    .s_axi4_awaddr                  (s00_cdc_axi4_awaddr        ),
    .s_axi4_awlen                   (s00_cdc_axi4_awlen         ),
    .s_axi4_awsize                  (s00_cdc_axi4_awsize        ),
    .s_axi4_awburst                 (s00_cdc_axi4_awburst       ),
    .s_axi4_awregion                (s00_cdc_axi4_awregion      ),
    .s_axi4_awlock                  (s00_cdc_axi4_awlock        ),
    .s_axi4_awcache                 (s00_cdc_axi4_awcache       ),
    .s_axi4_awprot                  (s00_cdc_axi4_awprot        ),
    .s_axi4_awqos                   (s00_cdc_axi4_awqos         ),
    .s_axi4_awvalid                 (s00_cdc_axi4_awvalid       ),
    .s_axi4_awready                 (s00_cdc_axi4_awready       ),
    .s_axi4_wdata                   (s00_cdc_axi4_wdata         ),
    .s_axi4_wstrob                  (s00_cdc_axi4_wstrob        ),
    .s_axi4_wlast                   (s00_cdc_axi4_wlast         ),
    .s_axi4_wvalid                  (s00_cdc_axi4_wvalid        ),
    .s_axi4_wready                  (s00_cdc_axi4_wready        ),
    .s_axi4_bid                     (s00_cdc_axi4_bid           ),
    .s_axi4_bresp                   (s00_cdc_axi4_bresp         ),
    .s_axi4_bvalid                  (s00_cdc_axi4_bvalid        ),
    .s_axi4_bready                  (s00_cdc_axi4_bready        ),
    .s_axi4_aruser                  (1'b0                       ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  (1'b0                       ),
    .s_axi4_wuser                   (1'b0                       ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (s00_dcv_axi4_arid          ),
    .m_axi4_araddr                  (s00_dcv_axi4_araddr        ),
    .m_axi4_arlen                   (s00_dcv_axi4_arlen         ),
    .m_axi4_arsize                  (s00_dcv_axi4_arsize        ),
    .m_axi4_arburst                 (s00_dcv_axi4_arburst       ),
    .m_axi4_arregion                (s00_dcv_axi4_arregion      ),
    .m_axi4_arlock                  (s00_dcv_axi4_arlock        ),
    .m_axi4_arcache                 (s00_dcv_axi4_arcache       ),
    .m_axi4_arprot                  (s00_dcv_axi4_arprot        ),
    .m_axi4_arqos                   (s00_dcv_axi4_arqos         ),
    .m_axi4_arvalid                 (s00_dcv_axi4_arvalid       ),
    .m_axi4_arready                 (s00_dcv_axi4_arready       ),
    .m_axi4_rid                     (s00_dcv_axi4_rid           ),
    .m_axi4_rdata                   (s00_dcv_axi4_rdata         ),
    .m_axi4_rresp                   (s00_dcv_axi4_rresp         ),
    .m_axi4_rlast                   (s00_dcv_axi4_rlast         ),
    .m_axi4_rvalid                  (s00_dcv_axi4_rvalid        ),
    .m_axi4_rready                  (s00_dcv_axi4_rready        ),
    .m_axi4_awid                    (s00_dcv_axi4_awid          ),
    .m_axi4_awaddr                  (s00_dcv_axi4_awaddr        ),
    .m_axi4_awlen                   (s00_dcv_axi4_awlen         ),
    .m_axi4_awsize                  (s00_dcv_axi4_awsize        ),
    .m_axi4_awburst                 (s00_dcv_axi4_awburst       ),
    .m_axi4_awregion                (s00_dcv_axi4_awregion      ),
    .m_axi4_awlock                  (s00_dcv_axi4_awlock        ),
    .m_axi4_awcache                 (s00_dcv_axi4_awcache       ),
    .m_axi4_awprot                  (s00_dcv_axi4_awprot        ),
    .m_axi4_awqos                   (s00_dcv_axi4_awqos         ),
    .m_axi4_awvalid                 (s00_dcv_axi4_awvalid       ),
    .m_axi4_awready                 (s00_dcv_axi4_awready       ),
    .m_axi4_wdata                   (s00_dcv_axi4_wdata         ),
    .m_axi4_wstrob                  (s00_dcv_axi4_wstrob        ),
    .m_axi4_wlast                   (s00_dcv_axi4_wlast         ),
    .m_axi4_wvalid                  (s00_dcv_axi4_wvalid        ),
    .m_axi4_wready                  (s00_dcv_axi4_wready        ),
    .m_axi4_bid                     (s00_dcv_axi4_bid           ),
    .m_axi4_bresp                   (s00_dcv_axi4_bresp         ),
    .m_axi4_bvalid                  (s00_dcv_axi4_bvalid        ),
    .m_axi4_bready                  (s00_dcv_axi4_bready        ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   (1'b0                       ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   (1'b0                       )
);

assign s_cbr_axi4_arid[0+:8] = s00_dcv_axi4_arid;
assign s_cbr_axi4_araddr[0+:40] = s00_dcv_axi4_araddr;
assign s_cbr_axi4_arlen[0+:8] = s00_dcv_axi4_arlen;
assign s_cbr_axi4_arsize[0+:3] = s00_dcv_axi4_arsize;
assign s_cbr_axi4_arburst[0+:2] = s00_dcv_axi4_arburst;
assign s_cbr_axi4_arregion[0+:4] = s00_dcv_axi4_arregion;
assign s_cbr_axi4_arlock[0] = s00_dcv_axi4_arlock;
assign s_cbr_axi4_arcache[0+:4] = s00_dcv_axi4_arcache;
assign s_cbr_axi4_arprot[0+:3] = s00_dcv_axi4_arprot;
assign s_cbr_axi4_arqos[0+:4] = s00_dcv_axi4_arqos;
assign s_cbr_axi4_arvalid[0] = s00_dcv_axi4_arvalid;
assign s00_dcv_axi4_arready = s_cbr_axi4_arready[0];
assign s00_dcv_axi4_rid = s_cbr_axi4_rid[0+:8];
assign s00_dcv_axi4_rdata = s_cbr_axi4_rdata[0+:512];
assign s00_dcv_axi4_rresp = s_cbr_axi4_rresp[0+:2];
assign s00_dcv_axi4_rlast = s_cbr_axi4_rlast[0];
assign s00_dcv_axi4_rvalid = s_cbr_axi4_rvalid[0];
assign s_cbr_axi4_rready[0] = s00_dcv_axi4_rready;
assign s_cbr_axi4_awid[0+:8] = s00_dcv_axi4_awid;
assign s_cbr_axi4_awaddr[0+:40] = s00_dcv_axi4_awaddr;
assign s_cbr_axi4_awlen[0+:8] = s00_dcv_axi4_awlen;
assign s_cbr_axi4_awsize[0+:3] = s00_dcv_axi4_awsize;
assign s_cbr_axi4_awburst[0+:2] = s00_dcv_axi4_awburst;
assign s_cbr_axi4_awregion[0+:4] = s00_dcv_axi4_awregion;
assign s_cbr_axi4_awlock[0] = s00_dcv_axi4_awlock;
assign s_cbr_axi4_awcache[0+:4] = s00_dcv_axi4_awcache;
assign s_cbr_axi4_awprot[0+:3] = s00_dcv_axi4_awprot;
assign s_cbr_axi4_awqos[0+:4] = s00_dcv_axi4_awqos;
assign s_cbr_axi4_awvalid[0] = s00_dcv_axi4_awvalid;
assign s00_dcv_axi4_awready = s_cbr_axi4_awready[0];
assign s_cbr_axi4_wdata[0+:512] = s00_dcv_axi4_wdata;
assign s_cbr_axi4_wstrob[0+:64] = s00_dcv_axi4_wstrob;
assign s_cbr_axi4_wlast[0] = s00_dcv_axi4_wlast;
assign s_cbr_axi4_wvalid[0] = s00_dcv_axi4_wvalid;
assign s00_dcv_axi4_wready = s_cbr_axi4_wready[0];
assign s00_dcv_axi4_bid = s_cbr_axi4_bid[0+:8];
assign s00_dcv_axi4_bresp = s_cbr_axi4_bresp[0+:2];
assign s00_dcv_axi4_bvalid = s_cbr_axi4_bvalid[0];
assign s_cbr_axi4_bready[0] = s00_dcv_axi4_bready;

axi_interconnect_axi4_adapter #
(
    .WIDTH_S_ID                     (8                          ),
    .WIDTH_M_ID                     (8                          ),
    .WIDTH_S_ADDR                   (40                         ),
    .WIDTH_M_ADDR                   (40                         ),
    .WIDTH_DATA                     (128                        ),
    .U_DLY                          (U_DLY                      )
)
u_s01_axi4_addr_id_adapter
(
    .s_axi4_arid                    (s01_axi4_arid              ),
    .s_axi4_araddr                  (s01_axi4_araddr            ),
    .s_axi4_arlen                   (s01_axi4_arlen             ),
    .s_axi4_arsize                  (s01_axi4_arsize            ),
    .s_axi4_arburst                 (s01_axi4_arburst           ),
    .s_axi4_arregion                (s01_axi4_arregion          ),
    .s_axi4_arlock                  (s01_axi4_arlock            ),
    .s_axi4_arcache                 (s01_axi4_arcache           ),
    .s_axi4_arprot                  (s01_axi4_arprot            ),
    .s_axi4_arqos                   (s01_axi4_arqos             ),
    .s_axi4_arvalid                 (s01_axi4_arvalid           ),
    .s_axi4_arready                 (s01_axi4_arready           ),
    .s_axi4_rid                     (s01_axi4_rid               ),
    .s_axi4_rdata                   (s01_axi4_rdata             ),
    .s_axi4_rresp                   (s01_axi4_rresp             ),
    .s_axi4_rlast                   (s01_axi4_rlast             ),
    .s_axi4_rvalid                  (s01_axi4_rvalid            ),
    .s_axi4_rready                  (s01_axi4_rready            ),
    .s_axi4_awid                    (s01_axi4_awid              ),
    .s_axi4_awaddr                  (s01_axi4_awaddr            ),
    .s_axi4_awlen                   (s01_axi4_awlen             ),
    .s_axi4_awsize                  (s01_axi4_awsize            ),
    .s_axi4_awburst                 (s01_axi4_awburst           ),
    .s_axi4_awregion                (s01_axi4_awregion          ),
    .s_axi4_awlock                  (s01_axi4_awlock            ),
    .s_axi4_awcache                 (s01_axi4_awcache           ),
    .s_axi4_awprot                  (s01_axi4_awprot            ),
    .s_axi4_awqos                   (s01_axi4_awqos             ),
    .s_axi4_awvalid                 (s01_axi4_awvalid           ),
    .s_axi4_awready                 (s01_axi4_awready           ),
    .s_axi4_wdata                   (s01_axi4_wdata             ),
    .s_axi4_wstrob                  (s01_axi4_wstrob            ),
    .s_axi4_wlast                   (s01_axi4_wlast             ),
    .s_axi4_wvalid                  (s01_axi4_wvalid            ),
    .s_axi4_wready                  (s01_axi4_wready            ),
    .s_axi4_bid                     (s01_axi4_bid               ),
    .s_axi4_bresp                   (s01_axi4_bresp             ),
    .s_axi4_bvalid                  (s01_axi4_bvalid            ),
    .s_axi4_bready                  (s01_axi4_bready            ),
    .m_axi4_arid                    (s01_adp_axi4_arid          ),
    .m_axi4_araddr                  (s01_adp_axi4_araddr        ),
    .m_axi4_arlen                   (s01_adp_axi4_arlen         ),
    .m_axi4_arsize                  (s01_adp_axi4_arsize        ),
    .m_axi4_arburst                 (s01_adp_axi4_arburst       ),
    .m_axi4_arregion                (s01_adp_axi4_arregion      ),
    .m_axi4_arlock                  (s01_adp_axi4_arlock        ),
    .m_axi4_arcache                 (s01_adp_axi4_arcache       ),
    .m_axi4_arprot                  (s01_adp_axi4_arprot        ),
    .m_axi4_arqos                   (s01_adp_axi4_arqos         ),
    .m_axi4_arvalid                 (s01_adp_axi4_arvalid       ),
    .m_axi4_arready                 (s01_adp_axi4_arready       ),
    .m_axi4_rid                     (s01_adp_axi4_rid           ),
    .m_axi4_rdata                   (s01_adp_axi4_rdata         ),
    .m_axi4_rresp                   (s01_adp_axi4_rresp         ),
    .m_axi4_rlast                   (s01_adp_axi4_rlast         ),
    .m_axi4_rvalid                  (s01_adp_axi4_rvalid        ),
    .m_axi4_rready                  (s01_adp_axi4_rready        ),
    .m_axi4_awid                    (s01_adp_axi4_awid          ),
    .m_axi4_awaddr                  (s01_adp_axi4_awaddr        ),
    .m_axi4_awlen                   (s01_adp_axi4_awlen         ),
    .m_axi4_awsize                  (s01_adp_axi4_awsize        ),
    .m_axi4_awburst                 (s01_adp_axi4_awburst       ),
    .m_axi4_awregion                (s01_adp_axi4_awregion      ),
    .m_axi4_awlock                  (s01_adp_axi4_awlock        ),
    .m_axi4_awcache                 (s01_adp_axi4_awcache       ),
    .m_axi4_awprot                  (s01_adp_axi4_awprot        ),
    .m_axi4_awqos                   (s01_adp_axi4_awqos         ),
    .m_axi4_awvalid                 (s01_adp_axi4_awvalid       ),
    .m_axi4_awready                 (s01_adp_axi4_awready       ),
    .m_axi4_wdata                   (s01_adp_axi4_wdata         ),
    .m_axi4_wstrob                  (s01_adp_axi4_wstrob        ),
    .m_axi4_wlast                   (s01_adp_axi4_wlast         ),
    .m_axi4_wvalid                  (s01_adp_axi4_wvalid        ),
    .m_axi4_wready                  (s01_adp_axi4_wready        ),
    .m_axi4_bid                     (s01_adp_axi4_bid           ),
    .m_axi4_bresp                   (s01_adp_axi4_bresp         ),
    .m_axi4_bvalid                  (s01_adp_axi4_bvalid        ),
    .m_axi4_bready                  (s01_adp_axi4_bready        )
);

axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_DATA                     (128                        ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .HAS_LOCK                       (1                          ),
    .HAS_CACHE                      (1                          ),
    .HAS_PROT                       (1                          ),
    .HAS_QOS                        (1                          ),
    .HAS_REGION                     (1                          ),
    .U_DLY                          (U_DLY                      )
)
u_s01_axi4_clock_convert
(
    .clk_s                          (s01_axi4_clk               ),
    .clk_m                          (clk_sys                    ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (s01_adp_axi4_arid          ),
    .s_axi4_araddr                  (s01_adp_axi4_araddr        ),
    .s_axi4_arlen                   (s01_adp_axi4_arlen         ),
    .s_axi4_arsize                  (s01_adp_axi4_arsize        ),
    .s_axi4_arburst                 (s01_adp_axi4_arburst       ),
    .s_axi4_arregion                (s01_adp_axi4_arregion      ),
    .s_axi4_arlock                  (s01_adp_axi4_arlock        ),
    .s_axi4_arcache                 (s01_adp_axi4_arcache       ),
    .s_axi4_arprot                  (s01_adp_axi4_arprot        ),
    .s_axi4_arqos                   (s01_adp_axi4_arqos         ),
    .s_axi4_arvalid                 (s01_adp_axi4_arvalid       ),
    .s_axi4_arready                 (s01_adp_axi4_arready       ),
    .s_axi4_rid                     (s01_adp_axi4_rid           ),
    .s_axi4_rdata                   (s01_adp_axi4_rdata         ),
    .s_axi4_rresp                   (s01_adp_axi4_rresp         ),
    .s_axi4_rlast                   (s01_adp_axi4_rlast         ),
    .s_axi4_rvalid                  (s01_adp_axi4_rvalid        ),
    .s_axi4_rready                  (s01_adp_axi4_rready        ),
    .s_axi4_awid                    (s01_adp_axi4_awid          ),
    .s_axi4_awaddr                  (s01_adp_axi4_awaddr        ),
    .s_axi4_awlen                   (s01_adp_axi4_awlen         ),
    .s_axi4_awsize                  (s01_adp_axi4_awsize        ),
    .s_axi4_awburst                 (s01_adp_axi4_awburst       ),
    .s_axi4_awregion                (s01_adp_axi4_awregion      ),
    .s_axi4_awlock                  (s01_adp_axi4_awlock        ),
    .s_axi4_awcache                 (s01_adp_axi4_awcache       ),
    .s_axi4_awprot                  (s01_adp_axi4_awprot        ),
    .s_axi4_awqos                   (s01_adp_axi4_awqos         ),
    .s_axi4_awvalid                 (s01_adp_axi4_awvalid       ),
    .s_axi4_awready                 (s01_adp_axi4_awready       ),
    .s_axi4_wdata                   (s01_adp_axi4_wdata         ),
    .s_axi4_wstrob                  (s01_adp_axi4_wstrob        ),
    .s_axi4_wlast                   (s01_adp_axi4_wlast         ),
    .s_axi4_wvalid                  (s01_adp_axi4_wvalid        ),
    .s_axi4_wready                  (s01_adp_axi4_wready        ),
    .s_axi4_bid                     (s01_adp_axi4_bid           ),
    .s_axi4_bresp                   (s01_adp_axi4_bresp         ),
    .s_axi4_bvalid                  (s01_adp_axi4_bvalid        ),
    .s_axi4_bready                  (s01_adp_axi4_bready        ),
    .s_axi4_wid                     (s01_adp_axi4_awid          ),
    .s_axi4_aruser                  (1'b0                       ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  (1'b0                       ),
    .s_axi4_wuser                   (1'b0                       ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (s01_cdc_axi4_arid          ),
    .m_axi4_araddr                  (s01_cdc_axi4_araddr        ),
    .m_axi4_arlen                   (s01_cdc_axi4_arlen         ),
    .m_axi4_arsize                  (s01_cdc_axi4_arsize        ),
    .m_axi4_arburst                 (s01_cdc_axi4_arburst       ),
    .m_axi4_arregion                (s01_cdc_axi4_arregion      ),
    .m_axi4_arlock                  (s01_cdc_axi4_arlock        ),
    .m_axi4_arcache                 (s01_cdc_axi4_arcache       ),
    .m_axi4_arprot                  (s01_cdc_axi4_arprot        ),
    .m_axi4_arqos                   (s01_cdc_axi4_arqos         ),
    .m_axi4_arvalid                 (s01_cdc_axi4_arvalid       ),
    .m_axi4_arready                 (s01_cdc_axi4_arready       ),
    .m_axi4_rid                     (s01_cdc_axi4_rid           ),
    .m_axi4_rdata                   (s01_cdc_axi4_rdata         ),
    .m_axi4_rresp                   (s01_cdc_axi4_rresp         ),
    .m_axi4_rlast                   (s01_cdc_axi4_rlast         ),
    .m_axi4_rvalid                  (s01_cdc_axi4_rvalid        ),
    .m_axi4_rready                  (s01_cdc_axi4_rready        ),
    .m_axi4_awid                    (s01_cdc_axi4_awid          ),
    .m_axi4_awaddr                  (s01_cdc_axi4_awaddr        ),
    .m_axi4_awlen                   (s01_cdc_axi4_awlen         ),
    .m_axi4_awsize                  (s01_cdc_axi4_awsize        ),
    .m_axi4_awburst                 (s01_cdc_axi4_awburst       ),
    .m_axi4_awregion                (s01_cdc_axi4_awregion      ),
    .m_axi4_awlock                  (s01_cdc_axi4_awlock        ),
    .m_axi4_awcache                 (s01_cdc_axi4_awcache       ),
    .m_axi4_awprot                  (s01_cdc_axi4_awprot        ),
    .m_axi4_awqos                   (s01_cdc_axi4_awqos         ),
    .m_axi4_awvalid                 (s01_cdc_axi4_awvalid       ),
    .m_axi4_awready                 (s01_cdc_axi4_awready       ),
    .m_axi4_wdata                   (s01_cdc_axi4_wdata         ),
    .m_axi4_wstrob                  (s01_cdc_axi4_wstrob        ),
    .m_axi4_wlast                   (s01_cdc_axi4_wlast         ),
    .m_axi4_wvalid                  (s01_cdc_axi4_wvalid        ),
    .m_axi4_wready                  (s01_cdc_axi4_wready        ),
    .m_axi4_bid                     (s01_cdc_axi4_bid           ),
    .m_axi4_bresp                   (s01_cdc_axi4_bresp         ),
    .m_axi4_bvalid                  (s01_cdc_axi4_bvalid        ),
    .m_axi4_bready                  (s01_cdc_axi4_bready        ),
    .m_axi4_wid                     (                           ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   (1'b0                       ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   (1'b0                       )
);

axi_interconnect_width_convert #
(
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_SDATA                    (128                        ),
    .WIDTH_MDATA                    (512                        ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .NUM_OUTSTANDING                (4                          ),
    .U_DLY                          (U_DLY                      )
)
u_s01_axi4_width_convert
(
    .clk_sys                        (clk_sys                    ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (s01_cdc_axi4_arid          ),
    .s_axi4_araddr                  (s01_cdc_axi4_araddr        ),
    .s_axi4_arlen                   (s01_cdc_axi4_arlen         ),
    .s_axi4_arsize                  (s01_cdc_axi4_arsize        ),
    .s_axi4_arburst                 (s01_cdc_axi4_arburst       ),
    .s_axi4_arregion                (s01_cdc_axi4_arregion      ),
    .s_axi4_arlock                  (s01_cdc_axi4_arlock        ),
    .s_axi4_arcache                 (s01_cdc_axi4_arcache       ),
    .s_axi4_arprot                  (s01_cdc_axi4_arprot        ),
    .s_axi4_arqos                   (s01_cdc_axi4_arqos         ),
    .s_axi4_arvalid                 (s01_cdc_axi4_arvalid       ),
    .s_axi4_arready                 (s01_cdc_axi4_arready       ),
    .s_axi4_rid                     (s01_cdc_axi4_rid           ),
    .s_axi4_rdata                   (s01_cdc_axi4_rdata         ),
    .s_axi4_rresp                   (s01_cdc_axi4_rresp         ),
    .s_axi4_rlast                   (s01_cdc_axi4_rlast         ),
    .s_axi4_rvalid                  (s01_cdc_axi4_rvalid        ),
    .s_axi4_rready                  (s01_cdc_axi4_rready        ),
    .s_axi4_awid                    (s01_cdc_axi4_awid          ),
    .s_axi4_awaddr                  (s01_cdc_axi4_awaddr        ),
    .s_axi4_awlen                   (s01_cdc_axi4_awlen         ),
    .s_axi4_awsize                  (s01_cdc_axi4_awsize        ),
    .s_axi4_awburst                 (s01_cdc_axi4_awburst       ),
    .s_axi4_awregion                (s01_cdc_axi4_awregion      ),
    .s_axi4_awlock                  (s01_cdc_axi4_awlock        ),
    .s_axi4_awcache                 (s01_cdc_axi4_awcache       ),
    .s_axi4_awprot                  (s01_cdc_axi4_awprot        ),
    .s_axi4_awqos                   (s01_cdc_axi4_awqos         ),
    .s_axi4_awvalid                 (s01_cdc_axi4_awvalid       ),
    .s_axi4_awready                 (s01_cdc_axi4_awready       ),
    .s_axi4_wdata                   (s01_cdc_axi4_wdata         ),
    .s_axi4_wstrob                  (s01_cdc_axi4_wstrob        ),
    .s_axi4_wlast                   (s01_cdc_axi4_wlast         ),
    .s_axi4_wvalid                  (s01_cdc_axi4_wvalid        ),
    .s_axi4_wready                  (s01_cdc_axi4_wready        ),
    .s_axi4_bid                     (s01_cdc_axi4_bid           ),
    .s_axi4_bresp                   (s01_cdc_axi4_bresp         ),
    .s_axi4_bvalid                  (s01_cdc_axi4_bvalid        ),
    .s_axi4_bready                  (s01_cdc_axi4_bready        ),
    .s_axi4_aruser                  (1'b0                       ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  (1'b0                       ),
    .s_axi4_wuser                   (1'b0                       ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (s01_dcv_axi4_arid          ),
    .m_axi4_araddr                  (s01_dcv_axi4_araddr        ),
    .m_axi4_arlen                   (s01_dcv_axi4_arlen         ),
    .m_axi4_arsize                  (s01_dcv_axi4_arsize        ),
    .m_axi4_arburst                 (s01_dcv_axi4_arburst       ),
    .m_axi4_arregion                (s01_dcv_axi4_arregion      ),
    .m_axi4_arlock                  (s01_dcv_axi4_arlock        ),
    .m_axi4_arcache                 (s01_dcv_axi4_arcache       ),
    .m_axi4_arprot                  (s01_dcv_axi4_arprot        ),
    .m_axi4_arqos                   (s01_dcv_axi4_arqos         ),
    .m_axi4_arvalid                 (s01_dcv_axi4_arvalid       ),
    .m_axi4_arready                 (s01_dcv_axi4_arready       ),
    .m_axi4_rid                     (s01_dcv_axi4_rid           ),
    .m_axi4_rdata                   (s01_dcv_axi4_rdata         ),
    .m_axi4_rresp                   (s01_dcv_axi4_rresp         ),
    .m_axi4_rlast                   (s01_dcv_axi4_rlast         ),
    .m_axi4_rvalid                  (s01_dcv_axi4_rvalid        ),
    .m_axi4_rready                  (s01_dcv_axi4_rready        ),
    .m_axi4_awid                    (s01_dcv_axi4_awid          ),
    .m_axi4_awaddr                  (s01_dcv_axi4_awaddr        ),
    .m_axi4_awlen                   (s01_dcv_axi4_awlen         ),
    .m_axi4_awsize                  (s01_dcv_axi4_awsize        ),
    .m_axi4_awburst                 (s01_dcv_axi4_awburst       ),
    .m_axi4_awregion                (s01_dcv_axi4_awregion      ),
    .m_axi4_awlock                  (s01_dcv_axi4_awlock        ),
    .m_axi4_awcache                 (s01_dcv_axi4_awcache       ),
    .m_axi4_awprot                  (s01_dcv_axi4_awprot        ),
    .m_axi4_awqos                   (s01_dcv_axi4_awqos         ),
    .m_axi4_awvalid                 (s01_dcv_axi4_awvalid       ),
    .m_axi4_awready                 (s01_dcv_axi4_awready       ),
    .m_axi4_wdata                   (s01_dcv_axi4_wdata         ),
    .m_axi4_wstrob                  (s01_dcv_axi4_wstrob        ),
    .m_axi4_wlast                   (s01_dcv_axi4_wlast         ),
    .m_axi4_wvalid                  (s01_dcv_axi4_wvalid        ),
    .m_axi4_wready                  (s01_dcv_axi4_wready        ),
    .m_axi4_bid                     (s01_dcv_axi4_bid           ),
    .m_axi4_bresp                   (s01_dcv_axi4_bresp         ),
    .m_axi4_bvalid                  (s01_dcv_axi4_bvalid        ),
    .m_axi4_bready                  (s01_dcv_axi4_bready        ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   (1'b0                       ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   (1'b0                       )
);

assign s_cbr_axi4_arid[8+:8] = s01_dcv_axi4_arid;
assign s_cbr_axi4_araddr[40+:40] = s01_dcv_axi4_araddr;
assign s_cbr_axi4_arlen[8+:8] = s01_dcv_axi4_arlen;
assign s_cbr_axi4_arsize[3+:3] = s01_dcv_axi4_arsize;
assign s_cbr_axi4_arburst[2+:2] = s01_dcv_axi4_arburst;
assign s_cbr_axi4_arregion[4+:4] = s01_dcv_axi4_arregion;
assign s_cbr_axi4_arlock[1] = s01_dcv_axi4_arlock;
assign s_cbr_axi4_arcache[4+:4] = s01_dcv_axi4_arcache;
assign s_cbr_axi4_arprot[3+:3] = s01_dcv_axi4_arprot;
assign s_cbr_axi4_arqos[4+:4] = s01_dcv_axi4_arqos;
assign s_cbr_axi4_arvalid[1] = s01_dcv_axi4_arvalid;
assign s01_dcv_axi4_arready = s_cbr_axi4_arready[1];
assign s01_dcv_axi4_rid = s_cbr_axi4_rid[8+:8];
assign s01_dcv_axi4_rdata = s_cbr_axi4_rdata[512+:512];
assign s01_dcv_axi4_rresp = s_cbr_axi4_rresp[2+:2];
assign s01_dcv_axi4_rlast = s_cbr_axi4_rlast[1];
assign s01_dcv_axi4_rvalid = s_cbr_axi4_rvalid[1];
assign s_cbr_axi4_rready[1] = s01_dcv_axi4_rready;
assign s_cbr_axi4_awid[8+:8] = s01_dcv_axi4_awid;
assign s_cbr_axi4_awaddr[40+:40] = s01_dcv_axi4_awaddr;
assign s_cbr_axi4_awlen[8+:8] = s01_dcv_axi4_awlen;
assign s_cbr_axi4_awsize[3+:3] = s01_dcv_axi4_awsize;
assign s_cbr_axi4_awburst[2+:2] = s01_dcv_axi4_awburst;
assign s_cbr_axi4_awregion[4+:4] = s01_dcv_axi4_awregion;
assign s_cbr_axi4_awlock[1] = s01_dcv_axi4_awlock;
assign s_cbr_axi4_awcache[4+:4] = s01_dcv_axi4_awcache;
assign s_cbr_axi4_awprot[3+:3] = s01_dcv_axi4_awprot;
assign s_cbr_axi4_awqos[4+:4] = s01_dcv_axi4_awqos;
assign s_cbr_axi4_awvalid[1] = s01_dcv_axi4_awvalid;
assign s01_dcv_axi4_awready = s_cbr_axi4_awready[1];
assign s_cbr_axi4_wdata[512+:512] = s01_dcv_axi4_wdata;
assign s_cbr_axi4_wstrob[64+:64] = s01_dcv_axi4_wstrob;
assign s_cbr_axi4_wlast[1] = s01_dcv_axi4_wlast;
assign s_cbr_axi4_wvalid[1] = s01_dcv_axi4_wvalid;
assign s01_dcv_axi4_wready = s_cbr_axi4_wready[1];
assign s01_dcv_axi4_bid = s_cbr_axi4_bid[8+:8];
assign s01_dcv_axi4_bresp = s_cbr_axi4_bresp[2+:2];
assign s01_dcv_axi4_bvalid = s_cbr_axi4_bvalid[1];
assign s_cbr_axi4_bready[1] = s01_dcv_axi4_bready;

axi_interconnect_crossbar #
(
    .NUM_SLAVE                      (2                          ),
    .NUM_MASTER                     (2                          ),
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_DATA                     (512                        ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .NUM_OUTSTANDING                (4                          ),
    .ADDR_BASE                      (ADDR_BASE                  ),
    .ADDR_HIGH                      (ADDR_HIGH                  ),
    .HAS_LOCK                       (1                          ),
    .HAS_CACHE                      (1                          ),
    .HAS_PROT                       (1                          ),
    .HAS_QOS                        (1                          ),
    .HAS_REGION                     (1                          ),
    .U_DLY                          (U_DLY                      )
)
u_axi_interconnect_crossbar
(
    .clk_sys                        (clk_sys                    ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (s_cbr_axi4_arid            ),
    .s_axi4_araddr                  (s_cbr_axi4_araddr          ),
    .s_axi4_arlen                   (s_cbr_axi4_arlen           ),
    .s_axi4_arsize                  (s_cbr_axi4_arsize          ),
    .s_axi4_arburst                 (s_cbr_axi4_arburst         ),
    .s_axi4_arregion                (s_cbr_axi4_arregion        ),
    .s_axi4_arlock                  (s_cbr_axi4_arlock          ),
    .s_axi4_arcache                 (s_cbr_axi4_arcache         ),
    .s_axi4_arprot                  (s_cbr_axi4_arprot          ),
    .s_axi4_arqos                   (s_cbr_axi4_arqos           ),
    .s_axi4_arvalid                 (s_cbr_axi4_arvalid         ),
    .s_axi4_arready                 (s_cbr_axi4_arready         ),
    .s_axi4_rid                     (s_cbr_axi4_rid             ),
    .s_axi4_rdata                   (s_cbr_axi4_rdata           ),
    .s_axi4_rresp                   (s_cbr_axi4_rresp           ),
    .s_axi4_rlast                   (s_cbr_axi4_rlast           ),
    .s_axi4_rvalid                  (s_cbr_axi4_rvalid          ),
    .s_axi4_rready                  (s_cbr_axi4_rready          ),
    .s_axi4_awid                    (s_cbr_axi4_awid            ),
    .s_axi4_awaddr                  (s_cbr_axi4_awaddr          ),
    .s_axi4_awlen                   (s_cbr_axi4_awlen           ),
    .s_axi4_awsize                  (s_cbr_axi4_awsize          ),
    .s_axi4_awburst                 (s_cbr_axi4_awburst         ),
    .s_axi4_awregion                (s_cbr_axi4_awregion        ),
    .s_axi4_awlock                  (s_cbr_axi4_awlock          ),
    .s_axi4_awcache                 (s_cbr_axi4_awcache         ),
    .s_axi4_awprot                  (s_cbr_axi4_awprot          ),
    .s_axi4_awqos                   (s_cbr_axi4_awqos           ),
    .s_axi4_awvalid                 (s_cbr_axi4_awvalid         ),
    .s_axi4_awready                 (s_cbr_axi4_awready         ),
    .s_axi4_wdata                   (s_cbr_axi4_wdata           ),
    .s_axi4_wstrob                  (s_cbr_axi4_wstrob          ),
    .s_axi4_wlast                   (s_cbr_axi4_wlast           ),
    .s_axi4_wvalid                  (s_cbr_axi4_wvalid          ),
    .s_axi4_wready                  (s_cbr_axi4_wready          ),
    .s_axi4_bid                     (s_cbr_axi4_bid             ),
    .s_axi4_bresp                   (s_cbr_axi4_bresp           ),
    .s_axi4_bvalid                  (s_cbr_axi4_bvalid          ),
    .s_axi4_bready                  (s_cbr_axi4_bready          ),
    .s_axi4_wid                     (s_cbr_axi4_awid            ),
    .s_axi4_aruser                  ({2{1'b0}}                  ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  ({2{1'b0}}                  ),
    .s_axi4_wuser                   ({2{1'b0}}                  ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (m_cbr_axi4_arid            ),
    .m_axi4_araddr                  (m_cbr_axi4_araddr          ),
    .m_axi4_arlen                   (m_cbr_axi4_arlen           ),
    .m_axi4_arsize                  (m_cbr_axi4_arsize          ),
    .m_axi4_arburst                 (m_cbr_axi4_arburst         ),
    .m_axi4_arregion                (m_cbr_axi4_arregion        ),
    .m_axi4_arlock                  (m_cbr_axi4_arlock          ),
    .m_axi4_arcache                 (m_cbr_axi4_arcache         ),
    .m_axi4_arprot                  (m_cbr_axi4_arprot          ),
    .m_axi4_arqos                   (m_cbr_axi4_arqos           ),
    .m_axi4_arvalid                 (m_cbr_axi4_arvalid         ),
    .m_axi4_arready                 (m_cbr_axi4_arready         ),
    .m_axi4_rid                     (m_cbr_axi4_rid             ),
    .m_axi4_rdata                   (m_cbr_axi4_rdata           ),
    .m_axi4_rresp                   (m_cbr_axi4_rresp           ),
    .m_axi4_rlast                   (m_cbr_axi4_rlast           ),
    .m_axi4_rvalid                  (m_cbr_axi4_rvalid          ),
    .m_axi4_rready                  (m_cbr_axi4_rready          ),
    .m_axi4_awid                    (m_cbr_axi4_awid            ),
    .m_axi4_awaddr                  (m_cbr_axi4_awaddr          ),
    .m_axi4_awlen                   (m_cbr_axi4_awlen           ),
    .m_axi4_awsize                  (m_cbr_axi4_awsize          ),
    .m_axi4_awburst                 (m_cbr_axi4_awburst         ),
    .m_axi4_awregion                (m_cbr_axi4_awregion        ),
    .m_axi4_awlock                  (m_cbr_axi4_awlock          ),
    .m_axi4_awcache                 (m_cbr_axi4_awcache         ),
    .m_axi4_awprot                  (m_cbr_axi4_awprot          ),
    .m_axi4_awqos                   (m_cbr_axi4_awqos           ),
    .m_axi4_awvalid                 (m_cbr_axi4_awvalid         ),
    .m_axi4_awready                 (m_cbr_axi4_awready         ),
    .m_axi4_wdata                   (m_cbr_axi4_wdata           ),
    .m_axi4_wstrob                  (m_cbr_axi4_wstrob          ),
    .m_axi4_wlast                   (m_cbr_axi4_wlast           ),
    .m_axi4_wvalid                  (m_cbr_axi4_wvalid          ),
    .m_axi4_wready                  (m_cbr_axi4_wready          ),
    .m_axi4_bid                     (m_cbr_axi4_bid             ),
    .m_axi4_bresp                   (m_cbr_axi4_bresp           ),
    .m_axi4_bvalid                  (m_cbr_axi4_bvalid          ),
    .m_axi4_bready                  (m_cbr_axi4_bready          ),
    .m_axi4_wid                     (                           ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   ({2{1'b0}}                  ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   ({2{1'b0}}                  )
);

assign m00_cbr_axi4_arid = m_cbr_axi4_arid[0+:8];
assign m00_cbr_axi4_araddr = m_cbr_axi4_araddr[0+:40];
assign m00_cbr_axi4_arlen = m_cbr_axi4_arlen[0+:8];
assign m00_cbr_axi4_arsize = m_cbr_axi4_arsize[0+:3];
assign m00_cbr_axi4_arburst = m_cbr_axi4_arburst[0+:2];
assign m00_cbr_axi4_arregion = m_cbr_axi4_arregion[0+:4];
assign m00_cbr_axi4_arlock = m_cbr_axi4_arlock[0];
assign m00_cbr_axi4_arcache = m_cbr_axi4_arcache[0+:4];
assign m00_cbr_axi4_arprot = m_cbr_axi4_arprot[0+:3];
assign m00_cbr_axi4_arqos = m_cbr_axi4_arqos[0+:4];
assign m00_cbr_axi4_arvalid = m_cbr_axi4_arvalid[0];
assign m_cbr_axi4_arready[0] = m00_cbr_axi4_arready;
assign m_cbr_axi4_rid[0+:8] = m00_cbr_axi4_rid;
assign m_cbr_axi4_rdata[0+:512] = m00_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[0+:2] = m00_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[0] = m00_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[0] = m00_cbr_axi4_rvalid;
assign m00_cbr_axi4_rready = m_cbr_axi4_rready[0];
assign m00_cbr_axi4_awid = m_cbr_axi4_awid[0+:8];
assign m00_cbr_axi4_awaddr = m_cbr_axi4_awaddr[0+:40];
assign m00_cbr_axi4_awlen = m_cbr_axi4_awlen[0+:8];
assign m00_cbr_axi4_awsize = m_cbr_axi4_awsize[0+:3];
assign m00_cbr_axi4_awburst = m_cbr_axi4_awburst[0+:2];
assign m00_cbr_axi4_awregion = m_cbr_axi4_awregion[0+:4];
assign m00_cbr_axi4_awlock = m_cbr_axi4_awlock[0];
assign m00_cbr_axi4_awcache = m_cbr_axi4_awcache[0+:4];
assign m00_cbr_axi4_awprot = m_cbr_axi4_awprot[0+:3];
assign m00_cbr_axi4_awqos = m_cbr_axi4_awqos[0+:4];
assign m00_cbr_axi4_awvalid = m_cbr_axi4_awvalid[0];
assign m_cbr_axi4_awready[0] = m00_cbr_axi4_awready;
assign m00_cbr_axi4_wdata = m_cbr_axi4_wdata[0+:512];
assign m00_cbr_axi4_wstrob = m_cbr_axi4_wstrob[0+:64];
assign m00_cbr_axi4_wlast = m_cbr_axi4_wlast[0];
assign m00_cbr_axi4_wvalid = m_cbr_axi4_wvalid[0];
assign m_cbr_axi4_wready[0] = m00_cbr_axi4_wready;
assign m_cbr_axi4_bid[0+:8] = m00_cbr_axi4_bid;
assign m_cbr_axi4_bresp[0+:2] = m00_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[0] = m00_cbr_axi4_bvalid;
assign m00_cbr_axi4_bready = m_cbr_axi4_bready[0];

assign m00_dcv_axi4_arid = m00_cbr_axi4_arid;
assign m00_dcv_axi4_araddr = m00_cbr_axi4_araddr;
assign m00_dcv_axi4_arlen = m00_cbr_axi4_arlen;
assign m00_dcv_axi4_arsize = m00_cbr_axi4_arsize;
assign m00_dcv_axi4_arburst = m00_cbr_axi4_arburst;
assign m00_dcv_axi4_arregion = m00_cbr_axi4_arregion;
assign m00_dcv_axi4_arlock = m00_cbr_axi4_arlock;
assign m00_dcv_axi4_arcache = m00_cbr_axi4_arcache;
assign m00_dcv_axi4_arprot = m00_cbr_axi4_arprot;
assign m00_dcv_axi4_arqos = m00_cbr_axi4_arqos;
assign m00_dcv_axi4_arvalid = m00_cbr_axi4_arvalid;
assign m00_cbr_axi4_arready = m00_dcv_axi4_arready;
assign m00_cbr_axi4_rid = m00_dcv_axi4_rid;
assign m00_cbr_axi4_rdata = m00_dcv_axi4_rdata;
assign m00_cbr_axi4_rresp = m00_dcv_axi4_rresp;
assign m00_cbr_axi4_rlast = m00_dcv_axi4_rlast;
assign m00_cbr_axi4_rvalid = m00_dcv_axi4_rvalid;
assign m00_dcv_axi4_rready = m00_cbr_axi4_rready;
assign m00_dcv_axi4_awid = m00_cbr_axi4_awid;
assign m00_dcv_axi4_awaddr = m00_cbr_axi4_awaddr;
assign m00_dcv_axi4_awlen = m00_cbr_axi4_awlen;
assign m00_dcv_axi4_awsize = m00_cbr_axi4_awsize;
assign m00_dcv_axi4_awburst = m00_cbr_axi4_awburst;
assign m00_dcv_axi4_awregion = m00_cbr_axi4_awregion;
assign m00_dcv_axi4_awlock = m00_cbr_axi4_awlock;
assign m00_dcv_axi4_awcache = m00_cbr_axi4_awcache;
assign m00_dcv_axi4_awprot = m00_cbr_axi4_awprot;
assign m00_dcv_axi4_awqos = m00_cbr_axi4_awqos;
assign m00_dcv_axi4_awvalid = m00_cbr_axi4_awvalid;
assign m00_cbr_axi4_awready = m00_dcv_axi4_awready;
assign m00_dcv_axi4_wdata = m00_cbr_axi4_wdata;
assign m00_dcv_axi4_wstrob = m00_cbr_axi4_wstrob;
assign m00_dcv_axi4_wlast = m00_cbr_axi4_wlast;
assign m00_dcv_axi4_wvalid = m00_cbr_axi4_wvalid;
assign m00_cbr_axi4_wready = m00_dcv_axi4_wready;
assign m00_cbr_axi4_bid = m00_dcv_axi4_bid;
assign m00_cbr_axi4_bresp = m00_dcv_axi4_bresp;
assign m00_cbr_axi4_bvalid = m00_dcv_axi4_bvalid;
assign m00_dcv_axi4_bready = m00_cbr_axi4_bready;

assign m00_cdc_axi4_arid = m00_dcv_axi4_arid;
assign m00_cdc_axi4_araddr = m00_dcv_axi4_araddr;
assign m00_cdc_axi4_arlen = m00_dcv_axi4_arlen;
assign m00_cdc_axi4_arsize = m00_dcv_axi4_arsize;
assign m00_cdc_axi4_arburst = m00_dcv_axi4_arburst;
assign m00_cdc_axi4_arregion = m00_dcv_axi4_arregion;
assign m00_cdc_axi4_arlock = m00_dcv_axi4_arlock;
assign m00_cdc_axi4_arcache = m00_dcv_axi4_arcache;
assign m00_cdc_axi4_arprot = m00_dcv_axi4_arprot;
assign m00_cdc_axi4_arqos = m00_dcv_axi4_arqos;
assign m00_cdc_axi4_arvalid = m00_dcv_axi4_arvalid;
assign m00_dcv_axi4_arready = m00_cdc_axi4_arready;
assign m00_dcv_axi4_rid = m00_cdc_axi4_rid;
assign m00_dcv_axi4_rdata = m00_cdc_axi4_rdata;
assign m00_dcv_axi4_rresp = m00_cdc_axi4_rresp;
assign m00_dcv_axi4_rlast = m00_cdc_axi4_rlast;
assign m00_dcv_axi4_rvalid = m00_cdc_axi4_rvalid;
assign m00_cdc_axi4_rready = m00_dcv_axi4_rready;
assign m00_cdc_axi4_awid = m00_dcv_axi4_awid;
assign m00_cdc_axi4_awaddr = m00_dcv_axi4_awaddr;
assign m00_cdc_axi4_awlen = m00_dcv_axi4_awlen;
assign m00_cdc_axi4_awsize = m00_dcv_axi4_awsize;
assign m00_cdc_axi4_awburst = m00_dcv_axi4_awburst;
assign m00_cdc_axi4_awregion = m00_dcv_axi4_awregion;
assign m00_cdc_axi4_awlock = m00_dcv_axi4_awlock;
assign m00_cdc_axi4_awcache = m00_dcv_axi4_awcache;
assign m00_cdc_axi4_awprot = m00_dcv_axi4_awprot;
assign m00_cdc_axi4_awqos = m00_dcv_axi4_awqos;
assign m00_cdc_axi4_awvalid = m00_dcv_axi4_awvalid;
assign m00_dcv_axi4_awready = m00_cdc_axi4_awready;
assign m00_cdc_axi4_wdata = m00_dcv_axi4_wdata;
assign m00_cdc_axi4_wstrob = m00_dcv_axi4_wstrob;
assign m00_cdc_axi4_wlast = m00_dcv_axi4_wlast;
assign m00_cdc_axi4_wvalid = m00_dcv_axi4_wvalid;
assign m00_dcv_axi4_wready = m00_cdc_axi4_wready;
assign m00_dcv_axi4_bid = m00_cdc_axi4_bid;
assign m00_dcv_axi4_bresp = m00_cdc_axi4_bresp;
assign m00_dcv_axi4_bvalid = m00_cdc_axi4_bvalid;
assign m00_cdc_axi4_bready = m00_dcv_axi4_bready;

axi_interconnect_axi4_adapter #
(
    .WIDTH_S_ID                     (8                          ),
    .WIDTH_M_ID                     (6                          ),
    .WIDTH_S_ADDR                   (40                         ),
    .WIDTH_M_ADDR                   (36                         ),
    .WIDTH_DATA                     (512                        ),
    .U_DLY                          (U_DLY                      )
)
u_m00_axi4_addr_id_adapter
(
    .s_axi4_arid                    (m00_cdc_axi4_arid          ),
    .s_axi4_araddr                  (m00_cdc_axi4_araddr        ),
    .s_axi4_arlen                   (m00_cdc_axi4_arlen         ),
    .s_axi4_arsize                  (m00_cdc_axi4_arsize        ),
    .s_axi4_arburst                 (m00_cdc_axi4_arburst       ),
    .s_axi4_arregion                (m00_cdc_axi4_arregion      ),
    .s_axi4_arlock                  (m00_cdc_axi4_arlock        ),
    .s_axi4_arcache                 (m00_cdc_axi4_arcache       ),
    .s_axi4_arprot                  (m00_cdc_axi4_arprot        ),
    .s_axi4_arqos                   (m00_cdc_axi4_arqos         ),
    .s_axi4_arvalid                 (m00_cdc_axi4_arvalid       ),
    .s_axi4_arready                 (m00_cdc_axi4_arready       ),
    .s_axi4_rid                     (m00_cdc_axi4_rid           ),
    .s_axi4_rdata                   (m00_cdc_axi4_rdata         ),
    .s_axi4_rresp                   (m00_cdc_axi4_rresp         ),
    .s_axi4_rlast                   (m00_cdc_axi4_rlast         ),
    .s_axi4_rvalid                  (m00_cdc_axi4_rvalid        ),
    .s_axi4_rready                  (m00_cdc_axi4_rready        ),
    .s_axi4_awid                    (m00_cdc_axi4_awid          ),
    .s_axi4_awaddr                  (m00_cdc_axi4_awaddr        ),
    .s_axi4_awlen                   (m00_cdc_axi4_awlen         ),
    .s_axi4_awsize                  (m00_cdc_axi4_awsize        ),
    .s_axi4_awburst                 (m00_cdc_axi4_awburst       ),
    .s_axi4_awregion                (m00_cdc_axi4_awregion      ),
    .s_axi4_awlock                  (m00_cdc_axi4_awlock        ),
    .s_axi4_awcache                 (m00_cdc_axi4_awcache       ),
    .s_axi4_awprot                  (m00_cdc_axi4_awprot        ),
    .s_axi4_awqos                   (m00_cdc_axi4_awqos         ),
    .s_axi4_awvalid                 (m00_cdc_axi4_awvalid       ),
    .s_axi4_awready                 (m00_cdc_axi4_awready       ),
    .s_axi4_wdata                   (m00_cdc_axi4_wdata         ),
    .s_axi4_wstrob                  (m00_cdc_axi4_wstrob        ),
    .s_axi4_wlast                   (m00_cdc_axi4_wlast         ),
    .s_axi4_wvalid                  (m00_cdc_axi4_wvalid        ),
    .s_axi4_wready                  (m00_cdc_axi4_wready        ),
    .s_axi4_bid                     (m00_cdc_axi4_bid           ),
    .s_axi4_bresp                   (m00_cdc_axi4_bresp         ),
    .s_axi4_bvalid                  (m00_cdc_axi4_bvalid        ),
    .s_axi4_bready                  (m00_cdc_axi4_bready        ),
    .m_axi4_arid                    (m00_axi4_arid              ),
    .m_axi4_araddr                  (m00_axi4_araddr            ),
    .m_axi4_arlen                   (m00_axi4_arlen             ),
    .m_axi4_arsize                  (m00_axi4_arsize            ),
    .m_axi4_arburst                 (m00_axi4_arburst           ),
    .m_axi4_arregion                (m00_axi4_arregion          ),
    .m_axi4_arlock                  (m00_axi4_arlock            ),
    .m_axi4_arcache                 (m00_axi4_arcache           ),
    .m_axi4_arprot                  (m00_axi4_arprot            ),
    .m_axi4_arqos                   (m00_axi4_arqos             ),
    .m_axi4_arvalid                 (m00_axi4_arvalid           ),
    .m_axi4_arready                 (m00_axi4_arready           ),
    .m_axi4_rid                     (m00_axi4_rid               ),
    .m_axi4_rdata                   (m00_axi4_rdata             ),
    .m_axi4_rresp                   (m00_axi4_rresp             ),
    .m_axi4_rlast                   (m00_axi4_rlast             ),
    .m_axi4_rvalid                  (m00_axi4_rvalid            ),
    .m_axi4_rready                  (m00_axi4_rready            ),
    .m_axi4_awid                    (m00_axi4_awid              ),
    .m_axi4_awaddr                  (m00_axi4_awaddr            ),
    .m_axi4_awlen                   (m00_axi4_awlen             ),
    .m_axi4_awsize                  (m00_axi4_awsize            ),
    .m_axi4_awburst                 (m00_axi4_awburst           ),
    .m_axi4_awregion                (m00_axi4_awregion          ),
    .m_axi4_awlock                  (m00_axi4_awlock            ),
    .m_axi4_awcache                 (m00_axi4_awcache           ),
    .m_axi4_awprot                  (m00_axi4_awprot            ),
    .m_axi4_awqos                   (m00_axi4_awqos             ),
    .m_axi4_awvalid                 (m00_axi4_awvalid           ),
    .m_axi4_awready                 (m00_axi4_awready           ),
    .m_axi4_wdata                   (m00_axi4_wdata             ),
    .m_axi4_wstrob                  (m00_axi4_wstrob            ),
    .m_axi4_wlast                   (m00_axi4_wlast             ),
    .m_axi4_wvalid                  (m00_axi4_wvalid            ),
    .m_axi4_wready                  (m00_axi4_wready            ),
    .m_axi4_bid                     (m00_axi4_bid               ),
    .m_axi4_bresp                   (m00_axi4_bresp             ),
    .m_axi4_bvalid                  (m00_axi4_bvalid            ),
    .m_axi4_bready                  (m00_axi4_bready            )
);

assign m01_cbr_axi4_arid = m_cbr_axi4_arid[8+:8];
assign m01_cbr_axi4_araddr = m_cbr_axi4_araddr[40+:40];
assign m01_cbr_axi4_arlen = m_cbr_axi4_arlen[8+:8];
assign m01_cbr_axi4_arsize = m_cbr_axi4_arsize[3+:3];
assign m01_cbr_axi4_arburst = m_cbr_axi4_arburst[2+:2];
assign m01_cbr_axi4_arregion = m_cbr_axi4_arregion[4+:4];
assign m01_cbr_axi4_arlock = m_cbr_axi4_arlock[1];
assign m01_cbr_axi4_arcache = m_cbr_axi4_arcache[4+:4];
assign m01_cbr_axi4_arprot = m_cbr_axi4_arprot[3+:3];
assign m01_cbr_axi4_arqos = m_cbr_axi4_arqos[4+:4];
assign m01_cbr_axi4_arvalid = m_cbr_axi4_arvalid[1];
assign m_cbr_axi4_arready[1] = m01_cbr_axi4_arready;
assign m_cbr_axi4_rid[8+:8] = m01_cbr_axi4_rid;
assign m_cbr_axi4_rdata[512+:512] = m01_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[2+:2] = m01_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[1] = m01_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[1] = m01_cbr_axi4_rvalid;
assign m01_cbr_axi4_rready = m_cbr_axi4_rready[1];
assign m01_cbr_axi4_awid = m_cbr_axi4_awid[8+:8];
assign m01_cbr_axi4_awaddr = m_cbr_axi4_awaddr[40+:40];
assign m01_cbr_axi4_awlen = m_cbr_axi4_awlen[8+:8];
assign m01_cbr_axi4_awsize = m_cbr_axi4_awsize[3+:3];
assign m01_cbr_axi4_awburst = m_cbr_axi4_awburst[2+:2];
assign m01_cbr_axi4_awregion = m_cbr_axi4_awregion[4+:4];
assign m01_cbr_axi4_awlock = m_cbr_axi4_awlock[1];
assign m01_cbr_axi4_awcache = m_cbr_axi4_awcache[4+:4];
assign m01_cbr_axi4_awprot = m_cbr_axi4_awprot[3+:3];
assign m01_cbr_axi4_awqos = m_cbr_axi4_awqos[4+:4];
assign m01_cbr_axi4_awvalid = m_cbr_axi4_awvalid[1];
assign m_cbr_axi4_awready[1] = m01_cbr_axi4_awready;
assign m01_cbr_axi4_wdata = m_cbr_axi4_wdata[512+:512];
assign m01_cbr_axi4_wstrob = m_cbr_axi4_wstrob[64+:64];
assign m01_cbr_axi4_wlast = m_cbr_axi4_wlast[1];
assign m01_cbr_axi4_wvalid = m_cbr_axi4_wvalid[1];
assign m_cbr_axi4_wready[1] = m01_cbr_axi4_wready;
assign m_cbr_axi4_bid[8+:8] = m01_cbr_axi4_bid;
assign m_cbr_axi4_bresp[2+:2] = m01_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[1] = m01_cbr_axi4_bvalid;
assign m01_cbr_axi4_bready = m_cbr_axi4_bready[1];

axi_interconnect_width_convert #
(
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_SDATA                    (512                        ),
    .WIDTH_MDATA                    (64                         ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .NUM_OUTSTANDING                (4                          ),
    .U_DLY                          (U_DLY                      )
)
u_m01_axi4_width_convert
(
    .clk_sys                        (clk_sys                    ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (m01_cbr_axi4_arid          ),
    .s_axi4_araddr                  (m01_cbr_axi4_araddr        ),
    .s_axi4_arlen                   (m01_cbr_axi4_arlen         ),
    .s_axi4_arsize                  (m01_cbr_axi4_arsize        ),
    .s_axi4_arburst                 (m01_cbr_axi4_arburst       ),
    .s_axi4_arregion                (m01_cbr_axi4_arregion      ),
    .s_axi4_arlock                  (m01_cbr_axi4_arlock        ),
    .s_axi4_arcache                 (m01_cbr_axi4_arcache       ),
    .s_axi4_arprot                  (m01_cbr_axi4_arprot        ),
    .s_axi4_arqos                   (m01_cbr_axi4_arqos         ),
    .s_axi4_arvalid                 (m01_cbr_axi4_arvalid       ),
    .s_axi4_arready                 (m01_cbr_axi4_arready       ),
    .s_axi4_rid                     (m01_cbr_axi4_rid           ),
    .s_axi4_rdata                   (m01_cbr_axi4_rdata         ),
    .s_axi4_rresp                   (m01_cbr_axi4_rresp         ),
    .s_axi4_rlast                   (m01_cbr_axi4_rlast         ),
    .s_axi4_rvalid                  (m01_cbr_axi4_rvalid        ),
    .s_axi4_rready                  (m01_cbr_axi4_rready        ),
    .s_axi4_awid                    (m01_cbr_axi4_awid          ),
    .s_axi4_awaddr                  (m01_cbr_axi4_awaddr        ),
    .s_axi4_awlen                   (m01_cbr_axi4_awlen         ),
    .s_axi4_awsize                  (m01_cbr_axi4_awsize        ),
    .s_axi4_awburst                 (m01_cbr_axi4_awburst       ),
    .s_axi4_awregion                (m01_cbr_axi4_awregion      ),
    .s_axi4_awlock                  (m01_cbr_axi4_awlock        ),
    .s_axi4_awcache                 (m01_cbr_axi4_awcache       ),
    .s_axi4_awprot                  (m01_cbr_axi4_awprot        ),
    .s_axi4_awqos                   (m01_cbr_axi4_awqos         ),
    .s_axi4_awvalid                 (m01_cbr_axi4_awvalid       ),
    .s_axi4_awready                 (m01_cbr_axi4_awready       ),
    .s_axi4_wdata                   (m01_cbr_axi4_wdata         ),
    .s_axi4_wstrob                  (m01_cbr_axi4_wstrob        ),
    .s_axi4_wlast                   (m01_cbr_axi4_wlast         ),
    .s_axi4_wvalid                  (m01_cbr_axi4_wvalid        ),
    .s_axi4_wready                  (m01_cbr_axi4_wready        ),
    .s_axi4_bid                     (m01_cbr_axi4_bid           ),
    .s_axi4_bresp                   (m01_cbr_axi4_bresp         ),
    .s_axi4_bvalid                  (m01_cbr_axi4_bvalid        ),
    .s_axi4_bready                  (m01_cbr_axi4_bready        ),
    .s_axi4_aruser                  (1'b0                       ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  (1'b0                       ),
    .s_axi4_wuser                   (1'b0                       ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (m01_dcv_axi4_arid          ),
    .m_axi4_araddr                  (m01_dcv_axi4_araddr        ),
    .m_axi4_arlen                   (m01_dcv_axi4_arlen         ),
    .m_axi4_arsize                  (m01_dcv_axi4_arsize        ),
    .m_axi4_arburst                 (m01_dcv_axi4_arburst       ),
    .m_axi4_arregion                (m01_dcv_axi4_arregion      ),
    .m_axi4_arlock                  (m01_dcv_axi4_arlock        ),
    .m_axi4_arcache                 (m01_dcv_axi4_arcache       ),
    .m_axi4_arprot                  (m01_dcv_axi4_arprot        ),
    .m_axi4_arqos                   (m01_dcv_axi4_arqos         ),
    .m_axi4_arvalid                 (m01_dcv_axi4_arvalid       ),
    .m_axi4_arready                 (m01_dcv_axi4_arready       ),
    .m_axi4_rid                     (m01_dcv_axi4_rid           ),
    .m_axi4_rdata                   (m01_dcv_axi4_rdata         ),
    .m_axi4_rresp                   (m01_dcv_axi4_rresp         ),
    .m_axi4_rlast                   (m01_dcv_axi4_rlast         ),
    .m_axi4_rvalid                  (m01_dcv_axi4_rvalid        ),
    .m_axi4_rready                  (m01_dcv_axi4_rready        ),
    .m_axi4_awid                    (m01_dcv_axi4_awid          ),
    .m_axi4_awaddr                  (m01_dcv_axi4_awaddr        ),
    .m_axi4_awlen                   (m01_dcv_axi4_awlen         ),
    .m_axi4_awsize                  (m01_dcv_axi4_awsize        ),
    .m_axi4_awburst                 (m01_dcv_axi4_awburst       ),
    .m_axi4_awregion                (m01_dcv_axi4_awregion      ),
    .m_axi4_awlock                  (m01_dcv_axi4_awlock        ),
    .m_axi4_awcache                 (m01_dcv_axi4_awcache       ),
    .m_axi4_awprot                  (m01_dcv_axi4_awprot        ),
    .m_axi4_awqos                   (m01_dcv_axi4_awqos         ),
    .m_axi4_awvalid                 (m01_dcv_axi4_awvalid       ),
    .m_axi4_awready                 (m01_dcv_axi4_awready       ),
    .m_axi4_wdata                   (m01_dcv_axi4_wdata         ),
    .m_axi4_wstrob                  (m01_dcv_axi4_wstrob        ),
    .m_axi4_wlast                   (m01_dcv_axi4_wlast         ),
    .m_axi4_wvalid                  (m01_dcv_axi4_wvalid        ),
    .m_axi4_wready                  (m01_dcv_axi4_wready        ),
    .m_axi4_bid                     (m01_dcv_axi4_bid           ),
    .m_axi4_bresp                   (m01_dcv_axi4_bresp         ),
    .m_axi4_bvalid                  (m01_dcv_axi4_bvalid        ),
    .m_axi4_bready                  (m01_dcv_axi4_bready        ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   (1'b0                       ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   (1'b0                       )
);

axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (8                          ),
    .WIDTH_ADDR                     (40                         ),
    .WIDTH_DATA                     (64                         ),
    .WIDTH_AWUSER                   (0                          ),
    .WIDTH_ARUSER                   (0                          ),
    .WIDTH_WUSER                    (0                          ),
    .WIDTH_RUSER                    (0                          ),
    .WIDTH_BUSER                    (0                          ),
    .HAS_LOCK                       (1                          ),
    .HAS_CACHE                      (1                          ),
    .HAS_PROT                       (1                          ),
    .HAS_QOS                        (1                          ),
    .HAS_REGION                     (1                          ),
    .U_DLY                          (U_DLY                      )
)
u_m01_axi4_clock_convert
(
    .clk_s                          (clk_sys                    ),
    .clk_m                          (m01_axi4_clk               ),
    .rst_n                          (rst_n                      ),
    .s_axi4_arid                    (m01_dcv_axi4_arid          ),
    .s_axi4_araddr                  (m01_dcv_axi4_araddr        ),
    .s_axi4_arlen                   (m01_dcv_axi4_arlen         ),
    .s_axi4_arsize                  (m01_dcv_axi4_arsize        ),
    .s_axi4_arburst                 (m01_dcv_axi4_arburst       ),
    .s_axi4_arregion                (m01_dcv_axi4_arregion      ),
    .s_axi4_arlock                  (m01_dcv_axi4_arlock        ),
    .s_axi4_arcache                 (m01_dcv_axi4_arcache       ),
    .s_axi4_arprot                  (m01_dcv_axi4_arprot        ),
    .s_axi4_arqos                   (m01_dcv_axi4_arqos         ),
    .s_axi4_arvalid                 (m01_dcv_axi4_arvalid       ),
    .s_axi4_arready                 (m01_dcv_axi4_arready       ),
    .s_axi4_rid                     (m01_dcv_axi4_rid           ),
    .s_axi4_rdata                   (m01_dcv_axi4_rdata         ),
    .s_axi4_rresp                   (m01_dcv_axi4_rresp         ),
    .s_axi4_rlast                   (m01_dcv_axi4_rlast         ),
    .s_axi4_rvalid                  (m01_dcv_axi4_rvalid        ),
    .s_axi4_rready                  (m01_dcv_axi4_rready        ),
    .s_axi4_awid                    (m01_dcv_axi4_awid          ),
    .s_axi4_awaddr                  (m01_dcv_axi4_awaddr        ),
    .s_axi4_awlen                   (m01_dcv_axi4_awlen         ),
    .s_axi4_awsize                  (m01_dcv_axi4_awsize        ),
    .s_axi4_awburst                 (m01_dcv_axi4_awburst       ),
    .s_axi4_awregion                (m01_dcv_axi4_awregion      ),
    .s_axi4_awlock                  (m01_dcv_axi4_awlock        ),
    .s_axi4_awcache                 (m01_dcv_axi4_awcache       ),
    .s_axi4_awprot                  (m01_dcv_axi4_awprot        ),
    .s_axi4_awqos                   (m01_dcv_axi4_awqos         ),
    .s_axi4_awvalid                 (m01_dcv_axi4_awvalid       ),
    .s_axi4_awready                 (m01_dcv_axi4_awready       ),
    .s_axi4_wdata                   (m01_dcv_axi4_wdata         ),
    .s_axi4_wstrob                  (m01_dcv_axi4_wstrob        ),
    .s_axi4_wlast                   (m01_dcv_axi4_wlast         ),
    .s_axi4_wvalid                  (m01_dcv_axi4_wvalid        ),
    .s_axi4_wready                  (m01_dcv_axi4_wready        ),
    .s_axi4_bid                     (m01_dcv_axi4_bid           ),
    .s_axi4_bresp                   (m01_dcv_axi4_bresp         ),
    .s_axi4_bvalid                  (m01_dcv_axi4_bvalid        ),
    .s_axi4_bready                  (m01_dcv_axi4_bready        ),
    .s_axi4_wid                     (m01_dcv_axi4_awid          ),
    .s_axi4_aruser                  (1'b0                       ),
    .s_axi4_ruser                   (                           ),
    .s_axi4_awuser                  (1'b0                       ),
    .s_axi4_wuser                   (1'b0                       ),
    .s_axi4_buser                   (                           ),
    .m_axi4_arid                    (m01_cdc_axi4_arid          ),
    .m_axi4_araddr                  (m01_cdc_axi4_araddr        ),
    .m_axi4_arlen                   (m01_cdc_axi4_arlen         ),
    .m_axi4_arsize                  (m01_cdc_axi4_arsize        ),
    .m_axi4_arburst                 (m01_cdc_axi4_arburst       ),
    .m_axi4_arregion                (m01_cdc_axi4_arregion      ),
    .m_axi4_arlock                  (m01_cdc_axi4_arlock        ),
    .m_axi4_arcache                 (m01_cdc_axi4_arcache       ),
    .m_axi4_arprot                  (m01_cdc_axi4_arprot        ),
    .m_axi4_arqos                   (m01_cdc_axi4_arqos         ),
    .m_axi4_arvalid                 (m01_cdc_axi4_arvalid       ),
    .m_axi4_arready                 (m01_cdc_axi4_arready       ),
    .m_axi4_rid                     (m01_cdc_axi4_rid           ),
    .m_axi4_rdata                   (m01_cdc_axi4_rdata         ),
    .m_axi4_rresp                   (m01_cdc_axi4_rresp         ),
    .m_axi4_rlast                   (m01_cdc_axi4_rlast         ),
    .m_axi4_rvalid                  (m01_cdc_axi4_rvalid        ),
    .m_axi4_rready                  (m01_cdc_axi4_rready        ),
    .m_axi4_awid                    (m01_cdc_axi4_awid          ),
    .m_axi4_awaddr                  (m01_cdc_axi4_awaddr        ),
    .m_axi4_awlen                   (m01_cdc_axi4_awlen         ),
    .m_axi4_awsize                  (m01_cdc_axi4_awsize        ),
    .m_axi4_awburst                 (m01_cdc_axi4_awburst       ),
    .m_axi4_awregion                (m01_cdc_axi4_awregion      ),
    .m_axi4_awlock                  (m01_cdc_axi4_awlock        ),
    .m_axi4_awcache                 (m01_cdc_axi4_awcache       ),
    .m_axi4_awprot                  (m01_cdc_axi4_awprot        ),
    .m_axi4_awqos                   (m01_cdc_axi4_awqos         ),
    .m_axi4_awvalid                 (m01_cdc_axi4_awvalid       ),
    .m_axi4_awready                 (m01_cdc_axi4_awready       ),
    .m_axi4_wdata                   (m01_cdc_axi4_wdata         ),
    .m_axi4_wstrob                  (m01_cdc_axi4_wstrob        ),
    .m_axi4_wlast                   (m01_cdc_axi4_wlast         ),
    .m_axi4_wvalid                  (m01_cdc_axi4_wvalid        ),
    .m_axi4_wready                  (m01_cdc_axi4_wready        ),
    .m_axi4_bid                     (m01_cdc_axi4_bid           ),
    .m_axi4_bresp                   (m01_cdc_axi4_bresp         ),
    .m_axi4_bvalid                  (m01_cdc_axi4_bvalid        ),
    .m_axi4_bready                  (m01_cdc_axi4_bready        ),
    .m_axi4_wid                     (                           ),
    .m_axi4_aruser                  (                           ),
    .m_axi4_ruser                   (1'b0                       ),
    .m_axi4_awuser                  (                           ),
    .m_axi4_wuser                   (                           ),
    .m_axi4_buser                   (1'b0                       )
);

axi_interconnect_axi4_adapter #
(
    .WIDTH_S_ID                     (8                          ),
    .WIDTH_M_ID                     (4                          ),
    .WIDTH_S_ADDR                   (40                         ),
    .WIDTH_M_ADDR                   (32                         ),
    .WIDTH_DATA                     (64                         ),
    .U_DLY                          (U_DLY                      )
)
u_m01_axi4_addr_id_adapter
(
    .s_axi4_arid                    (m01_cdc_axi4_arid          ),
    .s_axi4_araddr                  (m01_cdc_axi4_araddr        ),
    .s_axi4_arlen                   (m01_cdc_axi4_arlen         ),
    .s_axi4_arsize                  (m01_cdc_axi4_arsize        ),
    .s_axi4_arburst                 (m01_cdc_axi4_arburst       ),
    .s_axi4_arregion                (m01_cdc_axi4_arregion      ),
    .s_axi4_arlock                  (m01_cdc_axi4_arlock        ),
    .s_axi4_arcache                 (m01_cdc_axi4_arcache       ),
    .s_axi4_arprot                  (m01_cdc_axi4_arprot        ),
    .s_axi4_arqos                   (m01_cdc_axi4_arqos         ),
    .s_axi4_arvalid                 (m01_cdc_axi4_arvalid       ),
    .s_axi4_arready                 (m01_cdc_axi4_arready       ),
    .s_axi4_rid                     (m01_cdc_axi4_rid           ),
    .s_axi4_rdata                   (m01_cdc_axi4_rdata         ),
    .s_axi4_rresp                   (m01_cdc_axi4_rresp         ),
    .s_axi4_rlast                   (m01_cdc_axi4_rlast         ),
    .s_axi4_rvalid                  (m01_cdc_axi4_rvalid        ),
    .s_axi4_rready                  (m01_cdc_axi4_rready        ),
    .s_axi4_awid                    (m01_cdc_axi4_awid          ),
    .s_axi4_awaddr                  (m01_cdc_axi4_awaddr        ),
    .s_axi4_awlen                   (m01_cdc_axi4_awlen         ),
    .s_axi4_awsize                  (m01_cdc_axi4_awsize        ),
    .s_axi4_awburst                 (m01_cdc_axi4_awburst       ),
    .s_axi4_awregion                (m01_cdc_axi4_awregion      ),
    .s_axi4_awlock                  (m01_cdc_axi4_awlock        ),
    .s_axi4_awcache                 (m01_cdc_axi4_awcache       ),
    .s_axi4_awprot                  (m01_cdc_axi4_awprot        ),
    .s_axi4_awqos                   (m01_cdc_axi4_awqos         ),
    .s_axi4_awvalid                 (m01_cdc_axi4_awvalid       ),
    .s_axi4_awready                 (m01_cdc_axi4_awready       ),
    .s_axi4_wdata                   (m01_cdc_axi4_wdata         ),
    .s_axi4_wstrob                  (m01_cdc_axi4_wstrob        ),
    .s_axi4_wlast                   (m01_cdc_axi4_wlast         ),
    .s_axi4_wvalid                  (m01_cdc_axi4_wvalid        ),
    .s_axi4_wready                  (m01_cdc_axi4_wready        ),
    .s_axi4_bid                     (m01_cdc_axi4_bid           ),
    .s_axi4_bresp                   (m01_cdc_axi4_bresp         ),
    .s_axi4_bvalid                  (m01_cdc_axi4_bvalid        ),
    .s_axi4_bready                  (m01_cdc_axi4_bready        ),
    .m_axi4_arid                    (m01_axi4_arid              ),
    .m_axi4_araddr                  (m01_axi4_araddr            ),
    .m_axi4_arlen                   (m01_axi4_arlen             ),
    .m_axi4_arsize                  (m01_axi4_arsize            ),
    .m_axi4_arburst                 (m01_axi4_arburst           ),
    .m_axi4_arregion                (m01_axi4_arregion          ),
    .m_axi4_arlock                  (m01_axi4_arlock            ),
    .m_axi4_arcache                 (m01_axi4_arcache           ),
    .m_axi4_arprot                  (m01_axi4_arprot            ),
    .m_axi4_arqos                   (m01_axi4_arqos             ),
    .m_axi4_arvalid                 (m01_axi4_arvalid           ),
    .m_axi4_arready                 (m01_axi4_arready           ),
    .m_axi4_rid                     (m01_axi4_rid               ),
    .m_axi4_rdata                   (m01_axi4_rdata             ),
    .m_axi4_rresp                   (m01_axi4_rresp             ),
    .m_axi4_rlast                   (m01_axi4_rlast             ),
    .m_axi4_rvalid                  (m01_axi4_rvalid            ),
    .m_axi4_rready                  (m01_axi4_rready            ),
    .m_axi4_awid                    (m01_axi4_awid              ),
    .m_axi4_awaddr                  (m01_axi4_awaddr            ),
    .m_axi4_awlen                   (m01_axi4_awlen             ),
    .m_axi4_awsize                  (m01_axi4_awsize            ),
    .m_axi4_awburst                 (m01_axi4_awburst           ),
    .m_axi4_awregion                (m01_axi4_awregion          ),
    .m_axi4_awlock                  (m01_axi4_awlock            ),
    .m_axi4_awcache                 (m01_axi4_awcache           ),
    .m_axi4_awprot                  (m01_axi4_awprot            ),
    .m_axi4_awqos                   (m01_axi4_awqos             ),
    .m_axi4_awvalid                 (m01_axi4_awvalid           ),
    .m_axi4_awready                 (m01_axi4_awready           ),
    .m_axi4_wdata                   (m01_axi4_wdata             ),
    .m_axi4_wstrob                  (m01_axi4_wstrob            ),
    .m_axi4_wlast                   (m01_axi4_wlast             ),
    .m_axi4_wvalid                  (m01_axi4_wvalid            ),
    .m_axi4_wready                  (m01_axi4_wready            ),
    .m_axi4_bid                     (m01_axi4_bid               ),
    .m_axi4_bresp                   (m01_axi4_bresp             ),
    .m_axi4_bvalid                  (m01_axi4_bvalid            ),
    .m_axi4_bready                  (m01_axi4_bready            )
);

endmodule

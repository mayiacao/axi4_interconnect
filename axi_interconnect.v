// +FHDR============================================================================/ 
// Author       : hjie
// Creat Time   : 2025/11/29 11:19:20
// File Name    : axi_interconnect.v
// Module Ver   : V1.0
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
// axi_interconnect
//    |---
//
`timescale 1ns/1ps

module axi_interconnect # 
(
parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    input                               clk_sys                     , 
    input                               rst_n                       , 
// ---------------------------------------------------------------------------------
// Slave Interface 
// ---------------------------------------------------------------------------------
   input                        [03:0] s00_axi4_arid           , 
   input                        [31:0] s00_axi4_araddr         , 
   input                        [ 7:0] s00_axi4_arlen          , 
   input                        [ 2:0] s00_axi4_arsize         , 
   input                        [ 1:0] s00_axi4_arburst        , 
   input                        [ 3:0] s00_axi4_arregion       , 
   input                        [ 3:0] s00_axi4_arcache        , 
   input                               s00_axi4_arvalid         , 
   output                              s00_axi4_arready         , 

   output                       [03:0] s00_axi4_rid            , 
   output                       [511:0] s00_axi4_rdata          , 
   output                        [1:0] s00_axi4_rresp          , 
   output                              s00_axi4_rlast          , 
   output                              s00_axi4_rvalid          , 
   input                               s00_axi4_rready          , 

   input                        [03:0] s00_axi4_awid           , 
   input                        [31:0] s00_axi4_awaddr         , 
   input                        [ 7:0] s00_axi4_awlen          , 
   input                        [ 2:0] s00_axi4_awsize         , 
   input                        [ 1:0] s00_axi4_awburst        , 
   input                        [ 3:0] s00_axi4_awregion       , 
   input                        [ 3:0] s00_axi4_awcache        , 
   input                               s00_axi4_awvalid         , 
   output                              s00_axi4_awready         , 

   input                        [511:0] s00_axi4_wdata          , 
   input                        [63:0] s00_axi4_wstrob         , 
   input                               s00_axi4_wlast          , 
   input                               s00_axi4_wvalid          , 
   output                              s00_axi4_wready          , 

   output                       [03:0] s00_axi4_bid            , 
   output                        [1:0] s00_axi4_bresp          , 
   output                              s00_axi4_bvalid          , 
   input                               s00_axi4_bready          , 


// ---------------------------------------------------------------------------------
// Master Interface 
// ---------------------------------------------------------------------------------
    input                               m00_axi4_clk               , 
   output                       [03:0] m00_axi4_arid           , 
   output                       [31:0] m00_axi4_araddr         , 
   output                       [ 7:0] m00_axi4_arlen          , 
   output                       [ 2:0] m00_axi4_arsize         , 
   output                       [ 1:0] m00_axi4_arburst        , 
   output                       [ 3:0] m00_axi4_arregion       , 
   output                       [ 3:0] m00_axi4_arcache        , 
   output                              m00_axi4_arvalid         , 
   input                               m00_axi4_arready         , 

   input                        [03:0] m00_axi4_rid            , 
   input                        [255:0] m00_axi4_rdata          , 
   input                         [1:0] m00_axi4_rresp          , 
   input                               m00_axi4_rlast          , 
   input                               m00_axi4_rvalid          , 
   output                              m00_axi4_rready          , 

   output                       [03:0] m00_axi4_awid           , 
   output                       [31:0] m00_axi4_awaddr         , 
   output                       [ 7:0] m00_axi4_awlen          , 
   output                       [ 2:0] m00_axi4_awsize         , 
   output                       [ 1:0] m00_axi4_awburst        , 
   output                       [ 3:0] m00_axi4_awregion       , 
   output                       [ 3:0] m00_axi4_awcache        , 
   output                              m00_axi4_awvalid         , 
   input                               m00_axi4_awready         , 

   output                       [255:0] m00_axi4_wdata          , 
   output                       [31:0] m00_axi4_wstrob         , 
   output                              m00_axi4_wlast          , 
   output                              m00_axi4_wvalid          , 
   input                               m00_axi4_wready          , 

   input                        [03:0] m00_axi4_bid            , 
   input                         [1:0] m00_axi4_bresp          , 
   input                               m00_axi4_bvalid          , 
   output                              m00_axi4_bready            
);

localparam [1*32-1:0] ADDR_BASE = { 
32'h80000000};

localparam [1*32-1:0] ADDR_HIGH = { 
32'h800fffff};

wire                              [03:0] s00_cdc_axi4_arid                 ; 
wire                              [31:0] s00_cdc_axi4_araddr               ; 
wire                              [ 7:0] s00_cdc_axi4_arlen                ; 
wire                              [ 2:0] s00_cdc_axi4_arsize               ; 
wire                              [ 1:0] s00_cdc_axi4_arburst              ; 
wire                              [ 3:0] s00_cdc_axi4_arregion             ; 
wire                              [ 3:0] s00_cdc_axi4_arcache              ; 
wire                                    s00_cdc_axi4_arvalid              ; 
wire                                    s00_cdc_axi4_arready              ; 

wire                              [03:0] s00_cdc_axi4_rid                  ; 
wire                              [511:0] s00_cdc_axi4_rdata                ;  
wire                              [ 1:0] s00_cdc_axi4_rresp                ;  
wire                                     s00_cdc_axi4_rlast                ; 
wire                                     s00_cdc_axi4_rvalid               ; 
wire                                     s00_cdc_axi4_rready               ; 

wire                              [03:0] s00_cdc_axi4_awid                 ; 
wire                              [31:0] s00_cdc_axi4_awaddr               ; 
wire                              [ 7:0] s00_cdc_axi4_awlen                ; 
wire                              [ 2:0] s00_cdc_axi4_awsize               ; 
wire                              [ 1:0] s00_cdc_axi4_awburst              ; 
wire                              [ 3:0] s00_cdc_axi4_awregion             ; 
wire                              [ 3:0] s00_cdc_axi4_awcache              ; 
wire                                    s00_cdc_axi4_awvalid              ; 
wire                                    s00_cdc_axi4_awready              ; 

wire                             [511:0] s00_cdc_axi4_wdata                ; 
wire                             [63:0] s00_cdc_axi4_wstrob               ; 
wire                                    s00_cdc_axi4_wlast                ; 
wire                                    s00_cdc_axi4_wvalid               ; 
wire                                    s00_cdc_axi4_wready               ; 

wire                             [03:0] s00_cdc_axi4_bid                  ;  
wire                             [ 1:0] s00_cdc_axi4_bresp                ; 
wire                                    s00_cdc_axi4_bvalid               ; 
wire                                    s00_cdc_axi4_bready               ; 


wire                              [03:0] s00_dcv_axi4_arid                 ; 
wire                              [31:0] s00_dcv_axi4_araddr               ; 
wire                              [ 7:0] s00_dcv_axi4_arlen                ; 
wire                              [ 2:0] s00_dcv_axi4_arsize               ; 
wire                              [ 1:0] s00_dcv_axi4_arburst              ; 
wire                              [ 3:0] s00_dcv_axi4_arregion             ; 
wire                              [ 3:0] s00_dcv_axi4_arcache              ; 
wire                                    s00_dcv_axi4_arvalid              ; 
wire                                    s00_dcv_axi4_arready              ; 

wire                              [03:0] s00_dcv_axi4_rid                  ; 
wire                              [511:0] s00_dcv_axi4_rdata                ;  
wire                              [ 1:0] s00_dcv_axi4_rresp                ;  
wire                                     s00_dcv_axi4_rlast                ; 
wire                                     s00_dcv_axi4_rvalid               ; 
wire                                     s00_dcv_axi4_rready               ; 

wire                              [03:0] s00_dcv_axi4_awid                 ; 
wire                              [31:0] s00_dcv_axi4_awaddr               ; 
wire                              [ 7:0] s00_dcv_axi4_awlen                ; 
wire                              [ 2:0] s00_dcv_axi4_awsize               ; 
wire                              [ 1:0] s00_dcv_axi4_awburst              ; 
wire                              [ 3:0] s00_dcv_axi4_awregion             ; 
wire                              [ 3:0] s00_dcv_axi4_awcache              ; 
wire                                    s00_dcv_axi4_awvalid              ; 
wire                                    s00_dcv_axi4_awready              ; 

wire                             [511:0] s00_dcv_axi4_wdata                ; 
wire                             [63:0] s00_dcv_axi4_wstrob               ; 
wire                                    s00_dcv_axi4_wlast                ; 
wire                                    s00_dcv_axi4_wvalid               ; 
wire                                    s00_dcv_axi4_wready               ; 

wire                             [03:0] s00_dcv_axi4_bid                  ;  
wire                             [ 1:0] s00_dcv_axi4_bresp                ; 
wire                                    s00_dcv_axi4_bvalid               ; 
wire                                    s00_dcv_axi4_bready               ; 


wire                        [01*04-1:0] s_cbr_axi4_arid             ; 
wire                        [01*32-1:0] s_cbr_axi4_araddr           ;
wire                         [01*8-1:0] s_cbr_axi4_arlen            ;
wire                         [01*3-1:0] s_cbr_axi4_arsize           ; 
wire                         [01*2-1:0] s_cbr_axi4_arburst          ; 
wire                         [01*4-1:0] s_cbr_axi4_arregion         ;
wire                         [01*4-1:0] s_cbr_axi4_arcache          ; 
wire                           [01-1:0] s_cbr_axi4_arvalid          ;  
wire                           [01-1:0] s_cbr_axi4_arready          ; 

wire                        [01*04-1:0] s_cbr_axi4_rid              ; 
wire                        [01*512-1:0] s_cbr_axi4_rdata            ;  
wire                         [01*2-1:0] s_cbr_axi4_rresp            ;  
wire                           [01-1:0] s_cbr_axi4_rlast            ;  
wire                           [01-1:0] s_cbr_axi4_rvalid           ; 
wire                           [01-1:0] s_cbr_axi4_rready           ;  

wire                        [01*04-1:0] s_cbr_axi4_awid             ;  
wire                        [01*32-1:0] s_cbr_axi4_awaddr           ; 
wire                         [01*8-1:0] s_cbr_axi4_awlen            ; 
wire                         [01*3-1:0] s_cbr_axi4_awsize           ;  
wire                         [01*2-1:0] s_cbr_axi4_awburst          ; 
wire                         [01*4-1:0] s_cbr_axi4_awregion         ; 
wire                         [01*4-1:0] s_cbr_axi4_awcache          ; 
wire                           [01-1:0] s_cbr_axi4_awvalid          ; 
wire                           [01-1:0] s_cbr_axi4_awready          ; 

wire                        [01*512-1:0] s_cbr_axi4_wdata            ;
wire                        [01*64-1:0] s_cbr_axi4_wstrob           ;
wire                           [01-1:0] s_cbr_axi4_wlast            ;
wire                           [01-1:0] s_cbr_axi4_wvalid           ; 
wire                           [01-1:0] s_cbr_axi4_wready           ; 

wire                        [01*04-1:0] s_cbr_axi4_bid              ;  
wire                         [01*2-1:0] s_cbr_axi4_bresp            ; 
wire                           [01-1:0] s_cbr_axi4_bvalid           ; 
wire                           [01-1:0] s_cbr_axi4_bready           ; 


wire                        [01*04-1:0] m_cbr_axi4_arid             ; 
wire                        [01*32-1:0] m_cbr_axi4_araddr           ;
wire                         [01*8-1:0] m_cbr_axi4_arlen            ;
wire                         [01*3-1:0] m_cbr_axi4_arsize           ; 
wire                         [01*2-1:0] m_cbr_axi4_arburst          ; 
wire                         [01*4-1:0] m_cbr_axi4_arregion         ;
wire                         [01*4-1:0] m_cbr_axi4_arcache          ; 
wire                           [01-1:0] m_cbr_axi4_arvalid          ;  
wire                           [01-1:0] m_cbr_axi4_arready          ; 

wire                        [01*04-1:0] m_cbr_axi4_rid              ; 
wire                        [01*512-1:0] m_cbr_axi4_rdata            ;  
wire                         [01*2-1:0] m_cbr_axi4_rresp            ;  
wire                           [01-1:0] m_cbr_axi4_rlast            ;  
wire                           [01-1:0] m_cbr_axi4_rvalid           ; 
wire                           [01-1:0] m_cbr_axi4_rready           ;  

wire                        [01*04-1:0] m_cbr_axi4_awid             ;  
wire                        [01*32-1:0] m_cbr_axi4_awaddr           ; 
wire                         [01*8-1:0] m_cbr_axi4_awlen            ; 
wire                         [01*3-1:0] m_cbr_axi4_awsize           ;  
wire                         [01*2-1:0] m_cbr_axi4_awburst          ; 
wire                         [01*4-1:0] m_cbr_axi4_awregion         ; 
wire                         [01*4-1:0] m_cbr_axi4_awcache          ; 
wire                           [01-1:0] m_cbr_axi4_awvalid          ; 
wire                           [01-1:0] m_cbr_axi4_awready          ; 

wire                        [01*512-1:0] m_cbr_axi4_wdata            ;
wire                        [01*64-1:0] m_cbr_axi4_wstrob           ;
wire                           [01-1:0] m_cbr_axi4_wlast            ;
wire                           [01-1:0] m_cbr_axi4_wvalid           ; 
wire                           [01-1:0] m_cbr_axi4_wready           ; 

wire                        [01*04-1:0] m_cbr_axi4_bid              ;  
wire                         [01*2-1:0] m_cbr_axi4_bresp            ; 
wire                           [01-1:0] m_cbr_axi4_bvalid           ; 
wire                           [01-1:0] m_cbr_axi4_bready           ; 


wire                              [03:0] m00_cbr_axi4_arid                 ; 
wire                              [31:0] m00_cbr_axi4_araddr               ; 
wire                              [ 7:0] m00_cbr_axi4_arlen                ; 
wire                              [ 2:0] m00_cbr_axi4_arsize               ; 
wire                              [ 1:0] m00_cbr_axi4_arburst              ; 
wire                              [ 3:0] m00_cbr_axi4_arregion             ; 
wire                              [ 3:0] m00_cbr_axi4_arcache              ; 
wire                                    m00_cbr_axi4_arvalid              ; 
wire                                    m00_cbr_axi4_arready              ; 

wire                              [03:0] m00_cbr_axi4_rid                  ; 
wire                              [511:0] m00_cbr_axi4_rdata                ;  
wire                              [ 1:0] m00_cbr_axi4_rresp                ;  
wire                                     m00_cbr_axi4_rlast                ; 
wire                                     m00_cbr_axi4_rvalid               ; 
wire                                     m00_cbr_axi4_rready               ; 

wire                              [03:0] m00_cbr_axi4_awid                 ; 
wire                              [31:0] m00_cbr_axi4_awaddr               ; 
wire                              [ 7:0] m00_cbr_axi4_awlen                ; 
wire                              [ 2:0] m00_cbr_axi4_awsize               ; 
wire                              [ 1:0] m00_cbr_axi4_awburst              ; 
wire                              [ 3:0] m00_cbr_axi4_awregion             ; 
wire                              [ 3:0] m00_cbr_axi4_awcache              ; 
wire                                    m00_cbr_axi4_awvalid              ; 
wire                                    m00_cbr_axi4_awready              ; 

wire                             [511:0] m00_cbr_axi4_wdata                ; 
wire                             [63:0] m00_cbr_axi4_wstrob               ; 
wire                                    m00_cbr_axi4_wlast                ; 
wire                                    m00_cbr_axi4_wvalid               ; 
wire                                    m00_cbr_axi4_wready               ; 

wire                             [03:0] m00_cbr_axi4_bid                  ;  
wire                             [ 1:0] m00_cbr_axi4_bresp                ; 
wire                                    m00_cbr_axi4_bvalid               ; 
wire                                    m00_cbr_axi4_bready               ; 


wire                              [03:0] m00_dcv_axi4_arid                 ; 
wire                              [31:0] m00_dcv_axi4_araddr               ; 
wire                              [ 7:0] m00_dcv_axi4_arlen                ; 
wire                              [ 2:0] m00_dcv_axi4_arsize               ; 
wire                              [ 1:0] m00_dcv_axi4_arburst              ; 
wire                              [ 3:0] m00_dcv_axi4_arregion             ; 
wire                              [ 3:0] m00_dcv_axi4_arcache              ; 
wire                                    m00_dcv_axi4_arvalid              ; 
wire                                    m00_dcv_axi4_arready              ; 

wire                              [03:0] m00_dcv_axi4_rid                  ; 
wire                              [255:0] m00_dcv_axi4_rdata                ;  
wire                              [ 1:0] m00_dcv_axi4_rresp                ;  
wire                                     m00_dcv_axi4_rlast                ; 
wire                                     m00_dcv_axi4_rvalid               ; 
wire                                     m00_dcv_axi4_rready               ; 

wire                              [03:0] m00_dcv_axi4_awid                 ; 
wire                              [31:0] m00_dcv_axi4_awaddr               ; 
wire                              [ 7:0] m00_dcv_axi4_awlen                ; 
wire                              [ 2:0] m00_dcv_axi4_awsize               ; 
wire                              [ 1:0] m00_dcv_axi4_awburst              ; 
wire                              [ 3:0] m00_dcv_axi4_awregion             ; 
wire                              [ 3:0] m00_dcv_axi4_awcache              ; 
wire                                    m00_dcv_axi4_awvalid              ; 
wire                                    m00_dcv_axi4_awready              ; 

wire                             [255:0] m00_dcv_axi4_wdata                ; 
wire                             [31:0] m00_dcv_axi4_wstrob               ; 
wire                                     m00_dcv_axi4_wlast                ; 
wire                                    m00_dcv_axi4_wvalid               ; 
wire                                    m00_dcv_axi4_wready               ; 

wire                             [03:0] m00_dcv_axi4_bid                  ;  
wire                             [ 1:0] m00_dcv_axi4_bresp                ; 
wire                                    m00_dcv_axi4_bvalid               ; 
wire                                    m00_dcv_axi4_bready               ; 


assign s00_cdc_axi4_arid = s00_axi4_arid;
assign s00_cdc_axi4_araddr = s00_axi4_araddr;
assign s00_cdc_axi4_arlen = s00_axi4_arlen;
assign s00_cdc_axi4_arsize = s00_axi4_arsize;
assign s00_cdc_axi4_arburst = s00_axi4_arburst;
assign s00_cdc_axi4_arregion = s00_axi4_arregion;
assign s00_cdc_axi4_arcache = s00_axi4_arcache;
assign s00_cdc_axi4_arvalid = s00_axi4_arvalid;
assign s00_axi4_arready = s00_cdc_axi4_arready;

assign s00_axi4_rid = s00_cdc_axi4_rid;
assign s00_axi4_rdata = s00_cdc_axi4_rdata;
assign s00_axi4_rresp = s00_cdc_axi4_rresp;
assign s00_axi4_rlast = s00_cdc_axi4_rlast;
assign s00_axi4_rvalid = s00_cdc_axi4_rvalid;
assign s00_cdc_axi4_rready = s00_axi4_rready;

assign s00_cdc_axi4_awid= s00_axi4_awid;
assign s00_cdc_axi4_awaddr = s00_axi4_awaddr;
assign s00_cdc_axi4_awlen = s00_axi4_awlen;
assign s00_cdc_axi4_awsize = s00_axi4_awsize;
assign s00_cdc_axi4_awburst = s00_axi4_awburst;
assign s00_cdc_axi4_awregion = s00_axi4_awregion;
assign s00_cdc_axi4_awcache = s00_axi4_awcache;
assign s00_cdc_axi4_awvalid = s00_axi4_awvalid;
assign s00_axi4_awready = s00_cdc_axi4_awready;

assign s00_cdc_axi4_wdata = s00_axi4_wdata;
assign s00_cdc_axi4_wstrob = s00_axi4_wstrob;
assign s00_cdc_axi4_wlast = s00_axi4_wlast;
assign s00_cdc_axi4_wvalid = s00_axi4_wvalid;
assign s00_axi4_wready = s00_cdc_axi4_wready;

assign s00_axi4_bid = s00_cdc_axi4_bid;
assign s00_axi4_bresp = s00_cdc_axi4_bresp;
assign s00_axi4_bvalid = s00_cdc_axi4_bvalid;
assign s00_cdc_axi4_bready = s00_axi4_bready;
assign s00_dcv_axi4_arid = s00_cdc_axi4_arid;
assign s00_dcv_axi4_araddr = s00_cdc_axi4_araddr;
assign s00_dcv_axi4_arlen = s00_cdc_axi4_arlen;
assign s00_dcv_axi4_arsize = s00_cdc_axi4_arsize;
assign s00_dcv_axi4_arburst = s00_cdc_axi4_arburst;
assign s00_dcv_axi4_arregion = s00_cdc_axi4_arregion;
assign s00_dcv_axi4_arcache = s00_cdc_axi4_arcache;
assign s00_dcv_axi4_arvalid = s00_cdc_axi4_arvalid;
assign s00_cdc_axi4_arready = s00_dcv_axi4_arready;

assign s00_cdc_axi4_rid = s00_dcv_axi4_rid;
assign s00_cdc_axi4_rdata = s00_dcv_axi4_rdata;
assign s00_cdc_axi4_rresp = s00_dcv_axi4_rresp;
assign s00_cdc_axi4_rlast = s00_dcv_axi4_rlast;
assign s00_cdc_axi4_rvalid = s00_dcv_axi4_rvalid;
assign s00_dcv_axi4_rready = s00_cdc_axi4_rready;

assign s00_dcv_axi4_awid= s00_cdc_axi4_awid;
assign s00_dcv_axi4_awaddr = s00_cdc_axi4_awaddr;
assign s00_dcv_axi4_awlen = s00_cdc_axi4_awlen;
assign s00_dcv_axi4_awsize = s00_cdc_axi4_awsize;
assign s00_dcv_axi4_awburst = s00_cdc_axi4_awburst;
assign s00_dcv_axi4_awregion = s00_cdc_axi4_awregion;
assign s00_dcv_axi4_awcache = s00_cdc_axi4_awcache;
assign s00_dcv_axi4_awvalid = s00_cdc_axi4_awvalid;
assign s00_cdc_axi4_awready = s00_dcv_axi4_awready;

assign s00_dcv_axi4_wdata = s00_cdc_axi4_wdata;
assign s00_dcv_axi4_wstrob = s00_cdc_axi4_wstrob;
assign s00_dcv_axi4_wlast = s00_cdc_axi4_wlast;
assign s00_dcv_axi4_wvalid = s00_cdc_axi4_wvalid;
assign s00_cdc_axi4_wready = s00_dcv_axi4_wready;

assign s00_cdc_axi4_bid = s00_dcv_axi4_bid;
assign s00_cdc_axi4_bresp = s00_dcv_axi4_bresp;
assign s00_cdc_axi4_bvalid = s00_dcv_axi4_bvalid;
assign s00_dcv_axi4_bready = s00_cdc_axi4_bready;
assign s_cbr_axi4_arid[ 0* 4+: 4] = s00_dcv_axi4_arid;
assign s_cbr_axi4_araddr[ 0*32+:32] = s00_dcv_axi4_araddr; 
assign s_cbr_axi4_arlen[ 0*8+:8] = s00_dcv_axi4_arlen; 
assign s_cbr_axi4_arsize[ 0*3+:3] = s00_dcv_axi4_arsize;
assign s_cbr_axi4_arburst[ 0*2+:2] = s00_dcv_axi4_arburst;
assign s_cbr_axi4_arregion[ 0*4+:4] = s00_dcv_axi4_arregion;
assign s_cbr_axi4_arcache[ 0*4+:4] = s00_dcv_axi4_arcache;
assign s_cbr_axi4_arvalid[ 0] = s00_dcv_axi4_arvalid;
assign s00_dcv_axi4_arready = s_cbr_axi4_arready[ 0];

assign s00_dcv_axi4_rid = s_cbr_axi4_rid[ 0* 4+: 4];
assign s00_dcv_axi4_rdata = s_cbr_axi4_rdata[ 0*512+:512];
assign s00_dcv_axi4_rresp = s_cbr_axi4_rresp[ 0*2+:2];
assign s00_dcv_axi4_rlast = s_cbr_axi4_rlast[ 0];
assign s00_dcv_axi4_rvalid = s_cbr_axi4_rvalid[ 0];
assign s_cbr_axi4_rready[ 0] = s00_dcv_axi4_rready;

assign s_cbr_axi4_awid[ 0* 4+: 4] = s00_dcv_axi4_awid;
assign s_cbr_axi4_awaddr[ 0*32+:32] = s00_dcv_axi4_awaddr; 
assign s_cbr_axi4_awlen[ 0*8+:8] = s00_dcv_axi4_awlen; 
assign s_cbr_axi4_awsize[ 0*3+:3] = s00_dcv_axi4_awsize;
assign s_cbr_axi4_awburst[ 0*2+:2] = s00_dcv_axi4_awburst;
assign  s_cbr_axi4_awregion[ 0*4+:4] = s00_dcv_axi4_awregion;
assign s_cbr_axi4_awcache[ 0*4+:4] = s00_dcv_axi4_awcache;
assign s_cbr_axi4_awvalid[ 0] = s00_dcv_axi4_awvalid;
assign s00_dcv_axi4_awready = s_cbr_axi4_awready[ 0];

assign s_cbr_axi4_wdata[ 0*512+:512] = s00_dcv_axi4_wdata;
assign s_cbr_axi4_wstrob[ 0*64+:64] = s00_dcv_axi4_wstrob;
assign s_cbr_axi4_wlast[ 0] = s00_dcv_axi4_wlast;
assign s_cbr_axi4_wvalid[ 0] = s00_dcv_axi4_wvalid;
assign s00_dcv_axi4_wready = s_cbr_axi4_wready[ 0];

assign s00_dcv_axi4_bid = s_cbr_axi4_bid[ 0* 4+: 4];
assign s00_dcv_axi4_bresp = s_cbr_axi4_bresp[ 0*2+:2];
assign s00_dcv_axi4_bvalid = s_cbr_axi4_bvalid[ 0];
assign s_cbr_axi4_bready[ 0] = s00_dcv_axi4_bready;
axi_interconnect_crossbar #
(
    .NUM_SLAVE                      (1                           ), 
    .NUM_MASTER                     (1                           ), 
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (512                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .ADDR_BASE                      (ADDR_BASE                  ),
    .ADDR_HIGH                      (ADDR_HIGH                  ),
    .NUM_OUTSTANDING                (4                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u_axi_interconnect_crossbar
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (s_cbr_axi4_arid          ), // (input )
    .s_axi4_araddr                  (s_cbr_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (s_cbr_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (s_cbr_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (s_cbr_axi4_arburst       ), // (input )
    .s_axi4_arregion                (s_cbr_axi4_arregion      ), // (input )
    .s_axi4_arcache                 (s_cbr_axi4_arcache       ), // (input )
    .s_axi4_arvalid                 (s_cbr_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (s_cbr_axi4_arready       ), // (output)

    .s_axi4_rid                     (s_cbr_axi4_rid           ), // (output)
    .s_axi4_rdata                   (s_cbr_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (s_cbr_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (s_cbr_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (s_cbr_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (s_cbr_axi4_rready        ), // (input )

    .s_axi4_awid                    (s_cbr_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (s_cbr_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (s_cbr_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (s_cbr_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (s_cbr_axi4_awburst       ), // (input )
    .s_axi4_awregion                (s_cbr_axi4_awregion      ), // (input )
    .s_axi4_awcache                 (s_cbr_axi4_awcache       ), // (input )
    .s_axi4_awvalid                 (s_cbr_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (s_cbr_axi4_awready       ), // (output)

    .s_axi4_wdata                   (s_cbr_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (s_cbr_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (s_cbr_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (s_cbr_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (s_cbr_axi4_wready        ), // (output)

    .s_axi4_bid                     (s_cbr_axi4_bid           ), // (output)
    .s_axi4_bresp                   (s_cbr_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (s_cbr_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (s_cbr_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m_cbr_axi4_arid          ), // (output)
    .m_axi4_araddr                  (m_cbr_axi4_araddr        ), // (output)
    .m_axi4_arlen                   (m_cbr_axi4_arlen         ), // (output)
    .m_axi4_arsize                  (m_cbr_axi4_arsize        ), // (output)
    .m_axi4_arburst                 (m_cbr_axi4_arburst       ), // (output)
    .m_axi4_arregion                (m_cbr_axi4_arregion      ), // (output)
    .m_axi4_arcache                 (m_cbr_axi4_arcache       ), // (output)
    .m_axi4_arvalid                 (m_cbr_axi4_arvalid       ), // (output)
    .m_axi4_arready                 (m_cbr_axi4_arready       ), // (input )

    .m_axi4_rid                     (m_cbr_axi4_rid           ), // (input )
    .m_axi4_rdata                   (m_cbr_axi4_rdata         ), // (input )
    .m_axi4_rresp                   (m_cbr_axi4_rresp         ), // (input )
    .m_axi4_rlast                   (m_cbr_axi4_rlast         ), // (input )
    .m_axi4_rvalid                  (m_cbr_axi4_rvalid        ), // (input )
    .m_axi4_rready                  (m_cbr_axi4_rready        ), // (output)
    .m_axi4_awid                    (m_cbr_axi4_awid          ), // (output)
    .m_axi4_awaddr                  (m_cbr_axi4_awaddr        ), // (output)
    .m_axi4_awlen                   (m_cbr_axi4_awlen         ), // (output)
    .m_axi4_awsize                  (m_cbr_axi4_awsize        ), // (output)
    .m_axi4_awburst                 (m_cbr_axi4_awburst       ), // (output)
    .m_axi4_awregion                (m_cbr_axi4_awregion      ), // (output)
    .m_axi4_awcache                 (m_cbr_axi4_awcache       ), // (output)
    .m_axi4_awvalid                 (m_cbr_axi4_awvalid       ), // (output)
    .m_axi4_awready                 (m_cbr_axi4_awready       ), // (input )

    .m_axi4_wdata                   (m_cbr_axi4_wdata         ), // (output)
    .m_axi4_wstrob                  (m_cbr_axi4_wstrob        ), // (output)
    .m_axi4_wlast                   (m_cbr_axi4_wlast         ), // (output)
    .m_axi4_wvalid                  (m_cbr_axi4_wvalid        ), // (output)
    .m_axi4_wready                  (m_cbr_axi4_wready        ), // (input )
    .m_axi4_bid                     (m_cbr_axi4_bid           ), // (input )
    .m_axi4_bresp                   (m_cbr_axi4_bresp         ), // (input )
    .m_axi4_bvalid                  (m_cbr_axi4_bvalid        ), // (input )
    .m_axi4_bready                  (m_cbr_axi4_bready        )  // (output)
);
assign m00_cbr_axi4_arid = m_cbr_axi4_arid[ 0* 4+: 4];
assign m00_cbr_axi4_araddr = m_cbr_axi4_araddr[ 0*32+:32]; 
assign m00_cbr_axi4_arlen = m_cbr_axi4_arlen[ 0*8+:8]; 
assign m00_cbr_axi4_arsize = m_cbr_axi4_arsize[ 0*3+:3];
assign m00_cbr_axi4_arburst = m_cbr_axi4_arburst[ 0*2+:2];
assign m00_cbr_axi4_arregion = m_cbr_axi4_arregion[ 0*4+:4];
assign m00_cbr_axi4_arcache = m_cbr_axi4_arcache[ 0*4+:4];
assign m00_cbr_axi4_arvalid = m_cbr_axi4_arvalid[ 0];
assign m_cbr_axi4_arready[ 0] = m00_cbr_axi4_arready;

assign m_cbr_axi4_rid[ 0* 4+: 4] = m00_cbr_axi4_rid;
assign m_cbr_axi4_rdata[ 0*512+:512] = m00_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[ 0*2+:2] = m00_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[ 0] = m00_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[ 0] = m00_cbr_axi4_rvalid;
assign m00_cbr_axi4_rready = m_cbr_axi4_rready[ 0];

assign m00_cbr_axi4_awid = m_cbr_axi4_awid[ 0* 4+: 4];
assign m00_cbr_axi4_awaddr = m_cbr_axi4_awaddr[ 0*32+:32]; 
assign m00_cbr_axi4_awlen = m_cbr_axi4_awlen[ 0*8+:8]; 
assign m00_cbr_axi4_awsize = m_cbr_axi4_awsize[ 0*3+:3];
assign m00_cbr_axi4_awburst = m_cbr_axi4_awburst[ 0*2+:2];
assign m00_cbr_axi4_awregion = m_cbr_axi4_awregion[ 0*4+:4];
assign m00_cbr_axi4_awcache = m_cbr_axi4_awcache[ 0*4+:4];
assign m00_cbr_axi4_awvalid = m_cbr_axi4_awvalid[ 0];
assign m_cbr_axi4_awready[ 0] = m00_cbr_axi4_awready;

assign m00_cbr_axi4_wdata = m_cbr_axi4_wdata[ 0*512+:512];
assign m00_cbr_axi4_wstrob = m_cbr_axi4_wstrob[ 0*64+:64];
assign m00_cbr_axi4_wlast = m_cbr_axi4_wlast[ 0];
assign m00_cbr_axi4_wvalid = m_cbr_axi4_wvalid[ 0];
assign m_cbr_axi4_wready[ 0] = m00_cbr_axi4_wready;

assign m_cbr_axi4_bid[ 0* 4+: 4] = m00_cbr_axi4_bid;
assign m_cbr_axi4_bresp[ 0*2+:2] = m00_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[ 0] = m00_cbr_axi4_bvalid;
assign m00_cbr_axi4_bready = m_cbr_axi4_bready[ 0];
axi_interconnect_width_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_SDATA                    (512                         ), 
    .WIDTH_MDATA                    (256                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .NUM_OUTSTANDING                (4                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u00m_axi_interconnect_width_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m00_cbr_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m00_cbr_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m00_cbr_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m00_cbr_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m00_cbr_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m00_cbr_axi4_arregion      ), // (input )
    .s_axi4_arcache                 (m00_cbr_axi4_arcache       ), // (input )
    .s_axi4_arvalid                 (m00_cbr_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m00_cbr_axi4_arready       ), // (output)

    .s_axi4_rid                     (m00_cbr_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m00_cbr_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m00_cbr_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m00_cbr_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m00_cbr_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m00_cbr_axi4_rready        ), // (input )

    .s_axi4_awid                    (m00_cbr_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m00_cbr_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m00_cbr_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m00_cbr_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m00_cbr_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m00_cbr_axi4_awregion      ), // (input )
    .s_axi4_awcache                 (m00_cbr_axi4_awcache       ), // (input )
    .s_axi4_awvalid                 (m00_cbr_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m00_cbr_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m00_cbr_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m00_cbr_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m00_cbr_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m00_cbr_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m00_cbr_axi4_wready        ), // (output)

    .s_axi4_bid                     (m00_cbr_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m00_cbr_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m00_cbr_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m00_cbr_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m00_dcv_axi4_arid          ), // (output)
    .m_axi4_araddr                  (m00_dcv_axi4_araddr        ), // (output)
    .m_axi4_arlen                   (m00_dcv_axi4_arlen         ), // (output)
    .m_axi4_arsize                  (m00_dcv_axi4_arsize        ), // (output)
    .m_axi4_arburst                 (m00_dcv_axi4_arburst       ), // (output)
    .m_axi4_arregion                (m00_dcv_axi4_arregion      ), // (output)
    .m_axi4_arcache                 (m00_dcv_axi4_arcache       ), // (output)
    .m_axi4_arvalid                 (m00_dcv_axi4_arvalid       ), // (output)
    .m_axi4_arready                 (m00_dcv_axi4_arready       ), // (input )

    .m_axi4_rid                     (m00_dcv_axi4_rid           ), // (input )
    .m_axi4_rdata                   (m00_dcv_axi4_rdata         ), // (input )
    .m_axi4_rresp                   (m00_dcv_axi4_rresp         ), // (input )
    .m_axi4_rlast                   (m00_dcv_axi4_rlast         ), // (input )
    .m_axi4_rvalid                  (m00_dcv_axi4_rvalid        ), // (input )
    .m_axi4_rready                  (m00_dcv_axi4_rready        ), // (output)
    .m_axi4_awid                    (m00_dcv_axi4_awid          ), // (output)
    .m_axi4_awaddr                  (m00_dcv_axi4_awaddr        ), // (output)
    .m_axi4_awlen                   (m00_dcv_axi4_awlen         ), // (output)
    .m_axi4_awsize                  (m00_dcv_axi4_awsize        ), // (output)
    .m_axi4_awburst                 (m00_dcv_axi4_awburst       ), // (output)
    .m_axi4_awregion                (m00_dcv_axi4_awregion      ), // (output)
    .m_axi4_awcache                 (m00_dcv_axi4_awcache       ), // (output)
    .m_axi4_awvalid                 (m00_dcv_axi4_awvalid       ), // (output)
    .m_axi4_awready                 (m00_dcv_axi4_awready       ), // (input )

    .m_axi4_wdata                   (m00_dcv_axi4_wdata         ), // (output)
    .m_axi4_wstrob                  (m00_dcv_axi4_wstrob        ), // (output)
    .m_axi4_wlast                   (m00_dcv_axi4_wlast         ), // (output)
    .m_axi4_wvalid                  (m00_dcv_axi4_wvalid        ), // (output)
    .m_axi4_wready                  (m00_dcv_axi4_wready        ), // (input )
    .m_axi4_bid                     (m00_dcv_axi4_bid           ), // (input )
    .m_axi4_bresp                   (m00_dcv_axi4_bresp         ), // (input )
    .m_axi4_bvalid                  (m00_dcv_axi4_bvalid        ), // (input )
    .m_axi4_bready                  (m00_dcv_axi4_bready        )  // (output)
);
axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (256                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .HAS_LOCK                       (0                           ), 
    .HAS_CACHE                      (1                           ), 
    .HAS_PROT                       (0                           ), 
    .HAS_QOS                        (0                           ), 
    .HAS_REGION                     (1                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u00m_axi_interconnect_clock_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_s                          (clk_sys                    ),  // (input ) 
    .clk_m                          (m00_axi4_clk               ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m00_dcv_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m00_dcv_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m00_dcv_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m00_dcv_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m00_dcv_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m00_dcv_axi4_arregion      ), // (input )
    .s_axi4_arcache                 (m00_dcv_axi4_arcache       ), // (input )
    .s_axi4_arvalid                 (m00_dcv_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m00_dcv_axi4_arready       ), // (output)

    .s_axi4_rid                     (m00_dcv_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m00_dcv_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m00_dcv_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m00_dcv_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m00_dcv_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m00_dcv_axi4_rready        ), // (input )

    .s_axi4_awid                    (m00_dcv_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m00_dcv_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m00_dcv_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m00_dcv_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m00_dcv_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m00_dcv_axi4_awregion      ), // (input )
    .s_axi4_awcache                 (m00_dcv_axi4_awcache       ), // (input )
    .s_axi4_awvalid                 (m00_dcv_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m00_dcv_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m00_dcv_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m00_dcv_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m00_dcv_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m00_dcv_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m00_dcv_axi4_wready        ), // (output)

    .s_axi4_bid                     (m00_dcv_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m00_dcv_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m00_dcv_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m00_dcv_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m00_axi4_arid              ), // (output)
    .m_axi4_araddr                  (m00_axi4_araddr            ), // (output)
    .m_axi4_arlen                   (m00_axi4_arlen             ), // (output)
    .m_axi4_arsize                  (m00_axi4_arsize            ), // (output)
    .m_axi4_arburst                 (m00_axi4_arburst           ), // (output)
    .m_axi4_arregion                (m00_axi4_arregion          ), // (output)
    .m_axi4_arcache                 (m00_axi4_arcache           ), // (output)
    .m_axi4_arvalid                 (m00_axi4_arvalid           ), // (output)
    .m_axi4_arready                 (m00_axi4_arready           ), // (input )

    .m_axi4_rid                     (m00_axi4_rid               ), // (input )
    .m_axi4_rdata                   (m00_axi4_rdata             ), // (input )
    .m_axi4_rresp                   (m00_axi4_rresp             ), // (input )
    .m_axi4_rlast                   (m00_axi4_rlast             ), // (input )
    .m_axi4_rvalid                  (m00_axi4_rvalid            ), // (input )
    .m_axi4_rready                  (m00_axi4_rready            ), // (output)
    .m_axi4_awid                    (m00_axi4_awid              ), // (output)
    .m_axi4_awaddr                  (m00_axi4_awaddr            ), // (output)
    .m_axi4_awlen                   (m00_axi4_awlen             ), // (output)
    .m_axi4_awsize                  (m00_axi4_awsize            ), // (output)
    .m_axi4_awburst                 (m00_axi4_awburst           ), // (output)
    .m_axi4_awregion                (m00_axi4_awregion          ), // (output)
    .m_axi4_awcache                 (m00_axi4_awcache           ), // (output)
    .m_axi4_awvalid                 (m00_axi4_awvalid           ), // (output)
    .m_axi4_awready                 (m00_axi4_awready           ), // (input )

    .m_axi4_wdata                   (m00_axi4_wdata             ), // (output)
    .m_axi4_wstrob                  (m00_axi4_wstrob            ), // (output)
    .m_axi4_wlast                   (m00_axi4_wlast             ), // (output)
    .m_axi4_wvalid                  (m00_axi4_wvalid            ), // (output)
    .m_axi4_wready                  (m00_axi4_wready            ), // (input )
    .m_axi4_bid                     (m00_axi4_bid               ), // (input )
    .m_axi4_bresp                   (m00_axi4_bresp             ), // (input )
    .m_axi4_bvalid                  (m00_axi4_bvalid            ), // (input )
    .m_axi4_bready                  (m00_axi4_bready            )  // (output)
);


endmodule

// +FHDR============================================================================/ 
// Author       : hjie
// Creat Time   : 2025/02/21 11:24:53
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
   input                               s00_axi4_arlock         , 
   input                        [ 3:0] s00_axi4_arcache        , 
   input                        [ 2:0] s00_axi4_arprot         , 
   input                        [ 3:0] s00_axi4_arqos          , 
   input                               s00_axi4_arvalid         , 
   output                              s00_axi4_arready         , 

   output                       [03:0] s00_axi4_rid            , 
   output                       [127:0] s00_axi4_rdata          , 
   output                        [1:0] s00_axi4_rresp          , 
   output                              s00_axi4_rlast          , 
   output                              s00_axi4_rvalid          , 
   input                               s00_axi4_rready          , 

   input                        [03:0] s00_axi4_awid           , 
   input                        [31:0] s00_axi4_awaddr         , 
   input                        [ 7:0] s00_axi4_awlen          , 
   input                        [ 3:0] s00_axi4_awsize         , 
   input                        [ 2:0] s00_axi4_awburst        , 
   input                        [ 3:0] s00_axi4_awregion       , 
   input                               s00_axi4_awlock         , 
   input                        [ 3:0] s00_axi4_awcache        , 
   input                        [ 2:0] s00_axi4_awprot         , 
   input                        [ 3:0] s00_axi4_awqos          , 
   input                               s00_axi4_awvalid         , 
   output                              s00_axi4_awready         , 

   input                        [127:0] s00_axi4_wdata          , 
   input                        [15:0] s00_axi4_wstrob         , 
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
   output                              m00_axi4_arlock         , 
   output                       [ 3:0] m00_axi4_arcache        , 
   output                       [ 2:0] m00_axi4_arprot         , 
   output                       [ 3:0] m00_axi4_arqos          , 
   output                              m00_axi4_arvalid         , 
   input                               m00_axi4_arready         , 

   input                        [03:0] m00_axi4_rid            , 
   input                        [127:0] m00_axi4_rdata          , 
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
   output                              m00_axi4_awlock         , 
   output                       [ 3:0] m00_axi4_awcache        , 
   output                       [ 2:0] m00_axi4_awprot         , 
   output                       [ 3:0] m00_axi4_awqos          , 
   output                              m00_axi4_awvalid         , 
   input                               m00_axi4_awready         , 

   output                       [127:0] m00_axi4_wdata          , 
   output                       [15:0] m00_axi4_wstrob         , 
   output                              m00_axi4_wlast          , 
   output                              m00_axi4_wvalid          , 
   input                               m00_axi4_wready          , 

   input                        [03:0] m00_axi4_bid            , 
   input                         [1:0] m00_axi4_bresp          , 
   input                               m00_axi4_bvalid          , 
   output                              m00_axi4_bready          , 


    input                               m01_axi4_clk               , 
   output                       [03:0] m01_axi4_arid           , 
   output                       [31:0] m01_axi4_araddr         , 
   output                       [ 7:0] m01_axi4_arlen          , 
   output                       [ 2:0] m01_axi4_arsize         , 
   output                       [ 1:0] m01_axi4_arburst        , 
   output                       [ 3:0] m01_axi4_arregion       , 
   output                              m01_axi4_arlock         , 
   output                       [ 3:0] m01_axi4_arcache        , 
   output                       [ 2:0] m01_axi4_arprot         , 
   output                       [ 3:0] m01_axi4_arqos          , 
   output                              m01_axi4_arvalid         , 
   input                               m01_axi4_arready         , 

   input                        [03:0] m01_axi4_rid            , 
   input                        [31:0] m01_axi4_rdata          , 
   input                         [1:0] m01_axi4_rresp          , 
   input                               m01_axi4_rlast          , 
   input                               m01_axi4_rvalid          , 
   output                              m01_axi4_rready          , 

   output                       [03:0] m01_axi4_awid           , 
   output                       [31:0] m01_axi4_awaddr         , 
   output                       [ 7:0] m01_axi4_awlen          , 
   output                       [ 2:0] m01_axi4_awsize         , 
   output                       [ 1:0] m01_axi4_awburst        , 
   output                       [ 3:0] m01_axi4_awregion       , 
   output                              m01_axi4_awlock         , 
   output                       [ 3:0] m01_axi4_awcache        , 
   output                       [ 2:0] m01_axi4_awprot         , 
   output                       [ 3:0] m01_axi4_awqos          , 
   output                              m01_axi4_awvalid         , 
   input                               m01_axi4_awready         , 

   output                       [31:0] m01_axi4_wdata          , 
   output                       [03:0] m01_axi4_wstrob         , 
   output                              m01_axi4_wlast          , 
   output                              m01_axi4_wvalid          , 
   input                               m01_axi4_wready          , 

   input                        [03:0] m01_axi4_bid            , 
   input                         [1:0] m01_axi4_bresp          , 
   input                               m01_axi4_bvalid          , 
   output                              m01_axi4_bready          , 


    input                               m02_axi4_clk               , 
   output                       [03:0] m02_axi4_arid           , 
   output                       [31:0] m02_axi4_araddr         , 
   output                       [ 7:0] m02_axi4_arlen          , 
   output                       [ 2:0] m02_axi4_arsize         , 
   output                       [ 1:0] m02_axi4_arburst        , 
   output                       [ 3:0] m02_axi4_arregion       , 
   output                              m02_axi4_arlock         , 
   output                       [ 3:0] m02_axi4_arcache        , 
   output                       [ 2:0] m02_axi4_arprot         , 
   output                       [ 3:0] m02_axi4_arqos          , 
   output                              m02_axi4_arvalid         , 
   input                               m02_axi4_arready         , 

   input                        [03:0] m02_axi4_rid            , 
   input                        [31:0] m02_axi4_rdata          , 
   input                         [1:0] m02_axi4_rresp          , 
   input                               m02_axi4_rlast          , 
   input                               m02_axi4_rvalid          , 
   output                              m02_axi4_rready          , 

   output                       [03:0] m02_axi4_awid           , 
   output                       [31:0] m02_axi4_awaddr         , 
   output                       [ 7:0] m02_axi4_awlen          , 
   output                       [ 2:0] m02_axi4_awsize         , 
   output                       [ 1:0] m02_axi4_awburst        , 
   output                       [ 3:0] m02_axi4_awregion       , 
   output                              m02_axi4_awlock         , 
   output                       [ 3:0] m02_axi4_awcache        , 
   output                       [ 2:0] m02_axi4_awprot         , 
   output                       [ 3:0] m02_axi4_awqos          , 
   output                              m02_axi4_awvalid         , 
   input                               m02_axi4_awready         , 

   output                       [31:0] m02_axi4_wdata          , 
   output                       [03:0] m02_axi4_wstrob         , 
   output                              m02_axi4_wlast          , 
   output                              m02_axi4_wvalid          , 
   input                               m02_axi4_wready          , 

   input                        [03:0] m02_axi4_bid            , 
   input                         [1:0] m02_axi4_bresp          , 
   input                               m02_axi4_bvalid          , 
   output                              m02_axi4_bready          , 


    input                               m03_axi4_clk               , 
   output                       [03:0] m03_axi4_arid           , 
   output                       [31:0] m03_axi4_araddr         , 
   output                       [ 7:0] m03_axi4_arlen          , 
   output                       [ 2:0] m03_axi4_arsize         , 
   output                       [ 1:0] m03_axi4_arburst        , 
   output                       [ 3:0] m03_axi4_arregion       , 
   output                              m03_axi4_arlock         , 
   output                       [ 3:0] m03_axi4_arcache        , 
   output                       [ 2:0] m03_axi4_arprot         , 
   output                       [ 3:0] m03_axi4_arqos          , 
   output                              m03_axi4_arvalid         , 
   input                               m03_axi4_arready         , 

   input                        [03:0] m03_axi4_rid            , 
   input                        [127:0] m03_axi4_rdata          , 
   input                         [1:0] m03_axi4_rresp          , 
   input                               m03_axi4_rlast          , 
   input                               m03_axi4_rvalid          , 
   output                              m03_axi4_rready          , 

   output                       [03:0] m03_axi4_awid           , 
   output                       [31:0] m03_axi4_awaddr         , 
   output                       [ 7:0] m03_axi4_awlen          , 
   output                       [ 2:0] m03_axi4_awsize         , 
   output                       [ 1:0] m03_axi4_awburst        , 
   output                       [ 3:0] m03_axi4_awregion       , 
   output                              m03_axi4_awlock         , 
   output                       [ 3:0] m03_axi4_awcache        , 
   output                       [ 2:0] m03_axi4_awprot         , 
   output                       [ 3:0] m03_axi4_awqos          , 
   output                              m03_axi4_awvalid         , 
   input                               m03_axi4_awready         , 

   output                       [127:0] m03_axi4_wdata          , 
   output                       [15:0] m03_axi4_wstrob         , 
   output                              m03_axi4_wlast          , 
   output                              m03_axi4_wvalid          , 
   input                               m03_axi4_wready          , 

   input                        [03:0] m03_axi4_bid            , 
   input                         [1:0] m03_axi4_bresp          , 
   input                               m03_axi4_bvalid          , 
   output                              m03_axi4_bready            
);

localparam [4*32-1:0] ADDR_BASE = { 
32'h80800000,
32'h80000000,
32'h80400000,
32'h80c00000};

localparam [4*32-1:0] ADDR_HIGH = { 
32'h80bfffff,
32'h803fffff,
32'h807fffff,
32'h80cfffff};

wire                              [03:0] s00_cdc_axi4_arid                 ; 
wire                              [31:0] s00_cdc_axi4_araddr               ; 
wire                              [ 7:0] s00_cdc_axi4_arlen                ; 
wire                              [ 2:0] s00_cdc_axi4_arsize               ; 
wire                              [ 1:0] s00_cdc_axi4_arburst              ; 
wire                              [ 3:0] s00_cdc_axi4_arregion             ; 
wire                                     s00_cdc_axi4_arlock               ; 
wire                              [ 3:0] s00_cdc_axi4_arcache              ; 
wire                              [ 2:0] s00_cdc_axi4_arprot               ; 
wire                              [ 3:0] s00_cdc_axi4_arqos                ; 
wire                                    s00_cdc_axi4_arvalid              ; 
wire                                    s00_cdc_axi4_arready              ; 

wire                              [03:0] s00_cdc_axi4_rid                  ; 
wire                              [127:0] s00_cdc_axi4_rdata                ;  
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
wire                                     s00_cdc_axi4_awlock               ; 
wire                              [ 3:0] s00_cdc_axi4_awcache              ; 
wire                              [ 2:0] s00_cdc_axi4_awprot               ; 
wire                              [ 3:0] s00_cdc_axi4_awqos                ; 
wire                                    s00_cdc_axi4_awvalid              ; 
wire                                    s00_cdc_axi4_awready              ; 

wire                             [127:0] s00_cdc_axi4_wdata                ; 
wire                             [15:0] s00_cdc_axi4_wstrob               ; 
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
wire                                     s00_dcv_axi4_arlock               ; 
wire                              [ 3:0] s00_dcv_axi4_arcache              ; 
wire                              [ 2:0] s00_dcv_axi4_arprot               ; 
wire                              [ 3:0] s00_dcv_axi4_arqos                ; 
wire                                    s00_dcv_axi4_arvalid              ; 
wire                                    s00_dcv_axi4_arready              ; 

wire                              [03:0] s00_dcv_axi4_rid                  ; 
wire                              [127:0] s00_dcv_axi4_rdata                ;  
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
wire                                     s00_dcv_axi4_awlock               ; 
wire                              [ 3:0] s00_dcv_axi4_awcache              ; 
wire                              [ 2:0] s00_dcv_axi4_awprot               ; 
wire                              [ 3:0] s00_dcv_axi4_awqos                ; 
wire                                    s00_dcv_axi4_awvalid              ; 
wire                                    s00_dcv_axi4_awready              ; 

wire                             [127:0] s00_dcv_axi4_wdata                ; 
wire                             [15:0] s00_dcv_axi4_wstrob               ; 
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
wire                           [01-1:0] s_cbr_axi4_arlock           ;
wire                         [01*4-1:0] s_cbr_axi4_arcache          ; 
wire                         [01*3-1:0] s_cbr_axi4_arprot           ; 
wire                         [01*4-1:0] s_cbr_axi4_arqos            ; 
wire                           [01-1:0] s_cbr_axi4_arvalid          ;  
wire                           [01-1:0] s_cbr_axi4_arready          ; 

wire                        [01*04-1:0] s_cbr_axi4_rid              ; 
wire                        [01*128-1:0] s_cbr_axi4_rdata            ;  
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
wire                           [01-1:0] s_cbr_axi4_awlock           ;  
wire                         [01*4-1:0] s_cbr_axi4_awcache          ; 
wire                         [01*3-1:0] s_cbr_axi4_awprot           ;  
wire                         [01*4-1:0] s_cbr_axi4_awqos            ; 
wire                           [01-1:0] s_cbr_axi4_awvalid          ; 
wire                           [01-1:0] s_cbr_axi4_awready          ; 

wire                        [01*128-1:0] s_cbr_axi4_wdata            ;
wire                        [01*16-1:0] s_cbr_axi4_wstrob           ;
wire                           [01-1:0] s_cbr_axi4_wlast            ;
wire                           [01-1:0] s_cbr_axi4_wvalid           ; 
wire                           [01-1:0] s_cbr_axi4_wready           ; 

wire                        [01*04-1:0] s_cbr_axi4_bid              ;  
wire                         [01*2-1:0] s_cbr_axi4_bresp            ; 
wire                           [01-1:0] s_cbr_axi4_bvalid           ; 
wire                           [01-1:0] s_cbr_axi4_bready           ; 


wire                        [04*04-1:0] m_cbr_axi4_arid             ; 
wire                        [04*32-1:0] m_cbr_axi4_araddr           ;
wire                         [04*8-1:0] m_cbr_axi4_arlen            ;
wire                         [04*3-1:0] m_cbr_axi4_arsize           ; 
wire                         [04*2-1:0] m_cbr_axi4_arburst          ; 
wire                         [04*4-1:0] m_cbr_axi4_arregion         ;
wire                           [04-1:0] m_cbr_axi4_arlock           ;
wire                         [04*4-1:0] m_cbr_axi4_arcache          ; 
wire                         [04*3-1:0] m_cbr_axi4_arprot           ; 
wire                         [04*4-1:0] m_cbr_axi4_arqos            ; 
wire                           [04-1:0] m_cbr_axi4_arvalid          ;  
wire                           [04-1:0] m_cbr_axi4_arready          ; 

wire                        [04*04-1:0] m_cbr_axi4_rid              ; 
wire                        [04*128-1:0] m_cbr_axi4_rdata            ;  
wire                         [04*2-1:0] m_cbr_axi4_rresp            ;  
wire                           [04-1:0] m_cbr_axi4_rlast            ;  
wire                           [04-1:0] m_cbr_axi4_rvalid           ; 
wire                           [04-1:0] m_cbr_axi4_rready           ;  

wire                        [04*04-1:0] m_cbr_axi4_awid             ;  
wire                        [04*32-1:0] m_cbr_axi4_awaddr           ; 
wire                         [04*8-1:0] m_cbr_axi4_awlen            ; 
wire                         [04*3-1:0] m_cbr_axi4_awsize           ;  
wire                         [04*2-1:0] m_cbr_axi4_awburst          ; 
wire                         [04*4-1:0] m_cbr_axi4_awregion         ; 
wire                           [04-1:0] m_cbr_axi4_awlock           ;  
wire                         [04*4-1:0] m_cbr_axi4_awcache          ; 
wire                         [04*3-1:0] m_cbr_axi4_awprot           ;  
wire                         [04*4-1:0] m_cbr_axi4_awqos            ; 
wire                           [04-1:0] m_cbr_axi4_awvalid          ; 
wire                           [04-1:0] m_cbr_axi4_awready          ; 

wire                        [04*128-1:0] m_cbr_axi4_wdata            ;
wire                        [04*16-1:0] m_cbr_axi4_wstrob           ;
wire                           [04-1:0] m_cbr_axi4_wlast            ;
wire                           [04-1:0] m_cbr_axi4_wvalid           ; 
wire                           [04-1:0] m_cbr_axi4_wready           ; 

wire                        [04*04-1:0] m_cbr_axi4_bid              ;  
wire                         [04*2-1:0] m_cbr_axi4_bresp            ; 
wire                           [04-1:0] m_cbr_axi4_bvalid           ; 
wire                           [04-1:0] m_cbr_axi4_bready           ; 


wire                              [03:0] m00_cbr_axi4_arid                 ; 
wire                              [31:0] m00_cbr_axi4_araddr               ; 
wire                              [ 7:0] m00_cbr_axi4_arlen                ; 
wire                              [ 2:0] m00_cbr_axi4_arsize               ; 
wire                              [ 1:0] m00_cbr_axi4_arburst              ; 
wire                              [ 3:0] m00_cbr_axi4_arregion             ; 
wire                                     m00_cbr_axi4_arlock               ; 
wire                              [ 3:0] m00_cbr_axi4_arcache              ; 
wire                              [ 2:0] m00_cbr_axi4_arprot               ; 
wire                              [ 3:0] m00_cbr_axi4_arqos                ; 
wire                                    m00_cbr_axi4_arvalid              ; 
wire                                    m00_cbr_axi4_arready              ; 

wire                              [03:0] m00_cbr_axi4_rid                  ; 
wire                              [127:0] m00_cbr_axi4_rdata                ;  
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
wire                                     m00_cbr_axi4_awlock               ; 
wire                              [ 3:0] m00_cbr_axi4_awcache              ; 
wire                              [ 2:0] m00_cbr_axi4_awprot               ; 
wire                              [ 3:0] m00_cbr_axi4_awqos                ; 
wire                                    m00_cbr_axi4_awvalid              ; 
wire                                    m00_cbr_axi4_awready              ; 

wire                             [127:0] m00_cbr_axi4_wdata                ; 
wire                             [15:0] m00_cbr_axi4_wstrob               ; 
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
wire                                     m00_dcv_axi4_arlock               ; 
wire                              [ 3:0] m00_dcv_axi4_arcache              ; 
wire                              [ 2:0] m00_dcv_axi4_arprot               ; 
wire                              [ 3:0] m00_dcv_axi4_arqos                ; 
wire                                    m00_dcv_axi4_arvalid              ; 
wire                                    m00_dcv_axi4_arready              ; 

wire                              [03:0] m00_dcv_axi4_rid                  ; 
wire                              [127:0] m00_dcv_axi4_rdata                ;  
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
wire                                     m00_dcv_axi4_awlock               ; 
wire                              [ 3:0] m00_dcv_axi4_awcache              ; 
wire                              [ 2:0] m00_dcv_axi4_awprot               ; 
wire                              [ 3:0] m00_dcv_axi4_awqos                ; 
wire                                    m00_dcv_axi4_awvalid              ; 
wire                                    m00_dcv_axi4_awready              ; 

wire                             [127:0] m00_dcv_axi4_wdata                ; 
wire                             [15:0] m00_dcv_axi4_wstrob               ; 
wire                                     m00_dcv_axi4_wlast                ; 
wire                                    m00_dcv_axi4_wvalid               ; 
wire                                    m00_dcv_axi4_wready               ; 

wire                             [03:0] m00_dcv_axi4_bid                  ;  
wire                             [ 1:0] m00_dcv_axi4_bresp                ; 
wire                                    m00_dcv_axi4_bvalid               ; 
wire                                    m00_dcv_axi4_bready               ; 


wire                              [03:0] m01_cbr_axi4_arid                 ; 
wire                              [31:0] m01_cbr_axi4_araddr               ; 
wire                              [ 7:0] m01_cbr_axi4_arlen                ; 
wire                              [ 2:0] m01_cbr_axi4_arsize               ; 
wire                              [ 1:0] m01_cbr_axi4_arburst              ; 
wire                              [ 3:0] m01_cbr_axi4_arregion             ; 
wire                                     m01_cbr_axi4_arlock               ; 
wire                              [ 3:0] m01_cbr_axi4_arcache              ; 
wire                              [ 2:0] m01_cbr_axi4_arprot               ; 
wire                              [ 3:0] m01_cbr_axi4_arqos                ; 
wire                                    m01_cbr_axi4_arvalid              ; 
wire                                    m01_cbr_axi4_arready              ; 

wire                              [03:0] m01_cbr_axi4_rid                  ; 
wire                              [127:0] m01_cbr_axi4_rdata                ;  
wire                              [ 1:0] m01_cbr_axi4_rresp                ;  
wire                                     m01_cbr_axi4_rlast                ; 
wire                                     m01_cbr_axi4_rvalid               ; 
wire                                     m01_cbr_axi4_rready               ; 

wire                              [03:0] m01_cbr_axi4_awid                 ; 
wire                              [31:0] m01_cbr_axi4_awaddr               ; 
wire                              [ 7:0] m01_cbr_axi4_awlen                ; 
wire                              [ 2:0] m01_cbr_axi4_awsize               ; 
wire                              [ 1:0] m01_cbr_axi4_awburst              ; 
wire                              [ 3:0] m01_cbr_axi4_awregion             ; 
wire                                     m01_cbr_axi4_awlock               ; 
wire                              [ 3:0] m01_cbr_axi4_awcache              ; 
wire                              [ 2:0] m01_cbr_axi4_awprot               ; 
wire                              [ 3:0] m01_cbr_axi4_awqos                ; 
wire                                    m01_cbr_axi4_awvalid              ; 
wire                                    m01_cbr_axi4_awready              ; 

wire                             [127:0] m01_cbr_axi4_wdata                ; 
wire                             [15:0] m01_cbr_axi4_wstrob               ; 
wire                                    m01_cbr_axi4_wlast                ; 
wire                                    m01_cbr_axi4_wvalid               ; 
wire                                    m01_cbr_axi4_wready               ; 

wire                             [03:0] m01_cbr_axi4_bid                  ;  
wire                             [ 1:0] m01_cbr_axi4_bresp                ; 
wire                                    m01_cbr_axi4_bvalid               ; 
wire                                    m01_cbr_axi4_bready               ; 


wire                              [03:0] m01_dcv_axi4_arid                 ; 
wire                              [31:0] m01_dcv_axi4_araddr               ; 
wire                              [ 7:0] m01_dcv_axi4_arlen                ; 
wire                              [ 2:0] m01_dcv_axi4_arsize               ; 
wire                              [ 1:0] m01_dcv_axi4_arburst              ; 
wire                              [ 3:0] m01_dcv_axi4_arregion             ; 
wire                                     m01_dcv_axi4_arlock               ; 
wire                              [ 3:0] m01_dcv_axi4_arcache              ; 
wire                              [ 2:0] m01_dcv_axi4_arprot               ; 
wire                              [ 3:0] m01_dcv_axi4_arqos                ; 
wire                                    m01_dcv_axi4_arvalid              ; 
wire                                    m01_dcv_axi4_arready              ; 

wire                              [03:0] m01_dcv_axi4_rid                  ; 
wire                              [31:0] m01_dcv_axi4_rdata                ;  
wire                              [ 1:0] m01_dcv_axi4_rresp                ;  
wire                                     m01_dcv_axi4_rlast                ; 
wire                                     m01_dcv_axi4_rvalid               ; 
wire                                     m01_dcv_axi4_rready               ; 

wire                              [03:0] m01_dcv_axi4_awid                 ; 
wire                              [31:0] m01_dcv_axi4_awaddr               ; 
wire                              [ 7:0] m01_dcv_axi4_awlen                ; 
wire                              [ 2:0] m01_dcv_axi4_awsize               ; 
wire                              [ 1:0] m01_dcv_axi4_awburst              ; 
wire                              [ 3:0] m01_dcv_axi4_awregion             ; 
wire                                     m01_dcv_axi4_awlock               ; 
wire                              [ 3:0] m01_dcv_axi4_awcache              ; 
wire                              [ 2:0] m01_dcv_axi4_awprot               ; 
wire                              [ 3:0] m01_dcv_axi4_awqos                ; 
wire                                    m01_dcv_axi4_awvalid              ; 
wire                                    m01_dcv_axi4_awready              ; 

wire                             [31:0] m01_dcv_axi4_wdata                ; 
wire                             [03:0] m01_dcv_axi4_wstrob               ; 
wire                                     m01_dcv_axi4_wlast                ; 
wire                                    m01_dcv_axi4_wvalid               ; 
wire                                    m01_dcv_axi4_wready               ; 

wire                             [03:0] m01_dcv_axi4_bid                  ;  
wire                             [ 1:0] m01_dcv_axi4_bresp                ; 
wire                                    m01_dcv_axi4_bvalid               ; 
wire                                    m01_dcv_axi4_bready               ; 


wire                              [03:0] m02_cbr_axi4_arid                 ; 
wire                              [31:0] m02_cbr_axi4_araddr               ; 
wire                              [ 7:0] m02_cbr_axi4_arlen                ; 
wire                              [ 2:0] m02_cbr_axi4_arsize               ; 
wire                              [ 1:0] m02_cbr_axi4_arburst              ; 
wire                              [ 3:0] m02_cbr_axi4_arregion             ; 
wire                                     m02_cbr_axi4_arlock               ; 
wire                              [ 3:0] m02_cbr_axi4_arcache              ; 
wire                              [ 2:0] m02_cbr_axi4_arprot               ; 
wire                              [ 3:0] m02_cbr_axi4_arqos                ; 
wire                                    m02_cbr_axi4_arvalid              ; 
wire                                    m02_cbr_axi4_arready              ; 

wire                              [03:0] m02_cbr_axi4_rid                  ; 
wire                              [127:0] m02_cbr_axi4_rdata                ;  
wire                              [ 1:0] m02_cbr_axi4_rresp                ;  
wire                                     m02_cbr_axi4_rlast                ; 
wire                                     m02_cbr_axi4_rvalid               ; 
wire                                     m02_cbr_axi4_rready               ; 

wire                              [03:0] m02_cbr_axi4_awid                 ; 
wire                              [31:0] m02_cbr_axi4_awaddr               ; 
wire                              [ 7:0] m02_cbr_axi4_awlen                ; 
wire                              [ 2:0] m02_cbr_axi4_awsize               ; 
wire                              [ 1:0] m02_cbr_axi4_awburst              ; 
wire                              [ 3:0] m02_cbr_axi4_awregion             ; 
wire                                     m02_cbr_axi4_awlock               ; 
wire                              [ 3:0] m02_cbr_axi4_awcache              ; 
wire                              [ 2:0] m02_cbr_axi4_awprot               ; 
wire                              [ 3:0] m02_cbr_axi4_awqos                ; 
wire                                    m02_cbr_axi4_awvalid              ; 
wire                                    m02_cbr_axi4_awready              ; 

wire                             [127:0] m02_cbr_axi4_wdata                ; 
wire                             [15:0] m02_cbr_axi4_wstrob               ; 
wire                                    m02_cbr_axi4_wlast                ; 
wire                                    m02_cbr_axi4_wvalid               ; 
wire                                    m02_cbr_axi4_wready               ; 

wire                             [03:0] m02_cbr_axi4_bid                  ;  
wire                             [ 1:0] m02_cbr_axi4_bresp                ; 
wire                                    m02_cbr_axi4_bvalid               ; 
wire                                    m02_cbr_axi4_bready               ; 


wire                              [03:0] m02_dcv_axi4_arid                 ; 
wire                              [31:0] m02_dcv_axi4_araddr               ; 
wire                              [ 7:0] m02_dcv_axi4_arlen                ; 
wire                              [ 2:0] m02_dcv_axi4_arsize               ; 
wire                              [ 1:0] m02_dcv_axi4_arburst              ; 
wire                              [ 3:0] m02_dcv_axi4_arregion             ; 
wire                                     m02_dcv_axi4_arlock               ; 
wire                              [ 3:0] m02_dcv_axi4_arcache              ; 
wire                              [ 2:0] m02_dcv_axi4_arprot               ; 
wire                              [ 3:0] m02_dcv_axi4_arqos                ; 
wire                                    m02_dcv_axi4_arvalid              ; 
wire                                    m02_dcv_axi4_arready              ; 

wire                              [03:0] m02_dcv_axi4_rid                  ; 
wire                              [31:0] m02_dcv_axi4_rdata                ;  
wire                              [ 1:0] m02_dcv_axi4_rresp                ;  
wire                                     m02_dcv_axi4_rlast                ; 
wire                                     m02_dcv_axi4_rvalid               ; 
wire                                     m02_dcv_axi4_rready               ; 

wire                              [03:0] m02_dcv_axi4_awid                 ; 
wire                              [31:0] m02_dcv_axi4_awaddr               ; 
wire                              [ 7:0] m02_dcv_axi4_awlen                ; 
wire                              [ 2:0] m02_dcv_axi4_awsize               ; 
wire                              [ 1:0] m02_dcv_axi4_awburst              ; 
wire                              [ 3:0] m02_dcv_axi4_awregion             ; 
wire                                     m02_dcv_axi4_awlock               ; 
wire                              [ 3:0] m02_dcv_axi4_awcache              ; 
wire                              [ 2:0] m02_dcv_axi4_awprot               ; 
wire                              [ 3:0] m02_dcv_axi4_awqos                ; 
wire                                    m02_dcv_axi4_awvalid              ; 
wire                                    m02_dcv_axi4_awready              ; 

wire                             [31:0] m02_dcv_axi4_wdata                ; 
wire                             [03:0] m02_dcv_axi4_wstrob               ; 
wire                                     m02_dcv_axi4_wlast                ; 
wire                                    m02_dcv_axi4_wvalid               ; 
wire                                    m02_dcv_axi4_wready               ; 

wire                             [03:0] m02_dcv_axi4_bid                  ;  
wire                             [ 1:0] m02_dcv_axi4_bresp                ; 
wire                                    m02_dcv_axi4_bvalid               ; 
wire                                    m02_dcv_axi4_bready               ; 


wire                              [03:0] m03_cbr_axi4_arid                 ; 
wire                              [31:0] m03_cbr_axi4_araddr               ; 
wire                              [ 7:0] m03_cbr_axi4_arlen                ; 
wire                              [ 2:0] m03_cbr_axi4_arsize               ; 
wire                              [ 1:0] m03_cbr_axi4_arburst              ; 
wire                              [ 3:0] m03_cbr_axi4_arregion             ; 
wire                                     m03_cbr_axi4_arlock               ; 
wire                              [ 3:0] m03_cbr_axi4_arcache              ; 
wire                              [ 2:0] m03_cbr_axi4_arprot               ; 
wire                              [ 3:0] m03_cbr_axi4_arqos                ; 
wire                                    m03_cbr_axi4_arvalid              ; 
wire                                    m03_cbr_axi4_arready              ; 

wire                              [03:0] m03_cbr_axi4_rid                  ; 
wire                              [127:0] m03_cbr_axi4_rdata                ;  
wire                              [ 1:0] m03_cbr_axi4_rresp                ;  
wire                                     m03_cbr_axi4_rlast                ; 
wire                                     m03_cbr_axi4_rvalid               ; 
wire                                     m03_cbr_axi4_rready               ; 

wire                              [03:0] m03_cbr_axi4_awid                 ; 
wire                              [31:0] m03_cbr_axi4_awaddr               ; 
wire                              [ 7:0] m03_cbr_axi4_awlen                ; 
wire                              [ 2:0] m03_cbr_axi4_awsize               ; 
wire                              [ 1:0] m03_cbr_axi4_awburst              ; 
wire                              [ 3:0] m03_cbr_axi4_awregion             ; 
wire                                     m03_cbr_axi4_awlock               ; 
wire                              [ 3:0] m03_cbr_axi4_awcache              ; 
wire                              [ 2:0] m03_cbr_axi4_awprot               ; 
wire                              [ 3:0] m03_cbr_axi4_awqos                ; 
wire                                    m03_cbr_axi4_awvalid              ; 
wire                                    m03_cbr_axi4_awready              ; 

wire                             [127:0] m03_cbr_axi4_wdata                ; 
wire                             [15:0] m03_cbr_axi4_wstrob               ; 
wire                                    m03_cbr_axi4_wlast                ; 
wire                                    m03_cbr_axi4_wvalid               ; 
wire                                    m03_cbr_axi4_wready               ; 

wire                             [03:0] m03_cbr_axi4_bid                  ;  
wire                             [ 1:0] m03_cbr_axi4_bresp                ; 
wire                                    m03_cbr_axi4_bvalid               ; 
wire                                    m03_cbr_axi4_bready               ; 


wire                              [03:0] m03_dcv_axi4_arid                 ; 
wire                              [31:0] m03_dcv_axi4_araddr               ; 
wire                              [ 7:0] m03_dcv_axi4_arlen                ; 
wire                              [ 2:0] m03_dcv_axi4_arsize               ; 
wire                              [ 1:0] m03_dcv_axi4_arburst              ; 
wire                              [ 3:0] m03_dcv_axi4_arregion             ; 
wire                                     m03_dcv_axi4_arlock               ; 
wire                              [ 3:0] m03_dcv_axi4_arcache              ; 
wire                              [ 2:0] m03_dcv_axi4_arprot               ; 
wire                              [ 3:0] m03_dcv_axi4_arqos                ; 
wire                                    m03_dcv_axi4_arvalid              ; 
wire                                    m03_dcv_axi4_arready              ; 

wire                              [03:0] m03_dcv_axi4_rid                  ; 
wire                              [127:0] m03_dcv_axi4_rdata                ;  
wire                              [ 1:0] m03_dcv_axi4_rresp                ;  
wire                                     m03_dcv_axi4_rlast                ; 
wire                                     m03_dcv_axi4_rvalid               ; 
wire                                     m03_dcv_axi4_rready               ; 

wire                              [03:0] m03_dcv_axi4_awid                 ; 
wire                              [31:0] m03_dcv_axi4_awaddr               ; 
wire                              [ 7:0] m03_dcv_axi4_awlen                ; 
wire                              [ 2:0] m03_dcv_axi4_awsize               ; 
wire                              [ 1:0] m03_dcv_axi4_awburst              ; 
wire                              [ 3:0] m03_dcv_axi4_awregion             ; 
wire                                     m03_dcv_axi4_awlock               ; 
wire                              [ 3:0] m03_dcv_axi4_awcache              ; 
wire                              [ 2:0] m03_dcv_axi4_awprot               ; 
wire                              [ 3:0] m03_dcv_axi4_awqos                ; 
wire                                    m03_dcv_axi4_awvalid              ; 
wire                                    m03_dcv_axi4_awready              ; 

wire                             [127:0] m03_dcv_axi4_wdata                ; 
wire                             [15:0] m03_dcv_axi4_wstrob               ; 
wire                                     m03_dcv_axi4_wlast                ; 
wire                                    m03_dcv_axi4_wvalid               ; 
wire                                    m03_dcv_axi4_wready               ; 

wire                             [03:0] m03_dcv_axi4_bid                  ;  
wire                             [ 1:0] m03_dcv_axi4_bresp                ; 
wire                                    m03_dcv_axi4_bvalid               ; 
wire                                    m03_dcv_axi4_bready               ; 


assign s00_cdc_axi4_arid = s00_axi4_arid;
assign s00_cdc_axi4_araddr = s00_axi4_araddr;
assign s00_cdc_axi4_arlen = s00_axi4_arlen;
assign s00_cdc_axi4_arsize = s00_axi4_arsize;
assign s00_cdc_axi4_arburst = s00_axi4_arburst;
assign s00_cdc_axi4_arregion = s00_axi4_arregion;
assign s00_cdc_axi4_arlock = s00_axi4_arlock;
assign s00_cdc_axi4_arcache = s00_axi4_arcache;
assign s00_cdc_axi4_arprot = s00_axi4_arprot;
assign s00_cdc_axi4_arqos = s00_axi4_arqos;
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
assign s00_cdc_axi4_awlock = s00_axi4_awlock;
assign s00_cdc_axi4_awcache = s00_axi4_awcache;
assign s00_cdc_axi4_awprot = s00_axi4_awprot;
assign s00_cdc_axi4_awqos = s00_axi4_awqos;
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
assign s00_dcv_axi4_arlock = s00_cdc_axi4_arlock;
assign s00_dcv_axi4_arcache = s00_cdc_axi4_arcache;
assign s00_dcv_axi4_arprot = s00_cdc_axi4_arprot;
assign s00_dcv_axi4_arqos = s00_cdc_axi4_arqos;
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
assign s00_dcv_axi4_awlock = s00_cdc_axi4_awlock;
assign s00_dcv_axi4_awcache = s00_cdc_axi4_awcache;
assign s00_dcv_axi4_awprot = s00_cdc_axi4_awprot;
assign s00_dcv_axi4_awqos = s00_cdc_axi4_awqos;
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
assign s_cbr_axi4_arlock[ 0] = s00_dcv_axi4_arlock;
assign s_cbr_axi4_arcache[ 0*4+:4] = s00_dcv_axi4_arcache;
assign s_cbr_axi4_arprot[ 0*3+:3] = s00_dcv_axi4_arprot;
assign s_cbr_axi4_arqos[ 0*4+:4] = s00_dcv_axi4_arqos;
assign s_cbr_axi4_arvalid[ 0] = s00_dcv_axi4_arvalid;
assign s00_dcv_axi4_arready = s_cbr_axi4_arready[ 0];

assign s00_dcv_axi4_rid = s_cbr_axi4_rid[ 0* 4+: 4];
assign s00_dcv_axi4_rdata = s_cbr_axi4_rdata[ 0*128+:128];
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
assign s_cbr_axi4_awlock[ 0] = s00_dcv_axi4_awlock;
assign s_cbr_axi4_awcache[ 0*4+:4] = s00_dcv_axi4_awcache;
assign s_cbr_axi4_awprot[ 0*3+:3] = s00_dcv_axi4_awprot;
assign s_cbr_axi4_awqos[ 0*4+:4] = s00_dcv_axi4_awqos;
assign s_cbr_axi4_awvalid[ 0] = s00_dcv_axi4_awvalid;
assign s00_dcv_axi4_awready = s_cbr_axi4_awready[ 0];

assign s_cbr_axi4_wdata[ 0*128+:128] = s00_dcv_axi4_wdata;
assign s_cbr_axi4_wstrob[ 0*16+:16] = s00_dcv_axi4_wstrob;
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
    .NUM_MASTER                     (4                           ), 
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (128                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .ADDR_BASE                      (ADDR_BASE                  ),
    .ADDR_HIGH                      (ADDR_HIGH                  ),
    .NUM_OUTSTANDING                (16                          ), 
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
    .s_axi4_arlock                  (s_cbr_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (s_cbr_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (s_cbr_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (s_cbr_axi4_arqos         ), // (input )
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
    .s_axi4_awlock                  (s_cbr_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (s_cbr_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (s_cbr_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (s_cbr_axi4_awqos         ), // (input )
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
    .m_axi4_arlock                  (m_cbr_axi4_arlock        ), // (output)
    .m_axi4_arcache                 (m_cbr_axi4_arcache       ), // (output)
    .m_axi4_arprot                  (m_cbr_axi4_arprot        ), // (output)
    .m_axi4_arqos                   (m_cbr_axi4_arqos         ), // (output)
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
    .m_axi4_awlock                  (m_cbr_axi4_awlock        ), // (output)
    .m_axi4_awcache                 (m_cbr_axi4_awcache       ), // (output)
    .m_axi4_awprot                  (m_cbr_axi4_awprot        ), // (output)
    .m_axi4_awqos                   (m_cbr_axi4_awqos         ), // (output)// (input )
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
assign m00_cbr_axi4_arlock = m_cbr_axi4_arlock[ 0];
assign m00_cbr_axi4_arcache = m_cbr_axi4_arcache[ 0*4+:4];
assign m00_cbr_axi4_arprot = m_cbr_axi4_arprot[ 0*3+:3];
assign m00_cbr_axi4_arqos = m_cbr_axi4_arqos[ 0*4+:4];
assign m00_cbr_axi4_arvalid = m_cbr_axi4_arvalid[ 0];
assign m_cbr_axi4_arready[ 0] = m00_cbr_axi4_arready;

assign m_cbr_axi4_rid[ 0* 4+: 4] = m00_cbr_axi4_rid;
assign m_cbr_axi4_rdata[ 0*128+:128] = m00_cbr_axi4_rdata;
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
assign m00_cbr_axi4_awlock = m_cbr_axi4_awlock[ 0];
assign m00_cbr_axi4_awcache = m_cbr_axi4_awcache[ 0*4+:4];
assign m00_cbr_axi4_awprot = m_cbr_axi4_awprot[ 0*3+:3];
assign m00_cbr_axi4_awqos = m_cbr_axi4_awqos[ 0*4+:4];
assign m00_cbr_axi4_awvalid = m_cbr_axi4_awvalid[ 0];
assign m_cbr_axi4_awready[ 0] = m00_cbr_axi4_awready;

assign m00_cbr_axi4_wdata = m_cbr_axi4_wdata[ 0*128+:128];
assign m00_cbr_axi4_wstrob = m_cbr_axi4_wstrob[ 0*16+:16];
assign m00_cbr_axi4_wlast = m_cbr_axi4_wlast[ 0];
assign m00_cbr_axi4_wvalid = m_cbr_axi4_wvalid[ 0];
assign m_cbr_axi4_wready[ 0] = m00_cbr_axi4_wready;

assign m_cbr_axi4_bid[ 0* 4+: 4] = m00_cbr_axi4_bid;
assign m_cbr_axi4_bresp[ 0*2+:2] = m00_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[ 0] = m00_cbr_axi4_bvalid;
assign m00_cbr_axi4_bready = m_cbr_axi4_bready[ 0];
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

assign m00_dcv_axi4_awid= m00_cbr_axi4_awid;
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
assign m01_cbr_axi4_arid = m_cbr_axi4_arid[ 1* 4+: 4];
assign m01_cbr_axi4_araddr = m_cbr_axi4_araddr[ 1*32+:32]; 
assign m01_cbr_axi4_arlen = m_cbr_axi4_arlen[ 1*8+:8]; 
assign m01_cbr_axi4_arsize = m_cbr_axi4_arsize[ 1*3+:3];
assign m01_cbr_axi4_arburst = m_cbr_axi4_arburst[ 1*2+:2];
assign m01_cbr_axi4_arregion = m_cbr_axi4_arregion[ 1*4+:4];
assign m01_cbr_axi4_arlock = m_cbr_axi4_arlock[ 1];
assign m01_cbr_axi4_arcache = m_cbr_axi4_arcache[ 1*4+:4];
assign m01_cbr_axi4_arprot = m_cbr_axi4_arprot[ 1*3+:3];
assign m01_cbr_axi4_arqos = m_cbr_axi4_arqos[ 1*4+:4];
assign m01_cbr_axi4_arvalid = m_cbr_axi4_arvalid[ 1];
assign m_cbr_axi4_arready[ 1] = m01_cbr_axi4_arready;

assign m_cbr_axi4_rid[ 1* 4+: 4] = m01_cbr_axi4_rid;
assign m_cbr_axi4_rdata[ 1*128+:128] = m01_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[ 1*2+:2] = m01_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[ 1] = m01_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[ 1] = m01_cbr_axi4_rvalid;
assign m01_cbr_axi4_rready = m_cbr_axi4_rready[ 1];

assign m01_cbr_axi4_awid = m_cbr_axi4_awid[ 1* 4+: 4];
assign m01_cbr_axi4_awaddr = m_cbr_axi4_awaddr[ 1*32+:32]; 
assign m01_cbr_axi4_awlen = m_cbr_axi4_awlen[ 1*8+:8]; 
assign m01_cbr_axi4_awsize = m_cbr_axi4_awsize[ 1*3+:3];
assign m01_cbr_axi4_awburst = m_cbr_axi4_awburst[ 1*2+:2];
assign m01_cbr_axi4_awregion = m_cbr_axi4_awregion[ 1*4+:4];
assign m01_cbr_axi4_awlock = m_cbr_axi4_awlock[ 1];
assign m01_cbr_axi4_awcache = m_cbr_axi4_awcache[ 1*4+:4];
assign m01_cbr_axi4_awprot = m_cbr_axi4_awprot[ 1*3+:3];
assign m01_cbr_axi4_awqos = m_cbr_axi4_awqos[ 1*4+:4];
assign m01_cbr_axi4_awvalid = m_cbr_axi4_awvalid[ 1];
assign m_cbr_axi4_awready[ 1] = m01_cbr_axi4_awready;

assign m01_cbr_axi4_wdata = m_cbr_axi4_wdata[ 1*128+:128];
assign m01_cbr_axi4_wstrob = m_cbr_axi4_wstrob[ 1*16+:16];
assign m01_cbr_axi4_wlast = m_cbr_axi4_wlast[ 1];
assign m01_cbr_axi4_wvalid = m_cbr_axi4_wvalid[ 1];
assign m_cbr_axi4_wready[ 1] = m01_cbr_axi4_wready;

assign m_cbr_axi4_bid[ 1* 4+: 4] = m01_cbr_axi4_bid;
assign m_cbr_axi4_bresp[ 1*2+:2] = m01_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[ 1] = m01_cbr_axi4_bvalid;
assign m01_cbr_axi4_bready = m_cbr_axi4_bready[ 1];
axi_interconnect_width_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_SDATA                    (128                         ), 
    .WIDTH_MDATA                    (32                          ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .NUM_OUTSTANDING                (16                          ), 
    .U_DLY                          (U_DLY                      ) 
)
u01m_axi_interconnect_width_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m01_cbr_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m01_cbr_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m01_cbr_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m01_cbr_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m01_cbr_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m01_cbr_axi4_arregion      ), // (input )
    .s_axi4_arlock                  (m01_cbr_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m01_cbr_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m01_cbr_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m01_cbr_axi4_arqos         ), // (input )
    .s_axi4_arvalid                 (m01_cbr_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m01_cbr_axi4_arready       ), // (output)

    .s_axi4_rid                     (m01_cbr_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m01_cbr_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m01_cbr_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m01_cbr_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m01_cbr_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m01_cbr_axi4_rready        ), // (input )

    .s_axi4_awid                    (m01_cbr_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m01_cbr_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m01_cbr_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m01_cbr_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m01_cbr_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m01_cbr_axi4_awregion      ), // (input )
    .s_axi4_awlock                  (m01_cbr_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m01_cbr_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m01_cbr_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m01_cbr_axi4_awqos         ), // (input )
    .s_axi4_awvalid                 (m01_cbr_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m01_cbr_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m01_cbr_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m01_cbr_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m01_cbr_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m01_cbr_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m01_cbr_axi4_wready        ), // (output)

    .s_axi4_bid                     (m01_cbr_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m01_cbr_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m01_cbr_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m01_cbr_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m01_dcv_axi4_arid          ), // (output)
    .m_axi4_araddr                  (m01_dcv_axi4_araddr        ), // (output)
    .m_axi4_arlen                   (m01_dcv_axi4_arlen         ), // (output)
    .m_axi4_arsize                  (m01_dcv_axi4_arsize        ), // (output)
    .m_axi4_arburst                 (m01_dcv_axi4_arburst       ), // (output)
    .m_axi4_arregion                (m01_dcv_axi4_arregion      ), // (output)
    .m_axi4_arlock                  (m01_dcv_axi4_arlock        ), // (output)
    .m_axi4_arcache                 (m01_dcv_axi4_arcache       ), // (output)
    .m_axi4_arprot                  (m01_dcv_axi4_arprot        ), // (output)
    .m_axi4_arqos                   (m01_dcv_axi4_arqos         ), // (output)
    .m_axi4_arvalid                 (m01_dcv_axi4_arvalid       ), // (output)
    .m_axi4_arready                 (m01_dcv_axi4_arready       ), // (input )

    .m_axi4_rid                     (m01_dcv_axi4_rid           ), // (input )
    .m_axi4_rdata                   (m01_dcv_axi4_rdata         ), // (input )
    .m_axi4_rresp                   (m01_dcv_axi4_rresp         ), // (input )
    .m_axi4_rlast                   (m01_dcv_axi4_rlast         ), // (input )
    .m_axi4_rvalid                  (m01_dcv_axi4_rvalid        ), // (input )
    .m_axi4_rready                  (m01_dcv_axi4_rready        ), // (output)
    .m_axi4_awid                    (m01_dcv_axi4_awid          ), // (output)
    .m_axi4_awaddr                  (m01_dcv_axi4_awaddr        ), // (output)
    .m_axi4_awlen                   (m01_dcv_axi4_awlen         ), // (output)
    .m_axi4_awsize                  (m01_dcv_axi4_awsize        ), // (output)
    .m_axi4_awburst                 (m01_dcv_axi4_awburst       ), // (output)
    .m_axi4_awregion                (m01_dcv_axi4_awregion      ), // (output)
    .m_axi4_awlock                  (m01_dcv_axi4_awlock        ), // (output)
    .m_axi4_awcache                 (m01_dcv_axi4_awcache       ), // (output)
    .m_axi4_awprot                  (m01_dcv_axi4_awprot        ), // (output)
    .m_axi4_awqos                   (m01_dcv_axi4_awqos         ), // (output)// (input )
    .m_axi4_awvalid                 (m01_dcv_axi4_awvalid       ), // (output)
    .m_axi4_awready                 (m01_dcv_axi4_awready       ), // (input )

    .m_axi4_wdata                   (m01_dcv_axi4_wdata         ), // (output)
    .m_axi4_wstrob                  (m01_dcv_axi4_wstrob        ), // (output)
    .m_axi4_wlast                   (m01_dcv_axi4_wlast         ), // (output)
    .m_axi4_wvalid                  (m01_dcv_axi4_wvalid        ), // (output)
    .m_axi4_wready                  (m01_dcv_axi4_wready        ), // (input )
    .m_axi4_bid                     (m01_dcv_axi4_bid           ), // (input )
    .m_axi4_bresp                   (m01_dcv_axi4_bresp         ), // (input )
    .m_axi4_bvalid                  (m01_dcv_axi4_bvalid        ), // (input )
    .m_axi4_bready                  (m01_dcv_axi4_bready        )  // (output)
);
assign m02_cbr_axi4_arid = m_cbr_axi4_arid[ 2* 4+: 4];
assign m02_cbr_axi4_araddr = m_cbr_axi4_araddr[ 2*32+:32]; 
assign m02_cbr_axi4_arlen = m_cbr_axi4_arlen[ 2*8+:8]; 
assign m02_cbr_axi4_arsize = m_cbr_axi4_arsize[ 2*3+:3];
assign m02_cbr_axi4_arburst = m_cbr_axi4_arburst[ 2*2+:2];
assign m02_cbr_axi4_arregion = m_cbr_axi4_arregion[ 2*4+:4];
assign m02_cbr_axi4_arlock = m_cbr_axi4_arlock[ 2];
assign m02_cbr_axi4_arcache = m_cbr_axi4_arcache[ 2*4+:4];
assign m02_cbr_axi4_arprot = m_cbr_axi4_arprot[ 2*3+:3];
assign m02_cbr_axi4_arqos = m_cbr_axi4_arqos[ 2*4+:4];
assign m02_cbr_axi4_arvalid = m_cbr_axi4_arvalid[ 2];
assign m_cbr_axi4_arready[ 2] = m02_cbr_axi4_arready;

assign m_cbr_axi4_rid[ 2* 4+: 4] = m02_cbr_axi4_rid;
assign m_cbr_axi4_rdata[ 2*128+:128] = m02_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[ 2*2+:2] = m02_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[ 2] = m02_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[ 2] = m02_cbr_axi4_rvalid;
assign m02_cbr_axi4_rready = m_cbr_axi4_rready[ 2];

assign m02_cbr_axi4_awid = m_cbr_axi4_awid[ 2* 4+: 4];
assign m02_cbr_axi4_awaddr = m_cbr_axi4_awaddr[ 2*32+:32]; 
assign m02_cbr_axi4_awlen = m_cbr_axi4_awlen[ 2*8+:8]; 
assign m02_cbr_axi4_awsize = m_cbr_axi4_awsize[ 2*3+:3];
assign m02_cbr_axi4_awburst = m_cbr_axi4_awburst[ 2*2+:2];
assign m02_cbr_axi4_awregion = m_cbr_axi4_awregion[ 2*4+:4];
assign m02_cbr_axi4_awlock = m_cbr_axi4_awlock[ 2];
assign m02_cbr_axi4_awcache = m_cbr_axi4_awcache[ 2*4+:4];
assign m02_cbr_axi4_awprot = m_cbr_axi4_awprot[ 2*3+:3];
assign m02_cbr_axi4_awqos = m_cbr_axi4_awqos[ 2*4+:4];
assign m02_cbr_axi4_awvalid = m_cbr_axi4_awvalid[ 2];
assign m_cbr_axi4_awready[ 2] = m02_cbr_axi4_awready;

assign m02_cbr_axi4_wdata = m_cbr_axi4_wdata[ 2*128+:128];
assign m02_cbr_axi4_wstrob = m_cbr_axi4_wstrob[ 2*16+:16];
assign m02_cbr_axi4_wlast = m_cbr_axi4_wlast[ 2];
assign m02_cbr_axi4_wvalid = m_cbr_axi4_wvalid[ 2];
assign m_cbr_axi4_wready[ 2] = m02_cbr_axi4_wready;

assign m_cbr_axi4_bid[ 2* 4+: 4] = m02_cbr_axi4_bid;
assign m_cbr_axi4_bresp[ 2*2+:2] = m02_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[ 2] = m02_cbr_axi4_bvalid;
assign m02_cbr_axi4_bready = m_cbr_axi4_bready[ 2];
axi_interconnect_width_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_SDATA                    (128                         ), 
    .WIDTH_MDATA                    (32                          ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .NUM_OUTSTANDING                (16                          ), 
    .U_DLY                          (U_DLY                      ) 
)
u02m_axi_interconnect_width_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m02_cbr_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m02_cbr_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m02_cbr_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m02_cbr_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m02_cbr_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m02_cbr_axi4_arregion      ), // (input )
    .s_axi4_arlock                  (m02_cbr_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m02_cbr_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m02_cbr_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m02_cbr_axi4_arqos         ), // (input )
    .s_axi4_arvalid                 (m02_cbr_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m02_cbr_axi4_arready       ), // (output)

    .s_axi4_rid                     (m02_cbr_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m02_cbr_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m02_cbr_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m02_cbr_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m02_cbr_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m02_cbr_axi4_rready        ), // (input )

    .s_axi4_awid                    (m02_cbr_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m02_cbr_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m02_cbr_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m02_cbr_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m02_cbr_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m02_cbr_axi4_awregion      ), // (input )
    .s_axi4_awlock                  (m02_cbr_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m02_cbr_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m02_cbr_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m02_cbr_axi4_awqos         ), // (input )
    .s_axi4_awvalid                 (m02_cbr_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m02_cbr_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m02_cbr_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m02_cbr_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m02_cbr_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m02_cbr_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m02_cbr_axi4_wready        ), // (output)

    .s_axi4_bid                     (m02_cbr_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m02_cbr_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m02_cbr_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m02_cbr_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m02_dcv_axi4_arid          ), // (output)
    .m_axi4_araddr                  (m02_dcv_axi4_araddr        ), // (output)
    .m_axi4_arlen                   (m02_dcv_axi4_arlen         ), // (output)
    .m_axi4_arsize                  (m02_dcv_axi4_arsize        ), // (output)
    .m_axi4_arburst                 (m02_dcv_axi4_arburst       ), // (output)
    .m_axi4_arregion                (m02_dcv_axi4_arregion      ), // (output)
    .m_axi4_arlock                  (m02_dcv_axi4_arlock        ), // (output)
    .m_axi4_arcache                 (m02_dcv_axi4_arcache       ), // (output)
    .m_axi4_arprot                  (m02_dcv_axi4_arprot        ), // (output)
    .m_axi4_arqos                   (m02_dcv_axi4_arqos         ), // (output)
    .m_axi4_arvalid                 (m02_dcv_axi4_arvalid       ), // (output)
    .m_axi4_arready                 (m02_dcv_axi4_arready       ), // (input )

    .m_axi4_rid                     (m02_dcv_axi4_rid           ), // (input )
    .m_axi4_rdata                   (m02_dcv_axi4_rdata         ), // (input )
    .m_axi4_rresp                   (m02_dcv_axi4_rresp         ), // (input )
    .m_axi4_rlast                   (m02_dcv_axi4_rlast         ), // (input )
    .m_axi4_rvalid                  (m02_dcv_axi4_rvalid        ), // (input )
    .m_axi4_rready                  (m02_dcv_axi4_rready        ), // (output)
    .m_axi4_awid                    (m02_dcv_axi4_awid          ), // (output)
    .m_axi4_awaddr                  (m02_dcv_axi4_awaddr        ), // (output)
    .m_axi4_awlen                   (m02_dcv_axi4_awlen         ), // (output)
    .m_axi4_awsize                  (m02_dcv_axi4_awsize        ), // (output)
    .m_axi4_awburst                 (m02_dcv_axi4_awburst       ), // (output)
    .m_axi4_awregion                (m02_dcv_axi4_awregion      ), // (output)
    .m_axi4_awlock                  (m02_dcv_axi4_awlock        ), // (output)
    .m_axi4_awcache                 (m02_dcv_axi4_awcache       ), // (output)
    .m_axi4_awprot                  (m02_dcv_axi4_awprot        ), // (output)
    .m_axi4_awqos                   (m02_dcv_axi4_awqos         ), // (output)// (input )
    .m_axi4_awvalid                 (m02_dcv_axi4_awvalid       ), // (output)
    .m_axi4_awready                 (m02_dcv_axi4_awready       ), // (input )

    .m_axi4_wdata                   (m02_dcv_axi4_wdata         ), // (output)
    .m_axi4_wstrob                  (m02_dcv_axi4_wstrob        ), // (output)
    .m_axi4_wlast                   (m02_dcv_axi4_wlast         ), // (output)
    .m_axi4_wvalid                  (m02_dcv_axi4_wvalid        ), // (output)
    .m_axi4_wready                  (m02_dcv_axi4_wready        ), // (input )
    .m_axi4_bid                     (m02_dcv_axi4_bid           ), // (input )
    .m_axi4_bresp                   (m02_dcv_axi4_bresp         ), // (input )
    .m_axi4_bvalid                  (m02_dcv_axi4_bvalid        ), // (input )
    .m_axi4_bready                  (m02_dcv_axi4_bready        )  // (output)
);
assign m03_cbr_axi4_arid = m_cbr_axi4_arid[ 3* 4+: 4];
assign m03_cbr_axi4_araddr = m_cbr_axi4_araddr[ 3*32+:32]; 
assign m03_cbr_axi4_arlen = m_cbr_axi4_arlen[ 3*8+:8]; 
assign m03_cbr_axi4_arsize = m_cbr_axi4_arsize[ 3*3+:3];
assign m03_cbr_axi4_arburst = m_cbr_axi4_arburst[ 3*2+:2];
assign m03_cbr_axi4_arregion = m_cbr_axi4_arregion[ 3*4+:4];
assign m03_cbr_axi4_arlock = m_cbr_axi4_arlock[ 3];
assign m03_cbr_axi4_arcache = m_cbr_axi4_arcache[ 3*4+:4];
assign m03_cbr_axi4_arprot = m_cbr_axi4_arprot[ 3*3+:3];
assign m03_cbr_axi4_arqos = m_cbr_axi4_arqos[ 3*4+:4];
assign m03_cbr_axi4_arvalid = m_cbr_axi4_arvalid[ 3];
assign m_cbr_axi4_arready[ 3] = m03_cbr_axi4_arready;

assign m_cbr_axi4_rid[ 3* 4+: 4] = m03_cbr_axi4_rid;
assign m_cbr_axi4_rdata[ 3*128+:128] = m03_cbr_axi4_rdata;
assign m_cbr_axi4_rresp[ 3*2+:2] = m03_cbr_axi4_rresp;
assign m_cbr_axi4_rlast[ 3] = m03_cbr_axi4_rlast;
assign m_cbr_axi4_rvalid[ 3] = m03_cbr_axi4_rvalid;
assign m03_cbr_axi4_rready = m_cbr_axi4_rready[ 3];

assign m03_cbr_axi4_awid = m_cbr_axi4_awid[ 3* 4+: 4];
assign m03_cbr_axi4_awaddr = m_cbr_axi4_awaddr[ 3*32+:32]; 
assign m03_cbr_axi4_awlen = m_cbr_axi4_awlen[ 3*8+:8]; 
assign m03_cbr_axi4_awsize = m_cbr_axi4_awsize[ 3*3+:3];
assign m03_cbr_axi4_awburst = m_cbr_axi4_awburst[ 3*2+:2];
assign m03_cbr_axi4_awregion = m_cbr_axi4_awregion[ 3*4+:4];
assign m03_cbr_axi4_awlock = m_cbr_axi4_awlock[ 3];
assign m03_cbr_axi4_awcache = m_cbr_axi4_awcache[ 3*4+:4];
assign m03_cbr_axi4_awprot = m_cbr_axi4_awprot[ 3*3+:3];
assign m03_cbr_axi4_awqos = m_cbr_axi4_awqos[ 3*4+:4];
assign m03_cbr_axi4_awvalid = m_cbr_axi4_awvalid[ 3];
assign m_cbr_axi4_awready[ 3] = m03_cbr_axi4_awready;

assign m03_cbr_axi4_wdata = m_cbr_axi4_wdata[ 3*128+:128];
assign m03_cbr_axi4_wstrob = m_cbr_axi4_wstrob[ 3*16+:16];
assign m03_cbr_axi4_wlast = m_cbr_axi4_wlast[ 3];
assign m03_cbr_axi4_wvalid = m_cbr_axi4_wvalid[ 3];
assign m_cbr_axi4_wready[ 3] = m03_cbr_axi4_wready;

assign m_cbr_axi4_bid[ 3* 4+: 4] = m03_cbr_axi4_bid;
assign m_cbr_axi4_bresp[ 3*2+:2] = m03_cbr_axi4_bresp;
assign m_cbr_axi4_bvalid[ 3] = m03_cbr_axi4_bvalid;
assign m03_cbr_axi4_bready = m_cbr_axi4_bready[ 3];
assign m03_dcv_axi4_arid = m03_cbr_axi4_arid;
assign m03_dcv_axi4_araddr = m03_cbr_axi4_araddr;
assign m03_dcv_axi4_arlen = m03_cbr_axi4_arlen;
assign m03_dcv_axi4_arsize = m03_cbr_axi4_arsize;
assign m03_dcv_axi4_arburst = m03_cbr_axi4_arburst;
assign m03_dcv_axi4_arregion = m03_cbr_axi4_arregion;
assign m03_dcv_axi4_arlock = m03_cbr_axi4_arlock;
assign m03_dcv_axi4_arcache = m03_cbr_axi4_arcache;
assign m03_dcv_axi4_arprot = m03_cbr_axi4_arprot;
assign m03_dcv_axi4_arqos = m03_cbr_axi4_arqos;
assign m03_dcv_axi4_arvalid = m03_cbr_axi4_arvalid;
assign m03_cbr_axi4_arready = m03_dcv_axi4_arready;

assign m03_cbr_axi4_rid = m03_dcv_axi4_rid;
assign m03_cbr_axi4_rdata = m03_dcv_axi4_rdata;
assign m03_cbr_axi4_rresp = m03_dcv_axi4_rresp;
assign m03_cbr_axi4_rlast = m03_dcv_axi4_rlast;
assign m03_cbr_axi4_rvalid = m03_dcv_axi4_rvalid;
assign m03_dcv_axi4_rready = m03_cbr_axi4_rready;

assign m03_dcv_axi4_awid= m03_cbr_axi4_awid;
assign m03_dcv_axi4_awaddr = m03_cbr_axi4_awaddr;
assign m03_dcv_axi4_awlen = m03_cbr_axi4_awlen;
assign m03_dcv_axi4_awsize = m03_cbr_axi4_awsize;
assign m03_dcv_axi4_awburst = m03_cbr_axi4_awburst;
assign m03_dcv_axi4_awregion = m03_cbr_axi4_awregion;
assign m03_dcv_axi4_awlock = m03_cbr_axi4_awlock;
assign m03_dcv_axi4_awcache = m03_cbr_axi4_awcache;
assign m03_dcv_axi4_awprot = m03_cbr_axi4_awprot;
assign m03_dcv_axi4_awqos = m03_cbr_axi4_awqos;
assign m03_dcv_axi4_awvalid = m03_cbr_axi4_awvalid;
assign m03_cbr_axi4_awready = m03_dcv_axi4_awready;

assign m03_dcv_axi4_wdata = m03_cbr_axi4_wdata;
assign m03_dcv_axi4_wstrob = m03_cbr_axi4_wstrob;
assign m03_dcv_axi4_wlast = m03_cbr_axi4_wlast;
assign m03_dcv_axi4_wvalid = m03_cbr_axi4_wvalid;
assign m03_cbr_axi4_wready = m03_dcv_axi4_wready;

assign m03_cbr_axi4_bid = m03_dcv_axi4_bid;
assign m03_cbr_axi4_bresp = m03_dcv_axi4_bresp;
assign m03_cbr_axi4_bvalid = m03_dcv_axi4_bvalid;
assign m03_dcv_axi4_bready = m03_cbr_axi4_bready;
axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (128                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .HAS_LOCK                       (1                           ), 
    .HAS_CACHE                      (1                           ), 
    .HAS_PROT                       (1                           ), 
    .HAS_QOS                        (1                           ), 
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
    .s_axi4_arlock                  (m00_dcv_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m00_dcv_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m00_dcv_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m00_dcv_axi4_arqos         ), // (input )
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
    .s_axi4_awlock                  (m00_dcv_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m00_dcv_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m00_dcv_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m00_dcv_axi4_awqos         ), // (input )
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
    .m_axi4_arlock                  (m00_axi4_arlock            ), // (output)
    .m_axi4_arcache                 (m00_axi4_arcache           ), // (output)
    .m_axi4_arprot                  (m00_axi4_arprot            ), // (output)
    .m_axi4_arqos                   (m00_axi4_arqos             ), // (output)
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
    .m_axi4_awlock                  (m00_axi4_awlock            ), // (output)
    .m_axi4_awcache                 (m00_axi4_awcache           ), // (output)
    .m_axi4_awprot                  (m00_axi4_awprot            ), // (output)
    .m_axi4_awqos                   (m00_axi4_awqos             ), // (output)
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
axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (32                          ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .HAS_LOCK                       (1                           ), 
    .HAS_CACHE                      (1                           ), 
    .HAS_PROT                       (1                           ), 
    .HAS_QOS                        (1                           ), 
    .HAS_REGION                     (1                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u01m_axi_interconnect_clock_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_s                          (clk_sys                    ),  // (input ) 
    .clk_m                          (m01_axi4_clk               ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m01_dcv_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m01_dcv_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m01_dcv_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m01_dcv_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m01_dcv_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m01_dcv_axi4_arregion      ), // (input )
    .s_axi4_arlock                  (m01_dcv_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m01_dcv_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m01_dcv_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m01_dcv_axi4_arqos         ), // (input )
    .s_axi4_arvalid                 (m01_dcv_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m01_dcv_axi4_arready       ), // (output)

    .s_axi4_rid                     (m01_dcv_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m01_dcv_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m01_dcv_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m01_dcv_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m01_dcv_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m01_dcv_axi4_rready        ), // (input )

    .s_axi4_awid                    (m01_dcv_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m01_dcv_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m01_dcv_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m01_dcv_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m01_dcv_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m01_dcv_axi4_awregion      ), // (input )
    .s_axi4_awlock                  (m01_dcv_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m01_dcv_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m01_dcv_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m01_dcv_axi4_awqos         ), // (input )
    .s_axi4_awvalid                 (m01_dcv_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m01_dcv_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m01_dcv_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m01_dcv_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m01_dcv_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m01_dcv_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m01_dcv_axi4_wready        ), // (output)

    .s_axi4_bid                     (m01_dcv_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m01_dcv_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m01_dcv_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m01_dcv_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m01_axi4_arid              ), // (output)
    .m_axi4_araddr                  (m01_axi4_araddr            ), // (output)
    .m_axi4_arlen                   (m01_axi4_arlen             ), // (output)
    .m_axi4_arsize                  (m01_axi4_arsize            ), // (output)
    .m_axi4_arburst                 (m01_axi4_arburst           ), // (output)
    .m_axi4_arregion                (m01_axi4_arregion          ), // (output)
    .m_axi4_arlock                  (m01_axi4_arlock            ), // (output)
    .m_axi4_arcache                 (m01_axi4_arcache           ), // (output)
    .m_axi4_arprot                  (m01_axi4_arprot            ), // (output)
    .m_axi4_arqos                   (m01_axi4_arqos             ), // (output)
    .m_axi4_arvalid                 (m01_axi4_arvalid           ), // (output)
    .m_axi4_arready                 (m01_axi4_arready           ), // (input )

    .m_axi4_rid                     (m01_axi4_rid               ), // (input )
    .m_axi4_rdata                   (m01_axi4_rdata             ), // (input )
    .m_axi4_rresp                   (m01_axi4_rresp             ), // (input )
    .m_axi4_rlast                   (m01_axi4_rlast             ), // (input )
    .m_axi4_rvalid                  (m01_axi4_rvalid            ), // (input )
    .m_axi4_rready                  (m01_axi4_rready            ), // (output)
    .m_axi4_awid                    (m01_axi4_awid              ), // (output)
    .m_axi4_awaddr                  (m01_axi4_awaddr            ), // (output)
    .m_axi4_awlen                   (m01_axi4_awlen             ), // (output)
    .m_axi4_awsize                  (m01_axi4_awsize            ), // (output)
    .m_axi4_awburst                 (m01_axi4_awburst           ), // (output)
    .m_axi4_awregion                (m01_axi4_awregion          ), // (output)
    .m_axi4_awlock                  (m01_axi4_awlock            ), // (output)
    .m_axi4_awcache                 (m01_axi4_awcache           ), // (output)
    .m_axi4_awprot                  (m01_axi4_awprot            ), // (output)
    .m_axi4_awqos                   (m01_axi4_awqos             ), // (output)
    .m_axi4_awvalid                 (m01_axi4_awvalid           ), // (output)
    .m_axi4_awready                 (m01_axi4_awready           ), // (input )

    .m_axi4_wdata                   (m01_axi4_wdata             ), // (output)
    .m_axi4_wstrob                  (m01_axi4_wstrob            ), // (output)
    .m_axi4_wlast                   (m01_axi4_wlast             ), // (output)
    .m_axi4_wvalid                  (m01_axi4_wvalid            ), // (output)
    .m_axi4_wready                  (m01_axi4_wready            ), // (input )
    .m_axi4_bid                     (m01_axi4_bid               ), // (input )
    .m_axi4_bresp                   (m01_axi4_bresp             ), // (input )
    .m_axi4_bvalid                  (m01_axi4_bvalid            ), // (input )
    .m_axi4_bready                  (m01_axi4_bready            )  // (output)
);
axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (32                          ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .HAS_LOCK                       (1                           ), 
    .HAS_CACHE                      (1                           ), 
    .HAS_PROT                       (1                           ), 
    .HAS_QOS                        (1                           ), 
    .HAS_REGION                     (1                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u02m_axi_interconnect_clock_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_s                          (clk_sys                    ),  // (input ) 
    .clk_m                          (m02_axi4_clk               ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m02_dcv_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m02_dcv_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m02_dcv_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m02_dcv_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m02_dcv_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m02_dcv_axi4_arregion      ), // (input )
    .s_axi4_arlock                  (m02_dcv_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m02_dcv_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m02_dcv_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m02_dcv_axi4_arqos         ), // (input )
    .s_axi4_arvalid                 (m02_dcv_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m02_dcv_axi4_arready       ), // (output)

    .s_axi4_rid                     (m02_dcv_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m02_dcv_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m02_dcv_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m02_dcv_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m02_dcv_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m02_dcv_axi4_rready        ), // (input )

    .s_axi4_awid                    (m02_dcv_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m02_dcv_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m02_dcv_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m02_dcv_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m02_dcv_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m02_dcv_axi4_awregion      ), // (input )
    .s_axi4_awlock                  (m02_dcv_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m02_dcv_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m02_dcv_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m02_dcv_axi4_awqos         ), // (input )
    .s_axi4_awvalid                 (m02_dcv_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m02_dcv_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m02_dcv_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m02_dcv_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m02_dcv_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m02_dcv_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m02_dcv_axi4_wready        ), // (output)

    .s_axi4_bid                     (m02_dcv_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m02_dcv_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m02_dcv_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m02_dcv_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m02_axi4_arid              ), // (output)
    .m_axi4_araddr                  (m02_axi4_araddr            ), // (output)
    .m_axi4_arlen                   (m02_axi4_arlen             ), // (output)
    .m_axi4_arsize                  (m02_axi4_arsize            ), // (output)
    .m_axi4_arburst                 (m02_axi4_arburst           ), // (output)
    .m_axi4_arregion                (m02_axi4_arregion          ), // (output)
    .m_axi4_arlock                  (m02_axi4_arlock            ), // (output)
    .m_axi4_arcache                 (m02_axi4_arcache           ), // (output)
    .m_axi4_arprot                  (m02_axi4_arprot            ), // (output)
    .m_axi4_arqos                   (m02_axi4_arqos             ), // (output)
    .m_axi4_arvalid                 (m02_axi4_arvalid           ), // (output)
    .m_axi4_arready                 (m02_axi4_arready           ), // (input )

    .m_axi4_rid                     (m02_axi4_rid               ), // (input )
    .m_axi4_rdata                   (m02_axi4_rdata             ), // (input )
    .m_axi4_rresp                   (m02_axi4_rresp             ), // (input )
    .m_axi4_rlast                   (m02_axi4_rlast             ), // (input )
    .m_axi4_rvalid                  (m02_axi4_rvalid            ), // (input )
    .m_axi4_rready                  (m02_axi4_rready            ), // (output)
    .m_axi4_awid                    (m02_axi4_awid              ), // (output)
    .m_axi4_awaddr                  (m02_axi4_awaddr            ), // (output)
    .m_axi4_awlen                   (m02_axi4_awlen             ), // (output)
    .m_axi4_awsize                  (m02_axi4_awsize            ), // (output)
    .m_axi4_awburst                 (m02_axi4_awburst           ), // (output)
    .m_axi4_awregion                (m02_axi4_awregion          ), // (output)
    .m_axi4_awlock                  (m02_axi4_awlock            ), // (output)
    .m_axi4_awcache                 (m02_axi4_awcache           ), // (output)
    .m_axi4_awprot                  (m02_axi4_awprot            ), // (output)
    .m_axi4_awqos                   (m02_axi4_awqos             ), // (output)
    .m_axi4_awvalid                 (m02_axi4_awvalid           ), // (output)
    .m_axi4_awready                 (m02_axi4_awready           ), // (input )

    .m_axi4_wdata                   (m02_axi4_wdata             ), // (output)
    .m_axi4_wstrob                  (m02_axi4_wstrob            ), // (output)
    .m_axi4_wlast                   (m02_axi4_wlast             ), // (output)
    .m_axi4_wvalid                  (m02_axi4_wvalid            ), // (output)
    .m_axi4_wready                  (m02_axi4_wready            ), // (input )
    .m_axi4_bid                     (m02_axi4_bid               ), // (input )
    .m_axi4_bresp                   (m02_axi4_bresp             ), // (input )
    .m_axi4_bvalid                  (m02_axi4_bvalid            ), // (input )
    .m_axi4_bready                  (m02_axi4_bready            )  // (output)
);
axi_interconnect_clock_convert #
(
    .WIDTH_ID                       (4                           ), 
    .WIDTH_ADDR                     (32                          ), 
    .WIDTH_DATA                     (128                         ), 
    .WIDTH_AWUSER                   (0                           ), 
    .WIDTH_ARUSER                   (0                           ), 
    .WIDTH_WUSER                    (0                           ), 
    .WIDTH_RUSER                    (0                           ), 
    .WIDTH_BUSER                    (0                           ), 
    .HAS_LOCK                       (1                           ), 
    .HAS_CACHE                      (1                           ), 
    .HAS_PROT                       (1                           ), 
    .HAS_QOS                        (1                           ), 
    .HAS_REGION                     (1                           ), 
    .U_DLY                          (U_DLY                      ) 
)
u03m_axi_interconnect_clock_convert
(
// ---------------------------------------------------------------------------------
// Clock & Reset 
// ---------------------------------------------------------------------------------
    .clk_s                          (clk_sys                    ),  // (input ) 
    .clk_m                          (m03_axi4_clk               ), // (input ) 
    .rst_n                          (rst_n                      ), // (input ) 
// ---------------------------------------------------------------------------------
// Slave AXI4 
// ---------------------------------------------------------------------------------
    .s_axi4_arid                    (m03_dcv_axi4_arid          ), // (input )
    .s_axi4_araddr                  (m03_dcv_axi4_araddr        ), // (input )
    .s_axi4_arlen                   (m03_dcv_axi4_arlen         ), // (input )
    .s_axi4_arsize                  (m03_dcv_axi4_arsize        ), // (input )
    .s_axi4_arburst                 (m03_dcv_axi4_arburst       ), // (input )
    .s_axi4_arregion                (m03_dcv_axi4_arregion      ), // (input )
    .s_axi4_arlock                  (m03_dcv_axi4_arlock        ), // (input )
    .s_axi4_arcache                 (m03_dcv_axi4_arcache       ), // (input )
    .s_axi4_arprot                  (m03_dcv_axi4_arprot        ), // (input )
    .s_axi4_arqos                   (m03_dcv_axi4_arqos         ), // (input )
    .s_axi4_arvalid                 (m03_dcv_axi4_arvalid       ), // (input )
    .s_axi4_arready                 (m03_dcv_axi4_arready       ), // (output)

    .s_axi4_rid                     (m03_dcv_axi4_rid           ), // (output)
    .s_axi4_rdata                   (m03_dcv_axi4_rdata         ), // (output)
    .s_axi4_rresp                   (m03_dcv_axi4_rresp         ), // (output)
    .s_axi4_rlast                   (m03_dcv_axi4_rlast         ), // (output)
    .s_axi4_rvalid                  (m03_dcv_axi4_rvalid        ), // (output)
    .s_axi4_rready                  (m03_dcv_axi4_rready        ), // (input )

    .s_axi4_awid                    (m03_dcv_axi4_awid          ), // (input )
    .s_axi4_awaddr                  (m03_dcv_axi4_awaddr        ), // (input )
    .s_axi4_awlen                   (m03_dcv_axi4_awlen         ), // (input )
    .s_axi4_awsize                  (m03_dcv_axi4_awsize        ), // (input )
    .s_axi4_awburst                 (m03_dcv_axi4_awburst       ), // (input )
    .s_axi4_awregion                (m03_dcv_axi4_awregion      ), // (input )
    .s_axi4_awlock                  (m03_dcv_axi4_awlock        ), // (input )
    .s_axi4_awcache                 (m03_dcv_axi4_awcache       ), // (input )
    .s_axi4_awprot                  (m03_dcv_axi4_awprot        ), // (input )
    .s_axi4_awqos                   (m03_dcv_axi4_awqos         ), // (input )
    .s_axi4_awvalid                 (m03_dcv_axi4_awvalid       ), // (input )
    .s_axi4_awready                 (m03_dcv_axi4_awready       ), // (output)

    .s_axi4_wdata                   (m03_dcv_axi4_wdata         ), // (input )
    .s_axi4_wstrob                  (m03_dcv_axi4_wstrob        ), // (input )
    .s_axi4_wlast                   (m03_dcv_axi4_wlast         ), // (input )
    .s_axi4_wvalid                  (m03_dcv_axi4_wvalid        ), // (input )
    .s_axi4_wready                  (m03_dcv_axi4_wready        ), // (output)

    .s_axi4_bid                     (m03_dcv_axi4_bid           ), // (output)
    .s_axi4_bresp                   (m03_dcv_axi4_bresp         ), // (output)
    .s_axi4_bvalid                  (m03_dcv_axi4_bvalid        ), // (output)
    .s_axi4_bready                  (m03_dcv_axi4_bready        ), // (input )
// ---------------------------------------------------------------------------------
// Master AXI4 
// ---------------------------------------------------------------------------------
    .m_axi4_arid                    (m03_axi4_arid              ), // (output)
    .m_axi4_araddr                  (m03_axi4_araddr            ), // (output)
    .m_axi4_arlen                   (m03_axi4_arlen             ), // (output)
    .m_axi4_arsize                  (m03_axi4_arsize            ), // (output)
    .m_axi4_arburst                 (m03_axi4_arburst           ), // (output)
    .m_axi4_arregion                (m03_axi4_arregion          ), // (output)
    .m_axi4_arlock                  (m03_axi4_arlock            ), // (output)
    .m_axi4_arcache                 (m03_axi4_arcache           ), // (output)
    .m_axi4_arprot                  (m03_axi4_arprot            ), // (output)
    .m_axi4_arqos                   (m03_axi4_arqos             ), // (output)
    .m_axi4_arvalid                 (m03_axi4_arvalid           ), // (output)
    .m_axi4_arready                 (m03_axi4_arready           ), // (input )

    .m_axi4_rid                     (m03_axi4_rid               ), // (input )
    .m_axi4_rdata                   (m03_axi4_rdata             ), // (input )
    .m_axi4_rresp                   (m03_axi4_rresp             ), // (input )
    .m_axi4_rlast                   (m03_axi4_rlast             ), // (input )
    .m_axi4_rvalid                  (m03_axi4_rvalid            ), // (input )
    .m_axi4_rready                  (m03_axi4_rready            ), // (output)
    .m_axi4_awid                    (m03_axi4_awid              ), // (output)
    .m_axi4_awaddr                  (m03_axi4_awaddr            ), // (output)
    .m_axi4_awlen                   (m03_axi4_awlen             ), // (output)
    .m_axi4_awsize                  (m03_axi4_awsize            ), // (output)
    .m_axi4_awburst                 (m03_axi4_awburst           ), // (output)
    .m_axi4_awregion                (m03_axi4_awregion          ), // (output)
    .m_axi4_awlock                  (m03_axi4_awlock            ), // (output)
    .m_axi4_awcache                 (m03_axi4_awcache           ), // (output)
    .m_axi4_awprot                  (m03_axi4_awprot            ), // (output)
    .m_axi4_awqos                   (m03_axi4_awqos             ), // (output)
    .m_axi4_awvalid                 (m03_axi4_awvalid           ), // (output)
    .m_axi4_awready                 (m03_axi4_awready           ), // (input )

    .m_axi4_wdata                   (m03_axi4_wdata             ), // (output)
    .m_axi4_wstrob                  (m03_axi4_wstrob            ), // (output)
    .m_axi4_wlast                   (m03_axi4_wlast             ), // (output)
    .m_axi4_wvalid                  (m03_axi4_wvalid            ), // (output)
    .m_axi4_wready                  (m03_axi4_wready            ), // (input )
    .m_axi4_bid                     (m03_axi4_bid               ), // (input )
    .m_axi4_bresp                   (m03_axi4_bresp             ), // (input )
    .m_axi4_bvalid                  (m03_axi4_bvalid            ), // (input )
    .m_axi4_bready                  (m03_axi4_bready            )  // (output)
);


endmodule

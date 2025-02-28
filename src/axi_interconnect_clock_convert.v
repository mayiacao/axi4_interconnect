// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/14 10:27:03
// File Name    : axi_interconnect_clock_convert.v
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
// axi_interconnect_clock_convert
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_clock_convert #
(
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDR          = 32    ,
    parameter                           WIDTH_DATA          = 32    ,
    parameter                           WIDTH_AWUSER        = 1     ,
    parameter                           WIDTH_ARUSER        = 1     ,
    parameter                           WIDTH_WUSER         = 1     ,
    parameter                           WIDTH_RUSER         = 1     ,
    parameter                           WIDTH_BUSER         = 1     ,
    parameter                           HAS_LOCK            = 'd1   ,
    parameter                           HAS_CACHE           = 'd1   ,
    parameter                           HAS_PROT            = 'd1   ,
    parameter                           HAS_QOS             = 'd1   ,
    parameter                           HAS_REGION          = 'd1   ,

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
    input                               clk_s                       , 
    input                               clk_m                       , 
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
    output             [WIDTH_DATA-1:0] s_axi4_rdata                , 
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

    input                    [W_ID-1:0] s_axi4_wid                  , 
    input              [WIDTH_DATA-1:0] s_axi4_wdata                , 
    input            [WIDTH_DATA/8-1:0] s_axi4_wstrob               , 
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
    input              [WIDTH_DATA-1:0] m_axi4_rdata                , 
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

    output                   [W_ID-1:0] m_axi4_wid                  , 
    output             [WIDTH_DATA-1:0] m_axi4_wdata                , 
    output           [WIDTH_DATA/8-1:0] m_axi4_wstrob               , 
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

localparam WIDTH_ADDRINFO  = WIDTH_ADDR+WIDTH_ID+WIDTH_AWUSER+
                             8+3+2+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                             HAS_QOS*4+HAS_REGION*4;

localparam WIDTH_WDATAINFO = WIDTH_DATA+WIDTH_ID+WIDTH_WUSER+
                             WIDTH_DATA/8+1;

localparam WIDTH_BRESPINFO = WIDTH_ID+2+WIDTH_BUSER;

localparam WIDTH_RRESPINFO = WIDTH_ID+2+1+WIDTH_RUSER+WIDTH_DATA;

wire                                    awfifo_full                 ; 
wire                                    awfifo_empty                ; 
wire               [WIDTH_ADDRINFO-1:0] s_waddr_info                ; 
wire               [WIDTH_ADDRINFO-1:0] m_waddr_info                ; 
wire                                    wfifo_full                  ; 
wire                                    wfifo_empty                 ; 
wire              [WIDTH_WDATAINFO-1:0] s_wdata_info                ; 
wire              [WIDTH_WDATAINFO-1:0] m_wdata_info                ; 
wire                                    bfifo_full                  ; 
wire                                    bfifo_empty                 ; 
wire              [WIDTH_BRESPINFO-1:0] s_bresp_info                ; 
wire              [WIDTH_BRESPINFO-1:0] m_bresp_info                ; 
wire                                    arfifo_full                 ; 
wire                                    arfifo_empty                ; 
wire               [WIDTH_ADDRINFO-1:0] s_raddr_info                ; 
wire               [WIDTH_ADDRINFO-1:0] m_raddr_info                ; 
wire                                    rfifo_full                  ; 
wire                                    rfifo_empty                 ; 
wire              [WIDTH_RRESPINFO-1:0] s_rresp_info                ; 
wire              [WIDTH_RRESPINFO-1:0] m_rresp_info                ; 


assign s_axi4_awready = ~awfifo_full;
assign m_axi4_awvalid = ~awfifo_empty;
assign s_axi4_wready = ~wfifo_full;
assign m_axi4_wvalid = ~wfifo_empty;
assign m_axi4_bready = ~bfifo_full;
assign s_axi4_bvalid = ~bfifo_empty;
assign s_axi4_arready = ~arfifo_full;
assign m_axi4_arvalid = ~arfifo_empty; 
assign m_axi4_rready = ~rfifo_full;
assign s_axi4_rvalid = ~rfifo_empty;

assign s_waddr_info[WIDTH_ID+:WIDTH_ADDR] = s_axi4_awaddr;   
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR)+:8] = s_axi4_awlen;   
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8)+:3] = s_axi4_awsize;   
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3)+:2] = s_axi4_awburst; 


assign s_raddr_info[WIDTH_ID+:WIDTH_ADDR] = s_axi4_araddr;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR)+:8] = s_axi4_arlen;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8)+:3] = s_axi4_arsize;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3)+:2] = s_axi4_arburst; 

generate
if(WIDTH_ID>0) begin :has_awrid_if
assign s_waddr_info[0+:WIDTH_ID] = s_axi4_awid;
assign s_raddr_info[0+:WIDTH_ID] = s_axi4_arid;
end if(HAS_REGION==1) begin :has_region_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2)+:4] = s_axi4_awregion;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2)+:4] = s_axi4_arregion;               
end if(HAS_LOCK== 1) begin :has_lock_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1] = s_axi4_awlock;  
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1] = s_axi4_arlock;                   
end if(HAS_CACHE==1) begin:has_cache_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK)+:4] = s_axi4_awcache;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK)+:4] = s_axi4_arcache;               
end if(HAS_PROT==1) begin:has_prot_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4)+:3] = s_axi4_awprot; 
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4)+:3] = s_axi4_arprot;             
end if(HAS_QOS==1) begin:has_qos_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4] = s_axi4_awqos; 
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4] = s_axi4_arqos;                 
end if(WIDTH_AWUSER > 0) begin:has_awuser_if
assign s_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+HAS_QOS*4)+:W_AWUSER] = s_axi4_awuser;   
assign s_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+HAS_QOS*4)+:W_AWUSER] = s_axi4_aruser;                   
end


if(WIDTH_ID>0) begin :has_wid_if
assign s_wdata_info[0+:WIDTH_ID] = s_axi4_wid;
end
assign s_wdata_info[WIDTH_ID+:WIDTH_DATA] = s_axi4_wdata;
assign s_wdata_info[(WIDTH_ID+WIDTH_DATA)+:(WIDTH_DATA/8)] = s_axi4_wstrob;
if(WIDTH_WUSER > 0) begin:has_wuser_if
assign s_wdata_info[(WIDTH_ID+WIDTH_DATA+WIDTH_DATA/8)+: W_WUSER] = s_axi4_wuser;
end
assign s_wdata_info[(WIDTH_ID+WIDTH_DATA+WIDTH_DATA/8 + WIDTH_WUSER)+:1] = s_axi4_wlast;


assign s_axi4_bresp[0+:2] = s_bresp_info[0+:2];     

if(WIDTH_ID>0) begin :has_bid_if                
assign s_axi4_bid = s_bresp_info[2+:WIDTH_ID];
end else begin: no_bit_if
assign s_axi4_bid = 'd0;
end

if(WIDTH_BUSER > 0) begin:has_buser_if
assign s_axi4_buser[0+:W_BUSER] = s_bresp_info[(2+WIDTH_ID)+:W_BUSER];
end else begin: no_buser_if
assign s_axi4_buser[0+:W_BUSER] = 'd0;
end

assign s_axi4_rlast = s_rresp_info[0];
assign s_axi4_rresp = s_rresp_info[1+:2];

if(WIDTH_ID>0) begin :has_rid_if           
assign s_axi4_rid = s_rresp_info[(1+2)+:W_ID];
end else begin:no_rid_if
assign s_axi4_rid = 'd0;
end

assign s_axi4_rdata = s_rresp_info[(1+2+WIDTH_ID)+:WIDTH_DATA];

if(WIDTH_BUSER > 0) begin:has_ruser_if
assign s_axi4_ruser = s_rresp_info[(1+2+WIDTH_ID+WIDTH_DATA)+:W_RUSER];
end else begin:no_ruser_if
assign s_axi4_ruser = 'd0;
end 


if(WIDTH_ID>0) begin :has_mawrid_if
assign m_axi4_arid = m_raddr_info[0+:W_ID];
assign m_axi4_awid = m_waddr_info[0+:W_ID];
end else begin:no_mawrid_if
assign m_axi4_arid = 'd0;
assign m_axi4_awid = 'd0;
end if(HAS_REGION==1) begin :has_mregion_if
assign m_axi4_arregion = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2)+:4];      
assign m_axi4_awregion = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2)+:4];   
end else begin:no_mregion_if
assign m_axi4_arregion = 'd0;
assign m_axi4_awregion = 'd0;
end if(HAS_LOCK== 1) begin :has_mlock_if
assign m_axi4_arlock = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1];
assign m_axi4_awlock = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1];  
end else begin:no_mlock_if
assign m_axi4_arlock = 'd0;
assign m_axi4_awlock = 'd0;
end if(HAS_CACHE==1) begin:has_mcache_if
assign m_axi4_awcache = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK)+:4];   
assign m_axi4_arcache = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK)+:4];     
end else begin:no_mcache_if
assign m_axi4_awcache = 'd0;
assign m_axi4_arcache = 'd0;
end if(HAS_PROT==1) begin:has_mprot_if
assign m_axi4_awprot = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4)+:3]; 
assign m_axi4_arprot = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4)+:3];     
end else begin:no_mprot_if            
assign m_axi4_awprot = 'd0;
assign m_axi4_arprot = 'd0;
end if(HAS_QOS==1) begin:has_mqos_if
assign m_axi4_awqos = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4]; 
assign m_axi4_arqos = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4];    
end else begin:no_mqos_if         
assign m_axi4_awqos = 'd0;
assign m_axi4_arqos = 'd0;
end if(WIDTH_AWUSER > 0) begin:has_mawuser_if
assign m_axi4_awuser = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+HAS_QOS*4)+:W_AWUSER];   
assign m_axi4_aruser = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3+2+HAS_REGION*4+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+HAS_QOS*4)+:W_AWUSER];                   
end else begin:no_mawuser_if   
assign m_axi4_awuser = 'd0;
assign m_axi4_aruser = 'd0;
end

assign m_axi4_awaddr = m_waddr_info[WIDTH_ID+:WIDTH_ADDR];   
assign m_axi4_awlen = m_waddr_info[(WIDTH_ID+WIDTH_ADDR)+:8];   
assign m_axi4_awsize = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8)+:3];   
assign m_axi4_awburst = m_waddr_info[(WIDTH_ID+WIDTH_ADDR+8+3)+:2]; 

assign m_axi4_araddr = m_raddr_info[(WIDTH_ID)+:WIDTH_ADDR];   
assign m_axi4_arlen = m_raddr_info[(WIDTH_ID+WIDTH_ADDR)+:8];   
assign m_axi4_arsize = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8)+:3];   
assign m_axi4_arburst = m_raddr_info[(WIDTH_ID+WIDTH_ADDR+8+3)+:2]; 


if(WIDTH_ID>0) begin :has_mwid_if
assign m_axi4_wid = m_wdata_info[0+:W_ID];
end else begin:no_mwid_if
assign m_axi4_wid = 'd0;
end

assign m_axi4_wdata = m_wdata_info[WIDTH_ID+:WIDTH_DATA];
assign m_axi4_wstrob = m_wdata_info[(WIDTH_ID+WIDTH_DATA)+:(WIDTH_DATA/8)];
if(WIDTH_WUSER > 0) begin:has_mwuser_if
assign m_axi4_wuser = m_wdata_info[(WIDTH_ID+WIDTH_DATA+WIDTH_DATA/8)+: W_WUSER];
end else begin:no_mwuser_if
assign m_axi4_wuser = 'd0;
end

assign m_axi4_wlast = m_wdata_info[(WIDTH_ID+WIDTH_DATA+WIDTH_DATA/8 + WIDTH_WUSER)+:1];

assign m_bresp_info[0+:2] = m_axi4_bresp;     

if(WIDTH_ID>0) begin :has_mbid_if                
assign m_bresp_info[2+:W_ID] = m_axi4_bid;
end

if(WIDTH_BUSER > 0) begin:has_mbuser_if
assign m_bresp_info[(2+WIDTH_ID)+:W_BUSER] = m_axi4_buser;
end

assign m_rresp_info[0] = m_axi4_rlast;
assign m_rresp_info[1+:2] = m_axi4_rresp;

if(WIDTH_ID>0) begin :has_mrid_if           
assign m_rresp_info[(1+2)+:W_ID] = m_axi4_rid;
end

assign m_rresp_info[(1+2+WIDTH_ID)+:WIDTH_DATA] = m_axi4_rdata;

if(WIDTH_BUSER > 0) begin:has_mruser_if
assign m_rresp_info[(1+2+WIDTH_ID+WIDTH_DATA)+:W_RUSER] = m_axi4_ruser;
end 
endgenerate

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_ADDRINFO             ), // It must be a multiple of 8.
    .PA_AW                          (2                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_ADDRINFO             ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("TRUE"                     ), // 
    .PIPLI_STAGE                    (2                          ), //Must be >= 2  
    .U_DLY                          (U_DLY                      )  // 
)
u0_awfifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_s                      ), // (input )
    .clk_rd                         (clk_m                      ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (s_axi4_awvalid&&s_axi4_awready), // (input )
    .wr_data                        (s_waddr_info               ), // (input )
    .prog_data                      (3                          ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (awfifo_full                ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (m_axi4_awvalid && m_axi4_awready), // (input )
    .rd_data                        (m_waddr_info               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (awfifo_empty               ), // (output)
    .aempty                         (                           )  // (output)
);


axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_WDATAINFO            ), // It must be a multiple of 8.
    .PA_AW                          (2                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_WDATAINFO            ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("TRUE"                     ), // 
    .PIPLI_STAGE                    (2                          ), //Must be >= 2  
    .U_DLY                          (U_DLY                      )  // 
)
u0_wfifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_s                      ), // (input )
    .clk_rd                         (clk_m                      ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (s_axi4_wvalid&&s_axi4_wready), // (input )
    .wr_data                        (s_wdata_info               ), // (input )
    .prog_data                      (3                          ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (wfifo_full                 ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (m_axi4_wvalid && m_axi4_wready), // (input )
    .rd_data                        (m_wdata_info               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (wfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_BRESPINFO            ), // It must be a multiple of 8.
    .PA_AW                          (2                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_BRESPINFO            ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("TRUE"                     ), // 
    .PIPLI_STAGE                    (2                          ), //Must be >= 2  
    .U_DLY                          (U_DLY                      )  // 
)
u0_bfifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_m                      ), // (input )
    .clk_rd                         (clk_s                      ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (m_axi4_bvalid&&m_axi4_bready), // (input )
    .wr_data                        (m_bresp_info               ), // (input )
    .prog_data                      (3                          ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (bfifo_full                 ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (s_axi4_bvalid && s_axi4_bready), // (input )
    .rd_data                        (s_bresp_info               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (bfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_ADDRINFO             ), // It must be a multiple of 8.
    .PA_AW                          (2                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_ADDRINFO             ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("TRUE"                     ), // 
    .PIPLI_STAGE                    (2                          ), //Must be >= 2  
    .U_DLY                          (U_DLY                      )  // 
)
u0_arfifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_s                      ), // (input )
    .clk_rd                         (clk_m                      ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (s_axi4_arvalid&&s_axi4_arready), // (input )
    .wr_data                        (s_raddr_info               ), // (input )
    .prog_data                      (3                          ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (arfifo_full                ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (m_axi4_arvalid && m_axi4_arready), // (input )
    .rd_data                        (m_raddr_info               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (arfifo_empty               ), // (output)
    .aempty                         (                           )  // (output)
);

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_RRESPINFO            ), // It must be a multiple of 8.
    .PA_AW                          (2                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_RRESPINFO            ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("TRUE"                     ), // 
    .PIPLI_STAGE                    (2                          ), //Must be >= 2  
    .U_DLY                          (U_DLY                      )  // 
)
u0_rfifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_m                      ), // (input )
    .clk_rd                         (clk_s                      ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (m_axi4_rvalid&&m_axi4_rready), // (input )
    .wr_data                        (m_rresp_info               ), // (input )
    .prog_data                      (3                          ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (rfifo_full                 ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (s_axi4_rvalid && s_axi4_rready), // (input )
    .rd_data                        (s_rresp_info               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (rfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);



endmodule








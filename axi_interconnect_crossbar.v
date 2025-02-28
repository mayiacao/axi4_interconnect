// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/18 11:16:42
// File Name    : axi_interconnect_crossbar.v
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
// axi_interconnect_crossbar
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar #
(
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           NUM_MASTER          = 4     , // 0 ~ 4
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDR          = 32    ,
    parameter                           WIDTH_DATA          = 32    ,
    parameter                           WIDTH_AWUSER        = 1     ,
    parameter                           WIDTH_ARUSER        = 1     ,
    parameter                           WIDTH_WUSER         = 1     ,
    parameter                           WIDTH_RUSER         = 1     ,
    parameter                           WIDTH_BUSER         = 1     ,
    parameter                           NUM_OUTSTANDING     = 4     ,
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_BASE         = 'd0   , 
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_HIGH         = 'd0   ,
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
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    input          [NUM_SLAVE*W_ID-1:0] s_axi4_arid                 , 
    input    [NUM_SLAVE*WIDTH_ADDR-1:0] s_axi4_araddr               , 
    input             [NUM_SLAVE*8-1:0] s_axi4_arlen                , 
    input             [NUM_SLAVE*3-1:0] s_axi4_arsize               , 
    input             [NUM_SLAVE*2-1:0] s_axi4_arburst              , 
    input             [NUM_SLAVE*4-1:0] s_axi4_arregion             , 
    input               [NUM_SLAVE-1:0] s_axi4_arlock               , 
    input             [NUM_SLAVE*4-1:0] s_axi4_arcache              , 
    input             [NUM_SLAVE*3-1:0] s_axi4_arprot               , 
    input             [NUM_SLAVE*4-1:0] s_axi4_arqos                , 
    input      [NUM_SLAVE*W_ARUSER-1:0] s_axi4_aruser               , 
    input               [NUM_SLAVE-1:0] s_axi4_arvalid              , 
    output              [NUM_SLAVE-1:0] s_axi4_arready              , 

    output         [NUM_SLAVE*W_ID-1:0] s_axi4_rid                  , 
    output   [NUM_SLAVE*WIDTH_DATA-1:0] s_axi4_rdata                , 
    output            [NUM_SLAVE*2-1:0] s_axi4_rresp                , 
    output              [NUM_SLAVE-1:0] s_axi4_rlast                , 
    output      [NUM_SLAVE*W_RUSER-1:0] s_axi4_ruser                , 
    output              [NUM_SLAVE-1:0] s_axi4_rvalid               , 
    input               [NUM_SLAVE-1:0] s_axi4_rready               , 

    input          [NUM_SLAVE*W_ID-1:0] s_axi4_awid                 , 
    input    [NUM_SLAVE*WIDTH_ADDR-1:0] s_axi4_awaddr               , 
    input             [NUM_SLAVE*8-1:0] s_axi4_awlen                , 
    input             [NUM_SLAVE*3-1:0] s_axi4_awsize               , 
    input             [NUM_SLAVE*2-1:0] s_axi4_awburst              , 
    input             [NUM_SLAVE*4-1:0] s_axi4_awregion             , 
    input               [NUM_SLAVE-1:0] s_axi4_awlock               , 
    input             [NUM_SLAVE*4-1:0] s_axi4_awcache              , 
    input             [NUM_SLAVE*3-1:0] s_axi4_awprot               , 
    input             [NUM_SLAVE*4-1:0] s_axi4_awqos                , 
    input      [NUM_SLAVE*W_AWUSER-1:0] s_axi4_awuser               , 
    input               [NUM_SLAVE-1:0] s_axi4_awvalid              , 
    output              [NUM_SLAVE-1:0] s_axi4_awready              , 

    input          [NUM_SLAVE*W_ID-1:0] s_axi4_wid                  , 
    input    [NUM_SLAVE*WIDTH_DATA-1:0] s_axi4_wdata                , 
    input  [NUM_SLAVE*WIDTH_DATA/8-1:0] s_axi4_wstrob               , 
    input               [NUM_SLAVE-1:0] s_axi4_wlast                , 
    input       [NUM_SLAVE*W_WUSER-1:0] s_axi4_wuser                , 
    input               [NUM_SLAVE-1:0] s_axi4_wvalid               , 
    output              [NUM_SLAVE-1:0] s_axi4_wready               , 

    output         [NUM_SLAVE*W_ID-1:0] s_axi4_bid                  , 
    output            [NUM_SLAVE*2-1:0] s_axi4_bresp                , 
    output      [NUM_SLAVE*W_BUSER-1:0] s_axi4_buser                , 
    output              [NUM_SLAVE-1:0] s_axi4_bvalid               , 
    input               [NUM_SLAVE-1:0] s_axi4_bready               , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    output        [NUM_MASTER*W_ID-1:0] m_axi4_arid                 , 
    output  [NUM_MASTER*WIDTH_ADDR-1:0] m_axi4_araddr               , 
    output           [NUM_MASTER*8-1:0] m_axi4_arlen                , 
    output           [NUM_MASTER*3-1:0] m_axi4_arsize               , 
    output           [NUM_MASTER*2-1:0] m_axi4_arburst              , 
    output           [NUM_MASTER*4-1:0] m_axi4_arregion             , 
    output             [NUM_MASTER-1:0] m_axi4_arlock               , 
    output           [NUM_MASTER*4-1:0] m_axi4_arcache              , 
    output           [NUM_MASTER*3-1:0] m_axi4_arprot               , 
    output           [NUM_MASTER*4-1:0] m_axi4_arqos                , 
    output    [NUM_MASTER*W_ARUSER-1:0] m_axi4_aruser               , 
    output             [NUM_MASTER-1:0] m_axi4_arvalid              , 
    input              [NUM_MASTER-1:0] m_axi4_arready              , 

    input         [NUM_MASTER*W_ID-1:0] m_axi4_rid                  , 
    input   [NUM_MASTER*WIDTH_DATA-1:0] m_axi4_rdata                , 
    input            [NUM_MASTER*2-1:0] m_axi4_rresp                , 
    input              [NUM_MASTER-1:0] m_axi4_rlast                , 
    input      [NUM_MASTER*W_RUSER-1:0] m_axi4_ruser                , 
    input              [NUM_MASTER-1:0] m_axi4_rvalid               , 
    output             [NUM_MASTER-1:0] m_axi4_rready               , 

    output        [NUM_MASTER*W_ID-1:0] m_axi4_awid                 , 
    output  [NUM_MASTER*WIDTH_ADDR-1:0] m_axi4_awaddr               , 
    output           [NUM_MASTER*8-1:0] m_axi4_awlen                , 
    output           [NUM_MASTER*3-1:0] m_axi4_awsize               , 
    output           [NUM_MASTER*2-1:0] m_axi4_awburst              , 
    output           [NUM_MASTER*4-1:0] m_axi4_awregion             , 
    output             [NUM_MASTER-1:0] m_axi4_awlock               , 
    output           [NUM_MASTER*4-1:0] m_axi4_awcache              , 
    output           [NUM_MASTER*3-1:0] m_axi4_awprot               , 
    output           [NUM_MASTER*4-1:0] m_axi4_awqos                , 
    output    [NUM_MASTER*W_AWUSER-1:0] m_axi4_awuser               , 
    output             [NUM_MASTER-1:0] m_axi4_awvalid              , 
    input              [NUM_MASTER-1:0] m_axi4_awready              , 

    output        [NUM_MASTER*W_ID-1:0] m_axi4_wid                  , 
    output  [NUM_MASTER*WIDTH_DATA-1:0] m_axi4_wdata                , 
    output [NUM_MASTER*WIDTH_DATA/8-1:0] m_axi4_wstrob              , 
    output             [NUM_MASTER-1:0] m_axi4_wlast                , 
    output     [NUM_MASTER*W_WUSER-1:0] m_axi4_wuser                , 
    output             [NUM_MASTER-1:0] m_axi4_wvalid               , 
    input              [NUM_MASTER-1:0] m_axi4_wready               , 

    input         [NUM_MASTER*W_ID-1:0] m_axi4_bid                  , 
    input            [NUM_MASTER*2-1:0] m_axi4_bresp                , 
    input      [NUM_MASTER*W_BUSER-1:0] m_axi4_buser                , 
    input              [NUM_MASTER-1:0] m_axi4_bvalid               , 
    output             [NUM_MASTER-1:0] m_axi4_bready                 
);

localparam WIDTH_ADDRINFO  = WIDTH_ADDR+WIDTH_ID+WIDTH_AWUSER+
                             8+3+2+HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                             HAS_QOS*4+HAS_REGION*4;

localparam WIDTH_WDATAINFO = WIDTH_DATA+WIDTH_ID+WIDTH_WUSER+
                             WIDTH_DATA/8+1;

localparam WIDTH_BRESPINFO = WIDTH_ID+2+1+WIDTH_BUSER;

localparam WIDTH_RRESPINFO = WIDTH_ID+2+1+WIDTH_RUSER+WIDTH_DATA;


wire     [NUM_SLAVE*WIDTH_ADDRINFO-1:0] s_waddr_info                ; 
wire                    [NUM_SLAVE-1:0] s_waddr_valid               ; 
wire                    [NUM_SLAVE-1:0] s_waddr_ready               ; 
                                          
wire    [NUM_SLAVE*WIDTH_WDATAINFO-1:0] s_wdata_info                ; 
wire                    [NUM_SLAVE-1:0] s_wdata_valid               ; 
wire                    [NUM_SLAVE-1:0] s_wdata_ready               ; 

wire    [NUM_SLAVE*WIDTH_BRESPINFO-1:0] s_bresp_info                ; 
wire                    [NUM_SLAVE-1:0] s_bresp_ready               ; 
wire                    [NUM_SLAVE-1:0] s_bresp_valid               ; 

wire    [NUM_MASTER*WIDTH_ADDRINFO-1:0] m_waddr_info                ; 
wire                   [NUM_MASTER-1:0] m_waddr_valid               ; 
wire                   [NUM_MASTER-1:0] m_waddr_ready               ; 

wire   [NUM_MASTER*WIDTH_WDATAINFO-1:0] m_wdata_info                ; 
wire                   [NUM_MASTER-1:0] m_wdata_valid               ; 
wire                   [NUM_MASTER-1:0] m_wdata_ready               ; 

wire   [NUM_MASTER*WIDTH_BRESPINFO-1:0] m_bresp_info                ; 
wire                   [NUM_MASTER-1:0] m_bresp_ready               ; 
wire                   [NUM_MASTER-1:0] m_bresp_valid               ; 


wire     [NUM_SLAVE*WIDTH_ADDRINFO-1:0] s_raddr_info                ; 
wire                    [NUM_SLAVE-1:0] s_raddr_valid               ; 
wire                    [NUM_SLAVE-1:0] s_raddr_ready               ; 

wire    [NUM_SLAVE*WIDTH_RRESPINFO-1:0] s_rresp_info                ; 
wire                    [NUM_SLAVE-1:0] s_rresp_ready               ; 
wire                    [NUM_SLAVE-1:0] s_rresp_valid               ; 

wire    [NUM_MASTER*WIDTH_ADDRINFO-1:0] m_raddr_info                ; 
wire                   [NUM_MASTER-1:0] m_raddr_valid               ; 
wire                   [NUM_MASTER-1:0] m_raddr_ready               ; 

wire   [NUM_MASTER*WIDTH_RRESPINFO-1:0] m_rresp_info                ; 
wire                   [NUM_MASTER-1:0] m_rresp_ready               ; 
wire                   [NUM_MASTER-1:0] m_rresp_valid               ; 

genvar                                  i                           ;


assign s_waddr_valid = s_axi4_awvalid;
assign s_axi4_awready = s_waddr_ready;

assign s_wdata_valid = s_axi4_wvalid;
assign s_axi4_wready = s_wdata_ready;

assign s_axi4_bvalid = s_bresp_valid;
assign s_bresp_ready = s_axi4_bready;

assign s_raddr_valid = s_axi4_arvalid;
assign s_axi4_arready = s_raddr_ready;

assign s_rresp_ready = s_axi4_rready;
assign s_axi4_rvalid = s_rresp_valid;


assign m_axi4_awvalid = m_waddr_valid;
assign m_waddr_ready = m_axi4_awready;

assign m_axi4_wvalid = m_wdata_valid;
assign m_wdata_ready = m_axi4_wready;

assign m_bresp_valid = m_axi4_bvalid;
assign m_axi4_bready = m_bresp_ready;

assign m_axi4_arvalid = m_raddr_valid;
assign m_raddr_ready = m_axi4_arready;

assign m_rresp_valid = m_axi4_rvalid;
assign m_axi4_rready = m_rresp_ready;


generate
for(i=0;i<NUM_SLAVE;i=i+1) begin:slave_if


assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID)+:WIDTH_ADDR] = s_axi4_awaddr[i*WIDTH_ADDR+:WIDTH_ADDR];   
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR)+:8] = s_axi4_awlen[i*8+:8];   
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8)+:3] = s_axi4_awsize[i*3+:3];   
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3)+:2] = s_axi4_awburst[i*2+:2]; 


assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID)+:WIDTH_ADDR] = s_axi4_araddr[i*WIDTH_ADDR+:WIDTH_ADDR];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR)+:8] = s_axi4_arlen[i*8+:8];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8)+:3] = s_axi4_arsize[i*3+:3];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3)+:2] = s_axi4_arburst[i*2+:2]; 

if(WIDTH_ID>0) begin :has_awrid_if
assign s_waddr_info[i*WIDTH_ADDRINFO+:WIDTH_ID] = s_axi4_awid[i*WIDTH_ID+:WIDTH_ID];
assign s_raddr_info[i*WIDTH_ADDRINFO+:WIDTH_ID] = s_axi4_arid[i*WIDTH_ID+:WIDTH_ID];
end if(HAS_REGION==1) begin :has_region_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2)+:4] = s_axi4_awregion[i*4+:4];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2)+:4] = s_axi4_arregion[i*4+:4];               
end if(HAS_LOCK== 1) begin :has_lock_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1] = s_axi4_awlock[i];  
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1] = s_axi4_arlock[i];                   
end if(HAS_CACHE==1) begin:has_cache_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK)+:4] = s_axi4_awcache[i*4+:4];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK)+:4] = s_axi4_arcache[i*4+:4];               
end if(HAS_PROT==1) begin:has_prot_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4)+:3] = s_axi4_awprot[i*3+:3]; 
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4)+:3] = s_axi4_arprot[i*3+:3];             
end if(HAS_QOS==1) begin:has_qos_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4] = s_axi4_awqos[i*4+:4]; 
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4] = s_axi4_arqos[i*4+:4];                 
end if(WIDTH_AWUSER > 0) begin:has_awuser_if
assign s_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                    HAS_QOS*4)+:W_AWUSER] = s_axi4_awuser[i*W_AWUSER+:W_AWUSER];   
assign s_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                    HAS_QOS*4)+:W_AWUSER] = s_axi4_aruser[i*W_AWUSER+:W_AWUSER];                   
end


if(WIDTH_ID>0) begin :has_wid_if
assign s_wdata_info[i*WIDTH_WDATAINFO+:WIDTH_ID] = s_axi4_wid[i*WIDTH_ID+:WIDTH_ID];
end
assign s_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID)+:WIDTH_DATA] = s_axi4_wdata[i*WIDTH_DATA+:WIDTH_DATA];
assign s_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA)+:(WIDTH_DATA/8)] = s_axi4_wstrob[i*(WIDTH_DATA/8)+:(WIDTH_DATA/8)];
if(WIDTH_WUSER > 0) begin:has_wuser_if
assign s_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA+WIDTH_DATA/8)+: W_WUSER] = s_axi4_wuser[i*W_WUSER+:W_WUSER];
end

assign s_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA+WIDTH_DATA/8 + WIDTH_WUSER)+:1] = s_axi4_wlast[i];


assign s_axi4_bresp[i*2+:2] = s_bresp_info[(i*WIDTH_BRESPINFO+1)+:2];     

if(WIDTH_ID>0) begin :has_bid_if                
assign s_axi4_bid[i*W_ID+:W_ID] = s_bresp_info[(i*WIDTH_BRESPINFO+1+2)+:WIDTH_ID];
end else begin: no_bit_if
assign s_axi4_bid[i*W_ID+:W_ID] = 'd0;
end

if(WIDTH_BUSER > 0) begin:has_buser_if
assign s_axi4_buser[i*W_BUSER+:W_BUSER] = s_bresp_info[(i*WIDTH_BRESPINFO+1+2+WIDTH_ID)+:W_BUSER];
end else begin: no_buser_if
assign s_axi4_buser[i*W_BUSER+:W_BUSER] = 'd0;
end

assign s_axi4_rlast[i] = s_rresp_info[i*WIDTH_RRESPINFO];
assign s_axi4_rresp[i*2+:2] = s_rresp_info[(i*WIDTH_RRESPINFO+1)+:2];

if(WIDTH_ID>0) begin :has_rid_if           
assign s_axi4_rid[i*W_ID+:W_ID] = s_rresp_info[(i*WIDTH_RRESPINFO+1+2)+:W_ID];
end else begin:no_rid_if
assign s_axi4_rid[i*W_ID+:W_ID] = 'd0;
end

assign s_axi4_rdata[i*WIDTH_DATA+:WIDTH_DATA] = s_rresp_info[(i*WIDTH_RRESPINFO+1+2+WIDTH_ID)+:WIDTH_DATA];

if(WIDTH_BUSER > 0) begin:has_ruser_if
assign s_axi4_ruser[i*W_RUSER+:W_RUSER] = s_rresp_info[(i*WIDTH_RRESPINFO+1+2+
                                                        WIDTH_ID+WIDTH_DATA)+:W_RUSER];
end else begin:no_ruser_if
assign s_axi4_ruser[i*W_RUSER+:W_RUSER] = 'd0;
end end

for(i=0;i<NUM_MASTER;i=i+1) begin:master_if

if(WIDTH_ID>0) begin :has_mawrid_if
assign m_axi4_arid[i*W_ID+:W_ID] = m_raddr_info[i*WIDTH_ADDRINFO+:W_ID];
assign m_axi4_awid[i*W_ID+:W_ID] = m_waddr_info[i*WIDTH_ADDRINFO+:W_ID];
end else begin:no_mawrid_if
assign m_axi4_arid[i*W_ID+:W_ID] = 'd0;
assign m_axi4_awid[i*W_ID+:W_ID] = 'd0;
end if(HAS_REGION==1) begin :has_mregion_if
assign m_axi4_arregion[i*4+:4] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2)+:4];      
assign m_axi4_awregion[i*4+:4] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2)+:4];   
end else begin:no_mregion_if
assign m_axi4_arregion[i*4+:4] = 'd0;
assign m_axi4_awregion[i*4+:4] = 'd0;
end if(HAS_LOCK== 1) begin :has_mlock_if
assign m_axi4_arlock[i] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1];
assign m_axi4_awlock[i] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4)+:1];  
end else begin:no_mlock_if
assign m_axi4_arlock[i] = 'd0;
assign m_axi4_awlock[i] = 'd0;
end if(HAS_CACHE==1) begin:has_mcache_if
assign m_axi4_awcache[i*4+:4] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK)+:4];   
assign m_axi4_arcache[i*4+:4] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK)+:4];     
end else begin:no_mcache_if
assign m_axi4_awcache[i*4+:4] = 'd0;
assign m_axi4_arcache[i*4+:4] = 'd0;
end if(HAS_PROT==1) begin:has_mprot_if
assign m_axi4_awprot[i*3+:3] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4)+:3]; 
assign m_axi4_arprot[i*3+:3] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4)+:3];     
end else begin:no_mprot_if            
assign m_axi4_awprot[i*3+:3] = 'd0;
assign m_axi4_arprot[i*3+:3] = 'd0;
end if(HAS_QOS==1) begin:has_mqos_if
assign m_axi4_awqos[i*4+:4] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4]; 
assign m_axi4_arqos[i*4+:4] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3)+:4];    
end else begin:no_mqos_if         
assign m_axi4_awqos[i*4+:4] = 'd0;
assign m_axi4_arqos[i*4+:4] = 'd0;
end if(WIDTH_AWUSER > 0) begin:has_mawuser_if
assign m_axi4_awuser[i*W_AWUSER+:W_AWUSER] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                    HAS_QOS*4)+:W_AWUSER];   
assign m_axi4_aruser[i*W_AWUSER+:W_AWUSER] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3+2+HAS_REGION*4+
                    HAS_LOCK+HAS_CACHE*4+HAS_PROT*3+
                    HAS_QOS*4)+:W_AWUSER];                   
end else begin:no_mawuser_if   
assign m_axi4_awuser[i*W_AWUSER+:W_AWUSER] = 'd0;
assign m_axi4_aruser[i*W_AWUSER+:W_AWUSER] = 'd0;
end

assign m_axi4_awaddr[i*WIDTH_ADDR+:WIDTH_ADDR] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID)+:WIDTH_ADDR];   
assign m_axi4_awlen[i*8+:8] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR)+:8];   
assign m_axi4_awsize[i*3+:3] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8)+:3];   
assign m_axi4_awburst[i*2+:2] = m_waddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3)+:2]; 

assign m_axi4_araddr[i*WIDTH_ADDR+:WIDTH_ADDR] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID)+:WIDTH_ADDR];   
assign m_axi4_arlen[i*8+:8] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR)+:8];   
assign m_axi4_arsize[i*3+:3] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8)+:3];   
assign m_axi4_arburst[i*2+:2] = m_raddr_info[(i*WIDTH_ADDRINFO+WIDTH_ID+
                    WIDTH_ADDR+8+3)+:2]; 


if(WIDTH_ID>0) begin :has_mwid_if
assign m_axi4_wid[i*W_ID+:W_ID] = m_wdata_info[i*WIDTH_WDATAINFO+:W_ID];
end else begin:no_mwid_if
assign m_axi4_wid[i*W_ID+:W_ID] = 'd0;
end

assign m_axi4_wdata[i*WIDTH_DATA+:WIDTH_DATA] = m_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID)+:WIDTH_DATA];
assign m_axi4_wstrob[i*(WIDTH_DATA/8)+:(WIDTH_DATA/8)] = m_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA)+:(WIDTH_DATA/8)];
if(WIDTH_WUSER > 0) begin:has_mwuser_if
assign m_axi4_wuser[i*W_WUSER+:W_WUSER] = m_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA+WIDTH_DATA/8)+: W_WUSER];
end else begin:no_mwuser_if
assign m_axi4_wuser[i*W_WUSER+:W_WUSER] = 'd0;
end

assign m_axi4_wlast[i] = m_wdata_info[(i*WIDTH_WDATAINFO+WIDTH_ID+
                    WIDTH_DATA+WIDTH_DATA/8 + WIDTH_WUSER)+:1];

assign m_bresp_info[i*WIDTH_BRESPINFO] = 1'd1;         
assign m_bresp_info[(i*WIDTH_BRESPINFO+1)+:2] = m_axi4_bresp[i*2+:2];     

if(WIDTH_ID>0) begin :has_mbid_if                
assign m_bresp_info[(i*WIDTH_BRESPINFO+1+2)+:W_ID] = m_axi4_bid[i*W_ID+:W_ID];
end

if(WIDTH_BUSER > 0) begin:has_mbuser_if
assign m_bresp_info[(i*WIDTH_BRESPINFO+1+2+WIDTH_ID)+:W_BUSER] = m_axi4_buser[i*W_BUSER+:W_BUSER];
end

assign m_rresp_info[i*WIDTH_RRESPINFO] = m_axi4_rlast[i];
assign m_rresp_info[(i*WIDTH_RRESPINFO+1)+:2] = m_axi4_rresp[i*2+:2];

if(WIDTH_ID>0) begin :has_mrid_if           
assign m_rresp_info[(i*WIDTH_RRESPINFO+1+2)+:W_ID] = m_axi4_rid[i*W_ID+:W_ID];
end

assign m_rresp_info[(i*WIDTH_RRESPINFO+1+2+WIDTH_ID)+:WIDTH_DATA] = m_axi4_rdata[i*WIDTH_DATA+:WIDTH_DATA];

if(WIDTH_BUSER > 0) begin:has_mruser_if
assign m_rresp_info[(i*WIDTH_RRESPINFO+1+2+WIDTH_ID+WIDTH_DATA)+:W_RUSER] = m_axi4_ruser[i*W_RUSER+:W_RUSER];
end end
endgenerate

axi_interconnect_crossbar_switch #
(
    .MODE_READ                      (0                          ), 
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .NUM_MASTER                     (NUM_MASTER                 ), // 0 ~ 4
    .WIDTH_ADDR                     (WIDTH_ADDR                 ), 
    .ADDR_BASE                      (ADDR_BASE                  ), 
    .ADDR_HIGH                      (ADDR_HIGH                  ), 
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_RUSER                    (WIDTH_RUSER                ), 
    .WIDTH_ADDRINFO                 (WIDTH_ADDRINFO             ), 
    .WIDTH_DATAINFO                 (WIDTH_WDATAINFO            ), 
    .WIDTH_RESPINFO                 (WIDTH_BRESPINFO            ), 
    .NUM_OUTSTANDING                (NUM_OUTSTANDING            ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_axi_interconnect_crossbar_switch
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    .s_addr_info                    (s_waddr_info               ), // (input )
    .s_addr_valid                   (s_waddr_valid              ), // (input )
    .s_addr_ready                   (s_waddr_ready              ), // (output)

    .s_wdata_info                   (s_wdata_info               ), // (input )
    .s_wdata_valid                  (s_wdata_valid              ), // (input )
    .s_wdata_ready                  (s_wdata_ready              ), // (output)

    .s_resp_info                    (s_bresp_info               ), // (output)
    .s_resp_ready                   (s_bresp_ready              ), // (input )
    .s_resp_valid                   (s_bresp_valid              ), // (output)
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    .m_addr_info                    (m_waddr_info               ), // (output)
    .m_addr_valid                   (m_waddr_valid              ), // (output)
    .m_addr_ready                   (m_waddr_ready              ), // (input )

    .m_wdata_info                   (m_wdata_info               ), // (output)
    .m_wdata_valid                  (m_wdata_valid              ), // (output)
    .m_wdata_ready                  (m_wdata_ready              ), // (input )

    .m_resp_info                    (m_bresp_info               ), // (input )
    .m_resp_ready                   (m_bresp_ready              ), // (output)
    .m_resp_valid                   (m_bresp_valid              )  // (input )
);

axi_interconnect_crossbar_switch #
(
    .MODE_READ                      (1                          ), 
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .NUM_MASTER                     (NUM_MASTER                 ), // 0 ~ 4
    .WIDTH_ADDR                     (WIDTH_ADDR                 ), 
    .ADDR_BASE                      (ADDR_BASE                  ), 
    .ADDR_HIGH                      (ADDR_HIGH                  ), 
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_RUSER                    (WIDTH_RUSER                ), 
    .WIDTH_ADDRINFO                 (WIDTH_ADDRINFO             ), 
    .WIDTH_DATAINFO                 (1                          ), 
    .WIDTH_RESPINFO                 (WIDTH_RRESPINFO            ), 
    .NUM_OUTSTANDING                (NUM_OUTSTANDING            ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_axi_interconnect_crossbar_switch
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    .s_addr_info                    (s_raddr_info               ), // (input )
    .s_addr_valid                   (s_raddr_valid              ), // (input )
    .s_addr_ready                   (s_raddr_ready              ), // (output)

    .s_wdata_info                   ('d0                        ), // (input )
    .s_wdata_valid                  ('d0                        ), // (input )
    .s_wdata_ready                  (                           ), // (output)

    .s_resp_info                    (s_rresp_info               ), // (output)
    .s_resp_ready                   (s_rresp_ready              ), // (input )
    .s_resp_valid                   (s_rresp_valid              ), // (output)
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    .m_addr_info                    (m_raddr_info               ), // (output)
    .m_addr_valid                   (m_raddr_valid              ), // (output)
    .m_addr_ready                   (m_raddr_ready              ), // (input )

    .m_wdata_info                   (                           ), // (output)
    .m_wdata_valid                  (                           ), // (output)
    .m_wdata_ready                  ('d0                        ), // (input )

    .m_resp_info                    (m_rresp_info               ), // (input )
    .m_resp_ready                   (m_rresp_ready              ), // (output)
    .m_resp_valid                   (m_rresp_valid              )  // (input )
);

endmodule






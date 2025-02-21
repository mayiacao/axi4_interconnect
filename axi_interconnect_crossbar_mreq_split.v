// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/17 16:52:49
// File Name    : axi_interconnect_crossbar_mreq_split.v
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
// axi_interconnect_crossbar_mreq_split
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_mreq_split #
(
    parameter                           MODE_READ           = 1     ,
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           NUM_MASTER          = 1     , // 0 ~ 4
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDR          = 32    ,
    parameter                           WIDTH_ADDRINFO      = 64    ,   
    parameter                           WIDTH_DATAINFO      = 48    ,
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_BASE         = 'd0   , 
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_HIGH         = 'd0   , 
    parameter                           NUM_OUTSTANDING     = 4     ,
    parameter                           WIDTH_OUTSTANDING   = LOG2(NUM_OUTSTANDING-1),
    parameter                           WIDTH_SALVE         = LOG2(NUM_SLAVE-1),
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    input     [WIDTH_ADDRINFO+WIDTH_SALVE-1:0] addr_info            , 
    input                               addr_valid                  , 
    output                              addr_ready                  , 

(*keep = "true",mark_debug = "true"*)    input          [WIDTH_DATAINFO-1:0] wdata_info                  , 
(*keep = "true",mark_debug = "true"*)    input                               wdata_valid                 , 
(*keep = "true",mark_debug = "true"*)    output                              wdata_ready                 , 
// ---------------------------------------------------------------------------------
// Master Port
// ---------------------------------------------------------------------------------
    output     [NUM_MASTER*WIDTH_ADDRINFO-1:0] m_addr_info          , 
    output             [NUM_MASTER-1:0] m_addr_valid                , 
    input              [NUM_MASTER-1:0] m_addr_ready                , 

(*keep = "true",mark_debug = "true"*)     output     [NUM_MASTER*WIDTH_DATAINFO-1:0] m_wdata_info         , 
(*keep = "true",mark_debug = "true"*)     output             [NUM_MASTER-1:0] m_wdata_valid               , 
(*keep = "true",mark_debug = "true"*)     input              [NUM_MASTER-1:0] m_wdata_ready               , 
// ---------------------------------------------------------------------------------
// Request Queen
// ---------------------------------------------------------------------------------
    output reg                          req_wren                    , 
    output reg [NUM_MASTER+WIDTH_SALVE+WIDTH_ID:0] req_id                        
);

localparam [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_MASK = ADDR_BASE ^ ADDR_HIGH;

wire                                    dfifo_full                  ; 
wire   [WIDTH_ADDRINFO+WIDTH_SALVE-1:0] dfifo_rddata                ; 

wire                   [WIDTH_ADDR-1:0] req_addr                    ; 
(*keep = "true",mark_debug = "true"*) reg                                     reqfifo_wren                ; 
(*keep = "true",mark_debug = "true"*) reg                    [NUM_MASTER-1:0] addr_match                  ; 
wire                                    reqfifo_en                  ; 
wire                   [NUM_MASTER-1:0] reqfifo_rddata              ; 
wire                                    reqfifo_empty               ; 
wire                   [NUM_MASTER-1:0] m_addr_ready_mask           ; 

genvar                                  i                           ;

assign req_addr = addr_info[(WIDTH_ID+WIDTH_SALVE)+:WIDTH_ADDR];

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        reqfifo_wren <= #U_DLY 'd0;
    else begin
        if(addr_valid & addr_ready)
            reqfifo_wren <= #U_DLY 'd1;
        else
            reqfifo_wren <= #U_DLY 'd0;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        req_wren <= #U_DLY 'd0;
    else begin
        if(reqfifo_en)
            req_wren <= #U_DLY 'd1;
        else
            req_wren <= #U_DLY 'd0;
    end
end

wire [NUM_MASTER*WIDTH_ADDR-1:0] targ_addr ;
wire [NUM_MASTER*WIDTH_ADDR-1:0] user_addr ;

generate
for(i=0;i<NUM_MASTER;i=i+1)begin:mst_loop



assign user_addr[i*WIDTH_ADDR+:WIDTH_ADDR] = ~ADDR_MASK[i*WIDTH_ADDR+:WIDTH_ADDR] & req_addr;
assign targ_addr[i*WIDTH_ADDR+:WIDTH_ADDR] = ~ADDR_MASK[i*WIDTH_ADDR+:WIDTH_ADDR] & ADDR_BASE[i*WIDTH_ADDR+:WIDTH_ADDR];

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        addr_match[i] <= #U_DLY 'd0;
    else begin
//        if((~ADDR_MASK[i*WIDTH_ADDR+:WIDTH_ADDR] & req_addr) == 
//            (~ADDR_MASK[i*WIDTH_ADDR+:WIDTH_ADDR] & ADDR_BASE[i*WIDTH_ADDR+:WIDTH_ADDR]))
          if(targ_addr[i*WIDTH_ADDR+:WIDTH_ADDR] == user_addr[i*WIDTH_ADDR+:WIDTH_ADDR])
            addr_match[i] <= #U_DLY 'd1;
        else
            addr_match[i] <= #U_DLY 'd0;
    end
end

assign m_addr_info[i*WIDTH_ADDRINFO+:WIDTH_ADDRINFO] = dfifo_rddata[WIDTH_SALVE+:WIDTH_ADDRINFO];
assign m_addr_valid[i] = reqfifo_rddata[i] ? ~reqfifo_empty : 1'd0;
assign m_addr_ready_mask[i] = reqfifo_rddata[i] ? m_addr_ready[i] : 1'd0;

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        req_id[WIDTH_SALVE+WIDTH_ID+i] <= #U_DLY 'd0;
    else begin
        if(~reqfifo_empty && reqfifo_rddata[i])
            req_id[WIDTH_SALVE+WIDTH_ID+i] <= #U_DLY 'd1;
        else
            req_id[WIDTH_SALVE+WIDTH_ID+i] <= #U_DLY 'd0;
    end
end

end
endgenerate

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        req_id[0+:(WIDTH_ID+WIDTH_SALVE)] <= #U_DLY 'd0;
        req_id[NUM_MASTER+WIDTH_SALVE+WIDTH_ID] <= #U_DLY 'd0;
    end
    else begin
        if(~reqfifo_empty && (reqfifo_rddata == 'd0))
            req_id[NUM_MASTER+WIDTH_SALVE+WIDTH_ID] <= #U_DLY 'd1;
        else
            req_id[NUM_MASTER+WIDTH_SALVE+WIDTH_ID] <= #U_DLY 'd0;

        req_id[0+:(WIDTH_ID+WIDTH_SALVE)] <= #U_DLY dfifo_rddata[0+:(WIDTH_ID+WIDTH_SALVE)];
    end
end

assign reqfifo_en = (|m_addr_ready_mask && ~reqfifo_empty) || (~reqfifo_empty && (reqfifo_rddata == 'd0));

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_ADDRINFO+WIDTH_SALVE ), // It must be a multiple of 8.
    .PA_AW                          (1                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_ADDRINFO+WIDTH_SALVE ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u0_datafifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_sys                    ), // (input )
    .clk_rd                         ('d0                        ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (addr_valid&addr_ready      ), // (input )
    .wr_data                        (addr_info                  ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (dfifo_full                 ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (reqfifo_en                 ), // (input )
    .rd_data                        (dfifo_rddata               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (                           ), // (output)
    .aempty                         (                           )  // (output)
);

assign addr_ready = ~dfifo_full;

axi_interconnect_fifogen #
(
    .PA_DW                          (NUM_MASTER                 ), // It must be a multiple of 8.
    .PA_AW                          (1                          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (NUM_MASTER                 ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u0_infofifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_sys                    ), // (input )
    .clk_rd                         ('d0                        ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (reqfifo_wren               ), // (input )
    .wr_data                        (addr_match                 ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (reqfifo_en                 ), // (input )
    .rd_data                        (reqfifo_rddata             ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (reqfifo_empty              ), // (output)
    .aempty                         (                           )  // (output)
);

generate 
if(MODE_READ == 0) begin:wdata_if


(*keep = "true",mark_debug = "true"*) wire                                    dififo_en                   ; 
(*keep = "true",mark_debug = "true"*) wire                   [NUM_MASTER-1:0] dififo_rddata               ; 
(*keep = "true",mark_debug = "true"*) wire                                    dififo_empty                ; 
(*keep = "true",mark_debug = "true"*) wire                   [NUM_MASTER-1:0] m_wdata_ready_mask          ; 

for(i=0;i<NUM_MASTER;i=i+1)begin:mstwr_loop

assign m_wdata_valid[i] = ~dififo_empty && dififo_rddata[i] ? wdata_valid : 'd0;
assign m_wdata_ready_mask[i] = ~dififo_empty && dififo_rddata[i] ? m_wdata_ready[i] : 'd0;
assign m_wdata_info[i*WIDTH_DATAINFO+:WIDTH_DATAINFO] = wdata_info;
end

assign wdata_ready = |m_wdata_ready_mask;
assign dififo_en = wdata_valid & wdata_ready & wdata_info[WIDTH_DATAINFO-1];

axi_interconnect_fifogen #
(
    .PA_DW                          (NUM_MASTER                 ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING          ), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (NUM_MASTER                 ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u1_infofifo
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_wr                         (clk_sys                    ), // (input )
    .clk_rd                         ('d0                        ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    .wr_en                          (reqfifo_wren               ), // (input )
    .wr_data                        (addr_match                 ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (dififo_en                  ), // (input )
    .rd_data                        (dififo_rddata              ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (dififo_empty               ), // (output)
    .aempty                         (                           )  // (output)
);

end
endgenerate

function integer LOG2 ;
input integer d;
begin
    LOG2 = 1;
    while((2**LOG2-1) < d)
        LOG2 = LOG2 + 1;
end
endfunction

endmodule









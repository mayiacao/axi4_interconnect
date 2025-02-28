// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/18 09:40:50
// File Name    : axi_interconnect_crossbar_mresp_arbit.v
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
// axi_interconnect_crossbar_mresp_arbit
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_mresp_arbit #
(
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           NUM_MASTER          = 1     , // 0 ~ 4
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_RESPINFO      = 48    ,
    parameter                           NUM_OUTSTANDING     = 4     ,
    parameter                           MODE_READ           = 0     ,
    parameter                           WIDTH_RUSER         = 1     ,
    parameter                           WIDTH_OUTSTANDING   = LOG2(NUM_OUTSTANDING-1),
    parameter                           WIDTH_SALVE         = LOG2(NUM_SLAVE-1),
    parameter                           WIDTH_MASTER        = LOG2(NUM_MASTER),
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Response Queen
// ---------------------------------------------------------------------------------
    input                               req_wren                    , 
    input     [NUM_MASTER+WIDTH_SALVE+WIDTH_ID:0] req_id            , 
// ---------------------------------------------------------------------------------
// Slave 
// ---------------------------------------------------------------------------------
    input     [NUM_MASTER*WIDTH_RESPINFO-1:0] m_resp_info           , 
    output             [NUM_MASTER-1:0] m_resp_ready                , 
    input              [NUM_MASTER-1:0] m_resp_valid                , 
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    output reg [WIDTH_RESPINFO+WIDTH_SALVE-1:0] resp_info           , 
    output reg                          resp_valid                  , 
    input                               resp_ready                    
);

wire                     [NUM_MASTER:0] ififo_rden_tmp              ; 
wire                                    ififo_rden                  ; 
wire [NUM_MASTER+WIDTH_SALVE+WIDTH_ID:0] ififo_rddata               ; 
wire                                    ififo_empty                 ; 

wire [(NUM_MASTER+1)*WIDTH_RESPINFO-1:0] m_resp_info_tmp            ; 
reg                      [NUM_MASTER:0] m_resp_ready_tmp            ; 
wire                     [NUM_MASTER:0] m_resp_valid_tmp            ; 
wire                     [NUM_MASTER:0] m_resp_rlast_tmp            ; 

wire                 [WIDTH_MASTER-1:0] cuer_tmp0 [NUM_MASTER:0]    ; 
wire                     [NUM_MASTER:0] cuer_tmp1 [WIDTH_MASTER-1:0]; 
wire                 [WIDTH_MASTER-1:0] cuser                       ; 

genvar                                  i                           ;
genvar                                  j                           ;

always @ (*) begin
if(resp_ready)
    m_resp_ready_tmp = ififo_rddata[WIDTH_SALVE+WIDTH_ID+:(NUM_MASTER+1)];
else
    m_resp_ready_tmp = 'd0;
end

assign m_resp_info_tmp = {{{(WIDTH_RESPINFO-3){1'b0}},2'b11,1'b1},m_resp_info};
//generate
//if(MODE_READ == 1) begin:read_if
//assign m_resp_info_tmp = {{{(WIDTH_RESPINFO-3){1'b0}},2'b11,1'b1},m_resp_info};
//end else begin:write_if
//assign m_resp_info_tmp = {{{(WIDTH_RESPINFO-2){1'b0}},2'b11},m_resp_info};
//end
//endgenerate

assign m_resp_ready = m_resp_ready_tmp[NUM_MASTER-1:0];
assign m_resp_valid_tmp = {~ififo_empty,m_resp_valid};

assign ififo_rden_tmp = m_resp_ready_tmp & m_resp_valid_tmp & m_resp_rlast_tmp;
assign ififo_rden = |ififo_rden_tmp;


generate
for(i=0;i<NUM_MASTER+1;i=i+1) begin:onehot2dec_loop

assign m_resp_rlast_tmp[i] = m_resp_info_tmp[i*WIDTH_RESPINFO];

assign cuer_tmp0[i] = ififo_rddata[WIDTH_SALVE+WIDTH_ID+i] ? i[WIDTH_MASTER-1:0] : 'd0; 

for(j=0;j<WIDTH_MASTER;j=j+1) begin:bitswitch_loop

assign cuer_tmp1[j][i] = cuer_tmp0[i][j];

end end

for(i=0;i<WIDTH_MASTER;i=i+1) begin:bitand_loop

assign cuser[i] =  |cuer_tmp1[i];

end

if((MODE_READ == 1) || (WIDTH_RUSER > 0)) begin:mode_read_if
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        resp_info[(WIDTH_SALVE+3+WIDTH_ID)+:(WIDTH_RESPINFO-WIDTH_ID-3)] <= #U_DLY 'd0;
    else begin
        if(resp_ready)
            resp_info[(WIDTH_SALVE+3+WIDTH_ID)+:(WIDTH_RESPINFO-WIDTH_ID-3)] <= #U_DLY
                m_resp_info_tmp[(cuser*WIDTH_RESPINFO+3+WIDTH_ID)+:(WIDTH_RESPINFO-WIDTH_ID-3)];
        else
            ;
    end
end

end

if(WIDTH_ID > 0) begin:width_id_if
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        resp_info[(WIDTH_SALVE+3)+:WIDTH_ID] <= #U_DLY 'd0;
    else begin
        if(resp_ready)
            resp_info[(WIDTH_SALVE+3)+:WIDTH_ID] <= #U_DLY ififo_rddata[WIDTH_SALVE+:WIDTH_ID];
        else
            ;
    end
end

end
endgenerate

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        resp_info[0+:(WIDTH_SALVE+3)] <= #U_DLY 'd0;
        resp_valid <= #U_DLY 'd0;
    end
    else begin
        if(resp_ready)
            resp_info[0+:(WIDTH_SALVE+3)] <= #U_DLY { 
                                            m_resp_info_tmp[(cuser*WIDTH_RESPINFO)+:3],
                                            ififo_rddata[0+:WIDTH_SALVE]};
        else
            ;
        
        if(m_resp_valid[cuser] & m_resp_ready[cuser])
            resp_valid <= #U_DLY 'd1;
        else if(resp_ready)
            resp_valid <= #U_DLY 'd0;
        else
            ;
    end
end
//always @ (posedge clk_sys or negedge rst_n) begin
//    if(~rst_n) begin
//        resp_info <= #U_DLY 'd0;
//        resp_valid <= #U_DLY 'd0;
//    end
//    else begin
//        if(resp_ready)
//            resp_info <= #U_DLY {m_resp_info_tmp[(cuser*WIDTH_RESPINFO+3+WIDTH_ID)+:(WIDTH_RESPINFO-WIDTH_ID-3)],
//                                ififo_rddata[WIDTH_SALVE+:WIDTH_ID],
//                                m_resp_info_tmp[(cuser*WIDTH_RESPINFO)+:3],
//                                ififo_rddata[0+:WIDTH_SALVE]};
// //           resp_info <= #U_DLY {m_resp_info_tmp[cuser*WIDTH_RESPINFO+:WIDTH_RESPINFO],
// //                                 ififo_rddata[0+:WIDTH_SALVE]};
//        else
//            ;
//
//        if(m_resp_valid[cuser] & m_resp_ready[cuser])
//            resp_valid <= #U_DLY 'd1;
//        else if(resp_ready)
//            resp_valid <= #U_DLY 'd0;
//        else
//            ;
//    end
//end

axi_interconnect_fifogen #
(
    .PA_DW                          (NUM_MASTER+WIDTH_SALVE+WIDTH_ID+1), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_MASTER+WIDTH_OUTSTANDING), 
    .PB_DW                          (NUM_MASTER+WIDTH_SALVE+WIDTH_ID+1), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_fifogen
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
    .wr_en                          (req_wren                   ), // (input )
    .wr_data                        (req_id                     ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (ififo_rden                 ), // (input )
    .rd_data                        (ififo_rddata               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (ififo_empty                ), // (output)
    .aempty                         (                           )  // (output)
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







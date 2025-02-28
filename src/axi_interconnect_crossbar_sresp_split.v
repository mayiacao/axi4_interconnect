// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/21 11:48:28
// File Name    : axi_interconnect_crossbar_sresp_split.v
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
// axi_interconnect_crossbar_sresp_split
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_sresp_split #
(
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           WIDTH_RESPINFO      = 48    ,
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
// Slave
// ---------------------------------------------------------------------------------
    input      [WIDTH_RESPINFO+WIDTH_SALVE-1:0] resp_info           , 
    input                               resp_valid                  , 
    output                              resp_ready                  , 
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    output reg [NUM_SLAVE*WIDTH_RESPINFO-1:0] m_resp_info           , 
    input               [NUM_SLAVE-1:0] m_resp_ready                , 
    output reg          [NUM_SLAVE-1:0] m_resp_valid                  
);

wire                                    fifo_full                   ; 
wire                    [NUM_SLAVE-1:0] fifo_rden_temp              ; 
wire                                    fifo_rden                   ; 
wire   [WIDTH_RESPINFO+WIDTH_SALVE-1:0] fifo_rddata                 ; 
wire                                    fifo_empty                  ; 
wire                  [WIDTH_SALVE-1:0] cuser                       ; 
genvar                                  i                           ;

assign cuser = fifo_rddata[0+:WIDTH_SALVE];

generate
for(i=0;i<NUM_SLAVE;i=i+1) begin:mast_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        m_resp_info[i*WIDTH_RESPINFO+:WIDTH_RESPINFO] <= #U_DLY 'd0;
        m_resp_valid[i] <= #U_DLY 'd0;
    end
    else begin
        m_resp_info[i*WIDTH_RESPINFO+:WIDTH_RESPINFO] <= #U_DLY fifo_rddata[WIDTH_SALVE+:WIDTH_RESPINFO];

        if(m_resp_valid[i] && m_resp_ready[i])
            m_resp_valid[i] <= #U_DLY 'd0;
        else if((~fifo_empty) && (cuser == i))
            m_resp_valid[i] <= #U_DLY 'd1;
        else 
            ;
    end 
end

assign fifo_rden_temp[i] = m_resp_ready[i] & m_resp_valid[i];

end
endgenerate

assign fifo_rden = |fifo_rden_temp;

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_RESPINFO+WIDTH_SALVE ), // It must be a multiple of 8.
    .PA_AW                          (1                          ), 
    .PB_DW                          (WIDTH_RESPINFO+WIDTH_SALVE ), // It must be a multiple of PA_DW.
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
    .wr_en                          (resp_valid & resp_ready    ), // (input )
    .wr_data                        (resp_info                  ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (fifo_full                  ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (fifo_rden                  ), // (input )
    .rd_data                        (fifo_rddata                ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (fifo_empty                 ), // (output)
    .aempty                         (                           )  // (output)
);
assign resp_ready = ~fifo_full;


function integer LOG2 ;
input integer d;
begin
    LOG2 = 1;
    while((2**LOG2-1) < d)
        LOG2 = LOG2 + 1;
end
endfunction

endmodule







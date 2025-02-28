// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/13 16:42:41
// File Name    : axi_interconnect_width_convert_bresp.v
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
// axi_interconnect_width_convert_bresp
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_width_convert_bresp #
(
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_RUSER         = 1     ,
    parameter                           WIDTH_OUTSTANDING   = 4     ,
    parameter                           W_ID                = (WIDTH_ID > 0) ? WIDTH_ID : 'd1,
    parameter                           W_RUSER             = (WIDTH_RUSER > 0) ? WIDTH_RUSER : 'd1,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------------
    input                               req_en                      , 
    input                               req_last                    , 
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    output reg               [W_ID-1:0] s_respid                    , 
    output reg                  [2-1:0] s_respresp                  , 
    output reg            [W_RUSER-1:0] s_respuser                  , 
    output reg                          s_respvalid                 , 
    input                               s_respready                 , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    input                    [W_ID-1:0] m_respid                    , 
    input                       [2-1:0] m_respresp                  , 
    input                 [W_RUSER-1:0] m_respuser                  , 
    input                               m_respvalid                 , 
    output reg                          m_respready                   
);

localparam IDLE = 2'b00;
localparam ACK  = 2'b01;
localparam WAIT = 2'b10;

reg                               [1:0] cstate                      ; 
reg                               [1:0] nstate                      ; 

wire                                    reqfifo_rddata              ; 
wire                                    reqfifo_empty               ; 

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        cstate <= #U_DLY IDLE;
    else
        cstate <= #U_DLY nstate;
end

always @ (*)
case(cstate)
    IDLE    : nstate = ~reqfifo_empty ? ACK : IDLE;
    ACK     : begin
        if(m_respvalid&m_respready) begin
            if(reqfifo_rddata)
                nstate = WAIT;
            else
                nstate = IDLE;
        end
        else
            nstate = ACK;
    end
    WAIT    : nstate = (s_respvalid&s_respready) ? IDLE : WAIT;
    default : nstate = IDLE;
endcase

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        m_respready <= #U_DLY 'd0;
    else begin
        if(m_respvalid&s_respready)
            m_respready <= #U_DLY 'd0;
        else if(~reqfifo_empty && (cstate == IDLE))
            m_respready <= #U_DLY 'd1;
        else
            ;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        s_respid <= #U_DLY 'd0;
        s_respresp <= #U_DLY 'd0;
        s_respuser <= #U_DLY 'd0;
        s_respvalid <= #U_DLY 'd0;
    end 
    else begin
        s_respid <= #U_DLY m_respid;
        s_respresp <= #U_DLY m_respresp;
        s_respuser <= #U_DLY m_respuser;

        if(s_respvalid&s_respready)
            s_respvalid <= #U_DLY 'd0;
        else if(m_respvalid&m_respready&reqfifo_rddata)
            s_respvalid <= #U_DLY 'd1;
        else
            ;
    end
end

axi_interconnect_fifogen #
(
    .PA_DW                          (1                          ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING          ), 
    .PB_DW                          (1                          ), // It must be a multiple of PA_DW.
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u0_axi_interconnect_fifogen
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
    .wr_en                          (req_en                     ), // (input )
    .wr_data                        (req_last                   ), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (m_respvalid&m_respready    ), // (input )
    .rd_data                        (reqfifo_rddata             ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (reqfifo_empty              ), // (output)
    .aempty                         (                           )  // (output)
);

endmodule







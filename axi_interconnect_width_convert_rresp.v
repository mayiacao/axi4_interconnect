// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/13 16:42:02
// File Name    : axi_interconnect_width_convert_rresp.v
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
// axi_interconnect_width_convert_rresp
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_width_convert_rresp #
(
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_SDATA         = 32    ,
    parameter                           WIDTH_MDATA         = 32    ,
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
(*mark_debug = "true" ,keep = "true"*)    input                               req_en                      , 
(*mark_debug = "true" ,keep = "true"*)    input                         [2:0] req_size                    , 
(*mark_debug = "true" ,keep = "true"*)    input                         [7:0] req_offset                  , 
(*mark_debug = "true" ,keep = "true"*)    input                               req_last                    , 
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
(*mark_debug = "true" ,keep = "true"*)    output                   [W_ID-1:0] s_respid                    , 
(*mark_debug = "true" ,keep = "true"*)    output            [WIDTH_SDATA-1:0] s_respdata                  , 
(*mark_debug = "true" ,keep = "true"*)    output                      [2-1:0] s_respresp                  , 
(*mark_debug = "true" ,keep = "true"*)    output                              s_resplast                  , 
(*mark_debug = "true" ,keep = "true"*)    output                [W_RUSER-1:0] s_respuser                  , 
(*mark_debug = "true" ,keep = "true"*)    output                              s_respvalid                 , 
(*mark_debug = "true" ,keep = "true"*)    input                               s_respready                 , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
(*mark_debug = "true" ,keep = "true"*)    input                    [W_ID-1:0] m_respid                    , 
(*mark_debug = "true" ,keep = "true"*)    input             [WIDTH_MDATA-1:0] m_respdata                  , 
(*mark_debug = "true" ,keep = "true"*)    input                       [2-1:0] m_respresp                  , 
(*mark_debug = "true" ,keep = "true"*)    input                               m_resplast                  , 
(*mark_debug = "true" ,keep = "true"*)    input                 [W_RUSER-1:0] m_respuser                  , 
(*mark_debug = "true" ,keep = "true"*)    input                               m_respvalid                 , 
(*mark_debug = "true" ,keep = "true"*)    output                              m_respready                   
);

localparam WIDTH_DFIFO = WIDTH_ID+WIDTH_SDATA+2+1+WIDTH_RUSER;

localparam NUM_SUB = (WIDTH_SDATA > WIDTH_MDATA) ? WIDTH_SDATA/WIDTH_MDATA : WIDTH_MDATA/WIDTH_SDATA;
localparam WIDTH_SUB = CLOG2(NUM_SUB);
localparam WIDTH_SBYTE = CLOG2(WIDTH_SDATA/8);
localparam WIDTH_MBYTE = CLOG2(WIDTH_MDATA/8);

localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam WAIT = 2'b10;

(*mark_debug = "true" ,keep = "true"*)reg                               [1:0] cstate                      ; 
(*mark_debug = "true" ,keep = "true"*)reg                               [1:0] nstate                      ; 
                             
(*mark_debug = "true" ,keep = "true"*)wire                              [2:0] stp_size                    ; 
(*mark_debug = "true" ,keep = "true"*)reg                     [WIDTH_SUB-1:0] stp_data                    ; 
(*mark_debug = "true" ,keep = "true"*)reg                     [WIDTH_SUB-1:0] stp_cnt                     ; 
                             
(*mark_debug = "true" ,keep = "true"*)wire                    [WIDTH_SUB-1:0] mux_data                    ; 
(*mark_debug = "true" ,keep = "true"*)reg                     [WIDTH_SUB-1:0] mux_cnt                     ; 
                             
(*mark_debug = "true" ,keep = "true"*)wire                                    reqfifo_rden                ; 
(*mark_debug = "true" ,keep = "true"*)wire                             [11:0] reqfifo_rddata              ; 
(*mark_debug = "true" ,keep = "true"*)wire                                    reqfifo_empty               ; 
                            
(*mark_debug = "true" ,keep = "true"*)reg                                     dfifo_wren                  ; 
(*mark_debug = "true" ,keep = "true"*)reg                   [WIDTH_DFIFO-1:0] dfifo_wrdata                ; 
(*mark_debug = "true" ,keep = "true"*)wire                  [WIDTH_DFIFO-1:0] dfifo_rddata                ; 
(*mark_debug = "true" ,keep = "true"*)wire                                    dfifo_pfull                 ; 
(*mark_debug = "true" ,keep = "true"*)wire                                    dfifo_empty                 ; 

genvar                                  i                           ;

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        cstate <= #U_DLY IDLE;
    else
        cstate <= #U_DLY nstate;
end

always @ (*)
case(cstate)
    IDLE    : nstate = ~reqfifo_empty ? LOAD : IDLE;
    LOAD    : nstate = WAIT;
    WAIT    : nstate = (m_respready && m_respvalid && m_resplast) ? IDLE : WAIT;
    default : nstate = IDLE;
endcase

assign stp_size = reqfifo_rddata[10:8];
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        stp_data <= #U_DLY 'd0;
        stp_cnt <= #U_DLY 'd0;
    end
    else begin
        if(cstate == IDLE)
            stp_data <= #U_DLY (1'd1 << stp_size) - 'd1;
        else
            ;
        
        if(~dfifo_pfull && m_respvalid && (cstate == WAIT)) begin
            if(stp_cnt >= stp_data)
                stp_cnt <= #U_DLY 'd0;
            else
                stp_cnt <= #U_DLY stp_cnt + 'd1;
        end
        else
            ;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        mux_cnt <= #U_DLY 'd0;
    else begin
        if(cstate == LOAD)
            mux_cnt <= #U_DLY mux_data;
        else if(~dfifo_pfull && m_respvalid && (cstate == WAIT))
            mux_cnt <= #U_DLY mux_cnt + 'd1;
        else
            ;
    end
end

assign m_respready = ~dfifo_pfull && m_respvalid && (cstate == WAIT);
assign reqfifo_rden = m_respvalid&m_respready&m_resplast;

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wren <= #U_DLY 'd0;
    else begin
        if(~dfifo_pfull && m_respvalid && (stp_cnt == stp_data) && (cstate == WAIT))
            dfifo_wren <= #U_DLY 'd1;
        else
            dfifo_wren <= #U_DLY 'd0;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[WIDTH_SDATA] <= #U_DLY 'd0;
    else begin
        if(~dfifo_pfull && m_respvalid && m_resplast && reqfifo_rddata[11])
            dfifo_wrdata[WIDTH_SDATA] <= #U_DLY 1'b1;
        else
            dfifo_wrdata[WIDTH_SDATA] <= #U_DLY 1'b0;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[(WIDTH_SDATA+1)+:2] <= #U_DLY 'd0;
    else 
        dfifo_wrdata[(WIDTH_SDATA+1)+:2] <= #U_DLY m_respresp;
end

generate
if(WIDTH_MDATA > WIDTH_SDATA) begin:amaxb_if

assign mux_data = reqfifo_rddata[WIDTH_MBYTE-1:WIDTH_SBYTE];

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[0+:WIDTH_SDATA] <= #U_DLY 'd0;
    else 
        dfifo_wrdata[0+:WIDTH_SDATA] <= #U_DLY m_respdata[mux_cnt*WIDTH_SDATA+:WIDTH_SDATA];
end

end else begin:aminb_if

assign mux_data = reqfifo_rddata[WIDTH_SBYTE-1:WIDTH_MBYTE];

for(i=0;i<NUM_SUB;i=i+1) begin:hasuserdata_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[i*WIDTH_MDATA+:WIDTH_MDATA] <= #U_DLY 'd0;
    else begin
        if(mux_cnt == i[WIDTH_SUB-1:0]) 
            dfifo_wrdata[i*WIDTH_MDATA+:WIDTH_MDATA] <= #U_DLY m_respdata;
        else 
            ;
    end
end
            
end end

if(WIDTH_ID >0) begin:hasrid_if
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[(WIDTH_SDATA+1+2+WIDTH_RUSER)+:WIDTH_ID] <= #U_DLY 'd0;
    
    else 
        dfifo_wrdata[(WIDTH_SDATA+1+2+WIDTH_RUSER)+:WIDTH_ID] <= #U_DLY m_respid;
end    
end

if(WIDTH_RUSER >0) begin:hasruser_if
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wrdata[(WIDTH_SDATA+1+2)+:WIDTH_RUSER] <= #U_DLY 'd0;
    
    else 
        dfifo_wrdata[(WIDTH_SDATA+1+2)+:WIDTH_RUSER] <= #U_DLY m_respuser;
end    
end



if(WIDTH_RUSER>0) begin:hasruserrd_if
assign s_respuser = dfifo_rddata[(WIDTH_SDATA+1+2)+:WIDTH_RUSER];
end else begin:noruserrd_if
assign s_respuser = 'd0;
end if(WIDTH_ID>0) begin:hasridrd_if
assign s_respid = dfifo_rddata[(WIDTH_SDATA+1+2+WIDTH_RUSER)+:WIDTH_ID];
end else begin:noridrd_if
assign s_respid = 'd0;
end

endgenerate

assign s_respvalid = ~dfifo_empty;
assign s_respdata = dfifo_rddata[0+:WIDTH_SDATA];
assign s_respresp = dfifo_rddata[(WIDTH_SDATA+1)+:2];
assign s_resplast = dfifo_rddata[WIDTH_SDATA];

axi_interconnect_fifogen #
(
    .PA_DW                          (12                         ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING          ), 
    .PB_DW                          (12                         ), // It must be a multiple of PA_DW.
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
    .wr_data                        ({req_last,req_size,req_offset}), // (input )
    .prog_data                      ('d1                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (                           ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (reqfifo_rden               ), // (input )
    .rd_data                        (reqfifo_rddata             ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (reqfifo_empty              ), // (output)
    .aempty                         (                           )  // (output)
);


axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_DFIFO                ), 
    .PA_AW                          (2                          ), 
    .PB_DW                          (WIDTH_DFIFO                ), 
    .RD_AS_ACK                      ("TRUE"                     ), // "TRUE" OR "FALSE"
    .CLOCK_ASYNC                    ("FALSE"                    ), // 
    .U_DLY                          (U_DLY                      )  // 
)
u1_axi_interconnect_fifogen
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
    .wr_en                          (dfifo_wren                 ), // (input )
    .wr_data                        (dfifo_wrdata               ), // (input )
    .prog_data                      ('d2                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (dfifo_pfull                ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (s_respvalid & s_respready  ), // (input )
    .rd_data                        (dfifo_rddata               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (dfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);


function integer CLOG2 ;
input integer d;
begin
    CLOG2 = 0;
    while((2**CLOG2) < d)
        CLOG2 = CLOG2 + 1;
end
endfunction

endmodule







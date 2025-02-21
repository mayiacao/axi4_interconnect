// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/11 15:46:57
// File Name    : axi_interconnect_width_convert_reqdata.v
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
// axi_interconnect_width_convert_reqdata
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_width_convert_reqdata #
(
    parameter                           WIDTH_SDATA         = 32    ,
    parameter                           WIDTH_MDATA         = 32    ,
    parameter                           WIDTH_DUSER         = 1     ,
    parameter                           WIDTH_OUTSTANDING   = 2     ,
    parameter                           W_DUSER             = (WIDTH_DUSER > 0) ? WIDTH_DUSER : 'd1,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Info
// ---------------------------------------------------------------------------------
    input                               split_en                    , 
    input                         [7:0] split_len                   , 
    input                         [7:0] split_offset                , 
    input                         [2:0] split_size                  , 
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    input             [WIDTH_SDATA-1:0] s_reqddata                  , 
    input           [WIDTH_SDATA/8-1:0] s_reqdstrob                 , 
    input                               s_reqdlast                  , 
    input                 [W_DUSER-1:0] s_reqduser                  , 
    input                               s_reqdvalid                 , 
    output                              s_reqdready                 , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    output            [WIDTH_MDATA-1:0] m_reqdwdata                 , 
    output          [WIDTH_MDATA/8-1:0] m_reqdwstrob                , 
    output                              m_reqdwlast                 , 
    output                [W_DUSER-1:0] m_reqdwuser                 , 
    output                              m_reqdwvalid                , 
    input                               m_reqdwready                  
);

localparam NUM_SUB = (WIDTH_SDATA > WIDTH_MDATA) ? WIDTH_SDATA/WIDTH_MDATA : WIDTH_MDATA/WIDTH_SDATA;
localparam WIDTH_SUB = CLOG2(NUM_SUB);
localparam WIDTH_SBYTE = CLOG2(WIDTH_SDATA/8);
localparam WIDTH_MBYTE = CLOG2(WIDTH_MDATA/8);

localparam IDLE  = 2'b00;
localparam LOAD  = 2'b01;
localparam WAIT  = 2'b10;

reg                               [1:0] cstate                      ; 
reg                               [1:0] nstate                      ; 

wire                              [2:0] stp_size                    ; 
reg                     [WIDTH_SUB-1:0] stp_data                    ; 
reg                     [WIDTH_SUB-1:0] stp_cnt                     ; 

wire                    [WIDTH_SUB-1:0] mux_data                    ; 
reg                     [WIDTH_SUB-1:0] mux_cnt                     ; 

wire                              [7:0] mlen_data                   ; 
reg                               [7:0] mlen_cnt                    ; 

wire                                    ififo_rden                  ; 
wire                             [18:0] ififo_rddata                ; 
wire                                    ififo_empty                 ; 

reg                                     dfifo_wren                  ; 
reg  [WIDTH_MDATA+WIDTH_MDATA/8+WIDTH_DUSER:0] dfifo_wrdata         ; 
wire [WIDTH_MDATA+WIDTH_MDATA/8+WIDTH_DUSER:0] dfifo_rddata         ; 
wire                                    dfifo_pfull                 ; 
wire                                    dfifo_empty                 ; 

genvar                                  i                           ;

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        cstate <= #U_DLY IDLE;
    else
        cstate <= #U_DLY nstate;
end

always @ (*)
case(cstate)
    IDLE    : nstate = ~ififo_empty ? LOAD : IDLE;
    LOAD    : nstate = WAIT;
    WAIT    : begin
        if(~dfifo_pfull && s_reqdvalid && (mlen_cnt >= mlen_data)) 
            nstate = IDLE;
        else
            nstate = WAIT;
    end 
    default : nstate = IDLE;
endcase

assign stp_size = ififo_rddata[18:16];
assign mlen_data = ififo_rddata[15:8];

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
        
        if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT)) begin
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
        else if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT))
            mux_cnt <= #U_DLY mux_cnt + 'd1;
        else
            ;
    end
end

assign s_reqdready = ~dfifo_pfull && s_reqdvalid && (stp_cnt == stp_data) && (cstate == WAIT);
assign ififo_rden = ~dfifo_pfull && s_reqdvalid && (mlen_cnt >= mlen_data) && (cstate == WAIT);


always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        mlen_cnt <= #U_DLY 'd0;
    else begin
        if(cstate == WAIT) begin
            if(~dfifo_pfull && s_reqdvalid)
                mlen_cnt <= #U_DLY mlen_cnt + 'd1;
            else
                ;
        end
        else
            mlen_cnt <= #U_DLY 'd0;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        dfifo_wrdata[0] <= #U_DLY 'd0;
    else begin
        if(~dfifo_pfull && s_reqdvalid && mlen_cnt >= mlen_data)
            dfifo_wrdata[0] <= #U_DLY 'd1;
        else
            dfifo_wrdata[0] <= #U_DLY 'd0;
    end
end

generate
if(WIDTH_SDATA > WIDTH_MDATA) begin:amaxb_if

assign mux_data = ififo_rddata[WIDTH_SBYTE-1:WIDTH_MBYTE];

if(WIDTH_DUSER>0)begin:maxhasuser_if

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wren <= #U_DLY 'd0;
        dfifo_wrdata[WIDTH_MDATA+WIDTH_MDATA/8+WIDTH_DUSER:1] <= #U_DLY 'd0;
    end
    else begin
        if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT))
            dfifo_wren <= #U_DLY 'd1;
        else
            dfifo_wren <= #U_DLY 'd0;

        dfifo_wrdata[(WIDTH_MDATA/8+WIDTH_DUSER+1)+:WIDTH_MDATA] <= #U_DLY s_reqddata[mux_cnt*WIDTH_MDATA+:WIDTH_MDATA];
        dfifo_wrdata[(WIDTH_DUSER+1)+:WIDTH_MDATA/8] <= #U_DLY s_reqdstrob[(mux_cnt*WIDTH_MDATA/8)+:(WIDTH_MDATA/8)];
        dfifo_wrdata[1+:WIDTH_DUSER] <= #U_DLY s_reqduser;
    end
end

end else begin:maxnouser_if
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wren <= #U_DLY 'd0;
        dfifo_wrdata[WIDTH_MDATA+WIDTH_MDATA/8+WIDTH_DUSER:1] <= #U_DLY 'd0;
    end
    else begin
        if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT))
            dfifo_wren <= #U_DLY 'd1;
        else
            dfifo_wren <= #U_DLY 'd0;

        dfifo_wrdata[(WIDTH_MDATA/8+WIDTH_DUSER+1)+:WIDTH_MDATA] <= #U_DLY s_reqddata[mux_cnt*WIDTH_MDATA+:WIDTH_MDATA];
        dfifo_wrdata[(WIDTH_DUSER+1)+:WIDTH_MDATA/8] <= #U_DLY s_reqdstrob[(mux_cnt*WIDTH_MDATA/8)+:(WIDTH_MDATA/8)];

//        if(~dfifo_pfull && s_reqdvalid) begin
//            if(mlen_cnt >= mlen_data - 'd1)
//                dfifo_wrdata[0] <= #U_DLY 'd1;
//            else
//                dfifo_wrdata[0] <= #U_DLY 'd0;
//        end
//        else
//            ;
    end
end
end end else begin:aminb_if

assign mux_data = ififo_rddata[WIDTH_MBYTE-1:WIDTH_SBYTE];

if(WIDTH_DUSER>0)begin:minhasuser_if

for(i=0;i<NUM_SUB;i=i+1) begin:hasuserdata_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wrdata[(WIDTH_MDATA/8+WIDTH_DUSER+1+i*WIDTH_SDATA)+:WIDTH_SDATA] <= #U_DLY 'd0;
        dfifo_wrdata[(WIDTH_DUSER+1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY 'd0;
    end
    else begin
        if(stp_cnt == i[WIDTH_SUB-1:0]) begin
            dfifo_wrdata[(WIDTH_MDATA/8+WIDTH_DUSER+1+i*WIDTH_SDATA)+:WIDTH_SDATA] <= #U_DLY s_reqddata;
            dfifo_wrdata[(WIDTH_DUSER+1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY s_reqdstrob;
        end
        else 
            dfifo_wrdata[(WIDTH_DUSER+1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY 'd0;
    end
end
            
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wren <= #U_DLY 'd0;
        dfifo_wrdata[WIDTH_DUSER:1] <= #U_DLY 'd0;
    end
    else begin
        if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT))
            dfifo_wren <= #U_DLY 'd1;
        else
            dfifo_wren <= #U_DLY 'd0;

        dfifo_wrdata[1+:WIDTH_DUSER] <= #U_DLY s_reqduser;
    end
end

end else begin:minnouser_if

for(i=0;i<NUM_SUB;i=i+1) begin:hasuserdata_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wrdata[(WIDTH_MDATA/8+1+i*WIDTH_SDATA)+:WIDTH_SDATA] <= #U_DLY 'd0;
        dfifo_wrdata[(1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY 'd0;
    end
    else begin
        if(stp_cnt == i[WIDTH_SUB-1:0]) begin
            dfifo_wrdata[(WIDTH_MDATA/8+1+i*WIDTH_SDATA)+:WIDTH_SDATA] <= #U_DLY s_reqddata;
            dfifo_wrdata[(1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY s_reqdstrob;
        end
        else 
            dfifo_wrdata[(WIDTH_DUSER+1+i*WIDTH_SDATA/8)+:WIDTH_SDATA/8] <= #U_DLY 'd0;
    end
end
            
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        dfifo_wren <= #U_DLY 'd0;
    else begin
        if(~dfifo_pfull && s_reqdvalid && (cstate == WAIT))
            dfifo_wren <= #U_DLY 'd1;
        else
            dfifo_wren <= #U_DLY 'd0;
    end
end

end end

if(WIDTH_DUSER>0)begin:hasuser_if
assign m_reqdwuser  = dfifo_rddata[WIDTH_DUSER-1:0];
end else begin:nouser_if
assign m_reqdwuser  = 'd0;
end

endgenerate

assign m_reqdwdata  = dfifo_rddata[(WIDTH_DUSER+1+WIDTH_MDATA/8)+:WIDTH_MDATA];
assign m_reqdwstrob = dfifo_rddata[(WIDTH_DUSER+1)+:(WIDTH_MDATA/8)];
assign m_reqdwlast  = dfifo_rddata[WIDTH_DUSER];
assign m_reqdwvalid = ~dfifo_empty;

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_MDATA+WIDTH_MDATA/8+1+WIDTH_DUSER), // It must be a multiple of 8.
    .PA_AW                          (2                          ), 
    .PB_DW                          (WIDTH_MDATA+WIDTH_MDATA/8+1+WIDTH_DUSER), // It must be a multiple of PA_DW.
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
    .wr_en                          (dfifo_wren                 ), // (input )
    .wr_data                        (dfifo_wrdata               ), // (input )
    .prog_data                      ('d2                        ), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (dfifo_pfull                ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (m_reqdwvalid&m_reqdwready  ), // (input )
    .rd_data                        (dfifo_rddata               ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (dfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);

axi_interconnect_fifogen #
(
    .PA_DW                          (19                         ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING          ), 
    .PB_DW                          (19                         ), // It must be a multiple of PA_DW.
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
    .wr_en                          (split_en                   ), // (input )
    .wr_data                        ({split_size,split_len,split_offset}), // (input )
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


function integer CLOG2 ;
input integer d;
begin
    CLOG2 = 0;
    while((2**CLOG2) < d)
        CLOG2 = CLOG2 + 1;
end
endfunction

endmodule







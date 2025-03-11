// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/11 15:45:36
// File Name    : axi_interconnect_width_convert_reqaddr.v
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
// axi_interconnect_width_convert_reqaddr
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_width_convert_reqaddr #
(
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDR          = 32    ,
    parameter                           WIDTH_MDATA         = 32    ,
    parameter                           WIDTH_AUSER         = 1     ,

    parameter                           W_ID                = (WIDTH_ID > 0) ? WIDTH_ID : 'd1,
    parameter                           W_AUSER             = (WIDTH_AUSER > 0) ? WIDTH_AUSER : 'd1,
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
    output                              split_en                    , 
    output                        [7:0] split_len                   , 
    output                        [7:0] split_offset                , 
    output reg                    [2:0] split_size                  , 
    output reg                          split_tlast                 , 
// ---------------------------------------------------------------------------------
// Slave AXI4
// ---------------------------------------------------------------------------------
    input                    [W_ID-1:0] s_reqaid                    , 
    input              [WIDTH_ADDR-1:0] s_reqaaddr                  , 
    input                       [8-1:0] s_reqalen                   , 
    input                       [3-1:0] s_reqasize                  , 
    input                       [2-1:0] s_reqaburst                 , 
    input                       [4-1:0] s_reqaregion                , 
    input                               s_reqalock                  , 
    input                       [4-1:0] s_reqacache                 , 
    input                       [3-1:0] s_reqaprot                  , 
    input                       [4-1:0] s_reqaqos                   , 
    input                 [W_AUSER-1:0] s_reqauser                  , 
    input                               s_reqavalid                 , 
    output reg                          s_reqaready                 , 
// ---------------------------------------------------------------------------------
// Master AXI4
// ---------------------------------------------------------------------------------
    output reg               [W_ID-1:0] m_reqaid                    , 
    output reg         [WIDTH_ADDR-1:0] m_reqaaddr                  , 
    output reg                  [8-1:0] m_reqalen                   , 
    output reg                  [3-1:0] m_reqasize                  , 
    output reg                  [2-1:0] m_reqaburst                 , 
    output reg                  [4-1:0] m_reqaregion                , 
    output reg                          m_reqalock                  , 
    output reg                  [4-1:0] m_reqacache                 , 
    output reg                  [3-1:0] m_reqaprot                  , 
    output reg                  [4-1:0] m_reqaqos                   , 
    output reg            [W_AUSER-1:0] m_reqauser                  , 
    output reg                          m_reqavalid                 , 
    input                               m_reqaready                   
);

localparam IDLE      = 1'b0;
localparam WAIT      = 1'b1;
localparam MAX_MSIZE = CLOG2(WIDTH_MDATA/8);

reg                                     cstate                      ; 
reg                                     nstate                      ; 

reg                              [15:0] max_burst_len               ; 
reg                              [15:0] remain_len                  ; 
reg                              [15:0] remain_len_last             ; 
reg                    [WIDTH_ADDR-1:0] boundary_mask               ; 
 
always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        cstate <= #U_DLY IDLE;
    else
        cstate <= #U_DLY nstate;
end

always @ (*)
case(cstate)
    IDLE    : nstate = (~s_reqaready && s_reqavalid) ? WAIT : IDLE; 
    WAIT    : nstate = (m_reqaready && (remain_len_last <= max_burst_len)) ? IDLE : WAIT;
    default : nstate = IDLE;
endcase

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) 
        s_reqaready <= #U_DLY 'd0;
    else begin
        if(s_reqaready & s_reqavalid)
            s_reqaready <= #U_DLY 'd0;
        else if((cstate == WAIT) && m_reqaready && (remain_len_last <= max_burst_len))
            s_reqaready <= #U_DLY 'd1;
        else
            ;
    end
end

always @ (*) begin
    if(m_reqaready && m_reqavalid)
        remain_len = remain_len_last - m_reqalen - 'd1;
    else
        remain_len = remain_len_last;
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        max_burst_len <= #U_DLY 'd0;
        remain_len_last <= #U_DLY 'd0;
    end
    else begin
        if(s_reqaburst == 2'd01)
            max_burst_len <= #U_DLY 'd256;
        else
            max_burst_len <= #U_DLY 'd16;

        if(s_reqavalid && (cstate == IDLE))
            remain_len_last <= #U_DLY (s_reqalen + 'd1) * (1<<(s_reqasize - m_reqasize));
        else
            remain_len_last <= #U_DLY remain_len;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        boundary_mask <= #U_DLY 'd0;
    else begin
        boundary_mask <= #U_DLY s_reqaaddr + (s_reqalen + 'd1)*(1<<s_reqasize) - 'd1;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        m_reqaid <= #U_DLY 'd0;
        m_reqaaddr <= #U_DLY 'd0;
        m_reqalen <= #U_DLY 'd0;
        m_reqasize <= #U_DLY 'd0;
        m_reqaburst <= #U_DLY 'd0;
        m_reqaregion <= #U_DLY 'd0;
        m_reqalock <= #U_DLY 'd0;
        m_reqacache <= #U_DLY 'd0;
        m_reqaprot <= #U_DLY 'd0;
        m_reqaqos <= #U_DLY 'd0;
        m_reqauser <= #U_DLY 'd0;
        m_reqavalid <= #U_DLY 'd0;
    end 
    else begin
        m_reqaid <= #U_DLY s_reqaid;
        m_reqaburst <= #U_DLY s_reqaburst;
        m_reqaregion <= #U_DLY s_reqaregion;
        m_reqalock <= #U_DLY s_reqalock;
        m_reqacache <= #U_DLY s_reqacache;
        m_reqaprot <= #U_DLY s_reqaprot;
        m_reqaqos <= #U_DLY s_reqaqos;
        m_reqauser <= #U_DLY s_reqauser;
        
        if(s_reqasize <= MAX_MSIZE)
            m_reqasize <= #U_DLY s_reqasize;
        else
            m_reqasize <= #U_DLY MAX_MSIZE;

        if(s_reqaburst == 2'd01) begin
            if(remain_len > 'd256)
                m_reqalen <= #U_DLY 'd255;
            else
                m_reqalen <= #U_DLY remain_len[7:0] - 'd1;
        end
        else begin
            if(remain_len > 'd16)
                m_reqalen <= #U_DLY 'd15;
            else
                m_reqalen <= #U_DLY {4'd0,remain_len[3:0]} - 'd1;
        end

        if(s_reqavalid && (cstate == IDLE))
            m_reqaaddr <= #U_DLY s_reqaaddr;
        else if(m_reqaready && m_reqavalid)
            case(s_reqaburst)
                2'b01   : m_reqaaddr <= #U_DLY m_reqaaddr + (m_reqalen + 'd1) * (1<<m_reqasize);
                2'b10   : m_reqaaddr <= #U_DLY boundary_mask & (m_reqaaddr + (m_reqalen + 'd1) * (1<<m_reqasize));
                default :;
            endcase
        else
            ;
        
        if(m_reqaready && m_reqavalid)
            m_reqavalid <= #U_DLY 'd0;
        else if(cstate == WAIT)   
            m_reqavalid <= #U_DLY 'd1;
        else
            ;
    end
end

assign split_en = m_reqaready && m_reqavalid;
assign split_len = m_reqalen;
assign split_offset = m_reqaaddr[7:0];

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        split_size <= #U_DLY 'd0;
        split_tlast <= #U_DLY 'd0;
    end
    else begin
        if(s_reqasize <= MAX_MSIZE)
            split_size <= #U_DLY 'd0;
        else
            split_size <= #U_DLY s_reqasize - MAX_MSIZE;

        if((remain_len <= max_burst_len) && (cstate == WAIT))
            split_tlast <= #U_DLY 'd1;
        else
            split_tlast <= #U_DLY 'd0;
    end
end

function integer CLOG2 ;
input integer d;
begin
    CLOG2 = 0;
    while((2**CLOG2) < d)
        CLOG2 = CLOG2 + 1;
end
endfunction

endmodule







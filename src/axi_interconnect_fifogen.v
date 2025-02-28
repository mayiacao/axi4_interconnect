// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/17 12:26:20
// File Name    : axi_interconnect_fifogen.v
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
// axi_interconnect_fifogen
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_fifogen #
(
    parameter                           PA_DW = 8                   , // It must be a multiple of 8.
    parameter                           PA_AW = 8                   , // Must not be less than log2(PB_DW/PA_DW).
    parameter                           PB_DW = 16                  , // It must be a multiple of PA_DW.
    parameter                           RD_AS_ACK = "TRUE"          , // "TRUE" OR "FALSE"
    parameter                           CLOCK_ASYNC = "TRUE"        , // 
    parameter                           PIPLI_STAGE = 2             , //Must be >= 2  
    parameter                           PA_DEPTH = 2**PA_AW         ,
    parameter                           PB_AW = LOG2(PA_DW*PA_DEPTH/PB_DW-1),  
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_wr                      , 
    input                               clk_rd                      , 
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Write Control & Status
// ---------------------------------------------------------------------------------
    input                               wr_en                       , 
    input                   [PA_DW-1:0] wr_data                     , 
    input                   [PA_AW-1:0] prog_data                   , 
    output reg              [PA_AW-1:0] wr_cnt                      , 
    output reg                          full                        , 
    output reg                          pfull                       , 
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    input                               rd_en                       , 
    output reg              [PB_DW-1:0] rd_data                     , 
    output reg              [PB_AW-1:0] rd_cnt                      , 
    output reg                          empty                       , 
    output reg                          aempty                
);

localparam SUB_ABDW = (PA_DW > PB_DW) ? PA_DW/PB_DW : PB_DW/PA_DW;
localparam SUB_ABAW = (PA_DW > PB_DW) ? PB_AW-PA_AW : PA_AW-PB_AW;
localparam MEM_DW = (PA_DW > PB_DW) ? PB_DW : PA_DW;
localparam MEM_AW = (PA_DW > PB_DW) ? PA_AW : PB_AW;
localparam MEM_DEPTH = 2 ** MEM_AW;

reg                         [MEM_DW-1:0] mem [MEM_DEPTH-1:0]        ; 

wire                                    clk_pb                      ; 

reg                           [PA_AW:0] wrptr                       ; 
reg                           [PA_AW:0] wrptr_next                  ; 
wire              [SUB_ABDW*MEM_AW-1:0] wraddr                      ; 

reg                           [PB_AW:0] rdptr                       ; 
reg                           [PB_AW:0] rdptr_next                  ; 
wire              [SUB_ABDW*MEM_AW-1:0] rdaddr                      ; 

wire                          [PA_AW:0] wrcnt_next                  ; 
wire                          [PB_AW:0] rdcnt_next                  ; 


genvar                                  i                           ;

generate
for(i=0;i<MEM_DEPTH;i=i+1) begin:init_loop
initial mem[i] = 0;
end
endgenerate

always @ (*) begin
    if(~full && wr_en)
        wrptr_next = wrptr + {{PA_AW{1'b0}},1'b1};
    else
        wrptr_next = wrptr;
end

always @ (posedge clk_wr or negedge rst_n) begin
    if(~rst_n)
        wrptr <= #U_DLY {(PA_AW+1){1'b0}};
    else 
        wrptr <= #U_DLY wrptr_next;
end

always @ (*) begin
    if(~empty && rd_en)
        rdptr_next = rdptr + {{PB_AW{1'b0}},1'b1};
    else
        rdptr_next = rdptr;
end

always @ (posedge clk_pb or negedge rst_n) begin
    if(rst_n == 1'b0) 
        rdptr <= #U_DLY {(PB_AW+1){1'b0}};
    else 
        rdptr <= #U_DLY rdptr_next;
end

always @ (posedge clk_wr or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        full <= #U_DLY 1'b0;
        pfull <= #U_DLY 1'b0;
        wr_cnt <= #U_DLY {PA_AW{1'b0}};
    end
    else begin
        if(wrcnt_next >= {1'b0,{PA_AW{1'b1}}})
            full <= #U_DLY 1'b1;
        else
            full <= #U_DLY 1'b0;

        if(wrcnt_next >= {1'b0,prog_data})
            pfull <= #U_DLY 1'b1;
        else
            pfull <= #U_DLY 1'b0;

        wr_cnt <= #U_DLY wrcnt_next;
    end
end

always @ (posedge clk_pb or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        empty <= #U_DLY 1'b1;
        aempty <= #U_DLY 1'b1;
        rd_cnt <= #U_DLY {PB_AW{1'b0}};
    end
    else begin
        if(rdcnt_next <= {{(PB_AW+1){1'b0}}})
            empty <= #U_DLY 1'b1;
        else
            empty <= #U_DLY 1'b0;

        if(rdcnt_next <= {{PB_AW{1'b0}},1'b1})
            aempty <= #U_DLY 1'b1;
        else
            aempty <= #U_DLY 1'b0;

        rd_cnt <= #U_DLY rdcnt_next;
    end
end

generate
if(CLOCK_ASYNC == "TRUE") begin:async_if

assign clk_pb = clk_rd;

end else begin:sync_if

assign clk_pb = clk_wr;

end


if(PA_DW >= PB_DW) begin : max2min_if
for(i=0;i<SUB_ABDW;i=i+1) begin:subamaxb_loop

assign wraddr[i*MEM_AW+:MEM_AW] = {wrptr,{SUB_ABAW{1'b0}}} + i;

always @(posedge clk_wr) begin
    if(~full && wr_en)
        mem[wraddr[i*MEM_AW+:MEM_AW]] <= #U_DLY wr_data[i*MEM_DW +:MEM_DW];
    else
        ;
end
end 


if(RD_AS_ACK == "FALSE") begin:rdreq_if

assign rdaddr[0*MEM_AW+:MEM_AW] = rdptr[MEM_AW-1:0];

always @(posedge clk_pb or negedge rst_n) begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY {PB_DW{1'b0}};
    else begin
        if(~empty && rd_en)
            rd_data <= #U_DLY mem[rdaddr[0*MEM_AW+:MEM_AW]];
        else
            ;        
    end
end

end else begin:rdack_if

assign rdaddr[0*MEM_AW+:MEM_AW] = rdptr_next[MEM_AW-1:0];

always @(posedge clk_pb or negedge rst_n) begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY {PB_DW{1'b0}};
    else begin
        rd_data <= #U_DLY mem[rdaddr[0*MEM_AW+:MEM_AW]];
    end
end

end


if(CLOCK_ASYNC == "FALSE") begin:wr_as_clk_sync_if

assign wrcnt_next = wrptr_next - rdptr_next[PB_AW:SUB_ABAW];
assign rdcnt_next = {wrptr,{SUB_ABAW{1'b0}}} - rdptr_next;

end else begin:wr_as_clk_async_if

wire                          [PB_AW:0] rdptr_gray                  ; 
wire                          [PB_AW:0] rdptr_bin                   ; 

wire                          [PA_AW:0] wrptr_gray                  ; 
wire                          [PA_AW:0] wrptr_bin                   ; 

axi_interconnect_fifogen_dec2gray #
(
    .PIPLE_LINE                     (PIPLI_STAGE                ), // 
    .DW                             (PB_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_asfifo_dec2gray
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_wr                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Dec In
// ---------------------------------------------------------------------------------
    .idata                          (rdptr                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray Out
// ---------------------------------------------------------------------------------
    .odata                          (rdptr_gray                 )  // (output)
); 

axi_interconnect_fifogen_gray2dec #
(
    .PIPLE_LINE                     (1                          ), // 
    .DW                             (PB_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_asfifo_gray2dec
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_wr                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray In
// ---------------------------------------------------------------------------------
    .idata                          (rdptr_gray                 ), // (input )
// ---------------------------------------------------------------------------------
// Dec Out
// ---------------------------------------------------------------------------------
    .odata                          (rdptr_bin                  )  // (output)
);

axi_interconnect_fifogen_dec2gray #
(
    .PIPLE_LINE                     (PIPLI_STAGE                ), // 
    .DW                             (PA_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_asfifo_dec2gray
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_pb                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Dec In
// ---------------------------------------------------------------------------------
    .idata                          (wrptr                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray Out
// ---------------------------------------------------------------------------------
    .odata                          (wrptr_gray                 )  // (output)
); 

axi_interconnect_fifogen_gray2dec #
(
    .PIPLE_LINE                     (1                          ), // 
    .DW                             (PA_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_asfifo_gray2dec
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_pb                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray In
// ---------------------------------------------------------------------------------
    .idata                          (wrptr_gray                 ), // (input )
// ---------------------------------------------------------------------------------
// Dec Out
// ---------------------------------------------------------------------------------
    .odata                          (wrptr_bin                  )  // (output)
);

assign wrcnt_next = wrptr_next - rdptr_bin[PB_AW:SUB_ABAW];
assign rdcnt_next = {wrptr_bin,{SUB_ABAW{1'b0}}} - rdptr_next;

end end else begin:min2max_if

assign wraddr[0*MEM_AW+:MEM_AW] = wrptr[MEM_AW-1:0];

always @(posedge clk_wr) begin
    if(~full && wr_en)
        mem[wraddr[0*MEM_AW+:MEM_AW]] <= #U_DLY wr_data;
    else
        ;
end


for(i=0;i<SUB_ABDW;i=i+1) begin:subaminb_loop
if(RD_AS_ACK == "FALSE") begin:rdreq1_if

assign rdaddr[i*MEM_AW+:MEM_AW] = {rdptr,{SUB_ABAW{1'b0}}} + i;

always @(posedge clk_pb or negedge rst_n) begin
    if(rst_n == 1'b0)
        rd_data[i*MEM_DW+:MEM_DW] <= #U_DLY {MEM_DW{1'b0}};
    else begin
        if(~empty && rd_en)
            rd_data[i*MEM_DW+:MEM_DW] <= #U_DLY mem[rdaddr[i*MEM_AW+:MEM_AW]];
        else
            ;        
    end
end

end else begin:rdack1_if

assign rdaddr[i*MEM_AW+:MEM_AW] = {rdptr_next,{SUB_ABAW{1'b0}}} + i;

always @(posedge clk_pb or negedge rst_n) begin
    if(rst_n == 1'b0)
        rd_data[i*MEM_DW+:MEM_DW] <= #U_DLY {MEM_DW{1'b0}};
    else begin
        rd_data[i*MEM_DW+:MEM_DW] <= #U_DLY mem[rdaddr[i*MEM_AW+:MEM_AW]];
    end
end

end end 

if(CLOCK_ASYNC == "FALSE") begin:wr_as_clk_sync1_if

assign wrcnt_next = wrptr_next - {rdptr_next,{SUB_ABAW{1'b0}}};
assign rdcnt_next = wrptr[PA_AW:SUB_ABAW] - rdptr_next;

end else begin:wr_as_clk_async1_if

wire                          [PB_AW:0] rdptr_gray                  ; 
wire                          [PB_AW:0] rdptr_bin                   ; 

wire                          [PA_AW:0] wrptr_gray                  ; 
wire                          [PA_AW:0] wrptr_bin                   ; 

axi_interconnect_fifogen_dec2gray #
(
    .PIPLE_LINE                     (PIPLI_STAGE                ), // 
    .DW                             (PB_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_asfifo_dec2gray
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_wr                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Dec In
// ---------------------------------------------------------------------------------
    .idata                          (rdptr                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray Out
// ---------------------------------------------------------------------------------
    .odata                          (rdptr_gray                 )  // (output)
); 

axi_interconnect_fifogen_gray2dec #
(
    .PIPLE_LINE                     (1                          ), // 
    .DW                             (PB_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u0_asfifo_gray2dec
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_wr                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray In
// ---------------------------------------------------------------------------------
    .idata                          (rdptr_gray                 ), // (input )
// ---------------------------------------------------------------------------------
// Dec Out
// ---------------------------------------------------------------------------------
    .odata                          (rdptr_bin                  )  // (output)
);

axi_interconnect_fifogen_dec2gray #
(
    .PIPLE_LINE                     (PIPLI_STAGE                ), // 
    .DW                             (PA_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_asfifo_dec2gray
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_pb                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Dec In
// ---------------------------------------------------------------------------------
    .idata                          (wrptr                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray Out
// ---------------------------------------------------------------------------------
    .odata                          (wrptr_gray                 )  // (output)
); 

axi_interconnect_fifogen_gray2dec #
(
    .PIPLE_LINE                     (1                          ), // 
    .DW                             (PA_AW+1                    ), 
    .U_DLY                          (U_DLY                      )  // 
)
u1_asfifo_gray2dec
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_pb                     ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Gray In
// ---------------------------------------------------------------------------------
    .idata                          (wrptr_gray                 ), // (input )
// ---------------------------------------------------------------------------------
// Dec Out
// ---------------------------------------------------------------------------------
    .odata                          (wrptr_bin                  )  // (output)
);

assign wrcnt_next = wrptr_next - {rdptr_bin,{SUB_ABAW{1'b0}}};
assign rdcnt_next = wrptr_bin[PA_AW:SUB_ABAW] - rdptr_next;

end end
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



// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/17 12:26:56
// File Name    : axi_interconnect_fifogen_dec2gray.v
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
// axi_interconnect_fifogen_dec2gray
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_fifogen_dec2gray #
(
    parameter                           PIPLE_LINE = 1              , // 
    parameter                           DW = 16                     ,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Dec In
// ---------------------------------------------------------------------------------
    input                      [DW-1:0] idata                       , 
// ---------------------------------------------------------------------------------
// Gray Out
// ---------------------------------------------------------------------------------
    output                     [DW-1:0] odata                         
); 

genvar                                  i                           ;


generate
if(PIPLE_LINE == 0) begin:zero_p_if

reg                            [DW-1:0] odata_tmp                   ; 

always @ (*) odata_tmp = {1'b0,idata[DW-1:1]} ^ idata[DW-1:0];

assign odata = odata_tmp;

end
else if(PIPLE_LINE == 1) begin:one_p_if

reg                            [DW-1:0] odata_tmp                   ; 
reg                            [DW-1:0] odata_reg                   ; 

always @ (*) odata_tmp = {1'b0,idata[DW-1:1]} ^ idata[DW-1:0];

always @ (posedge clk_sys or negedge rst_n) begin
    if(rst_n == 1'b0)
        odata_reg <= #U_DLY {DW{1'd0}};
    else
        odata_reg <= #U_DLY odata_tmp;
end

assign odata = odata_tmp;

end
else begin : other_if

reg                            [DW-1:0] odata_tmp                   ; 
reg                            [DW-1:0] odata_reg [PIPLE_LINE-1:0]  ; 

always @ (*) odata_tmp = {1'b0,idata[DW-1:1]} ^ idata[DW-1:0];

always @ (posedge clk_sys or negedge rst_n) begin
    if(rst_n == 1'b0)
        odata_reg[PIPLE_LINE-1] <= #U_DLY {DW{1'd0}};
    else
        odata_reg[PIPLE_LINE-1] <= #U_DLY odata_tmp;
end

for(i=0;i<PIPLE_LINE-1;i=i+1) begin:piple_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(rst_n == 1'b0)
        odata_reg[i] <= #U_DLY {DW{1'd0}};
    else
        odata_reg[i] <= #U_DLY odata_reg[i+1];
end

end

assign odata = odata_reg[0];

end
endgenerate

endmodule


// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/18 10:01:36
// File Name    : axi_interconnect_crossbar_arbit_polling.v
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
// axi_interconnect_crossbar_arbit_polling
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_arbit_polling #
(
    parameter                           NUM         = 1             , //
    parameter                           WIDTH       = LOG2(NUM-1)
)
(
// ---------------------------------------------------------------------------------
// Aribit User
// ---------------------------------------------------------------------------------
    input                     [NUM-1:0] user_req                    , 
    input                   [WIDTH-1:0] last_user                   , 
// ---------------------------------------------------------------------------------
// Aribit Result
// ---------------------------------------------------------------------------------
    output                  [WIDTH-1:0] current_user                  
);

wire                        [WIDTH-1:0] last_user_temp              ; 
wire                          [NUM-1:0] user_base                   ; 
wire                        [2*NUM-1:0] double_req                  ; 
wire                        [2*NUM-1:0] double_gnt                  ; 
wire                          [NUM-1:0] gnt                         ; 

wire                        [WIDTH-1:0] cuer_tmp0 [NUM-1:0]         ; 
wire                          [NUM-1:0] cuer_tmp1 [WIDTH-1:0]       ; 

genvar                                  i                           ;
genvar                                  j                           ;

assign last_user_temp = last_user-1;
assign user_base = 1'b1 << last_user_temp;
//assign user_base = 1'b1 << (last_user);
assign double_req = {user_req,user_req};
assign double_gnt = ~(double_req - user_base) & double_req;
assign gnt = double_gnt[0+:NUM] | double_gnt[NUM+:NUM];

generate
for(i=0;i<NUM;i=i+1) begin:onehot2dec_loop

assign cuer_tmp0[i] = gnt[i] ? i[WIDTH-1:0] : 'd0; 

for(j=0;j<WIDTH;j=j+1) begin:bitswitch_loop

assign cuer_tmp1[j][i] = cuer_tmp0[i][j];

end end

for(i=0;i<WIDTH;i=i+1) begin:bitand_loop

assign current_user[i] =  |cuer_tmp1[i];

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



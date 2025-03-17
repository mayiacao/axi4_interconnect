// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/23 11:23:47
// File Name    : axi_interconnect_tb.v
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
// axi_interconnect_tb
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_tb #
(
    parameter                           U_DLY = 1                     // 
);

localparam NUM = 8;
localparam WIDTH = $clog2(NUM);

reg                                     clk_sys                     ; 
reg                                     rst_n                       ; 

reg                           [NUM-1:0] user_req                    ; 
reg                         [WIDTH-1:0] last_user                   ; 
wire                        [WIDTH-1:0] current_user                ; 

initial begin
    clk_sys = 0;
    rst_n = 'd0;
    #1000;
    rst_n = 'd1;
    user_req = 'd0;
    forever begin
        @(posedge clk_sys);
        user_req <= #U_DLY $random()%(2**NUM);
    end
end

initial begin
    forever  begin
        @(posedge clk_sys);
        check_pooling();
    end
end

always #5 clk_sys = ~clk_sys;

always @ (posedge clk_sys)
    if(~rst_n)
        last_user <= #U_DLY 'd0;
    else
        last_user <= #U_DLY current_user;


task check_pooling;
reg flag;
integer i,j;
begin
    flag = 0;
    i=0;
    j=last_user;
    if(j < 2**WIDTH-1)
        j=j+1;
    else
        j = 0;

     while(~user_req[j] && i < 2**WIDTH) begin
        i=i+1;
        if(j < 2**WIDTH-1)
            j=j+1;
        else
            j = 0;
    end


    if (i >= 2**WIDTH)
        flag = 1;

 //   if(flag)
 //       $display("[DBG Info 0]:There is no input request in the current period.\n");
 //   else begin
    if(~flag && (j != current_user))
        $display("[DBG Info 1]:The DUT output result is incorrect!, current_user = %d,j=%d\n",current_user,j,);
//    end
end
endtask

axi_interconnect_crossbar_arbit_polling #
(
    .NUM                            (NUM                        )  //
)
u_axi_interconnect_crossbar_arbit_polling
(
// ---------------------------------------------------------------------------------
// Aribit User
// ---------------------------------------------------------------------------------
    .user_req                       (user_req                   ), // (input )
    .last_user                      (last_user                  ), // (input )
// ---------------------------------------------------------------------------------
// Aribit Result
// ---------------------------------------------------------------------------------
    .current_user                   (current_user               )  // (output)
);

endmodule






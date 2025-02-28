// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/17 12:29:43
// File Name    : axi_interconnect_crossbar_sreq_arbit.v
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
// axi_interconnect_crossbar_sreq_arbit
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_sreq_arbit #
(
    parameter                           MODE_READ           = 1     ,
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           NUM_MASTER          = 1     , // 0 ~ 4
    parameter                           WIDTH_ADDRINFO      = 64    ,   
    parameter                           WIDTH_DATAINFO      = 48    ,
    parameter                           NUM_OUTSTANDING     = 4     ,
    parameter                           WIDTH_OUTSTANDING   = LOG2(NUM_OUTSTANDING-1),
    parameter                           WIDTH_SALVE         = LOG2(NUM_SLAVE-1),
    parameter                           WIDTH_MASTER        = LOG2(NUM_MASTER-1),
    parameter                           U_DLY = 1                      
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    input     [NUM_SLAVE*WIDTH_ADDRINFO-1:0] s_addr_info            , 
    input               [NUM_SLAVE-1:0] s_addr_valid                , 
    output reg          [NUM_SLAVE-1:0] s_addr_ready                , 

(*keep = "true",mark_debug = "true"*)    input     [NUM_SLAVE*WIDTH_DATAINFO-1:0] s_wdata_info           , 
(*keep = "true",mark_debug = "true"*)    input               [NUM_SLAVE-1:0] s_wdata_valid               , 
(*keep = "true",mark_debug = "true"*)    output reg          [NUM_SLAVE-1:0] s_wdata_ready               , 
// ---------------------------------------------------------------------------------
// Master Port
// ---------------------------------------------------------------------------------
    output reg[WIDTH_ADDRINFO+WIDTH_SALVE-1:0] addr_info            , 
    output reg                          addr_valid                  , 
    input                               addr_ready                  , 

(*keep = "true",mark_debug = "true"*)     output         [WIDTH_DATAINFO-1:0] wdata_info                  , 
(*keep = "true",mark_debug = "true"*)     output                              wdata_valid                 , 
(*keep = "true",mark_debug = "true"*)     input                               wdata_ready                   
);

reg                   [WIDTH_SALVE-1:0] luser                       ; 
(*keep = "true",mark_debug = "true"*) wire                  [WIDTH_SALVE-1:0] cuser                       ; 
genvar                                  i                           ;


always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        luser <= #U_DLY {WIDTH_SALVE{1'b1}};
       // luser <= #U_DLY 'd0;
    else begin
        if(addr_ready)
            luser <= #U_DLY cuser;
        else
            ;
    end
end

always @ (*)  begin
    if(addr_ready)
        s_addr_ready = 1'd1 << cuser;
    else
        s_addr_ready = 'd0;
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        addr_info <= #U_DLY 'd0;
        addr_valid <= #U_DLY 'd0;
    end
    else begin
        if(addr_ready)
            addr_info <= #U_DLY {s_addr_info[cuser*WIDTH_ADDRINFO+:WIDTH_ADDRINFO],cuser};
        else
            ;

        if(addr_ready & s_addr_valid[cuser])
            addr_valid <= #U_DLY 'd1;
        else if(addr_ready)
            addr_valid <= #U_DLY 'd0;
        else
            ;
    end
end

axi_interconnect_crossbar_arbit_polling #
(
    .NUM                            (NUM_SLAVE                  ), //
    .WIDTH                          (WIDTH_SALVE                )  
)
u_axi_interconnect_crossbar_arbit_polling
(
// ---------------------------------------------------------------------------------
// Aribit User
// ---------------------------------------------------------------------------------
    .user_req                       (s_addr_valid               ), // (input )
    .last_user                      (luser                      ), // (input )
// ---------------------------------------------------------------------------------
// Aribit Result
// ---------------------------------------------------------------------------------
    .current_user                   (cuser                      )  // (output)
);

generate 
if(MODE_READ == 0) begin:wdata_if

(*keep = "true",mark_debug = "true"*) reg                     [NUM_SLAVE-1:0] ififo_wren_temp             ; 
(*keep = "true",mark_debug = "true"*) wire                                    ififo_wren                  ;
(*keep = "true",mark_debug = "true"*) reg                                     ififo_rden                  ; 
(*keep = "true",mark_debug = "true"*) wire                  [WIDTH_SALVE-1:0] ififo_rddata                ; 
(*keep = "true",mark_debug = "true"*) wire                                    ififo_empty                 ; 

reg                                     dfifo_wren                  ; 
reg                [WIDTH_DATAINFO-1:0] dfifo_wrdata                ; 
wire                                    dfifo_pfull                 ; 
wire                                    dfifo_empty                 ; 

for(i=0;i<NUM_SLAVE;i=i+1) begin:slave_loop

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        ififo_wren_temp[i] <= #U_DLY 'd0;
    else begin
        if(s_addr_valid[i] & s_addr_ready[i])
            ififo_wren_temp[i] <= #U_DLY 'd1;
        else
            ififo_wren_temp[i] <= #U_DLY 'd0;
    end
end

end 

assign ififo_wren = |ififo_wren_temp;

always @ (*) begin
if(~ififo_empty && (~dfifo_pfull))
    s_wdata_ready = 1'd1 << ififo_rddata;
else
    s_wdata_ready = 'd0;
end

always @ (*) begin
    if(s_wdata_info[ififo_rddata*WIDTH_DATAINFO+(WIDTH_DATAINFO-1)] && 
       s_wdata_valid[ififo_rddata] && s_wdata_ready[ififo_rddata])
        ififo_rden <= #U_DLY 'd1;
    else
        ififo_rden <= #U_DLY 'd0;
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        dfifo_wren <= #U_DLY 'd0;
        dfifo_wrdata <= #U_DLY 'd0;
    end
    else begin
            if(s_wdata_valid[ififo_rddata] && s_wdata_ready[ififo_rddata])
                dfifo_wren <= #U_DLY 'd1;
            else
                dfifo_wren <= #U_DLY 'd0;

            dfifo_wrdata <= #U_DLY s_wdata_info[ififo_rddata*WIDTH_DATAINFO+:WIDTH_DATAINFO];
    end
end

assign wdata_valid = ~dfifo_empty;

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_SALVE                ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING+WIDTH_MASTER), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_SALVE                ), // It must be a multiple of PA_DW.
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
    .wr_en                          (ififo_wren                 ), // (input )
    .wr_data                        (luser                      ), // (input )
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

axi_interconnect_fifogen #
(
    .PA_DW                          (WIDTH_DATAINFO                ), // It must be a multiple of 8.
    .PA_AW                          (WIDTH_OUTSTANDING+WIDTH_MASTER), // Must not be less than log2(PB_DW/PA_DW).
    .PB_DW                          (WIDTH_DATAINFO                ), // It must be a multiple of PA_DW.
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
    .prog_data                      (('d1<<(WIDTH_OUTSTANDING+WIDTH_MASTER))-'d2), // (input )
    .wr_cnt                         (                           ), // (output)
    .full                           (                           ), // (output)
    .pfull                          (dfifo_pfull                ), // (output)
// ---------------------------------------------------------------------------------
// Read Control & Status
// ---------------------------------------------------------------------------------
    .rd_en                          (wdata_valid&wdata_ready    ), // (input )
    .rd_data                        (wdata_info                 ), // (output)
    .rd_cnt                         (                           ), // (output)
    .empty                          (dfifo_empty                ), // (output)
    .aempty                         (                           )  // (output)
);

end else begin:rdata_if

always @ (*) s_wdata_ready = 'd0;
assign wdata_info = 'd0;
assign wdata_valid = 'd0;

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





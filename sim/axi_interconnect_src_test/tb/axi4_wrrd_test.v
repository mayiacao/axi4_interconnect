// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/02/19 09:30:46
// File Name    : axi4_wrrd_test.v
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
// axi4_wrrd_test
//    |---
// 
`timescale 1ns/1ps

module axi4_wrrd_test #
(
    parameter                           IDW = 4                     ,
    parameter                           DW = 32                     ,
    parameter                           DEW = DW/8                  ,
    parameter                           AW = 32                     ,
    parameter                           MEM_AW = 10                 ,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_sys                     ,
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// AXI-4
// ---------------------------------------------------------------------------------
    input                     [IDW-1:0] axi4_awid                   , 
    input                      [AW-1:0] axi4_awaddr                 , 
    input                       [8-1:0] axi4_awlen                  , 
    input                       [3-1:0] axi4_awsize                 , 
    input                       [2-1:0] axi4_awburst                , 
    input                               axi4_awvalid                , 
    output reg                          axi4_awready                , 
                                             
    input                      [DW-1:0] axi4_wdata                  , 
    input                     [DEW-1:0] axi4_wstrb                  , 
    input                               axi4_wlast                  , 
    input                               axi4_wvalid                 , 
    output reg                          axi4_wready                 , 
                                             
    output reg                  [2-1:0] axi4_bresp                  , 
    output reg                          axi4_bvalid                 , 
    input                               axi4_bready                 , 
                                           
    input                     [IDW-1:0] axi4_arid                   , 
    input                      [AW-1:0] axi4_araddr                 , 
    input                       [8-1:0] axi4_arlen                  , 
    input                       [3-1:0] axi4_arsize                 , 
    input                       [2-1:0] axi4_arburst                , 
    input                               axi4_arvalid                , 
    output reg                          axi4_arready                , 
                                             
    output reg                 [DW-1:0] axi4_rdata                  , 
    output reg                  [2-1:0] axi4_rresp                  , 
    output reg                          axi4_rlast                  , 
    output reg                          axi4_rvalid                 , 
    input                               axi4_rready                   
);

localparam IDLE = 'b000;
localparam GET_WRINFO = 'b001;
localparam GET_WRDATA = 'b011;
localparam SET_BRESP  = 'b010;
localparam GET_RDINFO = 'b100;
localparam SET_RDDATA = 'b110;
localparam SET_RDDONE = 'b100;

reg                        [MEM_AW-1:0] mem_addr                    ; 
reg                            [DW-1:0] mem_data [1<<MEM_AW-1:0]    ; 
reg                               [7:0] rdcnt                       ; 

reg                               [2:0] nstate                      ; 
reg                               [2:0] cstate                      ; 


always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        cstate <= #U_DLY IDLE;
    else
        cstate <= #U_DLY nstate;
end

always @ (*)
case(cstate)
    IDLE        : begin
        if(axi4_arvalid)
            nstate = GET_RDINFO;
        else if(axi4_awvalid)
            nstate = GET_WRINFO;
        else
            nstate = IDLE;
    end
    GET_WRINFO  : nstate = GET_WRDATA;
    GET_WRDATA  : nstate = axi4_wready & axi4_wvalid & axi4_wlast ? SET_BRESP : GET_WRDATA; 
    SET_BRESP   : nstate = axi4_bready & axi4_bvalid ? IDLE : SET_BRESP;
    GET_RDINFO  : nstate = GET_WRDATA;
    SET_RDDATA  : nstate = axi4_rvalid & axi4_rready & (rdcnt == 'd1) ? SET_RDDONE : SET_RDDATA;
    SET_RDDONE  : nstate = axi4_rvalid & axi4_rready ? IDLE : SET_RDDONE;
    default     : nstate = IDLE;
endcase

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        mem_addr <= #U_DLY 'd0;
    else begin
        if(cstate == GET_RDINFO)
            mem_addr <= #U_DLY axi4_araddr[MEM_AW-1:0];
        else if(cstate == GET_WRINFO)
            mem_addr <= #U_DLY axi4_awaddr[MEM_AW-1:0];
        else if((axi4_wready & axi4_wvalid) || (axi4_rvalid & axi4_rready))
            mem_addr <= #U_DLY mem_addr + 'd1;
        else
            ;
    end
end


always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        rdcnt <= #U_DLY 'd0;
    else begin
        if(cstate == GET_RDINFO)
            rdcnt <= #U_DLY axi4_awlen;
        else if(axi4_rvalid & axi4_rready)
            rdcnt <= #U_DLY rdcnt - 'd1;
        else
            ;
    end
end

always @ (posedge clk_sys) begin
    if(axi4_wready & axi4_wvalid)
        mem_data[mem_addr] <= #U_DLY axi4_wdata;
    else
        ;
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        axi4_awready <= #U_DLY 'd0;
    else begin
        if(axi4_awready&axi4_awvalid)
            axi4_awready <= #U_DLY 'd0;
        else if(axi4_wready & axi4_wvalid & axi4_wlast)
            axi4_awready <= #U_DLY 'd1;
        else
            ;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n)
        axi4_wready <= #U_DLY 'd0;
    else begin
        if(axi4_wready & axi4_wvalid & axi4_wlast)
            axi4_wready <= #U_DLY 'd0;
        else if(cstate == GET_WRINFO)
            axi4_wready <= #U_DLY 'd1;
        else
            ;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        axi4_bresp <= #U_DLY 'd0;
        axi4_bvalid <= #U_DLY 'd0;
    end
    else begin
        if(axi4_bready & axi4_bvalid)
            axi4_bvalid <= #U_DLY 'd0;
        else if(axi4_awready & axi4_awvalid)
            axi4_bvalid <= #U_DLY 'd1;
        else
            ;
    end
end

always @ (posedge clk_sys or negedge rst_n) begin
    if(~rst_n) begin
        axi4_arready <= #U_DLY 'd0;
        axi4_rdata <= #U_DLY 'd0;
        axi4_rresp <= #U_DLY 'd0;
        axi4_rlast <= #U_DLY 'd0;
        axi4_rvalid <= #U_DLY 'd0;
    end
    else begin
        if(axi4_arready&axi4_arvalid)
            axi4_arready <= #U_DLY 'd0;
        else if(cstate == GET_RDINFO)
            axi4_arready <= #U_DLY 'd1;
        else
            ;

        axi4_rdata <= #U_DLY mem_data[mem_addr];
        if(axi4_rvalid & axi4_rready) begin
            if(rdcnt == 'd1)
                axi4_rlast <= #U_DLY 'd1;
            else
                axi4_rlast <= #U_DLY 'd0;
        end
        else
            ;

        if(axi4_rvalid & axi4_rready & axi4_rlast)
            axi4_rvalid <= #U_DLY 'd0;
        else if((cstate == SET_RDDATA) || (cstate == SET_RDDONE))
            axi4_rvalid <= #U_DLY 'd1;
        else
            ;
    end
end

endmodule






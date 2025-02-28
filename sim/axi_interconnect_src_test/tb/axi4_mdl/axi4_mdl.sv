// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2024/11/15 14:39:27
// File Name    : axi4_mdl.v
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
// axi4_mdl
//    |---
// 
`timescale 1ns/1ps

module axi4_mdl #
(
    parameter                           IDW = 4                     ,
    parameter                           DW = 32                     ,
    parameter                           DEW = DW/8                  ,
    parameter                           AW = 32                     ,
    parameter                           MAX_BURST_LEN = 64          ,
    parameter                           U_DLY = 1                     // 
)
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    input                               clk_axi                     , 
    input                               rst_n                       ,
// ---------------------------------------------------------------------------------
// User Data
// ---------------------------------------------------------------------------------
    input        [MAX_BURST_LEN*DW-1:0] axi_wrmem                   , 
// ---------------------------------------------------------------------------------
// AXI4
// ---------------------------------------------------------------------------------
    output reg                [IDW-1:0] axi4_awid                   , 
    output reg                 [AW-1:0] axi4_awaddr                 , 
    output reg                  [8-1:0] axi4_awlen                  , 
    output reg                  [3-1:0] axi4_awsize                 , 
    output reg                  [2-1:0] axi4_awburst                , 
    output reg                          axi4_awvalid                , 
    input                               axi4_awready                , 
                                             
    output reg                 [DW-1:0] axi4_wdata                  , 
    output reg                [DEW-1:0] axi4_wstrb                  , 
    output reg                          axi4_wlast                  , 
    output reg                          axi4_wvalid                 , 
    input                               axi4_wready                 , 
                                             
    input                       [2-1:0] axi4_bresp                  , 
    input                               axi4_bvalid                 , 
    output                              axi4_bready                 , 
                                           
    output reg                [IDW-1:0] axi4_arid                   , 
    output reg                 [AW-1:0] axi4_araddr                 , 
    output reg                  [8-1:0] axi4_arlen                  , 
    output reg                  [3-1:0] axi4_arsize                 , 
    output reg                  [2-1:0] axi4_arburst                , 
    output reg                          axi4_arvalid                , 
    input                               axi4_arready                , 
                                             
    input                      [DW-1:0] axi4_rdata                  , 
    input                       [2-1:0] axi4_rresp                  , 
    input                               axi4_rlast                  , 
    input                               axi4_rvalid                 , 
    output                              axi4_rready                   
);

localparam AEW = LOG2(DEW-1);

initial
begin
    axi4_awid =0;
    axi4_awaddr = 0;
    axi4_awlen = 0;
    axi4_awsize = 0;
    axi4_awburst = 0;
    axi4_awvalid = 0;

    axi4_wdata = 0;
    axi4_wstrb = 0;
    axi4_wlast = 0;
    axi4_wvalid = 0;

    axi4_arid = 0;
    axi4_araddr = 0;
    axi4_arlen = 0;
    axi4_arsize = 0;
    axi4_arburst = 0;
    axi4_arvalid = 0;
end

assign axi4_bready = 1'b1;
assign axi4_rready = 1'b1;

wire hfalg;
assign hfalg = axi4_awvalid & axi4_awready;

task axi4_write;
    input [3:0] id;
    input [1:0] burst;
    input [31:0] addr;
    input [7:0] length;
    input [2:0] size;

    integer     pkgi ;

    reg [31:0] addr_temp;
begin
    @(posedge clk_axi);
    addr_temp <= addr;
    @(posedge clk_axi);
    axi4_awid <= #U_DLY id;
    axi4_awaddr <= #U_DLY addr_temp;
    axi4_awlen <= #U_DLY length;
    axi4_awsize <= #U_DLY size;
    axi4_awburst <= #U_DLY burst;
    axi4_awvalid <= #U_DLY 1'b1;
    pkgi = 0;
    @(negedge clk_axi);
    if(~(axi4_awvalid & axi4_awready)) begin
//        @(negedge clk_axi);
        @(axi4_awvalid & axi4_awready);
    end
    @(posedge clk_axi);
    axi4_awvalid <= #U_DLY 1'b0;

    while(pkgi <= length)
    begin
        axi4_wvalid <= #U_DLY 1;
        case(size)
            3'd0    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**0)*8+:(2**0)*8] << addr_temp[AEW-1:0]*8);
            3'd1    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**1)*8+:(2**1)*8] << addr_temp[AEW-1:0]*8);
            3'd2    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**2)*8+:(2**2)*8] << addr_temp[AEW-1:0]*8);
            3'd3    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**3)*8+:(2**3)*8] << addr_temp[AEW-1:0]*8);
            3'd4    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**4)*8+:(2**4)*8] << addr_temp[AEW-1:0]*8);
            3'd5    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**5)*8+:(2**5)*8] << addr_temp[AEW-1:0]*8);
            3'd6    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**6)*8+:(2**6)*8] << addr_temp[AEW-1:0]*8);
            3'd7    : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**7)*8+:(2**7)*8] << addr_temp[AEW-1:0]*8);
            default : axi4_wdata <= #U_DLY {DW{1'b0}} | (axi_wrmem[pkgi[7:0]*(2**0)*8+:(2**0)*8] << addr_temp[AEW-1:0]*8); 
        endcase

        case(size)
            3'd0    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**0){1'b1}} <<addr_temp[AEW-1:0]);
            3'd1    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**1){1'b1}} <<addr_temp[AEW-1:0]);
            3'd2    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**2){1'b1}} <<addr_temp[AEW-1:0]);
            3'd3    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**3){1'b1}} <<addr_temp[AEW-1:0]);
            3'd4    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**4){1'b1}} <<addr_temp[AEW-1:0]);
            3'd5    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**5){1'b1}} <<addr_temp[AEW-1:0]);
            3'd6    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**6){1'b1}} <<addr_temp[AEW-1:0]);
            3'd7    : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**7){1'b1}} <<addr_temp[AEW-1:0]);
            default : axi4_wstrb <= #U_DLY {DEW{1'b0}} | ({(2**0){1'b1}} <<addr_temp[AEW-1:0]);
        endcase     
//        axi4_wdata <= #U_DLY {DW{1'b0}} | axi_wrmem[pkgi[7:0]*(2**size)*8+:(2**size)*8] << addr_temp[3:0]*8;
//        axi4_wstrb <= #U_DLY {DEW{1'b0}} | {(2**size){1'b1}} <<addr_temp[3:0];
       // case(size)
       //     3'd0    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wdata <= #U_DLY {120'd0,axi_wrmem[pkgi[7:0]*8+:8]}; 
       //             4'd1    : axi4_wdata <= #U_DLY {112'd0,axi_wrmem[pkgi[7:0]*8+:8],8'd0}; 
       //             4'd2    : axi4_wdata <= #U_DLY {104'd0,axi_wrmem[pkgi[7:0]*8+:8],16'd0}; 
       //             4'd3    : axi4_wdata <= #U_DLY {96'd0,axi_wrmem[pkgi[7:0]*8+:8],24'd0}; 
       //             4'd4    : axi4_wdata <= #U_DLY {88'd0,axi_wrmem[pkgi[7:0]*8+:8],32'd0}; 
       //             4'd5    : axi4_wdata <= #U_DLY {80'd0,axi_wrmem[pkgi[7:0]*8+:8],40'd0}; 
       //             4'd6    : axi4_wdata <= #U_DLY {72'd0,axi_wrmem[pkgi[7:0]*8+:8],48'd0}; 
       //             4'd7    : axi4_wdata <= #U_DLY {64'd0,axi_wrmem[pkgi[7:0]*8+:8],56'd0}; 
       //             4'd8    : axi4_wdata <= #U_DLY {56'd0,axi_wrmem[pkgi[7:0]*8+:8],64'd0}; 
       //             4'd9    : axi4_wdata <= #U_DLY {48'd0,axi_wrmem[pkgi[7:0]*8+:8],72'd0}; 
       //             4'd10   : axi4_wdata <= #U_DLY {40'd0,axi_wrmem[pkgi[7:0]*8+:8],80'd0}; 
       //             4'd11   : axi4_wdata <= #U_DLY {32'd0,axi_wrmem[pkgi[7:0]*8+:8],88'd0}; 
       //             4'd12   : axi4_wdata <= #U_DLY {24'd0,axi_wrmem[pkgi[7:0]*8+:8],96'd0}; 
       //             4'd13   : axi4_wdata <= #U_DLY {16'd0,axi_wrmem[pkgi[7:0]*8+:8],104'd0}; 
       //             4'd14   : axi4_wdata <= #U_DLY {8'd0,axi_wrmem[pkgi[7:0]*8+:8],112'd0}; 
       //             4'd15   : axi4_wdata <= #U_DLY {axi_wrmem[pkgi[7:0]*8+:8],120'd0}; 
       //             default :; 
       //         endcase                
       //     3'd1    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wdata <= #U_DLY {112'd0,axi_wrmem[pkgi[6:0]*16+:16]}; 
       //             4'd2    : axi4_wdata <= #U_DLY {96'd0,axi_wrmem[pkgi[6:0]*16+:16],16'd0}; 
       //             4'd4    : axi4_wdata <= #U_DLY {80'd0,axi_wrmem[pkgi[6:0]*16+:16],32'd0}; 
       //             4'd6    : axi4_wdata <= #U_DLY {64'd0,axi_wrmem[pkgi[6:0]*16+:16],48'd0}; 
       //             4'd8    : axi4_wdata <= #U_DLY {48'd0,axi_wrmem[pkgi[6:0]*16+:16],64'd0}; 
       //             4'd10   : axi4_wdata <= #U_DLY {32'd0,axi_wrmem[pkgi[6:0]*16+:16],80'd0}; 
       //             4'd12   : axi4_wdata <= #U_DLY {16'd0,axi_wrmem[pkgi[6:0]*16+:16],96'd0}; 
       //             4'd14   : axi4_wdata <= #U_DLY {axi_wrmem[pkgi[6:0]*16+:16],112'd0}; 
       //             default :; 
       //         endcase                  
       //     3'd2    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wdata <= #U_DLY {96'd0,axi_wrmem[pkgi[5:0]*32+:32]}; 
       //             4'd4    : axi4_wdata <= #U_DLY {64'd0,axi_wrmem[pkgi[5:0]*32+:32],32'd0}; 
       //             4'd8    : axi4_wdata <= #U_DLY {32'd0,axi_wrmem[pkgi[5:0]*32+:32],64'd0}; 
       //             4'd12   : axi4_wdata <= #U_DLY {axi_wrmem[pkgi[5:0]*32+:32],96'd0}; 
       //             default :; 
       //         endcase                                  
       //     3'd3    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wdata <= #U_DLY {64'd0,axi_wrmem[pkgi[4:0]*64+:64]}; 
       //             4'd8    : axi4_wdata <= #U_DLY {axi_wrmem[pkgi[4:0]*64+:64],64'd0}; 
       //             default :; 
       //         endcase                 
       //     3'd4    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wdata <= #U_DLY axi_wrmem[pkgi[3:0]*128+:128];   
       //             default :;
       //         endcase                                  
       //     default : axi4_wdata <= #U_DLY axi_wrmem[pkgi[3:0]*128+:128];
       // endcase 
            
       // case(size)
       //     3'd0    : 
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wstrb <= #U_DLY 16'h0001;
       //             4'd1    : axi4_wstrb <= #U_DLY 16'h0002;
       //             4'd2    : axi4_wstrb <= #U_DLY 16'h0004;
       //             4'd3    : axi4_wstrb <= #U_DLY 16'h0008;
       //             4'd4    : axi4_wstrb <= #U_DLY 16'h0010;
       //             4'd5    : axi4_wstrb <= #U_DLY 16'h0020;
       //             4'd6    : axi4_wstrb <= #U_DLY 16'h0040;
       //             4'd7    : axi4_wstrb <= #U_DLY 16'h0080;
       //             4'd8    : axi4_wstrb <= #U_DLY 16'h0100;
       //             4'd9    : axi4_wstrb <= #U_DLY 16'h0200;
       //             4'd10   : axi4_wstrb <= #U_DLY 16'h0400;
       //             4'd11   : axi4_wstrb <= #U_DLY 16'h0800;
       //             4'd12   : axi4_wstrb <= #U_DLY 16'h1000;
       //             4'd13   : axi4_wstrb <= #U_DLY 16'h2000;
       //             4'd14   : axi4_wstrb <= #U_DLY 16'h4000;
       //             4'd15   : axi4_wstrb <= #U_DLY 16'h8000;
       //             default :;
       //         endcase
       //     3'd1    :
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wstrb <= #U_DLY 16'h0003;
       //             4'd2    : axi4_wstrb <= #U_DLY 16'h000c;
       //             4'd4    : axi4_wstrb <= #U_DLY 16'h0030;
       //             4'd6    : axi4_wstrb <= #U_DLY 16'h00c0;
       //             4'd8    : axi4_wstrb <= #U_DLY 16'h0300;
       //             4'd10   : axi4_wstrb <= #U_DLY 16'h0c00;
       //             4'd12   : axi4_wstrb <= #U_DLY 16'h3000;
       //             4'd14   : axi4_wstrb <= #U_DLY 16'hc000;
       //             default :;
       //         endcase
       //     3'd2    :
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wstrb <= #U_DLY 16'h000f;
       //             4'd4    : axi4_wstrb <= #U_DLY 16'h00f0;
       //             4'd8    : axi4_wstrb <= #U_DLY 16'h0f00;
       //             4'd12   : axi4_wstrb <= #U_DLY 16'hf000;
       //             default :;
       //         endcase                
       //     3'd3    :
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wstrb <= #U_DLY 16'h00ff;
       //             4'd8    : axi4_wstrb <= #U_DLY 16'hff00;
       //             default :;
       //         endcase                
       //     3'd4    :
       //         case(addr_temp[3:0])
       //             4'd0    : axi4_wstrb <= #U_DLY 16'hffff;
       //             default :;
       //         endcase                            
       //     default :;
       // endcase 

        if(pkgi==length)
            axi4_wlast <= #U_DLY 1'b1;
        else
            axi4_wlast <= #U_DLY 1'b0;
        pkgi <= #U_DLY pkgi+1;
        
        if(burst > 'b0)
            addr_temp <= addr_temp + 2**size;
     

        @(posedge clk_axi);
        if(~(axi4_wvalid&axi4_wready))
        begin
            @(axi4_wvalid & axi4_wready);
            @(posedge clk_axi);
        end
    end
    axi4_wlast <= #U_DLY 1'b0;
    axi4_wstrb <= #U_DLY 16'h0;
    axi4_wvalid <= #U_DLY 0;
    if(~(axi4_bvalid & axi4_bready))
        @(axi4_bvalid & axi4_bready);

end
endtask

task axi4_read;
    input [3:0] id;
    input [1:0] burst;
    input [31:0] addr;
    input [7:0] length;
    input [2:0] size;
begin
    @(posedge clk_axi);
    axi4_arid <= #U_DLY id;
    axi4_araddr <= #U_DLY addr;
    axi4_arlen <= #U_DLY length;
    axi4_arsize <= #U_DLY size;
    axi4_arburst <= #U_DLY burst;
    axi4_arvalid <= #U_DLY 1'b1;

    if(~(axi4_arvalid & axi4_arready))
        @(axi4_arvalid & axi4_arready);

    @(posedge clk_axi);
    axi4_arvalid <= #U_DLY 1'b0;
    if(~(axi4_rvalid & axi4_rready & axi4_rlast))
        @(axi4_rvalid & axi4_rready & axi4_rlast);
end
endtask

function integer LOG2 ;
input integer d;
begin
    LOG2 = 1;
    while((2**LOG2-1) < d)
        LOG2 = LOG2 + 1;
end
endfunction


endmodule


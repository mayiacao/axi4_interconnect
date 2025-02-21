// +FHDR============================================================================/
// Author       : hjie
// Creat Time   : 2025/01/21 11:49:38
// File Name    : axi_interconnect_crossbar_switch.v
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
// axi_interconnect_crossbar_switch
//    |---
// 
`timescale 1ns/1ps

module axi_interconnect_crossbar_switch #
(
    parameter                           MODE_READ           = 1     ,
    parameter                           NUM_SLAVE           = 1     , // 0 ~ 4
    parameter                           NUM_MASTER          = 1     , // 0 ~ 4
    parameter                           WIDTH_ADDR          = 32    ,
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_BASE         = 'd0   , 
    parameter [NUM_MASTER*WIDTH_ADDR-1:0] ADDR_HIGH         = 'd0   , 
    parameter                           WIDTH_ID            = 4     ,
    parameter                           WIDTH_ADDRINFO      = 64    ,   
    parameter                           WIDTH_DATAINFO      = 48    ,
    parameter                           WIDTH_RESPINFO      = 48    ,
    parameter                           NUM_OUTSTANDING     = 4     ,
    parameter                           WIDTH_SALVE         = LOG2(NUM_SLAVE-1),
    parameter                           U_DLY = 1                     // 
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
    output              [NUM_SLAVE-1:0] s_addr_ready                , 

    input     [NUM_SLAVE*WIDTH_DATAINFO-1:0] s_wdata_info           , 
    input               [NUM_SLAVE-1:0] s_wdata_valid               , 
    output              [NUM_SLAVE-1:0] s_wdata_ready               , 

    output     [NUM_SLAVE*WIDTH_RESPINFO-1:0] s_resp_info           , 
    input               [NUM_SLAVE-1:0] s_resp_ready                , 
    output              [NUM_SLAVE-1:0] s_resp_valid                , 
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    output     [NUM_MASTER*WIDTH_ADDRINFO-1:0] m_addr_info          , 
    output             [NUM_MASTER-1:0] m_addr_valid                , 
    input              [NUM_MASTER-1:0] m_addr_ready                , 

    output     [NUM_MASTER*WIDTH_DATAINFO-1:0] m_wdata_info         , 
    output             [NUM_MASTER-1:0] m_wdata_valid               , 
    input              [NUM_MASTER-1:0] m_wdata_ready               , 

    input     [NUM_MASTER*WIDTH_RESPINFO-1:0] m_resp_info           , 
    output             [NUM_MASTER-1:0] m_resp_ready                , 
    input              [NUM_MASTER-1:0] m_resp_valid                  
);

wire   [WIDTH_ADDRINFO+WIDTH_SALVE-1:0] addr_info                   ; 
wire                                    addr_valid                  ; 
wire                                    addr_ready                  ; 

wire               [WIDTH_DATAINFO-1:0] wdata_info                  ; 
wire                                    wdata_valid                 ; 
wire                                    wdata_ready                 ; 

wire                                    req_wren                    ; 
wire [NUM_MASTER+WIDTH_SALVE+WIDTH_ID:0] req_id                     ; 

wire   [WIDTH_RESPINFO+WIDTH_SALVE-1:0] resp_info                   ; 
wire                                    resp_valid                  ; 
wire                                    resp_ready                  ; 

axi_interconnect_crossbar_sreq_arbit #
(
    .MODE_READ                      (MODE_READ                  ), 
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .NUM_MASTER                     (NUM_MASTER                 ), // 0 ~ 4
    .WIDTH_ADDRINFO                 (WIDTH_ADDRINFO             ), 
    .WIDTH_DATAINFO                 (WIDTH_DATAINFO             ), 
    .NUM_OUTSTANDING                (NUM_OUTSTANDING            ), 
    .U_DLY                          (U_DLY                      )  
)
u_axi_interconnect_crossbar_sreq_arbit
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    .s_addr_info                    (s_addr_info                ), // (input )
    .s_addr_valid                   (s_addr_valid               ), // (input )
    .s_addr_ready                   (s_addr_ready               ), // (output)

    .s_wdata_info                   (s_wdata_info               ), // (input )
    .s_wdata_valid                  (s_wdata_valid              ), // (input )
    .s_wdata_ready                  (s_wdata_ready              ), // (output)
// ---------------------------------------------------------------------------------
// Master Port
// ---------------------------------------------------------------------------------
    .addr_info                      (addr_info                  ), // (output)
    .addr_valid                     (addr_valid                 ), // (output)
    .addr_ready                     (addr_ready                 ), // (input )

    .wdata_info                     (wdata_info                 ), // (output)
    .wdata_valid                    (wdata_valid                ), // (output)
    .wdata_ready                    (wdata_ready                )  // (input )
);

axi_interconnect_crossbar_mreq_split #
(
    .MODE_READ                      (MODE_READ                  ), 
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .NUM_MASTER                     (NUM_MASTER                 ), // 0 ~ 4
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_ADDR                     (WIDTH_ADDR                 ), 
    .WIDTH_ADDRINFO                 (WIDTH_ADDRINFO             ), 
    .WIDTH_DATAINFO                 (WIDTH_DATAINFO             ), 
    .ADDR_BASE                      (ADDR_BASE                  ), 
    .ADDR_HIGH                      (ADDR_HIGH                  ), 
    .NUM_OUTSTANDING                (NUM_OUTSTANDING            ),
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_crossbar_mreq_split
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave Port
// ---------------------------------------------------------------------------------
    .addr_info                      (addr_info                  ), // (input )
    .addr_valid                     (addr_valid                 ), // (input )
    .addr_ready                     (addr_ready                 ), // (output)

    .wdata_info                     (wdata_info                 ), // (input )
    .wdata_valid                    (wdata_valid                ), // (input )
    .wdata_ready                    (wdata_ready                ), // (output)
// ---------------------------------------------------------------------------------
// Master Port
// ---------------------------------------------------------------------------------
    .m_addr_info                    (m_addr_info                ), // (output)
    .m_addr_valid                   (m_addr_valid               ), // (output)
    .m_addr_ready                   (m_addr_ready               ), // (input )

    .m_wdata_info                   (m_wdata_info               ), // (output)
    .m_wdata_valid                  (m_wdata_valid              ), // (output)
    .m_wdata_ready                  (m_wdata_ready              ), // (input )
// ---------------------------------------------------------------------------------
// Request Queen
// ---------------------------------------------------------------------------------
    .req_wren                       (req_wren                   ), // (output)
    .req_id                         (req_id                     )  // (output)
);

axi_interconnect_crossbar_mresp_arbit #
(
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .NUM_MASTER                     (NUM_MASTER                 ), // 0 ~ 4
    .WIDTH_ID                       (WIDTH_ID                   ), 
    .WIDTH_RESPINFO                 (WIDTH_RESPINFO             ), 
    .NUM_OUTSTANDING                (NUM_OUTSTANDING            ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_crossbar_mresp_arbit
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Response Queen
// ---------------------------------------------------------------------------------
    .req_wren                       (req_wren                   ), // (input )
    .req_id                         (req_id                     ), // (input )
// ---------------------------------------------------------------------------------
// Slave 
// ---------------------------------------------------------------------------------
    .m_resp_info                    (m_resp_info                ), // (input )
    .m_resp_ready                   (m_resp_ready               ), // (output)
    .m_resp_valid                   (m_resp_valid               ), // (input )
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    .resp_info                      (resp_info                  ), // (output)
    .resp_valid                     (resp_valid                 ), // (output)
    .resp_ready                     (resp_ready                 )  // (input )
);

axi_interconnect_crossbar_sresp_split #
(
    .NUM_SLAVE                      (NUM_SLAVE                  ), // 0 ~ 4
    .WIDTH_RESPINFO                 (WIDTH_RESPINFO             ), 
    .U_DLY                          (U_DLY                      )  // 
)
u_axi_interconnect_crossbar_sresp_split
(
// ---------------------------------------------------------------------------------
// CLock & Reset
// ---------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ---------------------------------------------------------------------------------
// Slave
// ---------------------------------------------------------------------------------
    .resp_info                      (resp_info                  ), // (input )
    .resp_valid                     (resp_valid                 ), // (input )
    .resp_ready                     (resp_ready                 ), // (output)
// ---------------------------------------------------------------------------------
// Master
// ---------------------------------------------------------------------------------
    .m_resp_info                    (s_resp_info                ), // (output)
    .m_resp_ready                   (s_resp_ready               ), // (input )
    .m_resp_valid                   (s_resp_valid               )  // (output)
);

function integer LOG2 ;
input integer d;
begin
    LOG2 = 1;
    while((2**LOG2-1) < d)
        LOG2 = LOG2 + 1;
end
endfunction


endmodule







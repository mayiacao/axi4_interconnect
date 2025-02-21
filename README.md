AXI4 Bus Interconnect Module:
Version Number: v1.0.0
Scheme Block Diagram:

axi_interconnect
                            ┌───────────────┐
                            │               │
                ┌───────┐   │   AXI4        │   ┌───────┐
SAXI4_IN0──────►│Clock  │──►│  Crossbar     │──►│Data   │──────►MAXI4_OUT0
                │Conv(○)│   │   (路由核心)   │   │Conv(○)│
                └───────┘   │               │   └───────┘
                            │               │
                ┌───────┐   │               │   ┌───────┐
SAXI4_IN1──────►│Data   │──►│               │──►│Clock  │──────►MAXI4_OUT1
                │Conv(○)│   │               │   │Conv(○)│
                └───────┘   └───────────────┘   └───────┘
                            ▲               ▲
                ┌───────┐   │               │   ┌───────┐
SAXI4_INn──────►│       │───┘               └───│       │──────►MAXI4_OUTm
                │(可选)  │                       │(可选)  │
                └───────┘                       └───────┘

axi_interconnect_crossbar_switch
┌─────────┐      ┌─────────────┐       ┌────────────┐       ┌─────────┐
│ NUM_SLAVE│      │ sreq_arbit  │       │ mreq_split │       │ NUM_MASTER
│ Slaves  ├─────►│ (多到一仲裁) ├──────►│ (一到多解码)├───────►│ Masters │
└─────────┘      └─────────────┘       └──────┬──────┘       └─────────┘
                                               │
                                               ▼ 状态记录
                                     ┌───────────────────┐
                                     │  事务ID映射表      │
                                     │ (req_wren/req_id) │
                                     └───────────────────┘

[响应通道] (Master→Slave方向)
┌─────────┐      ┌─────────────┐       ┌────────────┐       ┌─────────┐
│ NUM_MASTER│     │ mresp_arbit │       │ sresp_split│       │ NUM_SLAVE
│ Masters  ├─────►│ (多到一仲裁) ├──────►│ (一到多路由)├───────►│ Slaves  │
└─────────┘      └──────┬──────┘       └────────────┘       └─────────┘
                        ▲                  
                        │
                  ┌─────┴─────┐
                  │ 状态查询  │
                  │ (req_id)  │
                  └───────────┘
Supported Functions:
The ID, data, and address bit widths can be customized.
It supports arbitration indexing of the address space.
It supports cross-clock domain conversion.
It supports data bit width conversion.
The axi_interconnect.v module supports software-generated configuration.
Defects:
The current version does not support out-of-order bursts.
Auxiliary control signals such as cache, lock, and QoS do not support independent configuration for each interface.

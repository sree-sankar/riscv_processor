//----------------------+-------------------------------------------------------
// Filename             | central_interconnect.sv
// File created on      | 26.10.2024
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Central Interconnect
//------------------------------------------------------------------------------

`include "../risc-v/riscv.vh"
`include "../apb/apb.vh"

module central_interconnect(
    // Core Clock and Reset
    input                       core_clk_i         ,
    input                       core_resetn_i      ,
    // Core Data Memory Interface
    input  [      `XLEN-1:0]    mem_addr_i         , // Memory Address
    input                       mem_read_en_i      , // Memory Read Enable
    output [      `XLEN-1:0]    mem_read_data_o    , // Memory Read Data
    input                       mem_write_en_i     , // Memory Write Enable
    input  [      `XLEN-1:0]    mem_write_data_i   , // Memory Write Data
    // DCache Memory
    output [      `XLEN-1:0]    dcache_addr_o      , // Memory Address
    output                      dcache_read_en_o   , // Memory Read Enable
    input  [      `XLEN-1:0]    dcache_read_data_i , // Memory Read Data
    output                      dcache_write_en_o  , // Memory Write Enable
    output [      `XLEN-1:0]    dcache_write_data_o, // Memory Write Data
    // APB Interface to pheripherals
    input                       m_apb_pclk_i       , // Master APB Clock
    input                       m_apb_presetn_i    , // Master APB Reset
    output [    `APB_AW-1:0]    m_apb_paddr_o      , // Master APB Address
    output                      m_apb_pwrite_o     , // Master APB Write
    output [`APB_SLAVES-1:0]    m_apb_psel_o       , // Master APB Select
    output                      m_apb_penable_o    , // Master APB Select
    input                       m_apb_pready_i     , // Master APB Slave Ready
    output [    `APB_DW-1:0]    m_apb_pwdata_o     , // Master APB Write
    output [ `APB_STRBW-1:0]    m_apb_pstrb_o      , // Master APB Strobe
    input  [    `APB_AW-1:0]    m_apb_rdata_i        // Master APB Read data
);

    logic [    `APB_AW-1:0]    apb_read_write_addr;
    logic [`APB_SLAVES-1:0]    apb_read_write_sel ;
    logic                      apb_write_en       ;
    logic [    `APB_DW-1:0]    apb_write_data     ;
    logic                      apb_read_en        ;
    logic [    `APB_DW-1:0]    apb_read_data      ;
    logic                      apb_busy           ;
    logic                      apb_done           ;

//------------------------------------------------------------------------------
// Memory to APB Bridge
//------------------------------------------------------------------------------

    mem2apb_bridge mem2apb_bridge_inst(
        .core_clk_i               (core_clk_i         ),
        .core_resetn_i            (core_resetn_i      ),
        .m_apb_pclk_i             (m_apb_pclk_i       ),
        .m_apb_presetn_i          (m_apb_presetn_i    ),
        .mem_addr_i               (mem_addr_i         ),
        .mem_read_en_i            (mem_read_en_i      ),
        .mem_read_data_o          (mem_read_data_o    ),
        .mem_write_en_i           (mem_write_en_i     ),
        .mem_write_data_i         (mem_write_data_i   ),
        .dcache_addr_o            (dcache_addr_o      ),
        .dcache_read_en_o         (dcache_read_en_o   ),
        .dcache_read_data_i       (dcache_read_data_i ),
        .dcache_write_en_o        (dcache_write_en_o  ),
        .dcache_write_data_o      (dcache_write_data_o),
        .read_write_addr_o        (apb_read_write_addr),
        .read_write_sel_o         (apb_read_write_sel ),
        .write_en_o               (apb_write_en       ),
        .write_data_o             (apb_write_data     ),
        .read_en_o                (apb_read_en        ),
        .read_data_i              (apb_read_data      ),
        .busy_i                   (apb_busy           ),
        .done_i                   (apb_done           )
    );

//------------------------------------------------------------------------------
// Master APB Interface
//------------------------------------------------------------------------------

    m_apb m_apb_inst(
        .m_apb_pclk_i         (m_apb_pclk_i       ),
        .m_apb_presetn_i      (m_apb_presetn_i    ),
        .m_apb_paddr_o        (m_apb_paddr_o      ),
        .m_apb_pwrite_o       (m_apb_pwrite_o     ),
        .m_apb_psel_o         (m_apb_psel_o       ),
        .m_apb_penable_o      (m_apb_penable_o    ),
        .m_apb_pready_i       (m_apb_pready_i     ),
        .m_apb_pwdata_o       (m_apb_pwdata_o     ),
        .m_apb_pstrb_o        (m_apb_pstrb_o      ),
        .m_apb_rdata_i        (m_apb_rdata_i      ),
        .read_write_addr_i    (apb_read_write_addr),
        .read_write_sel_i     (apb_read_write_sel ),
        .write_en_i           (apb_write_en       ),
        .write_data_i         (apb_write_data     ),
        .read_en_i            (apb_read_en        ),
        .read_data_o          (apb_read_data      ),
        .busy_o               (apb_busy           ),
        .done_o               (apb_done           )
    );

endmodule
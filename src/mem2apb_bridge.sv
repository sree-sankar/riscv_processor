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
// TBD
//    -- Clock Domain clock to Core, APB and Memory Clock
//    -- Buffering to handle throughput
//------------------------------------------------------------------------------

`include "../risc-v/riscv.vh"
`include "../apb/apb.vh"
`include "../memory_map.vh"

module mem2apb_bridge(
    // Clock and Reset
    input                       m_apb_pclk_i       ,
    input                       m_apb_presetn_i    ,
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
    // Address
    output [    `APB_AW-1:0]    read_write_addr_o  , // Write Address
    output [`APB_SLAVES-1:0]    read_write_sel_o   , // Write Device Select
    // Write Interface
    output                      write_en_o         , // Write Enable
    output [    `APB_DW-1:0]    write_data_o       , // Write Data
    // Read Interface
    output                      read_en_o          , // Read Enable
    input  [    `APB_DW-1:0]    read_data_i        , // Read Data
    // Status
    input                       busy_i             , // Busy
    input                       done_i               // Done
);

    localparam OCM_SEL  = 'h1,
               UART_SEL = 'h2;

//------------------------------------------------------------------------------
// Memory MUX
//------------------------------------------------------------------------------

    logic [1:0]    dev_sel;

    assign dev_sel = ((mem_addr_i >= `OCM_BASE_ADDR) && mem_addr_i <= (`OCM_BASE_ADDR + `OCM_OFFSET)      ) ? OCM_SEL  :
                     ((mem_addr_i >= `UART0_BASE_ADDR) && mem_addr_i <= (`UART0_BASE_ADDR + `UART0_OFFSET)) ? UART_SEL : 'h0;

//------------------------------------------------------------------------------
// Muxing
//------------------------------------------------------------------------------

    // DCache
    assign dcache_addr_o       = dev_sel[0] ? mem_addr_i       : 'h0;
    assign dcache_read_en_o    = dev_sel[0] ? mem_read_en_i    : 'h0;
    assign dcache_write_en_o   = dev_sel[0] ? mem_write_en_i   : 'h0;
    assign dcache_write_data_o = dev_sel[0] ? mem_write_data_i : 'h0;

    // Pheripherals
    assign read_write_addr_o   = dev_sel[1] ? {4'h0,mem_addr_i[27:0]} : 'h0;
    assign read_en_o           = dev_sel[1] ? mem_read_en_i    : 'h0;
    assign write_en_o          = dev_sel[1] ? mem_write_en_i   : 'h0;

    // Read Data Muxing
    assign mem_read_data_o     = dev_sel[1] ? dcache_read_data_i : read_data_i;
    assign write_data_o        = dev_sel[1] ? mem_write_data_i   : 'h0;

    // APB Select
    assign read_write_sel_o    = dev_sel[1];

endmodule
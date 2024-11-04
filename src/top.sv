//----------------------+-------------------------------------------------------
// Filename             | top.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// RISC V Core File
//------------------------------------------------------------------------------

`include "riscv.vh"
`include "../apb/apb.vh"

module top(
    // Input Clock and Reset
    input     clk_i   , // System Clock
    input     resetn_i, // Synchronous Reset (Asserted Low)
   // UART
    input     uart_rx_i, // UART RX
    output    uart_tx_o  // UART TX
);

//------------------------------------------------------------------------------
// Clock Generator
//------------------------------------------------------------------------------

    logic    sys_resetn; // Core Resetn
    logic    core_clk  ; // Core Clock
    logic    apb_pclk  ; // Interconnect Clock
    logic    uart_clk  ; // Uart Clock

    clk_generator clk_generator_inst(
        .clk_i           (clk_i     ),
        .resetn_i        (resetn_i  ),
        .sys_resetn_o    (sys_resetn),
        .core_clk_o      (core_clk  ),
        .apb_pclk_o      (apb_pclk  ),
        .uart_clk_o      (uart_clk  )
    );

//------------------------------------------------------------------------------
// OCM
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    instr            ; // Instruction
    logic [`XLEN-1:0]    instr_addr       ; // Program Counter
    // Memory
    logic [`XLEN-1:0]    mem_addr         ;
    logic                mem_read_en      ;
    logic [`XLEN-1:0]    mem_read_data    ;
    logic                mem_write_en     ;
    logic [`XLEN-1:0]    mem_write_data   ;
    // DCache Memory
    logic [`XLEN-1:0]    dcache_addr      ;
    logic                dcache_read_en   ;
    logic [`XLEN-1:0]    dcache_read_data ;
    logic                dcache_write_en  ;
    logic [`XLEN-1:0]    dcache_write_data;

    ocm ocm_inst(
        .icache_clk_i           (core_clk         ),
        .icache_addr_i          (instr_addr       ),
        .icache_read_en_i       (1'b1             ),
        .icache_write_en_i      (1'b0             ),
        .icache_read_data_o     (instr            ),
        .icache_write_data_i    ('h0              ),
        .dcache_clk_i           (core_clk         ),
        .dcache_addr_i          (dcache_addr      ),
        .dcache_read_en_i       (dcache_read_en   ),
        .dcache_write_en_i      (dcache_write_en  ),
        .dcache_read_data_o     (dcache_read_data ),
        .dcache_write_data_i    (dcache_write_data)
    );

//------------------------------------------------------------------------------
// RISC V Core
//------------------------------------------------------------------------------

    riscv riscv_inst(
        .clk_i               (core_clk           ), // System Clock
        .resetn_i            (sys_resetn         ), // Synchronous Active Low System Reset
        .instr_addr_o        (instr_addr         ), // Program Counter
        .instr_i             (instr              ), // Instruction
        .mem_read_en_o       (mem_read_en        ), // Data Memory Read Enable
        .mem_addr_o          (mem_addr           ), // Data Memory Read Address
        .mem_read_data_i     (mem_read_data      ), // Data Memory Read Data
        .mem_write_en_o      (mem_write_en       ), // Data Memory Write Enable
        .mem_write_data_o    (mem_write_data     )  // Data Memory Write Data
    );

//------------------------------------------------------------------------------
// Central Interconnect
//------------------------------------------------------------------------------

    logic [    `APB_AW-1:0]    apb_paddr  ; // APB Address
    logic                      apb_pwrite ; // APB Write
    logic [`APB_SLAVES-1:0]    apb_psel   ; // APB Select
    logic                      apb_penable; // APB Select
    logic                      apb_pready ; // APB Slave Ready
    logic [    `APB_DW-1:0]    apb_pwdata ; // APB Write
    logic [ `APB_STRBW-1:0]    apb_pstrb  ; // APB Strobe
    logic [    `APB_DW-1:0]    apb_rdata  ; // APB Read data

    central_interconnect central_interconnect_inst(
        .core_clk_i          (core_clk           ),
        .core_resetn_i       (sys_resetn         ),
        .mem_addr_i          (mem_addr           ),
        .mem_read_en_i       (mem_read_en        ),
        .mem_read_data_o     (mem_read_data      ),
        .mem_write_en_i      (mem_write_en       ),
        .mem_write_data_i    (mem_write_data     ),
        .dcache_addr_o       (dcache_addr        ),
        .dcache_read_en_o    (dcache_read_en     ),
        .dcache_read_data_i  (dcache_read_data   ),
        .dcache_write_en_o   (dcache_write_en    ),
        .dcache_write_data_o (dcache_write_data  ),
        .m_apb_pclk_i        (apb_pclk           ),
        .m_apb_presetn_i     (sys_resetn         ),
        .m_apb_paddr_o       (apb_paddr          ),
        .m_apb_pwrite_o      (apb_pwrite         ),
        .m_apb_psel_o        (apb_psel           ),
        .m_apb_penable_o     (apb_penable        ),
        .m_apb_pready_i      (apb_pready         ),
        .m_apb_pwdata_o      (apb_pwdata         ),
        .m_apb_pstrb_o       (apb_pstrb          ),
        .m_apb_rdata_i       (apb_rdata          )
    );

//------------------------------------------------------------------------------
// Pheripherals
//------------------------------------------------------------------------------

    pher_ctrl pher_ctrl_inst(
        .uart_clk_i         (uart_clk           ),
        .resetn_i           (sys_resetn         ),
        .s_apb_pclk_i       (apb_pclk           ),
        .s_apb_presetn_i    (sys_resetn         ),
        .s_apb_paddr_i      (apb_paddr          ),
        .s_apb_pwrite_i     (apb_pwrite         ),
        .s_apb_psel_i       (apb_psel           ),
        .s_apb_penable_i    (apb_penable        ),
        .s_apb_pready_o     (apb_pready         ),
        .s_apb_pwdata_i     (apb_pwdata         ),
        .s_apb_pstrb_i      (apb_pstrb          ),
        .s_apb_rdata_o      (apb_rdata          ),
        .uart_rx_i          (uart_rx_i          ),
        .uart_tx_o          (uart_tx_o          )
    );

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:40:01 08/07/2022
// Design Name:
// Module Name:    addr_decoder
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/memory_map.vh"

module addr_decoder(
    input  [`XLEN-1:0]      mem_addr      ,
    // BOOT RAM Address Decoding
    output [`XLEN-1:0]      data_mem_addr ,
    output                  data_mem_en   ,

    // UART Address Decoding
    output                  uart0_addr_en ,
    output [`XLEN-1:0]      uart0_addr    ,

    output                  gpio0_addr_en ,
    output [`XLEN-1:0]      gpio0_addr

);

    assign data_mem_en   = ((mem_addr >= `BOOT_RAM_BASE)& (mem_addr <= (`BOOT_RAM_BASE + `BOOT_RAM_OFFSET))) ? 1'b1 : 1'b0;
    assign data_mem_addr = (mem_addr - `BOOT_RAM_BASE);

    // UART Signals
    assign uart0_addr_en = ((mem_addr >= `UART0_BASE)& (mem_addr <= (`UART0_BASE + `UART0_OFFSET))) ? 1'b1 : 1'b0;
    assign uart_addr     = (mem_addr - `UART0_BASE);

    // GPIO0 Signals
    assign gpio0_addr_en = ((mem_addr >= `GPIO0_BASE)& (mem_addr <= (`GPIO0_BASE + `GPIO0_OFFSET))) ? 1'b1 : 1'b0;
    assign gpio0_addr    = (mem_addr - `GPIO0_BASE);

endmodule

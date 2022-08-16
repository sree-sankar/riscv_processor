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
	input  [`XLEN-1:0] 	mem_addr,
	// BOOT RAM Address Decoding
	output [`XLEN-1:0] 	data_mem_addr,
	output 					data_mem_en,
	
	// UART Address Decoding
	output 					uart_addr_detect,
	output [`XLEN-1:0]	uart_addr

);

	assign data_mem_addr = mem_addr - `BOOT_RAM_BASE;
	assign data_mem_en	= ((mem_addr >= `BOOT_RAM_BASE)& (mem_addr <= (`BOOT_RAM_BASE + `BOOT_RAM_OFFSET))) ? 1'b1 : 1'b0;
	
	// UART Signals
	assign uart_addr_detect = ((mem_addr >= `UART0_BASE)& (mem_addr <= (`UART0_BASE + `UART0_OFFSET))) ? 1'b1 : 1'b0;
	assign uart_addr			= mem_addr - `UART0_BASE;
endmodule

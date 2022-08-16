`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:19 06/25/2022 
// Design Name: 
// Module Name:    boot_rom_if 
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
module boot_rom_if(
    input       			clk,        	// System Clock
    input       			rst_n,      	// Synchronous Reset (Asserted Low)
	 
	 // Port A for Instruction
	 input  [`XLEN-1:0]  instr_rd_addr, // Instruction Read Address
	 output [`XLEN-1:0] 	instr,         // Instruction
    input  					instr_rd_en,   // Instruction Read Enable
	 
	 // Port B for Data Access
	 input  [`XLEN-1:0] 	mem_rd_data,    // Memory Read Data
    output [`XLEN-1:0] 	mem_wr_data,    // Memory Read Data
    input  [`XLEN-1:0] 	mem_addr,       // Memory Address    
    input				  	mem_data_rd_en, // Data Read Enable    
    input 				  	mem_data_wr_en  // Data Write Enable
    
);

	assign instr 	    = 32'b0;
	assign mem_wr_data = 32'b0;

endmodule

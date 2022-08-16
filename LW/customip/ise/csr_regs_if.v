`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company					: 
// Engineer					: 
// 
// Create Date				:    23:16:28 06/22/2022 
// Design Name				: 
// Module Name				:    csr_regs_if 
// Project Name			: 
// Target Devices			: 
// Tool versions			: 
// Description				: 
//
// Dependencies			: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments	: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"
module csr_regs_if(
	input                           clk,         // System Clock
   input                           rst_n,       // System Reset
	input									  halt,			// Halt signal
	input									  halt_fetch,	// Halt Fetch Signal
	input  [`FUNCT3_LEN-1:0]        funct3_in,	// Function 3 
	input  [`OPCODE_WIDTH-1:0]      opcode_in,	// Opcode	 
	input  [`CSR_UIMM_WIDTH-1:0]	  uimm,			// Immediate Value
   input  [`CSR_BASE_WIDTH-1:0]    write_addr,  // Write address
   input  [`XLEN-1:0]              write_data,  // Write data
	input  [`XLEN-1:0]              read_data,   // CSR data
   input	 [`SYS_REGS_WIDTH-1:0]	  rd_addr,		// rd data
	output [`CSR_BASE_WIDTH-1:0]    read_addr    // Read data
);

	wire read_en;
	wire write_en;
	wire fn3_sel;
	wire opcode_sel;
	
	// Control Signal Generation
	assign fn3_sel 	 = (funct3_in == `CSRRW || (funct3_in == `CSRRS && rd_addr != `X0) || 
								(funct3_in == `CSRRC && rd_addr != `X0) || funct3_in == `CSRRWI ||
								(funct3_in == `CSRRSI && uimm != `CSR_UIMM_WIDTH'b0) ||
								(funct3_in == `CSRRCI && uimm != `CSR_UIMM_WIDTH'b0) ) ? 1'b1 : 1'b0;
								 
	assign opcode_sel	 = (opcode_in == `SYSTEM) ? 1'b1 : 1'b0;
	assign read_en	 	 = (!halt_fetch) ? 1'b1 : 1'b0;
	assign write_en	 = (!halt) ? (opcode_sel && fn3_sel) : 1'b0;
	
	csr_regs csr_regs_inst(
        .clk                 (clk                    	),
        .rst_n               (rst_n                  	),
        .read_en             (read_en         			),
        .write_en            (write_en         			),
		  .write_addr			  (write_addr					),
        .write_data          (write_data            	),
        .read_addr           (read_addr            	),
        .read_data           (read_data            	)
    );

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              : 
// Engineer             :  
// 
// Create Date          : 05.12.2021 12:48:12
// Design Name          : 
// Module Name          : mem_access_cntrl
// Project Name         : 
// Target Devices       : 
// Tool Versions        : 
// Description          : 
// 
// Dependencies         : 
// 
// Revision             : 1.0
// Additional Comments  :
// 
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"

module mem_access_cntrl(
   input                       	clk,           // System Clock
   input                      	rst_n,         // System Reset 
   input                       	halt,          // Halt Control Signal
	input  [`OPCODE_WIDTH-1:0]  	opcode_in,     // Opcode
   input  [`FUNCT3_LEN-1:0]     	funct3_in,     // Function 3
   input  [`XLEN-1:0]        	   rd_data_in,   	// rd Data In
   input	 [`SYS_REGS_WIDTH-1:0]	rd_addr_in,		// rd register address
   input  [`XLEN-1:0]        	   csr_data_in,   // CSR Data In
	input	 [`CSR_BASE_WIDTH-1:0]  csr_addr_in,	// CSR register address
	input  [`CSR_UIMM_WIDTH-1:0]  uimm_in,			// UIMM data of CSR
	output [`XLEN-1:0]         	rd_data_out,  	// Register Data Out
	output [`OPCODE_WIDTH-1:0]  	opcode_out,    // Opcode
   output [`FUNCT3_LEN-1:0]     	funct3_out,    // Function 3   
   output [`SYS_REGS_WIDTH-1:0]	rd_addr_out,	// rd register address
   output [`XLEN-1:0]        	   csr_data_out,  // CSR Data In
	output [`CSR_BASE_WIDTH-1:0]  csr_addr_out,	// CSR register address
	output [`CSR_UIMM_WIDTH-1:0]  uimm_out,			// UImm Output
	// Control Signal
   output                     	write_en,
	output                     	read_en
);
	reg [`FUNCT3_LEN-1:0] 			funct3_reg;		 // Function 3 Reg
	reg [`OPCODE_WIDTH-1:0]  		opcode_reg;     // Opcode register
	reg [`XLEN-1:0]        	   	rd_data_reg;    // rd Data In
   reg [`SYS_REGS_WIDTH-1:0]		rd_addr_reg;	 // rd register address
   reg [`XLEN-1:0]        	   	csr_data_reg;   // CSR Data In
	reg [`CSR_BASE_WIDTH-1:0]  	csr_addr_reg;	 // CSR register address
	reg [`CSR_UIMM_WIDTH-1:0]  	uimm_reg;
 
   assign write_en     = ((opcode_in == `STORE) & rst_n & !halt) ? 1'b1 : 1'b0;
   assign read_en      = ((opcode_in == `LOAD) & rst_n & !halt) ? 1'b1 : 1'b0;
	
	assign opcode_out   = opcode_reg;
	assign funct3_out	  = funct3_reg;
	assign rd_data_out  = rd_data_reg;
	assign rd_addr_out  = rd_addr_reg;
	assign csr_data_out = csr_data_reg;
	assign csr_addr_out = csr_addr_reg;
	assign uimm_out	  = uimm_reg;
   
	// Data Forwarding to Register Access Stage 
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
			opcode_reg	 	<= `OPCODE_WIDTH'b0;
			funct3_reg		<= `FUNCT3_LEN'b0;
			rd_data_reg		<=	`XLEN'h0000_0000;
			rd_addr_reg		<= `SYS_REGS_WIDTH'h0;
			csr_data_reg	<= `XLEN'h0000_0000;
			csr_addr_reg	<=	`CSR_BASE_WIDTH'h0;
			uimm_reg			<= `CSR_BASE_WIDTH'h0;
         end
      else 
         begin
			opcode_reg		<= opcode_in;
			funct3_reg		<= funct3_in;
			rd_data_reg		<=	rd_data_in;
			rd_addr_reg		<= rd_addr_in;
			csr_data_reg	<= csr_data_in;
			csr_addr_reg	<=	csr_addr_in;
			uimm_reg			<= uimm_in;
         end
      end
endmodule

`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company			: 
// Engineer			: 
// 
// Create Date		:    19:12:41 06/25/2022 
// Design Name		: 
// Module Name		:    reg_access_if 
// Project Name	: 
// Target Devices	: 
// Tool versions	: 
// Description	: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"
module reg_access_if(
	input 								clk,				// System clock
	input									rst_n,			// System Reset
	input 								halt,				// Halt signal
	input									halt_fetch,    // Halt fetch in
	//System Reg Signals
	input  [`FUNCT3_LEN-1:0]      funct3_in,		 // Function 3 
	input  [`OPCODE_WIDTH-1:0]    opcode_in,		 // Opcode	 
   input  [`SYS_REGS_WIDTH-1:0]	rs1_addr,		 // Operand Address 1
	input  [`SYS_REGS_WIDTH-1:0]	rs2_addr,		 // Operand Address 2
	input  [`SYS_REGS_WIDTH-1:0]  rd_addr,  		 // Destination Address
   input  [`XLEN-1:0]  				write_data,  	 // Data register
   output [`XLEN-1:0]  				rs1_data, 		 // Read Operand 1
   output [`XLEN-1:0]  				rs2_data,  		 // Read Operand 2
	
	// CSR Register
	input  [`CSR_UIMM_WIDTH-1:0]	uimm,				 // Immediate Value
   input  [`CSR_BASE_WIDTH-1:0]  csr_read_addr,  // Read address
   input  [`CSR_BASE_WIDTH-1:0]  csr_write_addr, // Write address
   input  [`XLEN-1:0]            csr_write_data, // Write data
   output [`XLEN-1:0]            csr_read_data 	 // Read data
);

	

//---------------------------------------------------------------------------//
// System Register Interface                                                 //
//---------------------------------------------------------------------------//
	sys_regs_if sys_regs_if_inst(
			.clk					 	(clk									),
			.rst_n					(rst_n								),
			.halt						(halt									),
			.halt_fetch				(halt_fetch							),
			.opcode_in				(opcode_in							),
			.funct3_in				(funct3_in							),			
			.rs1_addr				(rs1_addr							), 
			.rs2_addr				(rs2_addr							), 
			.rd_addr					(rd_addr								), 
			.write_data				(write_data							), 
			.rs1_data				(rs1_data							), 
			.rs2_data				(rs2_data							)
    );
//---------------------------------------------------------------------------//
// CSR Register 
//---------------------------------------------------------------------------// 
   csr_regs_if csr_regs_if_inst (
    .clk								(clk									), 
    .rst_n							(rst_n								),
	 .halt							(halt									),
	 .halt_fetch					(halt_fetch							),
	 .opcode_in						(opcode_in							),
	 .funct3_in						(funct3_in							),	 
    .rd_addr						(rd_addr								), 
    .uimm							(uimm									), 
    .write_addr					(csr_write_addr					), 
    .write_data					(csr_write_data					),
    .read_addr						(csr_read_addr						), 	 
    .read_data						(csr_read_data						)
    );
endmodule

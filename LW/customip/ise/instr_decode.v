`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company          	: 
// Engineer         	: 
// 
// Create Date			: 05.12.2021 12:48:12
// Design Name      	: 
// Module Name      	: instr_decode
// Project Name     	: 
// Target Devices   	: 
// Tool Versions    	: 
// Description      	: 
// 
// Dependencies     	: 
// 
// Revision         	: 1.0
// Additional Comments	:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"
module instr_decode( 
	input 					    		clk,		   	// System Clock
   input 					    		rst_n,	   	// Synchronous Negatice Reset 
	input 			 		    		halt,	   		// Halt Contro;
	input  [`XLEN-1:0]				pc_in,			// Program Counter 
	input  [`XLEN-1:0]		    	instr,      	// Instructions
   input  [`SYS_REGS_WIDTH-1:0] 	rd_addr_in, 	// Operand register
	input  [`XLEN-1:0]				csr_data_in,	// CSR data int
	input	 [`CSR_BASE_WIDTH-1:0]	csr_addr_in,	// CSR
	output [`OPCODE_WIDTH-1:0] 	opcode,    		// Opcode
   output [`FUNCT3_LEN-1:0]    	funct3,	   	// Function 3
	output [`FUNCT7_LEN-1:0]    	funct7,     	// Function 7 
	output [`XLEN-1:0]   	   	imm_i_data, 	// I type immediate data
	output [`XLEN-1:0]   	   	imm_s_data, 	// S type immediate data
	output [`XLEN-1:0]   	   	imm_b_data, 	// B type immediate data
	output [`XLEN-1:0]   	   	imm_u_data, 	// U type immediate data
	output [`XLEN-1:0]   	   	imm_j_data, 	// J type immediate data
	output [`SYS_REGS_WIDTH-1:0]  rs1_addr_out,	// Destination address
	output [`SYS_REGS_WIDTH-1:0]  rs2_addr_out,	// Destination address
	output [`SYS_REGS_WIDTH-1:0]  rd_addr_out,	// Destination address
	output [`XLEN-1:0]				pc_out, 			// PC out
	output [`CSR_BASE_WIDTH-1:0]  csr_addr_out,	// CSR destination address
 	output [`XLEN-1:0]				uimm_out			// UImm data of CSR 
);
   
	reg [`SYS_REGS_WIDTH-1:0]		rd_addr_reg;	 // rd register
	reg [`SYS_REGS_WIDTH-1:0]		rs1_addr_reg;	 // rd register
	reg [`SYS_REGS_WIDTH-1:0]		rs2_addr_reg;	 // rd register
	reg [`OPCODE_WIDTH-1:0] 		opcode_reg;     // Opcode register
   reg [`FUNCT3_LEN-1:0]    		funct3_reg;	    // Function 3 register
	reg [`FUNCT7_LEN-1:0]    		funct7_reg;     // Function 7 register
	reg [`XLEN-1:0]   				imm_i_data_reg; // I type immediate data register
	reg [`XLEN-1:0]   				imm_s_data_reg; // S type immediate data register
	reg [`XLEN-1:0]   				imm_b_data_reg; // B type immediate data register
	reg [`XLEN-1:0]   				imm_u_data_reg; // U type immediate data register
	reg [`XLEN-1:0]   				imm_j_data_reg; // J type immediate data register
	reg [`XLEN-1:0]					pc_out_reg;     // PC Out register
	reg [`CSR_BASE_WIDTH-1:0]		csr_addr_reg;	 // CSR address register
	reg [`XLEN-1:0]					uimm_reg;		 // UImm data register
	
	assign pc_out 			= pc_out_reg;
	assign opcode 			= opcode_reg;
	assign funct3			= funct3_reg;
	assign funct7			= funct7_reg;
	assign imm_i_data		= imm_i_data_reg;
	assign imm_s_data		= imm_s_data_reg;
	assign imm_b_data 	= imm_b_data_reg;
	assign imm_u_data		= imm_u_data_reg;
	assign imm_j_data 	= imm_j_data_reg;
	assign rd_addr_out	= rd_addr_reg;
	assign uimm_out		= uimm_reg;
	assign csr_addr_out  = csr_addr_reg;
	assign rs1_addr_out	= rs1_addr_reg;
	assign rs2_addr_out	= rs2_addr_reg;
	
	// Instruction Decoding
	always @(posedge clk)
		begin
		if(!rst_n)
			begin
			rd_addr_reg		<= 5'h0;
			funct3_reg 		<= 3'h0;
			funct7_reg 		<= 7'h0;
			imm_i_data_reg	<= 32'h0;
			imm_s_data_reg	<= 32'h0;
			imm_b_data_reg	<= 32'h0;
			imm_u_data_reg	<= 32'h0;
			imm_j_data_reg	<= 32'h0;
			opcode_reg		<= 8'h0;
			pc_out_reg		<= 32'h0;
			csr_addr_reg	<= 12'h0;
			uimm_reg			<= 32'h0;
			rs1_addr_reg	<= `SYS_REGS_WIDTH'h0;
			rs2_addr_reg	<= `SYS_REGS_WIDTH'h0;
			end
		else
			begin
			if(!halt)
				begin
				pc_out_reg		<= pc_in;
				rd_addr_reg		<= instr[11:7];  
				opcode_reg		<= instr[6:0];									// Decoding Opcode
				funct3_reg		<= instr[14:12];								// Decoding Function3
				funct7_reg		<= instr[31:25];								// Decoding Function7
				imm_i_data_reg	<= {{21{instr[31]}},instr[30:20]};										// Decoding I type Immediate data
				imm_s_data_reg	<= {{21{instr[31]}},instr[30:25],instr[11:7]};						// Decoding S type Immediate data		
				imm_b_data_reg <= {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};   // Decoding B type Immediate data
				imm_u_data_reg <= {instr[31:12],12'b0};									   			// Decoding B type Immediate data
				imm_j_data_reg <= {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0}; // Decoding B type Immediate data
				uimm_reg			<= {27'b0,instr[19:15]};	// Decoding uimm data 
				csr_addr_reg	<= instr[31:20];	// Decoding CSR address 
				rs1_addr_reg	<= instr[19:15]; // Decoding rs1_addr
				rs2_addr_reg	<= instr[24:20]; // Decoding rs2_addr
				end
			end
		end
endmodule

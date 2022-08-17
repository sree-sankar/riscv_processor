`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:00 06/22/2022 
// Design Name: 
// Module Name:    sys_regs_if 
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
`include "header_files/register_definition.vh"
module sys_regs_if(
	input									clk,				// System Clock
	input									rst_n,			// System Reset
	input									halt,				// Halt 
	input									halt_fetch, 	// Halt fetch
	input  [`FUNCT3_LEN-1:0]      funct3_in,		// Function 3 
	input  [`OPCODE_WIDTH-1:0]    opcode_in,		// Opcode	 
   input  [`SYS_REGS_WIDTH-1:0]	rs1_addr,		// Operand Address 1
	input  [`SYS_REGS_WIDTH-1:0]	rs2_addr,		// Operand Address 2
	input  [`SYS_REGS_WIDTH-1:0]  rd_addr,  		// Destination Address
   input  [`XLEN-1:0]  				write_data,   	// Data register
   output [`XLEN-1:0]  				rs1_data, 		// Read Operand 1
   output [`XLEN-1:0]  				rs2_data  		// Read Operand 2
	);

	wire read_en;
	wire write_en;
	wire fn3_sel;
	wire opcode_sel;
	
	// Control Signal Generation
	assign fn3_sel 	 = (funct3_in == `FN3_SB || funct3_in == `FN3_SH  || 
								 funct3_in == `FN3_SW || funct3_in == `FN3_SBU ||
								 funct3_in == `FN3_SHU ) ? opcode_sel : 1'b0;
								 
	assign opcode_sel  = (opcode_in == `STORE) ? 1'b0 : 1'b1;
	assign read_en	 	 = (!halt_fetch) ? 1'b1 : 1'b0;
	assign write_en	 = !halt & opcode_sel ;
	 
	 sys_regs system_regs_inst(
       .clk                 (clk                    	),
       .rst_n               (rst_n                  	),
       .read_en             (read_en         	 	 	),
       .write_en            (write_en         	 		),
       .rs1_addr            (rs1_addr         			),
       .rs2_addr            (rs2_addr         			),
       .rd_addr             (rd_addr            		),
       .write_data          (write_data            	),
       .rs1_data            (rs1_data         			),
       .rs2_data            (rs2_data         			)
    );
endmodule

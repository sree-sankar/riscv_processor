`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              : 
// Engineer             : 
// 
// Create Date          : 05.12.2021 12:48:12
// Design Name          : 
// Module Name          : halt_cntrl
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
module halt_cntrl(
   input                clk,
   input                rst_n,
   input                taken_branch,
   input [`XLEN-1:0]    fetch_instr,
   input [`XLEN-1:0]    decode_instr,
   input [`XLEN-1:0]    exec_instr,
   input [`XLEN-1:0]    mem_opcode,
   output 					halt_fetch,
   output 					halt_decode,
   output 					halt_exec,
	output					halt_mem,
   output 					halt_reg
);
                    
	reg [4:0] halt;
	
	
	assign halt_fetch  		 = halt[0] | rst_halt[0];
	assign halt_decode 		 = halt[1] | rst_halt[1];
	assign halt_exec   		 = halt[2] | rst_halt[2];
	assign halt_mem		    = halt[3] | rst_halt[3];
	assign halt_reg          = halt[4] | rst_halt[4];
	
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         halt <= 5'b00000;
         end
//      else if((mem_opcode == `LOAD) && ((execute_instr[19:15] == mem_instr[11:7]) || (execute_instr[24:20] == mem_instr[11:7])))
//         begin
//         halt <= 5'b11100;
//         end 
//         //else if(if_id_instr == id_ex_instr) begin
//         //halt <= 5'b11000;
//         //end
      else
         begin
         halt <= 5'b00000;
         end
      end
		
// Halt on reset 
	reg [4:0]  rst_halt;
	reg 		  rst_d;
	wire       rst_posedge;
	reg [4:0]  rst_pipe;
	
	always @(posedge clk)
		begin
		if(!rst_n)
			begin
			rst_halt <= 5'b11110;
			rst_d		<= 1'b0;
			rst_pipe	<= 5'b0;
			end
		else
			begin
			rst_d 	<= rst_n;
			rst_pipe	<= {rst_pipe[3:0],rst_posedge};
			if(rst_posedge)
				rst_halt	<= 5'b11100;
			//else if(rst_pipe[0])	
			//	rst_halt	<= 5'b11100;
			else if(rst_pipe[0])
				rst_halt	<= 5'b11000;
			else if(rst_pipe[1])
				rst_halt	<= 5'b10000;
			else if(rst_pipe[2])
				rst_halt	<= 5'b00000;
			else if(rst_pipe[3])
				rst_halt	<= 5'b00000;
			else 
				rst_halt <= 5'b00000;
			end
		end
	
	assign rst_posedge = rst_n & ~rst_d;
		
endmodule

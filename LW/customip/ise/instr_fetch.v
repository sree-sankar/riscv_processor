`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              : 
// Engineer             : 
// 
// Create Date          : 05.12.2021 12:48:12
// Design Name          : 
// Module Name          : instr_fetch
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
module instr_fetch(
      input                     clk,                // System Clock 
      input                     rst_n,              // Synchronized Negative Reset
      input                     halt,               // Halt enable signal
      input                     branch_en,          // Branch enable
      input  [`XLEN-1:0]        branch_addr,        // Addr when branch occurs          
		output                    branch_taken,       // Branch taken signal
      output [`XLEN-1:0]        pc,                 // Program Counter		
		
		
		//Control Signal
		output                    instr_read_en       // Intstruction fetch read signal
);
   reg [`XLEN-1:0]              pc_reg;             // PC Register
   reg                          branch_taken_reg;   // Taken branch reg
	
   assign pc            = pc_reg;
   assign branch_taken  = branch_taken_reg;

	//Instruction Read Control
   assign instr_read_en = (!halt & rst_n) ? 1'b1 : 1'b0; 
   
	// PC Increment
   always @(posedge clk)
      begin
      if(!rst_n) 
         begin
         pc_reg            <= 32'h0;
         branch_taken_reg  <= 1'b0;     
         end
      else 
         begin
         if(!halt)
            begin
            if(branch_en)
               begin
               pc_reg           <= branch_addr;
               branch_taken_reg <= 1'b1;
					end 
            else
               begin
               pc_reg           <= pc_reg + `PC_INC;
               branch_taken_reg <= 1'b0; 
               end  
         end
         else 
            begin
               pc_reg           <= pc_reg;
               branch_taken_reg <= branch_taken_reg;  
            end
			end
      end 
			
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.12.2021 12:48:12
// Design Name: 
// Module Name: instr_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instr_decode( input i_clk,
                     input i_halt,
                     input[`XLEN-1:0] i_instruction,
                     input[`XLEN-1:0] i_reg_bank [0:`XLEN-1]
                     
                     output [`XLEN-1:0] i_instruction
    );
    
    
endmodule

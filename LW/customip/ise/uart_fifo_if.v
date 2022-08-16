`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:48 08/14/2022 
// Design Name: 
// Module Name:    uart_fifo_if 
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
module uart_fifo_if(
	input 		 clk,
	input 		 fifo_rd_en,
	input			 fifo_wr_en,
	
	input	 [7:0] fifo_din,
	output		 fifo_empty,
	output		 fifo_full,
	output [7:0] fifo_dout
   );
	


endmodule

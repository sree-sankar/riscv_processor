`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:19 06/25/2022 
// Design Name: 
// Module Name:    uart_if 
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

module uart_if(
	input						clk,			// Clock
	input						rst_n,		// Reset Signal
	input						uart_clk,	// UART Clock
	input [`XLEN-1:0]		uart_addr,	// UART Memory address
	input						uart_en,		// UART enable
	input						mem_wr_en,	// Memory Write Enable
	input						mem_rd_en,	// Memory Read Enable
	input						uart_tx_en,	// UART TX Enable
	input						uart_rx_en,	// UART RX Enable
	input [`XLEN-1:0]    uart_tx_data,
	// UART Signals
	//input 					uart_rx,
	output					uart_tx
   );
		
	parameter [8:0] DIVISOR  	 = 9'd326;
	parameter [3:0] DATA_BIT 	 = 4'd8;
	parameter [3:0] DVSR_BIT 	 = 4'd9;
	parameter [4:0] STP_BIT_TCK = 5'd16;
	parameter [4:0] FIFO_Add_Bit = 4'd11;
	// FIFO Signal
	wire					tx_fifo_wr_en;
	wire 					tx_fifo_rd_en;
	wire					tx_fifo_full;
	wire					tx_fifo_empty;
	wire [7:0]			tx_fifo_din;
	wire [7:0]			tx_fifo_dout;
	
	// FIFO Signal
//	wire					rx_fifo_wr_en;
//	wire 					rx_fifo_rd_en;
//	wire					rx_fifo_full;
//	wire					rx_fifo_empty;
//	wire [7:0]			rx_fifo_din;
//	wire [7:0]			rx_fifo_dout;
	
	wire					 tx;
	wire					 tck;
	wire [DIVISOR-1:0] q;
	wire 					 tx_done_tck;
	wire 					 tx_start;
	
	assign uart_tx	= (rst_n) ? tx : 1'b1;//(tx_end) ? 1'b1 : tx;
	
	// UART TX
	assign tx_fifo_din	= uart_tx_data[7:0];
	assign tx_fifo_wr_en = uart_en & mem_wr_en;
	assign tx_fifo_rd_en = tx_done_tck; //| ~tx_fifo_empty & uart_tx_en;
	
	assign tx_start = ~tx_fifo_empty & ~tx_fifo_empty & uart_tx_en;
	// Baud Gen
	mod_m_counter #(
						.M	(DIVISOR	),
						.N	(DVSR_BIT)
						) 
	baud_gen_unit(
					  .clk		(clk					),
					  .reset		(rst_n				),
					  .q			(q						),
					  .max_tck	(tck					)
					  );
	// UART TX IF
	uart_tx #(
				 .DBIT		  (DATA_BIT				), 
				 .SB_tck		  (STP_BIT_TCK			)
				 ) 
	uart_tx_unit(
				 .clk			  (clk					),
				 .reset		  (rst_n					),
				 .tx_start	  (tx_start 			),
				 .s_tck		  (tck					), 
				 .din			  (tx_fifo_dout		),
				 .tx_done_tck (tx_done_tck			),
				 .tx			  (tx						)
				 );

//	fifo #(
//				.B				  (DATA_BIT				),
//				.W				  (FIFO_Add_Bit 		)
//			) 
//	fifo_tx_unit(
//				.clk			  (clk					),
//				.reset		  (rst_n					),
//				.rd			  (tx_done_tck       ),
//				.wr			  (tx_fifo_wr_en		),
//				.w_data		  (tx_fifo_din			),
//				.empty		  (tx_fifo_empty		),
//				.full			  (tx_fifo_full		),
//				.r_data		  (tx_fifo_dout		)
//				);
	
//	reg [5:0] tx_cnt;
//	reg		 tx_end;
//	
//	always @(posedge clk)
//		begin
//		if(!rst_n)
//			begin
//			tx_cnt <= 5'b0;
//			tx_end <= 1'b0;
//			end
//		else
//			begin
//			if(tx_cnt == 5'd11)
//				begin
//				tx_end <= 1'b1;
//				end
//			else if(tx_done_tck)
//				tx_cnt <= tx_cnt + 1'b1;
//			end
//		end

	uart_fifo tx_fifo (
	  .clk	(clk					), // input clk
	  .din	(tx_fifo_din		), // input [7 : 0] din
	  .wr_en	(tx_fifo_wr_en		), // input wr_en
	  .rd_en	(tx_done_tck		), // input rd_en
	  .dout	(tx_fifo_dout		), // output [7 : 0] dout
	  .full	(tx_fifo_full		), // output full
	  .empty (tx_fifo_empty		) // output empty
	);

endmodule

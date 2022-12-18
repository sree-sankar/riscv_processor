`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              : 
// Engineer             :  
// 
// Create Date          : 06.12.2020 11:31:51
// Design Name          : 
// Module Name          : csr_regs
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

module riscv_ps_top(
    input       clk,        // System Clock
    input       rst_n,      // Synchronous Reset (Asserted Low)
	 // Reset LED
    output      rst_led,    // Reset LED

    // SPI Flash 
    input       spi_sdin,   // Serial Data In
    output      spi_sdout,  // Serial Data Out
    output      spi_sclk,   // Serial Clock,
    output      spi_cs_n,   // Chip Select

	 // UART
	 //input       uart_rx,    // UART RX
    output      uart_tx,    // UART TX
    
	 // GPIO
    output      led    		 // GPIO LED
);

//    wire [`XLEN-1:0] instr;          // Instruction
//    wire [`XLEN-1:0] mem_rd_data;    // Memory Read Data
//    wire [`XLEN-1:0] mem_wr_data;    // Memory Read Data
//    wire [`XLEN-1:0] mem_addr;       // Memory Address
//    wire [`XLEN-1:0] instr_rd_addr;  // Instruction Read Address
//    
//	// Clock Signals
//	wire					boot_clk;		 // Boot clock 50MHz
//	wire					core_clk;		 // Core clock 100MHz
//	wire					uart_clk;		 // UART clock 100MHz
//	
//	// Control Signals
//    wire 				sys_rst_n;      // System Reset 
//    wire 				sys_clk;        // System Clock
//	 wire 				instr_rd_en;    // Instruction Read Enable
//    wire 				mem_data_rd_en; // Data Read Enable    
//    wire		 			mem_data_wr_en; // Data Write Enable
//    
//	 // Address Decoding Signals
//	 wire [`XLEN-1:0]	addr_decode_mem_addr;
//	 
//	 // UART Signals
//	 wire 				uart0_addr_en;
//	 wire [`XLEN-1:0] uart0_addr;
//	 
//	 // GPIO Signals
//	 wire 				gpio0_addr_en;
//	 wire [`XLEN-1:0] gpio0_addr;
	wire [`XLEN-1:0]	boot_rom_rd_addr;
	wire [`XLEN-1:0]	boot_rom_rd_data;
////---------------------------------------------------------------------------//
//// RISC V Core 0
////---------------------------------------------------------------------------//
	assign rst_led = rst_n;
//	
//	rv_core riscv_core(
//		 .clk            (clk                        ),
//		 .rst_n          (sys_rst_n                  ),
//		 .pc             (instr_rd_addr              ),
//		 .instr			  (instr								),
//		 .mem_addr       (mem_addr                   ),	 
//		 .mem_write_data (mem_wr_data						),
//		 .mem_read_data  (mem_rd_data						),
//		 .instr_rd_en	  (instr_rd_en						),
//		 .mem_data_rd_en (mem_data_rd_en					),
//		 .mem_data_wr_en (mem_data_wr_en					)
//	);
////---------------------------------------------------------------------------//
//// Clock Generator
////---------------------------------------------------------------------------//
	clock_gen_if clock_gen_if_inst(
		.clk				 (clk									),
		.rst_n			 (rst_n								),
		.sys_rst_n		 (sys_rst_n							),
		.core_clk		 (core_clk							),
		.uart_clk		 (uart_clk							),
		.boot_clk		 (boot_clk							)
	);
////---------------------------------------------------------------------------//
//// Boot Controller
////---------------------------------------------------------------------------//
//	boot_cntrl  boot_cntrl_inst(
//		 .clk              (clk                      ),
//		 .rst_n            (rst_n                    ),
//		 .boot_rst_n		 (boot_rst_n					)
//	);
//
//	assign sys_rst_n = rst_n;
//
////---------------------------------------------------------------------------//
//// Internal Boot ROM
////---------------------------------------------------------------------------//
	
	assign boot_rom_rd_addr = 32'h0000_0000;
	boot_rom_if boot_rom_inst(
		 .clk            (clk                   		),
		 .rst_n          (rst_n                 	 	),
		 .read_addr		  (boot_rom_rd_addr				),
		 .read_data		  (boot_rom_rd_data				), 
		 .read_en		  (1'b1								),
		 .write_addr	  (32'b0								), 
		 .write_data     (32'b0								), 
		 .write_en		  (1'b0								),
		 .sclk			  (spi_sclk							),
		 .sdout			  (spi_sdout						),
		 .sdin			  (spi_sdin							),
		 .cs_n			  (spi_cs_n							)

	);
////---------------------------------------------------------------------------//
//// Internal Boot RAM
////---------------------------------------------------------------------------//
//	boot_ram_if boot_ram_inst(
//		 .clk              (clk                      ),
//		 .rst_n            (rst_n                    ),
//		 .instr				 (instr							),
//		 .instr_rd_addr    (instr_rd_addr            ),
//		 .instr_rd_en      (instr_rd_en              ),
//		 .data_rd_en       (mem_data_rd_en           ),
//		 .data_wr_en       (mem_data_wr_en				),
//		 .mem_addr         (addr_decode_mem_addr     ),
//		 .mem_rd_data      (mem_rd_data              ),
//		 .mem_wr_data      (mem_wr_data              )    
//	);
//
////---------------------------------------------------------------------------//
//// Address Decoder
////---------------------------------------------------------------------------//
//	addr_decoder addr_decoder_inst(
//		.mem_addr	 		 (mem_addr						),
//		.data_mem_addr		 (addr_decode_mem_addr		),
//		.uart0_addr_en 	 (uart0_addr_en				),
//		.uart0_addr			 (uart0_addr					),
//		.gpio0_addr_en		 (gpio0_addr_en				),
//		.gpio0_addr			 (gpio0_addr					)
//	);
////---------------------------------------------------------------------------//
//// GPIO Controller
////---------------------------------------------------------------------------//
//	gpio_if gpio_if_inst(
//		.clk					 (clk								),
//		.rst_n				 (rst_n							),
//		.en					 (gpio0_addr_en				),
//		.addr					 (gpio0_addr					),
//		.data_in				 (mem_wr_data					),
//		.led					 (led								)
//	);
////---------------------------------------------------------------------------//
//// UART Controller
////---------------------------------------------------------------------------//
//	wire uart_tx_en;
//
//	assign uart_tx_en = rst_n;
//
//	uart_if uart_if_inst(
//		.clk					 (clk								),
//		.rst_n				 (rst_n							),
//		.uart_clk			 (clk								),
//		.uart_en				 (uart_addr_en					),
//		.uart_addr			 (uart_addr						),
//		.uart_tx_data		 (mem_wr_data					),
//		.mem_wr_en			 (mem_data_wr_en				),
//		.mem_rd_en			 (mem_data_rd_en				),
//		.uart_tx_en			 (uart_tx_en					),
//		.uart_rx_en			 (uart_en						),
//		.uart_tx				 (uart_tx						)
//		//.uart_rx				 (uart_rx						)
//	);
endmodule

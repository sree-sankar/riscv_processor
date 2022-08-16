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

//    // SPI Flash 
//    input       spi_sdi,    // Serial Data In
//    output      spi_sdo,    // Serial Data Out
//    output      spi_sclk,   // Serial Clock,
//    output      spi_cs,     // Chip Select
//
//    // LED
    output      rst_led,    // Reset LED
//
//    //UART
//    input       uart_rx,    // UART RX
    output      uart_tx     // UART TX
//
//    //GPIO
//    output      gpio_led    // GPIO LED
);

    wire [`XLEN-1:0] instr;          // Instruction
    wire [`XLEN-1:0] mem_rd_data;    // Memory Read Data
    wire [`XLEN-1:0] mem_wr_data;    // Memory Read Data
    wire [`XLEN-1:0] mem_addr;       // Memory Address
    wire [`XLEN-1:0] instr_rd_addr;  // Instruction Read Address
    
    // Control Signals
    wire sys_rst_n;                 // System Reset 
//    wire sys_clk;                   // System Clock
//    wire spi_clk;                   // SPI Clock
//    wire uart_clk;                  // UART Clock
    wire instr_rd_en;               // Instruction Read Enable
    wire mem_data_rd_en;            // Data Read Enable    
    wire mem_data_wr_en;            // Data Write Enable
    
	 // Address Decoding Signals
	 wire [`XLEN-1:0]	addr_decode_mem_addr;
	 
	 // UART Signals
	 wire 				uart_en;
	 wire [`XLEN-1:0] uart_addr;
//---------------------------------------------------------------------------//
// RISC V Core 0
//---------------------------------------------------------------------------//
	assign rst_led = rst_n;
	
rv_core riscv_core(
    .clk            (clk                        ),
    .rst_n          (sys_rst_n                  ),
    .pc             (instr_rd_addr              ),
    .instr			  (instr								),
	 .mem_addr       (mem_addr                   ),	 
    .mem_write_data (mem_wr_data						),
    .mem_read_data  (mem_rd_data						),
	 .instr_rd_en	  (instr_rd_en						),
    .mem_data_rd_en (mem_data_rd_en					),
    .mem_data_wr_en (mem_data_wr_en					)
);

//---------------------------------------------------------------------------//
// Internal Boot ROM
//---------------------------------------------------------------------------//
//boot_rom_if boot_rom_inst(
//    .clk            (clk                        ),
//    .rst_n          (rst_n                      )
//
//);
//---------------------------------------------------------------------------//
// Internal Boot RAM
//---------------------------------------------------------------------------//
boot_ram_if boot_ram_inst(
    .clk              (clk                      ),
    .rst_n            (rst_n                    ),
	 .instr				 (instr							),
    .instr_rd_addr    (instr_rd_addr            ),
    .instr_rd_en      (instr_rd_en              ),
    .data_rd_en       (mem_data_rd_en           ),
    .data_wr_en       (mem_data_wr_en				),
    .mem_addr         (addr_decode_mem_addr     ),
    .mem_rd_data      (mem_rd_data              ),
    .mem_wr_data      (mem_wr_data              )    
);

//---------------------------------------------------------------------------//
// Address Decoder
//---------------------------------------------------------------------------//
addr_decoder addr_decoder_inst(
	.mem_addr	 		 (mem_addr						),
	.data_mem_addr		 (addr_decode_mem_addr		),
	.uart_addr_detect	 (uart_en						),
	.uart_addr			 (uart_addr						)
);
//---------------------------------------------------------------------------//
// Boot Controller
//---------------------------------------------------------------------------//
//boot_cntrl  boot_cntrl_inst(
//    .clk              (clk                      ),
//    .rst_n            (rst_n                    ),
//	   .sys_rst_n			 (sys_rst_n						)
//);

assign sys_rst_n = rst_n;
//---------------------------------------------------------------------------//
// Clock Generation
//---------------------------------------------------------------------------//
//clock_gen   clock_gen(
//    .clk            (clk                        ),
//    .rst_n          (rst_n                      ),
//    .sys_clk        (sys_clk                    ),
//    .spi_clk        (spi_clk                    ),
//    .uart_clk       (uart_clk                   ),
//	 .boot_clk		  (boot_clk							),
//	 .rst_n_locked	  (rst_n_locked					)
//);
//---------------------------------------------------------------------------//
// UART Controller
//---------------------------------------------------------------------------//
uart_if uart_top_inst(
	.clk					 (clk								),
	.rst_n				 (rst_n							),
	.uart_clk			 (clk								),
	.uart_en				 (uart_en						),
	.uart_addr			 (uart_addr						),
	.uart_tx_data		 (mem_wr_data					),
	.mem_wr_en			 (mem_data_wr_en				),
	.mem_rd_en			 (mem_data_rd_en				),
	.uart_tx_en			 (1'b1							),
	.uart_rx_en			 (1'b0							),
	.uart_tx				 (uart_tx						)
	//.uart_rx				 (uart_rx						)
);
endmodule

`timescale 10ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:26:49 06/19/2022
// Design Name:   rv_core
// Module Name:   D:/Development/RISC_V_32I/LW/testbench/tb_rv32i_core.v
// Project Name:  rv_32i
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rv_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module tb_rv32i_core;

	// Inputs
	reg clk;
	reg rst_n;
	reg clk_180p;
	
	initial begin
	clk <= 0; rst_n <= 0;
	clk_180p <= 1;
	#5 rst_n <= 1'b1;
	end

	// Clock
	always #5 clk = ~clk;
	always #5 clk_180p = ~clk_180p; 
//---------------------------------------------------------------------------//
// Top level Testbench
//---------------------------------------------------------------------------//
//`define TOP 	0
//`define CORE 	0

`ifdef TOP
    // SPI Flash 
    reg       spi_sdi;    // Serial Data In
    wire      spi_sdo;    // Serial Data Out
    wire      spi_sclk;   // Serial Clock,
    wire      spi_cs;     // Chip Select

    // LED
    wire      rst_led;    // Reset LED

    //UART
    reg       uart_rx;    // UART RX
    wire      uart_tx;    // UART TX

    //GPIO
    wire      gpio_led;    // GPIO LED
	 
riscv_ps_top uut(
	 .clk			(clk				),      
    .rst_n		(rst_n			), 

//    // SPI Flash 
//    .spi_sdi	(spi_sdi			),
//    .spi_sdo	(spi_sdo			),
//    .spi_sclk	(spi_sclk		),
//    .spi_cs		(spi_cs			),
//	 
//    // LED
//    .rst_led	(rst_led			),    // Reset LED
//
    //UART
//    .uart_rx	(uart_rx			),    // UART RX
    .uart_tx	(uart_tx			)    // UART TX
//
//    //GPIO
//    .gpio_led  (gpio_led		)
);  
`elsif CORE 
//---------------------------------------------------------------------------//
// Core level Testbench
////---------------------------------------------------------------------------//
	reg [31:0] instr;
	reg [31:0] mem_read_data;

	// Outputs
	wire [31:0] mem_write_data;
	wire [31:0] mem_addr;
	wire [31:0] pc;
	wire instr_rd_en;
	wire mem_data_rd_en;
	wire mem_data_wr_en;
	integer i;
		
// Instantiate the Unit Under Test (UUT)
	rv_core uut (
		.clk					(clk					), 
		.rst_n				(rst_n				), 
		.instr				(instr				), 
		.mem_write_data	(mem_write_data	),
		.mem_read_data		(mem_read_data    ),
		.mem_addr			(mem_addr			), 
		.pc					(pc					), 
		.instr_rd_en		(instr_rd_en		), 
		.mem_data_rd_en	(mem_data_rd_en	), 
		.mem_data_wr_en	(mem_data_wr_en	)
	);

	initial begin
		mem_read_data <= 32'b0;
//	// Print Hello World! Assembly Code
//		
//		// Generate Address 4321
		#15 instr <= 32'b0000000_00000_00000_000_00000_0110011;	// 0x00 nop instr 
		#10 instr <= 32'b0000_0001_0100_00000_000_00011_0010011; // 0x04 addi r3 r0 0x14		// 5<<20 = UART ADDR0 32'h0050_0000
		#10 instr <= 32'b0000_0000_0101_00000_000_00100_0010011; // 0x08 addi r4 r0 0x5			
		#10 instr <= 32'b0000000_00011_00100_001_00101_0110011;	// 0x0C sll r5 r4 r3		// 5<<20 // Generate load address 
//		
//		// Send H
			#10 instr <= 32'b0000_0100_1000_00000_000_00010_0010011;	// 0x10 addi r2 r0 0x48 	// H ASCII -> 0x47
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;	// sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		// Send e
			#10 instr <= 32'b0000_0110_0101_00000_000_00010_0010011; // addi r2 r0 0x65 	// e-> 0x65
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)

		// Send l and l
			#10 instr <= 32'b0000_0110_1100_00000_000_00010_0010011; // addi r2 r0 0x6C 	// l-> 0x6C
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;// sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;// sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send o
			#10 instr <= 32'b0000_0110_1111_00000_000_00010_0010011; // addi r2 r0 0x6F 	// o-> 0x6F
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send Space
			#10 instr <= 32'b0000_0010_0000_00000_000_00010_0010011;	// addi r2 r0 0x20 // Space -> 
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send W
			#10 instr <= 32'b0000_0101_0111_00000_000_00010_0010011; // addi r2 r0 0x57 // W 
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send o
			#10 instr <= 32'b0000_0110_1111_00000_000_00010_0010011; // addi r2 r0 0x6F // o
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send r
			#10 instr <= 32'b0000_0111_0010_00000_000_00010_0010011; // addi r2 r0 0x72 // r
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send l
			#10 instr <= 32'b0000_0110_1100_00000_000_00010_0010011; // addi r2 r0 0x6C // l
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send d
			#10 instr <= 32'b0000_0110_0100_00000_000_00010_0010011; // addi r2 r0 0x64 // d
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send !
			#10 instr <= 32'b0000_0010_0001_00000_000_00010_0010011; // addi r2 r0 0x21 // !
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send new line
			#10 instr <= 32'b0000_0000_1010_00000_000_00010_0010011; // addi r2 r0 0x0A // !
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		// Send carriage return
			#10 instr <= 32'b0000_0000_1101_00000_000_00010_0010011; // addi r2 r0 0x0D // !
			#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;  // sb r2, (0x0) r5  // Load value from r2 to (r5_data + 0x0)
		
		//	LED Light	
			#10 instr <= 32'b0000_0000_0110_00000_000_00110_0010011; // addi r6 r0 0x6			
			#10 instr <= 32'b0000000_00011_00100_001_00101_0110011;	// sll r5 r4 r3		// 5<<20 // Generate load address 
			// Write 1 to GPIO0
			#10 instr <= 32'b0000_0000_0001_00000_000_00111_0010011; // addi r7 r0 0x1 // 1
			#10 instr <= 32'b0000000_00111_00110_000_00000_0100011;  // sb r7, 0x0(r6)  // Load value from r2 to (r5_data + 0x0)
		
		// Branch to 0x10
		#10 instr <= 32'h0100_0067;	//jalr r0,r0,0x10
		
		// LED Blinky
			//Set Counter
			// addi r9,r0,0x5F		
			// addi r12,r0,0x1C
			// sll  r11,r9,r12
			
			// addi r10,r0,0x5E1
			// addi r12,r0,0x14
			// sll  r10,r9,r12
		#10 instr <= 32'b0000000_00000_00000_000_00000_0110011; //nop
		#10 instr <= 32'b0000000_00000_00000_000_00000_0110011; //nop
		#10 instr <= 32'b0000000_00000_00000_000_00000_0110011; // nop
		
		#20 instr <= 32'b0000_0100_1000_00000_000_00010_0010011;	// 0x10 addi r2 r0 0x48 	// H ASCII -> 0x47
		#10 instr <= 32'b0000000_00010_00101_000_00000_0100011;
		
		#10 for(i = 0; i<= 1000; i= i+1)
			begin
			instr <= 32'bx;//instr <= 32'b0000000_00000_00000_000_00000_0110011;
			end
	end
`else
	reg 			spi_en;
	reg [7:0]	tx_data;
	reg			sdin;
	wire [7:0]  rx_data;
	wire 			sclk;
	wire 			cs_n;
	wire 			sdout;
	spi_master dut (
    .clk					(clk				), 
    .clk_180p			(clk_180p		), 
    .rst_n				(rst_n			), 
    .spi_en				(spi_en			), 
    .tx_data			(tx_data			), 
    .rx_data			(rx_data			), 
    .sdin				(sdin				), 
    .sdout				(sdout			), 
    .sclk				(sclk				), 
    .cs_n				(cs_n				)
    );

	initial begin
	spi_en <= 1'b0; tx_data <= 8'h9E;
	#10 spi_en <= 1'b1;
	end
	
	reg [7:0]		clk_cnt;
	reg [2:0]		rx_data_cnt;
	reg [7:0]		flash_rx_data;
	reg [7:0]		flash_data_cnt;
	reg [7:0]		flash_tx_data;
	reg				flash_sdout;
	reg				flash_tx_en;
	reg [2:0]		flash_sdout_cnt;

	always @(posedge sclk or negedge rst_n)
		begin
		if(~rst_n)
			begin
			flash_tx_data   <= 8'h20;
			sdin   		    <= 1'b0;
			flash_sdout_cnt <= 3'b111;
			end
		else
			begin
			if(flash_rx_data == 8'h9E)
				begin
				flash_tx_en <= 1'b1;
				end
			if(flash_tx_en == 1'b1 & flash_sdout_cnt >= 3'b000)
				begin
				sdin 					<= flash_tx_data[flash_sdout_cnt];
				flash_sdout_cnt	<= flash_sdout_cnt - 1'b1;
				end
			end
		end
	
	always @(posedge sclk or negedge rst_n)
		begin
		if(~rst_n)
			begin
			rx_data_cnt 		<= 3'b111;
			flash_rx_data		<= 8'h00;
			flash_data_cnt		<= 8'h00;
			end
		else
			begin
			flash_data_cnt <= rx_data_cnt;
			if(rx_data_cnt >= 3'b000)
				begin
				flash_rx_data[flash_data_cnt] <= sdout;
				rx_data_cnt						   <= rx_data_cnt -1;	
				end
			end
		end
	
`endif
//---------------------------------------------------------------------------//
// Fetch State Testbench
//---------------------------------------------------------------------------//
//	reg 					halt_fetch;
//	reg 					branch_en;
//	reg [31:0]  		branch_addr;
//	wire 					branch_taken;
//	wire 					instr_read_en;
//	
//	wire [31:0] 		pc;
//	
//	instr_fetch uut(
//			.clk                	(clk                        	),
//			.rst_n              	(rst_n                      	),
//			.halt               	(halt_fetch                   ),
//			.branch_en          	(branch_en                  	),
//			.branch_taken       	(branch_taken               	),
//			.branch_addr			(branch_addr						),
//			.instr_read_en       (instr_read_en                ),
//			.pc                 	(pc                         	)
//    );
//	 initial
//		begin
//		halt_fetch <= 0; 
//		branch_en <= 0; 
//		branch_addr <= 32'h0000_0000;
//		
//		//#50 halt_fetch <= 1;
//		#100 branch_en <= 1; branch_addr<= 32'hA0A0_A0A0;
//		end
endmodule


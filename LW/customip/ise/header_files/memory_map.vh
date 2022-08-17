//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2020 12:07:34
// Design Name: 
// Module Name: define
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
//
//
//-----------------Memory Map---------------------------//

`define BOOT_RAM_BASE     	32'h0000_0000
`define BOOT_RAM_OFFSET		32'h000F_FFFF

`define BOOT_ROM_BASE     	32'h0000_0000
//`define RESERVED            32'h
`define UART0_BASE       	32'h0050_0000
`define UART0_OFFSET			32'h0001_0000

//`define RESERVED            32'h
//`define SPI0        		32'h0000_0000
//`define SPI1    			32'h0000_0000
//`define RESERVED            32'h
//`define MEM_MAP_UART0       32'h0000_0000
//`define RESERVED            32'b
//`define MEM_MAP_GPIO0       32'h0000_0000
//`define RESERVED            32'b
//`define MEM_MAP_DDR         32'h0000_0000
//`define RESERVED            32'b
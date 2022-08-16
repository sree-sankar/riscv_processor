`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              : 
// Engineer             :  
// 
// Create Date          : 18.06.2022 
// Design Name          : 
// Module Name          : dev_sel_cntrl
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

module dev_sel_cntrl(
    input               clk,
    input               rst_n,
    input [XLEN-1:0]    addr_in,
    output              boot_dev_sel,
    output              spi_dev_sel,
    output              uart_dev_sel,
    output              gpio_dev_sel
);

endmodule
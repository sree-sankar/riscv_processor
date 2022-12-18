`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:03:49 06/25/2022
// Design Name:
// Module Name:    clock_gen
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
module clock_gen_if(
    input             clk       , // Input clock from OSCILLATOR    : 100MHz
    input             rst_n     , // Reset Signal
    output            core_clk  , // Clock at which the core runs   : 100MHz
    output            boot_clk  , // Clock at which booting is done : 50MHz
    output            uart_clk  , // UART Clock                     : 100MHz
    output            sys_rst_n   // System Reset
    );

    wire    clk_rst  ; // Active High Reset for CLK_WIZ IP (Active low reset not possible)
    wire    clk_100M ; // 100MHz Clock
    wire    clk_50M  ; // 50 MHz Clock


    assign clk_rst  = ~clk_rst_n ;
    assign core_clk = clk_100M   ;
    assign uart_clk = clk_100M   ;
    assign boot_clk = clk_50M    ;

  clock_gen clock_gen_inst(
   .clk_in1       (clk           ), // IN
   .rst           (clk_rst       ), // IN
   .clk_out1      (clk_100M      ), // OUT
   .clk_out2      (clk_50M       ), // OUT
   .locked        (locked        )
   );

endmodule

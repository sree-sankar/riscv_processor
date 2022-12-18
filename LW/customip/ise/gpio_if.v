`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:56:49 08/18/2022
// Design Name:
// Module Name:    gpio_if
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

module gpio_if(
    input                   clk     ,
    input                   rst_n   ,
    input                   en      ,
    input   [`XLEN-1:0]     addr    ,
    input   [`XLEN-1:0]     data_in ,
    output                  led
   );

    reg     led_reg;

    assign led = led_reg;

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            led_reg <= 1'b0;
            end
        else
            begin
            if(en)
                begin
                led_reg <= data_in[0];
                end
            end
        end

endmodule

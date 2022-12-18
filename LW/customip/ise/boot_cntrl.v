`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:03:34 06/25/2022
// Design Name:
// Module Name:    boot_cntrl
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
`include "header_files/memory_map.vh"

module boot_cntrl(
    input                   clk            , // Input Clock same as SPI read clock
    input                   rst_n          , // Reset
    input                   fsbl_data_done , // Ticks when one data is read
    output                  fsbl_load_en   , // Enable signal for loading fsbl
    output [`XLEN-1:0]      fsbl_src_addr  , // Starting address from FLASH Read begins w.r.t FLASH
    output                  boot_rst_n        // Boot Reset Set to 1 when a specific number of data is loaded
   );


    reg                 boot_rst_n_reg   ;
    reg                 fsbl_load_en_reg ;
    reg [`XLEN-1:0]     fsbl_load_cnt    ;

    localparam [`XLEN-1:0] MAX_FSBL_CNT = 32'b0000_0001;

    assign fsbl_src_addr = `FSBL_SRC_ADDR;
    assign boot_rst_n    = boot_rst_n_reg;
    assign fsbl_load_en  = fsbl_load_en_reg;

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            fsbl_load_cnt     <= 32'h0;
            boot_rst_n_reg    <= 1'b0;
            fsbl_load_en_reg  <= 1'b1;
            end
        else
            begin
            if(fsbl_load_cnt == (MAX_FSBL_CNT-1))
                begin
                boot_rst_n_reg    <= 1'b1;
                fsbl_load_en_reg  <= 1'b0;
                end
            else if(fsbl_data_done)
                begin
                fsbl_load_cnt  <= fsbl_load_cnt + 1'b1;
                end
            end
        end

endmodule

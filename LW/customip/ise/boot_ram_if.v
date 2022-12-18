`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:02:57 06/25/2022
// Design Name:
// Module Name:    boot_ram_if
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
module boot_ram_if(
    input                   clk           , // System Clock
    input                   rst_n         , // Synchronous Reset (Asserted Low)

    // Port A for Instruction
    input  [`XLEN-1:0]      instr_rd_addr , // Instruction Read Address
    output [`XLEN-1:0]      instr         , // Instruction
    input                   instr_rd_en   , // Instruction Read Enable

    // Port B for Data Access
    output [`XLEN-1:0]     mem_rd_data    , // Memory Read Data
    input  [`XLEN-1:0]     mem_wr_data    , // Memory Read Data
    input  [`XLEN-1:0]     mem_addr       , // Memory Address
    input                  data_rd_en     , // Data Read Enable
    input                  data_wr_en         // Data Write Enable
);
    wire [8:0]      addra      ;
    wire [4:0]      addrb      ;
    //wire            en         ;
    wire [3:0]      data_rd_wr ;
    wire            data_en    ;


    // Port A Control
    assign addra ={instr_rd_addr[10:2]};

    // Port B Control
    assign data_en      = data_wr_en || data_rd_en;
    assign data_rd_wr   = (data_rd_en & ~data_wr_en) ? 4'h0 : 4'hF;
    assign addrb        = 5'b0;
    assign mem_rd_data  = 32'b0;

    boot_ram boot_ram (
        .clka     (clk                ), // input clka
        .ena      (1'b1               ), // input ena
        .wea      (1'h0               ), // input [0 : 0] wea
        .addra    (addra              ), // input [8 : 0] addra
        .dina     (32'b0              ), // input [31 : 0] dina
        .douta    (instr              ), // output [31 : 0] douta

        .clkb     (clk                ), // input clkb
        .enb      (data_en            ), // input enb
        .web      (1'b0               ), // input [0 : 0] web
        .addrb    (addrb              ), // input [4 : 0] addrb
        .dinb     (mem_wr_data        ), // input [31 : 0] dinb
        .doutb    (   ) // output [31 : 0] doutb
);

endmodule

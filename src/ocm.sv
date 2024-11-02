//----------------------+-------------------------------------------------------
// Filename             | ocm.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// On-Chip Memory
//------------------------------------------------------------------------------

`include "../risc-v/riscv.vh"

module ocm(
    input                 icache_clk_i       ,
    input  [`XLEN-1:0]    icache_addr_i      ,
    input                 icache_read_en_i   ,
    input                 icache_write_en_i  ,
    output [`XLEN-1:0]    icache_read_data_o ,
    input  [`XLEN-1:0]    icache_write_data_i,
    input                 dcache_clk_i       ,
    input  [`XLEN-1:0]    dcache_addr_i      ,
    input                 dcache_read_en_i   ,
    input                 dcache_write_en_i  ,
    output [`XLEN-1:0]    dcache_read_data_o ,
    input  [`XLEN-1:0]    dcache_write_data_i
);

//------------------------------------------------------------------------------
// Instruction Cache
//------------------------------------------------------------------------------

    icache icache_inst (
        .clka     (icache_clk_i            ),
        .wea      (1'b0                    ),
        .addra    (icache_addr_i[`XLEN-1:2]),
        .dina     (icache_write_data_i     ),
        .douta    (icache_read_data_o      )
    );

//------------------------------------------------------------------------------
// Data Cache
//------------------------------------------------------------------------------

    dcache dcache_inst(
        .clka     (dcache_clk_i            ),
        .wea      (dcache_write_en_i       ),
        .addra    (dcache_addr_i[`XLEN-1:2]),
        .dina     (dcache_write_data_i     ),
        .douta    (dcache_read_data_o      )
    );

endmodule

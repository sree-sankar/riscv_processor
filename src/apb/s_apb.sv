`timescale 1ns / 1ps
//----------------------+-------------------------------------------------------
// Filename             | apb_interface.sv
// File created on      | 10.30.2024 10:30:00 PM
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Slave APB3 Interface
// Read/Write Interface should be CDCed to APB Clock in the input side
//------------------------------------------------------------------------------

`include "apb.vh"

module s_apb(
    // APB Signal
    input                      s_apb_pclk_i     , // APB Clock
    input                      s_apb_presetn_i  , // APB Reset
    input  [   `APB_AW-1:0]    s_apb_paddr_i    , // APB Address
    input                      s_apb_pwrite_i   , // APB Write
    input                      s_apb_psel_i     , // APB Select
    input                      s_apb_penable_i  , // APB Select
    output                     s_apb_pready_o   , // APB Slave Ready
    input  [   `APB_DW-1:0]    s_apb_pwdata_i   , // APB Write
    input  [`APB_STRBW-1:0]    s_apb_pstrb_i    , // APB Strobe
    output [   `APB_DW-1:0]    s_apb_rdata_o    , // APB Read data
    // Address
    output [   `APB_AW-1:0]    read_write_addr_o, // Write Address
    // Write Interface
    output                     write_en_o       , // Write Enable
    output [   `APB_DW-1:0]    write_data_o     , // Write Data
    // Read Interface
    output                     read_en_o        , // Read Enable
    input  [   `APB_DW-1:0]    read_data_i        // Read Data
);

//------------------------------------------------------------------------------
// Ready Status Generation
//------------------------------------------------------------------------------

    logic    apb_pready_reg;

    always_ff @(posedge s_apb_pclk_i)
        begin
        if(!s_apb_presetn_i)
            begin
            apb_pready_reg <= 'h0;
            end
        else
            begin
            apb_pready_reg <= 'h1;
            end
        end

//------------------------------------------------------------------------------
// APB Slave Write
//------------------------------------------------------------------------------

    logic                  write_en      ;
    logic                  write_en_reg  ;
    logic [`APB_DW-1:0]    write_data_reg;
    logic [`APB_AW-1:0]    write_addr_reg;

    always_ff @(posedge s_apb_pclk_i)
        begin
        if(!s_apb_presetn_i)
            begin
            write_en_reg   <= 'h0;
            write_data_reg <= 'h0;
            write_addr_reg <= 'h0;
            end
        else
            begin
            if(|s_apb_pstrb_i & apb_pready_reg & s_apb_psel_i & s_apb_penable_i)
                begin
                write_en_reg   <= 'h1           ;
                write_data_reg <= s_apb_pwdata_i;
                write_addr_reg <= s_apb_paddr_i ;
                end
            else
                begin
                write_en_reg   <= 'h0;
                write_data_reg <= 'h0;
                write_addr_reg <= 'h0;
                end
            end
        end

    assign write_en = write_en_reg;

//------------------------------------------------------------------------------
// Sampling Input data duing idle state
//------------------------------------------------------------------------------

    logic                  read_en  ;
    logic [`APB_AW-1:0]    read_addr;

    assign read_en   = (|s_apb_pstrb_i & s_apb_psel_i & !s_apb_pwrite_i);
    assign read_addr = s_apb_paddr_i;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    // APB Signals
    assign s_apb_pready_o = apb_pready_reg;
    assign s_apb_rdata_o  = read_data_i;

    // Register Interface
    assign read_write_addr_o = write_en ? write_addr_reg :
                               read_en  ? read_addr      : 'h0;
    assign write_en_o        = write_en;
    assign write_data_o      = write_en ? write_data_reg : 'h0;
    assign read_en_o         = read_en;

endmodule
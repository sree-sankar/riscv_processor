//----------------------+-------------------------------------------------------
// Filename             | pher_ctrl.sv
// File created on      | 25.10.2024
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Pheripherals
//------------------------------------------------------------------------------

`include "./apb/apb.vh"

module pher_ctrl(
    // Clock and Reset
    input                       resetn_i       , // Reset Signal
    input                       uart_clk_i     , // UART Clock
    // APB Interface
    input                       s_apb_pclk_i   , // APB Clock
    input                       s_apb_presetn_i, // APB Reset
    input  [    `APB_AW-1:0]    s_apb_paddr_i  , // APB Address
    input                       s_apb_pwrite_i , // APB Write
    input  [`APB_SLAVES-1:0]    s_apb_psel_i   , // APB Select
    input                       s_apb_penable_i, // APB Select
    output                      s_apb_pready_o , // APB Slave Ready
    input  [    `APB_DW-1:0]    s_apb_pwdata_i , // APB Write
    input  [ `APB_STRBW-1:0]    s_apb_pstrb_i  , // APB Strobe
    output [    `APB_DW-1:0]    s_apb_rdata_o  , // APB Read data
    // UART Signals
    input                       uart_rx_i      , // UART RX Signal
    output                      uart_tx_o        // UART TX signal
);

//------------------------------------------------------------------------------
// UART Controller
//------------------------------------------------------------------------------

    uart_ctrl uart_ctrl_inst(
        .clk_i               (uart_clk_i              ),
        .resetn_i            (resetn_i                ),
        .s_apb_pclk_i        (s_apb_pclk_i            ),
        .s_apb_presetn_i     (s_apb_presetn_i         ),
        .s_apb_paddr_i       (s_apb_paddr_i           ),
        .s_apb_pwrite_i      (s_apb_pwrite_i          ),
        .s_apb_psel_i        (s_apb_psel_i[`APB_PSEL0]),
        .s_apb_penable_i     (s_apb_penable_i         ),
        .s_apb_pready_o      (s_apb_pready_o          ),
        .s_apb_pwdata_i      (s_apb_pwdata_i          ),
        .s_apb_pstrb_i       (s_apb_pstrb_i           ),
        .s_apb_rdata_o       (s_apb_rdata_o           ),
        .uart_rx_i           (uart_rx_i               ),
        .uart_tx_o           (uart_tx_o               )
    );

endmodule

//----------------------+-------------------------------------------------------
// Filename             | uart_ctrl.sv
// File created on      | 14/06/2022 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// UART Controller
//------------------------------------------------------------------------------

`include "../apb/apb.vh"

module uart_ctrl(
    // Clock and Reset
    input                      clk_i          , // Clock should be based on required Baud Rate
    input                      resetn_i       , // Reset Signal
    // APB Interface
    input                      s_apb_pclk_i   , // APB Clock
    input                      s_apb_presetn_i, // APB Reset
    input  [   `APB_AW-1:0]    s_apb_paddr_i  , // APB Address
    input                      s_apb_pwrite_i , // APB Write
    input                      s_apb_psel_i   , // APB Select
    input                      s_apb_penable_i, // APB Select
    output                     s_apb_pready_o , // APB Slave Ready
    input  [   `APB_DW-1:0]    s_apb_pwdata_i , // APB Write
    input  [`APB_STRBW-1:0]    s_apb_pstrb_i  , // APB Strobe
    output [   `APB_DW-1:0]    s_apb_rdata_o  , // APB Read data
    // UART Signals
    input                      uart_rx_i      , // UART RX Signal
    output                     uart_tx_o        // UART TX signal
);

//------------------------------------------------------------------------------
// Register interface
//------------------------------------------------------------------------------

    logic [`APB_AW-1:0]    read_write_addr; // Write Address
    logic                  write_en       ; // Write Enable
    logic [`APB_DW-1:0]    write_data     ; // Write Data
    logic                  read_en        ; // Read Enable
    logic [`APB_DW-1:0]    read_data      ; // Read Data

    s_apb s_apb_inst(
        .s_apb_pclk_i         (s_apb_pclk_i   ),
        .s_apb_presetn_i      (s_apb_presetn_i),
        .s_apb_paddr_i        (s_apb_paddr_i  ),
        .s_apb_pwrite_i       (s_apb_pwrite_i ),
        .s_apb_psel_i         (s_apb_psel_i   ),
        .s_apb_penable_i      (s_apb_penable_i),
        .s_apb_pready_o       (s_apb_pready_o ),
        .s_apb_pwdata_i       (s_apb_pwdata_i ),
        .s_apb_pstrb_i        (s_apb_pstrb_i  ),
        .s_apb_rdata_o        (s_apb_rdata_o  ),
        .read_write_addr_o    (read_write_addr),
        .write_en_o           (write_en       ),
        .write_data_o         (write_data     ),
        .read_en_o            (read_en        ),
        .read_data_i          (read_data      )
    );

//------------------------------------------------------------------------------
// Register interface
//------------------------------------------------------------------------------

    logic          tx_enable       ;
    logic [7:0]    tx_data         ;
    logic          tx_data_write_en;
    logic          tx_busy         ;
    logic          tx_done         ;

    uart_regs uart_regs_inst(
        .clk_i                 (clk_i           ),
        .resetn_i              (resetn_i        ),
        .s_apb_pclk_i          (s_apb_pclk_i    ),
        .s_apb_presetn_i       (s_apb_presetn_i ),
        .read_write_addr_i     (read_write_addr ),
        .write_en_i            (write_en        ),
        .write_data_i          (write_data      ),
        .read_en_i             (read_en         ),
        .read_data_o           (read_data       ),
        .tx_enable_o           (tx_enable       ),
        .tx_data_o             (tx_data         ),
        .tx_data_write_en_o    (tx_data_write_en),
        .tx_busy_i             (tx_busy         )
    );

//------------------------------------------------------------------------------
// UART TX FIFO
//------------------------------------------------------------------------------

    logic          tx_fifo_write_en  ;
    logic [7:0]    tx_fifo_write_data;
    logic          tx_fifo_read_en   ;
    logic [7:0]    tx_fifo_read_data ;
    logic          tx_fifo_empty     ;
    logic          tx_fifo_full      ;

    uart_tx_fifo uart_tx_fifo_inst(
        .wr_clk     (s_apb_pclk_i      ),
        .wr_en      (tx_fifo_write_en  ),
        .din        (tx_fifo_write_data),
        .rd_clk     (clk_i             ),
        .rd_en      (tx_fifo_read_en   ),
        .dout       (tx_fifo_read_data ),
        .full       (tx_fifo_full      ),
        .empty      (tx_fifo_empty     )
    );

    assign tx_fifo_read_en    = tx_done & !tx_fifo_empty;
    assign tx_fifo_write_en   = tx_data_write_en & !tx_fifo_full;
    assign tx_fifo_write_data = tx_data;

//------------------------------------------------------------------------------
// UART TX
//------------------------------------------------------------------------------

    logic    tx_trigger;

    uart_tx uart_tx_inst(
        .clk_i           (clk_i             ),
        .resetn_i        (resetn_i          ),
        .tx_trigger_i    (tx_trigger        ),
        .tx_data_i       (tx_fifo_read_data ),
        .tx_busy_o       (tx_busy           ),
        .tx_done_o       (tx_done           ),
        .uart_tx_o       (uart_tx_o         )
    );

    assign tx_trigger = tx_enable & !tx_fifo_empty;

//------------------------------------------------------------------------------
// UART RX
// TBD
//------------------------------------------------------------------------------


endmodule

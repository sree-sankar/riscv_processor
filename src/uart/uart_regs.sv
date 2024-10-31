//----------------------+-------------------------------------------------------
// Filename             | uart_ctrl.sv
// File created on      | 27/10/2024
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// UART Register
//------------------------------------------------------------------------------

`include "uart_ctrl.vh"
`include "../apb/apb.vh"

module uart_regs#(
    parameter APB_DW    = 32
)(
    // Clock and Reset
    input                   clk_i             ,
    input                   resetn_i          ,
    input                   s_apb_pclk_i      ,
    input                   s_apb_presetn_i   ,
    // Address
    input  [`APB_AW-1:0]    read_write_addr_i , // Write Address
    // Write Interface
    input                   write_en_i        , // Write Enable
    input  [`APB_DW-1:0]    write_data_i      , // Write Data
    // Read Interface
    input                   read_en_i         , // Read Enable
    output [`APB_DW-1:0]    read_data_o       , // Read Data
    // UART control and status register
    output                  tx_enable_o       ,
    output [        7:0]    tx_data_o         ,
    output                  tx_data_write_en_o,
    input                   tx_busy_i
);

//------------------------------------------------------------------------------
// Registers
//------------------------------------------------------------------------------

    logic [`APB_DW-1:0]    ctrl_reg   ;
    logic [`APB_DW-1:0]    status_reg ;
    logic [`APB_DW-1:0]    tx_data_reg;
    logic [`APB_DW-1:0]    rx_data_reg;

    // CDC Registers
    logic [`APB_DW-1:0]    cdc_ctrl_reg    [0:1];
    logic [`APB_DW-1:0]    cdc_status_reg  [0:1];
    logic [`APB_DW-1:0]    cdc_rx_data_reg [0:1];

//------------------------------------------------------------------------------
// Register Read in APB Clock Domain
//------------------------------------------------------------------------------

    logic [`APB_DW-1:0]    read_data_reg;

    always_ff @(posedge s_apb_pclk_i)
        begin
        if(!s_apb_presetn_i)
            begin
            read_data_reg <= 'h0;
            end
        else
            begin
            if(read_en_i)
                begin
                case(read_write_addr_i)
                    `CTRL_REG_ADDR    : read_data_reg <= ctrl_reg   ;
                    `STATUS_REG_ADDR  : read_data_reg <= status_reg ;
                    `TX_DATA_REG_ADDR : read_data_reg <= tx_data_reg;
                    `RX_DATA_REG_ADDR : read_data_reg <= rx_data_reg;
                    default           : read_data_reg <= 'h0;
                endcase
                end
            end
        end

    assign read_data_o = read_data_reg;

//------------------------------------------------------------------------------
// Register Write APB Clock Domain
//------------------------------------------------------------------------------

    logic    tx_data_write_en_reg;

    always_ff @(posedge s_apb_pclk_i)
        begin
        if(!s_apb_presetn_i)
            begin
            ctrl_reg             <= 'h0;
            tx_data_reg          <= 'h0;
            rx_data_reg          <= 'h0;
            tx_data_write_en_reg <= 'h0;
            end
        else
            begin
            if(write_en_i)
                begin
                case(read_write_addr_i)
                    `CTRL_REG_ADDR    :
                        begin
                        ctrl_reg             <= write_data_i;
                        tx_data_write_en_reg <= 'h0;
                        end
                    `TX_DATA_REG_ADDR :
                        begin
                        tx_data_reg          <= write_data_i;
                        tx_data_write_en_reg <= 'h1;
                        end
                    `RX_DATA_REG_ADDR :
                        begin
                        rx_data_reg          <= write_data_i;
                        tx_data_write_en_reg <= 'h0;
                        end
                    default :
                        begin
                        rx_data_reg          <= 'h0;
                        tx_data_write_en_reg <= 'h0;
                        end
                endcase
                end
            else
                begin
                tx_data_write_en_reg <= 'h0;
                end
            end
        end

//------------------------------------------------------------------------------
// CDC APB to UART Clock Domain usign double flopping
//------------------------------------------------------------------------------

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            cdc_ctrl_reg[0]    <= 'h0;
            cdc_ctrl_reg[1]    <= 'h0;
            cdc_rx_data_reg[0] <= 'h0;
            cdc_rx_data_reg[1] <= 'h0;
            end
        else
            begin
            cdc_ctrl_reg[0]    <= ctrl_reg          ;
            cdc_ctrl_reg[1]    <= cdc_ctrl_reg[0]   ;
            cdc_rx_data_reg[0] <= rx_data_reg       ;
            cdc_rx_data_reg[1] <= cdc_rx_data_reg[0];
            end
        end

//------------------------------------------------------------------------------
// CDC UART to APB Clock Domain using double flopping
//------------------------------------------------------------------------------

    always_ff @(posedge s_apb_pclk_i)
        begin
        if(!s_apb_presetn_i)
            begin
            cdc_status_reg[0] <= 'h0;
            cdc_status_reg[1] <= 'h0;
            status_reg        <= 'h0;
            end
        else
            begin
            cdc_status_reg[0] <= {{(`APB_DW-1){1'b0}},tx_busy_i};
            cdc_status_reg[1] <= cdc_status_reg[0];
            status_reg        <= cdc_status_reg[1];
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign tx_enable_o        = cdc_ctrl_reg[1][0]  ;
    assign tx_data_o          = tx_data_reg         ;
    assign tx_data_write_en_o = tx_data_write_en_reg;

endmodule

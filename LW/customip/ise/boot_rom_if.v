`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:02:19 06/25/2022
// Design Name:
// Module Name:    boot_rom_if
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
module boot_rom_if(
    input                   clk        , // System Clock
    input                   rst_n      , // Synchronous Reset (Asserted Low)

    // Read Signals
    input  [`XLEN-1:0]      read_addr  , // Read Address
    output [`XLEN-1:0]      read_data  , // Read Data
    input                   read_en    , // Read Enable

    // Read Signals
    input  [`XLEN-1:0]      write_addr , // Read Address
    input  [`XLEN-1:0]      write_data , // Read Data
    input                   write_en   , // Read Enable

    // SPI Signals
    output                  sclk       ,
    output                  sdout      ,
    input                   sdin       ,
    output                  cs_n

);

    wire [24:0]     spi_rd_addr;

    assign spi_rd_addr = 24'h800001;//read_addr[23:0];
    assign cs_n = ~rst_n;

    reg [7:0]       cnt           ;
    reg             tx_dv         ;
    reg  [7:0]      spi_data_out  ;
    wire            tx_ready      ;
    wire [7:0]      spi_data_in   ;
    wire            rx_data_valid ;


    wire [1:0] spi_id;
    reg [1:0]  spi_id_reg;

    spi_if #(
        .SPI_MODE           (0),
        .CLKS_PER_HALF_BIT  (2)
        )
    spi_inst(
        .i_Rst_L     (rst_n              ), // FPGA Reset
        .i_Clk       (clk                ), // FPGA Clock

        // TX (MOSI) Signals
        .i_TX_Byte   (spi_data_out      ), // Byte to transmit on MOSI
        .i_TX_DV     (tx_dv             ), // Data Valid Pulse with i_TX_Byte
        .o_TX_Ready  (tx_ready          ), // Transmit Ready for next byte

        // RX (MISO) Signals
        .o_RX_DV     (rx_data_valid     ), // Data Valid pulse (1 clock cycle)
        .o_RX_Byte   (spi_data_in       ), // Byte received on MISO

        // SPI Interface
        .o_SPI_Clk   (sclk              ),
        .i_SPI_MISO  (sdin              ),
        .o_SPI_MOSI  (sdout             )
  );

    parameter [7:0] SPI_READ_CMD = 8'h03, // Read at normal speed
                    SPI_READ_FST = 8'h0B; // Read at fast speed

    // State Machine to control READ
    localparam [4:0] IDLE      = 4'b0000,
                     READ_CMD  = 4'b0001,
                     SRC_ADDR  = 4'b0010,
                     READ_DATA = 4'b0100;

    reg [4:0] spi_state       ;
    reg [3:0] spi_addr_tx_cnt ;
    reg tx_cnt                ;
    reg tx_ready_d            ;
    wire tx_ready_posedge     ;

    assign tx_ready_posedge = tx_ready & ~tx_ready_d;

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            tx_cnt           <= 1'b0;
            spi_addr_tx_cnt  <= 4'b0;
            tx_ready_d       <= 1'b0;
            end
        else
            begin
            tx_ready_d <= tx_ready;
            if(spi_state== READ_CMD & tx_ready_posedge == 1'b1)
                tx_cnt <= tx_cnt + 1;
            else
                tx_cnt <= 1'b0;
            if(spi_state== SRC_ADDR & spi_addr_tx_cnt <4'h3 & tx_ready_posedge == 1'b1)
                begin
                spi_addr_tx_cnt <= spi_addr_tx_cnt + 1'b1;
                end
            end
        end

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            spi_state     <= IDLE;
            spi_data_out  <=  8'h00;
            tx_dv         <= 1'b0;
            end
        else
            begin
            case(spi_state)

                IDLE :
                    begin
                    spi_data_out  <=  8'h0;
                    tx_dv         <= 1'b0;
                    if(tx_ready)
                        begin
                        spi_state  <= READ_CMD;
                        end
                    end

                READ_CMD :
                    begin
                    spi_data_out  <=  SPI_READ_CMD;
                    tx_dv         <= tx_ready;
                    if(tx_ready && tx_cnt == 1'b1)
                        begin
                        spi_state  <= SRC_ADDR;
                        end
                    end

                SRC_ADDR :
                    begin
                     tx_dv      <= tx_ready;
                     if(spi_addr_tx_cnt == 4'h0)
                        spi_data_out  <= spi_rd_addr[23:16];
                     else if(spi_addr_tx_cnt == 4'h1)
                        spi_data_out  <= spi_rd_addr[15:8];
                     else if(spi_addr_tx_cnt == 4'h2)
                        spi_data_out  <= spi_rd_addr[7:0];
                     else if(tx_ready)
                            spi_state  <= READ_DATA;
                    end

                READ_DATA :
                    begin
                    tx_dv         <= 1'b0;
                    spi_data_out  <=  8'h00;
                    end

                default :
                    begin
                    spi_state     <= IDLE;
                    spi_data_out  <=  8'h00;
                    tx_dv         <= 1'b0;
                    end
            endcase
            end
        end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          :    11:31:04 08/28/2022
// Design Name          :
// Module Name          :    spi_master
// Project Name         :
// Target Devices       :
// Tool versions        :
// Description          :
//
// Dependencies         :
//
// Revision             :
// Revision             :
// Additional Comments  :
//
//////////////////////////////////////////////////////////////////////////////////
module spi_master(
    input           clk      ,
    input           clk_180p ,
    input           rst_n    ,
    input           spi_en   ,
    // TX data signals
    input  [7:0]    tx_data  ,
    // RX data signals
    output [7:0]    rx_data  ,

    // SPI signals
    input           sdin     ,
    output          sdout    ,
    output          sclk     ,
    output          cs_n
    );

    parameter [1:0] SPI_IDLE    = 2'b00,
                    SPI_RUNNING = 2'b01;

    reg [1:0]   spi_state   ;
    reg         cs_n_reg    ;
    reg         spi_clk_en  ;
    reg         clk_d       ;
    reg         spi_clk     ;
    wire        spi_running ;

    assign sclk = (spi_clk_en) ? clk : 1'b0;
    assign cs_n = cs_n_reg;


    always @(posedge clk)
        begin
        if(~rst_n | spi_clk_en)
            spi_clk <= 1'b0;
        else
            spi_clk <= clk;
        end

    // State Machine
    always @(posedge clk)
        begin
        if(~rst_n)
            begin
            spi_state  <= SPI_IDLE;
            cs_n_reg      <= 1'b1;
            spi_clk_en <= 1'b0;
            end
        else
            begin
            case(spi_state)
            SPI_IDLE :
                begin
                cs_n_reg    <= 1'b1;
                spi_clk_en  <= 1'b0;
                if(spi_en)
                    begin
                    spi_state <= SPI_RUNNING;
                    cs_n_reg <= 1'b0;
                    spi_clk_en  <= 1'b1;
                    end
                end

            SPI_RUNNING :
                begin
                if(~spi_en)
                    spi_state <= SPI_IDLE;
                end
            endcase
            end
        end

    assign spi_running = (spi_state == SPI_RUNNING) ? 1'b1 : 1'b0;

    //TX data
    reg [2:0]    tx_data_cnt;
    reg          tx_data_reg;
    reg          tx_done;

    assign sdout = tx_data_reg;
    always @(posedge clk_180p)
        begin
        if(~rst_n | ~spi_running)
            begin
            tx_data_cnt <= 3'b111;
            tx_data_reg <= 1'b0;
            tx_done     <= 1'b0;
            end
        else
            begin
            if(~tx_done)
                begin
                tx_data_reg <= tx_data[tx_data_cnt];
                tx_data_cnt <= tx_data_cnt - 1'b1;
                end
            else
                begin
                tx_data_reg <= 1'b0;
                tx_data_cnt <= tx_data_cnt;
                end
            if(tx_data_cnt == 3'b000)
                begin
                tx_done <= 1'b1;
                end
            end
        end

    // RX data
    reg [2:0] rx_data_cnt;
    reg [7:0] rx_data_reg;
    reg       rx_done;
    reg       tx_done_d;

    always @(posedge clk_180p)
        begin
        if(~rst_n)
            begin
            rx_data_reg <= 8'h00;
            rx_data_cnt <= 3'b111;
            rx_done     <= 1'b0;
            end
        else
            begin
            tx_done_d <= tx_done;
            if(tx_done_d)
                begin
                rx_done                  <= 1'b0;
                rx_data_reg[rx_data_cnt] <= sdin;
                rx_data_cnt              <= rx_data_cnt - 1'b1;
                if(rx_data_cnt == 3'b000)
                    begin
                    rx_data_cnt <= 3'b111;
                    rx_done     <= 1'b1;
                    end
                end
            end
        end

    reg [7:0] rx_data_s;
    always @(posedge clk)
        begin
        if(~rst_n)
            begin
            rx_data_s <= 8'h00;
            end
        else
            begin
            if(rx_done)
                rx_data_s <= rx_data_reg;
            end
        end

    assign rx_data = rx_data_s;

endmodule

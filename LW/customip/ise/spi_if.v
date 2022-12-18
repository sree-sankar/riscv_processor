`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          :    19:27:11 08/20/2022
// Design Name          :
// Module Name          :    spi_if
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
module spi_if_n(
    input           clk      ,    // Input clock
    input           rst_n    ,
    input [7:0]     tx_data  ,
    input           spi_din  ,
    output          spi_clk  ,
    output          spi_dout ,
    output          spi_cs
    );

    reg [2:0]       rx_cnt;
    reg [2:0]       tx_cnt;

    assign spi_clk = clk;
    assign spi_cs   = ~rst_n;

    // Serial Data Out
    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            tx_cnt      <= 3'b111;
            spi_out_reg <= 1'b0;
            end
        else
            begin
            if(tx_en)
                begin
                spi_out_reg <= tx_data[tx_cnt];
                if(tx_cnt==3'b000)
                    begin
                    tx_cnt <= 3'b111;
                    end
                end
            end
        end

    // Serial Data In
    always @(negedge clk)
        begin
        if(!rst_n)
            begin

            end
        else
            begin

            end
        end

endmodule

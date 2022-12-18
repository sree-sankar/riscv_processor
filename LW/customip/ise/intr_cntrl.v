`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          : 05.12.2021 12:48:12
// Design Name          :
// Module Name          : csr_regs
// Project Name         :
// Target Devices       :
// Tool Versions        :
// Description          :
//
// Dependencies         :
//
// Revision             : 1.0
// Additional Comments  :
//
//////////////////////////////////////////////////////////////////////////////////

module intr_cntrl(
    input               clk   , // System Clock
    input               rst_n , // System Reset
    //output o_mintr_en,
    //output o_mtimer_intr,
    //output o_mextern_intr,
    //output o_msoftware_intr,
    //output[`XLEN-1:0] o_mcause
    output              intr_en     //

);

    reg intr_en_reg;

    assign intr_en = intr_en_reg;

    // Interrupt Generator
    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            intr_en_reg         <= 1'b0;
            end
        else
            begin
            intr_en_reg         <= 1'b0;
            end
        end

endmodule
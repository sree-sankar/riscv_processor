//----------------------+-------------------------------------------------------
// Filename             | clk_gen.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Clock Generator
//------------------------------------------------------------------------------

module clk_divider#(
    parameter REF_CLK_FREQ = 1,
    parameter REQ_CLK_FREQ = 1
)(
    input     clk_i   , // Reference Frequency
    input     resetn_i, // Reset Signal
    output    clk_o
);

    localparam TICK_LIMIT = REF_CLK_FREQ/(2*REQ_CLK_FREQ); // For 50% duty ratio

//------------------------------------------------------------------------------
// Clock Generator
//------------------------------------------------------------------------------

    logic                             clk_reg   ;
    logic [$clog2(TICK_LIMIT)-1:0]    tick_count;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            clk_reg    <= 'h1;
            tick_count <= 'h0;
            end
        else
            begin
            if(tick_count >= (TICK_LIMIT-1))
                begin
                tick_count <= 'h0;
                clk_reg <= ~clk_reg;
                end
            else
                begin
                tick_count <= tick_count + 'h1;
                end
            end
        end

    assign clk_o = clk_reg;

endmodule
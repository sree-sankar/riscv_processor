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

module clk_generator(
    input     clk_i       , // Reference Frequency
    input     resetn_i    , // Reset Signal
    output    core_clk_o  , // Core Clock
    output    apb_pclk_o  , // APB Clock
    output    uart_clk_o  , // UART Clock
    output    sys_resetn_o  // System Reset
);

//------------------------------------------------------------------------------
// Clock Generator
//------------------------------------------------------------------------------

    logic   clk_11_5M;

    clk_gen clk_gen_inst(
        .clk_in1     (clk_i       ),
        .resetn      (resetn_i    ),
        .clk_out1    (core_clk_o  ),
        .clk_out2    (apb_pclk_o  ),
        .clk_out3    (clk_11_5M   ),
        .locked      (sys_resetn_o)
    );

//------------------------------------------------------------------------------
// Clock Division
//------------------------------------------------------------------------------

    // 1.15MHz clock for UART
    clk_divider #(
        .REF_CLK_FREQ    (11520000    ),
        .REQ_CLK_FREQ    (115200      )
    ) clk_divider_inst(
        .clk_i           (clk_11_5M   ),
        .resetn_i        (sys_resetn_o),
        .clk_o           (uart_clk_o  )
    );

endmodule
//----------------------+-------------------------------------------------------
// Filename             | reg_write.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Register Write Back
//------------------------------------------------------------------------------

module reg_write(
    // Input
    input                           clk_i        , // System Clock
    input                           resetn_i     , // System Reset
    input                           halt_i       , // Halt Control Signal
    input  [`SYS_REGS_WIDTH-1:0]    rd_addr_i    , // rd register address
    input                           rd_write_en_i, // rd write enable
    input  [          `XLEN-1:0]    rd_data_i    , // rd Data In
    // Output
    output [`SYS_REGS_WIDTH-1:0]    rd_addr_o    , // rd register address
    output                          rd_write_en_o, // rd write enable
    output [          `XLEN-1:0]    rd_data_o      // Register Data Out
);

//------------------------------------------------------------------------------
// Register Enable
//------------------------------------------------------------------------------

    logic          reg_enable ;
    logic [2:0]    resetn_pipe;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            resetn_pipe <= 'h0;
            end
        else
            begin
            resetn_pipe <= {resetn_pipe[1:0],resetn_i};
            end
        end

    assign reg_enable = resetn_pipe[2];

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign rd_addr_o     = rd_addr_i;
    assign rd_write_en_o = reg_enable & rd_write_en_i & !halt_i;
    assign rd_data_o     = rd_data_i;

endmodule
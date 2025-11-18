//----------------------+-------------------------------------------------------
// Filename             | branch_predictor.sv
// File created on      | 15.11.2025
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Branch Predictor
//------------------------------------------------------------------------------

module branch_predictor(
    input              clk_i         , // Reference Frequency
    input              resetn_i      , // Reset Signal
    input  [`XLEN-1:0] pc_i          , // PC
    input  [`XLEN-1:0] branch_pc_i   , // PC
    input  [`XLEN-1:0] branch_addr_i , // Branch Address
    input              branch_valid_i, // Branch Valid
    input              branch_taken_i, // Branch Taken
    // Output
    output [`XLEN-1:0] target_addr_o , // Target Address
    output             target_valid_o  // Target Address is valid
);

//------------------------------------------------------------------------------
// Branch Predictor
//------------------------------------------------------------------------------

    btb #(
        .AW             (`XLEN         ),
        .ENTRIES        (1024          )
    ) btb_inst(
        .clk_i          (clk_i         ),
        .resetn_i       (resetn_i      ),
        .pc_i           (pc_i          ),
        .branch_pc_i    (branch_pc_i   ),
        .branch_addr_i  (branch_addr_i ),
        .branch_valid_i (branch_valid_i),
        .branch_taken_i (branch_taken_i),
        .target_addr_o  (target_addr_o ),
        .target_valid_o (target_valid_o)
    );

endmodule
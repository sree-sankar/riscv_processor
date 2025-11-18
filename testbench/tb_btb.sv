//----------------------+-------------------------------------------------------
// Filename             | tb_btb.sv
// File created on      | 13.11.2025
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Branch Target Buffer Testbench
//------------------------------------------------------------------------------

module tb_btb();


    localparam DEPTH = 8;
    localparam AW    = 8;


    logic          clk_i         ; // Reference Frequency
    logic          resetn_i      ; // Reset Signal
    logic [AW-1:0] pc_i          ; // PC
    logic [AW-1:0] branch_pc_i   ; // PC
    logic [AW-1:0] branch_addr_i ; // Branch Address
    logic          branch_taken_i; // Branch Taken
    logic [AW-1:0] target_addr_o ; // Target Address
    logic          target_valid_o; // Target Address is valid

//------------------------------------------------------------------------------
// DUT
//------------------------------------------------------------------------------

    btb dut(.*);

//------------------------------------------------------------------------------
// Stimuli
//------------------------------------------------------------------------------

    // Clock
    always #5 clk_i = ~clk_i;

    initial
        begin
        clk_i          <= 'h0;
        resetn_i       <= 'h0;
        pc_i           <= 'h0;
        branch_addr_i  <= 'h0;
        branch_taken_i <= 'h0;
        #10
        resetn_i       <= 'h1;
        #10
        pc_i           <= 'h5C;
        branch_pc_i    <= 'h5C;
        branch_addr_i  <= 'hD4;
        branch_taken_i <= 'h01;
        end

endmodule
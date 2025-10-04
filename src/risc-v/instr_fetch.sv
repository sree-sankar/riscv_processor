//----------------------+-------------------------------------------------------
// Filename             | risc_v.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Instruction Fetch
//------------------------------------------------------------------------------

module instr_fetch(
    // Input
    input                 clk_i         , // System Clock
    input                 clk_2x_i      , // 2x System Clock
    input                 resetn_i      , // Synchronous Active Low System Reset
    input  [`XLEN-1:0]    instr_i       , // Fetched Instruction
    input  [`XLEN-1:0]    branch_addr_i , // Branch address
    input                 branch_valid_i, // Branch address valid
    input                 branch_taken_i, // Branch enable
    // Output
    output [`XLEN-1:0]    pc_o          , // Program Counter
    output [`XLEN-1:0]    instr_o         // Intstruction to decode stage
);

    logic branch_valid_d;

//------------------------------------------------------------------------------
// Program Counter0
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    pc_reg[0:1];

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            pc_reg[0] <= `XLEN'h0;
            end
        else
            begin
            if(branch_valid_d & !branch_taken_i)
                begin
                pc_reg[0] <= pc_reg[1] + `PC_INC;
                end
            else if(branch_valid_i)
                begin
                pc_reg[0] <= branch_addr_i;
                end
            else
                begin
                pc_reg[0] <= pc_reg[0] + `PC_INC;
                end
            end
        end

//------------------------------------------------------------------------------
// Program Counter1
//------------------------------------------------------------------------------

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            pc_reg[1] <= `XLEN'h0;
            end
        else
            begin
            if(branch_valid_i)
                begin
                pc_reg[1] <= pc_reg[0] + `PC_INC;
                end
            end
        end

//------------------------------------------------------------------------------
// Control Logic
//------------------------------------------------------------------------------

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            branch_valid_d <= 'h0;
            end
        else
            begin
            branch_valid_d <= branch_valid_i;
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign pc_o    = (branch_valid_d & !branch_taken_i) ? pc_reg[1] : pc_reg[0];
    assign instr_o = instr_i;

endmodule
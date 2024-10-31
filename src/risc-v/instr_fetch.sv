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
    input                 clk_i        , // System Clock
    input                 resetn_i     , // Synchronous Active Low System Reset
    input  [`XLEN-1:0]    instr_i      , // Fetched Instruction
    input                 branch_en_i  , // Branch enable
    input  [`XLEN-1:0]    branch_addr_i, // Branch address
    // Output
    output [`XLEN-1:0]    pc_o         , // Program Counter
    output [`XLEN-1:0]    instr_o        // Intstruction to decode stage
);

//------------------------------------------------------------------------------
// Program Counter
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    pc_reg;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            pc_reg <= `XLEN'h0;
            end
        else
            begin
            if(branch_en_i)
                begin
                pc_reg <= branch_addr_i + `PC_INC;
                end
            else
                begin
                pc_reg <= pc_reg + `PC_INC;
                end
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign pc_o    = branch_en_i ? branch_addr_i : pc_reg;
    assign instr_o = instr_i;

endmodule
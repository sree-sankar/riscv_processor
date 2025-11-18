//----------------------+-------------------------------------------------------
// Filename             | btb.sv
// File created on      | 13.11.2025 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Branch Target Buffer
// > Since address are 4byte aligned the last 2bit can be removed while storing
// > in the BTB
//------------------------------------------------------------------------------

module btb #(
    parameter AW      = 8         , // Address Width
    parameter ENTRIES = 8           // Entries in the BTB
)(
    input           clk_i         , // Reference Frequency
    input           resetn_i      , // Reset Signal
    input  [AW-1:0] pc_i          , // PC
    input  [AW-1:0] branch_pc_i   , // PC
    input  [AW-1:0] branch_addr_i , // Branch Address
    input           branch_valid_i, // Branch Valid
    input           branch_taken_i, // Branch Taken
    // Output
    output [AW-1:0] target_addr_o , // Target Address
    output          target_valid_o  // Target Address is valid
);

    localparam INDEX_WIDTH  = $clog2(ENTRIES)         ;
    localparam TAG_WIDTH    = (AW - INDEX_WIDTH - 2); // last 2 zeros are ignored
    localparam TARGET_WIDTH = (AW - 2)              ; // last 2 zeros are ignored
    localparam DW           = TAG_WIDTH + TARGET_WIDTH + 1; // +1 is Prediction validity bit

    logic [ INDEX_WIDTH-1:0] wr_index ; // Index
    logic [ INDEX_WIDTH-1:0] rd_index ; // Index
    logic [   TAG_WIDTH-1:0] wr_tag   ; // Tags
    logic [   TAG_WIDTH-1:0] rd_tag   ; // Tags
    logic [          AW-3:0] wr_target; // Target Address
    logic [          AW-1:0] rd_target; // Target Address

//------------------------------------------------------------------------------
// Branch Target Buffer
//------------------------------------------------------------------------------

    logic [DW-1:0] btb [0:ENTRIES-1];

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            for(int loc = 0; loc < ENTRIES; loc++)
                begin
                btb[loc] <= 'h0;
                end
            end
        else
            begin
            if(branch_taken_i)
                begin
                btb[wr_index] <= {wr_tag,wr_target,branch_taken_i};
                end
            end
        end

//------------------------------------------------------------------------------
// Registering
//------------------------------------------------------------------------------

    logic [AW-1:0] branch_pc_d  ;
    logic [AW-1:0] branch_addr_d;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            branch_pc_d   <= 'h0;
            branch_addr_d <= 'h0;
            end
        else
            begin
            if(branch_valid_i)
                begin
                branch_pc_d   <= branch_pc_i  ;
                branch_addr_d <= branch_addr_i;
                end
            end
        end

//------------------------------------------------------------------------------
// Write
//------------------------------------------------------------------------------

    assign wr_index  = branch_pc_d[(TAG_WIDTH + 1):2];
    assign wr_target = branch_addr_d[AW-1:2];
    assign wr_tag    = branch_pc_d[AW-1:(TAG_WIDTH + 2)];

//------------------------------------------------------------------------------
// Read
//------------------------------------------------------------------------------

    assign rd_index  = pc_i[(TAG_WIDTH + 1):2];
    assign rd_target = {btb[rd_index][(DW-TAG_WIDTH-1):1],2'b00};
    assign rd_tag    = btb[rd_index][DW-1:DW-TAG_WIDTH];

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign target_addr_o  = rd_target;
    assign target_valid_o = (rd_tag == pc_i[AW-1:(TAG_WIDTH + 2)]) & btb[rd_index][0];

endmodule
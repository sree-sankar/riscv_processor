//----------------------+-------------------------------------------------------
// Filename             | halt_ctrl.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Halt Control
//------------------------------------------------------------------------------

module halt_ctrl(
    // Input
    input     clk_i            ,
    input     resetn_i         ,
    input     branch_en_i      ,
    input     branch_valid_i   ,
    input     bp_target_valid_i,
    // Output
    output    halt_decode_o    ,
    output    halt_exec_o      ,
    output    halt_mem_o       ,
    output    halt_reg_write_o
);

//------------------------------------------------------------------------------
// Halt Control
//------------------------------------------------------------------------------

    logic [3:0] halt_pipe  ;
    logic       branch_en_d;
    logic [1:0] branch_valid_pipe;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            halt_pipe         <= 'h0;
            branch_en_d       <= 'h0;
            branch_valid_pipe <= 'h0;
            end
        else
            begin
            branch_en_d       <= branch_en_i;
            branch_valid_pipe <= {branch_valid_pipe[0],branch_valid_i};
            halt_pipe         <= {halt_pipe[2:0],(branch_en_d & ~(bp_target_valid_i | branch_valid_pipe[1]))};
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign halt_decode_o    = branch_en_d & ~(bp_target_valid_i | branch_valid_pipe[1]);
    assign halt_exec_o      = (branch_en_d & ~(bp_target_valid_i | branch_valid_pipe[1])) | halt_pipe[0];
    assign halt_mem_o       = halt_pipe[0] | halt_pipe[1];
    assign halt_reg_write_o = halt_pipe[1] | halt_pipe[2];

endmodule
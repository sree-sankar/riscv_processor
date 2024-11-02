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
    input     clk_i           ,
    input     resetn_i        ,
    input     branch_en_i     ,
    // Output
    output    halt_decode_o   ,
    output    halt_exec_o     ,
    output    halt_mem_o      ,
    output    halt_reg_write_o
);

//------------------------------------------------------------------------------
// Halt Control
//------------------------------------------------------------------------------

    logic [3:0] halt_pipe;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            halt_pipe <= 'h0;
            end
        else
            begin
            halt_pipe <= {halt_pipe[2:0],branch_en_i};
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign halt_decode_o    = branch_en_i;
    assign halt_exec_o      = branch_en_i  | halt_pipe[0];
    assign halt_mem_o       = halt_pipe[0] | halt_pipe[1];
    assign halt_reg_write_o = halt_pipe[1] | halt_pipe[2];

endmodule
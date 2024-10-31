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

    // enum logic [4:0] {
    //     HALT_IDLE        = 'h0,
    //     HALT_DECODE_EXEC = 'h1,
    //     HALT_EXEC_MEM    = 'h2,
    //     HALT_MEM_REG     = 'h4
    // } halt_state;

    // always_ff @(posedge clk_i)
    //     begin
    //     if(!resetn_i)
    //         begin
    //         halt_state <= HALT_IDLE;
    //         end
    //     else
    //         begin
    //         case(halt_state)
    //             HALT_IDLE :
    //                 begin
    //                 if(branch_en_i)
    //                     begin
    //                     halt_state <= HALT_DECODE_EXEC;
    //                     end
    //                 end
    //             HALT_DECODE_EXEC : halt_state <= HALT_EXEC_MEM;
    //             HALT_EXEC_MEM    : halt_state <= HALT_MEM_REG;
    //             HALT_MEM_REG     : halt_state <= HALT_IDLE;
    //             default          : halt_state <= HALT_IDLE;
    //         endcase
    //         end
    //     end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    // assign halt_decode_o    = (halt_state == HALT_DECODE_EXEC) ? 'h1 : 'h0;
    // assign halt_exec_o      = (halt_state == HALT_DECODE_EXEC ||
    //                            halt_state == HALT_EXEC_MEM   ) ? 'h1 : 'h0;
    // assign halt_mem_o       = (halt_state == HALT_EXEC_MEM ||
    //                            halt_state == HALT_MEM_REG    ) ? 'h1 : 'h0;
    // assign halt_reg_write_o = (halt_state == HALT_MEM_REG    ) ? 'h1 : 'h0;

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

    assign halt_decode_o    = branch_en_i;
    assign halt_exec_o      = branch_en_i  | halt_pipe[0];
    assign halt_mem_o       = halt_pipe[0] | halt_pipe[1];
    assign halt_reg_write_o = halt_pipe[1] | halt_pipe[2];

endmodule
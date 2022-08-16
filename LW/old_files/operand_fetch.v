`include "define.v"


module operand_fetch(input i_clk,
                     input i_halt,
                     input  [`XLEN-1:0] i_pc,
                     input  [`XLEN-1:0] i_instr,
                     output reg [`XLEN-1:0] o_pc,
                     output reg [`XLEN-1:0] o_instr,
                     output reg [`XLEN-1:0] o_imm_i_type,
                     output reg [`XLEN-1:0] o_imm_s_type,
                     output reg [`XLEN-1:0] o_imm_b_type,
                     output reg [`XLEN-1:0] o_imm_u_type,
                     output reg [`XLEN-1:0] o_imm_j_type);                    

      
 always @(posedge i_clk)
    begin
        if(i_halt == 1'b0)begin
            o_pc         <= i_pc;        
            o_instr      <= i_instr;
            o_imm_i_type <= {{21{i_instr[31]}}, i_instr[30:20]};
            o_imm_s_type <= {{21{i_instr[31]}}, i_instr[30:25],i_instr[11:7]};
            o_imm_b_type <= {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8],1'b0};
            o_imm_u_type <= {i_instr[31:12], 12'b0};
            o_imm_j_type <= {{12{i_instr[31]}},i_instr[19:12],i_instr[20],i_instr[30:21],1'b0};
        end
    end
endmodule
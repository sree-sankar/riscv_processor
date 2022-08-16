`timescale 1ns / 1ps
`include "define.v"

module mem_access(input i_clk,
                  input i_halt,
                  input i_taken_branch,
                  input [`XLEN-1:0] i_pc,
                  input [`XLEN-1:0] i_alu,
                  input [`XLEN-1:0] i_rs2,
                  input [`XLEN-1:0] i_instr,
                  input [`XLEN-1:0] i_mem_data,
                  output o_mem_wr_en,
                  output reg [`XLEN-1:0] o_instr,
                  output reg [`XLEN-1:0] o_mem_data,
                  output reg [`XLEN-1:0] o_mem_addr);
    
    reg [`XLEN-1:0] r_mem_data;

   assign o_mem_wr_en = (i_instr[14:12] == `STORE) ? 1 : 0;

    always @(posedge i_clk)
     begin
        if(i_halt == 1'b0 && i_taken_branch == 1'b0)begin
            o_instr <= i_instr;
            o_mem_data      <= r_mem_data;
         end
      end
             
      always @(*)
        begin
          case(i_instr[6:0])
             `OP,`OP_IMM,`LUI,`AUIPC,`SYSTEM : begin r_mem_data   <= i_alu; end                            
             `LOAD      : begin           
                             case(i_instr[14:12])
                               `FN3_LB   : r_mem_data  <= {{24{1'b0}},i_mem_data[7:0]};
                               `FN3_LH   : r_mem_data  <= {{16{1'b0}},i_mem_data[15:0]};
                               `FN3_LW   : r_mem_data  <= i_mem_data;
                               `FN3_LBU  : r_mem_data  <= $unsigned(i_mem_data[7:0]);
                               `FN3_LHU  : r_mem_data  <= $unsigned( {{16{1'b0}},i_mem_data[15:0]} );
                             endcase
                          end
             `JAL,`JALR : begin r_mem_data <= i_alu;end
             default    : begin r_mem_data <= 32'b0;end  
          endcase
        end
endmodule

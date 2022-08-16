`timescale 1ns / 1ps
`include"define.v"


module pc(input i_clk,
          input i_rst,
          input i_halt,
          input i_branch_en,
          input [`XLEN-1:0] i_branch_addr,
          
          output reg o_mem_rd_en,
          output reg o_reg_rd_en,
          output reg o_icache_rd_en,
          output reg o_taken_branch,
          output reg [`XLEN-1:0] o_pc,
          output reg [`XLEN-1:0] o_npc);
                    
   always @(posedge i_clk or negedge i_rst)
    begin
      if(!i_rst) begin
         o_pc            <= 0;
         o_npc           <= 1;
         o_mem_rd_en     <= 1'b1;
         o_reg_rd_en     <= 1'b1;
         o_icache_rd_en  <= 1'b1;
         o_taken_branch  <= 1'b0;     
         end
      else begin
         if(i_halt == 1'b0 && i_branch_en == 1'b1 ) begin
            o_pc           <= i_branch_addr;
            o_npc          <= i_branch_addr + 1;
            o_taken_branch <= 1'b1;
         end 
         else if(i_halt == 1'b0 && i_branch_en == 1'b0 )begin
               o_pc           <= o_npc;
               o_npc          <= o_npc + 1;
               o_taken_branch <= 1'b0; 
         end  
      end     
    end      
endmodule
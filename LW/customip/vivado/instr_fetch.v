`timescale 1ns / 1ps


module instr_fetch(
      input                clk,           // System Clock 
      input                rst_n,         // Synchronized Negative Reset
      
      input                halt,          // Halt enable signal
      input                branch_en,     // Branch enable
      input [`XLEN-1:0]    branch_addr,   // pc_reg addr when branch occurs
          
      output               instr_fetch_rd_en,
      output               taken_branch,
      output [`XLEN-1:0]   pc,
      output [`XLEN-1:0]   npc
);

   reg [`XLEN-1:0] pc_reg;
   reg [`XLEN-1:0] npc_reg;
   
   reg taken_branch_reg,
   reg instr_fetch_rd_en_reg;

   assign pc            = pc_reg;
   assign npc           = np_reg
   assign taken_branch  = taken_branch_reg;

   // pc_reg Increment
   always @(posedge clk)
      begin
      if(!rst_n) 
         begin
         pc_reg            <= 0;
         npc_reg           <= 1;
         taken_branch_reg  <= 1'b0;     
         end
      else 
         begin
         if(!halt)
            begin
            if(branch_en == 1'b1)
               begin
               pc_reg           <= branch_addr;
               npc_reg          <= branch_addr + 1;
               taken_branch_reg <= 1'b1;
            end 
            else
               begin
               pc_reg           <= npc_reg;
               npc_reg          <= npc_reg + 1;
               taken_branch_reg <= 1'b0; 
               end  
         end
         else 
            begin
               pc_reg           <= pc_reg;
               npc_reg          <= npc_reg;
               taken_branch_reg <= taken_branch_reg;  
            end     
      end 

   // Control Unit
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         instr_fetch_rd_en <= 1'b0;
         end
      else 
         begin
         if(!halt)
            begin
            instr_fetch_rd_en <= 1'b1;
            end
         else 
            begin
            instr_fetch_rd_en <= 1'b0;
            end
         end
      end     
endmodule
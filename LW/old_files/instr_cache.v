//1MB Cache 
module instr_cache (input i_clk,
                    input i_r_en,
                    input i_w_en,
                    input [`XLEN-1:0] i_pc,
                    input [`XLEN-1:0] i_addr,
                    input [`XLEN-1:0] i_instr,
                    output reg [`XLEN-1:0] o_instruction);
            
                    reg [`XLEN-1:0] instr_cache [0:`CACHE_DEPTH-1];

            always @(*)begin
              if(i_r_en)begin 
                  instruction_out <= instr_mem_reg[i_pc];
            end

            always @(posedge i_clk)
            begin
                if(i_w_en)begin 
                    instr_mem_reg[i_addr]     <= i_instr;
                end
            end
            
    
endmodule
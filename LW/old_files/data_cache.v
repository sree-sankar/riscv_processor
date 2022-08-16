module data_cache (input i_clk,
                    input i_r_en,i_w_en,
                    input [`XLEN-1:0] i_pc,
                    input [`XLEN-1:0] i_data,
                    input [`XLEN-1:0] i_addr,
                    output reg [`XLEN-1:0] o_data);
            
                    reg [`XLEN-1:0]data_cache[0:`CACHE_DEPTH-1];

            always @(*)begin
              if(i_r_en)begin 
                  o_data        <= data_cache[i_addr];end
            end

            always @(posedge i_clk)
            begin
                if(i_w_en)begin 
                    data_cache[i_addr]     <= i_data;
                end
            end
            
endmodule
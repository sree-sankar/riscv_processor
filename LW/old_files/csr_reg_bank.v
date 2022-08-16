`include "define.v"

module csr_reg_bank(input i_clk,
               input i_rst,
               input i_rd_en,
               input i_wr_en,
               input i_or,
               input i_and,
               input i_m_interrupt,
               input [11:0] i_rd_addr,
               input [11:0] i_wr_addr,
               input [`XLEN-1:0] i_data,
               output[`XLEN-1:0] o_csr);
               
            reg[`XLEN-1:0] csr_bank[0:`CSR_ADDR_DEPTH-1];
            wire [`XLEN-1:0] w_mstatus;


integer r_addr_cnt;
reg[`XLEN-1:0] r_csr;

  assign o_csr  = r_csr;
  //Write 
    always @(posedge i_clk or negedge i_rst)
     begin
        if(~i_rst) begin
            csr_bank[12'hF11] <= 32'h0000_0000;
            csr_bank[12'hF12] <= 32'h0000_0000;
            csr_bank[12'hF13] <= 32'h0000_0000;
            csr_bank[12'hF14] <= 32'h0000_0000;
            for(r_addr_cnt = 12'h3A0; r_addr_cnt <= 12'h3BF;r_addr_cnt = r_addr_cnt + 1) begin
                  csr_bank[r_addr_cnt] <= 32'b0; 
            end
            //mhpmcounter3 - 31 = 0
            for(r_addr_cnt = 12'hB02; r_addr_cnt <= 12'hB1F;r_addr_cnt = r_addr_cnt + 1) begin
                  csr_bank[r_addr_cnt] <= 32'b0; 
            end
            //mhpmcounter3h - 31 = 0
            for(r_addr_cnt = 12'hB83; r_addr_cnt <= 12'hB9F;r_addr_cnt = r_addr_cnt + 1) begin
                  csr_bank[r_addr_cnt] <= 32'b0; 
            end
        end else begin 
         csr_bank[12'hF300] = {19'b0,2'b11,7'b0,i_m_interrupt,3'b0};

         if(i_wr_en == 1'b1 && i_wr_addr != 12'hF11 && i_wr_addr != 12'hF12 && i_wr_addr != 12'hF13 && i_wr_addr != 12'hF14 && i_or == 1'b1) begin
           csr_bank[i_wr_addr] <= i_data | csr_bank[i_wr_addr];
         end else if(i_wr_en == 1'b1 && i_wr_addr != 12'hF11 && i_wr_addr != 12'hF12 && i_wr_addr != 12'hF13 && i_wr_addr != 12'hF14 && i_and == 1'b1) begin
           csr_bank[i_wr_addr] <= i_data & csr_bank[i_wr_addr];
         end
         else if(i_wr_en == 1'b1 && i_wr_addr != 12'hF11 && i_wr_addr != 12'hF12 && i_wr_addr != 12'hF13 && i_wr_addr != 12'hF14)  begin
            csr_bank[i_wr_addr] <= i_data;
         end
      end        
    end      

  //Read      
    always @(*) begin
      if(i_rd_en) begin
          r_csr <= csr_bank[i_rd_addr];
      end
     end

endmodule






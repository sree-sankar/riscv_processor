`timescale 1ns / 1ps
`include"define.v"

module reg_write_cntrl(
        input                   clk,
        input                   rst_n,
        input                   halt,
        input                   taken_branch,
        input [`XLEN-1:0]       i_instr,
        input [`XLEN-1:0]       i_alu, 
        output                  o_reg_wr_en
);
                  
        reg r_reg_wr_en;

        assign o_reg_wr_en = r_reg_wr_en;
        
        always @(posedge i_clk or negedge i_rst) begin
                if(!i_rst)begin
                        r_reg_wr_en <= 0;
                end
                else begin
                        if(i_instr[6:0] == `STORE) begin
                                r_reg_wr_en <= 0;
                        end
                        else begin
                                r_reg_wr_en <= 1;
                        end
                end
        end    
                  
endmodule
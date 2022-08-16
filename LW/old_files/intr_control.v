`include "define.v"

module intr_control(input  i_clk,
                    input  i_rst,
                    output o_mintr_en,
                    output o_mtimer_intr,
                    output o_mextern_intr,
                    output o_msoftware_intr,
                    output[`XLEN-1:0] o_mcause);

reg r_mintr_en;
reg r_mtimer_intr;
reg r_mextern_intr;
reg r_msoftware_intr;

reg[`XLEN-1:0] r_mcause;
assign o_mintr_en = r_mintr_en;                    

always @(posedge i_clk or negedge i_rst) begin
    if(~i_rst) begin
        r_mintr_en  <= 1'b0; 
        r_mcause    <= 32'h0000_0000;
    end else begin
        r_mtimer_intr       <= 1'b0;
        r_mextern_intr      <= 1'b0;
        r_msoftware_intr    <= 1'b0;
    end
end
    
endmodule
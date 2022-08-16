`include "define.v"

module csr_reg (
    input i_mintr_en,
    input i_mtimer_intr,
    input i_mextern_intr,
    input i_msoftware_intr,
    input i_mtimer_intr_en,
    input i_mextern_intr_en,
    input i_msoftware_intr_en,
    input i_mpie,
    input [1:0] i_mpp,
    input[`XLEN-1:0] i_mscratch,
    input[`XLEN-1:0] i_mepc,
    input[`XLEN-1:0] i_mcause,
    
    output[`XLEN-1:0] o_misa,
    output[`XLEN-1:0] o_mimpid,
    output[`XLEN-1:0] o_mhartid,
    output[`XLEN-1:0] o_mstatus,
    output[`XLEN-1:0] o_mtvec,
    output[`XLEN-1:0] o_medeleg,
    output[`XLEN-1:0] o_mideleg,
    output[`XLEN-1:0] o_mip,
    output[`XLEN-1:0] o_mie,
    output[`XLEN-1:0] o_mtime_msb,o_mtime_lsb,
    output[`XLEN-1:0] o_mtimecmp_msb,o_mtimecmp_lsb,
    output[`XLEN-1:0] o_mcycle,
    output[`XLEN-1:0] o_minstret,
    output[`XLEN-1:0] o_mhpmcounter,
    output[`XLEN-1:0] o_mhpmevent,
    output[`XLEN-1:0] o_mcounteren,
    output[`XLEN-1:0] o_mcountinhibit,
    output[`XLEN-1:0] o_mscratch,
    output[`XLEN-1:0] o_mepc

);

assign o_misa    = 32'h4000_0100;   // RV32I
assign o_mimpid  = 32'h0000_0000;   // Not implemented
assign o_mhartid = 32'h0000_0000;   // Not implemented

assign o_mtvec         = {`MVECT_BASE,2'b00};   // 30 bit Address for trap + 2 bit mode
assign o_medeleg       = 32'h0000_0000;   // Not implemented
assign o_mideleg       = 32'h0000_0000;   // Not implemented
assign o_mip           = {24'h000000,6'b000000,i_mextern_intr,3'b000,i_mtimer_intr,3'b000,i_msoftware_intr,3'b000} ; //Pending interrupt 
assign o_mie           = {24'h000000,6'b000000,i_mextern_intr_en,3'b000,i_mtimer_intr_en,3'b000,i_msoftware_intr_en,3'b000} ; //Enable interrupt
assign o_mcycle        = 32'h0000_0000;   // Not implemented
assign o_mhpmcounter   = 32'h0000_0000;   // Not implemented
assign o_mhpmevent     = 32'h0000_0000;   // Not implemented
assign o_mcounteren    = 32'h0000_0000;   // Not implemented
assign o_mcountinhibit = 32'h0000_0000;   // Not implemented
assign o_mscratch      = i_mscratch;
assign o_mepc          = i_mepc;
assign o_mcause        = i_mcause;      
assign o_mtval         = 32'h0000_0000;   // Not implemented

assign o_mstatus = {16'h0000,3'b000,i_mpp,3'b000,i_mpie,3'b000,i_mintr_en,3'b000}; //MPIE & MPP doubt
assign o_mtime_msb       = 32'h0000_0000;
assign o_mtime_lsb       = 32'h0000_0000;
assign o_mtimecmp_msb    = 32'h0000_0000;
assign o_mtimecmp_lsb    = 32'h0000_0000;
assign o_pmpcfg          = 32'h0000_0000;


endmodule




`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          :    21:00:28 08/16/2022
// Design Name          :
// Module Name          :    operand_fetch
// Project Name         :
// Target Devices       :
// Tool versions        :
// Description          :
//
// Dependencies         :
//
// Revision             :
// Revision             :
// Additional Comments  :
//
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"
module operand_fetch(
    input                               clk,            // System Clock
    input                               rst_n,      // Synchronous Negatice Reset
    input                               halt,           // Halt Contro;
    input  [              `XLEN-1:0]    pc_in,          // Program Counter
    input  [              `XLEN-1:0]    rs1_data_in,   // Operand register
    input  [              `XLEN-1:0]    rs2_data_in,    // Operand register
    input  [    `SYS_REGS_WIDTH-1:0]    rd_addr_in,     // Operand register
    input  [    `SYS_REGS_WIDTH-1:0]    rs1_addr_in,    // Operand register
    input  [    `SYS_REGS_WIDTH-1:0]    rs2_addr_in,    // Operand register
    input  [              `XLEN-1:0]    csr_data_in,    // CSR data int
    input  [    `CSR_BASE_WIDTH-1:0]    csr_addr_in,     // CSR
    input  [              `XLEN-1:0]    bypass_rd_data , // Data from execution unit for bypassing
    input  [    `SYS_REGS_WIDTH-1:0]    bypass_rd_addr , // Execution rd address
    input  [      `OPCODE_WIDTH-1:0]    opcode_in      , // Opcode
    input  [        `FUNCT3_LEN-1:0]    funct3_in      , // Function 3
    input  [        `FUNCT7_LEN-1:0]    funct7_in      , // Function 7
    input  [              `XLEN-1:0]    imm_i_data_in  , // I type immediate data
    input  [              `XLEN-1:0]    imm_s_data_in  , // S type immediate data
    input  [              `XLEN-1:0]    imm_b_data_in  , // B type immediate data
    input  [              `XLEN-1:0]    imm_u_data_in  , // U type immediate data
    input  [              `XLEN-1:0]    imm_j_data_in  , // J type immediate data
    input  [              `XLEN-1:0]    uimm_in        ,
    output [      `OPCODE_WIDTH-1:0]    opcode_out     ,    // Opcode
    output [        `FUNCT3_LEN-1:0]    funct3_out     , // Function 3
    output [        `FUNCT7_LEN-1:0]    funct7_out     , // Function 7
    output [              `XLEN-1:0]    imm_i_data_out , // I type immediate data
    output [              `XLEN-1:0]    imm_s_data_out , // S type immediate data
    output [              `XLEN-1:0]    imm_b_data_out , // B type immediate data
    output [              `XLEN-1:0]    imm_u_data_out , // U type immediate data
    output [              `XLEN-1:0]    imm_j_data_out , // J type immediate data
    output [              `XLEN-1:0]    rs1_data_out   , // Operand 1 Out
    output [              `XLEN-1:0]    rs2_data_out   , // Operand 2 Out
    output [    `SYS_REGS_WIDTH-1:0]    rs1_addr_out   , // Destination address
    output [    `SYS_REGS_WIDTH-1:0]    rs2_addr_out   , // Destination address
    output [    `SYS_REGS_WIDTH-1:0]    rd_addr_out    , // Destination address
    output [              `XLEN-1:0]    pc_out         , // PC out
    output [              `XLEN-1:0]    csr_data_out   , // CSR data register
    output [    `CSR_BASE_WIDTH-1:0]    csr_addr_out   , // CSR destination address
    output [              `XLEN-1:0]    uimm_out            // UImm data of CSR
    );

    reg [              `XLEN-1:0]    rs1_data_reg   ; // rs1 register
    reg [              `XLEN-1:0]    rs2_data_reg   ; // rs2 register
    reg [    `SYS_REGS_WIDTH-1:0]    rd_addr_reg    ; // rd register
    reg [    `SYS_REGS_WIDTH-1:0]    rs1_addr_reg   ; // rd register
    reg [    `SYS_REGS_WIDTH-1:0]    rs2_addr_reg   ; // rd register
    reg [      `OPCODE_WIDTH-1:0]    opcode_reg     ; // Opcode register
    reg [        `FUNCT3_LEN-1:0]    funct3_reg     ; // Function 3 register
    reg [        `FUNCT7_LEN-1:0]    funct7_reg     ; // Function 7 register
    reg [              `XLEN-1:0]    imm_i_data_reg ; // I type immediate data register
    reg [              `XLEN-1:0]    imm_s_data_reg ; // S type immediate data register
    reg [              `XLEN-1:0]    imm_b_data_reg ; // B type immediate data register
    reg [              `XLEN-1:0]    imm_u_data_reg ; // U type immediate data register
    reg [              `XLEN-1:0]    imm_j_data_reg ; // J type immediate data register
    reg [              `XLEN-1:0]    pc_out_reg     ; // PC Out register
    reg [              `XLEN-1:0]    csr_data_reg   ; // CSR data register
    reg [    `CSR_BASE_WIDTH-1:0]    csr_addr_reg   ; // CSR address register
    reg [              `XLEN-1:0]    uimm_reg       ; // UImm data register

    wire bypass_rs1;
    wire bypass_rs2;

    assign bypass_rs1 = (bypass_rd_addr == rs1_addr_in) ? 1'b1 : 1'b0;
    assign bypass_rs2 = (bypass_rd_addr == rs2_addr_in) ? 1'b1 : 1'b0;

    assign pc_out         = pc_out_reg     ;
    assign opcode_out     = opcode_reg     ;
    assign funct3_out     = funct3_reg     ;
    assign funct7_out     = funct7_reg     ;
    assign imm_i_data_out = imm_i_data_reg ;
    assign imm_s_data_out = imm_s_data_reg ;
    assign imm_b_data_out = imm_b_data_reg ;
    assign imm_u_data_out = imm_u_data_reg ;
    assign imm_j_data_out = imm_j_data_reg ;
    assign rs1_data_out   = rs1_data_reg   ;
    assign rs2_data_out   = rs2_data_reg   ;
    assign rd_addr_out    = rd_addr_reg    ;
    assign uimm_out       = uimm_reg       ;
    assign csr_addr_out   = csr_addr_reg   ;
    assign csr_data_out   = csr_data_reg   ;
    assign rs1_addr_out   = rs1_addr_reg   ;
    assign rs2_addr_out   = rs2_addr_reg   ;

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            rs1_data_reg    <= 32'h0;
            rs2_data_reg    <= 32'h0;
            rd_addr_reg     <= 5'h0;
            funct3_reg      <= 3'h0;
            funct7_reg      <= 7'h0;
            imm_i_data_reg  <= 32'h0;
            imm_s_data_reg  <= 32'h0;
            imm_b_data_reg  <= 32'h0;
            imm_u_data_reg  <= 32'h0;
            imm_j_data_reg  <= 32'h0;
            opcode_reg      <= 8'h0;
            pc_out_reg      <= 32'h0;
            csr_data_reg    <= 32'h0;
            csr_addr_reg    <= 12'h0;
            uimm_reg        <= 32'h0;
            rs1_addr_reg    <= `SYS_REGS_WIDTH'h0;
            rs2_addr_reg    <= `SYS_REGS_WIDTH'h0;
            end
        else
            begin
            if(!halt)
                begin
                pc_out_reg      <= pc_in;
                rd_addr_reg     <= rd_addr_in;
                opcode_reg      <= opcode_in;
                funct3_reg      <= funct3_in;
                funct7_reg      <= funct7_in;
                imm_i_data_reg  <= imm_i_data_in;
                imm_s_data_reg  <= imm_s_data_in;
                imm_b_data_reg  <= imm_b_data_in;
                imm_u_data_reg  <= imm_u_data_in;
                imm_j_data_reg  <= imm_j_data_in;
                uimm_reg        <= uimm_in;
                csr_data_reg    <= csr_data_in;
                csr_addr_reg    <= csr_addr_in;
                rs1_data_reg    <= (bypass_rs1) ? bypass_rd_data : rs1_data_in;
                rs2_data_reg    <= (bypass_rs2) ? bypass_rd_data : rs2_data_in;
                rs1_addr_reg    <= rs1_addr_in;
                rs2_addr_reg    <= rs2_addr_in;
                end
            end
        end

endmodule

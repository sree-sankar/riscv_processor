//----------------------+-------------------------------------------------------
// Filename             | instr_decode.sv
// File created on      | 05/12/2021 12:48:12
// Created by           | Sree Sankar E
//                      | 09/10/2024 : Porting to System Verilog
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Instruction Decode
//------------------------------------------------------------------------------

`include "riscv.vh"

module instr_decode(
    // Input
    input                           clk_i            , // System Clock
    input                           resetn_i         , // Synchronous Active Low System Reset
    input                           halt_i           , // Halt Control
    input  [          `XLEN-1:0]    pc_i             , // Program Counter
    input  [          `XLEN-1:0]    instr_i          , // Instructions
    input  [          `XLEN-1:0]    rs1_data_i       , // rs1 Data
    input  [          `XLEN-1:0]    rs2_data_i       , // rs2 Data
    // Data Forward Path
    input  [`SYS_REGS_WIDTH-1:0]    forward_rd_addr_i, // Forward Address
    input  [          `XLEN-1:0]    forward_rd_data_i, // Forward Data
    // Output
    output [          `XLEN-1:0]    pc_o             , // PC out
    output [  `OPCODE_WIDTH-1:0]    opcode_o         , // Opcode
    output [`SYS_REGS_WIDTH-1:0]    rd_addr_o        , // Operand register
    output [  `FUNCT3_WIDTH-1:0]    funct3_o         , // Function 3
    output [`SYS_REGS_WIDTH-1:0]    rs1_addr_o       , // Source address
    output [`SYS_REGS_WIDTH-1:0]    rs2_addr_o       , // Source address
    output [          `XLEN-1:0]    rs1_data_o       , // rs1 source data
    output [          `XLEN-1:0]    rs2_data_o       , // rs2 source data
    output                          rs_read_en_o     , // Source Read enable
    output [  `FUNCT7_WIDTH-1:0]    funct7_o         , // Function 7
    output [          `XLEN-1:0]    imm_i_data_o     , // I type immediate data
    output [          `XLEN-1:0]    imm_s_data_o     , // S type immediate data
    output [          `XLEN-1:0]    imm_b_data_o     , // B type immediate data
    output [          `XLEN-1:0]    imm_u_data_o     , // U type immediate data
    output [          `XLEN-1:0]    imm_j_data_o       // J type immediate data
);

//------------------------------------------------------------------------------
// Decoder Enable
//------------------------------------------------------------------------------

    logic [1:0]    resetn_pipe  ;
    logic          decode_enable;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            resetn_pipe <= 'h0;
            end
        else
            begin
            resetn_pipe <= {resetn_pipe[0],resetn_i};
            end
        end

    assign decode_enable = resetn_pipe[0];

//------------------------------------------------------------------------------
// Decoding
//------------------------------------------------------------------------------

    logic [  `OPCODE_WIDTH-1:0]    opcode    ; // Opcode register
    logic [`SYS_REGS_WIDTH-1:0]    rd_addr   ; // rd register
    logic [  `FUNCT3_WIDTH-1:0]    funct3    ; // Function 3 register
    logic [`SYS_REGS_WIDTH-1:0]    rs1_addr  ; // rd register
    logic [`SYS_REGS_WIDTH-1:0]    rs2_addr  ; // rd register
    logic [  `FUNCT7_WIDTH-1:0]    funct7    ; // Function 7 register
    logic [          `XLEN-1:0]    imm_i_data; // I type immediate data register
    logic [          `XLEN-1:0]    imm_s_data; // S type immediate data register
    logic [          `XLEN-1:0]    imm_b_data; // B type immediate data register
    logic [          `XLEN-1:0]    imm_u_data; // U type immediate data register
    logic [          `XLEN-1:0]    imm_j_data; // J type immediate data register

    // Instruction Decoding
    assign opcode     = instr_i[`OPCODE_B ];
    assign rd_addr    = instr_i[`RD_REG_B ];
    assign funct3     = instr_i[`FUNCT3_B ];
    assign rs1_addr   = instr_i[`RS1_REG_B];
    assign rs2_addr   = instr_i[`RS2_REG_B];
    assign funct7     = instr_i[`FUNCT7_B ];

    // Immediate Data Decoding
    assign imm_i_data = {{20{instr_i[31]}},instr_i[`I_IMM_B]};// I-Type Immediate Decoding
    assign imm_s_data = {{20{instr_i[31]}},instr_i[`S_IMMH_B],instr_i[`S_IMML_B]};// S-Type Immediate Decoding
    assign imm_b_data = {{20{instr_i[`B_IMMH_B]}},instr_i[`B_IMMMH_B],instr_i[`B_IMMML_B],instr_i[`B_IMML_B],1'b0}; // B-Type Immediate Decoding
    assign imm_u_data = {instr_i[`U_IMM_B],12'b0}; // U-Type Immediate Decoding
    assign imm_j_data = {{12{instr_i[`J_IMMH_B]}},instr_i[`J_IMMMH_B],instr_i[`J_IMMML_B],instr_i[`J_IMML_B],1'b0}; // J-Type Immediate Decoding

//------------------------------------------------------------------------------
// Pipeline Stage Register
// On Halt write to system register 0 which will be ignored as per RISC V
// architecture
//------------------------------------------------------------------------------

    logic [          `XLEN-1:0]    pc_reg        ; // PC Register
    logic [          `XLEN-1:0]    pc_d_reg      ; // PC Delay Register
    logic [          `XLEN-1:0]    rs1_addr_reg  ; // rd register
    logic [          `XLEN-1:0]    rs2_addr_reg  ; // rd register
    logic [`SYS_REGS_WIDTH-1:0]    rd_addr_reg   ; // rd register
    logic [  `OPCODE_WIDTH-1:0]    opcode_reg    ; // Opcode register
    logic [  `FUNCT3_WIDTH-1:0]    funct3_reg    ; // Function 3 register
    logic [  `FUNCT7_WIDTH-1:0]    funct7_reg    ; // Function 7 register
    logic [          `XLEN-1:0]    imm_i_data_reg; // I type immediate data register
    logic [          `XLEN-1:0]    imm_s_data_reg; // S type immediate data register
    logic [          `XLEN-1:0]    imm_b_data_reg; // B type immediate data register
    logic [          `XLEN-1:0]    imm_u_data_reg; // U type immediate data register
    logic [          `XLEN-1:0]    imm_j_data_reg; // J type immediate data register

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            pc_reg         <= 'h0;
            pc_d_reg       <= 'h0;
            rs1_addr_reg   <= 'h0;
            rs2_addr_reg   <= 'h0;
            opcode_reg     <= 'h0;
            rd_addr_reg    <= 'h0;
            funct3_reg     <= 'h0;
            funct7_reg     <= 'h0;
            imm_i_data_reg <= 'h0;
            imm_s_data_reg <= 'h0;
            imm_b_data_reg <= 'h0;
            imm_u_data_reg <= 'h0;
            imm_j_data_reg <= 'h0;
            end
        else
            begin
            if(halt_i)
                begin
                pc_reg         <= pc_i      ;
                pc_d_reg       <= pc_reg    ;
                rs1_addr_reg   <= rs1_addr  ;
                rs2_addr_reg   <= rs2_addr  ;
                opcode_reg     <= opcode    ;
                rd_addr_reg    <= 'h0       ;
                funct3_reg     <= funct3    ;
                funct7_reg     <= funct7    ;
                imm_i_data_reg <= imm_i_data;
                imm_s_data_reg <= imm_s_data;
                imm_b_data_reg <= imm_b_data;
                imm_u_data_reg <= imm_u_data;
                imm_j_data_reg <= imm_j_data;
                end
            else
                begin
                pc_reg         <= pc_i      ;
                pc_d_reg       <= pc_reg    ;
                rs1_addr_reg   <= rs1_addr  ;
                rs2_addr_reg   <= rs2_addr  ;
                opcode_reg     <= opcode    ;
                rd_addr_reg    <= rd_addr   ;
                funct3_reg     <= funct3    ;
                funct7_reg     <= funct7    ;
                imm_i_data_reg <= imm_i_data;
                imm_s_data_reg <= imm_s_data;
                imm_b_data_reg <= imm_b_data;
                imm_u_data_reg <= imm_u_data;
                imm_j_data_reg <= imm_j_data;
                end
            end
        end

//------------------------------------------------------------------------------
// Forward Data Muxing
// Execute stage to register write takes 2 cycles
//------------------------------------------------------------------------------

    logic                forward_en          ;
    logic [      2:0]    forward_rs1         ;
    logic [      2:0]    forward_rs2         ;
    logic [`XLEN-1:0]    forward_rd_addr[0:1];
    logic [`XLEN-1:0]    forward_rd_data[0:1];

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            forward_en         <= 'h0;
            forward_rd_addr[0] <= 'h0;
            forward_rd_data[0] <= 'h0;
            forward_rd_addr[1] <= 'h0;
            forward_rd_data[1] <= 'h0;
            end
        else
            begin
            forward_en         <= decode_enable     ;
            forward_rd_addr[0] <= forward_rd_addr_i ;
            forward_rd_data[0] <= forward_rd_data_i ;
            forward_rd_addr[1] <= forward_rd_addr[0];
            forward_rd_data[1] <= forward_rd_data[0];
            end
        end

    // rd Execute Stage Forwarding
    assign forward_rs1[0] = (forward_rd_addr_i == rs1_addr_reg) ? forward_en : 1'b0;
    assign forward_rs2[0] = (forward_rd_addr_i == rs2_addr_reg) ? forward_en : 1'b0;

    // rd Memory Stage Forwarding
    assign forward_rs1[1] = (forward_rd_addr[0] == rs1_addr_reg) ? forward_en : 1'b0;
    assign forward_rs2[1] = (forward_rd_addr[0] == rs2_addr_reg) ? forward_en : 1'b0;

    // rd Reg Write Stage Forwarding
    assign forward_rs1[2] = (forward_rd_addr[1] == rs1_addr_reg) ? forward_en : 1'b0;
    assign forward_rs2[2] = (forward_rd_addr[1] == rs2_addr_reg) ? forward_en : 1'b0;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign pc_o         = decode_enable ? pc_d_reg       : 'h0;
    assign opcode_o     = decode_enable ? opcode_reg     : 'h0;
    assign rd_addr_o    = decode_enable ? rd_addr_reg    : 'h0;
    assign funct3_o     = decode_enable ? funct3_reg     : 'h0;
    assign funct7_o     = decode_enable ? funct7_reg     : 'h0;
    assign imm_i_data_o = decode_enable ? imm_i_data_reg : 'h0;
    assign imm_s_data_o = decode_enable ? imm_s_data_reg : 'h0;
    assign imm_b_data_o = decode_enable ? imm_b_data_reg : 'h0;
    assign imm_u_data_o = decode_enable ? imm_u_data_reg : 'h0;
    assign imm_j_data_o = decode_enable ? imm_j_data_reg : 'h0;
    assign rs1_addr_o   = decode_enable ? rs1_addr       : 'h0;
    assign rs2_addr_o   = decode_enable ? rs2_addr       : 'h0;
    assign rs_read_en_o = decode_enable;
    assign rs1_data_o   = forward_rs1[0] ? forward_rd_data_i  :
                          forward_rs1[1] ? forward_rd_data[0] :
                          forward_rs1[2] ? forward_rd_data[1] : rs1_data_i;
    assign rs2_data_o   = forward_rs2[0] ? forward_rd_data_i  :
                          forward_rs2[1] ? forward_rd_data[0] :
                          forward_rs2[2] ? forward_rd_data[1] : rs2_data_i;

endmodule
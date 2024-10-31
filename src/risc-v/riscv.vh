//----------------------+-------------------------------------------------------
// Filename             | riscv.vh
// File created on      | 15.11.2020 12:07:34
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// RISC V Header
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Core Architecture
//------------------------------------------------------------------------------

    `define RV32       1 // 32 bit architecture
    //`define RV64     1 // 64 bit architecture for future
    //`define RV128    1 // 128 bit architecture for future
    //`define MMU      1 // Enable MMU for future

//------------------------------------------------------------------------------
// Privilege Levels
//------------------------------------------------------------------------------

    `define PRIV_MACHINE         1
    //`define PRIV_SUPERVISOR    1 // For future
    //`define PRIV_USER          1 // For future
    //`define DEBUG_MODE         1 // For future

//------------------------------------------------------------------------------
// Privilege Levels Encoding
//------------------------------------------------------------------------------

    `define PRIV_USER_ENCODING         2'b00
    `define PRIV_SUPERVISOR_ENCODING   2'b01
    `define PRIV_RSVD_ENCODING         2'b10
    `define PRIV_MACHINE_ENCODING      2'b11

//------------------------------------------------------------------------------
// Architecture Macros
//------------------------------------------------------------------------------

    `ifdef RV128
        `define XLEN               128
        `define MXLEN              128
    `elsif RV64
        `define XLEN               64
        `define MXLEN              64
    `else
        `define XLEN               32
        `define MXLEN              32
        // Program Counter
        `define PC_INC             4             // PC Increment
        `define PC_RESET_VECTOR    32'h0000_0000 // PC Reset Vector
        // Width
        `define OPCODE_WIDTH       7
        `define RD_RS_ADDR_WIDTH   5
        `define FUNCT3_WIDTH       3
        `define FUNCT7_WIDTH       7
        `define SHIFT_WIDTH        5
        // Bit Field
        `define OPCODE_B           6:0   // Bit Field Opcode
        `define RD_REG_B           11:7  // Bit Field rd Register
        `define FUNCT3_B           14:12 // Bit Field Function 3
        `define RS1_REG_B          19:15 // Bit Field rs1
        `define RS2_REG_B          24:20 // Bit Field rs2
        `define FUNCT7_B           31:25 // Bit Field Function 7
        `define I_IMM_B            31:20 // Bit Field I-Type
        `define S_IMML_B           11:7  // Bit Field S-Type imm[4:0]
        `define S_IMMH_B           31:25 // Bit Field S-Type imm[11:5]
        `define B_IMML_B           11:8  // Bit Field Lower imm[4:1]
        `define B_IMMML_B          30:25 // Bit Field Middle0 imm[10:5]
        `define B_IMMMH_B          7     // Bit Field Middle Low imm[11]
        `define B_IMMH_B           31    // Bit Field Middle High imm[12]
        `define U_IMM_B            31:12 // Bit Field U-Type
        `define J_IMML_B           30:21 // Bit Field Lower imm[10:1]
        `define J_IMMML_B          20    // Bit Field Middle Low imm[11]
        `define J_IMMMH_B          19:12 // Bit Field Middle High imm[19:12]
        `define J_IMMH_B           31    // Bit Field High imm[20]
    `endif

//------------------------------------------------------------------------------
// Instruction Encoding
//------------------------------------------------------------------------------

    // Opcode [6:0]
    `define OP             7'b0110011 // Instruction : ADD,SUB,AND
    `define OP_IMM         7'b0010011 // Immediate Instruction : ADDI,SUBI,SULI
    `define LUI            7'b0110111 // Load Upperimmidiate
    `define AUIPC          7'b0010111 // Add Upperimmidiate
    `define JAL            7'b1101111 // Jump Instruction
    `define JALR           7'b1100111 // Jump Indirect Instruction
    `define BRANCH         7'b1100011 // Branch Instruction
    `define STORE          7'b0100011 // Store Instruction
    `define LOAD           7'b0000011 // Load Instruction
    `define MISC_MEM       7'b0001111 // IO & Memory Access Instruction
    `define SYSTEM         7'b1110011 // Sytem function & CSR

    // Function 3 [14:12] for R, I and S-type Instruction
    `define FN3_ADD_SUB    3'b000 // Add and Subtract
    `define FN3_SLL        3'b001 // Shift Left Logic
    `define FN3_SLT        3'b010 // Set less than
    `define FN3_SLTU       3'b011 // Set less than unsigned
    `define FN3_XOR        3'b100 // XOR
    `define FN3_SRL_SRA    3'b101 // Shift Right Logic & Shift Right Arithmetic
    `define FN3_OR         3'b110 // OR
    `define FN3_AND        3'b111 // AND
    `define FN3_ADDI       3'b000 // Immediate ADD
    `define FN3_SLLI       3'b001 // Immediate Shift Left Logic
    `define FN3_SLTI       3'b010 // Immediate Compare
    `define FN3_SLTIU      3'b011 // Immediate Compare Signed
    `define FN3_XORI       3'b100 // Immediate XOR
    `define FN3_SRLI_SRAI  3'b101 // Immediate Shift Right Logic
    `define FN3_ORI        3'b110 // Immediate OR
    `define FN3_ANDI       3'b111 // Immediate AND
    `define FN3_BEQ        3'b000 // Branch if Equal
    `define FN3_BNE        3'b001 // Branch if Not Equal
    `define FN3_BLT        3'b100 // Branch if less than
    `define FN3_BGE        3'b101 // Branch if greater than
    `define FN3_BLTU       3'b110 // Branch if less than unsigned
    `define FN3_BGEU       3'b111 // Branch if greater than unsigned
    `define FN3_LB         3'b000 // Load Byte
    `define FN3_LH         3'b001 // Load Half Word
    `define FN3_LW         3'b010 // Load Word
    `define FN3_LBU        3'b100 // Load Byte Unsigned
    `define FN3_LHU        3'b101 // Load Half Unsigned
    `define FN3_SB         3'b000 // Store Byte
    `define FN3_SH         3'b001 // Store Half Word
    `define FN3_SW         3'b010 // Store Word

    `define FN3_FENCE      3'b000 // 
    `define FN3_FENCEI     3'b001 // 
    //SYSTEM
    `define PRIV           3'b000 // 
    `define CSRRW          3'b001 // 
    `define CSRRS          3'b010 // 
    `define CSRRC          3'b011 // 
    `define CSRRWI         3'b101 // 
    `define CSRRSI         3'b110 // 
    `define CSRRCI         3'b111 // 

    // Function 7 [31:25]
    `define FN7_F0         7'b0000000 // Function 0
    `define FN7_F1         7'b0100000 // Function 1

    // Function 12 [31:20]
    `define ECALL          12'b0000_0000_0000 // Make serivce request to the execution environment
    `define EBREAK         12'b0000_0000_0001 // Return control to debugging environment
    `define MRET           12'b0011_0000_0010 // Return from Trap
    `define WFI            12'b0001_0000_0101 //

//------------------------------------------------------------------------------
// Exception & Interrupt handler
//------------------------------------------------------------------------------

    `define MVECT_BASE    30'h0

//------------------------------------------------------------------------------
// Interrupt Cause
//------------------------------------------------------------------------------

    `define USR_SOFT_INTR       32'h0000_0000 // User software interrupt
    `define SU_SOFT_INTR        32'h0000_0001 // Supervisor software interrupt
    `define RESERVED0           32'h0000_0002 // Reserved for future standard use
    `define M_SOFT_INTR         32'h0000_0003 // Machine software interrupt
    `define USR_TMR_INTR        32'h0000_0004 // User timer interrupt
    `define SU_TMR_INTR         32'h0000_0005 // Supervisor timer interrupt
    `define RESERVED1           32'h0000_0006 // Reserved for future standard use
    `define M_TMR_INTR          32'h0000_0007 // Machine timer interrupt
    `define USR_EXTRN_INTR      32'h0000_0008 // User external interrupt
    `define SU_EXTRN_INTR       32'h0000_0009 // Supervisor external interrupt
    `define RESERVED2           32'h0000_000A // Reserved for future standard use
    `define M_EXTRN_INTR        32'h0000_000B // Machine external interrupt
    `define RESERVED3           32'h0000_000C // Reserved for future standard use
    `define RESERVED4           32'h0000_000D // Reserved for future standard use
    `define RESERVED5           32'h0000_000E // Reserved for future standard use
    `define RESERVED6           32'h0000_000F // Reserved for future standard use
    `define RESERVED_PTFM       32'h0000_0010 // Reserved for platform use
    `define INSTR_ADDR_MISA     32'h0000_0000 // Instruction address misaligned
    `define INSTR_ACC_FAULT     32'h0000_0001 // Instruction access fault
    `define ILLEGAL_INSTR       32'h0000_0002 // Illegal instruction
    `define BREAKPOINT          32'h0000_0003 // Breakpoint
    `define LD_ADDR_MISA        32'h0000_0004 // Load address misaligned
    `define LD_ACC_FAULT        32'h0000_0005 // Load access fault
    `define STR_AMO_ADDR_MISA   32'h0000_0006 // Store/AMO address misaligned
    `define STR_AMO_ACC_FAULT   32'h0000_0007 // Store/AMO access fault
    `define USR_ENV_CALL        32'h0000_0008 // Environment call from U-mode
    `define SU_ENV_CALL         32'h0000_0009 // Environment call from S-mode
    `define RESERVED7           32'h0000_000A // Reserved
    `define M_ENV_CALL          32'h0000_000B // Environment call from M-mode
    `define INSTR_PG_FAULT      32'h0000_000C // Instruction page fault
    `define LD_PG_FAULT         32'h0000_000D // Load page fault
    `define RESERVED8           32'h0000_000E // Reserved for future standard use
    `define STR_AMO_PG_FAULT    32'h0000_000F // Store/AMO page fault
    `define RESERVED9           32'h0000_0010 // Reserved for future standard use
    `define RESERVED_CUST_1     32'h0000_0018 // Reserved for custom use
    `define RESERVED10          32'h0000_0020 // Reserved for future standard use
    `define RESERVED_CUST_2     32'h0000_0030 // Reserved for custom use
    `define RESERVED11          32'h0000_0040 // Reserved for future standard use

//------------------------------------------------------------------------------
// System and CSR Register Width
//------------------------------------------------------------------------------

    `define SYS_REGS_WIDTH      5
    `define CSR_BASE_WIDTH      12
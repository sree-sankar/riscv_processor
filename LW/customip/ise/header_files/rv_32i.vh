//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2020 12:07:34
// Design Name: 
// Module Name: define
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//
//
//-----------------Privilege Levels---------------------------//
`define PRIV_MACHINE    1
//`define PRIV_SUPERVISOR    1
//`define PRIV_USER    1
//`define DEBUG_MODE    1
//-----------------Privilege Levels ENCODEING---------------------------//
`define PRIV_USER_ENCODING         2'b00
`define PRIV_SUPERVISOR_ENCODING   2'b01
`define PRIV_RSVD_ENCODING         2'b10
`define PRIV_MACHINE_ENCODING      2'b11
//-----------------Privilege Levels ENCODEING---------------------------//
`define RV32     1 // 32 bit architecture  
//`define ARCH_64     1 // 32 bit architecture
//`define ARCH_128     1 // 32 bit architecture
//-----------------Function 3 [14:12]---------------------------//
`define PC_INC			  4
`define XLEN          32
`define MXLEN         32
`define ADDR_LEN    1024
`define ADDR_BUS       5
`define FUNCT3_LEN     3
`define FUNCT7_LEN     7
`define FUNCT12_LEN   12
`define OPCODE_WIDTH   8
`define CSR_UIMM_WIDTH 5
//`define CACHE_DEPTH 250000
//-----------------PC---------------------------//
//`define L1_CACHE 1
//`define L2_CACHE 1
//`define MMU      1
//-----------------PC---------------------------//
`define PC_RESET_VECTOR 32'b0000_0000
//-----------------OPCode[6:0]---------------------------//
`define OP         7'b0110011 //Instruction : ADD,SUB,AND
`define OP_IMM     7'b0010011 //Immediate Instruction : ADDI,SUBI,SULI
`define LUI        7'b0110111 //Load Upperimmidiate
`define AUIPC      7'b0010111 //Add Upperimmidiate
`define JAL        7'b1101111 //Jump Instruction
`define JALR       7'b1100111 //Jump Indirect Instruction
`define BRANCH     7'b1100011 //Branch Instruction
`define STORE      7'b0100011 //Store Instruction
`define LOAD       7'b0000011 //Load Instruction
`define MISC_MEM   7'b0001111 //IO & Memory Access Instruction
`define SYSTEM     7'b1110011 //Sytem function & CSR

//-----------------Function 3 [14:12]---------------------------//
//OP
`define FN3_ADD_SUB    3'b000 //ADD_SUB
`define FN3_SLL        3'b001 //Shift Left Logic
`define FN3_SLT        3'b010 //Compare signed
`define FN3_SLTU       3'b011 //Compare unsigned
`define FN3_XOR        3'b100 //XOR
`define FN3_SRL_SRA    3'b101 //Shift Right Logic & Shift Right Arithmetic
`define FN3_OR         3'b110 //OR
`define FN3_AND        3'b111 //AND
//Immediate
`define FN3_ADDI       3'b000 //ADD 
`define FN3_SLTI       3'b010 //Compare 
`define FN3_SLTIU      3'b011 //Compare Signed 
`define FN3_XORI       3'b100 //XOR 
`define FN3_ORI        3'b110 //OR 
`define FN3_ANDI       3'b111 //AND 
`define FN3_SLLI       3'b001 //Shift Left Logic
`define FN3_SRLI       3'b101 //Shift Right Logic
`define FN3_SRAI       3'b101 //Shift Right Arithmetic
//Branch
`define FN3_BEQ        3'b000 //Branch if Equal 
`define FN3_BNE        3'b001 //Branch if Not Equal
`define FN3_BLT        3'b100 //Branch if less than
`define FN3_BGE        3'b101 //Branch if greater than
`define FN3_BLTU       3'b110 //Branch if less than unsigned
`define FN3_BGEU       3'b111 //Branch if greater than unsigned
//Load
`define FN3_LB         3'b000 //Load Byte
`define FN3_LH         3'b001 //Load Half Word
`define FN3_LW         3'b010 //Load Word
`define FN3_LBU        3'b100 //Load Byte Unsigned
`define FN3_LHU        3'b101 //Load Half Unsigned
//Store
`define FN3_SB         3'b000 //Store Byte
`define FN3_SH         3'b001 //Store Half Word
`define FN3_SW         3'b010 //Store Word
`define FN3_SBU        3'b100 //Store Byte Unsigned
`define FN3_SHU        3'b101 //Store Half Unsigned
//MISC-MEM
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

//-----------------Function 7 [31:25]---------------------------//
`define FN7_F1     7'b0000000 //ADD
`define FN7_F2     7'b0100000 //SUB
//-----------------Function 12 [31:20]--------------------------//
`define ECALL      12'b0000_0000_0000 // Make serivce request to the execution environment
`define EBREAK     12'b0000_0000_0001 // Return control to debugging environment
`define MRET       12'b0011_0000_0010 // Return from Trap
`define WFI        12'b0001_0000_0101 // 
//------------------Exception & Interrupt handler-------------------//
`define MVECT_BASE 30'b00_0000_0000_0000_0000_0000_0000_0000;
//------------------Interrupt Cause---------------------------------//
`define INTR0 1'b0
`define INTR1 1'b1

`define USR_SOFT_INTR       32'h0000_0000   // User software interrupt
`define SU_SOFT_INTR        32'h0000_0001   // Supervisor software interrupt
`define RESERVED0           32'h0000_0002   // Reserved for future standard use
`define M_SOFT_INTR         32'h0000_0003   // Machine software interrupt
`define USR_TMR_INTR        32'h0000_0004   // User timer interrupt
`define SU_TMR_INTR         32'h0000_0005   // Supervisor timer interrupt
`define RESERVED1           32'h0000_0006   // Reserved for future standard use
`define M_TMR_INTR          32'h0000_0007   // Machine timer interrupt
`define USR_EXTRN_INTR      32'h0000_0008   // User external interrupt
`define SU_EXTRN_INTR       32'h0000_0009   // Supervisor external interrupt
`define RESERVED2           32'h0000_000A   // Reserved for future standard use
`define M_EXTRN_INTR        32'h0000_000B   // Machine external interrupt
`define RESERVED3           32'h0000_000C   // Reserved for future standard use
`define RESERVED4           32'h0000_000D   // Reserved for future standard use
`define RESERVED5           32'h0000_000E   // Reserved for future standard use
`define RESERVED6           32'h0000_000F   // Reserved for future standard use
`define RESERVED_PTFM       32'h0000_0010   // Reserved for platform use
`define INSTR_ADDR_MISA     32'h0000_0000   // Instruction address misaligned
`define INSTR_ACC_FAULT     32'h0000_0001   // Instruction access fault
`define ILLEGAL_INSTR       32'h0000_0002   // Illegal instruction
`define BREAKPOINT          32'h0000_0003   // Breakpoint
`define LD_ADDR_MISA        32'h0000_0004   // Load address misaligned
`define LD_ACC_FAULT        32'h0000_0005   // Load access fault
`define STR_AMO_ADDR_MISA   32'h0000_0006   // Store/AMO address misaligned
`define STR_AMO_ACC_FAULT   32'h0000_0007   // Store/AMO access fault
`define USR_ENV_CALL        32'h0000_0008   // Environment call from U-mode
`define SU_ENV_CALL         32'h0000_0009   // Environment call from S-mode
`define RESERVED7           32'h0000_000A   // Reserved
`define M_ENV_CALL          32'h0000_000B   // Environment call from M-mode
`define INSTR_PG_FAULT      32'h0000_000C   // Instruction page fault 
`define LD_PG_FAULT         32'h0000_000D   // Load page fault 
`define RESERVED8           32'h0000_000E   // Reserved for future standard use 
`define STR_AMO_PG_FAULT    32'h0000_000F   // Store/AMO page fault 
`define RESERVED9           32'h0000_0010   // Reserved for future standard use
`define RESERVED_CUST_1     32'h0000_0018   // Reserved for custom use
`define RESERVED10           32'h0000_0020   // Reserved for future standard use
`define RESERVED_CUST_2     32'h0000_0030   // Reserved for custom use 
`define RESERVED11          32'h0000_0040   // Reserved for future standard use

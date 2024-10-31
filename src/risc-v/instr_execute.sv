//----------------------+-------------------------------------------------------
// Filename             | instr_exec.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Instruction Execute
//------------------------------------------------------------------------------

`include "riscv.vh"

module instr_exec(
    // Input
    input                           clk_i           , // System Clock
    input                           resetn_i        , // Synchronous Active Low Reset
    input                           halt_i          , // Halt control
    input  [          `XLEN-1:0]    pc_i            , // PC value
    input  [  `OPCODE_WIDTH-1:0]    opcode_i        , // Opcode
    input  [  `FUNCT3_WIDTH-1:0]    funct3_i        , // Function 3
    input  [  `FUNCT7_WIDTH-1:0]    funct7_i        , // Function 7
    input  [`SYS_REGS_WIDTH-1:0]    rd_addr_i       , // Address of destionation register
    input  [          `XLEN-1:0]    imm_i_data_i    , // I type immediate data
    input  [          `XLEN-1:0]    imm_s_data_i    , // S type immediate data
    input  [          `XLEN-1:0]    imm_b_data_i    , // B type immediate data
    input  [          `XLEN-1:0]    imm_u_data_i    , // U type immediate data
    input  [          `XLEN-1:0]    imm_j_data_i    , // J type immediate data
    input  [          `XLEN-1:0]    rs1_data_i      , // Operand 1 In
    input  [          `XLEN-1:0]    rs2_data_i      , // Operand 2 In
    // Output
    output                          branch_en_o     , // Branch enable
    output [          `XLEN-1:0]    branch_addr_o   , // Branch address
    output [          `XLEN-1:0]    mem_addr_o      , // Address of memory to be read
    output                          mem_read_en_o   , // Memory Read Enable
    output                          mem_write_en_o  , // Memory Write Enable
    output [          `XLEN-1:0]    mem_write_data_o, // Address of memory to be read
    output [`SYS_REGS_WIDTH-1:0]    rd_addr_o       , // Destination address out register
    output                          rd_write_en_o   , // rd Write enable to rd register
    output [                4:0]    rd_write_fmt_o  , // rd Write format
    output [          `XLEN-1:0]    rd_data_o         // Data to be written to rd register
);

    // Parameter for Control Path
    localparam [32:0] NOP          = 32'h0000_0000, // No operation
                      ALU_ADD      = 32'h0000_0001, // Add Signed
                      ALU_ADDU     = 32'h0000_0002, // Add Usigned
                      ALU_SUB      = 32'h0000_0004, // Subtraction
                      ALU_SLL      = 32'h0000_0008, // Shift Left
                      ALU_SRL      = 32'h0000_0010, // Shift right logic
                      ALU_SRA      = 32'h0000_0020, // Shift right arithmetic
                      ALU_SLT      = 32'h0000_0040, // Less than
                      ALU_SLTU     = 32'h0000_0080, // Less than unsigned
                      ALU_XOR      = 32'h0000_0100, // XOR operation
                      ALU_OR       = 32'h0000_0200, // OR operation
                      ALU_AND      = 32'h0000_0400, // AND operation
                      ALU_BEQ      = 32'h0000_0800, // Branch Equal
                      ALU_BNE      = 32'h0000_1000, // Branch Not Equal
                      ALU_BLT      = 32'h0000_2000, // Branch Less than
                      ALU_BLTU     = 32'h0000_4000, // Branch Less than unsigned
                      ALU_BGE      = 32'h0000_8000, // Branch Less than
                      ALU_BGEU     = 32'h0001_0000, // Branch Less than unsigned
                      INSTR_JUMP   = 32'h0002_0000, // For JAL and JALR
                      LUI_AUIPC    = 32'h0004_0000, // Register Store
                      MEM_LB       = 32'h0008_0000, // Memory Load Byte
                      MEM_LH       = 32'h0010_0000, // Memory Load High 16
                      MEM_LW       = 32'h0020_0000, // Memory Load Word
                      MEM_LBU      = 32'h0040_0000, // Memory Load Byte unsigned
                      MEM_LHU      = 32'h0080_0000, // Memory Load Higher unsigned
                      MEM_SB       = 32'h0100_0000, // Memory Store Byte
                      MEM_SH       = 32'h0200_0000, // Memory Store High 16
                      MEM_SW       = 32'h0400_0000; // Memory Store Word

//------------------------------------------------------------------------------
// Execute Enable
//------------------------------------------------------------------------------

    logic [1:0]    resetn_pipe;
    logic          exec_enable;

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

    assign exec_enable = resetn_pipe[1];

//------------------------------------------------------------------------------
// Control Path
// TBD :
//      Write to x0 must raise exception
//------------------------------------------------------------------------------

    logic [     31:0]    exec_op      ;
    logic [      1:0]    adder_op     ;
    logic [      5:0]    compare_op   ;
    logic [      2:0]    shift_op     ;
    logic                sub_en       ;
    logic                xor_en       ;
    logic                and_en       ;
    logic                or_en        ;
    logic                branch_en    ;
    logic                rd_write_en  ;
    logic                mem_read_en  ;
    logic                mem_write_en ;
    logic [`XLEN-1:0]    compare_data0;
    logic [`XLEN-1:0]    compare_data1;
    logic [`XLEN-1:0]    compare_res  ;
    logic [      4:0]    rd_write_fmt ;

    always_comb
        begin
        case(opcode_i)
            `OP :
                begin
                case(funct3_i)
                    `FN3_ADD_SUB : exec_op <= (funct7_i == `FN7_F0) ? ALU_ADD  :
                                              (funct7_i == `FN7_F1) ? ALU_SUB  : NOP;
                    `FN3_SLL     : exec_op <= (funct7_i == `FN7_F0) ? ALU_SLL  : NOP;
                    `FN3_SLT     : exec_op <= (funct7_i == `FN7_F0) ? ALU_SLT  : NOP;
                    `FN3_SLTU    : exec_op <= (funct7_i == `FN7_F0) ? ALU_SLTU : NOP;
                    `FN3_XOR     : exec_op <= (funct7_i == `FN7_F0) ? ALU_XOR  : NOP;
                    `FN3_SRL_SRA : exec_op <= (funct7_i == `FN7_F0) ? ALU_SRL  :
                                              (funct7_i == `FN7_F1) ? ALU_SRA  : NOP;
                    `FN3_OR      : exec_op <= (funct7_i == `FN7_F0) ? ALU_OR   : NOP;
                    `FN3_AND     : exec_op <= (funct7_i == `FN7_F0) ? ALU_AND  : NOP;
                    default      : exec_op <= NOP;
                endcase
                end
            `OP_IMM :
                begin
                case(funct3_i)
                    `FN3_ADDI      : exec_op <= ALU_ADD;
                    `FN3_SLLI      : exec_op <= (funct7_i == `FN7_F0) ? ALU_SLL : NOP;
                    `FN3_SLTI      : exec_op <= ALU_SLT ;
                    `FN3_SLTIU     : exec_op <= ALU_SLTU;
                    `FN3_XORI      : exec_op <= ALU_XOR ;
                    `FN3_SRLI_SRAI : exec_op <= (funct7_i == `FN7_F0) ? ALU_SRL :
                                                (funct7_i == `FN7_F1) ? ALU_SRA : NOP;
                    `FN3_ORI       : exec_op <= ALU_OR ;
                    `FN3_ANDI      : exec_op <= ALU_AND;
                    default        : exec_op <= NOP    ;
                endcase
                end
            `BRANCH :
                begin
                case(funct3_i)
                    `FN3_BEQ  : exec_op <= ALU_BEQ ;
                    `FN3_BNE  : exec_op <= ALU_BNE ;
                    `FN3_BLT  : exec_op <= ALU_BLT ;
                    `FN3_BGE  : exec_op <= ALU_BGE ;
                    `FN3_BLTU : exec_op <= ALU_BLTU;
                    `FN3_BGEU : exec_op <= ALU_BGEU;
                    default   : exec_op <= NOP;
                endcase
                end
            `LUI   : exec_op <= LUI_AUIPC ;
            `AUIPC : exec_op <= LUI_AUIPC ;
            `JAL   : exec_op <= INSTR_JUMP;
            `JALR  : exec_op <= INSTR_JUMP;
            `LOAD  :
                begin
                case(funct3_i)
                    `FN3_LB  : exec_op <= MEM_LB ;
                    `FN3_LH  : exec_op <= MEM_LH ;
                    `FN3_LW  : exec_op <= MEM_LW ;
                    `FN3_LBU : exec_op <= MEM_LBU;
                    `FN3_LHU : exec_op <= MEM_LHU;
                    default  : exec_op <= NOP;
                endcase
                end
            `STORE :
                begin
                case(funct3_i)
                    `FN3_SB  : exec_op <= MEM_SB ;
                    `FN3_SH  : exec_op <= MEM_SH ;
                    `FN3_SW  : exec_op <= MEM_SW ;
                    default  : exec_op <= NOP;
                endcase
                end
            default : exec_op <= NOP;
        endcase
        end

    // Arithmetic Operation Control
    assign adder_op   = exec_op[ 1:0] | exec_op[18] | {1'b0,(branch_en | mem_read_en | mem_write_en)};
    assign sub_en     = exec_op[   2];
    assign shift_op   = exec_op[ 5:3];
    assign compare_op = {exec_op[7:6],2'b00} | exec_op[16:11];

    // Logical Operation Control
    assign xor_en = exec_op[ 8];
    assign or_en  = exec_op[ 9];
    assign and_en = exec_op[10];

    // Register Write Control
    assign rd_write_en  = |exec_op & !exec_op[16:11] & !mem_write_en;
    assign rd_write_fmt = exec_op[23:19] ;
    assign mem_read_en  = |exec_op[23:19];
    assign mem_write_en = |exec_op[26:24];

    // Branch Control
    assign branch_en = exec_op[17] | (exec_op[16:11] && compare_res[0]);

//------------------------------------------------------------------------------
// Data Path
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    data0         ;
    logic [`XLEN-1:0]    data1         ;
    logic [`XLEN-1:0]    mem_addr      ;
    logic [`XLEN-1:0]    mem_write_data;
    logic [`XLEN-1:0]    rd_data       ;
    logic [`XLEN-1:0]    alu_result    ;
    logic [`XLEN-1:0]    branch_addr   ;

    always_comb
        begin
        case(opcode_i)
            `OP :
                begin
                data0         <= rs1_data_i;
                data1         <= rs2_data_i;
                compare_data0 <= rs1_data_i;
                compare_data1 <= rs2_data_i;
                rd_data       <= alu_result;
                mem_addr      <= 'h0       ;
                branch_addr   <= 'h0       ;
                end
            `OP_IMM :
                begin
                data0         <= rs1_data_i  ;
                data1         <= imm_i_data_i;
                compare_data0 <= rs1_data_i  ;
                compare_data1 <= rs2_data_i  ;
                rd_data       <= alu_result  ;
                mem_addr      <= 'h0         ;
                branch_addr   <= 'h0         ;
                end
            `BRANCH :
                begin
                data0         <= pc_i        ;
                data1         <= imm_b_data_i;
                compare_data0 <= rs1_data_i  ;
                compare_data1 <= rs2_data_i  ;
                rd_data       <= 'h0         ;
                mem_addr      <= 'h0         ;
                branch_addr   <= alu_result  ;
                end
            `LUI :
                begin
                data0         <= 'h0         ;
                data1         <= 'h0         ;
                compare_data0 <= 'h0         ;
                compare_data1 <= 'h0         ;
                rd_data       <= imm_u_data_i;
                mem_addr      <= 'h0         ;
                branch_addr   <= 'h0         ;
                end
            `AUIPC :
                begin
                data0         <= pc_i        ;
                data1         <= imm_u_data_i;
                rd_data       <= alu_result  ;
                compare_data0 <= 'h0         ;
                compare_data1 <= 'h0         ;
                mem_addr      <= 'h0         ;
                branch_addr   <= 'h0         ;
                end
            `JAL :
                begin
                data0         <= pc_i          ;
                data1         <= imm_j_data_i  ;
                compare_data0 <= 'h0           ;
                compare_data1 <= 'h0           ;
                rd_data       <= pc_i + `PC_INC;
                mem_addr      <= 'h0           ;
                branch_addr   <= alu_result    ;
                end
            `JALR :
                begin
                data0         <= rs1_data_i    ;
                data1         <= imm_i_data_i  ;
                compare_data0 <= 'h0           ;
                compare_data1 <= 'h0           ;
                rd_data       <= pc_i + `PC_INC;
                mem_addr      <= 'h0           ;
                branch_addr   <= alu_result    ;
                end
            `LOAD :
                begin
                data0         <= rs1_data_i  ;
                data1         <= imm_i_data_i;
                compare_data0 <= 'h0         ;
                compare_data1 <= 'h0         ;
                rd_data       <= 'h0         ;
                mem_addr      <= alu_result  ;
                branch_addr   <= 'h0         ;
                end
            `STORE :
                begin
                data0         <= rs1_data_i  ;
                data1         <= imm_s_data_i;
                compare_data0 <= 'h0         ;
                compare_data1 <= 'h0         ;
                rd_data       <= 'h0         ;
                mem_addr      <= alu_result  ;
                branch_addr   <= 'h0         ;
                end
            default :
                begin
                data0         <= 'h0;
                data1         <= 'h0;
                compare_data0 <= 'h0;
                compare_data1 <= 'h0;
                rd_data       <= 'h0;
                mem_addr      <= 'h0;
                branch_addr   <= 'h0;
                end
        endcase
        end

    // Memeory Write Data
    assign mem_write_data = exec_op[24] ? {{(`XLEN-8){1'b0}},rs2_data_i[7:0]}   :
                            exec_op[25] ? {{(`XLEN-16){1'b0}},rs2_data_i[15:0]} :
                            exec_op[26] ? rs2_data_i : 'h0;

//------------------------------------------------------------------------------
// ALU Unit
//------------------------------------------------------------------------------

    alu #(
        .DW              (`XLEN         ),
        .SHIFT_WIDTH     (`SHIFT_WIDTH  )
    ) alu_inst(
        .clk_i           (clk_i         ),
        .resetn_i        (resetn_i      ),
        .adder_op_i      (adder_op      ),
        .compare_op_i    (compare_op    ),
        .shift_op_i      (shift_op      ),
        .sub_en_i        (sub_en        ),
        .xor_en_i        (xor_en        ),
        .and_en_i        (and_en        ),
        .or_en_i         (or_en         ),
        .data0_i         (data0         ),
        .data1_i         (data1         ),
        .compare_data0   (compare_data0 ),
        .compare_data1   (compare_data1 ),
        .compare_res_o   (compare_res   ),
        .result_o        (alu_result    )
    );

//------------------------------------------------------------------------------
// Pipeline Stage Register
//------------------------------------------------------------------------------

    logic                          branch_en_reg     ;
    logic [          `XLEN-1:0]    branch_addr_reg   ;
    logic                          mem_write_en_reg  ;
    logic                          mem_read_en_reg   ;
    logic [          `XLEN-1:0]    mem_addr_reg      ;
    logic [          `XLEN-1:0]    mem_write_data_reg;
    logic [`SYS_REGS_WIDTH-1:0]    rd_addr_reg       ;
    logic [                4:0]    rd_write_fmt_reg  ;
    logic [          `XLEN-1:0]    rd_data_reg       ;
    logic                          rd_write_en_reg   ;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            branch_en_reg      <= 'h0;
            branch_addr_reg    <= 'h0;
            rd_addr_reg        <= 'h0;
            rd_write_en_reg    <= 'h0;
            rd_write_fmt_reg   <= 'h0;
            rd_data_reg        <= 'h0;
            mem_addr_reg       <= 'h0;
            mem_read_en_reg    <= 'h0;
            mem_write_en_reg   <= 'h0;
            mem_write_data_reg <= 'h0;
            end
        else
            begin
            if(!halt_i)
                begin
                branch_addr_reg    <= branch_addr   ;
                branch_en_reg      <= branch_en     ;
                rd_addr_reg        <= rd_addr_i     ;
                rd_write_en_reg    <= rd_write_en   ;
                rd_write_fmt_reg   <= rd_write_fmt  ;
                rd_data_reg        <= rd_data       ;
                mem_addr_reg       <= mem_addr      ;
                mem_read_en_reg    <= mem_read_en   ;
                mem_write_en_reg   <= mem_write_en  ;
                mem_write_data_reg <= mem_write_data;
                end
            else
                begin
                branch_en_reg      <= branch_en     ;
                branch_addr_reg    <= branch_addr   ;
                rd_addr_reg        <= rd_addr_i     ;
                rd_write_en_reg    <= 'h0           ;
                rd_write_fmt_reg   <= 'h0           ;
                rd_data_reg        <= rd_data       ;
                mem_addr_reg       <= mem_addr      ;
                mem_read_en_reg    <= 'h0           ;
                mem_write_en_reg   <= 'h0           ;
                mem_write_data_reg <= mem_write_data;
                end
            end
        end

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign branch_en_o      = branch_en_reg     ;
    assign branch_addr_o    = branch_addr_reg   ;
    assign rd_data_o        = rd_data_reg       ;
    assign rd_write_en_o    = rd_write_en_reg & exec_enable;
    assign rd_write_fmt_o   = rd_write_fmt_reg  ;
    assign rd_addr_o        = rd_addr_reg       ;
    assign mem_addr_o       = mem_addr_reg      ;
    assign mem_read_en_o    = mem_read_en_reg & exec_enable;
    assign mem_write_en_o   = mem_write_en_reg & exec_enable;
    assign mem_write_data_o = mem_write_data_reg;

endmodule
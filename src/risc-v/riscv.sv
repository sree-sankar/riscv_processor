//----------------------+-------------------------------------------------------
// Filename             | riscv.sv
// File created on      | 05/12/2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// RISC V Core File
//------------------------------------------------------------------------------

module riscv(
    // Clock and Reset
    input                 clk_i           , // System Clock
    input                 resetn_i        , // Synchronous Active Low System Reset
    // Instruction
    output [`XLEN-1:0]    instr_addr_o    , // Program Counter
    input  [`XLEN-1:0]    instr_i         , // Fetched Instrcution
    // Memory
    output [`XLEN-1:0]    mem_addr_o      , // Memory Address
    output                mem_read_en_o   , // Memory Read Enable
    input  [`XLEN-1:0]    mem_read_data_i , // Memory Read Data
    output                mem_write_en_o  , // Memory Write Enable
    output [`XLEN-1:0]    mem_write_data_o  // Memory Write Data
);

//------------------------------------------------------------------------------
// Fetch Stage
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    fetch_instr   ; // Fetch Intruction
    logic [`XLEN-1:0]    fetch_pc      ; // Fetch Program Counter
    logic [`XLEN-1:0]    fetch_rs1_data; // Forward rs1 data
    logic [`XLEN-1:0]    fetch_rs2_data; // Forward rs2 data

//------------------------------------------------------------------------------
// Decode Stage
//------------------------------------------------------------------------------

    logic [          `XLEN-1:0]    decode_pc        ; // Decoded PC
    logic [  `OPCODE_WIDTH-1:0]    decode_opcode    ; // Decoded Opcode
    logic [`SYS_REGS_WIDTH-1:0]    decode_rd_addr   ; // Decoded destination address
    logic [  `FUNCT3_WIDTH-1:0]    decode_funct3    ; // Decoded Function 3
    logic [`SYS_REGS_WIDTH-1:0]    decode_rs1_addr  ; // Decoded rs1_addr
    logic [`SYS_REGS_WIDTH-1:0]    decode_rs2_addr  ; // Decoded rs2_addr
    logic                          decode_rs_read_en; // Decode rs_read_en
    logic [  `FUNCT7_WIDTH-1:0]    decode_funct7    ; // Decoded Function 7
    logic [          `XLEN-1:0]    decode_rs1_data  ; // Decode Read Data
    logic [          `XLEN-1:0]    decode_rs2_data  ; // Decode Read Data
    logic [          `XLEN-1:0]    decode_imm_i_data; // Decoded Immediate I type
    logic [          `XLEN-1:0]    decode_imm_s_data; // Decoded Immediate S type
    logic [          `XLEN-1:0]    decode_imm_b_data; // Decoded Immediate B type
    logic [          `XLEN-1:0]    decode_imm_u_data; // Decoded Immediate U type
    logic [          `XLEN-1:0]    decode_imm_j_data; // Decoded Immediate J type

//------------------------------------------------------------------------------
// Execute Stage
//------------------------------------------------------------------------------

    logic [          `XLEN-1:0]    exec_mem_addr      ; // Execute memory address
    logic                          exec_mem_read_en   ; // Execute memory write enble
    logic                          exec_mem_write_en  ; // Execute memory write enble
    logic [          `XLEN-1:0]    exec_mem_write_data; // Execute memory data
    logic [`SYS_REGS_WIDTH-1:0]    exec_rd_addr       ; // Execute rd address
    logic                          exec_rd_write_en   ; // Execute rd write enable
    logic [                4:0]    exec_rd_write_fmt  ; // Memory Write Format
    logic [          `XLEN-1:0]    exec_rd_data       ; // Execute rd data
    logic                          exec_branch_en     ; // Execute Branch Enable Trigger
    logic [          `XLEN-1:0]    exec_branch_addr   ; // Execute Fetched Intruction

//------------------------------------------------------------------------------
// Memory Access Stage
//------------------------------------------------------------------------------

    logic [`SYS_REGS_WIDTH-1:0]    mem_rd_addr    ; // Memory rd address
    logic                          mem_rd_write_en; // Memory rd write enable
    logic [          `XLEN-1:0]    mem_rd_data    ; // Memory rd data
    logic [          `XLEN-1:0]    mem_addr       ; // Memory address
    logic                          mem_read_en    ; // Memory read enable
    logic                          mem_write_en   ; // Memory write enable
    logic [          `XLEN-1:0]    mem_write_data ; // Memory write data

//------------------------------------------------------------------------------
// Register Write Stage
//------------------------------------------------------------------------------

    logic [`SYS_REGS_WIDTH-1:0]    reg_write_rd_addr    ; // Register Write rd address
    logic                          reg_write_rd_write_en; // Memory Write Enable
    logic [          `XLEN-1:0]    reg_write_rd_data    ; // Register Write rd data

//------------------------------------------------------------------------------
// Halt Controller
//------------------------------------------------------------------------------

    logic    halt_decode    ; // Halt decode state
    logic    halt_exec      ; // Halt execute state
    logic    halt_mem       ; // Halt memory access
    logic    halt_reg_write ; // Halt register write state

//------------------------------------------------------------------------------
// Instruction Fetch
//------------------------------------------------------------------------------

    instr_fetch instr_fetch_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .instr_i           (instr_i                      ),
        .branch_en_i       (exec_branch_en               ),
        .branch_addr_i     (exec_branch_addr             ),
        .pc_o              (fetch_pc                     ),
        .instr_o           (fetch_instr                  )
    );

    assign instr_addr_o = fetch_pc; // Intruction Read Address

//------------------------------------------------------------------------------
// Instruction Decode
//------------------------------------------------------------------------------

    instr_decode instr_decode_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .halt_i            (halt_decode                  ),
        .pc_i              (fetch_pc                     ),
        .instr_i           (fetch_instr                  ),
        .rs1_data_i        (fetch_rs1_data               ),
        .rs2_data_i        (fetch_rs2_data               ),
        .forward_rd_addr_i (exec_rd_addr                 ),
        .forward_rd_data_i (exec_rd_data                 ),
        .pc_o              (decode_pc                    ),
        .opcode_o          (decode_opcode                ),
        .funct3_o          (decode_funct3                ),
        .funct7_o          (decode_funct7                ),
        .rs1_addr_o        (decode_rs1_addr              ),
        .rs2_addr_o        (decode_rs2_addr              ),
        .rs1_data_o        (decode_rs1_data              ),
        .rs2_data_o        (decode_rs2_data              ),
        .rs_read_en_o      (decode_rs_read_en            ),
        .rd_addr_o         (decode_rd_addr               ),
        .imm_i_data_o      (decode_imm_i_data            ),
        .imm_s_data_o      (decode_imm_s_data            ),
        .imm_b_data_o      (decode_imm_b_data            ),
        .imm_u_data_o      (decode_imm_u_data            ),
        .imm_j_data_o      (decode_imm_j_data            )
    );

//------------------------------------------------------------------------------
// Instruction Execute
//------------------------------------------------------------------------------

    instr_exec instr_exec_inst (
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .halt_i            (halt_exec                    ),
        .pc_i              (decode_pc                    ),
        .opcode_i          (decode_opcode                ),
        .funct3_i          (decode_funct3                ),
        .funct7_i          (decode_funct7                ),
        .rd_addr_i         (decode_rd_addr               ),
        .imm_i_data_i      (decode_imm_i_data            ),
        .imm_s_data_i      (decode_imm_s_data            ),
        .imm_b_data_i      (decode_imm_b_data            ),
        .imm_u_data_i      (decode_imm_u_data            ),
        .imm_j_data_i      (decode_imm_j_data            ),
        .rs1_data_i        (decode_rs1_data              ),
        .rs2_data_i        (decode_rs2_data              ),
        .branch_en_o       (exec_branch_en               ),
        .branch_addr_o     (exec_branch_addr             ),
        .mem_addr_o        (exec_mem_addr                ),
        .mem_read_en_o     (exec_mem_read_en             ),
        .mem_write_en_o    (exec_mem_write_en            ),
        .mem_write_data_o  (exec_mem_write_data          ),
        .rd_addr_o         (exec_rd_addr                 ),
        .rd_write_en_o     (exec_rd_write_en             ),
        .rd_write_fmt_o    (exec_rd_write_fmt            ),
        .rd_data_o         (exec_rd_data                 )
    );

//------------------------------------------------------------------------------
// Memory Access
//------------------------------------------------------------------------------

    mem_access mem_access_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .halt_i            (halt_mem                     ),
        .mem_addr_i        (exec_mem_addr                ),
        .mem_read_en_i     (exec_mem_read_en             ),
        .mem_read_data_i   (mem_read_data_i              ),
        .mem_write_en_i    (exec_mem_write_en            ),
        .mem_write_data_i  (exec_mem_write_data          ),
        .rd_addr_i         (exec_rd_addr                 ),
        .rd_write_en_i     (exec_rd_write_en             ),
        .rd_write_fmt_i    (exec_rd_write_fmt            ),
        .rd_data_i         (exec_rd_data                 ),
        .mem_addr_o        (mem_addr                     ),
        .mem_read_en_o     (mem_read_en                  ),
        .mem_write_en_o    (mem_write_en                 ),
        .mem_write_data_o  (mem_write_data               ),
        .rd_addr_o         (mem_rd_addr                  ),
        .rd_write_en_o     (mem_rd_write_en              ),
        .rd_data_o         (mem_rd_data                  )
    );

    assign mem_addr_o       = mem_addr      ;
    assign mem_read_en_o    = mem_read_en   ;
    assign mem_write_en_o   = mem_write_en  ;
    assign mem_write_data_o = mem_write_data;

//------------------------------------------------------------------------------
// Register Write Back
//------------------------------------------------------------------------------

    reg_write reg_write_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .halt_i            (halt_reg_write               ),
        .rd_addr_i         (mem_rd_addr                  ),
        .rd_write_en_i     (mem_rd_write_en              ),
        .rd_data_i         (mem_rd_data                  ),
        .rd_addr_o         (reg_write_rd_addr            ),
        .rd_write_en_o     (reg_write_rd_write_en        ),
        .rd_data_o         (reg_write_rd_data            )
    );

//------------------------------------------------------------------------------
// System Register
//------------------------------------------------------------------------------

    sys_regs sys_regs_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .read_en_i         (decode_rs_read_en            ),
        .rs1_addr_i        (decode_rs1_addr              ),
        .rs2_addr_i        (decode_rs2_addr              ),
        .rs1_data_o        (fetch_rs1_data               ),
        .rs2_data_o        (fetch_rs2_data               ),
        .rd_addr_i         (reg_write_rd_addr            ),
        .rd_write_en_i     (reg_write_rd_write_en        ),
        .rd_data_i         (reg_write_rd_data            )
    );

//------------------------------------------------------------------------------
// Halt Controller
//------------------------------------------------------------------------------

    halt_ctrl halt_ctrl_inst(
        .clk_i             (clk_i                        ),
        .resetn_i          (resetn_i                     ),
        .branch_en_i       (exec_branch_en               ),
        .halt_decode_o     (halt_decode                  ),
        .halt_exec_o       (halt_exec                    ),
        .halt_mem_o        (halt_mem                     ),
        .halt_reg_write_o  (halt_reg_write               )
    );

endmodule


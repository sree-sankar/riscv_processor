`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          : 05.12.2021 12:48:12
// Design Name          :
// Module Name          : rv_core
// Project Name         :
// Target Devices       :
// Tool Versions        :
// Description          :
//
// Dependencies         :
//
// Revision             : 1.0
// Additional Comments  :
//
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"

module rv_core(
    input                 clk            , // System Clock
    input                 rst_n          , // System Reset
    input  [`XLEN-1:0]    instr          , // Instruction
    input  [`XLEN-1:0]    mem_read_data  , // Memory Read Data
    output [`XLEN-1:0]    mem_write_data , // Memory Write Data
    output [`XLEN-1:0]    mem_addr       , // Memory Address
    output [`XLEN-1:0]    pc             , // Program Counter
    // Control Signals
    output                instr_rd_en    , // Instruction Read Enable
    output                mem_data_rd_en , // Read Enable signal for data read
    output                mem_data_wr_en   // Write enable signal for data write
);

//-----------------------------------Fetch-----------------------------------//
    wire [              `XLEN-1:0]    fetch_instr       ; // Fetched Intruction
    wire [    `SYS_REGS_WIDTH-1:0]    fetch_rs1_addr    ; // Operand Register 1 Address
    wire [    `SYS_REGS_WIDTH-1:0]    fetch_rs2_addr    ; // Operand Register 2 Address
    wire [    `SYS_REGS_WIDTH-1:0]    fetch_rd_addr     ; // Destination Register Address
    wire [              `XLEN-1:0]    fetch_rs1_data    ; // Operand Register 1 data
    wire [              `XLEN-1:0]    fetch_rs2_data    ; // Operand Register 2 data
    wire [              `XLEN-1:0]    fetch_csr_data    ; // Fetch CSR data
    wire [    `CSR_BASE_WIDTH-1:0]    fetch_csr_addr    ; // Fetch CSR address
    // Control Signals
    wire                             fetch_branch_taken ; // Branched
//-----------------------------------Decode----------------------------------//
    wire [              `XLEN-1:0]    decode_pc          ; // Decoded PC
    wire [      `OPCODE_WIDTH-1:0]    decode_opcode      ; // Decoded Opcode
    wire [    `SYS_REGS_WIDTH-1:0]    decode_rs1_addr    ; // Decoded rs1_addr
    wire [    `SYS_REGS_WIDTH-1:0]    decode_rs2_addr    ; // Decoded rs2_addr
    wire [        `FUNCT3_LEN-1:0]    decode_funct3      ; // Decoded Function 3
    wire [        `FUNCT7_LEN-1:0]    decode_funct7      ; // Decoded Function 7
    wire [              `XLEN-1:0]    decode_imm_i_data  ; // Decoded Immediate I type
    wire [              `XLEN-1:0]    decode_imm_s_data  ; // Decoded Immediate S type
    wire [              `XLEN-1:0]    decode_imm_b_data  ; // Decoded Immediate B type
    wire [              `XLEN-1:0]    decode_imm_u_data  ; // Decoded Immediate U type
    wire [              `XLEN-1:0]    decode_imm_j_data  ; // Decoded Immediate J type
    wire [    `SYS_REGS_WIDTH-1:0]    decode_rd_addr     ; // Decoded destination address
    wire [    `CSR_BASE_WIDTH-1:0]    decode_csr_addr    ; // Decode Forward Address
    wire [              `XLEN-1:0]    decode_uimm        ; // Decoded UImm data for CSR Instruction

//-----------------------------------Operand Fetch---------------------------------//
    wire [              `XLEN-1:0]    operand_pc         ; // Operand Fetch PC
    wire [      `OPCODE_WIDTH-1:0]    operand_opcode     ; // Operand Fetch Opcode
    wire [    `SYS_REGS_WIDTH-1:0]    operand_rs1_addr   ; // Operand Fetch rs1_addr
    wire [    `SYS_REGS_WIDTH-1:0]    operand_rs2_addr   ; // Operand Fetch rs2_addr
    wire [    `SYS_REGS_WIDTH-1:0]    operand_rd_addr    ; // Operand Fetch destination address
    wire [        `FUNCT3_LEN-1:0]    operand_funct3     ; // Operand Fetch Function 3
    wire [        `FUNCT7_LEN-1:0]    operand_funct7     ; // Operand Fetch Function 7
    wire [              `XLEN-1:0]    operand_rs1_data   ; // Operand Fetch Operand 1
    wire [              `XLEN-1:0]    operand_rs2_data   ; // Operand Fetch Operand 2
    wire [              `XLEN-1:0]    operand_imm_i_data ; // Operand Fetch Immediate I type
    wire [              `XLEN-1:0]    operand_imm_s_data ; // Operand Fetch Immediate S type
    wire [              `XLEN-1:0]    operand_imm_b_data ; // Operand Fetch Immediate B type
    wire [              `XLEN-1:0]    operand_imm_u_data ; // Operand Fetch Immediate U type
    wire [              `XLEN-1:0]    operand_imm_j_data ; // Operand Fetch Immediate J type
    wire [              `XLEN-1:0]    operand_csr_data   ; // Operand Fetch CRS data
    wire [    `CSR_BASE_WIDTH-1:0]    operand_csr_addr   ; // Operand Fetch Forward Address
    wire [              `XLEN-1:0]    operand_uimm       ; // Operand Fetch UImm data for CSR Instruction

//-----------------------------------Execute---------------------------------//
    wire [              `XLEN-1:0]    exec_rd_data       ; // Execute Data Out
    wire [    `SYS_REGS_WIDTH-1:0]    exec_rd_addr       ; // Decoded destination address
    wire [              `XLEN-1:0]    exec_branch_addr   ; // Execute Branch Address
    wire [              `XLEN-1:0]    exec_csr_data      ; // Execute CSR Data Out
    wire [    `CSR_BASE_WIDTH-1:0]    exec_csr_addr      ; // Execute CSR Write Address
    wire [        `FUNCT3_LEN-1:0]    exec_funct3        ; // Execute Function 3
    wire [        `FUNCT7_LEN-1:0]    exec_funct7        ; // Execute Function 7
    wire [      `OPCODE_WIDTH-1:0]    exec_opcode        ; // Execute Opcode
    wire [              `XLEN-1:0]    exec_mem_data      ; // Execute memory data
    wire [              `XLEN-1:0]    exec_mem_addr      ; // Execute memory address
    wire [              `XLEN-1:0]    exec_uimm          ; // Execute UImm data for CSR Instruction
    // Control Signals
    wire                              exec_branch_en     ; // Execute branch en
//   wire                         exec_csr_write_en; // Execute CSR Write En
//   wire                         exec_mem_write_en; // Execute Mem Write En
//   wire                         exec_mem_read_en;     // Execute Mem Read En
//   wire                         exec_reg_write_en;    // Execute Reg Write En
//-----------------------------------MEM->WB---------------------------------//
    wire [        `FUNCT3_LEN-1:0]    mem_funct3         ; // Memory Function 3
//   wire [`FUNCT7_LEN-1:0]      mem_funct7;               // Memory Function 7
    wire [      `OPCODE_WIDTH-1:0]    mem_opcode         ; // Memory Opcode
    wire [              `XLEN-1:0]    mem_csr_data       ; // Memory CSR data out
    wire [    `CSR_BASE_WIDTH-1:0]    mem_csr_addr       ; // Memory CSR address
    wire [              `XLEN-1:0]    mem_rd_data        ; // Memory Data
    wire [    `SYS_REGS_WIDTH-1:0]    mem_rd_addr        ; // Decoded destination address
    wire [    `CSR_UIMM_WIDTH-1:0]    mem_uimm           ; // Memory UImm data for CSR Instruction
    // Control Signals
    wire                              mem_write_en;       // Memory Write Enable
    wire                              mem_read_en;
//-----------------------------------System Reg-----------------------------//
//    wire [`XLEN-1:0]            reg_data_in;          // Register Data In
//    wire [`XLEN-1:0]            reg_data_out;     // Register Data Out
//    wire [`SYS_REGS_WIDTH-1:0]  reg_rd_addr;          // rd Address
//    // Control Signals
//    wire                        reg_read_en;          // Register read enable
//    wire                        reg_write_en;     // Register write enable
//-----------------------------------CSR-------------------------------------//
//    wire [`XLEN-1:0]            csr_write_data;       // CSR Write Data
//    wire [`CSR_BASE_WIDTH-1:0]  csr_write_addr;       // CSR Write Address
//    wire [`CSR_BASE_WIDTH-1:0]  csr_read_addr;        // CSR Read Address
//
//    // Control Signals
//    wire                        csr_read_en;          // CSR Read Enable
//    wire                        csr_write_en;     // CSR Write Enable

//----------------------- Interrupt Signals ---------------------------------//
    wire intr_en;
//----------------------- Halt Signals --------------------------------------//
    wire halt_fetch   ; // Halt fetch state
    wire halt_decode  ; // Halt decode state
    wire halt_operand ; // Halt operand state
    wire halt_exec    ; // Halt execute state
    wire halt_mem     ; // Halt memory state
    wire halt_reg     ; // Halt register state
//---------------------------------------------------------------------------//
// Instruction Fetch                                                         //
//---------------------------------------------------------------------------//
    assign fetch_instr     = instr        ; // Instruction fetched
    assign fetch_rs1_addr  = instr[19:15] ; // Address Of Operand 1
    assign fetch_rs2_addr  = instr[24:20] ; // Address Of Operand 2
    assign fetch_rd_addr   = instr[11:7]  ; // Address Of Destination addr
    assign fetch_csr_addr  = instr[31:20] ; // Address of CSR register

    instr_fetch instr_fetch_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_fetch                   ),
        .branch_en         (exec_branch_en               ),
        .branch_taken      (fetch_branch_taken           ),
        .branch_addr       (exec_branch_addr             ),
        .instr_read_en     (instr_rd_en                  ),
        .pc                (pc                           )
    );
//---------------------------------------------------------------------------//
// Instruction Decode                                                        //
//---------------------------------------------------------------------------//
    instr_decode instr_decode_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_decode                  ),
        .pc_in             (pc                           ),
        .instr             (fetch_instr                  ),
        .rd_addr_in        (fetch_rd_addr                ),
        .csr_addr_in       (fetch_csr_addr               ),
        .opcode            (decode_opcode                ),
        .funct3            (decode_funct3                ),
        .funct7            (decode_funct7                ),
        .imm_i_data        (decode_imm_i_data            ),
        .imm_s_data        (decode_imm_s_data            ),
        .imm_b_data        (decode_imm_b_data            ),
        .imm_u_data        (decode_imm_u_data            ),
        .imm_j_data        (decode_imm_j_data            ),
        .rs1_addr_out      (decode_rs1_addr              ),
        .rs2_addr_out      (decode_rs2_addr              ),
        .rd_addr_out       (decode_rd_addr               ),
        .pc_out            (decode_pc                    ),
        .uimm_out          (decode_uimm                  ),
        .csr_addr_out      (decode_csr_addr              )
    );

//---------------------------------------------------------------------------//
// Operand Fetch                                                              //
//---------------------------------------------------------------------------//
    operand_fetch operand_fetch_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_operand                 ),
        .rs1_data_in       (fetch_rs1_data               ),
        .rs2_data_in       (fetch_rs2_data               ),
        .csr_data_in       (fetch_csr_data               ),
        .pc_in             (decode_pc                    ),
        .rd_addr_in        (decode_rd_addr               ),
        .rs1_addr_in       (decode_rs1_addr              ),
        .rs2_addr_in       (decode_rs2_addr              ),
        .csr_addr_in       (decode_csr_addr              ),
        .opcode_in         (decode_opcode                ),
        .funct3_in         (decode_funct3                ),
        .funct7_in         (decode_funct7                ),
        .imm_i_data_in     (decode_imm_i_data            ),
        .imm_s_data_in     (decode_imm_s_data            ),
        .imm_b_data_in     (decode_imm_b_data            ),
        .imm_u_data_in     (decode_imm_u_data            ),
        .imm_j_data_in     (decode_imm_j_data            ),
        .uimm_in           (decode_uimm                  ),
        .opcode_out        (operand_opcode               ),
        .funct3_out        (operand_funct3               ),
        .funct7_out        (operand_funct7               ),
        .rs1_data_out      (operand_rs1_data             ),
        .rs2_data_out      (operand_rs2_data             ),
        .rs1_addr_out      (operand_rs1_addr             ),
        .rs2_addr_out      (operand_rs2_addr             ),
        .rd_addr_out       (operand_rd_addr              ),
        .imm_i_data_out    (operand_imm_i_data           ),
        .imm_s_data_out    (operand_imm_s_data           ),
        .imm_b_data_out    (operand_imm_b_data           ),
        .imm_u_data_out    (operand_imm_u_data           ),
        .imm_j_data_out    (operand_imm_j_data           ),
        .pc_out            (operand_pc                   ),
        .uimm_out          (operand_uimm                 ),
        .csr_addr_out      (operand_csr_addr             ),
        .csr_data_out      (operand_csr_data             ),
        .bypass_rd_data    (exec_rd_data                 ), // Bypass data
        .bypass_rd_addr    (exec_rd_addr                 )  // Bypass address
);

//---------------------------------------------------------------------------//
// Instruction Execute                                                       //
//---------------------------------------------------------------------------//
    instr_exec instr_exec_inst (
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_exec                    ),
        .pc_in             (operand_pc                   ),
        .rs1_addr          (operand_rs1_addr             ),
        .rs2_addr          (operand_rs2_addr             ),
        .opcode_in         (operand_opcode               ),
        .funct3_in         (operand_funct3               ),
        .funct7_in         (operand_funct7               ),
        .imm_i_data        (operand_imm_i_data           ),
        .imm_s_data        (operand_imm_s_data           ),
        .imm_b_data        (operand_imm_b_data           ),
        .imm_u_data        (operand_imm_u_data           ),
        .imm_j_data        (operand_imm_j_data           ),
        .csr_addr_in       (operand_csr_addr             ),
        .csr_data_in       (operand_csr_data             ),
        .rd_addr_in        (operand_rd_addr              ),
        .uimm_in           (operand_uimm                 ),
        .rs1_data_in       (operand_rs1_data             ),
        .rs2_data_in       (operand_rs2_data             ),
        .rd_data_out       (exec_rd_data                 ),
        .rd_addr_out       (exec_rd_addr                 ),
        .branch_addr       (exec_branch_addr             ),
        .funct3_out        (exec_funct3                  ),
        .funct7_out        (exec_funct7                  ),
        .opcode_out        (exec_opcode                  ),
        .csr_data_out      (exec_csr_data                ),
        .csr_addr_out      (exec_csr_addr                ),
        .mem_addr_out      (exec_mem_addr                ),
        .mem_data_out      (exec_mem_data                ),
        .uimm_out          (exec_uimm                    ),
        .branch_en         (exec_branch_en               )
    );
//---------------------------------------------------------------------------//
// Memory Access                                                             //
//---------------------------------------------------------------------------//

     assign mem_addr       = exec_mem_addr;
     assign mem_write_data = exec_mem_data;
     assign mem_data_rd_en = mem_read_en;
     assign mem_data_wr_en = mem_write_en;

    mem_access_cntrl mem_access_cntrl_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_mem                     ),
        .opcode_in         (exec_opcode                  ),
        .funct3_in         (exec_funct3                  ),
        .rd_data_in        (exec_rd_data                 ),
        .rd_addr_in        (exec_rd_addr                 ),
        .csr_data_in       (exec_csr_data                ),
        .csr_addr_in       (exec_csr_addr                ),
        .uimm_in           (exec_uimm                    ),
        .opcode_out        (mem_opcode                   ),
        .funct3_out        (mem_funct3                   ),
        .rd_data_out       (mem_rd_data                  ),
        .rd_addr_out       (mem_rd_addr                  ),
        .csr_data_out      (mem_csr_data                 ),
        .csr_addr_out      (mem_csr_addr                 ),
        .uimm_out          (mem_uimm                     ),
        .write_en          (mem_write_en                 ),
        .read_en           (mem_read_en                  )
    );
//---------------------------------------------------------------------------//
// Register Interface                                                        //
//---------------------------------------------------------------------------//
    reg_access_if reg_access_if_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .halt              (halt_reg                     ),
        .halt_fetch        (halt_fetch                   ),
        .funct3_in         (mem_funct3                   ),
        .opcode_in         (mem_opcode                   ),
        .rs1_addr          (fetch_rs1_addr               ),
        .rs2_addr          (fetch_rs2_addr               ),
        .rd_addr           (mem_rd_addr                  ),
        .write_data        (mem_rd_data                  ),
        .rs1_data          (fetch_rs1_data               ),
        .rs2_data          (fetch_rs2_data               ),
        .uimm              (mem_uimm                     ),
        .csr_write_addr    (mem_csr_addr                 ),
        .csr_write_data    (mem_csr_data                 ),
        .csr_read_addr     (fetch_csr_addr               ),
        .csr_read_data     (fetch_csr_data               )
    );

//---------------------------------------------------------------------------//
// Halt Controller                                                           //
//---------------------------------------------------------------------------//
    halt_cntrl halt_cntrl_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .branch_en         (exec_branch_en               ),
   //  .fetch_instr          (fetch_instr                    ),
   //  .decode_instr         (decode_opcode                  ),
   //  .execute_instr        (execute_instr                  ),
   //   .mem_opcode           (mem_opcode                     ),
   //  .taken_branch         (fetch_branch_taken             ),
        .halt_fetch        (halt_fetch                   ),
        .halt_decode       (halt_decode                  ),
        .halt_operand      (halt_operand                 ),
        .halt_exec         (halt_exec                    ),
        .halt_mem          (halt_mem                     ),
        .halt_reg          (halt_reg                     )
    );

//---------------------------------------------------------------------------//
// Interrupt Controller                                                      //
//---------------------------------------------------------------------------//
    intr_cntrl intr_cntrl_inst(
        .clk               (clk                          ),
        .rst_n             (rst_n                        ),
        .intr_en           (intr_en                      )
    );

endmodule


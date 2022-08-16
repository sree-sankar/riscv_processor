`timescale 1ns / 1ps
`include "define.v"


module risc_core(input clk, 
                 input rst);
    
//-----------------------------------IF->ID------------------------------------//
    wire [`XLEN-1:0] pc;            // Program Counter
    wire [`XLEN-1:0] npc;           // Next PC
    wire [`XLEN-1:0] if_id_instr;      // Fetched Intruction
    // Control Signals

//-----------------------------------ID->EX------------------------------------//
    wire [`XLEN-1:0] id_ex_pc;         // Instruction to Decode Unit
    
    wire [`XLEN-1:0] ID_EX_Instr;
    wire [`XLEN-1:0] id_ex_rs1;
    wire [`XLEN-1:0] id_ex_rs2;
    wire [`XLEN-1:0] ID_EX_I_Type;
    wire [`XLEN-1:0] ID_EX_S_Type;
    wire [`XLEN-1:0] ID_EX_B_Type;
    wire [`XLEN-1:0] ID_EX_U_Type;
    wire [`XLEN-1:0] ID_EX_J_Type;
    // Control Signals

//-----------------------------------EX->MEM------------------------------------//
    wire [`XLEN-1:0] EX_MEM_Instr;
    wire [`XLEN-1:0] EX_MEM_Out;
    wire [`XLEN-1:0] EX_MEM_rs2;
    wire [`XLEN-1:0] EX_pc_Branch_Addr;
    // Control Signals

//-----------------------------------MEM->WB------------------------------------//

    wire [`XLEN-1:0] MEM_WB_Instr;
    wire [`XLEN-1:0] MEM_WB_Out;
    wire [`XLEN-1:0] MEM_Addr;
    wire [`XLEN-1:0] MEM_Data;
    wire [`XLEN-1:0] MEM_Data_Out;

    wire [`XLEN-1:0] ID_EX_csr;
    wire [`XLEN-1:0] EX_CSR_Out;
    // Control Signals

//-----------------------------------CSR------------------------------------//
    wire[`CSR_BASE_WIDTH-1:0] csr_wr_addr;
    wire[`CSR_BASE_WIDTH-1:0] csr_rd_addr;
    // Control Signals
//------------------------------------------------ Control Signals ---------------------------------------------------//
    wire BRANCH_EN,TAKEN_BRANCH;
    wire CSR_OR,CSR_AND;
    wire MEM_WRITE_EN,REG_WRITE_EN,MEM_READ_EN,REG_READ_EN;
    wire I_CACHE_RD_EN,I_CACHE_WR_EN,CSR_WR_En,CSR_RD_En;
    wire D_CACHE_RD_EN,D_CACHE_WR_EN;
    wire [4:0] HALT;
//------------------------------------------------ Interrupt Signals ---------------------------------------------------//
    wire M_INTR_EN;
    wire M_SOFT_INTR;
    wire M_TMR_INTR;
    wire M_EXTERN_INTR;
    wire[`XLEN-1:0] M_CAUSE;
//------------------------------------------------Registers ---------------------------------------------------//
    reg [`XLEN-1:0] reg_bank[0:`XLEN-1];
//----------------------------------------------------- IF-->ID ------------------------------------------------------//
pc S0(.i_clk(i_clk),
      .i_rst(i_rst),
      .i_halt(HALT[0]),
      .i_branch_en(BRANCH_EN),
      .i_branch_addr(EX_pc_Branch_Addr),
      .o_pc(pc),
      .o_npc(npc),
      .o_mem_rd_en(MEM_READ_EN),
      .o_reg_rd_en(REG_READ_EN),
      .o_icache_rd_en(I_CACHE_RD_EN),
      .o_taken_branch(TAKEN_BRANCH));
//----------------------------------------------------- IF-->ID ------------------------------------------------------//


//----------------------------------------------------- ID-->EX ------------------------------------------------------//
operand_fetch S1(.i_pc(pc),
                 .i_clk(i_clk),
                 .i_halt(HALT[1]),
                 .i_instr(if_id_instr),
                 .o_pc(id_ex_pc),
                 .o_instr(ID_EX_Instr),
                 .o_imm_i_type(ID_EX_I_Type),
                 .o_imm_s_type(ID_EX_S_Type),
                 .o_imm_b_type(ID_EX_B_Type),
                 .o_imm_u_type(ID_EX_U_Type),
                 .o_imm_j_type(ID_EX_J_Type));    
//----------------------------------------------------- EX-->MEM ------------------------------------------------------//
instr_execute S2(.i_clk(i_clk),
                 .i_rst(i_rst),
                 .i_pc(id_ex_pc),
                 .i_halt(HALT[2]),
                 .i_rs1(id_ex_rs1),
                 .i_rs2(id_ex_rs2),
                 .i_csr_data(ID_EX_csr),
                 .i_instr(ID_EX_Instr),
                 .i_imm_i_type(ID_EX_I_Type),
                 .i_imm_s_type(ID_EX_S_Type),
                 .i_imm_b_type(ID_EX_B_Type),
                 .i_imm_u_type(ID_EX_U_Type),
                 .i_imm_j_type(ID_EX_J_Type),
                 .i_taken_branch(TAKEN_BRANCH),
                 .o_csr_or(CSR_OR),
                 .o_csr_and(CSR_AND),
                 .o_alu(EX_MEM_Out),
                 .o_rs2(EX_MEM_rs2),
                 .o_csr_wr_en(CSR_WR_En),
                 .o_mem_data(MEM_Data),
                 .o_instr(EX_MEM_Instr),
                 .o_csr_data(EX_CSR_Out),
                 .o_branch_en(BRANCH_EN),
                 .o_csr_wr_addr(csr_wr_addr),
                 .o_branch_addr(EX_pc_Branch_Addr));
//----------------------------------------------------- MEM-->WB ------------------------------------------------------//
mem_access S3(.i_pc(pc),
              .i_clk(i_clk),
              .i_halt(HALT[3]),
              .i_alu(EX_MEM_Out),
              .i_rs2(EX_MEM_rs2),
              .i_instr(EX_MEM_Instr),
              .i_mem_data(MEM_Data_Out),
              .i_taken_branch(TAKEN_BRANCH),
              .o_mem_addr(MEM_Addr),
              .o_instr(MEM_WB_Instr),
              .o_mem_data(MEM_WB_Out),
              .o_mem_wr_en(MEM_WRITE_EN));
//----------------------------------------------------- WB reg ---------------------------------------------------------//
write_back S4(.i_clk(i_clk),
              .i_rst(i_rst),
              .i_halt(HALT[4]),
              .i_taken_branch(TAKEN_BRANCH),
              .i_instr(MEM_WB_Instr),
              .i_alu(MEM_WB_Out),
              .o_reg_wr_en(REG_WRITE_EN));
//-------------------------------------------------- Register Memory -----------------------------------------------------//
reg_memory Reg_Read_Write(.i_clk(i_clk),
                   .read_en(REG_READ_EN),
                   .write_en(REG_WRITE_EN),
                   .rs1_addr(ID_EX_Instr[19:15]),
                   .rs2_addr(ID_EX_Instr[24:20]),
                   .rd_addr (MEM_WB_Instr[11:7]),
                   .data_in(MEM_WB_Out),
                   .bypass_res(EX_MEM_Out),
                   .bypass_rd(EX_MEM_Instr[11:7]),
                   .rs1(id_ex_rs1),.rs2(id_ex_rs2));
//---------------------------------------------------- Instruction ------------------------------------------------------//
main_memory Mem_Fetch_Access(.i_clk(i_clk),
                             .pc_in(pc),
                             .data_in(MEM_Data),
                             .read_en(MEM_READ_EN),
                             .write_en(MEM_WRITE_EN),
                             .addr_in(EX_MEM_Out),
                             .instruction_out(if_id_instr),
                             .data_out(MEM_Data_Out));
//-------------------------------------------------- CSR Register Memory -----------------------------------------------------//
csr_reg_bank CSR(.i_clk(i_clk),
                 .i_rst(i_rst),
                 .i_rd_en(1'b1),
                 .i_and(CSR_OR),
                 .i_or(CSR_AND),
                 .i_wr_en(CSR_WR_En),
                 .i_data(EX_CSR_Out),
                 .i_rd_addr(ID_EX_Instr[31:20]),
                 .i_wr_addr(csr_wr_addr),
                 .o_csr(ID_EX_csr));
//-------------------------------------------------- CSR Register Memory -----------------------------------------------------//
/*csr_reg CSR(.i_mintr_en(M_INTR_EN),
            .i_mtimer_intr(),
            .i_mextern_intr(),
            .i_msoftware_intr(),
            .i_mtimer_intr_en(),
            .i_mextern_intr_en(),
            .i_msoftware_intr_en(),
            .i_mscratch(),
            .i_mepc(),
            .i_mcause(M_CAUSE),
            .i_mpie
            .i_mpp(),

            .o_misa(),
            .o_mimpid(),
            .o_mhartid(),
            .o_mstatus(),
            .o_mtvec(),
            .o_medeleg(),
            .o_mideleg(),
            .o_mip(),
            .o_mie(),
            .o_mtime_msb,o_mtime_lsb(),
            .o_mtimecmp_msb,o_mtimecmp_lsb(),
            .o_mcycle(),
            .o_minstret(),
            .o_mhpmcounter(),
            .o_mhpmevent(),
            .o_mcounteren(),
            .o_mcountinhibit(),
            .o_mscratch(),
            .o_mepc());*/
//---------------------------------------------------- Halt Control -----------------------------------------------------//
halt_control HC(.i_clk(i_clk),
                .i_rst(i_rst), 
                .halt(HALT),
                .if_id_instr(if_id_instr),
                .id_ex_instr(ID_EX_Instr),
                .ex_mem_instr(EX_MEM_Instr),
                .mem_wb_instr(MEM_WB_Instr),
                .taken_branch(TAKEN_BRANCH));
//---------------------------------------------------- Interrupt Control -----------------------------------------------------//
intr_control INTR_CNTRL(.i_clk(i_clk),
                        .i_rst(i_rst),
                        .o_mintr_en(M_INTR_EN),
                        .o_mcause(M_CAUSE),
                        .o_mtimer_intr(M_TMR_INTR),
                        .o_mextern_intr(M_EXTERN_INTR),
                        .o_msoftware_intr(M_SOFT_INTR));
//---------------------------------------------------- Instruction Cache------------------------------------------------------//
//instr_cache Instr_Cache(.i_pc(pc),
//                        .i_clk(i_clk),
//                        .i_addr(EX_MEM_Out),
//                        .i_instr(MEM_Data),
//                        .i_r_en(MEM_READ_EN),
//                        .i_w_en(MEM_WRITE_EN),
//                        .o_instruction(if_id_instr));
////---------------------------------------------------- Data Cache------------------------------------------------------//
//data_cache Data_Cache(.i_pc(pc),
//                      .i_clk(i_clk),
//                      .i_addr(EX_MEM_Out),
//                      .i_instr(32'b0),  //from cache controller
//                      .i_r_en(MEM_READ_EN),
//                      .i_w_en(MEM_WRITE_EN),
//                      .o_data(MEM_Data_Out));*/
endmodule


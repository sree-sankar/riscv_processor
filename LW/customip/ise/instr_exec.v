`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          : 05.12.2021 12:48:12
// Design Name          :
// Module Name          : instr_exec
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
module instr_exec(
    input                                      clk          , // System Clock
    input                                      rst_n        , // Synchronous Reset negative
    input         [              `XLEN-1:0]    pc_in        , // PC value
    input         [    `SYS_REGS_WIDTH-1:0]    rs1_addr     , // rs1 address for bypass
    input         [    `SYS_REGS_WIDTH-1:0]    rs2_addr     , // rs1 address for bypass
    input         [      `OPCODE_WIDTH-1:0]    opcode_in    , // Opcode
    input         [        `FUNCT3_LEN-1:0]    funct3_in    , // Function 3
    input         [        `FUNCT7_LEN-1:0]    funct7_in    , // Function 7
    input         [    `SYS_REGS_WIDTH-1:0]    rd_addr_in   , // Address of destionation register
    input         [              `XLEN-1:0]    imm_i_data   , // I type immediate data
    input         [              `XLEN-1:0]    imm_s_data   , // S type immediate data
    input         [              `XLEN-1:0]    imm_b_data   , // B type immediate data
    input         [              `XLEN-1:0]    imm_u_data   , // U type immediate data
    input         [              `XLEN-1:0]    imm_j_data   , // J type immediate data
    input         [    `CSR_BASE_WIDTH-1:0]    csr_addr_in  , // CSR address
    input         [              `XLEN-1:0]    csr_data_in  , // CSR Data In
    input         [              `XLEN-1:0]    uimm_in      , // UIMM data of CSR
    input  signed [              `XLEN-1:0]    rs1_data_in  , // Operand 1 In
    input  signed [              `XLEN-1:0]    rs2_data_in  , // Operand 2 In
    output signed [              `XLEN-1:0]    rd_data_out  , // Data to be written to rd
    output        [    `SYS_REGS_WIDTH-1:0]    rd_addr_out  , // Destination address out
    output        [              `XLEN-1:0]    branch_addr  , // Branch address
    output        [    `CSR_BASE_WIDTH-1:0]    csr_addr_out , // CSR Write Address
    output        [              `XLEN-1:0]    csr_data_out , // CSR Write Data Out
    output        [        `FUNCT3_LEN-1:0]    funct3_out   , // Function 3
    output        [        `FUNCT7_LEN-1:0]    funct7_out   , // Function 7
    output        [      `OPCODE_WIDTH-1:0]    opcode_out   , // Opcode Code
    output        [              `XLEN-1:0]    mem_addr_out , // Address of memory to be read
    output        [              `XLEN-1:0]    mem_data_out , // Address of memory to be read
    output        [              `XLEN-1:0]    uimm_out     , // UImm Output
    // Control Signals
   input                                       halt         , // Halt control
   output                                      branch_en      // Branch enable

) ;

    // Register
    reg  [      `OPCODE_WIDTH-1:0]    opcode_reg       ; // Opcode register
    reg  [        `FUNCT3_LEN-1:0]    funct3_reg       ; // Function 3 register
    reg  [        `FUNCT7_LEN-1:0]    funct7_reg       ; // Function 7 register
    reg  [              `XLEN-1:0]    rd_data_reg      ; // Execute Data register
    reg  [              `XLEN-1:0]    branch_addr_reg  ; // Branch Address register
    reg  [    `CSR_BASE_WIDTH-1:0]    csr_addr_reg     ; // CSR address register
    reg  [              `XLEN-1:0]    csr_data_out_reg ; // CSR Data register
    reg  [              `XLEN-1:0]    mem_addr_reg     ; // Memory address register
    reg  [              `XLEN-1:0]    mem_data_reg     ; // Memory Data register
    reg  [    `SYS_REGS_WIDTH-1:0]    rd_addr_reg      ; // Destination address register
    reg  [              `XLEN-1:0]    uimm_reg         ;
    reg  [              `XLEN-1:0]    pc_reg           ;

    wire [              `XLEN-1:0]    rs1_data         ; // rs1 data input for processing including bypass
    wire [              `XLEN-1:0]    rs2_data         ; // rs2 data in
     // Control Signal
    reg                               branch_en_reg    ; // Branch enable register

    assign funct3_out    = funct3_reg;
    assign funct7_out    = funct7_reg;
    assign opcode_out    = opcode_reg;
    assign rd_data_out   = rd_data_reg;
    assign branch_addr   = branch_addr_reg;
    assign mem_addr_out  = mem_addr_reg;
    assign mem_data_out  = mem_data_reg;
    assign csr_addr_out  = csr_addr_reg;
    assign csr_data_out  = csr_data_out_reg;
    assign branch_en     = branch_en_reg;
    assign rd_addr_out   = rd_addr_reg;
    assign uimm_out      = uimm_reg;

     assign rs1_data = (bypass_rs1_stage0) ? bypass_data_stage0 :
                       (bypass_rs1_stage1) ? bypass_data_stage1 : rs1_data_in;
     assign rs2_data = (bypass_rs2_stage0) ? bypass_data_stage0 :
                       (bypass_rs2_stage1) ? bypass_data_stage1 : rs2_data_in;

     // Pipeline data Forwarding
    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            opcode_reg   <= `OPCODE_WIDTH'h0;
            funct3_reg   <= `FUNCT3_LEN'h0;
            funct7_reg   <= `FUNCT7_LEN'h0;
            rd_addr_reg  <= 32'h0000_0000;
            csr_addr_reg <= 32'h0000_0000;
            uimm_reg     <= `CSR_UIMM_WIDTH'h0;
            pc_reg       <= `XLEN'h0;
            end
        else
            begin
            opcode_reg   <= opcode_in;
            funct3_reg   <= funct3_in;
            funct7_reg   <= funct7_in;
            rd_addr_reg  <= rd_addr_in;
            csr_addr_reg <= csr_addr_in;
            uimm_reg     <= uimm_in;
            pc_reg       <= pc_in;
            end
        end


    // Execution
    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            rd_data_reg      <= `XLEN'h0000_0000;
            branch_addr_reg  <= `XLEN'h0000_0000;
            mem_data_reg     <= `XLEN'h0000_0000;
            mem_addr_reg     <= `XLEN'h0000_0000;
            csr_data_out_reg <= `XLEN'h0000_0000;
                end
        else
            begin
            if(!halt)
                begin
                case(opcode_in)
                //-----------------------------------------OP----------------------------------------//
                `OP :
                    begin
                    branch_addr_reg  <= 32'h0000_0000;
                    mem_addr_reg     <= 32'h0000_0000;
                    mem_data_reg     <= 32'h0000_0000;
                    csr_data_out_reg <= 32'b0000_0000;
                    case(funct3_in)
                    `FN3_ADD_SUB  : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data + rs2_data) :                       // Addition
                                                    (funct7_in == `FN7_F2) ? (rs1_data - rs2_data) : 32'h0000_0000;        // Substraction
                    `FN3_SLL      : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data << rs2_data[4:0]) : 32'h0;          // Logical Left Shift
                    `FN3_SLT      : rd_data_reg  <= (funct7_in == `FN7_F1 && (rs1_data < rs2_data)) ? 32'h0000_0001 :      // Set Less Than
                                                     32'h0000_0000;
                    `FN3_SLTU     : rd_data_reg  <= (funct7_in == `FN7_F1 && $unsigned(rs1_data) < $unsigned(rs2_data)) ?  // Set less than unsigned
                                                     32'h0000_0001 : 32'h0000_0000;
                    `FN3_SRL_SRA  : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data >>  rs2_data[4:0]) :                 // Logical right shift
                                                    (funct7_in == `FN7_F2) ? (rs1_data >>> rs2_data[4:0]) : 32'h0;         // Arithenetic right shift
                    `FN3_XOR      : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data ^ rs2_data) : 32'h0000_0000;        // Bitwise XOR
                    `FN3_OR       : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data | rs2_data) : 32'h0000_0000;        // Bitwise OR
                    `FN3_AND      : rd_data_reg  <= (funct7_in == `FN7_F1) ? (rs1_data & rs2_data) : 32'h0000_0000;        // Bitwise AND
                    default       :
                        begin
                        rd_data_reg       <= 32'h0000_0000;
                        branch_addr_reg   <= 32'h0000_0000;
                        mem_addr_reg      <= 32'h0000_0000;
                        mem_data_reg      <= 32'h0000_0000;
                        csr_data_out_reg  <= `XLEN'b0000_0000;
                        end
                    endcase
                    end
                //------------------------------------OP_IMM----------------------------------------//
                `OP_IMM :
                    begin
                    branch_addr_reg   <= 32'h0000_0000;
                    mem_addr_reg      <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    case(funct3_in)
                    `FN3_ADDI  : rd_data_reg  <= rs1_data + imm_i_data;                                          // Add Immediate Signed
                    `FN3_SLTI  : rd_data_reg  <= (rs1_data < imm_i_data) ? 32'h0000_0001 : 32'h0000_0000;        // Set less than
                    `FN3_SLTIU : rd_data_reg  <= ($unsigned(rs1_data) < $unsigned(imm_i_data)) ? 32'h0000_0001   // Set less than unsigned
                                                  : 32'h0000_0000;
                    `FN3_XORI  : rd_data_reg  <= rs1_data ^ imm_i_data;                                          // XOR Immediate Data
                    `FN3_ORI   : rd_data_reg  <= rs1_data | imm_i_data;                                          // OR  Immediate Data
                    `FN3_ANDI  : rd_data_reg  <= rs1_data & imm_i_data;                                          // AND Immediate Data
                    `FN3_SLLI  : rd_data_reg  <= (funct7_in == `FN7_F1) ? rs1_data <<  imm_i_data[4:0] : 32'b0;                                     // SLL Immediate Data
                    `FN3_SRLI  : rd_data_reg  <= (funct7_in == `FN7_F1) ? rs1_data >>  imm_i_data[4:0] : 32'b0;                                     // SRL Immediate Data
                    `FN3_SRAI  : rd_data_reg  <= (funct7_in == `FN7_F1) ? rs1_data >>> imm_i_data[4:0] : 32'b0;                                       // SRA Immediate Data
                    default :
                        begin
                        rd_data_reg       <= 32'h0000_0000;
                        branch_addr_reg   <= 32'h0000_0000;
                        mem_addr_reg      <= 32'h0000_0000;
                        mem_data_reg      <= 32'h0000_0000;
                        csr_data_out_reg  <= `XLEN'b0000_0000;
                        end
                    endcase
                    end
                //------------------------------------BRANCH----------------------------------------//
                `BRANCH :
                    begin
                    rd_data_reg      <= 32'h0000_0000;
                    mem_addr_reg     <= 32'h0000_0000;
                    mem_data_reg     <= 32'h0000_0000;
                    csr_data_out_reg <= `XLEN'b0000_0000;
                    case(funct3_in)
                    `FN3_BEQ  : branch_addr_reg  <= (rs1_data == rs2_data) ?  {pc_in + imm_b_data} : 32'h0;
                    `FN3_BNE  : branch_addr_reg  <= (rs1_data != rs2_data) ?  {pc_in + imm_b_data} : 32'h0;
                    `FN3_BLT  : branch_addr_reg  <= (rs1_data < rs2_data)  ?  {pc_in + imm_b_data} : 32'h0;
                    `FN3_BGE  : branch_addr_reg  <= (rs1_data > rs2_data)  ?  {pc_in + imm_b_data} : 32'h0;
                    `FN3_BLTU : branch_addr_reg  <= ($unsigned(rs1_data) < $unsigned(rs2_data)) ? {pc_in + imm_b_data} : 32'h0;
                    `FN3_BGEU : branch_addr_reg  <= ($unsigned(rs1_data) > $unsigned(rs2_data)) ? {pc_in + imm_b_data} : 32'h0;
                    default :
                        begin
                        rd_data_reg       <= 32'h0000_0000;
                        branch_addr_reg   <= 32'h0000_0000;
                        mem_addr_reg      <= 32'h0000_0000;
                        mem_data_reg      <= 32'h0000_0000;
                        csr_data_out_reg  <= `XLEN'b0000_0000;
                        end
                    endcase
                    end
                //---------------------------------------LUI-----------------------------------------//
                `LUI :
                    begin
                    rd_data_reg       <= imm_u_data;
                    branch_addr_reg   <= 32'h0000_0000;
                    mem_addr_reg      <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    end
                //--------------------------------------AUIPC---------------------------------------//
                `AUIPC :
                    begin
                    rd_data_reg       <= pc_reg + imm_u_data;
                    branch_addr_reg   <= 32'h0000_0000;
                    mem_addr_reg      <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    end
                //---------------------------------------JAL---------------------------------------//
                `JAL :
                    begin
                    rd_data_reg       <= pc_reg + `PC_INC;
                    branch_addr_reg   <= pc_reg + imm_j_data;
                    mem_addr_reg      <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    end
                //--------------------------------------JALR--------------------------------------//
                `JALR  :
                    begin
                    rd_data_reg       <= pc_reg + `PC_INC;
                    branch_addr_reg   <= (funct3_in == 3'b0) ? ((rs1_data + imm_i_data) & 32'hFFFF_FFFE) : 32'b0; // & 32'hFFFF_FFFE to make last bit 0
                    mem_addr_reg      <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    end
                //--------------------------------------LOAD-------------------------------------//
                `LOAD :
                    begin
                    // Load with rd as x0 should raise an exeception and to be handled
                    rd_data_reg       <= 32'h0000_0000;
                    branch_addr_reg   <= 32'h0000_0000;
                    mem_data_reg      <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'b0000_0000;
                    case(funct3_in)
                        `FN3_LB   : mem_addr_reg  <= rs1_data + imm_i_data;
                        `FN3_LH   : mem_addr_reg  <= rs1_data + imm_i_data;
                        `FN3_LW   : mem_addr_reg  <= rs1_data + imm_i_data;
                        `FN3_LBU  : mem_addr_reg  <= rs1_data + imm_i_data;
                        `FN3_LHU  : mem_addr_reg  <= rs1_data + imm_i_data;
                        default :
                            begin
                            rd_data_reg       <= 32'h0000_0000;
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            csr_data_out_reg  <= `XLEN'b0000_0000;
                            end
                    endcase
                    end
                //--------------------------------------STORE------------------------------------//
                `STORE :
                    begin
                    rd_data_reg       <= 32'h0000_0000;
                    branch_addr_reg   <= 32'h0000_0000;
                    csr_data_out_reg  <= `XLEN'h0000_0000;
                    mem_addr_reg      <= rs1_data + imm_s_data;
                    case(funct3_in)
                        `FN3_SB  : mem_data_reg  <= {24'b0,rs2_data[7:0]};
                        `FN3_SH  : mem_data_reg  <= {16'b0,rs2_data[15:0]};
                        `FN3_SW  : mem_data_reg  <= rs2_data;
                        `FN3_SBU : mem_data_reg  <= $unsigned({24'b0,rs2_data[7:0]});
                        `FN3_SHU : mem_data_reg  <= $unsigned({16'b0,rs2_data[15:0]});
                        default :
                            begin
                            rd_data_reg       <= 32'h0000_0000;
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            csr_data_out_reg  <= `XLEN'b0000_0000;
                            end
                    endcase
                    end
                //-------------------------------------SYSTEM------------------------------------//
                `SYSTEM :
                        begin
                        case(funct3_in)
                        // /*  `PRIV   : begin
                        //         case(i_instr[31:20]) begin


                        //             `MRET   : begin

                        //             end

                        //             `WFI    : begin
                        //             end

                        //             `ECALL  : begin

                        //             end
                        //             `EBREAK : begin

                        //             end
                        //         end
                        //     end
                        //     */
                        `CSRRW :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= rs1_data;
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                           end
                        `CSRRS :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= csr_data_in | rs1_data; // Set all bits that is high in rs1
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            end

                        `CSRRC :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= (csr_data_in & (~rs1_data)); // Clear all bits that is high in rs1
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            end

                        `CSRRWI :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= uimm_in;
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            end

                        `CSRRSI :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= (csr_data_in | uimm_in); // Clear all bits that is high in rs1
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                            end

                        `CSRRCI :
                            begin
                            rd_data_reg       <= csr_data_in;
                            csr_data_out_reg  <= (csr_data_in & (~uimm_in)); // Clear all bits that is high in rs1
                            branch_addr_reg   <= 32'h0000_0000;
                            mem_addr_reg      <= 32'h0000_0000;
                            mem_data_reg      <= 32'h0000_0000;
                             end
                        default :
                            begin
                            end
                         endcase
                        end

                default :
                    begin
                    rd_data_reg      <= 32'h0000_0000;
                    branch_addr_reg  <= 32'h0000_0000;
                    csr_data_out_reg <= 32'h0000_0000;
                    mem_addr_reg     <= 32'h0000_0000;
                    end
                endcase
                end
            else
                begin
                rd_data_reg      <= rd_data_reg;
                branch_addr_reg  <= branch_addr_reg;
                csr_data_out_reg <= csr_data_out_reg;
                mem_addr_reg     <= mem_addr_reg;
                end
            end
        end

//--------------------Control Unit-------------------------------//
    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            branch_en_reg <= 1'b0;
            end
        else
            begin
                if(!halt)
                    begin
                    case(opcode_in)
                        `BRANCH : branch_en_reg <= 1'b1;
                        `JAL    : branch_en_reg <= 1'b1;
                        `JALR   : branch_en_reg <= 1'b1;
                        default : branch_en_reg <= 1'b0;
                    endcase
                    end
                else
                    begin
                    branch_en_reg <= 1'b0;
                    end
                end
       end

// Bypass logic

    reg [          `XLEN-1:0]  rd_data_d0 ;
    reg [          `XLEN-1:0]  rd_data_d1 ;
    reg [`SYS_REGS_WIDTH-1:0]  rd_addr_d0 ;
    reg [`SYS_REGS_WIDTH-1:0]  rd_addr_d1 ;

    wire                      bypass_rs1_stage0  ; // Bypassing Reg Access after reg(Reg->Reg)
    wire                      bypass_rs2_stage0  ; // Bypassing Reg Access after reg
    wire [         `XLEN-1:0] bypass_data_stage0 ;
    wire                      bypass_rs1_stage1  ; // Bypassing Reg Access after reg(Reg->Reg->)
    wire                      bypass_rs2_stage1  ; // Bypassing Reg Access after reg

    assign bypass_data_stage0  = rd_data_out;
    assign bypass_data_stage1  = rd_data_d0;
    assign bypass_rs1_stage0   = (rd_addr_d0 == rs1_addr) ? 1'b1 : 1'b0;
    assign bypass_rs2_stage0   = (rd_addr_d0 == rs2_addr) ? 1'b1 : 1'b0;
    assign bypass_rs1_stage1   = 1'b0;//(rd_addr_d1 == rs1_addr) ? 1'b1 : 1'b0;
    assign bypass_rs2_stage1   = 1'b0;//(rd_addr_d1 == rs2_addr) ? 1'b1 : 1'b0;

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            rd_data_d0 <= `XLEN'h0;
            rd_data_d1 <= `XLEN'h0;
            rd_addr_d0 <= `SYS_REGS_WIDTH'h0;
            rd_addr_d1 <= `SYS_REGS_WIDTH'h0;
            end
        else
            begin
            rd_data_d0 <= rd_data_out;
            rd_addr_d0 <= rd_addr_in;
            rd_addr_d1 <= rd_addr_d0;
            end
        end

endmodule

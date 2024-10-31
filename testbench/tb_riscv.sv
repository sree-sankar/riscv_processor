`timescale 10ns / 1ps
//----------------------+-------------------------------------------------------
// Filename             | uart_ctrl.sv
// File created on      | 06/19/2022 18:26:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// System Register
//------------------------------------------------------------------------------

`include "../src/risc-v/riscv.vh"
`include "../src/risc-v/sys_regs.vh"
`include "../src/memory_map.vh"


module tb_riscv();

    logic                clk_i           ; // System Clock
    logic                resetn_i        ; // Synchronous Active Low System Reset
    logic [`XLEN-1:0]    instr_addr_o    ; // Program Counter
    logic [`XLEN-1:0]    instr_i         ; // Fetched Instrcution
    logic [`XLEN-1:0]    mem_addr_o      ; // Memory Address
    logic                mem_read_en_o   ; // Memory Read Enable
    logic [`XLEN-1:0]    mem_read_data_i ; // Memory Read Data
    logic                mem_write_en_o  ; // Memory Write Enable
    logic [`XLEN-1:0]    mem_write_data_o; // Memory Write Data

//------------------------------------------------------------------------------
// DUT
//------------------------------------------------------------------------------

    riscv dut(.*);

//------------------------------------------------------------------------------
// DUT
//------------------------------------------------------------------------------

    // Clock
    always #5 clk_i = ~clk_i;

    initial
        begin
        clk_i    <= 'h1;
        resetn_i <= 'h0;
        instr_i  <= 'h0;
        // Reset Release
        #10 resetn_i <= 1'b1;

        // OP Instruction Verification
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_ADD_SUB,`X1,`OP}; // ADD
        // #10 instr_i <= {`FN7_F1,`X3,`X2,`FN3_ADD_SUB,`X1,`OP}; // SUB
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_SLL,`X1,`OP    }; // SLL
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_SLT,`X1,`OP    }; // SLT
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_SLTU,`X1,`OP   }; // SLTU
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_XOR,`X1,`OP    }; // XOR
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_SRL_SRA,`X1,`OP}; // SRL
        // #10 instr_i <= {`FN7_F1,`X3,`X2,`FN3_SRL_SRA,`X1,`OP}; // SRA
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_OR,`X1,`OP     }; // OR
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_AND,`X1,`OP    }; // AND

        // OP Immediate Verification
        // #10 instr_i <= {12'h040,`X2,`FN3_ADDI,`X1,`OP_IMM   }; // ADDI
        // #10 instr_i <= {12'h2,`X2,`FN3_SLLI,`X1,`OP_IMM     }; // SLLI
        // #10 instr_i <= {12'h3,`X2,`FN3_SLTI,`X1,`OP_IMM     }; // SLTI
        // #10 instr_i <= {12'h4,`X2,`FN3_SLTIU,`X1,`OP_IMM    }; // SLTIU
        // #10 instr_i <= {12'h777,`X2,`FN3_XORI,`X1,`OP_IMM   }; // XORI
        // #10 instr_i <= {`FN7_F0,5'h6,`X2,`FN3_SRLI_SRAI,`X1,`OP_IMM}; // SRLI
        // #10 instr_i <= {`FN7_F1,5'h7,`X2,`FN3_SRLI_SRAI,`X1,`OP_IMM}; // SRAI
        // #10 instr_i <= {12'h8,`X2,`FN3_ORI,`X1,`OP_IMM      }; // ORI
        // #10 instr_i <= {12'h9,`X2,`FN3_ANDI,`X1,`OP_IMM     }; // ANDI

        // Branch Verification
        // #10 instr_i <= {'h0,`X3,`X2,`FN3_BEQ,4'h9,1'b0,`BRANCH   }; //  Branch if Equal
        // #10 instr_i <= {7'h7F,`X3,`X2,`FN3_BNE,4'hF,1'b1,`BRANCH }; //  Branch if Not Equal
        // #10 instr_i <= {7'h7F,`X3,`X2,`FN3_BLT,4'hF,1'b1,`BRANCH }; //  Branch if Not Equal
        // #10 instr_i <= {7'h7F,`X3,`X2,`FN3_BGE,4'hF,1'b1,`BRANCH }; //  Branch if greater than
        // #10 instr_i <= {7'h7F,`X3,`X2,`FN3_BLTU,4'hF,1'b1,`BRANCH}; // Branch if less than unsigned
        // #10 instr_i <= {'h0,`X3,`X2,`FN3_BGEU,4'h9,1'b0,`BRANCH  }; // Branch if greater than unsigned

        // LUI and AUIPC
        // #10 instr_i <= {20'h8,`X1,`LUI}; // Load Upper Immediate
        // #10 instr_i <= {20'h8,`X1,`AUIPC}; // ADD Load Upper Immediate

        // JAL and JALR
        // #10 instr_i <= {20'h200,`X1,`JAL}; // Jump and Link
        // #10 instr_i <= {12'h2,`X2,3'h0,`X1,`JALR}; // Jump and link register

        // Load
        // #10 instr_i <= {12'hFFE,`X2,`FN3_LB,`X1,`LOAD};
        // #10 instr_i <= {12'hFFE,`X2,`FN3_LH,`X1,`LOAD};
        // #10 instr_i <= {12'hFFE,`X2,`FN3_LW,`X1,`LOAD};
        // #10 instr_i <= {12'hFFE,`X2,`FN3_LBU,`X1,`LOAD};
        // #10 instr_i <= {12'hFFE,`X2,`FN3_LHU,`X1,`LOAD};

        // // Store
        // #10 instr_i <= {7'h1,`X3,`X2,`FN3_SB,5'h0,`STORE};
        // #10 instr_i <= {7'h1,`X3,`X2,`FN3_SH,5'h0,`STORE};
        // #10 instr_i <= {7'h1,`X3,`X2,`FN3_SW,5'h0,`STORE};

        // Data Forwarding
        // #10 instr_i <= {`FN7_F0,`X3,`X2,`FN3_ADD_SUB,`X1,`OP}; // ADD
        // #10 instr_i <= 'h0;
        // #10 instr_i <= {`FN7_F0,`X1,`X0,`FN3_ADD_SUB,`X4,`OP}; // ADD

        // Memory Forwarding
        // #10 instr_i <= {7'h0,`X3,`X2,`FN3_SW,5'h0,`STORE};
        // #10 instr_i <= {12'h0,`X2,`FN3_LHU,`X5,`LOAD};

        // Hello World! Assembly ASCII

        // Generate Address
        #10 instr_i <= {12'h00A,`X0,`FN3_ADDI,`X1,`OP_IMM};
        #10 instr_i <= {12'h01C,`X1,`FN3_SLLI,`X2,`OP_IMM};
        #10 instr_i <= {12'h004,`X2,`FN3_ADDI,`X2,`OP_IMM};

        // TX Data to UART Controller
        #10 instr_i <= {12'h048,`X0,`FN3_ADDI,`X1,`OP_IMM}; // H
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // H
        #10 instr_i <= {12'h065,`X0,`FN3_ADDI,`X1,`OP_IMM}; // e
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // e
        #10 instr_i <= {12'h06C,`X0,`FN3_ADDI,`X1,`OP_IMM}; // l
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // l
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // l
        #10 instr_i <= {12'h06F,`X0,`FN3_ADDI,`X1,`OP_IMM}; // o
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // o
        #10 instr_i <= {12'h020,`X0,`FN3_ADDI,`X1,`OP_IMM}; // Space
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // Space
        #10 instr_i <= {12'h057,`X0,`FN3_ADDI,`X1,`OP_IMM}; // W
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // W
        #10 instr_i <= {12'h06F,`X0,`FN3_ADDI,`X1,`OP_IMM}; // o
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // o
        #10 instr_i <= {12'h072,`X0,`FN3_ADDI,`X1,`OP_IMM}; // r
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // r
        #10 instr_i <= {12'h06C,`X0,`FN3_ADDI,`X1,`OP_IMM}; // l
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // l
        #10 instr_i <= {12'h064,`X0,`FN3_ADDI,`X1,`OP_IMM}; // d
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // d
        #10 instr_i <= {12'h021,`X0,`FN3_ADDI,`X1,`OP_IMM}; // !
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE }; // !

        // UART TX Enable
        #10 instr_i <= {12'h00A,`X0,`FN3_ADDI,`X1,`OP_IMM};
        #10 instr_i <= {12'h01C,`X1,`FN3_SLLI,`X2,`OP_IMM};
        #10 instr_i <= {12'h001,`X0,`FN3_ADDI,`X1,`OP_IMM};
        #10 instr_i <= {7'h0,`X1,`X2,`FN3_SB,5'h0,`STORE };
        #10 instr_i <= {12'h78,`X0,3'h0,`X0,`JALR}; // Jump and link register

        #10 instr_i <= 'h0;
    #50 $finish;
    end

    // Memory Read Data
    always_ff @(posedge clk_i)
        begin
        if(mem_read_en_o)
            begin
            mem_read_data_i <= 'hA0A0_8080;
            end
        else
            begin
            mem_read_data_i <= 'h0;
            end
        end

endmodule
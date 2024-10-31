//----------------------+-------------------------------------------------------
// Filename             | sys_regs.sv
// File created on      |  14/06/2022 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// System Register
//------------------------------------------------------------------------------

`include "sys_regs.vh"

module sys_regs(
    // Input
    input                           clk_i        , // System Clock
    input                           resetn_i     , // System Reset
    input  [`SYS_REGS_WIDTH-1:0]    rs1_addr_i   , // Operand Register Address
    input  [`SYS_REGS_WIDTH-1:0]    rs2_addr_i   , // Operand Register Address
    input                           read_en_i    , // Read Enable
    input  [`SYS_REGS_WIDTH-1:0]    rd_addr_i    , // Destination Address
    input                           rd_write_en_i, // Write Enable
    input  [          `XLEN-1:0]    rd_data_i    , // Destination Register Data
    // Output
    output [          `XLEN-1:0]    rs1_data_o   , // Read Operand 1
    output [          `XLEN-1:0]    rs2_data_o     // Read Operand 2
);

//------------------------------------------------------------------------------
// System Registers
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    x0 ; // Always Read as 0
    logic [`XLEN-1:0]    x1 ;
    logic [`XLEN-1:0]    x2 ;
    logic [`XLEN-1:0]    x3 ;
    logic [`XLEN-1:0]    x4 ;
    logic [`XLEN-1:0]    x5 ;
    logic [`XLEN-1:0]    x6 ;
    logic [`XLEN-1:0]    x7 ;
    logic [`XLEN-1:0]    x8 ;
    logic [`XLEN-1:0]    x9 ;
    logic [`XLEN-1:0]    x10;
    logic [`XLEN-1:0]    x11;
    logic [`XLEN-1:0]    x12;
    logic [`XLEN-1:0]    x13;
    logic [`XLEN-1:0]    x14;
    logic [`XLEN-1:0]    x15;
    logic [`XLEN-1:0]    x16;
    logic [`XLEN-1:0]    x17;
    logic [`XLEN-1:0]    x18;
    logic [`XLEN-1:0]    x19;
    logic [`XLEN-1:0]    x20;
    logic [`XLEN-1:0]    x21;
    logic [`XLEN-1:0]    x22;
    logic [`XLEN-1:0]    x23;
    logic [`XLEN-1:0]    x24;
    logic [`XLEN-1:0]    x25;
    logic [`XLEN-1:0]    x26;
    logic [`XLEN-1:0]    x27;
    logic [`XLEN-1:0]    x28;
    logic [`XLEN-1:0]    x29;
    logic [`XLEN-1:0]    x30;
    logic [`XLEN-1:0]    x31;

//------------------------------------------------------------------------------
// Write Register
//------------------------------------------------------------------------------

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            x0  <= `DEF_SYS_REG;
            x1  <= `DEF_SYS_REG;
            x2  <= 'h0000_0A00;//`DEF_SYS_REG;
            x3  <= 'h70AA_A081;//`DEF_SYS_REG;
            x4  <= `DEF_SYS_REG;
            x5  <= `DEF_SYS_REG;
            x6  <= `DEF_SYS_REG;
            x7  <= `DEF_SYS_REG;
            x8  <= `DEF_SYS_REG;
            x9  <= `DEF_SYS_REG;
            x10 <= `DEF_SYS_REG;
            x11 <= `DEF_SYS_REG;
            x12 <= `DEF_SYS_REG;
            x13 <= `DEF_SYS_REG;
            x14 <= `DEF_SYS_REG;
            x15 <= `DEF_SYS_REG;
            x16 <= `DEF_SYS_REG;
            x17 <= `DEF_SYS_REG;
            x18 <= `DEF_SYS_REG;
            x19 <= `DEF_SYS_REG;
            x20 <= `DEF_SYS_REG;
            x21 <= `DEF_SYS_REG;
            x22 <= `DEF_SYS_REG;
            x23 <= `DEF_SYS_REG;
            x24 <= `DEF_SYS_REG;
            x25 <= `DEF_SYS_REG;
            x26 <= `DEF_SYS_REG;
            x27 <= `DEF_SYS_REG;
            x28 <= `DEF_SYS_REG;
            x29 <= `DEF_SYS_REG;
            x30 <= `DEF_SYS_REG;
            x31 <= `DEF_SYS_REG;
            end
        else
            begin
            if(rd_write_en_i)
                case(rd_addr_i)
                    `X1  : x1  <= rd_data_i;
                    `X2  : x2  <= rd_data_i;
                    `X3  : x3  <= rd_data_i;
                    `X4  : x4  <= rd_data_i;
                    `X5  : x5  <= rd_data_i;
                    `X6  : x6  <= rd_data_i;
                    `X7  : x7  <= rd_data_i;
                    `X8  : x8  <= rd_data_i;
                    `X9  : x9  <= rd_data_i;
                    `X10 : x10 <= rd_data_i;
                    `X11 : x11 <= rd_data_i;
                    `X12 : x12 <= rd_data_i;
                    `X13 : x13 <= rd_data_i;
                    `X14 : x14 <= rd_data_i;
                    `X15 : x15 <= rd_data_i;
                    `X16 : x16 <= rd_data_i;
                    `X17 : x17 <= rd_data_i;
                    `X18 : x18 <= rd_data_i;
                    `X19 : x19 <= rd_data_i;
                    `X20 : x20 <= rd_data_i;
                    `X21 : x21 <= rd_data_i;
                    `X22 : x22 <= rd_data_i;
                    `X23 : x23 <= rd_data_i;
                    `X24 : x24 <= rd_data_i;
                    `X25 : x25 <= rd_data_i;
                    `X26 : x26 <= rd_data_i;
                    `X27 : x27 <= rd_data_i;
                    `X28 : x28 <= rd_data_i;
                    `X29 : x29 <= rd_data_i;
                    `X30 : x30 <= rd_data_i;
                    `X31 : x31 <= rd_data_i;
                    default : ;
                endcase
            end
        end

//------------------------------------------------------------------------------
// Read rs1
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    rs1_data_reg;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            rs1_data_reg <= `XLEN'h0;
            end
        else
            begin
            if(read_en_i)
                begin
                case(rs1_addr_i)
                    `X0  : rs1_data_reg <= `XLEN'h0;
                    `X1  : rs1_data_reg <= x1;
                    `X2  : rs1_data_reg <= x2;
                    `X3  : rs1_data_reg <= x3;
                    `X4  : rs1_data_reg <= x4;
                    `X5  : rs1_data_reg <= x5;
                    `X6  : rs1_data_reg <= x6;
                    `X7  : rs1_data_reg <= x7;
                    `X8  : rs1_data_reg <= x8;
                    `X9  : rs1_data_reg <= x9;
                    `X10 : rs1_data_reg <= x10;
                    `X11 : rs1_data_reg <= x11;
                    `X12 : rs1_data_reg <= x12;
                    `X13 : rs1_data_reg <= x13;
                    `X14 : rs1_data_reg <= x14;
                    `X15 : rs1_data_reg <= x15;
                    `X16 : rs1_data_reg <= x16;
                    `X17 : rs1_data_reg <= x17;
                    `X18 : rs1_data_reg <= x18;
                    `X19 : rs1_data_reg <= x19;
                    `X20 : rs1_data_reg <= x20;
                    `X21 : rs1_data_reg <= x21;
                    `X22 : rs1_data_reg <= x22;
                    `X23 : rs1_data_reg <= x23;
                    `X24 : rs1_data_reg <= x24;
                    `X25 : rs1_data_reg <= x25;
                    `X26 : rs1_data_reg <= x26;
                    `X27 : rs1_data_reg <= x27;
                    `X28 : rs1_data_reg <= x28;
                    `X29 : rs1_data_reg <= x29;
                    `X30 : rs1_data_reg <= x30;
                    `X31 : rs1_data_reg <= x31;
                    default : ;
                endcase
                end
            end
        end

    assign rs1_data_o = rs1_data_reg;

//------------------------------------------------------------------------------
// Read rs2
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    rs2_data_reg;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            rs2_data_reg <= `XLEN'h0;
            end
        else
            begin
            if(read_en_i)
                begin
                case(rs2_addr_i)
                    `X0  : rs2_data_reg <= `XLEN'h0;
                    `X1  : rs2_data_reg <= x1;
                    `X2  : rs2_data_reg <= x2;
                    `X3  : rs2_data_reg <= x3;
                    `X4  : rs2_data_reg <= x4;
                    `X5  : rs2_data_reg <= x5;
                    `X6  : rs2_data_reg <= x6;
                    `X7  : rs2_data_reg <= x7;
                    `X8  : rs2_data_reg <= x8;
                    `X9  : rs2_data_reg <= x9;
                    `X10 : rs2_data_reg <= x10;
                    `X11 : rs2_data_reg <= x11;
                    `X12 : rs2_data_reg <= x12;
                    `X13 : rs2_data_reg <= x13;
                    `X14 : rs2_data_reg <= x14;
                    `X15 : rs2_data_reg <= x15;
                    `X16 : rs2_data_reg <= x16;
                    `X17 : rs2_data_reg <= x17;
                    `X18 : rs2_data_reg <= x18;
                    `X19 : rs2_data_reg <= x19;
                    `X20 : rs2_data_reg <= x20;
                    `X21 : rs2_data_reg <= x21;
                    `X22 : rs2_data_reg <= x22;
                    `X23 : rs2_data_reg <= x23;
                    `X24 : rs2_data_reg <= x24;
                    `X25 : rs2_data_reg <= x25;
                    `X26 : rs2_data_reg <= x26;
                    `X27 : rs2_data_reg <= x27;
                    `X28 : rs2_data_reg <= x28;
                    `X29 : rs2_data_reg <= x29;
                    `X30 : rs2_data_reg <= x30;
                    `X31 : rs2_data_reg <= x31;
                    default : ;
                endcase
                end
            end
        end

    assign rs2_data_o  = rs2_data_reg;

endmodule
//----------------------+-------------------------------------------------------
// Filename             | sys_regs.vh
// File created on      | 15.11.2020 12:07:34
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// System Register Header
//------------------------------------------------------------------------------

    `include "riscv.vh"

    `define X0   `SYS_REGS_WIDTH'h00
    `define X1   `SYS_REGS_WIDTH'h01
    `define X2   `SYS_REGS_WIDTH'h02
    `define X3   `SYS_REGS_WIDTH'h03
    `define X4   `SYS_REGS_WIDTH'h04
    `define X5   `SYS_REGS_WIDTH'h05
    `define X6   `SYS_REGS_WIDTH'h06
    `define X7   `SYS_REGS_WIDTH'h07
    `define X8   `SYS_REGS_WIDTH'h08
    `define X9   `SYS_REGS_WIDTH'h09
    `define X10  `SYS_REGS_WIDTH'h0A
    `define X11  `SYS_REGS_WIDTH'h0B
    `define X12  `SYS_REGS_WIDTH'h0C
    `define X13  `SYS_REGS_WIDTH'h0D
    `define X14  `SYS_REGS_WIDTH'h0E
    `define X15  `SYS_REGS_WIDTH'h0F
    `define X16  `SYS_REGS_WIDTH'h10
    `define X17  `SYS_REGS_WIDTH'h11
    `define X18  `SYS_REGS_WIDTH'h12
    `define X19  `SYS_REGS_WIDTH'h13
    `define X20  `SYS_REGS_WIDTH'h14
    `define X21  `SYS_REGS_WIDTH'h15
    `define X22  `SYS_REGS_WIDTH'h16
    `define X23  `SYS_REGS_WIDTH'h17
    `define X24  `SYS_REGS_WIDTH'h18
    `define X25  `SYS_REGS_WIDTH'h19
    `define X26  `SYS_REGS_WIDTH'h1A
    `define X27  `SYS_REGS_WIDTH'h1B
    `define X28  `SYS_REGS_WIDTH'h1C
    `define X29  `SYS_REGS_WIDTH'h1D
    `define X30  `SYS_REGS_WIDTH'h1E
    `define X31  `SYS_REGS_WIDTH'h1F

//------------------------------------------------------------------------------
// Default Values
//------------------------------------------------------------------------------

    `define DEF_SYS_REG `XLEN'h0;
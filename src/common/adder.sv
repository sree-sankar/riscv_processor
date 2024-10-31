//----------------------+-------------------------------------------------------
// Filename             | adder.sv
// File created on      | 10.10.2024 08:52:12 AM
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Adder Signed and Unsigned based on opcode
//------------------------------------------------------------------------------

module adder #(
    parameter  DW = 32
)(
    input  [   1:0]    opcode_i,
    input  [DW-1:0]    data0_i ,
    input  [DW-1:0]    data1_i ,
    output [DW-1:0]    result_o
);

//------------------------------------------------------------------------------
// Signed and Unsigned Addition based on opcode
//------------------------------------------------------------------------------

    logic signed [DW-1:0]    data0_signed   ;
    logic signed [DW-1:0]    data1_signed   ;
    logic signed [DW-1:0]    result_signed  ;
    logic        [DW-1:0]    result_unsigned;

    assign data0_signed = data0_i;
    assign data1_signed = data1_i;

    assign result_signed   = data0_signed + data1_signed;
    assign result_unsigned = data0_i + data1_i;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign result_o = opcode_i[0] ? result_signed   :
                      opcode_i[1] ? result_unsigned : 'h0;

endmodule
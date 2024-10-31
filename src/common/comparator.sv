//----------------------+-------------------------------------------------------
// Filename             | comparator.sv
// File created on      | 25.10.2024 08:52:12 AM
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Comparator
//------------------------------------------------------------------------------

module comparator#(
    parameter DW = 32
)(
    input  [   5:0]    opcode_i,
    input  [DW-1:0]    data0_i ,
    input  [DW-1:0]    data1_i ,
    output [DW-1:0]    result_o
);

//------------------------------------------------------------------------------
// Signed
//------------------------------------------------------------------------------

    logic signed [DW-1:0]    data0_signed;
    logic signed [DW-1:0]    data1_signed;
    logic                    compare_res ;

    assign data0_signed = data0_i;
    assign data1_signed = data1_i;

    assign compare_res = opcode_i[0] ? (data0_i == data1_i          ) :
                         opcode_i[1] ? (data0_i != data1_i          ) :
                         opcode_i[2] ? (data0_signed < data1_signed ) :
                         opcode_i[3] ? (data0_i < data1_i           ) :
                         opcode_i[4] ? (data0_signed >= data1_signed) :
                         opcode_i[5] ? (data0_i >= data1_i          ) : 'h0;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign result_o = {{(DW-1){1'b0}},compare_res};

endmodule
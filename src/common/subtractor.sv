//----------------------+-------------------------------------------------------
// Filename             | subtractor.sv
// File created on      | 20.10.2024 04:45:12 PM
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------------

module subtractor#(
    parameter  DW = 32
)(
    input              enable_i,
    input  [DW-1:0]    data0_i ,
    input  [DW-1:0]    data1_i ,
    output [DW-1:0]    result_o
);

//------------------------------------------------------------------------------
// Signed Subtraction
//------------------------------------------------------------------------------

    logic signed [DW-1:0]    data0_signed   ;
    logic signed [DW-1:0]    data1_signed   ;
    logic signed [DW-1:0]    result_signed  ;

    assign data0_signed = data0_i;
    assign data1_signed = data1_i;

    assign result_signed = (enable_i) ? (data0_signed - data1_signed) : 'h0;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign result_o = enable_i ? result_signed : 'h0;

endmodule
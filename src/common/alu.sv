//----------------------+-------------------------------------------------------
// Filename             | alu.sv
// File created on      | 16.10.2024 23:47:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// ALU
//------------------------------------------------------------------------------

module alu #(
    parameter DW          = 32      , // Data Width in Bits
    parameter SHIFT_WIDTH = 32        // Shift Width
)(
    input              clk_i        , // System Clock
    input              resetn_i     , // Synchronous Active Low Reset
    input  [   1:0]    adder_op_i   ,
    input  [   5:0]    compare_op_i ,
    input  [   2:0]    shift_op_i   ,
    input              sub_en_i     ,
    input              xor_en_i     ,
    input              or_en_i      ,
    input              and_en_i     ,
    input  [DW-1:0]    data0_i      ,
    input  [DW-1:0]    data1_i      ,
    output [DW-1:0]    result_o     ,
    input  [DW-1:0]    compare_data0,
    input  [DW-1:0]    compare_data1,
    output [DW-1:0]    compare_res_o
);

//------------------------------------------------------------------------------
// Adder
//------------------------------------------------------------------------------

    logic [DW-1:0]    adder_res;
    logic             adder_en ;

    adder #(
        .DW          (DW                )
    ) adder_inst(
        .opcode_i    (adder_op_i        ),
        .data0_i     (data0_i           ),
        .data1_i     (data1_i           ),
        .result_o    (adder_res         )
    );

    assign adder_en = |adder_op_i;

//------------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------------

    logic [DW-1:0]    sub_res;

    subtractor #(
        .DW          (DW                )
    ) subtractor_inst(
        .enable_i    (sub_en_i          ),
        .data0_i     (data0_i           ),
        .data1_i     (data1_i           ),
        .result_o    (sub_res           )
    );

//------------------------------------------------------------------------------
// Shifter
//------------------------------------------------------------------------------

    logic [DW-1:0]    shift_res;
    logic             shift_en ;

    shifter #(
        .DW            (DW                 ),
        .SHIFT_WIDTH   (SHIFT_WIDTH        )
    ) shifter_inst(
        .opcode_i       (shift_op_i        ),
        .data0_i        (data0_i           ),
        .data1_i        (data1_i           ),
        .result_o       (shift_res         )
    );

    assign shift_en = |shift_op_i;

//------------------------------------------------------------------------------
// Compartor
//------------------------------------------------------------------------------

    logic [DW-1:0]    compare_res;
    logic             compare_en ;

    comparator #(
        .DW          (DW           )
    ) comparator_inst(
        .opcode_i    (compare_op_i ),
        .data0_i     (compare_data0),
        .data1_i     (compare_data1),
        .result_o    (compare_res  )
    );

    assign compare_en = |compare_op_i;

//------------------------------------------------------------------------------
// Logical Operation
//------------------------------------------------------------------------------

    logic [DW-1:0]    xor_res;
    logic [DW-1:0]    or_res ;
    logic [DW-1:0]    and_res;

    assign xor_res = data0_i ^ data1_i;
    assign or_res  = data0_i | data1_i;
    assign and_res = data0_i & data1_i;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign result_o = adder_en   ? adder_res   :
                      sub_en_i   ? sub_res     :
                      shift_en   ? shift_res   :
                      compare_en ? compare_res :
                      xor_en_i   ? xor_res     :
                      or_en_i    ? or_res      :
                      and_en_i   ? and_res     : 'h0;

    assign compare_res_o = compare_res;

endmodule
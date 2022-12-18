`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          : 05.12.2021 12:48:12
// Design Name          :
// Module Name          : halt_cntrl
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
module halt_cntrl(
    input                clk          ,
    input                rst_n        ,
    input                branch_en    ,
//   input [`XLEN-1:0]    fetch_instr,
//   input [`XLEN-1:0]    decode_instr,
//   input [`XLEN-1:0]    exec_instr,
//   input [`XLEN-1:0]    mem_opcode,
    output               halt_fetch   ,
    output               halt_decode  ,
    output               halt_operand ,
    output               halt_exec    ,
    output               halt_mem     ,
    output               halt_reg
);

    wire [5:0] rst_halt    ;
    wire [5:0] branch_halt ;

    assign halt_fetch    = rst_halt[0] | branch_halt[0];
    assign halt_decode   = rst_halt[1] | branch_halt[1];
    assign halt_operand  = rst_halt[2] | branch_halt[2];
    assign halt_exec     = rst_halt[3] | branch_halt[3];
    assign halt_mem      = rst_halt[4] | branch_halt[4];
    assign halt_reg      = rst_halt[5] | branch_halt[5];

///////////////////////////////////////////////////////////////////////////////
// Halt all stages except fetch on reset
///////////////////////////////////////////////////////////////////////////////
    reg  [5:0] rst_halt_reg ;
    reg  [5:0] rst_pipe     ;
    reg       rst_n_d       ;

    assign rst_halt[0] = (!rst_n)? 1'b1 : 1'b0;
    assign rst_halt[1] = rst_halt_reg[1];
    assign rst_halt[2] = rst_halt_reg[2];
    assign rst_halt[3] = rst_halt_reg[3];
    assign rst_halt[4] = rst_halt_reg[4];
    assign rst_halt[5] = rst_halt_reg[5];

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            rst_halt_reg <= 6'b111111;
            rst_pipe     <= 6'b0;
            rst_n_d      <= 1'b0;
            end
        else
            begin
            rst_n_d  <= rst_n;
            rst_pipe <= {rst_pipe[4:0],rst_n_posedge};
            if(rst_n_posedge)
                rst_halt_reg <= 6'b111100;
            else if(rst_pipe[0])
                rst_halt_reg <= 6'b111000;
            else if(rst_pipe[1])
                rst_halt_reg <= 6'b110000;
            else if(rst_pipe[2])
                rst_halt_reg <= 6'b100000;
            else
                rst_halt_reg <= 6'b000000;
            end
        end

assign rst_n_posedge = rst_n & ~rst_n_d;

///////////////////////////////////////////////////////////////////////////////
// Branch instruction halt
///////////////////////////////////////////////////////////////////////////////

    reg  [5:0] branch_halt_reg ;
    reg  [5:0] branch_pipe     ;

    assign branch_halt[0] = branch_halt_reg[0];
    assign branch_halt[1] = branch_halt_reg[1] | branch_en;
    assign branch_halt[2] = branch_halt_reg[2] | branch_en;
    assign branch_halt[3] = branch_halt_reg[3] | branch_en;
    assign branch_halt[4] = branch_halt_reg[4];
    assign branch_halt[5] = branch_halt_reg[5];

    always @(posedge clk)
        begin
        if(!rst_n)
            begin
            branch_halt_reg <= 6'b0;
            branch_pipe      <= 6'b0;
            end
        else
            begin
            branch_pipe <= {branch_pipe[4:0],branch_en};
            if(branch_en)
                branch_halt_reg <= 6'b011100;
            else if(branch_pipe[0])
                branch_halt_reg <= 6'b111000;
            else if(branch_pipe[1])
                branch_halt_reg <= 6'b110000;
            else if(branch_pipe[2])
                branch_halt_reg <= 6'b100000;
            else if(branch_pipe[3])
                branch_halt_reg <= 6'b000000;
            else
                branch_halt_reg <= 6'b000000;
            end
        end

    reg [5:0] halt;

   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         halt <= 6'b000000;
         end
//      else if((mem_opcode == `LOAD) && ((execute_instr[19:15] == mem_instr[11:7]) || (execute_instr[24:20] == mem_instr[11:7])))
//         begin
//         halt <= 5'b11100;
//         end
//         //else if(if_id_instr == id_ex_instr) begin
//         //halt <= 5'b11000;
//         //end
      else
         begin
         halt <= 6'b000000;
         end
      end

endmodule

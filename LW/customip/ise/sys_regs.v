`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company          : 
// Engineer         : 
// 
// Create Date      : 14/06/2022
// Design Name      : 
// Module Name      : sys_regs
// Project Name     : 
// Target Devices   : 
// Tool Versions    : 
// Description      : 
// 
// Dependencies     : 
// 
// Revision         : 1.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "header_files/rv_32i.vh"
`include "header_files/register_definition.vh"
module sys_regs(
   input               				clk,      	// System Clock
   input               				rst_n,    	// System Reset 
   input               				read_en,    	// Read Enable
   input               				write_en,     	// Write Enable
   input  [`SYS_REGS_WIDTH-1:0]  rs1_addr,  	// Operand Register Address
   input  [`SYS_REGS_WIDTH-1:0]  rs2_addr,  	// Operand Register Address
   input  [`SYS_REGS_WIDTH-1:0]  rd_addr,   	// Destination Address
   input  [`XLEN-1:0]  				write_data,	// Data register
   output [`XLEN-1:0]  				rs1_data, 	// Read Operand 1
   output [`XLEN-1:0]  				rs2_data  	// Read Operand 2
);
   reg [`XLEN-1:0] x0;
   reg [`XLEN-1:0] x1;
   reg [`XLEN-1:0] x2;
   reg [`XLEN-1:0] x3;
   reg [`XLEN-1:0] x4;
   reg [`XLEN-1:0] x5;
   reg [`XLEN-1:0] x6;
   reg [`XLEN-1:0] x7;
   reg [`XLEN-1:0] x8;
   reg [`XLEN-1:0] x9;
   reg [`XLEN-1:0] x10;
   reg [`XLEN-1:0] x11;
   reg [`XLEN-1:0] x12;
   reg [`XLEN-1:0] x13;
   reg [`XLEN-1:0] x14;
   reg [`XLEN-1:0] x15;
   reg [`XLEN-1:0] x16;
   reg [`XLEN-1:0] x17;
   reg [`XLEN-1:0] x18;
   reg [`XLEN-1:0] x19;
   reg [`XLEN-1:0] x20;
   reg [`XLEN-1:0] x21;
   reg [`XLEN-1:0] x22;
   reg [`XLEN-1:0] x23;
   reg [`XLEN-1:0] x24;
   reg [`XLEN-1:0] x25;
   reg [`XLEN-1:0] x26;
   reg [`XLEN-1:0] x27;
   reg [`XLEN-1:0] x28;
   reg [`XLEN-1:0] x29;
   reg [`XLEN-1:0] x30;
   reg [`XLEN-1:0] x31;

   reg [`XLEN-1:0] rs1_reg;
   reg [`XLEN-1:0] rs2_reg;
   
   wire rs1_addr_match;
   wire rs2_addr_match;

   assign rs1_data       = rs1_reg;
   assign rs2_data       = rs2_reg;
   assign rs1_addr_match = (rs1_addr == rd_addr) ? 1'b1 : 1'b0;
   assign rs2_addr_match = (rs2_addr == rd_addr) ? 1'b1 : 1'b0;
  
  //Write 
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         x0    <= `DEF_SYS_REG;
         x1    <= `DEF_SYS_REG;
         x2    <= `DEF_SYS_REG;
         x3    <= `DEF_SYS_REG;
         x4    <= `DEF_SYS_REG;
         x5    <= `DEF_SYS_REG;
         x6    <= `DEF_SYS_REG;
         x7    <= `DEF_SYS_REG;
         x8    <= `DEF_SYS_REG;
         x9    <= `DEF_SYS_REG;
         x10   <= `DEF_SYS_REG;
         x11   <= `DEF_SYS_REG;
         x12   <= `DEF_SYS_REG;
         x13   <= `DEF_SYS_REG;
         x14   <= `DEF_SYS_REG;
         x15   <= `DEF_SYS_REG;
         x16   <= `DEF_SYS_REG;
         x17   <= `DEF_SYS_REG;
         x18   <= `DEF_SYS_REG;
         x19   <= `DEF_SYS_REG;
         x20   <= `DEF_SYS_REG;
         x21   <= `DEF_SYS_REG;
         x22   <= `DEF_SYS_REG;
         x23   <= `DEF_SYS_REG;
         x24   <= `DEF_SYS_REG;
         x25   <= `DEF_SYS_REG;
         x26   <= `DEF_SYS_REG;
         x27   <= `DEF_SYS_REG;
         x28   <= `DEF_SYS_REG; 
         x29   <= `DEF_SYS_REG;
         x30   <= `DEF_SYS_REG;
         x31   <= `DEF_SYS_REG;
         end
      else 
         begin
         if(write_en)
            case(rd_addr)
					`X0  : x0    <= 32'h0000_0000;
               `X1  : x1    <= write_data;
               `X2  : x2    <= write_data;
               `X3  : x3    <= write_data;
               `X4  : x4    <= write_data;
               `X5  : x5    <= write_data;
               `X6  : x6    <= write_data;
               `X7  : x7    <= write_data;
               `X8  : x8    <= write_data;
               `X9  : x9    <= write_data;
					`X10 : x10   <= write_data;
					`X11 : x11   <= write_data;
					`X12 : x12   <= write_data;
					`X13 : x13   <= write_data;
					`X14 : x14   <= write_data;
					`X15 : x15   <= write_data;
					`X16 : x16   <= write_data;
					`X17 : x17   <= write_data;
					`X18 : x18   <= write_data;
					`X19 : x19   <= write_data;
               `X20 : x20   <= write_data;
               `X21 : x21   <= write_data;
               `X22 : x22   <= write_data;
					`X23 : x23   <= write_data;
               `X24 : x24   <= write_data;
               `X25 : x25   <= write_data;
               `X26 : x26   <= write_data;
               `X27 : x27   <= write_data;
               `X28 : x28   <= write_data;
               `X29 : x29   <= write_data;
               `X30 : x30   <= write_data;
               `X31 : x31   <= write_data;
            endcase
         end
		end

  //Read rs1
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         rs1_reg <= 32'h00000_0000;
         end
      else 
         begin
         if(read_en)
            begin 
            if(rs1_addr_match) 
               begin
               rs1_reg <= write_data;
               end
            else 
               begin
               case(rs1_addr)
                  `X0  : rs1_reg  <= 32'h0000_0000;
                  `X1  : rs1_reg  <= x1;
                  `X2  : rs1_reg  <= x2;
                  `X3  : rs1_reg  <= x3;
                  `X4  : rs1_reg  <= x4;
                  `X5  : rs1_reg  <= x5;
                  `X6  : rs1_reg  <= x6;
                  `X7  : rs1_reg  <= x7;
                  `X8  : rs1_reg  <= x8;
                  `X9  : rs1_reg  <= x9;
                  `X10 : rs1_reg  <= x10;
                  `X11 : rs1_reg  <= x11;
                  `X12 : rs1_reg  <= x12;
                  `X13 : rs1_reg  <= x13;
                  `X14 : rs1_reg  <= x14;
                  `X15 : rs1_reg  <= x15;
                  `X16 : rs1_reg  <= x16;
                  `X17 : rs1_reg  <= x17;
                  `X18 : rs1_reg  <= x18;
                  `X19 : rs1_reg  <= x19;
                  `X20 : rs1_reg  <= x20;
                  `X21 : rs1_reg  <= x21;
                  `X22 : rs1_reg  <= x22;
                  `X23 : rs1_reg  <= x23;
                  `X24 : rs1_reg  <= x24;
                  `X25 : rs1_reg  <= x25;
                  `X26 : rs1_reg  <= x26;
                  `X27 : rs1_reg  <= x27;
                  `X28 : rs1_reg  <= x28;
                  `X29 : rs1_reg  <= x29;
                  `X30 : rs1_reg  <= x30;
                  `X31 : rs1_reg  <= x31;
               endcase
               end
				end
            else 
               begin
               rs1_reg <= rs1_reg;
               end
				end
         end

    //Read rs2
   always @(posedge clk)
      begin
      if(!rst_n)
         begin
         rs2_reg <= 32'h00000_0000;
         end
      else 
         begin
         if(read_en)
            begin 
            if(rs2_addr_match) 
               begin
               rs2_reg <= write_data;
               end
            else 
               begin
               case(rs2_addr)
                  `X0  : rs2_reg  <= 32'h0000_0000;
                  `X1  : rs2_reg  <= x1;
                  `X2  : rs2_reg  <= x2;
                  `X3  : rs2_reg  <= x3;
                  `X4  : rs2_reg  <= x4;
                  `X5  : rs2_reg  <= x5;
                  `X6  : rs2_reg  <= x6;
                  `X7  : rs2_reg  <= x7;
                  `X8  : rs2_reg  <= x8;
                  `X9  : rs2_reg  <= x9;
                  `X10 : rs2_reg  <= x10;
                  `X11 : rs2_reg  <= x11;
                  `X12 : rs2_reg  <= x12;
                  `X13 : rs2_reg  <= x13;
                  `X14 : rs2_reg  <= x14;
                  `X15 : rs2_reg  <= x15;
                  `X16 : rs2_reg  <= x16;
                  `X17 : rs2_reg  <= x17;
                  `X18 : rs2_reg  <= x18;
                  `X19 : rs2_reg  <= x19;
                  `X20 : rs2_reg  <= x20;
                  `X21 : rs2_reg  <= x21;
                  `X22 : rs2_reg  <= x22;
                  `X23 : rs2_reg  <= x23;
                  `X24 : rs2_reg  <= x24;
                  `X25 : rs2_reg  <= x25;
                  `X26 : rs2_reg  <= x26;
                  `X27 : rs2_reg  <= x27;
                  `X28 : rs2_reg  <= x28;
                  `X29 : rs2_reg  <= x29;
                  `X30 : rs2_reg  <= x30;
                  `X31 : rs2_reg  <= x31;
               endcase
               end
				end
            else 
               begin
               rs2_reg <= rs2_reg;
               end
				end
         end
                      
endmodule
`timescale 1ns / 1ps
`include "define.v"

module instr_execute(input i_clk,
                     input i_rst,
                     input i_halt,
                     input i_taken_branch,
                     input [`XLEN-1:0] i_pc,
                     input [`XLEN-1:0] i_instr,
                     input [`XLEN-1:0] i_csr_data,
                     input [`XLEN-1:0] i_imm_i_type,
                     input [`XLEN-1:0] i_imm_s_type,
                     input [`XLEN-1:0] i_imm_b_type,
                     input [`XLEN-1:0] i_imm_j_type,
                     input [`XLEN-1:0] i_imm_u_type,
                     input signed [`XLEN-1:0] i_rs1,
                     input signed [`XLEN-1:0] i_rs2,
                     
                     output reg o_csr_or,
                     output reg o_csr_and,
                     output reg o_branch_en,
                     output reg o_csr_wr_en,
                     output reg [`XLEN-1:0] o_rs2,
                     output reg [`XLEN-1:0] o_alu,
                     output reg [`XLEN-1:0] o_instr,
                     output reg [11:0] o_csr_wr_addr,
                     output reg [`XLEN-1:0] o_mem_data,
                     output reg [`XLEN-1:0] o_csr_data,
                     output reg [`XLEN-1:0] o_branch_addr);
    
    reg[`XLEN-1 : 0] r_alu_res;
    reg[`XLEN-1 : 0] r_mem_data;
    reg[`XLEN-1 : 0] r_branch_addr;
    reg[`XLEN-1 : 0] r_csr_data;
    reg r_branch_en,r_csr_wr_en,r_csr_rd_en;
    reg[11:0] r_csr_wr_addr;
    reg r_csr_or,r_csr_and;

    //Branch Enable

    always @(posedge i_clk or negedge i_rst)
     begin
        if(!i_rst)begin
            o_branch_addr  <= 0;
            o_branch_en    <= 0;
        end 
        else begin 
            if(i_halt == 1'b0 && i_taken_branch == 1'b0)begin
                o_rs2         <= i_rs2;
                o_instr       <= i_instr;
                o_alu         <= r_alu_res;
                o_mem_data    <= r_mem_data;
                o_branch_addr <= r_branch_addr;
                o_csr_data    <= r_csr_data;
                o_csr_wr_en   <= r_csr_wr_en;
                o_csr_wr_addr <= r_csr_wr_addr;
                o_branch_en   <= r_branch_en;
                o_csr_and     <= r_csr_and;
                o_csr_or      <= r_csr_or;
            end
        end
    end     
        
        //--------------------Execution Unit-------------------------------//
        always @(*) begin
            r_csr_wr_en <= 1'b0;
            r_csr_or    <= 1'b0;
            r_csr_and   <= 1'b0;    
            case(i_instr[6:0])
            
            //---------------------OP------------------------------//
            `OP:begin
                case(i_instr[14:12])
                   `FN3_ADD_SUB  : r_alu_res  <= (i_instr[31:25] == `FN7_F1) ?  (i_rs1 + i_rs2) :
                                                    (i_instr[31:25] == `FN7_F2) ?  (i_rs1 - i_rs2) : 32'bx;
                   `FN3_SLL      : r_alu_res  <= i_rs1 << i_rs2[4:0];
                   `FN3_SLT      : r_alu_res  <= i_rs1 < i_rs2;
                   `FN3_SLTU     : r_alu_res  <= $unsigned(i_rs1) < $unsigned(i_rs2);
                   `FN3_XOR      : r_alu_res  <= i_rs1 ^ i_rs2;
                   `FN3_SRL_SRA  : r_alu_res  <= (i_instr[31:25] == `FN7_F1) ?  i_rs1 >> i_rs2[4:0]  :
                                               (i_instr[31:25] == `FN7_F2) ?  i_rs1 >>> i_rs2[4:0] : 32'b0;
                   `FN3_OR       : r_alu_res  <= i_rs1 | i_rs2;
                   `FN3_AND      : r_alu_res  <= i_rs1 & i_rs2;
                endcase
               end
            
            //------------------------------------OP_IMM----------------------------------------//
            `OP_IMM:begin
                case(i_instr[14:12])   
                        `FN3_ADDI  : r_alu_res  <= i_rs1 + i_imm_i_type;
                        `FN3_SLTI  : r_alu_res  <= i_rs1 < i_imm_i_type;  
                        `FN3_SLTIU : r_alu_res  <= $unsigned(i_rs1) < $unsigned(i_imm_i_type);
                        `FN3_XORI  : r_alu_res  <= i_rs1 ^ i_imm_i_type;
                        `FN3_ORI   : r_alu_res  <= i_rs1 | i_imm_i_type;
                        `FN3_ANDI  : r_alu_res  <= i_rs1 & i_imm_i_type;
                        `FN3_SLLI  : r_alu_res  <= i_rs1 << i_instr[24:20];
                        `FN3_SRLI  : r_alu_res  <= i_rs1 >> i_instr[24:20];
                        `FN3_SRAI  : r_alu_res  <= i_rs1 >>> i_rs2[4:0];
                   endcase
                end  
            
            //------------------------------------BRANCH----------------------------------------//
            `BRANCH : begin
                case(i_instr[14:12])   
                        `FN3_BEQ  :  {r_branch_en, r_branch_addr}  <= (i_rs1 == i_rs2) ?  {1'b1, i_pc + i_imm_b_type} : 0; 
                        `FN3_BNE  :  {r_branch_en, r_branch_addr}  <= (i_rs1 != i_rs2) ?  {1'b1, i_pc + i_imm_b_type} : 0; 
                        `FN3_BLT  :  {r_branch_en, r_branch_addr}  <= (i_rs1 < i_rs2)  ?  {1'b1, i_pc + i_imm_b_type} : 0; 
                        `FN3_BGE  :  {r_branch_en, r_branch_addr}  <= (i_rs1 > i_rs2)  ?  {1'b1, i_pc + i_imm_b_type} : 0; 
                        `FN3_BLTU :  {r_branch_en, r_branch_addr}  <= ($unsigned(i_rs1) < $unsigned(i_rs2)) ? {1'b1, i_pc + i_imm_b_type} : 0; 
                        `FN3_BGEU :  {r_branch_en, r_branch_addr}  <= ($unsigned(i_rs1) > $unsigned(i_rs2)) ? {1'b1, i_pc + i_imm_b_type} : 0; 
                   endcase
                end                        
            
            //---------------------LUI------------------------------//
            `LUI   :  begin r_alu_res <=  i_imm_u_type; end 
            //---------------------ALUI------------------------------//
            `AUIPC :  begin r_alu_res <=  i_pc + i_imm_u_type; end
            //---------------------JAL------------------------------//
            `JAL   : begin
                       r_branch_en <= 1'b1;
                       r_alu_res       <= i_pc + 1;
                       o_branch_addr <= i_pc +{{12{i_instr[31]}},i_instr[31:12]};
                     end
            //---------------------JALR------------------------------//
            `JALR  :  begin
                       r_branch_en   <= 1'b1;
                       r_alu_res         <= i_pc + 1;
                       r_branch_addr <= (i_rs1 +{{20{i_instr[31]}},i_instr[31:21], 1'b0});
                     end
            //---------------------LOAD------------------------------//
            `LOAD  :  begin r_alu_res <= i_rs1 + i_imm_i_type; end   
            //---------------------STORE------------------------------//
            `STORE :  begin 
                      r_alu_res <=  i_rs1 + i_imm_s_type ;
                      case(i_instr[14:12])  
                          `FN3_SB  : r_mem_data  <= {{24{1'b0}},i_rs2[7:0]};
                          `FN3_SH  : r_mem_data  <= {{16{1'b0}},i_rs2[15:0]};
                          `FN3_SW  : r_mem_data  <= i_rs2;
                          `FN3_SBU : r_mem_data  <= $unsigned(i_rs2[7:0]);
                          `FN3_SHU : r_mem_data  <= $unsigned( {{16{1'b0}},i_rs2[15:0]} );
                      endcase 
                      end
            //---------------------SYSTEM------------------------------//
            `SYSTEM : begin
                    case(i_instr[14:12])
                      /*  `PRIV   : begin
                            case(i_instr[31:20]) begin
                  
                              
                                `MRET   : begin 
                                    
                                end 
                                
                                `WFI    : begin
                                end 
                                
                                `ECALL  : begin  

                                end
                                `EBREAK : begin 

                                end
                            end
                        end
                        */
                        `CSRRW  : begin
                               if(i_instr[11:7] != 5'b0 ) begin
                                    r_alu_res       <= i_csr_data;
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end else begin
                                    r_alu_res       <= 32'b0;
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= 12'b0;
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end
                        end

                        `CSRRS  : begin
                                if(i_instr[19:15] != 5'b0 ) begin
                                    r_alu_res       <= i_csr_data;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b1;
                                    r_csr_and       <= 1'b0;
                                end else begin
                                    r_alu_res       <= i_csr_data;
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b0;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end
                        end

                        `CSRRC  : begin
                               if(i_instr[19:15] != 5'b0 ) begin
                                    r_alu_res       <= i_csr_data;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b1;
                                end else begin
                                    r_alu_res       <= i_csr_data;
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b0;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end
                        end
                        
                        `CSRRWI : begin
                                if(i_instr[11:7] != 5'b0 ) begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end else begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end
                        end

                        `CSRRSI : begin
                                if(i_instr[19:15] != 5'b0) begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b1;
                                    r_csr_and       <= 1'b0;
                                end else begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b0;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end
                        end

                        `CSRRCI : begin
                                if(i_instr[19:15] != 5'b0 ) begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b1;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b1;
                                end else begin
                                    r_alu_res       <= {i_instr[31:20],12'b0};
                                    r_csr_data      <= i_rs1;
                                    r_csr_wr_addr   <= i_instr[31:20];
                                    r_csr_wr_en     <= 1'b0;
                                    r_csr_or        <= 1'b0;
                                    r_csr_and       <= 1'b0;
                                end                 
                        end
                        endcase
                      end  

           default : begin  
                        //r_alu_res      <= 32'b0;
                        r_mem_data     <= 32'b0;
                        r_branch_en  <=  1'b0;
                        r_branch_addr  <= 32'b0;
                        r_csr_data     <= 32'b0;
                        r_csr_wr_en    <=  1'b0;
                      end          
         endcase 
   end
endmodule

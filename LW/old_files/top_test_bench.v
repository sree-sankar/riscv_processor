`timescale 1ns / 1ps


module top_test_bench();
    reg i_clk,i_rst;
    top RV32I(i_clk,i_rst);
    integer i,k;
    
    initial begin
        i_clk = 0; i_rst = 1;
        #6 i_rst = 0;
        #1 i_rst = 1; 
    end
    always #5 i_clk = ~i_clk;
    
    initial begin
    //Checked OP, OP IM,LUI,AUIPC,BRANCH,
       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[0]  <= 32'b0000000_00011_00010_000_00001_0110011;// R1 = 73
       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[1]  <= 32'b0000000_00010_00000_000_00100_0110011;// R4 = 7
       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[2]  <= 32'b0000000_00010_00001_000_00101_0110011;// R5  = 73+73 
//      // RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[1]  <= 32'b0000000_00010_00001_000_10010_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[2]  <= 32'b0000000_00010_00001_000_01010_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[3]  <= 32'b0000000_00010_00001_000_00110_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[4]  <= 32'b0000000_00010_00001_000_00011_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[5]  <= 32'b0000000_00010_00001_000_01110_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[6]  <= 32'b0000000_00010_00001_000_01010_0110011;// R3  = 8 
//       RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[7]  <= 32'b0000000_00010_00001_000_01010_0110011;// R3  = 8 

   //Reg Memory
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[0]  <= 0;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[1]  <= 7;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[2]  <= 7;//32'b1011_1000_1000_0000_0010_0001_0001_1100_1000;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[3]  <= 66;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[4]  <= 5;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[5]  <= 2214;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[6]  <= 55782;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[7]  <= 2121;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[8]  <= 242424;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[9]  <= 6446;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[10] <= 5777;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[11] <= 1201;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[12] <= 1777;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[13] <= 99999;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[14] <= 54003;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[15] <= 10;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[16] <= 52122;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[17] <= 13131;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[18] <= 888;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[19] <= 2445;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[20] <= 4;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[21] <= 58882;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[22] <= 21212;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[23] <= 247877;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[24] <= 2428;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[25] <= 211222;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[26] <= 33364;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[27] <= 347999;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[28] <= 549912;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[29] <= 55557;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[30] <= 4444;
         RV32I.RV32I_core.Reg_Read_Write.reg_bank[31] <= 444421;
         
         RV32I.RV32I_core.CSR.csr_bank[0]  <= 55;

    end



    initial begin
        #56 for(k=0; k<31; k=k+1)begin
           $display($time," Mem%1d = %2d\t\t R%1d = %2d",k,RV32I.RV32I_core.Mem_Fetch_Access.mem_bank[k],k,RV32I.RV32I_core.Reg_Read_Write.reg_bank[k] ); 
        end
        $display("CSR[0] = %2d",RV32I.RV32I_core.CSR.csr_bank[0]);

//    #56 for(k=0; k<4096; k=k+1)begin
//            $display("CSR = %2d",RV32I.RV32I_core.CSR.csr_bank[k]);
//        end
    end 
endmodule



`include "rv_32i.vh"
`include "register_definition.vh"

module csr_reg (
        input                           clk,
        input                           rst_n,
        input                           wr_en,
        input                           rd_en,
        input  [`CSR_BASE_WIDTH-1:0]    rd_addr,
        input  [`CSR_BASE_WIDTH-1:0]    wr_addr,
        input  [`MXLEN-1:0]             wr_data,
       
        // Interrupt and Trap signals
        input                           intr,
        input  [`MXLEN-2:0]             m_cause,
       
        
        output [`MXLEN-1:0]             rd_data,
        output                          wr_done,
        output                          rd_data_valid      
);

    // Machine Information Registers
    reg [`XLEN-1:0] m_vendorid_reg;    
    reg [`XLEN-1:0] m_archid_reg;
    reg [`XLEN-1:0] m_impid_reg;
    reg [`XLEN-1:0] m_hartid_reg;
    reg [`XLEN-1:0] m_configptr_reg;
    
    // Machine Trap Setup Registers
    reg [`XLEN-1:0] m_status_reg;
    reg [`XLEN-1:0] m_isa_reg;
    reg [`XLEN-1:0] m_edeleg_reg;
    reg [`XLEN-1:0] m_ideleg_reg;
    reg [`XLEN-1:0] m_ie_reg;
    reg [`XLEN-1:0] m_tvec_reg;
    reg [`XLEN-1:0] m_counteren_reg;
    `ifdef RV32
        reg [`XLEN-1:0] m_statush_reg;
    `endif
    
    // Machine Trap Handling Registers
    reg [`XLEN-1:0] m_scratch_reg;
    reg [`XLEN-1:0] m_epc_reg;
    reg [`XLEN-1:0] m_cause_reg;
    reg [`XLEN-1:0] m_tval_reg;
    reg [`XLEN-1:0] m_ip_reg;
    reg [`XLEN-1:0] m_tinst_reg;
    reg [`XLEN-1:0] m_tval2_reg;
    
    // Machine Configuration Registers
    reg [`XLEN-1:0] m_envcfg_reg;
    reg [`XLEN-1:0] m_seccfg_reg;
    `ifdef RV32
        reg [`XLEN-1:0] m_envcfgh_reg;
        reg [`XLEN-1:0] m_seccfgh_reg;
    `endif
     
    // Machine Memory Protection Registers
    reg [`XLEN-1:0] m_pmpcfg0_reg;
    reg [`XLEN-1:0] m_pmpcfg2_reg;
    reg [`XLEN-1:0] m_pmpcfg4_reg;
    reg [`XLEN-1:0] m_pmpcfg6_reg;
    reg [`XLEN-1:0] m_pmpcfg8_reg;
    reg [`XLEN-1:0] m_pmpcfg10_reg;
    reg [`XLEN-1:0] m_pmpcfg12_reg;
    reg [`XLEN-1:0] m_pmpcfg14_reg;
    `ifdef RV32
        reg [`XLEN-1:0] m_pmpcfg1_reg;
        reg [`XLEN-1:0] m_pmpcfg3_reg;
        reg [`XLEN-1:0] m_pmpcfg5_reg;
        reg [`XLEN-1:0] m_pmpcfg7_reg;
        reg [`XLEN-1:0] m_pmpcfg9_reg;
        reg [`XLEN-1:0] m_pmpcfg11_reg;
        reg [`XLEN-1:0] m_pmpcfg13_reg;
        reg [`XLEN-1:0] m_pmpcfg15_reg;
    `endif
     
    reg [`XLEN-1:0] m_pmpaddr0_reg;
    reg [`XLEN-1:0] m_pmpaddr1_reg;
    reg [`XLEN-1:0] m_pmpaddr2_reg;
    reg [`XLEN-1:0] m_pmpaddr3_reg;
    reg [`XLEN-1:0] m_pmpaddr4_reg;
    reg [`XLEN-1:0] m_pmpaddr5_reg;
    reg [`XLEN-1:0] m_pmpaddr6_reg;
    reg [`XLEN-1:0] m_pmpaddr7_reg;
    reg [`XLEN-1:0] m_pmpaddr8_reg;
    reg [`XLEN-1:0] m_pmpaddr9_reg;
    reg [`XLEN-1:0] m_pmpaddr10_reg;
    reg [`XLEN-1:0] m_pmpaddr11_reg;
    reg [`XLEN-1:0] m_pmpaddr12_reg;
    reg [`XLEN-1:0] m_pmpaddr13_reg;
    reg [`XLEN-1:0] m_pmpaddr14_reg;
    reg [`XLEN-1:0] m_pmpaddr15_reg;
    reg [`XLEN-1:0] m_pmpaddr16_reg;
    reg [`XLEN-1:0] m_pmpaddr17_reg;
    reg [`XLEN-1:0] m_pmpaddr18_reg;
    reg [`XLEN-1:0] m_pmpaddr19_reg;
    reg [`XLEN-1:0] m_pmpaddr20_reg;
    reg [`XLEN-1:0] m_pmpaddr21_reg;
    reg [`XLEN-1:0] m_pmpaddr22_reg;
    reg [`XLEN-1:0] m_pmpaddr23_reg;
    reg [`XLEN-1:0] m_pmpaddr24_reg;
    reg [`XLEN-1:0] m_pmpaddr25_reg;
    reg [`XLEN-1:0] m_pmpaddr26_reg;
    reg [`XLEN-1:0] m_pmpaddr27_reg;
    reg [`XLEN-1:0] m_pmpaddr28_reg;
    reg [`XLEN-1:0] m_pmpaddr29_reg;
    reg [`XLEN-1:0] m_pmpaddr30_reg;
    reg [`XLEN-1:0] m_pmpaddr31_reg;
    reg [`XLEN-1:0] m_pmpaddr32_reg;
    reg [`XLEN-1:0] m_pmpaddr33_reg;
    reg [`XLEN-1:0] m_pmpaddr34_reg;
    reg [`XLEN-1:0] m_pmpaddr35_reg;
    reg [`XLEN-1:0] m_pmpaddr36_reg;
    reg [`XLEN-1:0] m_pmpaddr37_reg;
    reg [`XLEN-1:0] m_pmpaddr38_reg;
    reg [`XLEN-1:0] m_pmpaddr39_reg;
    reg [`XLEN-1:0] m_pmpaddr40_reg;
    reg [`XLEN-1:0] m_pmpaddr41_reg;
    reg [`XLEN-1:0] m_pmpaddr42_reg;
    reg [`XLEN-1:0] m_pmpaddr43_reg;
    reg [`XLEN-1:0] m_pmpaddr44_reg;
    reg [`XLEN-1:0] m_pmpaddr45_reg;
    reg [`XLEN-1:0] m_pmpaddr46_reg;
    reg [`XLEN-1:0] m_pmpaddr47_reg;
    reg [`XLEN-1:0] m_pmpaddr48_reg;
    reg [`XLEN-1:0] m_pmpaddr49_reg;
    reg [`XLEN-1:0] m_pmpaddr50_reg;
    reg [`XLEN-1:0] m_pmpaddr51_reg;
    reg [`XLEN-1:0] m_pmpaddr52_reg;
    reg [`XLEN-1:0] m_pmpaddr53_reg;
    reg [`XLEN-1:0] m_pmpaddr54_reg;
    reg [`XLEN-1:0] m_pmpaddr55_reg;
    reg [`XLEN-1:0] m_pmpaddr56_reg;
    reg [`XLEN-1:0] m_pmpaddr57_reg;
    reg [`XLEN-1:0] m_pmpaddr58_reg;
    reg [`XLEN-1:0] m_pmpaddr59_reg;
    reg [`XLEN-1:0] m_pmpaddr60_reg;
    reg [`XLEN-1:0] m_pmpaddr61_reg;
    reg [`XLEN-1:0] m_pmpaddr62_reg;
    reg [`XLEN-1:0] m_pmpaddr63_reg;
     
    // Machine Counter/Timer Registers
    reg [`XLEN-1:0] m_cycle_reg;
    reg [`XLEN-1:0] m_instret_reg;
    reg [`XLEN-1:0] m_hpmcounter3_reg;
    reg [`XLEN-1:0] m_hpmcounter4_reg;
    reg [`XLEN-1:0] m_hpmcounter5_reg;
    reg [`XLEN-1:0] m_hpmcounter6_reg;
    reg [`XLEN-1:0] m_hpmcounter7_reg;
    reg [`XLEN-1:0] m_hpmcounter8_reg;
    reg [`XLEN-1:0] m_hpmcounter9_reg;
    reg [`XLEN-1:0] m_hpmcounter10_reg;
    reg [`XLEN-1:0] m_hpmcounter11_reg;
    reg [`XLEN-1:0] m_hpmcounter12_reg;
    reg [`XLEN-1:0] m_hpmcounter13_reg;
    reg [`XLEN-1:0] m_hpmcounter14_reg;
    reg [`XLEN-1:0] m_hpmcounter15_reg;
    reg [`XLEN-1:0] m_hpmcounter16_reg;
    reg [`XLEN-1:0] m_hpmcounter17_reg;
    reg [`XLEN-1:0] m_hpmcounter18_reg;
    reg [`XLEN-1:0] m_hpmcounter19_reg;
    reg [`XLEN-1:0] m_hpmcounter20_reg;
    reg [`XLEN-1:0] m_hpmcounter21_reg;
    reg [`XLEN-1:0] m_hpmcounter22_reg;
    reg [`XLEN-1:0] m_hpmcounter23_reg;
    reg [`XLEN-1:0] m_hpmcounter24_reg;
    reg [`XLEN-1:0] m_hpmcounter25_reg;
    reg [`XLEN-1:0] m_hpmcounter26_reg;
    reg [`XLEN-1:0] m_hpmcounter27_reg;
    reg [`XLEN-1:0] m_hpmcounter28_reg;
    reg [`XLEN-1:0] m_hpmcounter29_reg;
    reg [`XLEN-1:0] m_hpmcounter30_reg;
    reg [`XLEN-1:0] m_hpmcounter31_reg;
    
    `ifdef RV32
        reg [`XLEN-1:0] m_cycleh_reg;
        reg [`XLEN-1:0] m_instreth_reg;
        reg [`XLEN-1:0] m_hpmcounter3h_reg;
        reg [`XLEN-1:0] m_hpmcounter4h_reg;
        reg [`XLEN-1:0] m_hpmcounter5h_reg;
        reg [`XLEN-1:0] m_hpmcounter6h_reg;
        reg [`XLEN-1:0] m_hpmcounter7h_reg;
        reg [`XLEN-1:0] m_hpmcounter8h_reg;
        reg [`XLEN-1:0] m_hpmcounter9h_reg;
        reg [`XLEN-1:0] m_hpmcounter10h_reg;
        reg [`XLEN-1:0] m_hpmcounter11h_reg;
        reg [`XLEN-1:0] m_hpmcounter12h_reg;
        reg [`XLEN-1:0] m_hpmcounter13h_reg;
        reg [`XLEN-1:0] m_hpmcounter14h_reg;
        reg [`XLEN-1:0] m_hpmcounter15h_reg;
        reg [`XLEN-1:0] m_hpmcounter16h_reg;
        reg [`XLEN-1:0] m_hpmcounter17h_reg;
        reg [`XLEN-1:0] m_hpmcounter18h_reg;
        reg [`XLEN-1:0] m_hpmcounter19h_reg;
        reg [`XLEN-1:0] m_hpmcounter20h_reg;
        reg [`XLEN-1:0] m_hpmcounter21h_reg;
        reg [`XLEN-1:0] m_hpmcounter22h_reg;
        reg [`XLEN-1:0] m_hpmcounter23h_reg;
        reg [`XLEN-1:0] m_hpmcounter24h_reg;
        reg [`XLEN-1:0] m_hpmcounter25h_reg;
        reg [`XLEN-1:0] m_hpmcounter26h_reg;
        reg [`XLEN-1:0] m_hpmcounter27h_reg;
        reg [`XLEN-1:0] m_hpmcounter28h_reg;
        reg [`XLEN-1:0] m_hpmcounter29h_reg;
        reg [`XLEN-1:0] m_hpmcounter30h_reg;
        reg [`XLEN-1:0] m_hpmcounter31h_reg;
    `endif
    
    // Machine Counter Setup
    reg [`XLEN-1:0] m_countinhibit_reg;
    reg [`XLEN-1:0] m_hpmevent3_reg;
    reg [`XLEN-1:0] m_hpmevent4_reg;
    reg [`XLEN-1:0] m_hpmevent5_reg;
    reg [`XLEN-1:0] m_hpmevent6_reg;
    reg [`XLEN-1:0] m_hpmevent7_reg;
    reg [`XLEN-1:0] m_hpmevent8_reg;
    reg [`XLEN-1:0] m_hpmevent9_reg;
    reg [`XLEN-1:0] m_hpmevent10_reg;
    reg [`XLEN-1:0] m_hpmevent11_reg;
    reg [`XLEN-1:0] m_hpmevent12_reg;
    reg [`XLEN-1:0] m_hpmevent13_reg;
    reg [`XLEN-1:0] m_hpmevent14_reg;
    reg [`XLEN-1:0] m_hpmevent15_reg;
    reg [`XLEN-1:0] m_hpmevent16_reg;
    reg [`XLEN-1:0] m_hpmevent17_reg;
    reg [`XLEN-1:0] m_hpmevent18_reg;
    reg [`XLEN-1:0] m_hpmevent19_reg;
    reg [`XLEN-1:0] m_hpmevent20_reg;
    reg [`XLEN-1:0] m_hpmevent21_reg;
    reg [`XLEN-1:0] m_hpmevent22_reg;
    reg [`XLEN-1:0] m_hpmevent23_reg;
    reg [`XLEN-1:0] m_hpmevent24_reg;
    reg [`XLEN-1:0] m_hpmevent25_reg;
    reg [`XLEN-1:0] m_hpmevent26_reg;
    reg [`XLEN-1:0] m_hpmevent27_reg;
    reg [`XLEN-1:0] m_hpmevent28_reg;
    reg [`XLEN-1:0] m_hpmevent29_reg;
    reg [`XLEN-1:0] m_hpmevent30_reg;
    reg [`XLEN-1:0] m_hpmevent31_reg;
    
    wire addr_match; // Signal for read & write address matching

//---------------------------------------------------------------------------------------//
// Address matching if write & read address
//---------------------------------------------------------------------------------------//
    assign addr_match = ((wr_en && rd_en) && (rd_addr == wr_addr)) ? 1'b1 : 1'b0; 

    //Write
    always @(posedge clk)begin
        if(!rst_n) 
            begin
            
            // Machine Information Registers
            m_vendorid_reg                  <= `DEF_M_VENDORID; 
            m_archid_reg                    <= `DEF_M_ARCHID;
            m_impid_reg                     <= `DEF_M_IMPID;
            m_hartid_reg                    <= `DEF_M_HARTID;
            m_configptr_reg                 <= `DEF_M_CONFIGPTR;
            m_status_reg                    <= `DEF_M_STATUS;
            m_isa_reg                       <= `DEF_M_ISA;
            m_edeleg_reg                    <= `DEF_M_EDELEG;
            m_ideleg_reg                    <= `DEF_M_IDELEG;
            m_ie_reg                        <= `DEF_M_IE;
            m_tvec_reg                      <= `DEF_M_TVEC;
            m_counteren_reg                 <= `DEF_M_COUNTEREN;
            `ifdef RV32
                m_scratch_reg               <= `DEF_M_SCRATCH;
            `endif
            
            // Machine Trap Setup Registers
            m_epc_reg                       <= `DEF_M_EPC;
            m_cause_reg                     <= `DEF_M_CAUSE;
            m_tval_reg                      <= `DEF_M_TVAL;
            m_ip_reg                        <= `DEF_M_IP;
            m_tinst_reg                     <= `DEF_M_TINST;
            m_tval2_reg                     <= `DEF_M_TVAL2;
            m_envcfg_reg                    <= `DEF_M_ENVCFG;
            m_seccfg_reg                    <= `DEF_M_SECCFG;
           `ifdef RV32
                m_envcfg_reg                <= `DEF_M_ENVCFGH;
                m_seccfg_reg                <= `DEF_M_SECCFGH;
           `endif
            
            // Machine Trap Handling Registers
            m_scratch_reg;                  <= `DEF_M_SCRATCH;
            m_epc_reg                       <= `DEF_M_EPC;
            m_cause_reg                     <= `DEF_M_CAUSE;
            m_tval_reg                      <= `DEF_M_TVAL;
            m_ip_reg                        <= `DEF_M_IP;
            m_tinst_reg                     <= `DEF_M_TINST;
            m_tval2_reg                     <= `DEF_M_TVAL2;
            
            // Machine Configuration Registers
            m_envcfg_reg                    <= `DEF_M_ENVCFG;
            m_seccfg_reg                    <= `DEF_M_SECCFG;
            `ifdef RV32
                m_envcfgh_reg               <= `DEF_M_ENVCFGH;
                m_seccfgh_reg               <= `DEF_M_SECCFGH;
            `endif

            // Machine Memory Protection Registers
            m_pmpcfg0_reg                   <= `DEF_M_PMPCFG0;
            m_pmpcfg2_reg                   <= `DEF_M_PMPCFG2;
            m_pmpcfg4_reg                   <= `DEF_M_PMPCFG4;
            m_pmpcfg6_reg                   <= `DEF_M_PMPCFG6;
            m_pmpcfg8_reg                   <= `DEF_M_PMPCFG8;
            m_pmpcfg10_reg                  <= `DEF_M_PMPCFG10;
            m_pmpcfg12_reg                  <= `DEF_M_PMPCFG12;
            m_pmpcfg14_reg                  <= `DEF_M_PMPCFG14;
            `ifdef RV32
                m_pmpcfg1_reg               <= `DEF_M_PMPCFG1;
                m_pmpcfg3_reg               <= `DEF_M_PMPCFG3;
                m_pmpcfg5_reg               <= `DEF_M_PMPCFG5;
                m_pmpcfg7_reg               <= `DEF_M_PMPCFG7;
                m_pmpcfg9_reg               <= `DEF_M_PMPCFG9;
                m_pmpcfg11_reg              <= `DEF_M_PMPCFG11;
                m_pmpcfg13_reg              <= `DEF_M_PMPCFG13;
                m_pmpcfg15_reg              <= `DEF_M_PMPCFG15;
            `endif
            
            m_pmpaddr3_reg                  <= `DEF_M_PMPADDR3;
            m_pmpaddr4_reg                  <= `DEF_M_PMPADDR4;
            m_pmpaddr5_reg                  <= `DEF_M_PMPADDR5;
            m_pmpaddr6_reg                  <= `DEF_M_PMPADDR6;
            m_pmpaddr7_reg                  <= `DEF_M_PMPADDR7;
            m_pmpaddr8_reg                  <= `DEF_M_PMPADDR8;
            m_pmpaddr9_reg                  <= `DEF_M_PMPADDR9;
            m_pmpaddr10_reg                 <= `DEF_M_PMPADDR10;
            m_pmpaddr11_reg                 <= `DEF_M_PMPADDR11;
            m_pmpaddr12_reg                 <= `DEF_M_PMPADDR12;
            m_pmpaddr13_reg                 <= `DEF_M_PMPADDR13;
            m_pmpaddr14_reg                 <= `DEF_M_PMPADDR14;
            m_pmpaddr15_reg                 <= `DEF_M_PMPADDR15;
            m_pmpaddr16_reg                 <= `DEF_M_PMPADDR16;
            m_pmpaddr17_reg                 <= `DEF_M_PMPADDR17;
            m_pmpaddr18_reg                 <= `DEF_M_PMPADDR18;
            m_pmpaddr19_reg                 <= `DEF_M_PMPADDR19;
            m_pmpaddr20_reg                 <= `DEF_M_PMPADDR20;
            m_pmpaddr21_reg                 <= `DEF_M_PMPADDR21;
            m_pmpaddr22_reg                 <= `DEF_M_PMPADDR22;
            m_pmpaddr23_reg                 <= `DEF_M_PMPADDR23;
            m_pmpaddr24_reg                 <= `DEF_M_PMPADDR23;
            m_pmpaddr25_reg                 <= `DEF_M_PMPADDR24;
            m_pmpaddr26_reg                 <= `DEF_M_PMPADDR25;
            m_pmpaddr27_reg                 <= `DEF_M_PMPADDR26;
            m_pmpaddr28_reg                 <= `DEF_M_PMPADDR27;
            m_pmpaddr29_reg                 <= `DEF_M_PMPADDR28;
            m_pmpaddr30_reg                 <= `DEF_M_PMPADDR29;
            m_pmpaddr31_reg                 <= `DEF_M_PMPADDR30;
            m_pmpaddr32_reg                 <= `DEF_M_PMPADDR31;
            m_pmpaddr33_reg                 <= `DEF_M_PMPADDR32;
            m_pmpaddr34_reg                 <= `DEF_M_PMPADDR33;
            m_pmpaddr35_reg                 <= `DEF_M_PMPADDR34;
            m_pmpaddr36_reg                 <= `DEF_M_PMPADDR35;
            m_pmpaddr37_reg                 <= `DEF_M_PMPADDR36;
            m_pmpaddr38_reg                 <= `DEF_M_PMPADDR37;
            m_pmpaddr39_reg                 <= `DEF_M_PMPADDR38;
            m_pmpaddr40_reg                 <= `DEF_M_PMPADDR39;
            m_pmpaddr41_reg                 <= `DEF_M_PMPADDR40;
            m_pmpaddr42_reg                 <= `DEF_M_PMPADDR41;
            m_pmpaddr43_reg                 <= `DEF_M_PMPADDR42;
            m_pmpaddr44_reg                 <= `DEF_M_PMPADDR43;
            m_pmpaddr45_reg                 <= `DEF_M_PMPADDR45;
            m_pmpaddr46_reg                 <= `DEF_M_PMPADDR46;
            m_pmpaddr47_reg                 <= `DEF_M_PMPADDR47;
            m_pmpaddr48_reg                 <= `DEF_M_PMPADDR48;
            m_pmpaddr49_reg                 <= `DEF_M_PMPADDR49;
            m_pmpaddr50_reg                 <= `DEF_M_PMPADDR50;
            m_pmpaddr51_reg                 <= `DEF_M_PMPADDR51;
            m_pmpaddr52_reg                 <= `DEF_M_PMPADDR52;
            m_pmpaddr53_reg                 <= `DEF_M_PMPADDR53;
            m_pmpaddr54_reg                 <= `DEF_M_PMPADDR54;
            m_pmpaddr55_reg                 <= `DEF_M_PMPADDR55;
            m_pmpaddr56_reg                 <= `DEF_M_PMPADDR56;
            m_pmpaddr57_reg                 <= `DEF_M_PMPADDR57;
            m_pmpaddr58_reg                 <= `DEF_M_PMPADDR58;
            m_pmpaddr59_reg                 <= `DEF_M_PMPADDR59;
            m_pmpaddr60_reg                 <= `DEF_M_PMPADDR60;
            m_pmpaddr61_reg                 <= `DEF_M_PMPADDR61;
            m_pmpaddr62_reg                 <= `DEF_M_PMPADDR62;
            m_pmpaddr63_reg                 <= `DEF_M_PMPADDR63;

            // Machine Counter/Timers
            m_cycle_reg                     <= `DEF_M_CYCLE;
            m_instret_reg                   <= `DEF_M_INSTRET;
            m_hpmcounter3_reg               <= `DEF_M_HPMCOUNTER3;
            m_hpmcounter4_reg               <= `DEF_M_HPMCOUNTER4;
            m_hpmcounter5_reg               <= `DEF_M_HPMCOUNTER5;
            m_hpmcounter6_reg               <= `DEF_M_HPMCOUNTER6;
            m_hpmcounter7_reg               <= `DEF_M_HPMCOUNTER7;
            m_hpmcounter8_reg               <= `DEF_M_HPMCOUNTER8; 
            m_hpmcounter9_reg               <= `DEF_M_HPMCOUNTER9; 
            m_hpmcounter10_reg              <= `DEF_M_HPMCOUNTER10;
            m_hpmcounter11_reg              <= `DEF_M_HPMCOUNTER11;
            m_hpmcounter12_reg              <= `DEF_M_HPMCOUNTER12;
            m_hpmcounter13_reg              <= `DEF_M_HPMCOUNTER13;
            m_hpmcounter14_reg              <= `DEF_M_HPMCOUNTER14;
            m_hpmcounter15_reg              <= `DEF_M_HPMCOUNTER15;
            m_hpmcounter16_reg              <= `DEF_M_HPMCOUNTER16;
            m_hpmcounter17_reg              <= `DEF_M_HPMCOUNTER17;
            m_hpmcounter18_reg              <= `DEF_M_HPMCOUNTER18;
            m_hpmcounter19_reg              <= `DEF_M_HPMCOUNTER19;
            m_hpmcounter20_reg              <= `DEF_M_HPMCOUNTER20;
            m_hpmcounter21_reg              <= `DEF_M_HPMCOUNTER21;
            m_hpmcounter22_reg              <= `DEF_M_HPMCOUNTER22;
            m_hpmcounter23_reg              <= `DEF_M_HPMCOUNTER23;
            m_hpmcounter24_reg              <= `DEF_M_HPMCOUNTER24;
            m_hpmcounter25_reg              <= `DEF_M_HPMCOUNTER25;
            m_hpmcounter26_reg              <= `DEF_M_HPMCOUNTER26;
            m_hpmcounter27_reg              <= `DEF_M_HPMCOUNTER27;
            m_hpmcounter28_reg              <= `DEF_M_HPMCOUNTER28;
            m_hpmcounter29_reg              <= `DEF_M_HPMCOUNTER29;
            m_hpmcounter30_reg              <= `DEF_M_HPMCOUNTER30;
            m_hpmcounter31_reg              <= `DEF_M_HPMCOUNTER31;
				`ifdef RV32
                m_cycleh_reg                <= `DEF_M_CYCLEH;
                m_hpmcounter3h_reg          <= `DEF_M_HPMCOUNTER3H;
                m_hpmcounter4h_reg          <= `DEF_M_HPMCOUNTER4H;
                m_hpmcounter5h_reg          <= `DEF_M_HPMCOUNTER5H;
                m_hpmcounter6h_reg          <= `DEF_M_HPMCOUNTER6H;
                m_hpmcounter7h_reg          <= `DEF_M_HPMCOUNTER7H;
                m_hpmcounter8h_reg          <= `DEF_M_HPMCOUNTER8H;
                m_hpmcounter9h_reg          <= `DEF_M_HPMCOUNTER9H;
                m_hpmcounter10h_reg         <= `DEF_M_HPMCOUNTER10H;
                m_hpmcounter11h_reg         <= `DEF_M_HPMCOUNTER11H;
                m_hpmcounter12h_reg         <= `DEF_M_HPMCOUNTER12H;
                m_hpmcounter13h_reg         <= `DEF_M_HPMCOUNTER13H;
                m_hpmcounter14h_reg         <= `DEF_M_HPMCOUNTER14H;
                m_hpmcounter15h_reg         <= `DEF_M_HPMCOUNTER15H;
                m_hpmcounter16h_reg         <= `DEF_M_HPMCOUNTER16H;
                m_hpmcounter17h_reg         <= `DEF_M_HPMCOUNTER17H;
                m_hpmcounter18h_reg         <= `DEF_M_HPMCOUNTER18H;
                m_hpmcounter19h_reg         <= `DEF_M_HPMCOUNTER19H;
                m_hpmcounter20h_reg         <= `DEF_M_HPMCOUNTER20H;
                m_hpmcounter21h_reg         <= `DEF_M_HPMCOUNTER21H;
                m_hpmcounter22h_reg         <= `DEF_M_HPMCOUNTER22H;
                m_hpmcounter23h_reg         <= `DEF_M_HPMCOUNTER23H;
                m_hpmcounter24h_reg         <= `DEF_M_HPMCOUNTER24H;
                m_hpmcounter25h_reg         <= `DEF_M_HPMCOUNTER25H;
                m_hpmcounter26h_reg         <= `DEF_M_HPMCOUNTER26H;
                m_hpmcounter27h_reg         <= `DEF_M_HPMCOUNTER27H;
                m_hpmcounter28h_reg         <= `DEF_M_HPMCOUNTER28H;
                m_hpmcounter29h_reg         <= `DEF_M_HPMCOUNTER29H;
                m_hpmcounter30h_reg         <= `DEF_M_HPMCOUNTER30H;
                m_hpmcounter31h_reg         <= `DEF_M_HPMCOUNTER31H;            
            `endif

            m_countinhibit_reg              <= `DEF_M_COUNTINHIBIT;
            m_hpmevent3_reg                 <= `DEF_M_HPMEVENT3;
            m_hpmevent4_reg                 <= `DEF_M_HPMEVENT4;
            m_hpmevent5_reg                 <= `DEF_M_HPMEVENT5;
            m_hpmevent6_reg                 <= `DEF_M_HPMEVENT6;
            m_hpmevent7_reg                 <= `DEF_M_HPMEVENT7;
            m_hpmevent8_reg                 <= `DEF_M_HPMEVENT8;
            m_hpmevent9_reg                 <= `DEF_M_HPMEVENT9;
            m_hpmevent10_reg                <= `DEF_M_HPMEVENT10;
            m_hpmevent11_reg                <= `DEF_M_HPMEVENT11;
            m_hpmevent12_reg                <= `DEF_M_HPMEVENT12;
            m_hpmevent13_reg                <= `DEF_M_HPMEVENT13;
            m_hpmevent14_reg                <= `DEF_M_HPMEVENT14;
            m_hpmevent15_reg                <= `DEF_M_HPMEVENT15;
            m_hpmevent16_reg                <= `DEF_M_HPMEVENT16;
            m_hpmevent17_reg                <= `DEF_M_HPMEVENT17;
            m_hpmevent18_reg                <= `DEF_M_HPMEVENT18;
            m_hpmevent19_reg                <= `DEF_M_HPMEVENT19;
            m_hpmevent20_reg                <= `DEF_M_HPMEVENT20;
            m_hpmevent21_reg                <= `DEF_M_HPMEVENT21;
            m_hpmevent22_reg                <= `DEF_M_HPMEVENT22;
            m_hpmevent23_reg                <= `DEF_M_HPMEVENT23;
            m_hpmevent24_reg                <= `DEF_M_HPMEVENT24;
            m_hpmevent25_reg                <= `DEF_M_HPMEVENT25;
            m_hpmevent26_reg                <= `DEF_M_HPMEVENT26;
            m_hpmevent27_reg                <= `DEF_M_HPMEVENT27;
            m_hpmevent28_reg                <= `DEF_M_HPMEVENT28;
            m_hpmevent29_reg                <= `DEF_M_HPMEVENT29;
            m_hpmevent30_reg                <= `DEF_M_HPMEVENT30;
            m_hpmevent31_reg                <= `DEF_M_HPMEVENT31;            
            end
        else
            begin
            if(wr_en)
                begin
                case(wr_addr)
                    `CSR_M_STATUS_ADDR              : m_status_reg              <= wr_data;
                    `CSR_M_ISA_ADDR                 : m_isa_reg                 <= wr_data;
                    `CSR_M_EDELEG_ADDR              : m_edeleg_reg              <= wr_data;
                    `CSR_M_IDELEG_ADDR              : m_ideleg_reg              <= wr_data;
                    `CSR_M_IE_ADDR                  : m_ie_reg                  <= wr_data;
                    `CSR_M_TVEC_ADDR                : m_tvec_reg                <= wr_data;
                    `CSR_M_COUNTEREN_ADDR           : m_counteren_reg           <= wr_data;
                    `CSR_M_SCRATCH_ADDR             : m_scratch_reg             <= wr_data;
                    `CSR_M_EPC_ADDR                 : m_epc_reg                 <= wr_data;
                    `CSR_M_CAUSE_ADDR               : m_cause_reg               <= wr_data;
                    `CSR_M_TVAL_ADDR                : m_tval_reg                <= wr_data;
                    `CSR_M_IP_ADDR                  : m_ip_reg                  <= wr_data;
                    `CSR_M_TINST                    : m_tinst_reg               <= wr_data;
                    `CSR_M_TVAL2                    : m_tval2_reg               <= wr_data;
                    `CSR_M_ENVCFG                   : m_envcfg                  <= wr_data;
                    `CSR_M_SECCFG                   : m_seccfg                  <= wr_data;
                    
                    `ifdef RV32
                        `CSR_M_STATUSH_ADDR         : m_statush_reg             <= wr_data; 
                        `CSR_M_ENVCFGH_ADDR         : m_envcfgh_reg             <= wr_data;
                        `CSR_M_SECCFGH_ADDR         : m_seccfgh_reg             <= wr_data;
                    `endif
                
                    `ifdef PHY_MEM_PROTECTION
                        `CSR_M_PMPCFG0_ADDR         : m_pmpcfg0_reg             <= wr_data;
                        `CSR_M_PMPCFG2_ADDR         : m_pmpcfg2_reg             <= wr_data;
                        `CSR_M_PMPCFG4_ADDR         : m_pmpcfg4_reg             <= wr_data;
                        `CSR_M_PMPCFG6_ADDR         : m_pmpcfg6_reg             <= wr_data;
                        `CSR_M_PMPCFG8_ADDR         : m_pmpcfg8_reg             <= wr_data;       
                        `CSR_M_PMPCFG10_ADDR        : m_pmpcfg10_reg            <= wr_data;      
                        `CSR_M_PMPCFG12_ADDR        : m_pmpcfg12_reg            <= wr_data;   
                        `CSR_M_PMPCFG14_ADDR        : m_pmpcfg14_reg            <= wr_data;   
                        `ifdef RV32
                            `CSR_M_PMPCFG1_ADDR     : m_pmpcfg1_reg             <= wr_data;
                            `CSR_M_PMPCFG3_ADDR     : m_pmpcfg3_reg             <= wr_data;
                            `CSR_M_PMPCFG5_ADDR     : m_pmpcfg5_reg             <= wr_data;
                            `CSR_M_PMPCFG7_ADDR     : m_pmpcfg7_reg             <= wr_data;
                            `CSR_M_PMPCFG9_ADDR     : m_pmpcfg9_reg             <= wr_data;
                            `CSR_M_PMPCFG11_ADDR    : m_pmpcfg11_reg            <= wr_data;
                            `CSR_M_PMPCFG13_ADDR    : m_pmpcfg13_reg            <= wr_data;
                            `CSR_M_PMPCFG15_ADDR    : m_pmpcfg15_reg            <= wr_data;
                        `endif
                   
                   `CSR_M_PMPADDR0                  : m_pmpaddr0_reg            <= wr_data; 
                   `CSR_M_PMPADDR1                  : m_pmpaddr1_reg            <= wr_data;
                   `CSR_M_PMPADDR2                  : m_pmpaddr2_reg            <= wr_data;
                   `CSR_M_PMPADDR3                  : m_pmpaddr3_reg            <= wr_data;
                   `CSR_M_PMPADDR4                  : m_pmpaddr4_reg            <= wr_data;
                   `CSR_M_PMPADDR5                  : m_pmpaddr5_reg            <= wr_data;
                   `CSR_M_PMPADDR6                  : m_pmpaddr6_reg            <= wr_data;
                   `CSR_M_PMPADDR7                  : m_pmpaddr7_reg            <= wr_data;
                   `CSR_M_PMPADDR8                  : m_pmpaddr8_reg            <= wr_data;
                   `CSR_M_PMPADDR9                  : m_pmpaddr9_reg            <= wr_data;
                   `CSR_M_PMPADDR10                 : m_pmpaddr10_reg           <= wr_data;
                   `CSR_M_PMPADDR11                 : m_pmpaddr11_reg           <= wr_data;
                   `CSR_M_PMPADDR12                 : m_pmpaddr12_reg           <= wr_data;
                   `CSR_M_PMPADDR13                 : m_pmpaddr13_reg           <= wr_data;
                   `CSR_M_PMPADDR14                 : m_pmpaddr14_reg           <= wr_data;
                   `CSR_M_PMPADDR15                 : m_pmpaddr15_reg           <= wr_data;
                   `CSR_M_PMPADDR16                 : m_pmpaddr16_reg           <= wr_data;
                   `CSR_M_PMPADDR17                 : m_pmpaddr17_reg           <= wr_data;
                   `CSR_M_PMPADDR18                 : m_pmpaddr18_reg           <= wr_data;
                   `CSR_M_PMPADDR19                 : m_pmpaddr19_reg           <= wr_data;
                   `CSR_M_PMPADDR20                 : m_pmpaddr20_reg           <= wr_data;
                   `CSR_M_PMPADDR21                 : m_pmpaddr21_reg           <= wr_data;
                   `CSR_M_PMPADDR22                 : m_pmpaddr22_reg           <= wr_data;
                   `CSR_M_PMPADDR23                 : m_pmpaddr23_reg           <= wr_data;
                   `CSR_M_PMPADDR24                 : m_pmpaddr24_reg           <= wr_data;
                   `CSR_M_PMPADDR25                 : m_pmpaddr25_reg           <= wr_data;
                   `CSR_M_PMPADDR26                 : m_pmpaddr26_reg           <= wr_data;
                   `CSR_M_PMPADDR27                 : m_pmpaddr27_reg           <= wr_data;
                   `CSR_M_PMPADDR28                 : m_pmpaddr28_reg           <= wr_data;
                   `CSR_M_PMPADDR29                 : m_pmpaddr29_reg           <= wr_data;
                   `CSR_M_PMPADDR30                 : m_pmpaddr30_reg           <= wr_data;            
                   `CSR_M_PMPADDR31                 : m_pmpaddr31_reg           <= wr_data;
                   `CSR_M_PMPADDR32                 : m_pmpaddr32_reg           <= wr_data;
                   `CSR_M_PMPADDR33                 : m_pmpaddr33_reg           <= wr_data;
                   `CSR_M_PMPADDR34                 : m_pmpaddr34_reg           <= wr_data;
                   `CSR_M_PMPADDR35                 : m_pmpaddr35_reg           <= wr_data;
                   `CSR_M_PMPADDR36                 : m_pmpaddr36_reg           <= wr_data;
                   `CSR_M_PMPADDR37                 : m_pmpaddr37_reg           <= wr_data;
                   `CSR_M_PMPADDR38                 : m_pmpaddr38_reg           <= wr_data;
                   `CSR_M_PMPADDR39                 : m_pmpaddr39_reg           <= wr_data;
                   `CSR_M_PMPADDR40                 : m_pmpaddr40_reg           <= wr_data;
                   `CSR_M_PMPADDR41                 : m_pmpaddr41_reg           <= wr_data;
                   `CSR_M_PMPADDR42                 : m_pmpaddr42_reg           <= wr_data;
                   `CSR_M_PMPADDR43                 : m_pmpaddr43_reg           <= wr_data;
                   `CSR_M_PMPADDR44                 : m_pmpaddr44_reg           <= wr_data;
                   `CSR_M_PMPADDR45                 : m_pmpaddr45_reg           <= wr_data;
                   `CSR_M_PMPADDR46                 : m_pmpaddr46_reg           <= wr_data;
                   `CSR_M_PMPADDR47                 : m_pmpaddr47_reg           <= wr_data;
                   `CSR_M_PMPADDR48                 : m_pmpaddr48_reg           <= wr_data;
                   `CSR_M_PMPADDR49                 : m_pmpaddr49_reg           <= wr_data;
                   `CSR_M_PMPADDR50                 : m_pmpaddr50_reg           <= wr_data;
                   `CSR_M_PMPADDR51                 : m_pmpaddr51_reg           <= wr_data;
                   `CSR_M_PMPADDR52                 : m_pmpaddr52_reg           <= wr_data;
                   `CSR_M_PMPADDR53                 : m_pmpaddr53_reg           <= wr_data;
                   `CSR_M_PMPADDR54                 : m_pmpaddr54_reg           <= wr_data;
                   `CSR_M_PMPADDR55                 : m_pmpaddr55_reg           <= wr_data;
                   `CSR_M_PMPADDR56                 : m_pmpaddr56_reg           <= wr_data;
                   `CSR_M_PMPADDR57                 : m_pmpaddr57_reg           <= wr_data;
                   `CSR_M_PMPADDR58                 : m_pmpaddr58_reg           <= wr_data;
                   `CSR_M_PMPADDR59                 : m_pmpaddr59_reg           <= wr_data;
                   `CSR_M_PMPADDR60                 : m_pmpaddr60_reg           <= wr_data;
                   `CSR_M_PMPADDR61                 : m_pmpaddr61_reg           <= wr_data;
                   `CSR_M_PMPADDR62                 : m_pmpaddr62_reg           <= wr_data;
                   `CSR_M_PMPADDR63                 : m_pmpaddr63_reg           <= wr_data;
                `endif
               
               `CSR_M_CYCLE                         : m_cycle_reg               <= wr_data;
               `CSR_M_INSTRET                       : m_instret_reg             <= wr_data;
               `CSR_M_HPMCOUNTER3                   : m_hpmcounter3_reg         <= wr_data;           
               `CSR_M_HPMCOUNTER4                   : m_hpmcounter4_reg         <= wr_data;
               `CSR_M_HPMCOUNTER5                   : m_hpmcounter5_reg         <= wr_data;
               `CSR_M_HPMCOUNTER6                   : m_hpmcounter6_reg         <= wr_data;
               `CSR_M_HPMCOUNTER7                   : m_hpmcounter7_reg         <= wr_data;
               `CSR_M_HPMCOUNTER8                   : m_hpmcounter8_reg         <= wr_data;
               `CSR_M_HPMCOUNTER9                   : m_hpmcounter9_reg         <= wr_data;
               `CSR_M_HPMCOUNTER10                  : m_hpmcounter10_reg        <= wr_data;
               `CSR_M_HPMCOUNTER11                  : m_hpmcounter11_reg        <= wr_data;
               `CSR_M_HPMCOUNTER12                  : m_hpmcounter12_reg        <= wr_data;
               `CSR_M_HPMCOUNTER13                  : m_hpmcounter13_reg        <= wr_data;
               `CSR_M_HPMCOUNTER14                  : m_hpmcounter14_reg        <= wr_data;
               `CSR_M_HPMCOUNTER15                  : m_hpmcounter15_reg        <= wr_data;
               `CSR_M_HPMCOUNTER16                  : m_hpmcounter16_reg        <= wr_data;
               `CSR_M_HPMCOUNTER17                  : m_hpmcounter17_reg        <= wr_data;
               `CSR_M_HPMCOUNTER18                  : m_hpmcounter18_reg        <= wr_data;
               `CSR_M_HPMCOUNTER19                  : m_hpmcounter19_reg        <= wr_data;
               `CSR_M_HPMCOUNTER20                  : m_hpmcounter20_reg        <= wr_data;
               `CSR_M_HPMCOUNTER21                  : m_hpmcounter21_reg        <= wr_data;
               `CSR_M_HPMCOUNTER22                  : m_hpmcounter22_reg        <= wr_data;
               `CSR_M_HPMCOUNTER23                  : m_hpmcounter23_reg        <= wr_data;
               `CSR_M_HPMCOUNTER24                  : m_hpmcounter24_reg        <= wr_data;
               `CSR_M_HPMCOUNTER25                  : m_hpmcounter25_reg        <= wr_data;
               `CSR_M_HPMCOUNTER26                  : m_hpmcounter26_reg        <= wr_data;
               `CSR_M_HPMCOUNTER27                  : m_hpmcounter27_reg        <= wr_data;
               `CSR_M_HPMCOUNTER28                  : m_hpmcounter28_reg        <= wr_data;
               `CSR_M_HPMCOUNTER29                  : m_hpmcounter29_reg        <= wr_data;
               `CSR_M_HPMCOUNTER30                  : m_hpmcounter30_reg        <= wr_data;
               `CSR_M_HPMCOUNTER31                  : m_hpmcounter31_reg        <= wr_data;
               
               `ifdef RV32
                   `CSR_M_CYCLEH                    : m_cycleh_reg              <= wr_data;
                   `CSR_M_INSTRETH                  : m_instreth_reg            <= wr_data;
                   `CSR_M_MPMCOUNTER3H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER4H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER5H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER6H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER7H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER8H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER9H              : m_hpmcounter3h_reg        <= wr_data;
                   `CSR_M_MPMCOUNTER10H             : m_hpmcounter10h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER11H             : m_hpmcounter11h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER12H             : m_hpmcounter12h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER13H             : m_hpmcounter13h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER14H             : m_hpmcounter14h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER15H             : m_hpmcounter15h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER16H             : m_hpmcounter16h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER17H             : m_hpmcounter17h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER18H             : m_hpmcounter18h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER19H             : m_hpmcounter19h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER20H             : m_hpmcounter10h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER21H             : m_hpmcounter21h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER22H             : m_hpmcounter22h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER23H             : m_hpmcounter23h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER24H             : m_hpmcounter24h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER25H             : m_hpmcounter25h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER26H             : m_hpmcounter26h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER27H             : m_hpmcounter27h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER28H             : m_hpmcounter28h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER29H             : m_hpmcounter29h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER30H             : m_hpmcounter30h_reg       <= wr_data;
                   `CSR_M_MPMCOUNTER31H             : m_hpmcounter31h_reg       <= wr_data;
               `endif
               `CSR_M_COUNTINHIBIT                  : m_countinhibit_reg        <= wr_data;
               `CSR_M_EVENT_3                       : m_event3_reg              <= wr_data;
               `CSR_M_EVENT_4                       : m_event4_reg              <= wr_data;
               `CSR_M_EVENT_5                       : m_event5_reg              <= wr_data;
               `CSR_M_EVENT_6                       : m_event6_reg              <= wr_data;
               `CSR_M_EVENT_7                       : m_event7_reg              <= wr_data;
               `CSR_M_EVENT_8                       : m_event8_reg              <= wr_data;
               `CSR_M_EVENT_9                       : m_event9_reg              <= wr_data;
               `CSR_M_EVENT_10                      : m_event10_reg             <= wr_data;
               `CSR_M_EVENT_11                      : m_event11_reg             <= wr_data;
               `CSR_M_EVENT_12                      : m_event12_reg             <= wr_data;
               `CSR_M_EVENT_13                      : m_event13_reg             <= wr_data;
               `CSR_M_EVENT_14                      : m_event14_reg             <= wr_data;
               `CSR_M_EVENT_15                      : m_event15_reg             <= wr_data;
               `CSR_M_EVENT_16                      : m_event16_reg             <= wr_data;
               `CSR_M_EVENT_17                      : m_event17_reg             <= wr_data;
               `CSR_M_EVENT_18                      : m_event18_reg             <= wr_data;
               `CSR_M_EVENT_19                      : m_event19_reg             <= wr_data;
               `CSR_M_EVENT_20                      : m_event20_reg             <= wr_data;
               `CSR_M_EVENT_21                      : m_event21_reg             <= wr_data;
               `CSR_M_EVENT_22                      : m_event22_reg             <= wr_data;
               `CSR_M_EVENT_23                      : m_event23_reg             <= wr_data;
               `CSR_M_EVENT_24                      : m_event24_reg             <= wr_data;
               `CSR_M_EVENT_25                      : m_event25_reg             <= wr_data;
               `CSR_M_EVENT_26                      : m_event26_reg             <= wr_data;
               `CSR_M_EVENT_27                      : m_event27_reg             <= wr_data;
               `CSR_M_EVENT_28                      : m_event28_reg             <= wr_data;
               `CSR_M_EVENT_29                      : m_event29_reg             <= wr_data;
               `CSR_M_EVENT_30                      : m_event30_reg             <= wr_data;
               `CSR_M_EVENT_31                      : m_event31_reg             <= wr_data;
                endcase
                end
            end
    end

    //Read
    always @(posedge clk)
        begin
            if(!rst) 
                begin
                rd_data       <= `MXLEN'h0000_0000;
                end
            else 
                begin
                if(addr_match && rd_en)
                    begin
                    rd_data <= wr_data;
                    end
                else if(rd_en)
                    begin
                    case(rd_addr)
                        `CSR_M_VENDORID_ADDR            : rd_data   <= m_vendorid_reg;
                        `CSR_M_ARCHID_ADDR              : rd_data   <= m_archid_reg;
                        `CSR_M_IMPID_ADDR               : rd_data   <= m_impid_reg;
                        `CSR_M_HARTID_ADDR              : rd_data   <= m_hartid_reg;
                        `CSR_M_CONFIGPTR_ADDR           : rd_data   <= m_configptr_reg;
                        `CSR_M_STATUS_ADDR              : rd_data   <= m_status_reg;
                        `CSR_M_ISA_ADDR                 : rd_data   <= m_isa_reg;
                        `CSR_M_EDELEG_ADDR              : rd_data   <= m_edeleg_reg;
                        `CSR_M_IDELEG_ADDR              : rd_data   <= m_ideleg_reg;
                        `CSR_M_IE_ADDR                  : rd_data   <= m_ie_reg;
                        `CSR_M_TVEC_ADDR                : rd_data   <= m_tvec_reg;
                        `CSR_M_COUNTEREN_ADDR           : rd_data   <= m_counteren_reg;
                        `CSR_M_SCRATCH_ADDR             : rd_data   <= m_scratch_reg;
                        `CSR_M_EPC_ADDR                 : rd_data   <= m_epc_reg;
                        `CSR_M_CAUSE_ADDR               : rd_data   <= m_cause_reg;
                        `CSR_M_TVAL_ADDR                : rd_data   <= m_tval_reg;
                        `CSR_M_IP_ADDR                  : rd_data   <= m_ip_reg;
                        `CSR_M_TINST                    : rd_data   <= m_tinst_reg;
                        `CSR_M_TVAL2                    : rd_data   <= m_tval2_reg;
                        `CSR_M_ENVCFG                   : rd_data   <= m_envcfg;
                        `CSR_M_SECCFG                   : rd_data   <= m_seccfg;
                        
                        `ifdef RV32
                            `CSR_M_STATUSH_ADDR         : rd_data   <= m_statush_reg; 
                            `CSR_M_ENVCFGH_ADDR         : rd_data   <= m_envcfgh_reg;
                            `CSR_M_SECCFGH_ADDR         : rd_data   <= m_seccfgh_reg;
                        `endif
                    
                        `ifdef PHY_MEM_PROTECTION
                            `CSR_M_PMPCFG0_ADDR         : rd_data   <= m_pmpcfg0_reg;
                            `CSR_M_PMPCFG2_ADDR         : rd_data   <= m_pmpcfg2_reg;
                            `CSR_M_PMPCFG4_ADDR         : rd_data   <= m_pmpcfg4_reg;
                            `CSR_M_PMPCFG6_ADDR         : rd_data   <= m_pmpcfg6_reg;
                            `CSR_M_PMPCFG8_ADDR         : rd_data   <= m_pmpcfg8_reg;       
                            `CSR_M_PMPCFG10_ADDR        : rd_data   <= m_pmpcfg10_reg;      
                            `CSR_M_PMPCFG12_ADDR        : rd_data   <= m_pmpcfg12_reg;   
                            `CSR_M_PMPCFG14_ADDR        : rd_data   <= m_pmpcfg14_reg;   
                            `ifdef RV32
                                `CSR_M_PMPCFG1_ADDR     : rd_data   <= m_pmpcfg1_reg;
                                `CSR_M_PMPCFG3_ADDR     : rd_data   <= m_pmpcfg3_reg;
                                `CSR_M_PMPCFG5_ADDR     : rd_data   <= m_pmpcfg5_reg;
                                `CSR_M_PMPCFG7_ADDR     : rd_data   <= m_pmpcfg7_reg;
                                `CSR_M_PMPCFG9_ADDR     : rd_data   <= m_pmpcfg9_reg;
                                `CSR_M_PMPCFG11_ADDR    : rd_data   <= m_pmpcfg11_reg;
                                `CSR_M_PMPCFG13_ADDR    : rd_data   <= m_pmpcfg13_reg;
                                `CSR_M_PMPCFG15_ADDR    : rd_data   <= m_pmpcfg15_reg;
                            `endif
                    
                            `CSR_M_PMPADDR0             : rd_data   <= m_pmpaddr0_reg; 
                            `CSR_M_PMPADDR1             : rd_data   <= m_pmpaddr1_reg;
                            `CSR_M_PMPADDR2             : rd_data   <= m_pmpaddr2_reg;
                            `CSR_M_PMPADDR3             : rd_data   <= m_pmpaddr3_reg;
                            `CSR_M_PMPADDR4             : rd_data   <= m_pmpaddr4_reg;
                            `CSR_M_PMPADDR5             : rd_data   <= m_pmpaddr5_reg;
                            `CSR_M_PMPADDR6             : rd_data   <= m_pmpaddr6_reg;
                            `CSR_M_PMPADDR7             : rd_data   <= m_pmpaddr7_reg;
                            `CSR_M_PMPADDR8             : rd_data   <= m_pmpaddr8_reg;
                            `CSR_M_PMPADDR9             : rd_data   <= m_pmpaddr9_reg;
                            `CSR_M_PMPADDR10            : rd_data   <= m_pmpaddr10_reg;
                            `CSR_M_PMPADDR11            : rd_data   <= m_pmpaddr11_reg;
                            `CSR_M_PMPADDR12            : rd_data   <= m_pmpaddr12_reg;
                            `CSR_M_PMPADDR13            : rd_data   <= m_pmpaddr13_reg;
                            `CSR_M_PMPADDR14            : rd_data   <= m_pmpaddr14_reg;
                            `CSR_M_PMPADDR15            : rd_data   <= m_pmpaddr15_reg;
                            `CSR_M_PMPADDR16            : rd_data   <= m_pmpaddr16_reg;
                            `CSR_M_PMPADDR17            : rd_data   <= m_pmpaddr17_reg;
                            `CSR_M_PMPADDR18            : rd_data   <= m_pmpaddr18_reg;
                            `CSR_M_PMPADDR19            : rd_data   <= m_pmpaddr19_reg;
                            `CSR_M_PMPADDR20            : rd_data   <= m_pmpaddr20_reg;
                            `CSR_M_PMPADDR21            : rd_data   <= m_pmpaddr21_reg;
                            `CSR_M_PMPADDR22            : rd_data   <= m_pmpaddr22_reg;
                            `CSR_M_PMPADDR23            : rd_data   <= m_pmpaddr23_reg;
                            `CSR_M_PMPADDR24            : rd_data   <= m_pmpaddr24_reg;
                            `CSR_M_PMPADDR25            : rd_data   <= m_pmpaddr25_reg;
                            `CSR_M_PMPADDR26            : rd_data   <= m_pmpaddr26_reg;
                            `CSR_M_PMPADDR27            : rd_data   <= m_pmpaddr27_reg;
                            `CSR_M_PMPADDR28            : rd_data   <= m_pmpaddr28_reg;
                            `CSR_M_PMPADDR29            : rd_data   <= m_pmpaddr29_reg;
                            `CSR_M_PMPADDR30            : rd_data   <= m_pmpaddr30_reg;            
                            `CSR_M_PMPADDR31            : rd_data   <= m_pmpaddr31_reg;
                            `CSR_M_PMPADDR32            : rd_data   <= m_pmpaddr32_reg;
                            `CSR_M_PMPADDR33            : rd_data   <= m_pmpaddr33_reg;
                            `CSR_M_PMPADDR34            : rd_data   <= m_pmpaddr34_reg;
                            `CSR_M_PMPADDR35            : rd_data   <= m_pmpaddr35_reg;
                            `CSR_M_PMPADDR36            : rd_data   <= m_pmpaddr36_reg;
                            `CSR_M_PMPADDR37            : rd_data   <= m_pmpaddr37_reg;
                            `CSR_M_PMPADDR38            : rd_data   <= m_pmpaddr38_reg;
                            `CSR_M_PMPADDR39            : rd_data   <= m_pmpaddr39_reg;
                            `CSR_M_PMPADDR40            : rd_data   <= m_pmpaddr40_reg;
                            `CSR_M_PMPADDR41            : rd_data   <= m_pmpaddr41_reg;
                            `CSR_M_PMPADDR42            : rd_data   <= m_pmpaddr42_reg;
                            `CSR_M_PMPADDR43            : rd_data   <= m_pmpaddr43_reg;
                            `CSR_M_PMPADDR44            : rd_data   <= m_pmpaddr44_reg;
                            `CSR_M_PMPADDR45            : rd_data   <= m_pmpaddr45_reg;
                            `CSR_M_PMPADDR46            : rd_data   <= m_pmpaddr46_reg;
                            `CSR_M_PMPADDR47            : rd_data   <= m_pmpaddr47_reg;
                            `CSR_M_PMPADDR48            : rd_data   <= m_pmpaddr48_reg;
                            `CSR_M_PMPADDR49            : rd_data   <= m_pmpaddr49_reg;
                            `CSR_M_PMPADDR50            : rd_data   <= m_pmpaddr50_reg;
                            `CSR_M_PMPADDR51            : rd_data   <= m_pmpaddr51_reg;
                            `CSR_M_PMPADDR52            : rd_data   <= m_pmpaddr52_reg;
                            `CSR_M_PMPADDR53            : rd_data   <= m_pmpaddr53_reg;
                            `CSR_M_PMPADDR54            : rd_data   <= m_pmpaddr54_reg;
                            `CSR_M_PMPADDR55            : rd_data   <= m_pmpaddr55_reg;
                            `CSR_M_PMPADDR56            : rd_data   <= m_pmpaddr56_reg;
                            `CSR_M_PMPADDR57            : rd_data   <= m_pmpaddr57_reg;
                            `CSR_M_PMPADDR58            : rd_data   <= m_pmpaddr58_reg;
                            `CSR_M_PMPADDR59            : rd_data   <= m_pmpaddr59_reg;
                            `CSR_M_PMPADDR60            : rd_data   <= m_pmpaddr60_reg;
                            `CSR_M_PMPADDR61            : rd_data   <= m_pmpaddr61_reg;
                            `CSR_M_PMPADDR62            : rd_data   <= m_pmpaddr62_reg;
                            `CSR_M_PMPADDR63            : rd_data   <= m_pmpaddr63_reg;
                            `endif
                    
                    `CSR_M_CYCLE                        : rd_data   <= m_cycle_reg;
                    `CSR_M_INSTRET                      : rd_data   <= m_instret_reg;
                    `CSR_M_HPMCOUNTER3                  : rd_data   <= m_hpmcounter3_reg;           
                    `CSR_M_HPMCOUNTER4                  : rd_data   <= m_hpmcounter4_reg;
                    `CSR_M_HPMCOUNTER5                  : rd_data   <= m_hpmcounter5_reg;
                    `CSR_M_HPMCOUNTER6                  : rd_data   <= m_hpmcounter6_reg;
                    `CSR_M_HPMCOUNTER7                  : rd_data   <= m_hpmcounter7_reg;
                    `CSR_M_HPMCOUNTER8                  : rd_data   <= m_hpmcounter8_reg;
                    `CSR_M_HPMCOUNTER9                  : rd_data   <= m_hpmcounter9_reg;
                    `CSR_M_HPMCOUNTER10                 : rd_data   <= m_hpmcounter10_reg;
                    `CSR_M_HPMCOUNTER11                 : rd_data   <= m_hpmcounter11_reg;
                    `CSR_M_HPMCOUNTER12                 : rd_data   <= m_hpmcounter12_reg;
                    `CSR_M_HPMCOUNTER13                 : rd_data   <= m_hpmcounter13_reg;
                    `CSR_M_HPMCOUNTER14                 : rd_data   <= m_hpmcounter14_reg;
                    `CSR_M_HPMCOUNTER15                 : rd_data   <= m_hpmcounter15_reg;
                    `CSR_M_HPMCOUNTER16                 : rd_data   <= m_hpmcounter16_reg;
                    `CSR_M_HPMCOUNTER17                 : rd_data   <= m_hpmcounter17_reg;
                    `CSR_M_HPMCOUNTER18                 : rd_data   <= m_hpmcounter18_reg;
                    `CSR_M_HPMCOUNTER19                 : rd_data   <= m_hpmcounter19_reg;
                    `CSR_M_HPMCOUNTER20                 : rd_data   <= m_hpmcounter20_reg;
                    `CSR_M_HPMCOUNTER21                 : rd_data   <= m_hpmcounter21_reg;
                    `CSR_M_HPMCOUNTER22                 : rd_data   <= m_hpmcounter22_reg;
                    `CSR_M_HPMCOUNTER23                 : rd_data   <= m_hpmcounter23_reg;
                    `CSR_M_HPMCOUNTER24                 : rd_data   <= m_hpmcounter24_reg;
                    `CSR_M_HPMCOUNTER25                 : rd_data   <= m_hpmcounter25_reg;
                    `CSR_M_HPMCOUNTER26                 : rd_data   <= m_hpmcounter26_reg;
                    `CSR_M_HPMCOUNTER27                 : rd_data   <= m_hpmcounter27_reg;
                    `CSR_M_HPMCOUNTER28                 : rd_data   <= m_hpmcounter28_reg;
                    `CSR_M_HPMCOUNTER29                 : rd_data   <= m_hpmcounter29_reg;
                    `CSR_M_HPMCOUNTER30                 : rd_data   <= m_hpmcounter30_reg;
                    `CSR_M_HPMCOUNTER31                 : rd_data   <= m_hpmcounter31_reg;
                    
                    `ifdef RV32
                        `CSR_M_CYCLEH                   : rd_data   <= m_cycleh_reg;
                        `CSR_M_INSTRETH                 : rd_data   <= m_instreth_reg;
                        `CSR_M_MPMCOUNTER3H             : rd_data   <= m_hpmcounter3h_reg;
                        `CSR_M_MPMCOUNTER4H             : rd_data   <= m_hpmcounter4h_reg;
                        `CSR_M_MPMCOUNTER5H             : rd_data   <= m_hpmcounter5h_reg;
                        `CSR_M_MPMCOUNTER6H             : rd_data   <= m_hpmcounter6h_reg;
                        `CSR_M_MPMCOUNTER7H             : rd_data   <= m_hpmcounter7h_reg;
                        `CSR_M_MPMCOUNTER8H             : rd_data   <= m_hpmcounter8h_reg;
                        `CSR_M_MPMCOUNTER9H             : rd_data   <= m_hpmcounter9h_reg;
                        `CSR_M_MPMCOUNTER10H            : rd_data   <= m_hpmcounter10h_reg;
                        `CSR_M_MPMCOUNTER11H            : rd_data   <= m_hpmcounter11h_reg;
                        `CSR_M_MPMCOUNTER12H            : rd_data   <= m_hpmcounter12h_reg;
                        `CSR_M_MPMCOUNTER13H            : rd_data   <= m_hpmcounter13h_reg;
                        `CSR_M_MPMCOUNTER14H            : rd_data   <= m_hpmcounter14h_reg;
                        `CSR_M_MPMCOUNTER15H            : rd_data   <= m_hpmcounter15h_reg;
                        `CSR_M_MPMCOUNTER16H            : rd_data   <= m_hpmcounter16h_reg;
                        `CSR_M_MPMCOUNTER17H            : rd_data   <= m_hpmcounter17h_reg;
                        `CSR_M_MPMCOUNTER18H            : rd_data   <= m_hpmcounter18h_reg;
                        `CSR_M_MPMCOUNTER19H            : rd_data   <= m_hpmcounter19h_reg;
                        `CSR_M_MPMCOUNTER20H            : rd_data   <= m_hpmcounter10h_reg;
                        `CSR_M_MPMCOUNTER21H            : rd_data   <= m_hpmcounter21h_reg;
                        `CSR_M_MPMCOUNTER22H            : rd_data   <= m_hpmcounter22h_reg;
                        `CSR_M_MPMCOUNTER23H            : rd_data   <= m_hpmcounter23h_reg;
                        `CSR_M_MPMCOUNTER24H            : rd_data   <= m_hpmcounter24h_reg;
                        `CSR_M_MPMCOUNTER25H            : rd_data   <= m_hpmcounter25h_reg;
                        `CSR_M_MPMCOUNTER26H            : rd_data   <= m_hpmcounter26h_reg;
                        `CSR_M_MPMCOUNTER27H            : rd_data   <= m_hpmcounter27h_reg;
                        `CSR_M_MPMCOUNTER28H            : rd_data   <= m_hpmcounter28h_reg;
                        `CSR_M_MPMCOUNTER29H            : rd_data   <= m_hpmcounter29h_reg;
                        `CSR_M_MPMCOUNTER30H            : rd_data   <= m_hpmcounter30h_reg;
                        `CSR_M_MPMCOUNTER31H            : rd_data   <= m_hpmcounter31h_reg;
                    `endif
                    `CSR_M_COUNTINHIBIT                 : rd_data   <= m_countinhibit_reg;
                    `CSR_M_EVENT_3                      : rd_data   <= m_event3_reg;
                    `CSR_M_EVENT_4                      : rd_data   <= m_event4_reg;
                    `CSR_M_EVENT_5                      : rd_data   <= m_event5_reg;
                    `CSR_M_EVENT_6                      : rd_data   <= m_event6_reg;
                    `CSR_M_EVENT_7                      : rd_data   <= m_event7_reg;
                    `CSR_M_EVENT_8                      : rd_data   <= m_event8_reg;
                    `CSR_M_EVENT_9                      : rd_data   <= m_event9_reg;
                    `CSR_M_EVENT_10                     : rd_data   <= m_event10_reg;
                    `CSR_M_EVENT_11                     : rd_data   <= m_event11_reg;
                    `CSR_M_EVENT_12                     : rd_data   <= m_event12_reg;
                    `CSR_M_EVENT_13                     : rd_data   <= m_event13_reg;
                    `CSR_M_EVENT_14                     : rd_data   <= m_event14_reg;
                    `CSR_M_EVENT_15                     : rd_data   <= m_event15_reg;
                    `CSR_M_EVENT_16                     : rd_data   <= m_event16_reg;
                    `CSR_M_EVENT_17                     : rd_data   <= m_event17_reg;
                    `CSR_M_EVENT_18                     : rd_data   <= m_event18_reg;
                    `CSR_M_EVENT_19                     : rd_data   <= m_event19_reg;
                    `CSR_M_EVENT_20                     : rd_data   <= m_event20_reg;
                    `CSR_M_EVENT_21                     : rd_data   <= m_event21_reg;
                    `CSR_M_EVENT_22                     : rd_data   <= m_event22_reg;
                    `CSR_M_EVENT_23                     : rd_data   <= m_event23_reg;
                    `CSR_M_EVENT_24                     : rd_data   <= m_event24_reg;
                    `CSR_M_EVENT_25                     : rd_data   <= m_event25_reg;
                    `CSR_M_EVENT_26                     : rd_data   <= m_event26_reg;
                    `CSR_M_EVENT_27                     : rd_data   <= m_event27_reg;
                    `CSR_M_EVENT_28                     : rd_data   <= m_event28_reg;
                    `CSR_M_EVENT_29                     : rd_data   <= m_event29_reg;
                    `CSR_M_EVENT_30                     : rd_data   <= m_event30_reg;
                    `CSR_M_EVENT_31                     : rd_data   <= m_event31_reg;
                    endcase
                    end
                else 
                    begin
                    rd_data <= wr_data;
                    end
                end
        end
endmodule




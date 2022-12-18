`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company              :
// Engineer             :
//
// Create Date          : 05.12.2021 12:48:12
// Design Name          :
// Module Name          : csr_regs
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

module csr_regs(
    input                           clk        , // System Clock
    input                           rst_n      , // System Reset
    input                           write_en   , // Write Enable
    input                           read_en    , // Read Enable
    input  [`CSR_BASE_WIDTH-1:0]    read_addr  , // Read address
    input  [`CSR_BASE_WIDTH-1:0]    write_addr , // Write address
    input  [`XLEN-1:0]              write_data , // Write data
    output [`XLEN-1:0]              read_data    // Read data
);

    reg [`XLEN-1:0]    read_data_reg ;
    wire addr_match; // Signal for read & write address matching

    // Machine Information Registers
    reg [`XLEN-1:0]       m_vendorid_reg       ;
    reg [`XLEN-1:0]       m_archid_reg         ;
    reg [`XLEN-1:0]       m_impid_reg          ;
    reg [`XLEN-1:0]       m_hartid_reg         ;
    reg [`XLEN-1:0]       m_configptr_reg      ;

    // Machine Trap Setup Registers
    reg [`XLEN-1:0]       m_status_reg         ;
    reg [`XLEN-1:0]       m_isa_reg            ;
    reg [`XLEN-1:0]       m_edeleg_reg         ;
    reg [`XLEN-1:0]       m_ideleg_reg         ;
    reg [`XLEN-1:0]       m_ie_reg             ;
    reg [`XLEN-1:0]       m_tvec_reg           ;
    reg [`XLEN-1:0]       m_counteren_reg      ;
    `ifdef RV32
        reg [`XLEN-1:0]       m_statush_reg    ;
    `endif

    // Machine Trap Handling Registers
    reg [`XLEN-1:0]       m_scratch_reg        ;
    reg [`XLEN-1:0]       m_epc_reg            ;
    reg [`XLEN-1:0]       m_cause_reg          ;
    reg [`XLEN-1:0]       m_tval_reg           ;
    reg [`XLEN-1:0]       m_ip_reg             ;
    reg [`XLEN-1:0]       m_tinst_reg          ;
    reg [`XLEN-1:0]       m_tval2_reg          ;

    // Machine Configuration Registers
    reg [`XLEN-1:0]       m_envcfg_reg         ;
    reg [`XLEN-1:0]       m_seccfg_reg         ;
    `ifdef RV32
        reg [`XLEN-1:0]       m_envcfgh_reg    ;
        reg [`XLEN-1:0]       m_seccfgh_reg    ;
    `endif

    // Machine Memory Protection Registers
    reg [`XLEN-1:0]    m_pmpcfg0_reg           ;
    reg [`XLEN-1:0]    m_pmpcfg2_reg           ;
    reg [`XLEN-1:0]    m_pmpcfg4_reg           ;
    reg [`XLEN-1:0]    m_pmpcfg6_reg           ;
    reg [`XLEN-1:0]    m_pmpcfg8_reg           ;
    reg [`XLEN-1:0]    m_pmpcfg10_reg          ;
    reg [`XLEN-1:0]    m_pmpcfg12_reg          ;
    reg [`XLEN-1:0]    m_pmpcfg14_reg          ;
    `ifdef RV32
        reg [`XLEN-1:0]    m_pmpcfg1_reg       ;
        reg [`XLEN-1:0]    m_pmpcfg3_reg       ;
        reg [`XLEN-1:0]    m_pmpcfg5_reg       ;
        reg [`XLEN-1:0]    m_pmpcfg7_reg       ;
        reg [`XLEN-1:0]    m_pmpcfg9_reg       ;
        reg [`XLEN-1:0]    m_pmpcfg11_reg      ;
        reg [`XLEN-1:0]    m_pmpcfg13_reg      ;
        reg [`XLEN-1:0]    m_pmpcfg15_reg      ;
    `endif

    reg [`XLEN-1:0]    m_pmpaddr0_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr1_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr2_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr3_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr4_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr5_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr6_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr7_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr8_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr9_reg          ;
    reg [`XLEN-1:0]    m_pmpaddr10_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr11_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr12_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr13_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr14_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr15_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr16_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr17_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr18_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr19_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr20_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr21_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr22_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr23_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr24_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr25_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr26_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr27_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr28_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr29_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr30_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr31_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr32_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr33_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr34_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr35_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr36_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr37_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr38_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr39_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr40_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr41_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr42_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr43_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr44_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr45_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr46_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr47_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr48_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr49_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr50_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr51_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr52_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr53_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr54_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr55_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr56_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr57_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr58_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr59_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr60_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr61_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr62_reg         ;
    reg [`XLEN-1:0]    m_pmpaddr63_reg         ;

    // Machine Counter/Timer Registers
    reg [`XLEN-1:0]    m_cycle_reg             ;
    reg [`XLEN-1:0]    m_instret_reg           ;
    reg [`XLEN-1:0]    m_hpmcounter3_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter4_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter5_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter6_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter7_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter8_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter9_reg       ;
    reg [`XLEN-1:0]    m_hpmcounter10_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter11_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter12_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter13_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter14_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter15_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter16_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter17_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter18_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter19_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter20_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter21_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter22_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter23_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter24_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter25_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter26_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter27_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter28_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter29_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter30_reg      ;
    reg [`XLEN-1:0]    m_hpmcounter31_reg      ;

    `ifdef RV32
        reg [`XLEN-1:0]    m_cycleh_reg        ;
        reg [`XLEN-1:0]    m_instreth_reg      ;
        reg [`XLEN-1:0]    m_hpmcounter3h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter4h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter5h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter6h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter7h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter8h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter9h_reg  ;
        reg [`XLEN-1:0]    m_hpmcounter10h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter11h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter12h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter13h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter14h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter15h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter16h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter17h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter18h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter19h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter20h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter21h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter22h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter23h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter24h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter25h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter26h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter27h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter28h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter29h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter30h_reg ;
        reg [`XLEN-1:0]    m_hpmcounter31h_reg ;
    `endif

    // Machine Counter Setup
    reg [`XLEN-1:0]    m_countinhibit_reg      ;
    reg [`XLEN-1:0]    m_hpmevent3_reg         ;
    reg [`XLEN-1:0]    m_hpmevent4_reg         ;
    reg [`XLEN-1:0]    m_hpmevent5_reg         ;
    reg [`XLEN-1:0]    m_hpmevent6_reg         ;
    reg [`XLEN-1:0]    m_hpmevent7_reg         ;
    reg [`XLEN-1:0]    m_hpmevent8_reg         ;
    reg [`XLEN-1:0]    m_hpmevent9_reg         ;
    reg [`XLEN-1:0]    m_hpmevent10_reg        ;
    reg [`XLEN-1:0]    m_hpmevent11_reg        ;
    reg [`XLEN-1:0]    m_hpmevent12_reg        ;
    reg [`XLEN-1:0]    m_hpmevent13_reg        ;
    reg [`XLEN-1:0]    m_hpmevent14_reg        ;
    reg [`XLEN-1:0]    m_hpmevent15_reg        ;
    reg [`XLEN-1:0]    m_hpmevent16_reg        ;
    reg [`XLEN-1:0]    m_hpmevent17_reg        ;
    reg [`XLEN-1:0]    m_hpmevent18_reg        ;
    reg [`XLEN-1:0]    m_hpmevent19_reg        ;
    reg [`XLEN-1:0]    m_hpmevent20_reg        ;
    reg [`XLEN-1:0]    m_hpmevent21_reg        ;
    reg [`XLEN-1:0]    m_hpmevent22_reg        ;
    reg [`XLEN-1:0]    m_hpmevent23_reg        ;
    reg [`XLEN-1:0]    m_hpmevent24_reg        ;
    reg [`XLEN-1:0]    m_hpmevent25_reg        ;
    reg [`XLEN-1:0]    m_hpmevent26_reg        ;
    reg [`XLEN-1:0]    m_hpmevent27_reg        ;
    reg [`XLEN-1:0]    m_hpmevent28_reg        ;
    reg [`XLEN-1:0]    m_hpmevent29_reg        ;
    reg [`XLEN-1:0]    m_hpmevent30_reg        ;
    reg [`XLEN-1:0]    m_hpmevent31_reg        ;

//---------------------------------------------------------------------------------------//
// Address matching if write & read address
//---------------------------------------------------------------------------------------//
    assign read_data = read_data_reg;
    assign addr_match = ((write_en && read_en) && (read_addr == write_addr)) ? 1'b1 : 1'b0;

    //Write
    always @(posedge clk)
          begin
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
            m_scratch_reg                   <= `DEF_M_SCRATCH;
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
            if(write_en)
                begin
                case(write_addr)
                    `CSR_M_STATUS_ADDR              : m_status_reg              <= write_data;
                    `CSR_M_ISA_ADDR                 : m_isa_reg                 <= write_data;
                    `CSR_M_EDELEG_ADDR              : m_edeleg_reg              <= write_data;
                    `CSR_M_IDELEG_ADDR              : m_ideleg_reg              <= write_data;
                    `CSR_M_IE_ADDR                  : m_ie_reg                  <= write_data;
                    `CSR_M_TVEC_ADDR                : m_tvec_reg                <= write_data;
                    `CSR_M_COUNTEREN_ADDR           : m_counteren_reg           <= write_data;
                    `CSR_M_SCRATCH_ADDR             : m_scratch_reg             <= write_data;
                    `CSR_M_EPC_ADDR                 : m_epc_reg                 <= write_data;
                    `CSR_M_CAUSE_ADDR               : m_cause_reg               <= write_data;
                    `CSR_M_TVAL_ADDR                : m_tval_reg                <= write_data;
                    `CSR_M_IP_ADDR                  : m_ip_reg                  <= write_data;
                    `CSR_M_TINST_ADDR               : m_tinst_reg               <= write_data;
                    `CSR_M_TVAL2_ADDR               : m_tval2_reg               <= write_data;
                    `CSR_M_ENVCFG_ADDR              : m_envcfg_reg              <= write_data;
                    `CSR_M_SECCFG_ADDR              : m_seccfg_reg              <= write_data;

                    `ifdef RV32
                        `CSR_M_STATUSH_ADDR         : m_statush_reg             <= write_data;
                        `CSR_M_ENVCFGH_ADDR         : m_envcfgh_reg             <= write_data;
                        `CSR_M_SECCFGH_ADDR         : m_seccfgh_reg             <= write_data;
                    `endif

                    `ifdef PHY_MEM_PROTECTION
                        `CSR_M_PMPCFG0_ADDR         : m_pmpcfg0_reg             <= write_data;
                        `CSR_M_PMPCFG2_ADDR         : m_pmpcfg2_reg             <= write_data;
                        `CSR_M_PMPCFG4_ADDR         : m_pmpcfg4_reg             <= write_data;
                        `CSR_M_PMPCFG6_ADDR         : m_pmpcfg6_reg             <= write_data;
                        `CSR_M_PMPCFG8_ADDR         : m_pmpcfg8_reg             <= write_data;
                        `CSR_M_PMPCFG10_ADDR        : m_pmpcfg10_reg            <= write_data;
                        `CSR_M_PMPCFG12_ADDR        : m_pmpcfg12_reg            <= write_data;
                        `CSR_M_PMPCFG14_ADDR        : m_pmpcfg14_reg            <= write_data;
                        `ifdef RV32
                            `CSR_M_PMPCFG1_ADDR     : m_pmpcfg1_reg             <= write_data;
                            `CSR_M_PMPCFG3_ADDR     : m_pmpcfg3_reg             <= write_data;
                            `CSR_M_PMPCFG5_ADDR     : m_pmpcfg5_reg             <= write_data;
                            `CSR_M_PMPCFG7_ADDR     : m_pmpcfg7_reg             <= write_data;
                            `CSR_M_PMPCFG9_ADDR     : m_pmpcfg9_reg             <= write_data;
                            `CSR_M_PMPCFG11_ADDR    : m_pmpcfg11_reg            <= write_data;
                            `CSR_M_PMPCFG13_ADDR    : m_pmpcfg13_reg            <= write_data;
                            `CSR_M_PMPCFG15_ADDR    : m_pmpcfg15_reg            <= write_data;
                        `endif

                   `CSR_M_PMPADDR0_ADDR             : m_pmpaddr0_reg            <= write_data;
                   `CSR_M_PMPADDR1_ADDR             : m_pmpaddr1_reg            <= write_data;
                   `CSR_M_PMPADDR2_ADDR             : m_pmpaddr2_reg            <= write_data;
                   `CSR_M_PMPADDR3_ADDR             : m_pmpaddr3_reg            <= write_data;
                   `CSR_M_PMPADDR4_ADDR             : m_pmpaddr4_reg            <= write_data;
                   `CSR_M_PMPADDR5_ADDR             : m_pmpaddr5_reg            <= write_data;
                   `CSR_M_PMPADDR6_ADDR             : m_pmpaddr6_reg            <= write_data;
                   `CSR_M_PMPADDR7_ADDR             : m_pmpaddr7_reg            <= write_data;
                   `CSR_M_PMPADDR8_ADDR             : m_pmpaddr8_reg            <= write_data;
                   `CSR_M_PMPADDR9_ADDR             : m_pmpaddr9_reg            <= write_data;
                   `CSR_M_PMPADDR10_ADDR            : m_pmpaddr10_reg           <= write_data;
                   `CSR_M_PMPADDR11_ADDR            : m_pmpaddr11_reg           <= write_data;
                   `CSR_M_PMPADDR12_ADDR            : m_pmpaddr12_reg           <= write_data;
                   `CSR_M_PMPADDR13_ADDR            : m_pmpaddr13_reg           <= write_data;
                   `CSR_M_PMPADDR14_ADDR            : m_pmpaddr14_reg           <= write_data;
                   `CSR_M_PMPADDR15_ADDR            : m_pmpaddr15_reg           <= write_data;
                   `CSR_M_PMPADDR16_ADDR            : m_pmpaddr16_reg           <= write_data;
                   `CSR_M_PMPADDR17_ADDR            : m_pmpaddr17_reg           <= write_data;
                   `CSR_M_PMPADDR18_ADDR            : m_pmpaddr18_reg           <= write_data;
                   `CSR_M_PMPADDR19_ADDR            : m_pmpaddr19_reg           <= write_data;
                   `CSR_M_PMPADDR20_ADDR            : m_pmpaddr20_reg           <= write_data;
                   `CSR_M_PMPADDR21_ADDR            : m_pmpaddr21_reg           <= write_data;
                   `CSR_M_PMPADDR22_ADDR            : m_pmpaddr22_reg           <= write_data;
                   `CSR_M_PMPADDR23_ADDR            : m_pmpaddr23_reg           <= write_data;
                   `CSR_M_PMPADDR24_ADDR            : m_pmpaddr24_reg           <= write_data;
                   `CSR_M_PMPADDR25_ADDR            : m_pmpaddr25_reg           <= write_data;
                   `CSR_M_PMPADDR26_ADDR            : m_pmpaddr26_reg           <= write_data;
                   `CSR_M_PMPADDR27_ADDR            : m_pmpaddr27_reg           <= write_data;
                   `CSR_M_PMPADDR28_ADDR            : m_pmpaddr28_reg           <= write_data;
                   `CSR_M_PMPADDR29_ADDR            : m_pmpaddr29_reg           <= write_data;
                   `CSR_M_PMPADDR30_ADDR            : m_pmpaddr30_reg           <= write_data;
                   `CSR_M_PMPADDR31_ADDR            : m_pmpaddr31_reg           <= write_data;
                   `CSR_M_PMPADDR32_ADDR            : m_pmpaddr32_reg           <= write_data;
                   `CSR_M_PMPADDR33_ADDR            : m_pmpaddr33_reg           <= write_data;
                   `CSR_M_PMPADDR34_ADDR            : m_pmpaddr34_reg           <= write_data;
                   `CSR_M_PMPADDR35_ADDR            : m_pmpaddr35_reg           <= write_data;
                   `CSR_M_PMPADDR36_ADDR            : m_pmpaddr36_reg           <= write_data;
                   `CSR_M_PMPADDR37_ADDR            : m_pmpaddr37_reg           <= write_data;
                   `CSR_M_PMPADDR38_ADDR            : m_pmpaddr38_reg           <= write_data;
                   `CSR_M_PMPADDR39_ADDR            : m_pmpaddr39_reg           <= write_data;
                   `CSR_M_PMPADDR40_ADDR            : m_pmpaddr40_reg           <= write_data;
                   `CSR_M_PMPADDR41_ADDR            : m_pmpaddr41_reg           <= write_data;
                   `CSR_M_PMPADDR42_ADDR            : m_pmpaddr42_reg           <= write_data;
                   `CSR_M_PMPADDR43_ADDR            : m_pmpaddr43_reg           <= write_data;
                   `CSR_M_PMPADDR44_ADDR            : m_pmpaddr44_reg           <= write_data;
                   `CSR_M_PMPADDR45_ADDR            : m_pmpaddr45_reg           <= write_data;
                   `CSR_M_PMPADDR46_ADDR            : m_pmpaddr46_reg           <= write_data;
                   `CSR_M_PMPADDR47_ADDR            : m_pmpaddr47_reg           <= write_data;
                   `CSR_M_PMPADDR48_ADDR            : m_pmpaddr48_reg           <= write_data;
                   `CSR_M_PMPADDR49_ADDR            : m_pmpaddr49_reg           <= write_data;
                   `CSR_M_PMPADDR50_ADDR            : m_pmpaddr50_reg           <= write_data;
                   `CSR_M_PMPADDR51_ADDR            : m_pmpaddr51_reg           <= write_data;
                   `CSR_M_PMPADDR52_ADDR            : m_pmpaddr52_reg           <= write_data;
                   `CSR_M_PMPADDR53_ADDR            : m_pmpaddr53_reg           <= write_data;
                   `CSR_M_PMPADDR54_ADDR            : m_pmpaddr54_reg           <= write_data;
                   `CSR_M_PMPADDR55_ADDR            : m_pmpaddr55_reg           <= write_data;
                   `CSR_M_PMPADDR56_ADDR            : m_pmpaddr56_reg           <= write_data;
                   `CSR_M_PMPADDR57_ADDR            : m_pmpaddr57_reg           <= write_data;
                   `CSR_M_PMPADDR58_ADDR            : m_pmpaddr58_reg           <= write_data;
                   `CSR_M_PMPADDR59_ADDR            : m_pmpaddr59_reg           <= write_data;
                   `CSR_M_PMPADDR60_ADDR            : m_pmpaddr60_reg           <= write_data;
                   `CSR_M_PMPADDR61_ADDR            : m_pmpaddr61_reg           <= write_data;
                   `CSR_M_PMPADDR62_ADDR            : m_pmpaddr62_reg           <= write_data;
                   `CSR_M_PMPADDR63_ADDR            : m_pmpaddr63_reg           <= write_data;
                `endif

               `CSR_M_CYCLE_ADDR                    : m_cycle_reg               <= write_data;
               `CSR_M_INSTRET_ADDR                  : m_instret_reg             <= write_data;
               `CSR_M_HPMCOUNTER3_ADDR              : m_hpmcounter3_reg         <= write_data;
               `CSR_M_HPMCOUNTER4_ADDR              : m_hpmcounter4_reg         <= write_data;
               `CSR_M_HPMCOUNTER5_ADDR              : m_hpmcounter5_reg         <= write_data;
               `CSR_M_HPMCOUNTER6_ADDR              : m_hpmcounter6_reg         <= write_data;
               `CSR_M_HPMCOUNTER7_ADDR              : m_hpmcounter7_reg         <= write_data;
               `CSR_M_HPMCOUNTER8_ADDR              : m_hpmcounter8_reg         <= write_data;
               `CSR_M_HPMCOUNTER9_ADDR              : m_hpmcounter9_reg         <= write_data;
               `CSR_M_HPMCOUNTER10_ADDR             : m_hpmcounter10_reg        <= write_data;
               `CSR_M_HPMCOUNTER11_ADDR             : m_hpmcounter11_reg        <= write_data;
               `CSR_M_HPMCOUNTER12_ADDR             : m_hpmcounter12_reg        <= write_data;
               `CSR_M_HPMCOUNTER13_ADDR             : m_hpmcounter13_reg        <= write_data;
               `CSR_M_HPMCOUNTER14_ADDR             : m_hpmcounter14_reg        <= write_data;
               `CSR_M_HPMCOUNTER15_ADDR             : m_hpmcounter15_reg        <= write_data;
               `CSR_M_HPMCOUNTER16_ADDR             : m_hpmcounter16_reg        <= write_data;
               `CSR_M_HPMCOUNTER17_ADDR             : m_hpmcounter17_reg        <= write_data;
               `CSR_M_HPMCOUNTER18_ADDR             : m_hpmcounter18_reg        <= write_data;
               `CSR_M_HPMCOUNTER19_ADDR             : m_hpmcounter19_reg        <= write_data;
               `CSR_M_HPMCOUNTER20_ADDR             : m_hpmcounter20_reg        <= write_data;
               `CSR_M_HPMCOUNTER21_ADDR             : m_hpmcounter21_reg        <= write_data;
               `CSR_M_HPMCOUNTER22_ADDR             : m_hpmcounter22_reg        <= write_data;
               `CSR_M_HPMCOUNTER23_ADDR             : m_hpmcounter23_reg        <= write_data;
               `CSR_M_HPMCOUNTER24_ADDR             : m_hpmcounter24_reg        <= write_data;
               `CSR_M_HPMCOUNTER25_ADDR             : m_hpmcounter25_reg        <= write_data;
               `CSR_M_HPMCOUNTER26_ADDR             : m_hpmcounter26_reg        <= write_data;
               `CSR_M_HPMCOUNTER27_ADDR             : m_hpmcounter27_reg        <= write_data;
               `CSR_M_HPMCOUNTER28_ADDR             : m_hpmcounter28_reg        <= write_data;
               `CSR_M_HPMCOUNTER29_ADDR             : m_hpmcounter29_reg        <= write_data;
               `CSR_M_HPMCOUNTER30_ADDR             : m_hpmcounter30_reg        <= write_data;
               `CSR_M_HPMCOUNTER31_ADDR             : m_hpmcounter31_reg        <= write_data;

               `ifdef RV32
                   `CSR_M_CYCLEH_ADDR               : m_cycleh_reg              <= write_data;
                   `CSR_M_INSTRETH_ADDR             : m_instreth_reg            <= write_data;
                   `CSR_M_HPMCOUNTER3H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER4H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER5H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER6H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER7H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER8H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER9H_ADDR         : m_hpmcounter3h_reg        <= write_data;
                   `CSR_M_HPMCOUNTER10H_ADDR        : m_hpmcounter10h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER11H_ADDR        : m_hpmcounter11h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER12H_ADDR        : m_hpmcounter12h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER13H_ADDR        : m_hpmcounter13h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER14H_ADDR        : m_hpmcounter14h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER15H_ADDR        : m_hpmcounter15h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER16H_ADDR        : m_hpmcounter16h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER17H_ADDR        : m_hpmcounter17h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER18H_ADDR        : m_hpmcounter18h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER19H_ADDR        : m_hpmcounter19h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER20H_ADDR        : m_hpmcounter10h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER21H_ADDR        : m_hpmcounter21h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER22H_ADDR        : m_hpmcounter22h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER23H_ADDR        : m_hpmcounter23h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER24H_ADDR        : m_hpmcounter24h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER25H_ADDR        : m_hpmcounter25h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER26H_ADDR        : m_hpmcounter26h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER27H_ADDR        : m_hpmcounter27h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER28H_ADDR        : m_hpmcounter28h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER29H_ADDR        : m_hpmcounter29h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER30H_ADDR        : m_hpmcounter30h_reg       <= write_data;
                   `CSR_M_HPMCOUNTER31H_ADDR        : m_hpmcounter31h_reg       <= write_data;
               `endif
               `CSR_M_COUNTINHIBIT_ADDR             : m_countinhibit_reg        <= write_data;
               `CSR_M_HPMEVENT3_ADDR                : m_hpmevent3_reg           <= write_data;
               `CSR_M_HPMEVENT4_ADDR                : m_hpmevent4_reg           <= write_data;
               `CSR_M_HPMEVENT5_ADDR                : m_hpmevent5_reg           <= write_data;
               `CSR_M_HPMEVENT6_ADDR                : m_hpmevent6_reg           <= write_data;
               `CSR_M_HPMEVENT7_ADDR                : m_hpmevent7_reg           <= write_data;
               `CSR_M_HPMEVENT8_ADDR                : m_hpmevent8_reg           <= write_data;
               `CSR_M_HPMEVENT9_ADDR                : m_hpmevent9_reg           <= write_data;
               `CSR_M_HPMEVENT10_ADDR               : m_hpmevent10_reg          <= write_data;
               `CSR_M_HPMEVENT11_ADDR               : m_hpmevent11_reg          <= write_data;
               `CSR_M_HPMEVENT12_ADDR               : m_hpmevent12_reg          <= write_data;
               `CSR_M_HPMEVENT13_ADDR               : m_hpmevent13_reg          <= write_data;
               `CSR_M_HPMEVENT14_ADDR               : m_hpmevent14_reg          <= write_data;
               `CSR_M_HPMEVENT15_ADDR               : m_hpmevent15_reg          <= write_data;
               `CSR_M_HPMEVENT16_ADDR               : m_hpmevent16_reg          <= write_data;
               `CSR_M_HPMEVENT17_ADDR               : m_hpmevent17_reg          <= write_data;
               `CSR_M_HPMEVENT18_ADDR               : m_hpmevent18_reg          <= write_data;
               `CSR_M_HPMEVENT19_ADDR               : m_hpmevent19_reg          <= write_data;
               `CSR_M_HPMEVENT20_ADDR               : m_hpmevent20_reg          <= write_data;
               `CSR_M_HPMEVENT21_ADDR               : m_hpmevent21_reg          <= write_data;
               `CSR_M_HPMEVENT22_ADDR               : m_hpmevent22_reg          <= write_data;
               `CSR_M_HPMEVENT23_ADDR               : m_hpmevent23_reg          <= write_data;
               `CSR_M_HPMEVENT24_ADDR               : m_hpmevent24_reg          <= write_data;
               `CSR_M_HPMEVENT25_ADDR               : m_hpmevent25_reg          <= write_data;
               `CSR_M_HPMEVENT26_ADDR               : m_hpmevent26_reg          <= write_data;
               `CSR_M_HPMEVENT27_ADDR               : m_hpmevent27_reg          <= write_data;
               `CSR_M_HPMEVENT28_ADDR               : m_hpmevent28_reg          <= write_data;
               `CSR_M_HPMEVENT29_ADDR               : m_hpmevent29_reg          <= write_data;
               `CSR_M_HPMEVENT30_ADDR               : m_hpmevent30_reg          <= write_data;
               `CSR_M_HPMEVENT31_ADDR               : m_hpmevent31_reg          <= write_data;
               endcase
               end
            end
            end

    //Read
    always @(posedge clk)
        begin
            if(!rst_n)
                begin
                read_data_reg       <= 32'h0000_0000;
                end
            else
                begin
                if(read_en)
                    begin
                    if(addr_match)
                        begin
                        read_data_reg <= write_data;
                        end
                    else
                        begin
                        case(read_addr)
                            `CSR_M_VENDORID_ADDR            : read_data_reg   <= m_vendorid_reg;
                            `CSR_M_ARCHID_ADDR              : read_data_reg   <= m_archid_reg;
                            `CSR_M_IMPID_ADDR               : read_data_reg   <= m_impid_reg;
                            `CSR_M_HARTID_ADDR              : read_data_reg   <= m_hartid_reg;
                            `CSR_M_CONFIGPTR_ADDR           : read_data_reg   <= m_configptr_reg;
                            `CSR_M_STATUS_ADDR              : read_data_reg   <= m_status_reg;
                            `CSR_M_ISA_ADDR                 : read_data_reg   <= m_isa_reg;
                            `CSR_M_EDELEG_ADDR              : read_data_reg   <= m_edeleg_reg;
                            `CSR_M_IDELEG_ADDR              : read_data_reg   <= m_ideleg_reg;
                            `CSR_M_IE_ADDR                  : read_data_reg   <= m_ie_reg;
                            `CSR_M_TVEC_ADDR                : read_data_reg   <= m_tvec_reg;
                            `CSR_M_COUNTEREN_ADDR           : read_data_reg   <= m_counteren_reg;
                            `CSR_M_SCRATCH_ADDR             : read_data_reg   <= m_scratch_reg;
                            `CSR_M_EPC_ADDR                 : read_data_reg   <= m_epc_reg;
                            `CSR_M_CAUSE_ADDR               : read_data_reg   <= m_cause_reg;
                            `CSR_M_TVAL_ADDR                : read_data_reg   <= m_tval_reg;
                            `CSR_M_IP_ADDR                  : read_data_reg   <= m_ip_reg;
                            `CSR_M_TINST_ADDR               : read_data_reg   <= m_tinst_reg;
                            `CSR_M_TVAL2_ADDR               : read_data_reg   <= m_tval2_reg;
                            `CSR_M_ENVCFG_ADDR              : read_data_reg   <= m_envcfg_reg;
                            `CSR_M_SECCFG_ADDR              : read_data_reg   <= m_seccfg_reg;

                            `ifdef RV32
                                `CSR_M_STATUSH_ADDR         : read_data_reg   <= m_statush_reg;
                                `CSR_M_ENVCFGH_ADDR         : read_data_reg   <= m_envcfgh_reg;
                                `CSR_M_SECCFGH_ADDR         : read_data_reg   <= m_seccfgh_reg;
                            `endif

                            `ifdef PHY_MEM_PROTECTION
                                `CSR_M_PMPCFG0_ADDR         : read_data_reg   <= m_pmpcfg0_reg;
                                `CSR_M_PMPCFG2_ADDR         : read_data_reg   <= m_pmpcfg2_reg;
                                `CSR_M_PMPCFG4_ADDR         : read_data_reg   <= m_pmpcfg4_reg;
                                `CSR_M_PMPCFG6_ADDR         : read_data_reg   <= m_pmpcfg6_reg;
                                `CSR_M_PMPCFG8_ADDR         : read_data_reg   <= m_pmpcfg8_reg;
                                `CSR_M_PMPCFG10_ADDR        : read_data_reg   <= m_pmpcfg10_reg;
                                `CSR_M_PMPCFG12_ADDR        : read_data_reg   <= m_pmpcfg12_reg;
                                `CSR_M_PMPCFG14_ADDR        : read_data_reg   <= m_pmpcfg14_reg;
                                `ifdef RV32
                                    `CSR_M_PMPCFG1_ADDR     : read_data_reg   <= m_pmpcfg1_reg;
                                    `CSR_M_PMPCFG3_ADDR     : read_data_reg   <= m_pmpcfg3_reg;
                                    `CSR_M_PMPCFG5_ADDR     : read_data_reg   <= m_pmpcfg5_reg;
                                    `CSR_M_PMPCFG7_ADDR     : read_data_reg   <= m_pmpcfg7_reg;
                                    `CSR_M_PMPCFG9_ADDR     : read_data_reg   <= m_pmpcfg9_reg;
                                    `CSR_M_PMPCFG11_ADDR    : read_data_reg   <= m_pmpcfg11_reg;
                                    `CSR_M_PMPCFG13_ADDR    : read_data_reg   <= m_pmpcfg13_reg;
                                    `CSR_M_PMPCFG15_ADDR    : read_data_reg   <= m_pmpcfg15_reg;
                                `endif

                                `CSR_M_PMPADDR0_ADDR        : read_data_reg   <= m_pmpaddr0_reg;
                                `CSR_M_PMPADDR1_ADDR        : read_data_reg   <= m_pmpaddr1_reg;
                                `CSR_M_PMPADDR2_ADDR        : read_data_reg   <= m_pmpaddr2_reg;
                                `CSR_M_PMPADDR3_ADDR        : read_data_reg   <= m_pmpaddr3_reg;
                                `CSR_M_PMPADDR4_ADDR        : read_data_reg   <= m_pmpaddr4_reg;
                                `CSR_M_PMPADDR5_ADDR        : read_data_reg   <= m_pmpaddr5_reg;
                                `CSR_M_PMPADDR6_ADDR        : read_data_reg   <= m_pmpaddr6_reg;
                                `CSR_M_PMPADDR7_ADDR        : read_data_reg   <= m_pmpaddr7_reg;
                                `CSR_M_PMPADDR8_ADDR        : read_data_reg   <= m_pmpaddr8_reg;
                                `CSR_M_PMPADDR9_ADDR        : read_data_reg   <= m_pmpaddr9_reg;
                                `CSR_M_PMPADDR10_ADDR       : read_data_reg   <= m_pmpaddr10_reg;
                                `CSR_M_PMPADDR11_ADDR       : read_data_reg   <= m_pmpaddr11_reg;
                                `CSR_M_PMPADDR12_ADDR       : read_data_reg   <= m_pmpaddr12_reg;
                                `CSR_M_PMPADDR13_ADDR       : read_data_reg   <= m_pmpaddr13_reg;
                                `CSR_M_PMPADDR14_ADDR       : read_data_reg   <= m_pmpaddr14_reg;
                                `CSR_M_PMPADDR15_ADDR       : read_data_reg   <= m_pmpaddr15_reg;
                                `CSR_M_PMPADDR16_ADDR       : read_data_reg   <= m_pmpaddr16_reg;
                                `CSR_M_PMPADDR17_ADDR       : read_data_reg   <= m_pmpaddr17_reg;
                                `CSR_M_PMPADDR18_ADDR       : read_data_reg   <= m_pmpaddr18_reg;
                                `CSR_M_PMPADDR19_ADDR       : read_data_reg   <= m_pmpaddr19_reg;
                                `CSR_M_PMPADDR20_ADDR       : read_data_reg   <= m_pmpaddr20_reg;
                                `CSR_M_PMPADDR21_ADDR       : read_data_reg   <= m_pmpaddr21_reg;
                                `CSR_M_PMPADDR22_ADDR       : read_data_reg   <= m_pmpaddr22_reg;
                                `CSR_M_PMPADDR23_ADDR       : read_data_reg   <= m_pmpaddr23_reg;
                                `CSR_M_PMPADDR24_ADDR       : read_data_reg   <= m_pmpaddr24_reg;
                                `CSR_M_PMPADDR25_ADDR       : read_data_reg   <= m_pmpaddr25_reg;
                                `CSR_M_PMPADDR26_ADDR       : read_data_reg   <= m_pmpaddr26_reg;
                                `CSR_M_PMPADDR27_ADDR       : read_data_reg   <= m_pmpaddr27_reg;
                                `CSR_M_PMPADDR28_ADDR       : read_data_reg   <= m_pmpaddr28_reg;
                                `CSR_M_PMPADDR29_ADDR       : read_data_reg   <= m_pmpaddr29_reg;
                                `CSR_M_PMPADDR30_ADDR       : read_data_reg   <= m_pmpaddr30_reg;
                                `CSR_M_PMPADDR31_ADDR       : read_data_reg   <= m_pmpaddr31_reg;
                                `CSR_M_PMPADDR32_ADDR       : read_data_reg   <= m_pmpaddr32_reg;
                                `CSR_M_PMPADDR33_ADDR       : read_data_reg   <= m_pmpaddr33_reg;
                                `CSR_M_PMPADDR34_ADDR       : read_data_reg   <= m_pmpaddr34_reg;
                                `CSR_M_PMPADDR35_ADDR       : read_data_reg   <= m_pmpaddr35_reg;
                                `CSR_M_PMPADDR36_ADDR       : read_data_reg   <= m_pmpaddr36_reg;
                                `CSR_M_PMPADDR37_ADDR       : read_data_reg   <= m_pmpaddr37_reg;
                                `CSR_M_PMPADDR38_ADDR       : read_data_reg   <= m_pmpaddr38_reg;
                                `CSR_M_PMPADDR39_ADDR       : read_data_reg   <= m_pmpaddr39_reg;
                                `CSR_M_PMPADDR40_ADDR       : read_data_reg   <= m_pmpaddr40_reg;
                                `CSR_M_PMPADDR41_ADDR       : read_data_reg   <= m_pmpaddr41_reg;
                                `CSR_M_PMPADDR42_ADDR       : read_data_reg   <= m_pmpaddr42_reg;
                                `CSR_M_PMPADDR43_ADDR       : read_data_reg   <= m_pmpaddr43_reg;
                                `CSR_M_PMPADDR44_ADDR       : read_data_reg   <= m_pmpaddr44_reg;
                                `CSR_M_PMPADDR45_ADDR       : read_data_reg   <= m_pmpaddr45_reg;
                                `CSR_M_PMPADDR46_ADDR       : read_data_reg   <= m_pmpaddr46_reg;
                                `CSR_M_PMPADDR47_ADDR       : read_data_reg   <= m_pmpaddr47_reg;
                                `CSR_M_PMPADDR48_ADDR       : read_data_reg   <= m_pmpaddr48_reg;
                                `CSR_M_PMPADDR49_ADDR       : read_data_reg   <= m_pmpaddr49_reg;
                                `CSR_M_PMPADDR50_ADDR       : read_data_reg   <= m_pmpaddr50_reg;
                                `CSR_M_PMPADDR51_ADDR       : read_data_reg   <= m_pmpaddr51_reg;
                                `CSR_M_PMPADDR52_ADDR       : read_data_reg   <= m_pmpaddr52_reg;
                                `CSR_M_PMPADDR53_ADDR       : read_data_reg   <= m_pmpaddr53_reg;
                                `CSR_M_PMPADDR54_ADDR       : read_data_reg   <= m_pmpaddr54_reg;
                                `CSR_M_PMPADDR55_ADDR       : read_data_reg   <= m_pmpaddr55_reg;
                                `CSR_M_PMPADDR56_ADDR       : read_data_reg   <= m_pmpaddr56_reg;
                                `CSR_M_PMPADDR57_ADDR       : read_data_reg   <= m_pmpaddr57_reg;
                                `CSR_M_PMPADDR58_ADDR       : read_data_reg   <= m_pmpaddr58_reg;
                                `CSR_M_PMPADDR59_ADDR       : read_data_reg   <= m_pmpaddr59_reg;
                                `CSR_M_PMPADDR60_ADDR       : read_data_reg   <= m_pmpaddr60_reg;
                                `CSR_M_PMPADDR61_ADDR       : read_data_reg   <= m_pmpaddr61_reg;
                                `CSR_M_PMPADDR62_ADDR       : read_data_reg   <= m_pmpaddr62_reg;
                                `CSR_M_PMPADDR63_ADDR       : read_data_reg   <= m_pmpaddr63_reg;
                                `endif
                        `CSR_M_CYCLE_ADDR                   : read_data_reg   <= m_cycle_reg;
                        `CSR_M_INSTRET_ADDR                 : read_data_reg   <= m_instret_reg;
                        `CSR_M_HPMCOUNTER3_ADDR             : read_data_reg   <= m_hpmcounter3_reg;
                        `CSR_M_HPMCOUNTER4_ADDR             : read_data_reg   <= m_hpmcounter4_reg;
                        `CSR_M_HPMCOUNTER5_ADDR             : read_data_reg   <= m_hpmcounter5_reg;
                        `CSR_M_HPMCOUNTER6_ADDR             : read_data_reg   <= m_hpmcounter6_reg;
                        `CSR_M_HPMCOUNTER7_ADDR             : read_data_reg   <= m_hpmcounter7_reg;
                        `CSR_M_HPMCOUNTER8_ADDR             : read_data_reg   <= m_hpmcounter8_reg;
                        `CSR_M_HPMCOUNTER9_ADDR             : read_data_reg   <= m_hpmcounter9_reg;
                        `CSR_M_HPMCOUNTER10_ADDR            : read_data_reg   <= m_hpmcounter10_reg;
                        `CSR_M_HPMCOUNTER11_ADDR            : read_data_reg   <= m_hpmcounter11_reg;
                        `CSR_M_HPMCOUNTER12_ADDR            : read_data_reg   <= m_hpmcounter12_reg;
                        `CSR_M_HPMCOUNTER13_ADDR            : read_data_reg   <= m_hpmcounter13_reg;
                        `CSR_M_HPMCOUNTER14_ADDR            : read_data_reg   <= m_hpmcounter14_reg;
                        `CSR_M_HPMCOUNTER15_ADDR            : read_data_reg   <= m_hpmcounter15_reg;
                        `CSR_M_HPMCOUNTER16_ADDR            : read_data_reg   <= m_hpmcounter16_reg;
                        `CSR_M_HPMCOUNTER17_ADDR            : read_data_reg   <= m_hpmcounter17_reg;
                        `CSR_M_HPMCOUNTER18_ADDR            : read_data_reg   <= m_hpmcounter18_reg;
                        `CSR_M_HPMCOUNTER19_ADDR            : read_data_reg   <= m_hpmcounter19_reg;
                        `CSR_M_HPMCOUNTER20_ADDR            : read_data_reg   <= m_hpmcounter20_reg;
                        `CSR_M_HPMCOUNTER21_ADDR            : read_data_reg   <= m_hpmcounter21_reg;
                        `CSR_M_HPMCOUNTER22_ADDR            : read_data_reg   <= m_hpmcounter22_reg;
                        `CSR_M_HPMCOUNTER23_ADDR            : read_data_reg   <= m_hpmcounter23_reg;
                        `CSR_M_HPMCOUNTER24_ADDR            : read_data_reg   <= m_hpmcounter24_reg;
                        `CSR_M_HPMCOUNTER25_ADDR            : read_data_reg   <= m_hpmcounter25_reg;
                        `CSR_M_HPMCOUNTER26_ADDR            : read_data_reg   <= m_hpmcounter26_reg;
                        `CSR_M_HPMCOUNTER27_ADDR            : read_data_reg   <= m_hpmcounter27_reg;
                        `CSR_M_HPMCOUNTER28_ADDR            : read_data_reg   <= m_hpmcounter28_reg;
                        `CSR_M_HPMCOUNTER29_ADDR            : read_data_reg   <= m_hpmcounter29_reg;
                        `CSR_M_HPMCOUNTER30_ADDR            : read_data_reg   <= m_hpmcounter30_reg;
                        `CSR_M_HPMCOUNTER31_ADDR            : read_data_reg   <= m_hpmcounter31_reg;

                        `ifdef RV32
                            `CSR_M_CYCLEH_ADDR              : read_data_reg   <= m_cycleh_reg;
                            `CSR_M_INSTRETH_ADDR            : read_data_reg   <= m_instreth_reg;
                            `CSR_M_HPMCOUNTER3H_ADDR        : read_data_reg   <= m_hpmcounter3h_reg;
                            `CSR_M_HPMCOUNTER4H_ADDR        : read_data_reg   <= m_hpmcounter4h_reg;
                            `CSR_M_HPMCOUNTER5H_ADDR        : read_data_reg   <= m_hpmcounter5h_reg;
                            `CSR_M_HPMCOUNTER6H_ADDR        : read_data_reg   <= m_hpmcounter6h_reg;
                            `CSR_M_HPMCOUNTER7H_ADDR        : read_data_reg   <= m_hpmcounter7h_reg;
                            `CSR_M_HPMCOUNTER8H_ADDR        : read_data_reg   <= m_hpmcounter8h_reg;
                            `CSR_M_HPMCOUNTER9H_ADDR        : read_data_reg   <= m_hpmcounter9h_reg;
                            `CSR_M_HPMCOUNTER10H_ADDR       : read_data_reg   <= m_hpmcounter10h_reg;
                            `CSR_M_HPMCOUNTER11H_ADDR       : read_data_reg   <= m_hpmcounter11h_reg;
                            `CSR_M_HPMCOUNTER12H_ADDR       : read_data_reg   <= m_hpmcounter12h_reg;
                            `CSR_M_HPMCOUNTER13H_ADDR       : read_data_reg   <= m_hpmcounter13h_reg;
                            `CSR_M_HPMCOUNTER14H_ADDR       : read_data_reg   <= m_hpmcounter14h_reg;
                            `CSR_M_HPMCOUNTER15H_ADDR       : read_data_reg   <= m_hpmcounter15h_reg;
                            `CSR_M_HPMCOUNTER16H_ADDR       : read_data_reg   <= m_hpmcounter16h_reg;
                            `CSR_M_HPMCOUNTER17H_ADDR       : read_data_reg   <= m_hpmcounter17h_reg;
                            `CSR_M_HPMCOUNTER18H_ADDR       : read_data_reg   <= m_hpmcounter18h_reg;
                            `CSR_M_HPMCOUNTER19H_ADDR       : read_data_reg   <= m_hpmcounter19h_reg;
                            `CSR_M_HPMCOUNTER20H_ADDR       : read_data_reg   <= m_hpmcounter10h_reg;
                            `CSR_M_HPMCOUNTER21H_ADDR       : read_data_reg   <= m_hpmcounter21h_reg;
                            `CSR_M_HPMCOUNTER22H_ADDR       : read_data_reg   <= m_hpmcounter22h_reg;
                            `CSR_M_HPMCOUNTER23H_ADDR       : read_data_reg   <= m_hpmcounter23h_reg;
                            `CSR_M_HPMCOUNTER24H_ADDR       : read_data_reg   <= m_hpmcounter24h_reg;
                            `CSR_M_HPMCOUNTER25H_ADDR       : read_data_reg   <= m_hpmcounter25h_reg;
                            `CSR_M_HPMCOUNTER26H_ADDR       : read_data_reg   <= m_hpmcounter26h_reg;
                            `CSR_M_HPMCOUNTER27H_ADDR       : read_data_reg   <= m_hpmcounter27h_reg;
                            `CSR_M_HPMCOUNTER28H_ADDR       : read_data_reg   <= m_hpmcounter28h_reg;
                            `CSR_M_HPMCOUNTER29H_ADDR       : read_data_reg   <= m_hpmcounter29h_reg;
                            `CSR_M_HPMCOUNTER30H_ADDR       : read_data_reg   <= m_hpmcounter30h_reg;
                            `CSR_M_HPMCOUNTER31H_ADDR       : read_data_reg   <= m_hpmcounter31h_reg;
                        `endif
                        `CSR_M_COUNTINHIBIT_ADDR            : read_data_reg   <= m_countinhibit_reg;
                        `CSR_M_HPMEVENT3_ADDR               : read_data_reg   <= m_hpmevent3_reg;
                        `CSR_M_HPMEVENT4_ADDR               : read_data_reg   <= m_hpmevent4_reg;
                        `CSR_M_HPMEVENT5_ADDR               : read_data_reg   <= m_hpmevent5_reg;
                        `CSR_M_HPMEVENT6_ADDR               : read_data_reg   <= m_hpmevent6_reg;
                        `CSR_M_HPMEVENT7_ADDR               : read_data_reg   <= m_hpmevent7_reg;
                        `CSR_M_HPMEVENT8_ADDR               : read_data_reg   <= m_hpmevent8_reg;
                        `CSR_M_HPMEVENT9_ADDR               : read_data_reg   <= m_hpmevent9_reg;
                        `CSR_M_HPMEVENT10_ADDR              : read_data_reg   <= m_hpmevent10_reg;
                        `CSR_M_HPMEVENT11_ADDR              : read_data_reg   <= m_hpmevent11_reg;
                        `CSR_M_HPMEVENT12_ADDR              : read_data_reg   <= m_hpmevent12_reg;
                        `CSR_M_HPMEVENT13_ADDR              : read_data_reg   <= m_hpmevent13_reg;
                        `CSR_M_HPMEVENT14_ADDR              : read_data_reg   <= m_hpmevent14_reg;
                        `CSR_M_HPMEVENT15_ADDR              : read_data_reg   <= m_hpmevent15_reg;
                        `CSR_M_HPMEVENT16_ADDR              : read_data_reg   <= m_hpmevent16_reg;
                        `CSR_M_HPMEVENT17_ADDR              : read_data_reg   <= m_hpmevent17_reg;
                        `CSR_M_HPMEVENT18_ADDR              : read_data_reg   <= m_hpmevent18_reg;
                        `CSR_M_HPMEVENT19_ADDR              : read_data_reg   <= m_hpmevent19_reg;
                        `CSR_M_HPMEVENT20_ADDR              : read_data_reg   <= m_hpmevent20_reg;
                        `CSR_M_HPMEVENT21_ADDR              : read_data_reg   <= m_hpmevent21_reg;
                        `CSR_M_HPMEVENT22_ADDR              : read_data_reg   <= m_hpmevent22_reg;
                        `CSR_M_HPMEVENT23_ADDR              : read_data_reg   <= m_hpmevent23_reg;
                        `CSR_M_HPMEVENT24_ADDR              : read_data_reg   <= m_hpmevent24_reg;
                        `CSR_M_HPMEVENT25_ADDR              : read_data_reg   <= m_hpmevent25_reg;
                        `CSR_M_HPMEVENT26_ADDR              : read_data_reg   <= m_hpmevent26_reg;
                        `CSR_M_HPMEVENT27_ADDR              : read_data_reg   <= m_hpmevent27_reg;
                        `CSR_M_HPMEVENT28_ADDR              : read_data_reg   <= m_hpmevent28_reg;
                        `CSR_M_HPMEVENT29_ADDR              : read_data_reg   <= m_hpmevent29_reg;
                        `CSR_M_HPMEVENT30_ADDR              : read_data_reg   <= m_hpmevent30_reg;
                        `CSR_M_HPMEVENT31_ADDR              : read_data_reg   <= m_hpmevent31_reg;
                        endcase
                        end
                    end
                else
                    begin
                    read_data_reg <= read_data_reg;
                    end
                end
                end

endmodule
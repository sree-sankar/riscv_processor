//----------------------+-------------------------------------------------------
// Filename             | csr_regs.vh
// File created on      | 15.11.2020 12:07:34
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// CSR Registers
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Address
//------------------------------------------------------------------------------

    // Machine Information Registers
    `define CSR_M_VENDORID_ADDR            `CSR_BASE_WIDTH'hF11 // Vendor ID
    `define CSR_M_ARCHID_ADDR              `CSR_BASE_WIDTH'hF12 // Architecture ID
    `define CSR_M_IMPID_ADDR               `CSR_BASE_WIDTH'hF13 // Implementation ID
    `define CSR_M_HARTID_ADDR              `CSR_BASE_WIDTH'hF14 // Hardware thread ID
    `define CSR_M_CONFIGPTR_ADDR           `CSR_BASE_WIDTH'hF15 // Pointer to configuration data structure

    // Machine Trap Setup
    `define CSR_M_STATUS_ADDR              `CSR_BASE_WIDTH'h300 // Machine Status
    `define CSR_M_ISA_ADDR                 `CSR_BASE_WIDTH'h301 // ISA and Extenstion Register
    `define CSR_M_EDELEG_ADDR              `CSR_BASE_WIDTH'h302 // Machine Exception Delegation Register
    `define CSR_M_IDELEG_ADDR              `CSR_BASE_WIDTH'h303 // Machine Interrupt Delegation Register
    `define CSR_M_IE_ADDR                  `CSR_BASE_WIDTH'h304 // Machine Interrupt Enable Register
    `define CSR_M_TVEC_ADDR                `CSR_BASE_WIDTH'h305 // Machine Trap Handler Base Address
    `define CSR_M_COUNTEREN_ADDR           `CSR_BASE_WIDTH'h306 // Machine Counter Enable
    `define CSR_M_STATUSH_ADDR             `CSR_BASE_WIDTH'h310 // Additional machine status register

    // Machine Trap Handling
    `define CSR_M_SCRATCH_ADDR             `CSR_BASE_WIDTH'h340 // Scratch register for machine trap handler
    `define CSR_M_EPC_ADDR                 `CSR_BASE_WIDTH'h341 // Machine exception program counter
    `define CSR_M_CAUSE_ADDR               `CSR_BASE_WIDTH'h342 // Machine trap cause
    `define CSR_M_TVAL_ADDR                `CSR_BASE_WIDTH'h343 // Machine bad address or instruction
    `define CSR_M_IP_ADDR                  `CSR_BASE_WIDTH'h344 // Machine interrupt pending
    `define CSR_M_TINST_ADDR               `CSR_BASE_WIDTH'h34A // Machine trap instructio
    `define CSR_M_TVAL2_ADDR               `CSR_BASE_WIDTH'h34B // Machine bad guest physical address

    // Machine Configuration
    `define CSR_M_ENVCFG_ADDR              `CSR_BASE_WIDTH'h30A // Machine environment configuration register
    `define CSR_M_SECCFG_ADDR              `CSR_BASE_WIDTH'h747 // Machine Security Configuration Register
    `define CSR_M_ENVCFGH_ADDR             `CSR_BASE_WIDTH'h31A // Additional machine env. conf register
    `define CSR_M_SECCFGH_ADDR             `CSR_BASE_WIDTH'h757 // Additional machine security conf. register
    // Machine Memory Protection
    `define CSR_M_PMPCFG0_ADDR             `CSR_BASE_WIDTH'h3A0 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG2_ADDR             `CSR_BASE_WIDTH'h3A2 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG4_ADDR             `CSR_BASE_WIDTH'h3A4 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG6_ADDR             `CSR_BASE_WIDTH'h3A6 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG8_ADDR             `CSR_BASE_WIDTH'h3A8 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG10_ADDR            `CSR_BASE_WIDTH'h3AA // Physical Memory Protection configuration
    `define CSR_M_PMPCFG12_ADDR            `CSR_BASE_WIDTH'h3AC // Physical Memory Protection configuration
    `define CSR_M_PMPCFG14_ADDR            `CSR_BASE_WIDTH'h3AE // Physical Memory Protection configuration
    `define CSR_M_PMPCFG1_ADDR             `CSR_BASE_WIDTH'h3A1 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG3_ADDR             `CSR_BASE_WIDTH'h3A3 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG5_ADDR             `CSR_BASE_WIDTH'h3A5 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG7_ADDR             `CSR_BASE_WIDTH'h3A7 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG9_ADDR             `CSR_BASE_WIDTH'h3A9 // Physical Memory Protection configuration
    `define CSR_M_PMPCFG11_ADDR            `CSR_BASE_WIDTH'h3AB // Physical Memory Protection configuration
    `define CSR_M_PMPCFG13_ADDR            `CSR_BASE_WIDTH'h3AD // Physical Memory Protection configuration
    `define CSR_M_PMPCFG15_ADDR            `CSR_BASE_WIDTH'h3AF // Physical Memory Protection configuration
    `define CSR_M_PMPADDR0_ADDR            `CSR_BASE_WIDTH'h3B0 // Physical memory protection address register
    `define CSR_M_PMPADDR1_ADDR            `CSR_BASE_WIDTH'h3B1 // Physical memory protection address register
    `define CSR_M_PMPADDR2_ADDR            `CSR_BASE_WIDTH'h3B2 // Physical memory protection address register
    `define CSR_M_PMPADDR3_ADDR            `CSR_BASE_WIDTH'h3B3 // Physical memory protection address register
    `define CSR_M_PMPADDR4_ADDR            `CSR_BASE_WIDTH'h3B4 // Physical memory protection address register
    `define CSR_M_PMPADDR5_ADDR            `CSR_BASE_WIDTH'h3B5 // Physical memory protection address register
    `define CSR_M_PMPADDR6_ADDR            `CSR_BASE_WIDTH'h3B6 // Physical memory protection address register
    `define CSR_M_PMPADDR7_ADDR            `CSR_BASE_WIDTH'h3B7 // Physical memory protection address register
    `define CSR_M_PMPADDR8_ADDR            `CSR_BASE_WIDTH'h3B8 // Physical memory protection address register
    `define CSR_M_PMPADDR9_ADDR            `CSR_BASE_WIDTH'h3B9 // Physical memory protection address register
    `define CSR_M_PMPADDR10_ADDR           `CSR_BASE_WIDTH'h3BA // Physical memory protection address register
    `define CSR_M_PMPADDR11_ADDR           `CSR_BASE_WIDTH'h3BB // Physical memory protection address register
    `define CSR_M_PMPADDR12_ADDR           `CSR_BASE_WIDTH'h3BC // Physical memory protection address register
    `define CSR_M_PMPADDR13_ADDR           `CSR_BASE_WIDTH'h3BD // Physical memory protection address register
    `define CSR_M_PMPADDR14_ADDR           `CSR_BASE_WIDTH'h3BE // Physical memory protection address register
    `define CSR_M_PMPADDR15_ADDR           `CSR_BASE_WIDTH'h3BF // Physical memory protection address register
    `define CSR_M_PMPADDR16_ADDR           `CSR_BASE_WIDTH'h3C0 // Physical memory protection address register
    `define CSR_M_PMPADDR17_ADDR           `CSR_BASE_WIDTH'h3C1 // Physical memory protection address register
    `define CSR_M_PMPADDR18_ADDR           `CSR_BASE_WIDTH'h3C2 // Physical memory protection address register
    `define CSR_M_PMPADDR19_ADDR           `CSR_BASE_WIDTH'h3C3 // Physical memory protection address register
    `define CSR_M_PMPADDR20_ADDR           `CSR_BASE_WIDTH'h3C4 // Physical memory protection address register
    `define CSR_M_PMPADDR21_ADDR           `CSR_BASE_WIDTH'h3C5 // Physical memory protection address register
    `define CSR_M_PMPADDR22_ADDR           `CSR_BASE_WIDTH'h3C6 // Physical memory protection address register
    `define CSR_M_PMPADDR23_ADDR           `CSR_BASE_WIDTH'h3C7 // Physical memory protection address register
    `define CSR_M_PMPADDR24_ADDR           `CSR_BASE_WIDTH'h3C8 // Physical memory protection address register
    `define CSR_M_PMPADDR25_ADDR           `CSR_BASE_WIDTH'h3C9 // Physical memory protection address register
    `define CSR_M_PMPADDR26_ADDR           `CSR_BASE_WIDTH'h3CA // Physical memory protection address register
    `define CSR_M_PMPADDR27_ADDR           `CSR_BASE_WIDTH'h3CB // Physical memory protection address register
    `define CSR_M_PMPADDR28_ADDR           `CSR_BASE_WIDTH'h3CC // Physical memory protection address register
    `define CSR_M_PMPADDR29_ADDR           `CSR_BASE_WIDTH'h3CD // Physical memory protection address register
    `define CSR_M_PMPADDR30_ADDR           `CSR_BASE_WIDTH'h3CE // Physical memory protection address register
    `define CSR_M_PMPADDR31_ADDR           `CSR_BASE_WIDTH'h3CF // Physical memory protection address register
    `define CSR_M_PMPADDR32_ADDR           `CSR_BASE_WIDTH'h3D0 // Physical memory protection address register
    `define CSR_M_PMPADDR33_ADDR           `CSR_BASE_WIDTH'h3D1 // Physical memory protection address register
    `define CSR_M_PMPADDR34_ADDR           `CSR_BASE_WIDTH'h3D2 // Physical memory protection address register
    `define CSR_M_PMPADDR35_ADDR           `CSR_BASE_WIDTH'h3D3 // Physical memory protection address register
    `define CSR_M_PMPADDR36_ADDR           `CSR_BASE_WIDTH'h3D4 // Physical memory protection address register
    `define CSR_M_PMPADDR37_ADDR           `CSR_BASE_WIDTH'h3D5 // Physical memory protection address register
    `define CSR_M_PMPADDR38_ADDR           `CSR_BASE_WIDTH'h3D6 // Physical memory protection address register
    `define CSR_M_PMPADDR39_ADDR           `CSR_BASE_WIDTH'h3D7 // Physical memory protection address register
    `define CSR_M_PMPADDR40_ADDR           `CSR_BASE_WIDTH'h3D8 // Physical memory protection address register
    `define CSR_M_PMPADDR41_ADDR           `CSR_BASE_WIDTH'h3D9 // Physical memory protection address register
    `define CSR_M_PMPADDR42_ADDR           `CSR_BASE_WIDTH'h3DA // Physical memory protection address register
    `define CSR_M_PMPADDR43_ADDR           `CSR_BASE_WIDTH'h3DB // Physical memory protection address register
    `define CSR_M_PMPADDR44_ADDR           `CSR_BASE_WIDTH'h3DC // Physical memory protection address register
    `define CSR_M_PMPADDR45_ADDR           `CSR_BASE_WIDTH'h3DD // Physical memory protection address register
    `define CSR_M_PMPADDR46_ADDR           `CSR_BASE_WIDTH'h3DE // Physical memory protection address register
    `define CSR_M_PMPADDR47_ADDR           `CSR_BASE_WIDTH'h3DF // Physical memory protection address register
    `define CSR_M_PMPADDR48_ADDR           `CSR_BASE_WIDTH'h3E0 // Physical memory protection address register
    `define CSR_M_PMPADDR49_ADDR           `CSR_BASE_WIDTH'h3E1 // Physical memory protection address register
    `define CSR_M_PMPADDR50_ADDR           `CSR_BASE_WIDTH'h3E2 // Physical memory protection address register
    `define CSR_M_PMPADDR51_ADDR           `CSR_BASE_WIDTH'h3E3 // Physical memory protection address register
    `define CSR_M_PMPADDR52_ADDR           `CSR_BASE_WIDTH'h3E4 // Physical memory protection address register
    `define CSR_M_PMPADDR53_ADDR           `CSR_BASE_WIDTH'h3E5 // Physical memory protection address register
    `define CSR_M_PMPADDR54_ADDR           `CSR_BASE_WIDTH'h3E6 // Physical memory protection address register
    `define CSR_M_PMPADDR55_ADDR           `CSR_BASE_WIDTH'h3E7 // Physical memory protection address register
    `define CSR_M_PMPADDR56_ADDR           `CSR_BASE_WIDTH'h3E8 // Physical memory protection address register
    `define CSR_M_PMPADDR57_ADDR           `CSR_BASE_WIDTH'h3E9 // Physical memory protection address register
    `define CSR_M_PMPADDR58_ADDR           `CSR_BASE_WIDTH'h3EA // Physical memory protection address register
    `define CSR_M_PMPADDR59_ADDR           `CSR_BASE_WIDTH'h3EB // Physical memory protection address register
    `define CSR_M_PMPADDR60_ADDR           `CSR_BASE_WIDTH'h3EC // Physical memory protection address register
    `define CSR_M_PMPADDR61_ADDR           `CSR_BASE_WIDTH'h3ED // Physical memory protection address register
    `define CSR_M_PMPADDR62_ADDR           `CSR_BASE_WIDTH'h3EE // Physical memory protection address register
    `define CSR_M_PMPADDR63_ADDR           `CSR_BASE_WIDTH'h3EF // Physical memory protection address register

    // Machine Counter/Timers
    `define CSR_M_CYCLE_ADDR               `CSR_BASE_WIDTH'hB00 // Machine cycle counter
    `define CSR_M_INSTRET_ADDR             `CSR_BASE_WIDTH'hB02 // Machine insturction retired counter
    `define CSR_M_HPMCOUNTER3_ADDR         `CSR_BASE_WIDTH'hB03 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER4_ADDR         `CSR_BASE_WIDTH'hB04 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER5_ADDR         `CSR_BASE_WIDTH'hB05 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER6_ADDR         `CSR_BASE_WIDTH'hB06 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER7_ADDR         `CSR_BASE_WIDTH'hB07 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER8_ADDR         `CSR_BASE_WIDTH'hB08 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER9_ADDR         `CSR_BASE_WIDTH'hB09 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER10_ADDR        `CSR_BASE_WIDTH'hB0A // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER11_ADDR        `CSR_BASE_WIDTH'hB0B // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER12_ADDR        `CSR_BASE_WIDTH'hB0C // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER13_ADDR        `CSR_BASE_WIDTH'hB0D // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER14_ADDR        `CSR_BASE_WIDTH'hB0E // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER15_ADDR        `CSR_BASE_WIDTH'hB0F // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER16_ADDR        `CSR_BASE_WIDTH'hB10 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER17_ADDR        `CSR_BASE_WIDTH'hB11 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER18_ADDR        `CSR_BASE_WIDTH'hB12 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER19_ADDR        `CSR_BASE_WIDTH'hB13 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER20_ADDR        `CSR_BASE_WIDTH'hB14 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER21_ADDR        `CSR_BASE_WIDTH'hB15 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER22_ADDR        `CSR_BASE_WIDTH'hB16 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER23_ADDR        `CSR_BASE_WIDTH'hB17 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER24_ADDR        `CSR_BASE_WIDTH'hB18 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER25_ADDR        `CSR_BASE_WIDTH'hB19 // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER26_ADDR        `CSR_BASE_WIDTH'hB1A // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER27_ADDR        `CSR_BASE_WIDTH'hB1B // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER28_ADDR        `CSR_BASE_WIDTH'hB1C // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER29_ADDR        `CSR_BASE_WIDTH'hB1D // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER30_ADDR        `CSR_BASE_WIDTH'hB1E // Machine performance monitoring counter
    `define CSR_M_HPMCOUNTER31_ADDR        `CSR_BASE_WIDTH'hB1F // Machine performance monitoring counter
    `define CSR_M_CYCLEH_ADDR              `CSR_BASE_WIDTH'hB80 // Upper 32 bits of mcycle
    `define CSR_M_INSTRETH_ADDR            `CSR_BASE_WIDTH'hB82 // Upper 32 bits of minstret
    `define CSR_M_HPMCOUNTER3H_ADDR        `CSR_BASE_WIDTH'hB83 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER4H_ADDR        `CSR_BASE_WIDTH'hB84 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER5H_ADDR        `CSR_BASE_WIDTH'hB85 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER6H_ADDR        `CSR_BASE_WIDTH'hB86 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER7H_ADDR        `CSR_BASE_WIDTH'hB87 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER8H_ADDR        `CSR_BASE_WIDTH'hB88 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER9H_ADDR        `CSR_BASE_WIDTH'hB89 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER10H_ADDR       `CSR_BASE_WIDTH'hB8A // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER11H_ADDR       `CSR_BASE_WIDTH'hB8B // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER12H_ADDR       `CSR_BASE_WIDTH'hB8C // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER13H_ADDR       `CSR_BASE_WIDTH'hB8D // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER14H_ADDR       `CSR_BASE_WIDTH'hB8E // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER15H_ADDR       `CSR_BASE_WIDTH'hB8F // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER16H_ADDR       `CSR_BASE_WIDTH'hB90 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER17H_ADDR       `CSR_BASE_WIDTH'hB91 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER18H_ADDR       `CSR_BASE_WIDTH'hB92 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER19H_ADDR       `CSR_BASE_WIDTH'hB93 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER20H_ADDR       `CSR_BASE_WIDTH'hB94 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER21H_ADDR       `CSR_BASE_WIDTH'hB95 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER22H_ADDR       `CSR_BASE_WIDTH'hB96 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER23H_ADDR       `CSR_BASE_WIDTH'hB97 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER24H_ADDR       `CSR_BASE_WIDTH'hB98 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER25H_ADDR       `CSR_BASE_WIDTH'hB99 // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER26H_ADDR       `CSR_BASE_WIDTH'hB9A // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER27H_ADDR       `CSR_BASE_WIDTH'hB9B // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER28H_ADDR       `CSR_BASE_WIDTH'hB9C // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER29H_ADDR       `CSR_BASE_WIDTH'hB9D // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER30H_ADDR       `CSR_BASE_WIDTH'hB9E // Upper 32 bits of mhpmcounter
    `define CSR_M_HPMCOUNTER31H_ADDR       `CSR_BASE_WIDTH'hB9F // Upper 32 bits of mhpmcounter

    // Machine Counter Setup
    `define CSR_M_COUNTINHIBIT_ADDR        `CSR_BASE_WIDTH'h320 // Machine counter-inhibit register
    `define CSR_M_HPMEVENT3_ADDR           `CSR_BASE_WIDTH'h323 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT4_ADDR           `CSR_BASE_WIDTH'h324 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT5_ADDR           `CSR_BASE_WIDTH'h325 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT6_ADDR           `CSR_BASE_WIDTH'h326 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT7_ADDR           `CSR_BASE_WIDTH'h327 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT8_ADDR           `CSR_BASE_WIDTH'h328 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT9_ADDR           `CSR_BASE_WIDTH'h329 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT10_ADDR          `CSR_BASE_WIDTH'h32A // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT11_ADDR          `CSR_BASE_WIDTH'h32B // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT12_ADDR          `CSR_BASE_WIDTH'h32C // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT13_ADDR          `CSR_BASE_WIDTH'h32D // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT14_ADDR          `CSR_BASE_WIDTH'h32E // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT15_ADDR          `CSR_BASE_WIDTH'h32F // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT16_ADDR          `CSR_BASE_WIDTH'h330 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT17_ADDR          `CSR_BASE_WIDTH'h331 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT18_ADDR          `CSR_BASE_WIDTH'h332 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT19_ADDR          `CSR_BASE_WIDTH'h333 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT20_ADDR          `CSR_BASE_WIDTH'h334 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT21_ADDR          `CSR_BASE_WIDTH'h335 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT22_ADDR          `CSR_BASE_WIDTH'h336 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT23_ADDR          `CSR_BASE_WIDTH'h337 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT24_ADDR          `CSR_BASE_WIDTH'h338 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT25_ADDR          `CSR_BASE_WIDTH'h339 // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT26_ADDR          `CSR_BASE_WIDTH'h33A // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT27_ADDR          `CSR_BASE_WIDTH'h33B // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT28_ADDR          `CSR_BASE_WIDTH'h33C // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT29_ADDR          `CSR_BASE_WIDTH'h33D // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT30_ADDR          `CSR_BASE_WIDTH'h33E // Machine performance-monitoring event selector
    `define CSR_M_HPMEVENT31_ADDR          `CSR_BASE_WIDTH'h33F // Machine performance-monitoring event selector


//------------------------------------------------------------------------------
// Default
//------------------------------------------------------------------------------

    //Default Machine Information Register Value
    `define DEF_M_VENDORID              `XLEN'h0000_0000
    `define DEF_M_ARCHID                `XLEN'h0000_0000
    `define DEF_M_IMPID                 `XLEN'h0000_0000
    `define DEF_M_HARTID                `XLEN'h0000_0000
    `define DEF_M_CONFIGPTR             `XLEN'h0000_0000
    //Default Machine Trap Setup Value
    `define DEF_M_STATUS                `XLEN'h0000_1800
    `define DEF_M_ISA                   `XLEN'h4000_0100
    `define DEF_M_EDELEG                `XLEN'h0000_0000
    `define DEF_M_IDELEG                `XLEN'h0000_0000
    `define DEF_M_IE                    `XLEN'h0000_0000
    `define DEF_M_TVEC                  `XLEN'h0000_0000//{1'b0,`MVECT_BASE}
    `define DEF_M_COUNTEREN             `XLEN'h0000_0000
    //Default Machine Trap Handling Value
    `define DEF_M_STATUS_H              `XLEN'h0000_0000
    `define DEF_M_EPC                   `XLEN'h0000_0000
    `define DEF_M_CAUSE                 `XLEN'h0000_0000
    `define DEF_M_TVAL                  `XLEN'h0000_0000
    `define DEF_M_IP                    `XLEN'h0000_0000
    `define DEF_M_TINST                 `XLEN'h0000_0000
    `define DEF_M_TVAL2                 `XLEN'h0000_0000
    //Default Machine Configuration Value
    `define DEF_M_ENVCFG                `XLEN'h0000_0000
    `define DEF_M_ENVCFGH               `XLEN'h0000_0000
    `define DEF_M_SECCFGH               `XLEN'h0000_0000
    `define DEF_M_SECCFG                `XLEN'h0000_0000
    //Default Machine Memory Protection
    `define DEF_M_PMPCFG0               `XLEN'h0000_0000
    `define DEF_M_PMPCFG2               `XLEN'h0000_0000
    `define DEF_M_PMPCFG4               `XLEN'h0000_0000
    `define DEF_M_PMPCFG6               `XLEN'h0000_0000
    `define DEF_M_PMPCFG8               `XLEN'h0000_0000
    `define DEF_M_PMPCFG10              `XLEN'h0000_0000
    `define DEF_M_PMPCFG12              `XLEN'h0000_0000
    `define DEF_M_PMPCFG14              `XLEN'h0000_0000
    `define DEF_M_PMPCFG1               `XLEN'h0000_0000
    `define DEF_M_PMPCFG3               `XLEN'h0000_0000
    `define DEF_M_PMPCFG5               `XLEN'h0000_0000
    `define DEF_M_PMPCFG7               `XLEN'h0000_0000
    `define DEF_M_PMPCFG9               `XLEN'h0000_0000
    `define DEF_M_PMPCFG11              `XLEN'h0000_0000
    `define DEF_M_PMPCFG13              `XLEN'h0000_0000
    `define DEF_M_PMPCFG15              `XLEN'h0000_0000
    `define DEF_M_PMPADDR0              `XLEN'h0000_0000
    `define DEF_M_PMPADDR1              `XLEN'h0000_0000
    `define DEF_M_PMPADDR2              `XLEN'h0000_0000
    `define DEF_M_PMPADDR3              `XLEN'h0000_0000
    `define DEF_M_PMPADDR4              `XLEN'h0000_0000
    `define DEF_M_PMPADDR5              `XLEN'h0000_0000
    `define DEF_M_PMPADDR6              `XLEN'h0000_0000
    `define DEF_M_PMPADDR7              `XLEN'h0000_0000
    `define DEF_M_PMPADDR8              `XLEN'h0000_0000
    `define DEF_M_PMPADDR9              `XLEN'h0000_0000
    `define DEF_M_PMPADDR10             `XLEN'h0000_0000
    `define DEF_M_PMPADDR11             `XLEN'h0000_0000
    `define DEF_M_PMPADDR12             `XLEN'h0000_0000
    `define DEF_M_PMPADDR13             `XLEN'h0000_0000
    `define DEF_M_PMPADDR14             `XLEN'h0000_0000
    `define DEF_M_PMPADDR15             `XLEN'h0000_0000
    `define DEF_M_PMPADDR16             `XLEN'h0000_0000
    `define DEF_M_PMPADDR17             `XLEN'h0000_0000
    `define DEF_M_PMPADDR18             `XLEN'h0000_0000
    `define DEF_M_PMPADDR19             `XLEN'h0000_0000
    `define DEF_M_PMPADDR20             `XLEN'h0000_0000
    `define DEF_M_PMPADDR21             `XLEN'h0000_0000
    `define DEF_M_PMPADDR22             `XLEN'h0000_0000
    `define DEF_M_PMPADDR23             `XLEN'h0000_0000
    `define DEF_M_PMPADDR24             `XLEN'h0000_0000
    `define DEF_M_PMPADDR25             `XLEN'h0000_0000
    `define DEF_M_PMPADDR26             `XLEN'h0000_0000
    `define DEF_M_PMPADDR27             `XLEN'h0000_0000
    `define DEF_M_PMPADDR28             `XLEN'h0000_0000
    `define DEF_M_PMPADDR29             `XLEN'h0000_0000
    `define DEF_M_PMPADDR30             `XLEN'h0000_0000
    `define DEF_M_PMPADDR31             `XLEN'h0000_0000
    `define DEF_M_PMPADDR32             `XLEN'h0000_0000
    `define DEF_M_PMPADDR33             `XLEN'h0000_0000
    `define DEF_M_PMPADDR34             `XLEN'h0000_0000
    `define DEF_M_PMPADDR35             `XLEN'h0000_0000
    `define DEF_M_PMPADDR36             `XLEN'h0000_0000
    `define DEF_M_PMPADDR37             `XLEN'h0000_0000
    `define DEF_M_PMPADDR38             `XLEN'h0000_0000
    `define DEF_M_PMPADDR39             `XLEN'h0000_0000
    `define DEF_M_PMPADDR40             `XLEN'h0000_0000
    `define DEF_M_PMPADDR41             `XLEN'h0000_0000
    `define DEF_M_PMPADDR42             `XLEN'h0000_0000
    `define DEF_M_PMPADDR43             `XLEN'h0000_0000
    `define DEF_M_PMPADDR44             `XLEN'h0000_0000
    `define DEF_M_PMPADDR45             `XLEN'h0000_0000
    `define DEF_M_PMPADDR46             `XLEN'h0000_0000
    `define DEF_M_PMPADDR47             `XLEN'h0000_0000
    `define DEF_M_PMPADDR48             `XLEN'h0000_0000
    `define DEF_M_PMPADDR49             `XLEN'h0000_0000
    `define DEF_M_PMPADDR50             `XLEN'h0000_0000
    `define DEF_M_PMPADDR51             `XLEN'h0000_0000
    `define DEF_M_PMPADDR52             `XLEN'h0000_0000
    `define DEF_M_PMPADDR53             `XLEN'h0000_0000
    `define DEF_M_PMPADDR54             `XLEN'h0000_0000
    `define DEF_M_PMPADDR55             `XLEN'h0000_0000
    `define DEF_M_PMPADDR56             `XLEN'h0000_0000
    `define DEF_M_PMPADDR57             `XLEN'h0000_0000
    `define DEF_M_PMPADDR58             `XLEN'h0000_0000
    `define DEF_M_PMPADDR59             `XLEN'h0000_0000
    `define DEF_M_PMPADDR60             `XLEN'h0000_0000
    `define DEF_M_PMPADDR61             `XLEN'h0000_0000
    `define DEF_M_PMPADDR62             `XLEN'h0000_0000
    `define DEF_M_PMPADDR63             `XLEN'h0000_0000
    //Default Machine Counter/Timer
    `define DEF_M_CYCLE                 `XLEN'h0000_0000
    `define DEF_M_CYCLEH                `XLEN'h0000_0000
    `define DEF_M_INSTRET               `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER3           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER4           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER5           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER6           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER7           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER8           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER9           `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER10          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER11          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER12          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER13          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER14          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER15          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER16          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER17          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER18          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER19          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER20          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER21          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER22          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER23          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER24          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER25          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER26          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER27          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER28          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER29          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER30          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER31          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER3H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER4H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER5H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER6H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER7H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER8H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER9H          `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER10H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER11H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER12H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER13H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER14H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER15H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER16H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER17H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER18H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER19H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER20H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER21H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER22H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER23H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER24H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER25H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER26H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER27H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER28H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER29H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER30H         `XLEN'h0000_0000
    `define DEF_M_HPMCOUNTER31H         `XLEN'h0000_0000
    //Default Machine Counter Setup Value
    `define DEF_M_COUNTINHIBIT          `XLEN'h0000_0000
    `define DEF_M_SCRATCH               `XLEN'h0000_0000
    `define DEF_M_EPC                   `XLEN'h0000_0000
    `define DEF_M_HPMEVENT3             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT4             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT5             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT6             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT7             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT8             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT9             `XLEN'h0000_0000
    `define DEF_M_HPMEVENT10            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT11            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT12            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT13            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT14            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT15            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT16            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT17            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT18            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT19            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT20            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT21            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT22            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT23            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT24            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT25            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT26            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT27            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT28            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT29            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT30            `XLEN'h0000_0000
    `define DEF_M_HPMEVENT31            `XLEN'h0000_0000
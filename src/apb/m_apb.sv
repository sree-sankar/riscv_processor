`timescale 1ns / 1ps
//----------------------+-------------------------------------------------------
// Filename             | apb_interface.sv
// File created on      | 10.30.2024 10:30:00 PM
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// APB3 Interface
// Read/Write Interface should be CDCed to APB Clock in the input side
//------------------------------------------------------------------------------

`include "apb.vh"

module m_apb(
    // APB Signal
    input                       m_apb_pclk_i     , // APB Clock
    input                       m_apb_presetn_i  , // APB Reset
    output [    `APB_AW-1:0]    m_apb_paddr_o    , // APB Address
    output                      m_apb_pwrite_o   , // APB Write
    output [`APB_SLAVES-1:0]    m_apb_psel_o     , // APB Select
    output                      m_apb_penable_o  , // APB Select
    input                       m_apb_pready_i   , // APB Slave Ready
    output [    `APB_DW-1:0]    m_apb_pwdata_o   , // APB Write
    output [ `APB_STRBW-1:0]    m_apb_pstrb_o    , // APB Strobe
    input  [    `APB_DW-1:0]    m_apb_rdata_i    , // APB Read data
    // Address and Select
    input  [    `APB_AW-1:0]    read_write_addr_i, // Write Address
    input  [`APB_SLAVES-1:0]    read_write_sel_i , // Wrute Select
    // Write Interface
    input                       write_en_i       , // Write Enable
    input  [    `APB_DW-1:0]    write_data_i     , // Write Data
    // Read Interface
    input                       read_en_i        , // Read Enable
    output [    `APB_DW-1:0]    read_data_o      , // Read Data
    // Status
    output                      busy_o           , // Busy
    output                      done_o             // Done
);

//------------------------------------------------------------------------------
// APB Master State
//------------------------------------------------------------------------------

    enum logic [2:0] {
        APB_IDLE   = 'h1,
        APB_SETUP  = 'h2,
        APB_ACCESS = 'h4
    } apb_state;

    logic    idle_state  ;
    logic    setup_state ;
    logic    access_state;
    logic    apb_enable  ;

    always_ff @(posedge m_apb_pclk_i)
        begin
        if(!m_apb_presetn_i)
            begin
            apb_state <= APB_IDLE;
            end
        else
            begin
            case(apb_state)
                APB_IDLE :
                    begin
                    if(apb_enable)
                        begin
                        apb_state <= APB_SETUP;
                        end
                    end
                APB_SETUP :
                    begin
                    apb_state <= APB_ACCESS;
                    end
                APB_ACCESS :
                    begin
                    if(m_apb_pready_i)
                        begin
                        apb_state <= APB_IDLE;
                        end
                    end
                default : apb_state <= APB_IDLE;
            endcase
            end
        end

    assign idle_state   = (apb_state == APB_IDLE  ) ? 'h1 : 'h0;
    assign setup_state  = (apb_state == APB_SETUP ) ? 'h1 : 'h0;
    assign access_state = (apb_state == APB_ACCESS) ? 'h1 : 'h0;

//------------------------------------------------------------------------------
// Sampling Input data duing idle state
//------------------------------------------------------------------------------

    assign busy_o = !idle_state;
    assign done_o = access_state & m_apb_pready_i;

//------------------------------------------------------------------------------
// Sampling Input data duing idle state
//------------------------------------------------------------------------------

    logic                      write_en_s       ;
    logic [    `APB_DW-1:0]    write_data_s     ;
    logic [    `APB_AW-1:0]    read_write_addr_s;
    logic [`APB_SLAVES-1:0]    read_write_sel_s ;

    always_ff @(posedge m_apb_pclk_i)
        begin
        if(!m_apb_presetn_i)
            begin
            write_en_s        <= 'h0;
            write_data_s      <= 'h0;
            read_write_addr_s <= 'h0;
            read_write_sel_s  <= 'h0;
            end
        else
            begin
            if(idle_state)
                begin
                write_en_s        <= write_en_i       ;
                write_data_s      <= write_data_i     ;
                read_write_addr_s <= read_write_addr_i;
                read_write_sel_s  <= read_write_sel_i ;
                end
            end
        end

    assign apb_enable = (write_en_i | read_en_i);

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign m_apb_paddr_o   = !idle_state ? read_write_addr_s : 'h0;
    assign m_apb_pwrite_o  = !idle_state ? write_en_s        : 'h0;
    assign m_apb_psel_o    = !idle_state ? read_write_sel_s  : 'h0;
    assign m_apb_penable_o = access_state;
    assign m_apb_pwdata_o  = !idle_state ? write_data_s : 'h0;
    assign m_apb_pstrb_o   = {`APB_STRBW{access_state}};

    assign read_data_o     = m_apb_rdata_i;

endmodule
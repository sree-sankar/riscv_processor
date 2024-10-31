//----------------------+-------------------------------------------------------
// Filename             | mem_access.sv
// File created on      | 05.12.2021 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// Memory Access
//------------------------------------------------------------------------------

module mem_access(
    // Input
    input                           clk_i           , // System Clock
    input                           resetn_i        , // System Reset
    input                           halt_i          , // Halt Control Signal
    input  [          `XLEN-1:0]    mem_addr_i      , // Memory Address
    input                           mem_read_en_i   , // Memory Read Data
    input  [          `XLEN-1:0]    mem_read_data_i , // Memory Read Data
    input                           mem_write_en_i  , // Memory Write Data
    input  [          `XLEN-1:0]    mem_write_data_i, // Memory Write Data
    input  [`SYS_REGS_WIDTH-1:0]    rd_addr_i       , // rd register address
    input                           rd_write_en_i   , // rd Write enable
    input  [                4:0]    rd_write_fmt_i  , // rd Write Format
    input  [          `XLEN-1:0]    rd_data_i       , // rd Data In
    // Output
    output [          `XLEN-1:0]    mem_addr_o      , // Memory Address
    output                          mem_read_en_o   , // Memory Read Data
    output                          mem_write_en_o  , // Memory Write Data
    output [          `XLEN-1:0]    mem_write_data_o, // Memory Write Data
    output [`SYS_REGS_WIDTH-1:0]    rd_addr_o       , // rd register address
    output                          rd_write_en_o   , // rd write enable
    output [          `XLEN-1:0]    rd_data_o         // Register Data Out
);

//------------------------------------------------------------------------------
// Memory Enable
//------------------------------------------------------------------------------

    logic [2:0]    resetn_pipe;
    logic          mem_enable ;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            resetn_pipe <= 'h0;
            end
        else
            begin
            resetn_pipe <= {resetn_pipe[1:0],resetn_i};
            end
        end

    assign mem_enable = resetn_pipe[2];

//------------------------------------------------------------------------------
// Pipeline Stages
//------------------------------------------------------------------------------

    logic                          mem_read_en_reg ;
    logic [`SYS_REGS_WIDTH-1:0]    rd_addr_reg     ;
    logic                          rd_write_en_reg ;
    logic [                4:0]    rd_write_fmt_reg;
    logic [          `XLEN-1:0]    rd_data_reg     ;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            mem_read_en_reg  <= 'h0;
            rd_addr_reg      <= 'h0;
            rd_write_en_reg  <= 'h0;
            rd_write_fmt_reg <= 'h0;
            rd_data_reg      <= 'h0;
            end
        else
            begin
            mem_read_en_reg  <= mem_read_en_i ;
            rd_addr_reg      <= rd_addr_i     ;
            rd_write_en_reg  <= rd_write_en_i ;
            rd_write_fmt_reg <= rd_write_fmt_i;
            rd_data_reg      <= rd_data_i     ;
            end
        end

//------------------------------------------------------------------------------
// Memory Data Forwarding
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    mem_addr_reg        ;
    logic                mem_write_en_reg    ;
    logic [`XLEN-1:0]    mem_write_data_reg  ;
    logic [`XLEN-1:0]    mem_read_data       ;
    logic                forward_mem_en      ;
    logic                forward_mem_en_reg  ;
    logic [`XLEN-1:0]    forward_mem_data_reg;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            mem_addr_reg         <= 'h0;
            mem_write_en_reg     <= 'h0;
            mem_write_data_reg   <= 'h0;
            forward_mem_en_reg   <= 'h0;
            forward_mem_data_reg <= 'h0;
            end
        else
            begin
            mem_addr_reg         <= mem_addr_i        ;
            mem_write_en_reg     <= mem_write_en_i    ;
            mem_write_data_reg   <= mem_write_data_i  ;
            forward_mem_en_reg   <= forward_mem_en    ;
            forward_mem_data_reg <= mem_write_data_reg;
            end
        end

    assign forward_mem_en = (mem_addr_reg == mem_addr_i) ? (mem_write_en_reg & mem_read_en_i): 'h0;
    assign mem_read_data  = forward_mem_en_reg ? forward_mem_data_reg : mem_read_data_i;

//------------------------------------------------------------------------------
// Memory Load to rd Write Data Format Muxing
//------------------------------------------------------------------------------

    logic [`XLEN-1:0]    mem2rd_data;

    assign mem2rd_data = (mem_enable & mem_read_en_reg & rd_write_fmt_reg[0]) ? {{(`XLEN-8){mem_read_data[7]}},mem_read_data[7:0]}    :
                         (mem_enable & mem_read_en_reg & rd_write_fmt_reg[1]) ? {{(`XLEN-16){mem_read_data[15]}},mem_read_data[15:0]} :
                         (mem_enable & mem_read_en_reg & rd_write_fmt_reg[2]) ? mem_read_data :
                         (mem_enable & mem_read_en_reg & rd_write_fmt_reg[3]) ? {{(`XLEN-8){1'b0}},mem_read_data[7:0]}   :
                         (mem_enable & mem_read_en_reg & rd_write_fmt_reg[4]) ? {{(`XLEN-16){1'b0}},mem_read_data[15:0]} : 'h0;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    // Memory Access
    assign mem_addr_o       = mem_enable ? mem_addr_i : 'h0;
    assign mem_read_en_o    = mem_read_en_i & !halt_i & mem_enable;
    assign mem_write_en_o   = mem_write_en_i & !halt_i & mem_enable;
    assign mem_write_data_o = mem_enable ? mem_write_data_i : 'h0;
    // Register Write
    assign rd_data_o        = (mem_read_en_reg & mem_enable ) ? mem2rd_data :
                              (!mem_read_en_reg & mem_enable) ? rd_data_reg : 'h0;
    assign rd_addr_o        = mem_enable ? rd_addr_reg     : 'h0;
    assign rd_write_en_o    = mem_enable ? rd_write_en_reg : 'h0;

endmodule
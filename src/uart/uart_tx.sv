//----------------------+-------------------------------------------------------
// Filename             | uart_tx.sv
// File created on      | 14/06/2022 12:48:12
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// System Register
//------------------------------------------------------------------------------
module uart_tx(
    input           clk_i       ,
    input           resetn_i    ,
    input           tx_trigger_i,
    input  [ 7:0]   tx_data_i   ,
    output          tx_busy_o   ,
    output          tx_done_o   ,
    output          uart_tx_o
);

//------------------------------------------------------------------------------
// Control Path
//------------------------------------------------------------------------------

    enum logic [3:0] {
        TX_IDLE  = 'h1,
        TX_START = 'h2,
        TX_DATA  = 'h4,
        TX_STOP  = 'h8
    } tx_state;

    logic    tx_data_done ;
    logic    tx_data_state;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            tx_state <= TX_IDLE;
            end
        else
            begin
            case(tx_state)
                TX_IDLE :
                    begin
                    if(tx_trigger_i)
                        begin
                        tx_state <= TX_START;
                        end
                    end
                TX_START :
                    begin
                    tx_state <= TX_DATA;
                    end
                TX_DATA :
                    begin
                    if(tx_data_done)
                        begin
                        tx_state <= TX_STOP;
                        end
                    end
                TX_STOP :
                    begin
                    tx_state <= TX_IDLE;
                    end
                default :
                    begin
                    tx_state <= TX_IDLE;
                    end
            endcase
            end
        end

    assign tx_data_state = (tx_state == TX_DATA) ? 'h1 : 'h0;
    assign tx_busy_o     = (tx_state == TX_IDLE) ? 'h0 : 'h1;
    assign tx_done_o     = (tx_state == TX_STOP) ? 'h1 : 'h0;

//------------------------------------------------------------------------------
// Data Count and shifting
//------------------------------------------------------------------------------

    logic           uart_tx    ;
    logic [7:0]     tx_data_reg;

    always_comb
        begin
        case(tx_state)
            TX_IDLE :
                begin
                uart_tx <= 'h1;
                end
            TX_START :
                begin
                uart_tx <= 'h0;
                end
            TX_DATA :
                begin
                uart_tx <= tx_data_reg[0];
                end
            TX_STOP :
                begin
                uart_tx <= 'h1;
                end
            default :
                begin
                uart_tx <= 'h1;
                end
        endcase
        end

//------------------------------------------------------------------------------
// Data Count and shifting
// Registering Input data only when not transmitting to avoid gliches
//------------------------------------------------------------------------------

    logic [3:0]     tx_data_count;

    always_ff @(posedge clk_i)
        begin
        if(!resetn_i)
            begin
            tx_data_reg   <= 'h0;
            tx_data_count <= 'h0;
            end
        else
            begin
            if(tx_data_state)
                begin
                tx_data_count <= tx_data_count + 'h1;
                tx_data_reg   <= tx_data_reg >> 1;
                end
            else
                begin
                tx_data_reg   <= tx_data_i;
                tx_data_count <= 'h0;
                end
            end
        end

    assign tx_data_done = (tx_data_count == 'h7) ? 'h1 : 'h0;

//------------------------------------------------------------------------------
// Output
//------------------------------------------------------------------------------

    assign uart_tx_o = uart_tx;

endmodule
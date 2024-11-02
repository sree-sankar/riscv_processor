##----------------------+-------------------------------------------------------
## Filename             | pin_map.sv
## File created on      | 26.10.2024
## Created by           | Sree Sankar E
##                      |
##                      |
##                      |
##----------------------+-------------------------------------------------------
##
##------------------------------------------------------------------------------
## Pin Map for Arty A7-35T Reference Board
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## Clock and Reset
##------------------------------------------------------------------------------

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {clk_i}];
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {resetn_i}];

##------------------------------------------------------------------------------
## UART
##------------------------------------------------------------------------------

set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {uart_tx_o}];
set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33} [get_ports {uart_rx_i}];
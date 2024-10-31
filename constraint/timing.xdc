
##----------------------+-------------------------------------------------------
## Filename             | timing.sv
## File created on      | 26.10.2024
## Created by           | Sree Sankar E
##                      |
##                      |
##                      |
##----------------------+-------------------------------------------------------
##
##------------------------------------------------------------------------------
## Timing
##------------------------------------------------------------------------------

create_clock -add -name clk_i -period 10.00 -waveform {0 5} [get_ports {clk_i}];

##------------------------------------------------------------------------------
## Timing
##------------------------------------------------------------------------------

set_clock_groups -asynchronous -group \
    [get_clocks -of_objects [get_pins clk_generator_inst/clk_gen_inst/inst/mmcm_adv_inst/CLKOUT0]] \
    [get_clocks -of_objects [get_pins clk_generator_inst/clk_gen_inst/inst/mmcm_adv_inst/CLKOUT1]] \
    [get_clocks -of_objects [get_pins clk_generator_inst/clk_gen_inst/inst/mmcm_adv_inst/CLKOUT2]]
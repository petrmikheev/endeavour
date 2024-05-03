## Generated SDC file "endeavour.sdc"

## Copyright (C) 2021  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"

## DATE    "Mon Feb 26 21:32:10 2024"

##
## DEVICE  "10M50SAE144C8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {io_clk_in} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_clk_in}]
create_clock -name {io_plla_clk0} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk0}]
create_clock -name {io_plla_clk1} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk1}]
create_clock -name {io_plla_clk2} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk2}]
create_clock -name {io_pllb_clk0} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk0}]
create_clock -name {io_pllb_clk1} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk1}]
create_clock -name {io_pllb_clk2} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk2}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks -create_base_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock {board_ctrl|pll|altpll_component|auto_generated|pll1|clk[0]} 0 [all_inputs]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock {board_ctrl|pll|altpll_component|auto_generated|pll1|clk[0]} -4.0 [all_outputs]
set_output_delay -clock {board_ctrl|pll|altpll_component|auto_generated|pll1|clk[0]} 0 [get_ports {io_ddr_*}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


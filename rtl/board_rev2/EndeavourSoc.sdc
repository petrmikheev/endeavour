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

create_clock -name {clk48} -period 20.833 -waveform { 0.000 10.416 } [get_ports {io_clk_in}]
#create_clock -name {io_plla_clk0} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk0}]
#create_clock -name {io_plla_clk1} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk1}]
#create_clock -name {io_plla_clk2} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_plla_clk2}]
#create_clock -name {io_pllb_clk0} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk0}]
#create_clock -name {io_pllb_clk1} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk1}]
#create_clock -name {io_pllb_clk2} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk2}]


#**************************************************************
# Create Generated Clock
#**************************************************************

#derive_pll_clocks -create_base_clocks
create_generated_clock -multiply_by 61 -divide_by 45 -source [get_ports io_clk_in] -name clk_tmds_pixel [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[0]]
create_generated_clock -multiply_by 61 -divide_by 9 -source [get_ports io_clk_in] -name clk_tmds_x5 [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[1]]
create_generated_clock -multiply_by 61 -divide_by 33 -source [get_ports io_clk_in] -name clk_cpu [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[2]]
create_generated_clock -multiply_by 61 -divide_by 33 -phase 90 -source [get_ports io_clk_in] -name clk_ram [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[3]]

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

set_input_delay -clock {clk48} 0 [get_ports {io_uart_rx io_*_i2c_sda io_plla_clk* io_pllb_clk*}]
set_input_delay -clock {clk48} 0 [get_ports {io_sdcard_cmd io_sdcard_data* io_sdcard_ndetect}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock {clk48} -4.0 [get_ports {io_uart_tx io_audio_* io_pll*i2c*}]
set_output_delay -clock {clk48} 0 [get_ports {io_sdcard_clk io_sdcard_cmd io_sdcard_data*}]
set_output_delay -clock {clk_cpu} 0 [get_ports {io_ddr_sdram_a* io_ddr_sdram_ba* io_ddr_sdram_cas_n io_ddr_sdram_ras_n io_ddr_sdram_we_n}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {io_nreset io_keys* io_ddr_sdram_dq*}]
set_false_path -to [get_ports {io_leds* io_dvi_* io_ddr_sdram_d* io_ddr_sdram_ck_* io_ddr_sdram_cke}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from clk_cpu -to clk48 10.000
set_max_delay -from clk48 -to clk_cpu 10.000
set_max_delay -from clk_cpu -to clk_tmds_pixel 30.000

#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


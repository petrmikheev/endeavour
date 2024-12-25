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

create_clock -name {clk48}       -period 20.833 -waveform { 0.0  10.416 } [get_ports {io_clk_in}]

# RAM 100 Mhz
#create_clock -name {clk_ram_bus} -period 10.000 -waveform { 0.0  5.000 }  [get_ports {io_plla_clk0}]
#create_clock -name {clk_ram}     -period 10.000 -waveform { 2.5  7.5 }    [get_ports {io_plla_clk1}]

# RAM 110 MHz
#create_clock -name {clk_ram_bus} -period 9.09   -waveform { 0.0   4.545 } [get_ports {io_plla_clk0}]
#create_clock -name {clk_ram}     -period 9.09   -waveform { 2.273 6.818 } [get_ports {io_plla_clk1}]

# RAM 120 MHz
#create_clock -name {clk_ram_bus} -period 8.333  -waveform { 0.0   4.167 } [get_ports {io_plla_clk0}]
#create_clock -name {clk_ram}     -period 8.333  -waveform { 2.083 6.250 } [get_ports {io_plla_clk1}]

# RAM 125 MHz (100 MHz + gap)
create_clock -name {clk_ram_bus}  -period 8.0   -waveform { 0.0   4.0  } [get_ports {io_plla_clk0}]
create_clock -name {clk_ram}      -period 8.0   -waveform { 2.0   6.0  } [get_ports {io_plla_clk1}]

# CPU 60 Mhz
create_clock -name {clk_cpu}     -period 16.666 -waveform { 0.0   8.333 } [get_ports {io_plla_clk2}]

#create_clock -name {io_pllb_clk0} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk0}]
#create_clock -name {io_pllb_clk1} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk1}]
#create_clock -name {io_pllb_clk2} -period 10.000 -waveform { 0.000 5.000 } [get_ports {io_pllb_clk2}]

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -multiply_by 116 -divide_by 75 -source [get_ports io_clk_in] -name clk_tmds_pixel [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[0]]
create_generated_clock -multiply_by 116 -divide_by 15 -source [get_ports io_clk_in] -name clk_tmds_x5 [get_pins board_ctrl|pll|altpll_component|auto_generated|pll1|clk[1]]

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
#set_input_delay -clock {clk48} 0 [get_ports {io_sdcard_cmd io_sdcard_data* io_sdcard_ndetect io_usb*}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock {clk48} -4.0 [get_ports {io_uart_tx io_audio_* io_pll*i2c*}]
#set_output_delay -clock {clk48} 0 [get_ports {io_sdcard_clk io_sdcard_cmd io_sdcard_data* io_usb*}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {io_nreset io_keys*}]
set_false_path -to [get_ports {io_leds*}]
set_false_path -to [get_ports {io_dvi_*}]

set_false_path -from [get_ports {io_ddr_sdram_dq*}]
set_false_path -from [get_ports {io_sdcard_* io_usb*}]

#set_false_path -setup -to [get_ports {io_ddr_sdram_*}]
set_false_path -hold -to [get_ports {io_ddr_sdram_*}]
set_false_path -hold -to [get_ports {io_sdcard_* io_usb*}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from clk_cpu -to clk48 10.000
set_max_delay -from clk48 -to clk_cpu 10.000
set_max_delay -from clk_cpu -to clk_ram_bus 10.000
set_max_delay -from clk_ram_bus -to clk_cpu 10.000
set_max_delay -from clk48 -to clk_ram_bus 20.000
set_max_delay -from clk_ram_bus -to clk48 20.000
set_max_delay -from clk_cpu -to clk_tmds_pixel 30.000
set_max_delay -from clk_tmds_pixel -to clk_cpu 30.000
set_max_delay -from clk_tmds_pixel -to clk_tmds_x5 2.69

set_min_delay -from [get_clocks clk_ram_bus] -to [get_ports {io_ddr_sdram_*}] 10
set_max_delay -from [get_clocks clk_ram_bus] -to [get_ports {io_ddr_sdram_*}] 11
set_min_delay -from [get_clocks clk_ram] -to [get_ports {io_ddr_sdram_*}] 10
set_max_delay -from [get_clocks clk_ram] -to [get_ports {io_ddr_sdram_*}] 11

set_min_delay -from [get_clocks clk48] -to [get_ports {io_sdcard_clk io_sdcard_cmd io_sdcard_data* io_usb*}] 13
set_max_delay -from [get_clocks clk48] -to [get_ports {io_sdcard_clk io_sdcard_cmd io_sdcard_data* io_usb*}] 14

#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from clk_cpu -to clk48 -5.000
set_min_delay -from clk48 -to clk_cpu -5.000
set_min_delay -from clk48 -to clk_ram_bus -5.000
set_min_delay -from clk_cpu -to clk_tmds_pixel -15.000
set_min_delay -from clk_tmds_pixel -to clk_cpu -15.000

#**************************************************************
# Set Input Transition
#**************************************************************

# JTAG

create_clock -name {jtag_tck}       -period 50.0 -waveform { 0.0  25.0 } [get_ports {io_jtag_tck}]
set_input_delay -clock {jtag_tck} -15.0 [get_ports {io_jtag_tdi io_jtag_tms}]
set_output_delay -clock {jtag_tck} 0 [get_ports {io_jtag_tdo}]

set_global_assignment -entity "DDR_O2" -library "lib_DDR_O2" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "DDR_O2" -library "lib_DDR_O2" -name IP_TOOL_VERSION "21.1"
set_global_assignment -entity "DDR_O2" -library "lib_DDR_O2" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_DDR_O2" -name SPD_FILE [file join $::quartus(sip_path) "DDR_O2.spd"]

set_global_assignment -library "lib_DDR_O2" -name MISC_FILE [file join $::quartus(sip_path) "DDR_O2_sim/DDR_O2.v"]
set_global_assignment -library "lib_DDR_O2" -name MISC_FILE [file join $::quartus(sip_path) "DDR_O2_sim/altera_gpio_lite/altera_gpio_lite.sv"]

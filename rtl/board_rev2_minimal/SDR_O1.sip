set_global_assignment -entity "SDR_O1" -library "lib_SDR_O1" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "SDR_O1" -library "lib_SDR_O1" -name IP_TOOL_VERSION "21.1"
set_global_assignment -entity "SDR_O1" -library "lib_SDR_O1" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_SDR_O1" -name SPD_FILE [file join $::quartus(sip_path) "SDR_O1.spd"]

set_global_assignment -library "lib_SDR_O1" -name MISC_FILE [file join $::quartus(sip_path) "SDR_O1_sim/SDR_O1.v"]
set_global_assignment -library "lib_SDR_O1" -name MISC_FILE [file join $::quartus(sip_path) "SDR_O1_sim/altera_gpio_lite/altera_gpio_lite.sv"]

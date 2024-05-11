transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdwb.v}
vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdio_top.v}
vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdio.v}
vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdfrontend.v}
vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdcmd.v}
vlog -vlog01compat -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdckgen.v}
vlog -vlog01compat -work work +incdir+/home/petya/endeavour/rtl2/spinal {/home/petya/endeavour/rtl2/spinal/EndeavourSoc.v}
vlog -vlog01compat -work work +incdir+/home/petya/endeavour/rtl2/board_rev1 {/home/petya/endeavour/rtl2/board_rev1/PLL.v}
vlog -vlog01compat -work work +incdir+/home/petya/endeavour/rtl2/board_rev1 {/home/petya/endeavour/rtl2/board_rev1/OnChipRAM.v}
vlog -vlog01compat -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/db {/home/petya/endeavour/rtl2/board_rev1/db/PLL_altpll.v}
vlog -sv -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdrxframe.sv}
vlog -sv -work work +incdir+/home/petya/sdspi/rtl {/home/petya/sdspi/rtl/sdtxframe.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/verilog {/home/petya/endeavour/rtl2/verilog/video_controller.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/verilog {/home/petya/endeavour/rtl2/verilog/uart_controller.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/verilog {/home/petya/endeavour/rtl2/verilog/sdcard_controller.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/verilog {/home/petya/endeavour/rtl2/verilog/internal_ram.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/verilog {/home/petya/endeavour/rtl2/verilog/clocking.sv}

vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/../testbench {/home/petya/endeavour/rtl2/board_rev1/../testbench/testbench.sv}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog {/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog/mdl_sdcmd.v}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog {/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog/mdl_sdio.v}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog {/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog/mdl_sdrx.v}
vlog -sv -work work +incdir+/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog {/home/petya/endeavour/rtl2/board_rev1/../../../sdspi/bench/verilog/mdl_sdtx.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
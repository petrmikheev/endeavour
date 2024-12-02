sources = ../verilog/*.sv ../verilog/*.v ../spinal/sim/EndeavourSoc.v ../ext/sdspi/rtl/sd*.v
sources_minimal = ../verilog/board_controller.sv ../verilog/i2c.sv ../verilog/uart_controller.sv ../verilog/internal_ram_minimal.sv ../spinal/EndeavourMinimalSoc.v ../verilog/audio_controller.sv
testbench_sources = ../ext/sdspi/bench/verilog/mdl_*.v micron_ddr_sdram_model.v io_buf.sv usb_device.sv ../ext/core_usb_*/src_v/*.v

build: testbench.vvp testbench_minimal.vvp

testbench.vvp: testbench.sv $(sources) $(testbench_sources)
	l_sources="" ; \
	for x in $(sources) $(testbench_sources); do l_sources="$$l_sources -l $$x"; done ; \
	iverilog -g2012 testbench.sv $$l_sources -o testbench.vvp -DIVERILOG -I../ext/core_usb_cdc/src_v

testbench_minimal.vvp: testbench_minimal.sv $(sources_minimal)
	l_sources="" ; \
	for x in $(sources_minimal); do l_sources="$$l_sources -l $$x"; done ; \
	iverilog -g2012 testbench_minimal.sv $$l_sources -o testbench_minimal.vvp -DIVERILOG -DMINIMAL

.PHONY: run
run: testbench.vvp
	./testbench.vvp $(ARGS)

.PHONY: clean
clean:
	rm -f testbench.vvp testbench_minimal.vvp dump.vcd dump_minimal.vcd

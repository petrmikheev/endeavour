sources = ../verilog/*.sv ../verilog/*.v ../spinal/sim/EndeavourSoc.v ../ext/sdspi/rtl/sd*.v
testbench_sources = ../ext/sdspi/bench/verilog/mdl_*.v micron_ddr_sdram_model.v io_buf.sv usb_device.sv ../ext/core_usb_*/src_v/*.v

testbench.vvp: testbench.sv $(sources) $(testbench_sources)
	l_sources="" ; \
	for x in $(sources) $(testbench_sources); do l_sources="$$l_sources -l $$x"; done ; \
	iverilog -g2012 testbench.sv $$l_sources -o testbench.vvp -DIVERILOG -I../ext/core_usb_cdc/src_v

.PHONY: run
run: testbench.vvp
	./testbench.vvp $(ARGS)

.PHONY: clean
clean:
	rm -f testbench.vvp dump.vcd

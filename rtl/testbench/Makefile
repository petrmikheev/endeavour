sources = ../verilog/*.sv ../spinal/EndeavourSoc.v /home/petya/sdspi/rtl/sd*.v
testbench_sources = /home/petya/sdspi/bench/verilog/mdl_*.v
#testbench_sources = testbench/quartus_ip_sim.sv testbench/micron_ddr_sdram_model.v

.PHONY: runbench
runbench: testbench.vvp
	./testbench.vvp $(ARGS)

testbench.vvp: testbench.sv $(sources) $(testbench_sources)
	l_sources="" ; \
	for x in $(sources) $(testbench_sources); do l_sources="$$l_sources -l $$x"; done ; \
	iverilog -g2012 testbench.sv $$l_sources -o testbench.vvp -DIVERILOG

.PHONY: clean
clean:
	rm -f testbench.vvp dump.vcd

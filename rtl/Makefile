sources = endeavour.sv internal_ram.sv VexRiscvGen/VexRiscvWithCrossbar.v controllers/*.sv controllers/*.v

build: output_files/endeavour.sof endeavour.svf endeavour_flash.svf

VexRiscvGen/VexRiscvWithCrossbar.v: VexRiscvGen/src/main/scala/endeavour/VexRiscvGen.scala
	cd VexRiscvGen && sbt 'runMain endeavour.VexRiscvGen' && cd ..

output_files/endeavour.sof: endeavour.qpf endeavour.qsf endeavour.sv $(sources) ../software/bootloader/bootloader.hex
	quartus_sh --flow compile endeavour.qpf

endeavour.svf: output_files/endeavour.sof
	quartus_cpf -c -q 10MHz -g 3.3 -n v output_files/endeavour.sof $@

endeavour_flash.svf: output_files/endeavour.sof
	quartus_cpf -c -q 10MHz -g 3.3 -n p output_files/endeavour.pof $@

.PHONY: write
write: endeavour.svf
	sudo rmmod ftdi_sio
	sudo ../mbftdi/mbftdi endeavour.svf
	sudo modprobe ftdi_sio

.PHONY: write_flash
write_flash: endeavour_flash.svf
	sudo rmmod ftdi_sio
	sudo ../mbftdi/mbftdi endeavour_flash.svf
	sudo modprobe ftdi_sio

.PHONY: runbench
runbench: sim/testbench.vvp
	./sim/testbench.vvp

sim/testbench.vvp: sim/testbench.sv sim/micron_ddr_sdram_model.v $(sources)
	l_sources="" ; \
	for x in $(sources); do l_sources="$$l_sources -l $$x"; done ; \
	iverilog -g2012 sim/testbench.sv $$l_sources -o sim/testbench.vvp -DIVERILOG

.PHONY: clean
clean:
	rm -f sim/testbench.vvp sim/testbench.vcd endeavour.svf endeavour_flash.svf

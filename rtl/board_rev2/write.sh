#!/bin/bash

sudo rmmod ftdi_sio
sudo ../../mbftdi/mbftdi EndeavourSoc.svf
sudo modprobe ftdi_sio
sleep 1
sudo chmod a+rw /dev/ttyUSB1











# Makefile draft

#-sources = endeavour.sv internal_ram.sv VexRiscvGen/VexRiscvWithCrossbar.v controllers/*.sv controllers/*.v
#-testbench_sources = testbench/quartus_ip_sim.sv testbench/micron_ddr_sdram_model.v
#-
#-build: output_files/endeavour.sof endeavour.svf endeavour_flash.svf
#-
#-VexRiscvGen/VexRiscvWithCrossbar.v: VexRiscvGen/src/main/scala/endeavour/VexRiscvGen.scala
#-	cd VexRiscvGen && sbt 'runMain endeavour.VexRiscvGen' && cd ..
#-
#-#output_files/endeavour.sof: endeavour.qpf endeavour.qsf endeavour.sv $(sources) ../software/bootloader/bootloader.hex
#-#	quartus_sh --flow compile endeavour.qpf
#-
#-endeavour.svf: output_files/endeavour.sof
#-	quartus_cpf -c -q 10MHz -g 3.3 -n v output_files/endeavour.sof $@
#-
#-endeavour_flash.svf: output_files/endeavour.sof
#-	quartus_cpf -c -q 10MHz -g 3.3 -n p output_files/endeavour.pof $@
#-
#-.PHONY: write
#-write: endeavour.svf
#-	sudo rmmod ftdi_sio
#-	sudo ../mbftdi/mbftdi endeavour.svf
#-	sudo modprobe ftdi_sio
#-
#-.PHONY: write_flash
#-write_flash: endeavour_flash.svf
#-	sudo rmmod ftdi_sio
#-	sudo ../mbftdi/mbftdi endeavour_flash.svf
#-	sudo modprobe ftdi_sio
#-
#-.PHONY: runbench
#-runbench: testbench/testbench.vvp
#-	./testbench/testbench.vvp
#-
#-testbench/testbench.vvp: testbench/testbench.sv $(sources) $(testbench_sources)
#-	l_sources="" ; \
#-	for x in $(sources) $(testbench_sources); do l_sources="$$l_sources -l $$x"; done ; \
#-	iverilog -g2012 testbench/testbench.sv $$l_sources -o testbench/testbench.vvp -DIVERILOG
#-
#-.PHONY: clean
#-clean:
#-	rm -f testbench/testbench.vvp testbench/dump.vcd endeavour.svf endeavour_flash.svf

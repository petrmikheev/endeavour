sources = ../verilog/*.sv ../verilog/*.v ../spinal/EndeavourSoc.v /home/petya/sdspi/rtl/sd*.v

build: output_files/EndeavourSoc.sof endeavour.svf endeavour_flash.svf

../splinal/EndeavourSoc.v: ../spinal/src/main/scala/endeavour/*.scala
	pushd ../spinal && sbt 'runMain endeavour.EndeavourSoc' && popd

output_files/EndeavourSoc.sof: endeavour.qpf EndeavourSoc.qsf $(sources) ../../software/bios/bios.hex
	quartus_sh --flow compile endeavour.qpf -c EndeavourSoc

endeavour.svf: output_files/EndeavourSoc.sof
	quartus_cpf -c -q 10MHz -g 3.3 -n v output_files/EndeavourSoc.sof $@

endeavour_flash.svf: output_files/EndeavourSoc.sof
	quartus_cpf -c -q 10MHz -g 3.3 -n p output_files/EndeavourSoc.pof $@

.PHONY: write
write:
	sudo rmmod ftdi_sio
	sudo ../../mbftdi/mbftdi endeavour.svf
	sudo modprobe ftdi_sio
	sleep 0.5
	../../scripts/setup_uart.sh

.PHONY: write_flash
write_flash:
	sudo rmmod ftdi_sio
	sudo ../../mbftdi/mbftdi endeavour_flash.svf
	sudo modprobe ftdi_sio
	sleep 0.5
	../../scripts/setup_uart.sh

.PHONY: clean
clean:
	rm -f endeavour.svf endeavour_flash.svf

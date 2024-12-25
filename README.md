Endeavour - open-source FPGA board and SoC
==========================================

| | |
|:-------------------------:|:-------------------------:|
| <img height=270 src="images/intro/blueprint.jpg"> | <img height=270 src="images/intro/soldering.jpg"> |
| <img height=270 src="images/hardware/rev2_front.jpg"> | <img height=270 src="images/intro/display.jpg"> |

### Project goal

- Design my own FPGA board and make a computer based on it.
- "A computer" means being able to attach a display and keyboard, and write and compile software directly on the device.
- Try to achieve best possible performance without using BGA chips. It is my first hardware project, I wasn't sure in my soldering skills and decided not to deal with BGA yet.

What are the practical uses of the device? No practical use. It is a hobby project, I just wanted to do it.

### Results

- It works and runs linux!
- It was fun to write from scratch SBI, bootloader, some linux drivers, implementation of ANSI escape sequences, text-based window manager.
- 128 MB DDR1 RAM works at 100 MHz (i.e. throughput limit is 400 MB/s). Configuring FPGA IO timing constraints wasn't fun at all.
- CPU: VexiiRiscv, 1 core, 60 MHz, 2.0 DMIPS/MHz.

Initially I planned to make a video game optimized specifically for this FPGA board. But now I am considering to skip this step and try to design a more advanced FPGA board.

## Hardware

### Components

**FPGA**

Due to the "I can't solder BGA" limitation there wasn't much choice.

I use 10M50SAE144, Intel MAX10 series, as currently (2024) it is by a huge margin the biggest (50K logic cells) non-BGA FPGA chip and also over all alternatives has the largest number of available IO pins.

- 10M50SAE144, EQFP-144
- 50K logic cells
- 182 M9K blocks
- 101 IO pin
- 1 PLL

**RAM**

Seems all RAM starting from DDR2 are BGA-only. I chose the biggest available DDR1 chip:

- AS4C64M16D1, TSOP66
- DDR1 128MB
- Max frequency 166Mhz
- CL 2 (up to 133Mhz) or 2.5 (up to 166Mhz)
- 16 data pins
- Max theoretical throughput: 664 MB/s

There is an option to use a smaller compatible chip. E.g. AS4C32M16D1 (64MB).

**Other chips**

- USB to UART/JTAG converter: FT2232HL
- 48Mhz clock generator, 2x external PLL Si5351A
- audio: D2A converter MCP4728, amplifier LM4811
- dc-dc converters: AP63203WU (5V -> 3.3V), AP2114H (3.3V -> 2.5V)

### Interfaces

Main interfaces

- USB-C: power / JTAG / UART / USB1.1 device
- Micro SD card slot
- DVI-D with HDMI connector
- 2x USB-A: USB1.1 host
- 3.5mm stereo audio

LEDs and buttons

- power button
- power LED
- FTDI power switch
- USB-C data lines switch "to FTDI" / "direct connection to FPGA"
- 3 LEDs
- 2 push buttons
- 1 switch (used as CPU reset)

For future extensions

- 3 GPIO pins
- 9 configurable GPIO/analog input pins
- 1 dedicated analog input pin

### Revision 1

<details>
  <summary>First attempt wasn't fully successful (though as expected). Keeping it here for history.</summary>

Results:

- practiced soldering;
- tested powering scheme, tested flashing via JTAG over FT2232HL;
- tested UART and SD card controllers;
- found some problems in the scheme, e.g. found out that USB-C requires 5.1K resistors to get power from the cable.
- DVI-D interface didn't work, mostly due to soldering errors;
- tried scheme with 4 AS4C32M16D1 DDR1 (4*64=256MB RAM in total) on a single bus, but even a single chip didn't work properly.
  Either because FPGA IO delays were configured incorrectly, or because tracks on PCB were too long.
  I decided to simplify the scheme: in second revision there is only a single 128MB DDR1 chip placed right under the FPGA in order to minimize tracks length and tracks length inequality.

[KiCad project](hardware/rev1), [gerber files](hardware/rev1/export)

  <img width=600 src="images/hardware/rev1.jpg">
</details>

### Revision 2

[KiCad project](hardware/rev2), [gerber files](hardware/rev2/export)

<details>
  <summary>images</summary>

  <img width=800 src="images/hardware/rev2_front_3d.jpg">
  <img width=800 src="images/hardware/rev2_back_3d.jpg">

  <img width=800 src="images/hardware/rev2_front.jpg">
  <img width=800 src="images/hardware/rev2_back.jpg">

</details>

## RTL

Used open source IP cores:

- [VexiiRiscv](https://github.com/SpinalHDL/VexiiRiscv/) - RISC-V core written in SpinalHDL. Special thanks to Dolu1990, the author of SpinalHDL and VexiiRiscv, for patiently answering my questions.
- A few components distributed with [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL): Tilelink interconnect, APB3 and AXI4 bridges, USB OHCI controller, Plic Mapper.
- [ZipCPU/sdspi SD-Card controller](https://github.com/ZipCPU/sdspi) with minor tweaks needed to use it with Intel/Altera FPGAs. In theory it requires 96-104 MHz base clock, but in my setup it couldn't work on such frequency, so I use it with 48 Mhz clock (same as for USB) and in software setup frequency with x2 coefficient. Data transfer speed is up to 24 MB/s.
- DDR1 sdram controller in my SoC is based on [FPGA-DDR-SDRAM by WangXuan95](https://github.com/WangXuan95/FPGA-DDR-SDRAM). I switched it to DDIO IO primitives, added `wstrb` support, changed bus width to 64 bit, and optimized some parts for better fMax. On my FPGA board it works stable at frequency up to 100 MHz (i.e. upper bound for throughput is 400 MB/s).
- Also in testbench I used [USB CDC Device](https://github.com/ultraembedded/core_usb_cdc) written by ultraembedded as a model of a connected USB device.

Components designed from scratch:

- DVI-D video controller. Features: independent text and graphic layers, transparency support, changing fonts in runtime, changing screen resolution in runtime. 32-bit APB3 control interface and 64-bit Tilelink DMA interface.
- UART and I2C implementation.
- Audio controller. Stereo, 12 bit per channel, up to 44.1 kHz sample rate, volume control.

[SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) is used to bring this all together.

There are several clock domains in the design:

- 100 Mhz - RAM
- 60 MHz - VexiiRiscv core, Tilelink hub, video DMA, USB OHCI
- 48 MHz - UART controller, audio controller, sdcard controller, USB phy, timer
- pixel clock (from 25.175 to 74.25 MHz depending on resolution)
- TMDS encoder bit clock (from 125.875 to 371.25 MHz; output signal frequency is twice higher thanks to DDIO primitives)

Pixel clock and TMDS clock are generated by internal PLL. CPU and RAM clocks are generated by Si5351A chip that is configured on startup via I2C.

**Address map**

See details in [endeavour_defs.h](software/include/endeavour_defs.h).

| | |
| --- | --- |
| `0x00001000 - 0x0000100B` | UART controller |
| `0x00002000 - 0x00002007` | Audio controller |
| `0x00003000 - 0x0000301F` | SD card controller |
| `0x00004000 - 0x0000402B` | LEDs, keys, timer, frequency control |
| `0x00009000 - 0x00009017` | Video controller |
| `0x0000A000 - 0x0000A05B` | OHCI controller |
| `0x04000000 - 0x07FFFFFF` | PLIC |
| `0x40000000 - 0x40001FFF` | BIOS ROM (8 KB) |
| `0x40002000 - 0x40003FFF` | Internal RAM (8 KB) |
| `0x80000000 - 0x87FFFFFF` | External RAM (128 MB) |

## Software

**[software/bios](software/bios)**

Initializes text video mode, runs memtest, initializes sdcard, loads bootsector and starts bootloader. Provides UART console for debugging. Provides a few functions like printf/sscanf (see at the end of [endeavour_defs.h](software/include/endeavour_defs.h)).

**[software/bootloader](software/bootloader)**

Bootloader with EXT2 filesystem support. Built-in console allows to set screen resolution and wallpaper (only 16bit BMP supported), view text files, run files in M mode, load and run linux kernel in S mode. Implements riscv timer SBI extension.

**[software/linux](software/linux)**

Contains linux kernel config and drivers for UART, SD card, and display (audio driver currently not implemented).

**[software/textwm](software/textwm)**

Text-based window manager. Features:

- Implementation of ANSI escape sequences.
- Conversion from keyboard scancodes to ANSI codes.
- Virtual TTYs /dev/ttyp0 - /dev/ttyp6. Each can work in fullscreen or windowed mode.
- UTF8 support.
- Configurable screen resolution, font, wallpaper, text styles, window background color and transparency.


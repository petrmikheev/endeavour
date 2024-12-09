#include "../include/endeavour_defs.h"

#ifdef NO_DISPLAY
#define charmap 0
#endif

#ifdef NO_SDCARD
#define sdread_impl start
#define sdwrite_impl start
#endif

.section .text.startup
.global _start
_start:
    j start        # bios_reset
.align 2
    j putc_impl    # bios_putc
.align 2
    j printf_impl  # bios_printf
.align 2
    j sscanf_impl  # bios_sscanf
.align 2
    j sdread_impl  # bios_sdread
.align 2
    j sdwrite_impl # bios_sdwrite
.align 2
    .word charmap  # BIOS_CHARMAP_ADDR
.align 2
    j gets_impl    # bios_gets
.align 2
    j uart_read    # bios_read_uart
.align 2
    j crc32_impl   # bios_crc32
.align 2
    j uart_console # bios_uart_console
.align 2
    j beep_impl    # bios_beep
start:
    csrci mstatus, 8
    li sp, BIOS_STACK_ADDR
    la t0, trap
    csrw mtvec, t0
    j main
trap:
    csrr a1, mcause
    la a0, trap_msg
    csrr a2, mtval
    csrr a3, mepc
    mv a4, sp
    mv a5, ra
    li sp, BIOS_STACK_ADDR
    jal printf_impl
    jal uart_flush
    j uart_console

.section .rodata

trap_msg: .ascii "TRAP\n\tcause = %8x\n\ttval  = %8x\n\tepc   = %8x\n\tsp\t= %8x\n\tra\t= %8x\n\0"

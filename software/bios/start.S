#include "../include/endeavour_defs.h"

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
wait_reset:        # bios_wait_reset
    jal uart_flush
    li a0, 0
    jal uart_getc
    # continue to start (reset)
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
    j wait_reset

.section .rodata

trap_msg: .ascii "TRAP\n\tcause = %8x\n\ttval  = %8x\n\tepc   = %8x\n\tsp\t= %8x\n\tra\t= %8x\n\0"

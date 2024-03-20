#include "../include/endeavour_defs.h"

.section .text.startup
.global _start
_start:
    li t0, CPU_FREQ / 115200 - 1
    li t1, UART_DIVISOR_ADDR
    sw t0, 0(t1) // set UART baud rate to 115200
    li sp, INTERNAL_RAM_ADDR + INTERNAL_RAM_SIZE
    jal ra, main
inf_loop:
    j inf_loop

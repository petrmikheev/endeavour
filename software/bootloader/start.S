#include "../include/endeavour_defs.h"

.section .text.startup
.global _start
_start:
    j start       # bios_reset
    j putc_impl   # bios_putc
    j printf_impl # bios_printf
    j sscanf_impl # bios_sscanf
start:
    li sp, INTERNAL_RAM_ADDR + INTERNAL_RAM_SIZE
    j main

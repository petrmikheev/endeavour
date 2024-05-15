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
    ret # bios_set_cursor_pos
.align 2
    ret # bios_scroll_text
.align 2
    .word charmap
start:
    li sp, BIOS_STACK_ADDR
    j main

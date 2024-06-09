.section .text.startup
.global _start
_start:
.option push
.option norelax
    la gp, __global_pointer$
.option pop
    li t0, -1
    csrw mie, t0
    csrs mstatus, 1<<3
    j main

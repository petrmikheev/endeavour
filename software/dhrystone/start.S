.section .text.startup
.global _start
_start:
.option push
.option norelax
    la gp, __global_pointer$
.option pop
    j main

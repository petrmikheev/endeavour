.section .text.startup
.global _start
_start:
    j main

.global drop_cache
drop_cache:
    .word 0x500F
    ret

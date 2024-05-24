#include "../include/endeavour_defs.h"

.section .text.startup
.global _start
_start:
    li sp, BIOS_STACK_ADDR
    la t0, trap
    csrw mtvec, t0
    j main

.global run_kernel  # void run_kernel(void* kernel)
run_kernel:
    csrw mepc, a0  # kernel addr
    li a0, 0       # hartid
    la a1, dtb

    # mstatus.mpp = 01 (S mode)
    li t0, 0x1000
    li t1, 0x0800
    csrc mstatus, t0
    csrs mstatus, t1

    # delegate all interrupts to S mode
    li t0, -1
    csrw mideleg, t0

    # delegate some exceptions to S mode
    li t0, (1<<12) | (1<<13) | (1<<15)
    csrw medeleg, t0

    # switch to S mode and jump to kernel addr
    fence.i
    mret

trap:
    # save context
    csrw mscratch, sp
    li sp, BIOS_STACK_ADDR - 56
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    sw a2, 28(sp)
    sw a3, 32(sp)
    sw a4, 36(sp)
    sw a5, 40(sp)
    sw a6, 44(sp)
    sw a7, 48(sp)
    sw ra, 52(sp)

    li t0, 9
    csrr t1, mcause
    beq t0, t1, ecall
    mv   a0, t1       # mcause
    csrr a1, mtval    # mtval
    csrr a2, mepc     # mepc
    csrr a3, mscratch # sp
    mv   a4, ra       # ra
    jal fatal_trap_handler
infloop:
    j infloop

ecall:
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
    mv a2, a6
    mv a3, a7
    jal sbi_handler

    # restore context
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    lw a2, 28(sp)
    lw a3, 32(sp)
    lw a4, 36(sp)
    lw a5, 40(sp)
    lw a6, 44(sp)
    lw a7, 48(sp)
    lw ra, 52(sp)
    csrr sp, mscratch

    mret

.global dtb
.align 3
dtb:
    .incbin "endeavour.dtb"

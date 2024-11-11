#include "../include/endeavour_defs.h"

#define STACK_ADDR 0x40002400

.section .text.startup
.global _start
_start:
.option push
.option norelax
    la gp, __global_pointer$
.option pop
    li sp, STACK_ADDR
    la t0, trap
    csrw mtvec, t0
    j main

.global run_kernel  # void run_kernel(void* kernel)
run_kernel:
    csrw mepc, a0  # kernel addr
    li a0, 0       # hartid
    la a1, dtb

    # mstatus.mpp = 01 (S mode), unset mie/mpie
    li t0, 0x1000 | (1<<3) | (1<<7)
    li t1, 0x0800
    csrc mstatus, t0
    csrs mstatus, t1

    # delegate interrupts to S mode
    li t0, ~(1<<11)
    csrw mie, t0
    li t0, -1
    csrw mideleg, t0

    # delegate exceptions to S mode
    li t0, (1<<2) | (1<<3) | (1<<5) | (1<<6) | (1<<8) | (1<<12) | (1<<13) | (1<<15)
    csrw medeleg, t0

    csrwi satp, 0  # turn off virtual memory in S mode
    fence.i
    mret           # switch to S mode and jump to kernel addr

trap:
    # save sp, t0, t1
    csrw mscratch, sp
    li sp, STACK_ADDR - 56
    sw t0, 0(sp)
    sw t1, 4(sp)

    # check timer interrupt
    li t0, (1<<31) | 7
    csrr t1, mcause
    beq t0, t1, timer_interrupt

    li t0, 9
    bne t0, t1, fatal_trap

    # ecall
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0  # set mepc to next command to prevent loop

    li t0, 0x54494D45 # timer extension
    beq t0, a7, set_timer

    # save the rest of the context before calling C code
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

    mv a2, a6
    mv a3, a7
    jal sbi_handler

    # restore context
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
    j trap_ret

set_timer:
    la t0, BOARD_TIMECMP
    li t1, -1
    sw t1, 4(t0)
    sw a0, 0(t0)
    sw a1, 4(t0)
    li t0, 1<<5
    csrc mip, t0  # clear S timer interrupt
    li a0, 0
    li a1, 0
    j trap_ret

timer_interrupt:
    la t0, BOARD_TIMECMPH
    li t1, -1
    sw t1, 0(t0)  # disable timer to prevent loop
    li t0, 1<<5
    csrs mip, t0  # trigger S timer interrupt
    # continue to trap_ret

trap_ret:
    lw t0, 0(sp)
    lw t1, 4(sp)
    csrr sp, mscratch
    mret

fatal_trap:
    mv   a0, t1       # mcause
    csrr a1, mtval    # mtval
    csrr a2, mepc     # mepc
    csrr a3, mscratch # sp
    mv   a4, ra       # ra
    jal fatal_trap_handler
infloop:
    j infloop

.section .rodata
.global dtb
.align 3
dtb:
    .incbin "endeavour.dtb"

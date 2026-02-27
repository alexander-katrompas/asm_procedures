// nonleaf_call_demo.S — AArch64 (ARM64) procedure demo (NON-LEAF function)
// Demonstrates a NON-LEAF procedure: a function that CALLS another function.
//
// Functions:
//   long add3(long a, long b, long c)           // leaf helper
//   long add3_then_double(long a,long b,long c) // non-leaf: calls add3, then doubles
//
// Calling convention (AArch64 SysV / Linux):
//   args: x0, x1, x2
//   return: x0
//
// Build (ARM64 native):
//   gcc -no-pie -O0 -g nonleaf_call_demo.S -o nonleaf_demo
//   ./nonleaf_demo
//
// Build (x86 cross + QEMU):
//   aarch64-linux-gnu-gcc -no-pie -O0 -g nonleaf_call_demo.S -o nonleaf_demo
//   qemu-aarch64 -L /usr/aarch64-linux-gnu ./nonleaf_demo

        .text
        .global main
        .global add3
        .global add3_then_double
        .extern printf

main:
        // Prologue
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!

        // Prepare arguments for add3_then_double(a,b,c)
        mov     x0, #7          // a = 7
        mov     x1, #5          // b = 5
        mov     x2, #9          // c = 9

        bl      add3_then_double // returns in x0

        // Save result across printf
        mov     x19, x0

        // printf("2*add3(7,5,9) = %ld\n", result);
        adrp    x0, fmt
        add     x0, x0, :lo12:fmt
        mov     x1, x19
        bl      printf

        // return 0
        mov     w0, wzr

        // Epilogue
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

// ------------------------
// add3 — LEAF procedure
// ------------------------
add3:
        // Computes x0 = x0 + x1 + x2
        add     x0, x0, x1
        add     x0, x0, x2
        ret

// ------------------------
// add3_then_double — NON-LEAF procedure
// ------------------------
add3_then_double:
        // Non-leaf because it CALLS add3 (BL).
        // Therefore it must preserve LR (x30), because BL overwrites x30.
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp

        bl      add3            // uses x0,x1,x2; returns sum in x0

        // Double result: x0 = x0 * 2
        lsl     x0, x0, #1

        // Restore LR and return
        ldp     x29, x30, [sp], #16
        ret

        .section .rodata
fmt:
        .asciz  "2*add3(7,5,9) = %ld\n"

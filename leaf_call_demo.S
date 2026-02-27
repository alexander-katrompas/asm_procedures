// leaf_call_demo.S — AArch64 (ARM64) procedure demo (LEAF function)
// Demonstrates a LEAF procedure: a function that does NOT call other functions.
//
// Function:
//   long add3(long a, long b, long c)   // returns a+b+c
//
// Calling convention (AArch64 SysV / Linux):
//   args: x0, x1, x2
//   return: x0
//
// Build (ARM64 native):
//   gcc -no-pie -O0 -g leaf_call_demo.S -o leaf_demo
//   ./leaf_demo
//
// Build (x86 cross + QEMU):
//   aarch64-linux-gnu-gcc -no-pie -O0 -g leaf_call_demo.S -o leaf_demo
//   qemu-aarch64 -L /usr/aarch64-linux-gnu ./leaf_demo

        .text
        .global main
        .global add3
        .extern printf

main:
        // Prologue
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!

        // Prepare arguments for add3(a,b,c)
        mov     x0, #7          // a = 7
        mov     x1, #5          // b = 5
        mov     x2, #9          // c = 9

        bl      add3            // returns in x0

        // Save result across printf
        mov     x19, x0

        // printf("add3(7,5,9) = %ld\n", result);
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
        // No BL inside: this is a leaf.
        // Computes x0 = x0 + x1 + x2
        add     x0, x0, x1
        add     x0, x0, x2
        ret

        .section .rodata
fmt:
        .asciz  "add3(7,5,9) = %ld\n"

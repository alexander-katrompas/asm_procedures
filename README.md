# AArch64 Procedures Demo (Leaf vs Non-Leaf)

This repo contains two small AArch64 (ARM64) assembly programs that demonstrate the key idea from Chapter 2: **procedures** and the difference between **leaf** and **non-leaf** functions.

- **Leaf procedure:** does *not* call any other function → typically does not need to preserve `LR` (X30).
- **Non-leaf procedure:** *does* call another function → must preserve `LR` (X30), usually by saving it on the stack.

---

## Contents

- `leaf_call_demo.S`
  - Defines a leaf function `add3(a,b,c)` that returns `a+b+c`
  - `main` calls `add3` and prints the result using `printf`

- `nonleaf_call_demo.S`
  - Defines the same leaf helper `add3(a,b,c)`
  - Defines a **non-leaf** function `add3_then_double(a,b,c)` that calls `add3` and then doubles the result
  - `main` calls `add3_then_double` and prints the result using `printf`

---

## Prerequisites

### ARM64 Ubuntu (native)
- `gcc` available (default on most Ubuntu installs after build tools are installed)

### x86 Ubuntu (cross-compile + run with QEMU user-mode)
- Cross compiler: `aarch64-linux-gnu-gcc`
- QEMU user-mode: `qemu-aarch64`
- ARM64 sysroot for dynamic loader + libc (typical path): `/usr/aarch64-linux-gnu`

Install (typical on Ubuntu x86_64):
```bash
sudo apt update
sudo apt install -y gcc-aarch64-linux-gnu qemu-user libc6-arm64-cross

Build and run the leaf demo ARM64 Ubuntu (native):
```bash
gcc -no-pie -O0 -g leaf_call_demo.S -o leaf_demo
./leaf_demo

Build and run the non-leaf demo ARM64 Ubuntu (native):
```bash
gcc -no-pie -O0 -g nonleaf_call_demo.S -o nonleaf_demo
./nonleaf_demo

Build and run the leaf demo cross-compile + run under QEMU:
```bash
aarch64-linux-gnu-gcc -no-pie -O0 -g leaf_call_demo.S -o leaf_demo
qemu-aarch64 -L /usr/aarch64-linux-gnu ./leaf_demo

Build and run the non-leaf demo cross-compile + run under QEMU:
```bash
aarch64-linux-gnu-gcc -no-pie -O0 -g nonleaf_call_demo.S -o nonleaf_demo
qemu-aarch64 -L /usr/aarch64-linux-gnu ./nonleaf_demo

Expected output leaf demo:
```bash
add3(7,5,9) = 21

Expected output non-leaf demo:
```bash
2*add3(7,5,9) = 42


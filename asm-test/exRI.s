/*
Description: Test assembly program R-type and I-Type instructions of RV32IM

Generate hex using: 
    riscv64-unknown-elf-as -march=rv32im asm-test/exRI.s -o asm-test/exRI.o
    riscv64-unknown-elf-ld -m elf32lriscv -T asm-test/linker.ld asm-test/exRI.o -o asm-test/exRI.elf
    riscv64-unknown-elf-objcopy -O binary asm-test/exRI.elf asm-test/exRI.bin
    xxd -p -c4 asm-test/exRI.bin > asm-test/exRI.hex                            
*/

.section .text
.globl _start

_start:
    addi x1, x0, 5      # initialize x3 = 5
    addi x2, x0, 10     # initialize x4 = 10
    sub x3, x2, x1      # result: x3 = 5
    sub x4, x1, x2      # result: x4 = -5 
    sll x5, x2, x1      # result: x5 = 320
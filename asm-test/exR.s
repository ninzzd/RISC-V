/*
Description: Test assembly program R-type instructions of RV32IM

Generate hex using: 
    riscv64-unknown-elf-as -march=rv32im asm-test/exR.s -o asm-test/exR.o
    riscv64-unknown-elf-ld -m elf32lriscv -T asm-test/linker.ld asm-test/exR.o -o asm-test/exR.elf
    riscv64-unknown-elf-objcopy -O binary asm-test/exR.elf asm-test/exR.bin
    xxd -p -c4 asm-test/exR.bin > asm-test/exR.hex                            
*/

.section .text
.globl _start

_start:
    add x3, x1, x2      # sample (x1 = 5, x2 = 10), result: x3 = 15
    mul x4, x3, x1      # sample multiply, result: x4 = 75
    sub x6, x4, x2      # sample subtract, result: x6 = 65

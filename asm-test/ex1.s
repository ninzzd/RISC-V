/*
Generate hex using: 
    riscv64-unknown-elf-as -march=rv32im ex1.s -o ex1.o
    riscv64-unknown-elf-ld -m elf32lriscv -T linker.ld ex1.o -o ex1.elf
    riscv64-unknown-elf-objcopy -O binary ex1.elf ex1.bin
    xxd -p -c4 ex1.bin > ex1.hex                            
*/

.section .text
.globl _start

_start:
    add x3, x1, x2      # sample (x1 = 5, x2 = 10), result: x3 = 15
    mul x4, x3, x1      # sample multiply, result: x4 = 75
    sub x5, x4, x2      # sample subtract, result: x5 = 65

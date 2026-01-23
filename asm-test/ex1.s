/*
Generate hex using: 
    riscv64-unknown-elf-as -march=rv32i ex1.s -o ex1.o
    riscv64-unknown-elf-ld -m elf32lriscv -T linker.ld ex1.o -o ex1.elf
    riscv64-unknown-elf-objcopy -O binary ex1.elf ex1.bin
    xxd -e -g4 ex1.bin | awk '{print $2}' > ex1.hex                            

Optional:
    riscv64-unknown-elf-readelf -h ex1.o 
*/
.section .text
.globl _start

_start:
    add x3, x1, x2      # sample (x1 = 5, x2 = 10)

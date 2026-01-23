/*
    Simple linker script to place all .text sections at address 0x00000000
*/
SECTIONS {
  . = 0x00000000;
  .text : { *(.text*) }
}
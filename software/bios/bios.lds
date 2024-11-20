ENTRY(_start)

SECTIONS
{
   . = 0x40000000;
   .text.startup : { *(.text.startup) }
   .text : { *(.text) }
   .rodata : { *(.rodata) }
}

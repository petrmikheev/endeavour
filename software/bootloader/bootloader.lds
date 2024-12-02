ENTRY(_start)

SECTIONS
{
   . = 0x40002000;
   .text.bootsector : { *(.text.bootsector) }
   . = 0x400023fc;
   .data.bootsign : { *(.data.bootsign) }
   . = 0x40002400;
   .text.startup : { *(.text.startup) }
   .text : { *(.text) }
   .data : { *(.data) }
   . = 0x80010000;
   PROVIDE( __global_pointer$ = . + 0x800 );
   .bss : { *(.bss) }
}

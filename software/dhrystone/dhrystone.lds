ENTRY(_start)

SECTIONS
{
   . = 0x80100000;
   .text.startup : { *(.text.startup) }
   .text : { *(.text) }
   .data : { *(.data) }
   . = 0x80200000;
   PROVIDE( __global_pointer$ = . + 0x800 );
   .bss : { *(.bss) }
}

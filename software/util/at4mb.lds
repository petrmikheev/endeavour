ENTRY(_start)

SECTIONS
{
   . = 0x80400000;
   .text.startup : { *(.text.startup) }
   .text : { *(.text) }
   . = ALIGN(4);
   PROVIDE( __global_pointer$ = . + 0x800 );
   .data : { *(.data) }
   .bss : { *(.bss) }
}

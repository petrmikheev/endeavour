#ifndef BIOS_H
#define BIOS_H

// util.c
void init_text_mode();
void uart_flush();

// sdcard.c
unsigned init_sdcard();

// console.c
void uart_console();
extern const char* console_help_msg;

// main.c
int memtest();

#endif // BIOS_H

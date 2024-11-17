#ifndef TEXTWM_H
#define TEXTWM_H

#define bool char
#define false 0
#define true 1

void update_taddr(int tty_id);

extern char* display_data;
extern int text_width, text_height;

#endif // TEXTWM_H

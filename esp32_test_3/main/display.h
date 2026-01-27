#ifndef DISPLAY_H
#define DISPLAY_H

void display_init(void);
void send_one_spi_byte(void);
void display_fill_red(void);
void wake_up_display(void);  // passing void means it's an explicit function call?

#endif
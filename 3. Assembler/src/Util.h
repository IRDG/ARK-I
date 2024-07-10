

#ifndef SRC_UTIL_H_
#define SRC_UTIL_H_

#include "Global.h"

#define BOLD_STYLE      0x01
#define UNDERLINE_STYLE 0x02
#define HIGH_INTENSITY  0x03
#define BOLD_HIGH_INT   0x04
#define NO_STYLE        0x00

#define STANDARD_COLOR  0xF0
#define BLACK_COLOR     0x10
#define RED_COLOR       0x20
#define GREEN_COLOR     0x30
#define YELLOW_COLOR    0x40
#define BLUE_COLOR      0x50
#define MAGENTA_COLOR   0x60
#define CYAN_COLOR      0x70
#define WHITE_COLOR     0x80

#define Cls()      system("cls")
#define Pause()    system("pause")
#define RstColor() SetPrintColor(WHITE_COLOR,NO_STYLE);

void SetPrintColor(char Color, char Style);

#endif /* SRC_UTIL_H_ */

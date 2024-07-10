
#include "Util.h"

void SetPrintColor(char Color, char Style)
{
	if(Color == STANDARD_COLOR)
	{
		printf("\e[0m");
		return;
	}
	unsigned char Select = Color + Style;
	switch (Select)
	{
		// Regular colored text
		case 0x10:
		{
			printf("\e[0;30m");
			return;
		}
		case 0x20:
		{
			printf("\e[0;31m");
			return;
		}
		case 0x30:
		{
			printf("\e[0;32m");
			return;
		}
		case 0x40:
		{
			printf("\e[0;33m");
			return;
		}
		case 0x50:
		{
			printf("\e[0;34m");
			return;
		}
		case 0x60:
		{
			printf("\e[0;35m");
			return;
		}
		case 0x70:
		{
			printf("\e[0;36m");
			return;
		}
		case 0x80:
		{
			printf("\e[0;37m");
			return;
		}
		// Bold colored text
		case 0x11:
		{
			printf("\e[1;30m");
			return;
		}
		case 0x21:
		{
			printf("\e[1;31m");
			return;
		}
		case 0x31:
		{
			printf("\e[1;32m");
			return;
		}
		case 0x41:
		{
			printf("\e[1;33m");
			return;
		}
		case 0x51:
		{
			printf("\e[1;34m");
			return;
		}
		case 0x61:
		{
			printf("\e[1;35m");
			return;
		}
		case 0x71:
		{
			printf("\e[1;36m");
			return;
		}
		case 0x81:
		{
			printf("\e[1;37m");
			return;
		}
		//Underlined Colored Text
		case 0x12:
		{
			printf("\e[4;30m");
			return;
		}
		case 0x22:
		{
			printf("\e[4;31m");
			return;
		}
		case 0x32:
		{
			printf("\e[4;32m");
			return;
		}
		case 0x42:
		{
			printf("\e[4;33m");
			return;
		}
		case 0x52:
		{
			printf("\e[4;34m");
			return;
		}
		case 0x62:
		{
			printf("\e[4;35m");
			return;
		}
		case 0x72:
		{
			printf("\e[4;36m");
			return;
		}
		case 0x82:
		{
			printf("\e[4;37m");
			return;
		}
		// High Intensity Colored Text
		case 0x13:
		{
			printf("\e[0;90m");
			return;
		}
		case 0x23:
		{
			printf("\e[0;91m");
			return;
		}
		case 0x33:
		{
			printf("\e[0;92m");
			return;
		}
		case 0x43:
		{
			printf("\e[0;93m");
			return;
		}
		case 0x53:
		{
			printf("\e[0;94m");
			return;
		}
		case 0x63:
		{
			printf("\e[0;95m");
			return;
		}
		case 0x73:
		{
			printf("\e[0;96m");
			return;
		}
		case 0x83:
		{
			printf("\e[0;97m");
			return;
		}
		// Bold High Intensity Colored Text
		case 0x14:
		{
			printf("\e[1;90m");
			return;
		}
		case 0x24:
		{
			printf("\e[1;91m");
			return;
		}
		case 0x34:
		{
			printf("\e[1;92m");
			return;
		}
		case 0x44:
		{
			printf("\e[1;93m");
			return;
		}
		case 0x54:
		{
			printf("\e[1;94m");
			return;
		}
		case 0x64:
		{
			printf("\e[1;95m");
			return;
		}
		case 0x74:
		{
			printf("\e[1;96m");
			return;
		}
		case 0x84:
		{
			printf("\e[1;97m");
			return;
		}
	}
}


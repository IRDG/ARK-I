/******************************************************************************
**
** Name        : ArkIAssembler.c
** Author      : Ivan Diaz Gamarra
**
******************************************************************************/

#include "Util.h"

#include "CodeProcessing.h"
#include "BinaryAssembly.h"

void Config(char *SliceSize, uint *MemorySize);

int main()
{
	Cls();
	Verbose              = 0xFF;
	char     SliceSize   =   16;
	uint     MemorySize  = 4096;
	char     Loop        =    1;
	uint     Selector    =    1;
	uint     MaxAddress  =    0;
	char     Compilation =    0;
	char     Assembly    =    0;
	char     Export      =    0;

	CounterT Counter                           ;
	GetCodeLines(&Counter);
	InstructionT Instructions[Counter.Code    ];
	AddressT     Address     [Counter.Address ];
	BinaryInstT  BinaryInst  [Counter.Code    ];

	while(Loop)
	{
		SetPrintColor(CYAN_COLOR, NO_STYLE);
		printf("Assembler program for the ARK I Processor \n\n");
		RstColor();
		printf("Select One of the following options: \n\n");
		printf("                                    Status\n");
		printf("1. Begin compilation     ");
		if(Compilation == 0)
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("<< Compilation unsuccessful >>");
		}
		else
		{
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			printf("<< Compilation   successful >>");
		}
		RstColor();
		printf("\n");
		printf("2. Begin Assembly        ");
		if(Assembly == 0)
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("<<   Assembly   Not  Done   >>");
		}
		else
		{
			switch (Compilation)
			{
				case 0:
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("<<  Compilation  Not  Done  >>");
					break;
				}
				case 1:
				{
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					printf("<<   Assembly    Outdated   >>");
					break;
				}
				case 2:
				{
					SetPrintColor(GREEN_COLOR, NO_STYLE);
					printf("<<   Assembly    Complete   >>");
					break;
				}
				default:
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("<< ********* ERROR ******** >>");
				}
			}
		}
		RstColor();
		printf("\n");
		printf("3. Export Results        ");
		if((Assembly == 1) && (Compilation == 2))
		{
			if(Export == 0)
			{
				SetPrintColor(GREEN_COLOR, NO_STYLE);
				printf("<<          Ready           >>");
			}
			else
			{
				SetPrintColor(GREEN_COLOR, NO_STYLE);
				printf("<<     Export  Complete     >>");
			}
		}
		else
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("<<         Not Ready        >>");
		}
		RstColor();
		printf("\n");
		printf("4. Do all of the above \n");
		printf("5. Configuration\n");
		printf("6. Exit \n");
		printf("\n\n");
		scanf(" %u",&Selector);
		Cls();

		switch (Selector)
		{
			case 1:
			{
				Compilation = GetCode(&Counter,Instructions,SliceSize,Address,&MaxAddress);
				Export      = 0;
				break;
			}
			case 2:
			{
				if((Compilation == 1) || (Compilation == 2))
				{
					Assembly = AssembleCode(&Counter,Instructions,SliceSize,Address,MaxAddress,BinaryInst);
					Compilation = 2;
					Export      = 0;
				}
				else
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("Please Complete a successful compilation before assembling . . .\n\n");
					RstColor();
					Pause();
					Cls();
				}
				break;
			}
			case 3:
			{
				if((Compilation == 2) && (Assembly == 1))
				{
					Export = ExportCode(&Counter,BinaryInst,MemorySize);
					Pause();
					Cls();
				}
				else
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("Please Complete a successful Assembly before Exporting results . . .\n\n");
					RstColor();
					Pause();
					Cls();
				}
				break;
			}
			case 4:
			{
				GetCodeLines(&Counter);
				InstructionT Instructions[Counter.Code    ];
				AddressT     Address     [Counter.Address ];
				Compilation = GetCode(&Counter,Instructions,SliceSize,Address,&MaxAddress);
				if((Compilation == 1) || (Compilation == 2))
				{
					Assembly = AssembleCode(&Counter,Instructions,SliceSize,Address,MaxAddress,BinaryInst);
					Compilation = 2;
					Export      = 0;
					if((Compilation == 2) && (Assembly == 1))
					{
						Export = ExportCode(&Counter,BinaryInst,MemorySize);
					}
					else
					{
						SetPrintColor(RED_COLOR, NO_STYLE);
						printf("Please Complete a successful Assembly before Exporting results . . .\n\n");
						RstColor();
					}
				}
				else
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("Please Complete a successful compilation before assembling . . .\n\n");
					RstColor();
				}
				Pause();
				Cls();
				break;
			}
			case 5:
			{
				Config(&SliceSize,&MemorySize);
				Cls();
				break;
			}
			case 6:
			{
				Loop = 0;
				break;
			}
			default:
			{
			}
		}
	}
	return 0;
}

void Config(char *SliceSize, uint *MemorySize)
{
	uint Selection;
	char Loop = 1;
	uint Temp;
	while(Loop)
	{
		SetPrintColor(YELLOW_COLOR, NO_STYLE);
		printf("*------------------------------------------------------------------------*\n");
		printf("|                                                                        |\n");
		printf("|                      Current system configuration                      |\n");
		printf("*------------------------------------------------------------------------*\n");
		printf("|                                                                        |\n");
		printf("| 1. Edit Slice size             [Current Size  =     ");
		SetPrintColor(CYAN_COLOR, NO_STYLE);
		PrintLineNumber(*SliceSize,255);
		printf(" words / Slice");
		SetPrintColor(YELLOW_COLOR, NO_STYLE);
		printf("] | \n");
		printf("| 2. Toggle Counter Comments     [Current State :              ");
		if(Verbose & ShowCounterValues)
		{
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			printf(" Enabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		else
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("Disabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		printf("] | \n");
		printf("| 3. Toggle Instruction Comments [Current State :              ");
		if(Verbose & ShowInstructions)
		{
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			printf(" Enabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		else
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("Disabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		printf("] | \n");
		printf("| 4. Toggle Address Comments     [Current State :              ");
		if(Verbose & ShowAddress)
		{
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			printf(" Enabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		else
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("Disabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		printf("] | \n");
		printf("| 5. Toggle Assembly comments    [Current State :              ");
		if(Verbose & ShowAssembly)
		{
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			printf(" Enabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		else
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("Disabled");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
		}
		printf("] | \n");
		printf("| 6. Max words in memory         [Current Size  = ");
		SetPrintColor(CYAN_COLOR, NO_STYLE);
		PrintLineNumber(*MemorySize,65536);
		printf(" Words in Memory");
		SetPrintColor(YELLOW_COLOR, NO_STYLE);
		printf("] |\n");
		printf("|                                                                        |\n");
		printf("*------------------------------------------------------------------------*\n");
		printf("|                                                                        |\n");
		printf("|           Select any other option to return to the main menu           |\n");
		printf("|                                                                        |\n");
		printf("*------------------------------------------------------------------------*\n");
		printf("\n\n");
		printf("Please type the option to edit/toggle it: ");
		RstColor();
		scanf(" %u",&Selection);
		SetPrintColor(YELLOW_COLOR, NO_STYLE);
		Cls();
		printf("\n\n");
		switch (Selection)
		{
			case 1:
			{
				printf("Please type the new Slice size (Words / Slice): ");
				scanf(" %u",&Temp);
				if(Temp < 256)
				{
					*SliceSize = Temp;
				}
				else
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("\n\n Error: Slice size must not be over 255 \n\n");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					Pause();
				}
				break;
			}
			case 2:
			{
				Verbose ^= ShowCounterValues;
				break;
			}
			case 3:
			{
				Verbose ^= ShowInstructions;
				break;
			}
			case 4:
			{
				Verbose ^= ShowAddress;
				break;
			}
			case 5:
			{
				Verbose ^= ShowAssembly;
				break;
			}
			case 6:
			{
				printf("Please type the new amount of words in memory : \n");
				printf("(This information will be used to create the mif file)\n");
				scanf(" %u",&Temp);
				if(Temp <= 65536)
				{
					*MemorySize = Temp;
				}
				else
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("\n\n Error: Memory size must not be over 65536 \n\n");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					Pause();
				}
				break;
			}
			default:
			{
				Loop = 0;
			}
		}
		Cls();
	}
}

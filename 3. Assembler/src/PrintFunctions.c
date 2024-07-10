
#include "PrintFunctions.h"

void PrintInstructions(CounterT *Counter, InstructionT Instructions[Counter->Code])
{
	uint  i,j;
	uchar NoL;
	uint  MaxL = 1;
	if(Verbose & ShowInstructions)
	{
		NoL  = GetNumOfDigits(Counter->Lines);
		for (i = 0; i < NoL; i++)
		{
			MaxL = MaxL*10;
		}
		RstColor();
		printf("\n");
		printf(" *-");
		if(NoL < 3)
		{
			printf("---");
		}
		else
		{
			for(i = 0; i <= NoL; i++)
			{
				printf("-");
			}
		}
		printf("-*-------------*-----------------*------------*------------*");
		printf("------------*---------*---------*---------*-----* \n");
		printf(" | ");
		if(NoL < 3)
		{
			printf("Num");
		}
		else
		{
			for(i = NoL; i >= 2; i--)
			{
				if(i == 3)
				{
					printf("Num");
				}
				else
				{
					printf(" ");
				}
			}
		}
		printf(" | Instruction | Immediate  Data |     Rd     |    Rs 1    |");
		printf("    Rs 2    | Funct 7 | Funct 3 | Op Code | Seg | \n");
		printf(" | ");
		if(NoL < 3)
		{
			printf("   ");
		}
		else
		{
			for(i = 0; i <= NoL; i++)
			{
				printf(" ");
			}
		}
		printf(" |     Name    | Class -  Value  | 0d -   0b  | 0d -   0b  |");
		printf(" 0d -   0b  |         |         |         |     | \n");
		printf(" *-");
		if(NoL < 3)
		{
			printf("---");
		}
		else
		{
			for(i = 0; i <= NoL; i++)
			{
				printf("-");
			}
		}
		printf("-*-------------*-----------------*------------*------------*");
		printf("------------*---------*---------*---------*-----* \n");
		for(i = 0; i < Counter->Code; i++)
		{
			printf(" | ");
			PrintLineNumber(i+1, MaxL);
			printf(" |    ");
			SetPrintColor(GREEN_COLOR, NO_STYLE);
			PrintInstructionName(Counter, Instructions, i);
			RstColor();
			printf("   | ");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
			switch(Instructions[i].Imm.Class)
			{
				case ClassImmI:
				{
					printf("  I  ");
					break;
				}
				case ClassImmU:
				{
					printf("  U  ");
					break;
				}
				case ClassImmS:
				{
					printf("  S  ");
					break;
				}
				case ClassImmR:
				{
					printf("  R  ");
					break;
				}
				case ClassImmNone:
				{
					printf("NoImm");
					break;
				}
				case ClassReturn:
				{
					printf(" Ret ");
					break;
				}
				default:
				{
					SetPrintColor(RED_COLOR, BOLD_HIGH_INT);
					printf("ERROR");
				}
			}
			RstColor();
			printf(" - ");
			SetPrintColor(YELLOW_COLOR, NO_STYLE);
			if((Instructions[i].Imm.Class == ClassImmI) || (Instructions[i].Imm.Class == ClassImmS))
			{
				printf("%07u",Instructions[i].Imm.Value);
			}
			else
			{
				printf("  ---  ");
			}
			RstColor();
			printf(" | ");
			SetPrintColor(CYAN_COLOR, NO_STYLE);
			if((Instructions[i].Rd.Val >= 0) && (Instructions[i].Rd.Val <= 31))
			{
				printf("%02u",Instructions[i].Rd.Val);
			}
			else
			{
				printf("--");
			}
			printf(" - ");
			if((Instructions[i].Rd.Val >= 0) && (Instructions[i].Rd.Val <= 31))
			{
				for(j = 0; j < 5; j++)
				{
					printf("%c",Instructions[i].Rd.Bin[4-j]);
				}
			}
			else
			{
				printf(" --- ");
			}
			RstColor();
			printf(" |");
			SetPrintColor(BLUE_COLOR, NO_STYLE);
			if((Instructions[i].Rs1.Val >= 0) && (Instructions[i].Rs1.Val <= 31))
			{
				printf(" %02u ",Instructions[i].Rs1.Val);
			}
			else
			{
				printf(" -- ");
			}
			printf("- ");
			if((Instructions[i].Rs1.Val >= 0) && (Instructions[i].Rs1.Val <= 32))
			{
				for(j = 0; j < 5; j++)
				{
					printf("%c",Instructions[i].Rs1.Bin[4-j]);
				}
			}
			else
			{
				printf(" --- ");
			}
			RstColor();
			printf(" |");
			SetPrintColor(BLUE_COLOR, NO_STYLE);
			if((Instructions[i].Rs2.Val >= 0) && (Instructions[i].Rs2.Val <= 32))
			{
				printf(" %02u ",Instructions[i].Rs2.Val);
			}
			else
			{
				printf(" -- ");
			}
			printf("- ");
			if((Instructions[i].Rs2.Val >= 0) && (Instructions[i].Rs2.Val <= 32))
			{
				for(j = 0; j < 5; j++)
				{
					printf("%c",Instructions[i].Rs2.Bin[4-j]);
				}
			}
			else
			{
				printf(" --- ");
			}
			RstColor();
			printf(" | ");
			SetPrintColor(MAGENTA_COLOR, NO_STYLE);
			for(j = 0; j < 7; j++)
			{
				printf("%c",Instructions[i].OpCode.Funct7[6-j]);
			}
			RstColor();
			printf(" |   ");
			SetPrintColor(MAGENTA_COLOR, NO_STYLE);
			for(j = 0; j < 3; j++)
			{
				printf("%c",Instructions[i].OpCode.Funct3[2-j]);
			}
			RstColor();
			printf("   | ");
			SetPrintColor(MAGENTA_COLOR, NO_STYLE);
			for(j = 0; j < 7; j++)
			{
				printf("%c",Instructions[i].OpCode.OpCode[6-j]);
			}
			RstColor();
			printf(" | ");
			SetPrintColor(BLACK_COLOR, BOLD_STYLE);
			printf("%03u",Instructions[i].Segment);
			RstColor();
			printf(" |\n");
		}
		printf(" *-");
		if(NoL < 3)
		{
			printf("---");
		}
		else
		{
			for(i = 0; i <= NoL; i++)
			{
				printf("-");
			}
		}
		printf("-*-------------*-----------------*------------*------------*");
		printf("------------*---------*---------*---------*-----* \n");
		printf("\n\n");
		Pause();
		Cls();
	}
}

void PrintInstructionName(CounterT *Counter, InstructionT Instructions[Counter->Code], int Pos)
{
	switch(Instructions[Pos].Instruction)
	{
		case Lui:
		{
			printf("Lui   ");
			break;
		}
		case AuiPc:
		{
			printf("AuiPc ");
			break;
		}
		case AddI:
		{
			printf("AddI  ");
			break;
		}
		case SltI:
		{
			printf("SltI  ");
			break;
		}
		case SltIu:
		{
			printf("SltIu ");
			break;
		}
		case XorI:
		{
			printf("XorI  ");
			break;
		}
		case OrI:
		{
			printf("OrI   ");
			break;
		}
		case AndI:
		{
			printf("AndI  ");
			break;
		}
		case SllI:
		{
			printf("SllI  ");
			break;
		}
		case SrlI:
		{
			printf("SrlI  ");
			break;
		}
		case SraI:
		{
			printf("SraI  ");
			break;
		}
		case Add:
		{
			printf("Add   ");
			break;
		}
		case Sub:
		{
			printf("Sub   ");
			break;
		}
		case Sll:
		{
			printf("Sll   ");
			break;
		}
		case Slt:
		{
			printf("Slt   ");
			break;
		}
		case Sltu:
		{
			printf("Sltu  ");
			break;
		}
		case Xor:
		{
			printf("Xor   ");
			break;
		}
		case Srl:
		{
			printf("Srl   ");
			break;
		}
		case Sra:
		{
			printf("Sra   ");
			break;
		}
		case Or:
		{
			printf("Or    ");
			break;
		}
		case And:
		{
			printf("And   ");
			break;
		}
		case Csrrw:
		{
			printf("Csrrw ");
			break;
		}
		case Csrrs:
		{
			printf("Csrrs ");
			break;
		}
		case Csrrc:
		{
			printf("Csrrc ");
			break;
		}
		case CsrrwI:
		{
			printf("CsrrwI");
			break;
		}
		case CsrrsI:
		{
			printf("CsrrsI");
			break;
		}
		case CsrrcI:
		{
			printf("CsrrcI");
			break;
		}
		case Uret:
		{
			printf("Uret  ");
			break;
		}
		case Sret:
		{
			printf("Sret  ");
			break;
		}
		case Mret:
		{
			printf("Mret  ");
			break;
		}
		case Lb:
		{
			printf("Lb    ");
			break;
		}
		case Lh:
		{
			printf("Lh    ");
			break;
		}
		case Lw:
		{
			printf("Lw    ");
			break;
		}
		case Lbu:
		{
			printf("Lbu   ");
			break;
		}
		case Lhu:
		{
			printf("Lhu   ");
			break;
		}
		case Sb:
		{
			printf("Sb    ");
			break;
		}
		case Sh:
		{
			printf("Sh    ");
			break;
		}
		case Sw:
		{
			printf("Sw    ");
			break;
		}
		case Jal:
		{
			printf("Jal   ");
			break;
		}
		case Jalr:
		{
			printf("Jalr  ");
			break;
		}
		case Beq:
		{
			printf("Beq   ");
			break;
		}
		case Bne:
		{
			printf("Bne   ");
			break;
		}
		case Blt:
		{
			printf("Blt   ");
			break;
		}
		case Bge:
		{
			printf("Bge   ");
			break;
		}
		case Bltu:
		{
			printf("Bltu  ");
			break;
		}
		case Bgeu:
		{
			printf("Bgeu  ");
			break;
		}
		case Mul:
		{
			printf("Mul   ");
			break;
		}
		case Mulh:
		{
			printf("Mulh  ");
			break;
		}
		case Mulhsu:
		{
			printf("Mulhsu");
			break;
		}
		case Mulhu:
		{
			printf("Mulhu ");
			break;
		}
		case Div:
		{
			printf("Div   ");
			break;
		}
		case Divu:
		{
			printf("Divu  ");
			break;
		}
		case Rem:
		{
			printf("Rem   ");
			break;
		}
		case Remu:
		{
			printf("Remu  ");
			break;
		}
		case NoOp:
		{
			printf("NoOp  ");
			break;
		}
		case None:
		{
			printf("None  ");
			break;
		}
		default:
		{
			printf("ERROR ");
		}
	}
	RstColor();
}


void PrintAddresses(CounterT *Counter, AddressT Address[Counter->Address])
{
	uint i;
	int  j;
	RstColor();
	if(Verbose & ShowAddress)
	{
		printf(" *--------------------------------*--------------*--------------*\n");
		printf(" | Address Name  ( 30 Characters) | AddressValue |  Number  of  |\n");
		printf(" |                                |              | instructions |\n");
		printf(" *--------------------------------*--------------*--------------*\n");
		for (i = 0; i < Counter->Address; ++i)
		{
			printf(" | ");
			for(j = 0; j < 30; j++)
			{
				printf("%c",Address[i].Name[j]);
			}
			printf(" |  ");
			printf("%010u",Address[i].Value);
			printf("  |  ");
			printf("%010u",Address[i].NoInst);
			printf("  |\n");
		}
		printf(" *--------------------------------*--------------*--------------*\n");
		printf("\n\n");
		Pause();
		Cls();
	}
}

uchar GetNumOfDigits(uint Number)
{
	uint  TempNum = Number;
	uchar Answ    = 0;
	while (TempNum > 0)
	{
		TempNum = TempNum / 10;
		Answ++;
	}
	return Answ;
}

void PrintLineNumber(uint Line, uint MaxLines)
{
	uchar MaxChar = GetNumOfDigits(MaxLines);
	uchar ActChar = GetNumOfDigits(    Line);
	int i;
	for(i = 0; i < (MaxChar - ActChar);i++)
	{
		printf(" ");
	}
	printf("%u",Line);
}

void PrintLineNumberOnCode(uint Line, uint MaxLines)
{
	SetPrintColor(YELLOW_COLOR, NO_STYLE);
	printf(" ");
	PrintLineNumber(Line, MaxLines);
	RstColor();
	printf(" | ");
}

void PrintAssembly(CounterT *Counter, BinaryInstT  BinaryInst  [Counter->Code],
                                      InstructionT Instructions[Counter->Code])
{
	uint i;
	uint j;
	if(Verbose & ShowAssembly)
	{
		printf(" *------------------------*-----*--------------------------------------*------------*\n");
		printf(" |       Instruction      |     |                Binary                |   Address  |\n");
		printf(" *------------------------*-----*--------------------------------------*------------*\n");
		for(i = 0; i < Counter->Code; i++)
		{
			printf(" | ");
			SetPrintColor(MAGENTA_COLOR, NO_STYLE);
			PrintInstructionName(Counter,Instructions,i);
			printf(" ");
			switch (Instructions[i].Imm.Class)
			{
				case ClassImmI:
				{
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rd .Val  );
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rs1.Val  );
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					printf( "%07u ",Instructions[i].Imm.Value);
					RstColor();
					printf("|  I  | ");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					for(j = 31; j > 19; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf("  ");
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					for(j = 19; j > 14; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j = 14; j > 11; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					for(j = 11; j >  6; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j =  6; j >  0; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					RstColor();
					break;
				}
				case ClassImmR:
				{
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rd .Val  );
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rs1.Val  );
					if((Instructions[i].Instruction == SllI) ||
					   (Instructions[i].Instruction == SrlI) ||
					   (Instructions[i].Instruction == SraI))
					{
						printf(" %02u ",Instructions[i].Rs2.Val  );
					}
					else
					{
						printf("R%02u ",Instructions[i].Rs2.Val  );
					}
					printf("    "                            );
					RstColor();
					printf("|  R  | ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j = 31; j > 24; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					for(j = 24; j > 19; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					for(j = 19; j > 14; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j = 14; j > 11; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					for(j = 11; j >  6; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j =  6; j >  0; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					RstColor();
					break;
				}
				case ClassImmS:
				{
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rs1 .Val  );
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rs2.Val  );
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					printf( "%07u ",Instructions[i].Imm.Value);
					RstColor();
					printf("|  S  | ");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					for(j = 31; j > 24; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					for(j = 24; j > 19; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(BLUE_COLOR, NO_STYLE);
					for(j = 19; j > 14; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j = 14; j > 11; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					for(j = 11; j >  6; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j =  6; j >  0; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					RstColor();
					break;
				}
				case ClassImmU:
				{
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					printf("R%02u ",Instructions[i].Rd .Val  );
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					printf("    ");
					printf( "%07u ",Instructions[i].Imm.Value);
					RstColor();
					printf("|  U  | ");
					SetPrintColor(YELLOW_COLOR, NO_STYLE);
					for(j = 31; j > 11; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf("    ");
					SetPrintColor(CYAN_COLOR, NO_STYLE);
					for(j = 11; j >  6; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j =  6; j >  0; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					RstColor();
					break;
				}
				case ClassReturn:
				{
					printf("        ");
					printf("        ");
					RstColor();
					printf("| Ret | ");
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					for(j = 31; j > 24; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					for(j = 24; j > 19; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					for(j = 19; j > 14; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					for(j = 14; j > 11; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					for(j = 11; j >  6; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					printf(" ");
					for(j =  6; j >  0; j--)
					{
						printf("%c",BinaryInst[i].Instruction[j]);
					}
					RstColor();
					break;
				}
				default:
				{
				}
			}
			printf(" | ");
			SetPrintColor(BLACK_COLOR, BOLD_HIGH_INT);
			printf("%010u",BinaryInst[i].Address);
			RstColor();
			printf(" | \n");
		}
		printf(" *------------------------*-----*--------------------------------------*------------*\n\n");
	}
}


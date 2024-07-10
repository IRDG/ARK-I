
#include "CodeProcessing.h"

char IsLetter(char Character)
{
	if(('A' <= Character) && (Character <= 'Z'))
	{
		return 1;
	}
	if(('a' <= Character) && (Character <= 'z'))
	{
		return 1;
	}
	return 0;
}

void GetCodeLines(CounterT *Counter)
{
	char Character;
	char Ignore = 0;
	Counter->Address  = 0;
	Counter->Code     = 0;
	Counter->Lines    = 1;

	OpenAsmCodeFile();
	Character = fgetc(AsmCodeFile);
	SetPrintColor(WHITE_COLOR, NO_STYLE);
	while(Character != EOF)
	{
		/***********************************************************************
		**
		** -> if char is letter, increase code line counter
		** -> if is # increase constant counter
		** -> if is $ increase address counter
		** -> if any counter is increased then the rest of characters are
		**    ignored until the next EOL
		** -> if is space or tab ignore that char
		**
		***********************************************************************/
		if(IsNextLine(Character))
		{
			Counter->Lines ++;
		}
		if(Ignore == 0)
		{
			if(IsComment(Character))
			{
				Ignore = 1;
			}
			if(IsLetter (Character))
			{
				Ignore = 1;
				Counter->Code ++;
			}
			if(IsAddress(Character))
			{
				Ignore = 1;
				Counter->Address ++;
			}
		}
		if(IsNextLine(Character))
		{
			Ignore = 0;
		}
		Character = fgetc(AsmCodeFile);
	}
	CloseAsmCodeFile();
}

char GetCode(CounterT *Counter   , InstructionT Instructions[Counter->Code    ],
             char      SliceSize , AddressT     Address     [Counter->Address ],
             uint     *MaxAddress)
{

	if(Verbose & ShowCounterValues)
	{
		SetPrintColor(YELLOW_COLOR, BOLD_STYLE);
		printf("\n");
		printf("Number of code lines detected = %u \n",Counter->Code    );
		printf("Number of Addresses  detected = %u \n",Counter->Address );
		printf("\n");
		RstColor();
	}
	char Error      = 0;
	EmptyInstructionArray(Counter,Instructions,Address);
	Error = GetData      (Counter,Instructions,Address);
	printf("\n\n");
	if(Error)
	{
		SetPrintColor(CYAN_COLOR, NO_STYLE);
		Pause();
		RstColor();
		Cls();
		*MaxAddress = 0;
		return 0;
	}
	else
	{
		SetPrintColor(CYAN_COLOR, NO_STYLE);
		Pause();
		RstColor();
		Cls();
		*MaxAddress = CreateAddressValues (Counter,Address,SliceSize);
		AssignOpCodes                     (Counter,Instructions     );
		BinaryConversion                  (Counter,Instructions     );
		PrintInstructions                 (Counter,Instructions     );
		PrintAddresses                    (Counter,Address          );
		return 1;
	}
	RstColor();
	Pause();
	RstColor();
	Cls();
}

void EmptyInstructionArray(CounterT *Counter, InstructionT Instructions[Counter->Code    ],
                                              AddressT     Address     [Counter->Address ])
{
	int i,j;
	for(i = 0; i < Counter->Code; i++)
	{
		Instructions[i].Segment       =            0;
		Instructions[i].Instruction   =         None;
		Instructions[i].Imm.Class     = ClassImmNone;
		Instructions[i].Imm.Value     =            0;
		Instructions[i].Imm.ConstId   =            0;
		Instructions[i].Rd .Val       =           99;
		Instructions[i].Rs1.Val       =           99;
		Instructions[i].Rs2.Val       =           99;
		for(j = 0; j < 20; j++)
		{
			Instructions[i].Imm.Bin.U[j] = '0';
		}
		for(j = 0; j < 12; j++)
		{
			Instructions[i].Imm.Bin.I[j] = '0';
		}
		for(j = 0; j < 7; j++)
		{
			Instructions[i].OpCode.OpCode[j] = '0';
			Instructions[i].OpCode.Funct7[j] = '0';
			Instructions[i].Imm.Bin.Sh   [j] = '0';
		}
		for(j = 0; j < 3; j++)
		{
			Instructions[i].OpCode.Funct3[j] = '0';
		}
		for(j = 0; j < 5; j++)
		{
			Instructions[i].Rd .Bin   [j] = '0';
			Instructions[i].Rs1.Bin   [j] = '0';
			Instructions[i].Rs2.Bin   [j] = '0';
			Instructions[i].Imm.Bin.Sl[j] = '0';
		}
		for(j = 0; j < 2; j++)
		{
			Instructions[i].Rd .Dec[j] = '0';
			Instructions[i].Rd .Hex[j] = '0';
			Instructions[i].Rs1.Dec[j] = '0';
			Instructions[i].Rs1.Hex[j] = '0';
			Instructions[i].Rs2.Dec[j] = '0';
			Instructions[i].Rs2.Hex[j] = '0';
		}
	}
	for(i = 0; i < Counter->Address; i++)
	{
		for(j = 0; j < 50; j++)
		{
			Address[i].Name[j] = ' ';
		}
		Address[i].NoInst = 0;
		Address[i].Value  = 0;
	}
}

char GetData(CounterT *Counter, InstructionT Instructions[Counter->Code    ],
                                AddressT     Address     [Counter->Address ])
{
	uint j                              ;
	char PrevChar               =      0;
	char NextChar               =   0x0A;
	char TempChar               =   0x0A;
	uint Line                   =      1;
	int  AddressIndex           =      0;
	uint InstrIndex             =      0;
	RdSt State                  = IdleSt;
	char SaveError              =      1;
	uint Errors[Counter->Lines]         ;
	uint ErrorIndex                     ;
	char FatalError             =      0;
	char PreventRead            =      0;
	char FirstIndex             =      1;

	for(ErrorIndex = 0; ErrorIndex < Counter->Lines; ErrorIndex ++)
	{
		Errors[ErrorIndex] = 0;
	}
	ErrorIndex = 0;

	OpenAsmCodeFile();
	AddressT TempAddress;
	uchar    ActSegment ;

	PrintLineNumberOnCode(Line,Counter->Lines);
	while(NextChar != EOF)
	{
		if(ErrorIndex >= Counter->Lines)
		{
			SetPrintColor(RED_COLOR, HIGH_INTENSITY);
			printf("**********************************\n");
			printf("***** ERROR COUNTER OVERFLOW *****\n");
			printf("**********************************\n");
			RstColor();
			ErrorIndex = 0;
			FatalError ++ ;
		}
		if(PreventRead == 0)
		{
			NextChar = PrevChar;
			PrevChar = fgetc(AsmCodeFile);
		}
		else
		{
			if((PreventRead == -1) && (NextChar == 0x0A))
			{
				TempChar = PrevChar;
				PrevChar = NextChar;
				NextChar = 0x00;
			}
			else
			{
				if(PreventRead == -2)
				{
					PreventRead = 0;
					NextChar = PrevChar;
					PrevChar = TempChar;
					TempChar = 0x0A;
				}
				else
				{
					if(State != ErrorSt)
					{
						PreventRead = 0;
					}
				}
			}
		}
		switch (State)
		{
			case IdleSt:
			{
				if((('A' <= PrevChar) && (PrevChar <= 'D')) || (('a' <= PrevChar) && (PrevChar <= 'd')))
				{
					State = InstructionSt;
				}
				if((PrevChar == 'J') || (PrevChar == 'j'))
				{
					State = InstructionSt;
				}
				if((('L' <= PrevChar) && (PrevChar <= 'O')) || (('l' <= PrevChar) && (PrevChar <= 'o')))
				{
					State = InstructionSt;
				}
				if((('R' <= PrevChar) && (PrevChar <= 'S')) || (('r' <= PrevChar) && (PrevChar <= 's')))
				{
					State = InstructionSt;
				}
				if((PrevChar == 'U') || (PrevChar == 'u'))
				{
					State = InstructionSt;
				}
				if((PrevChar == 'X') || (PrevChar == 'x'))
				{
					State = InstructionSt;
				}
				if(IsAddress(PrevChar))
				{
					SetPrintColor(MAGENTA_COLOR, NO_STYLE);
					printf("%c",PrevChar);
					RstColor();
					State = AddressSt;
				}
				if(PrevChar == '@')
				{
					State = CommentSt;
				}
				// ADD value input with $
				if((PrevChar == ' ') || (PrevChar == '	') || (IsNextLine(PrevChar)))
				{
					State = IdleSt;
					if(PrevChar == ' ')
					{
						printf(" ");
					}
					if(IsNextLine(PrevChar))
					{
						Line ++;
						printf("\n");
						PrintLineNumberOnCode(Line,Counter->Lines);
					}
				}
				else
				{
					if(State == IdleSt)
					{
						SetPrintColor(RED_COLOR, NO_STYLE);
						printf("-> Invalid character [%c | 0d%u] ",PrevChar,PrevChar);
						RstColor();
						State = ErrorSt;
					}
				}
				if(PreventRead == -1)
				{
					PreventRead = -2;
				}
				break;
			}
			case InstructionSt:
			{
				SetPrintColor(CYAN_COLOR, NO_STYLE);
				printf("%c",NextChar);
				RstColor();
				State = GetInstruction(Counter,Instructions, PrevChar, NextChar,InstrIndex, &Line);
				if((State == IdleSt) || (State == Argument1St) || (State == NoArgumentSt))
				{
					Instructions[InstrIndex].Segment = ActSegment;
					InstrIndex ++;
					if(State == IdleSt)
					{
						Address[AddressIndex].NoInst += 1;
					}
				}
				break;
			}
			case NoArgumentSt:
			{
				SetPrintColor(BLACK_COLOR, HIGH_INTENSITY);
				printf("%c",NextChar);
				RstColor();
				if((IsComment(NextChar)) || (IsComment(PrevChar)))
				{
					Address[AddressIndex].NoInst += 1;
					State = CommentSt;
				}
				else
				{
					if((IsNextLine(NextChar)) || (IsNextLine(PrevChar)))
					{
						Address[AddressIndex].NoInst += 1;
						State = IdleSt;
						Line ++;
						printf("\n");
						PrintLineNumberOnCode(Line,Counter->Lines);
					}
					else
					{
						if(!((IsSpace(NextChar)) || (NextChar != '@')))
						{
							SetPrintColor(RED_COLOR, HIGH_INTENSITY);
							printf("-> Error: No argument needed {%c,%u}",NextChar,NextChar);
							RstColor();
							State = ErrorSt;
						}
					}
				}
				break;
			}
			case Argument1St:
			{
				SetPrintColor(WHITE_COLOR, BOLD_HIGH_INT);
				printf("%c",NextChar);
				RstColor();
				State = GetArgument1(Counter, Instructions, PrevChar, NextChar, InstrIndex-1, &PreventRead);
				break;
			}
			case Argument2St:
			{
				SetPrintColor(WHITE_COLOR, BOLD_HIGH_INT);
				printf("%c",NextChar);
				RstColor();
				State = GetArgument2(Counter, Instructions, PrevChar, NextChar, InstrIndex-1, &PreventRead);
				if((State == IdleSt) || (State == CommentSt))
				{
					if(PrevChar == ' ')
					{
						printf(" ");
					}
					Address[AddressIndex].NoInst += 1;
				}
				break;
			}
			case Argument3St:
			{
				SetPrintColor(WHITE_COLOR, BOLD_HIGH_INT);
				printf("%c",NextChar);
				RstColor();
				State = GetArgument3(Counter, Instructions, PrevChar, NextChar, InstrIndex-1, &Line, &PreventRead);
				if((State == IdleSt) || (State == CommentSt))
				{
					if(PrevChar == ' ')
					{
						printf(" ");
					}
					Address[AddressIndex].NoInst += 1;
				}
				break;
			}
			case AddressSt:
			{
				SetPrintColor(MAGENTA_COLOR, NO_STYLE);
				printf("%c",PrevChar);
				RstColor();
				State = GetAddress(Counter,&TempAddress,PrevChar,NextChar,&Line,&PreventRead);
				if((State == CommentSt) || (State == IdleSt) || (State == AddressIdleSt))
				{
					if(FirstIndex == 0)
					{
						AddressIndex++;
						ActSegment++;
					}
					else
					{
						FirstIndex = 0;
					}
					for(j = 0; j < 50; j++)
					{
						Address[AddressIndex].Name[j] = TempAddress.Name[j];
					}
					Address[AddressIndex].NoInst = TempAddress.NoInst;
					Address[AddressIndex].Value  = TempAddress.Value ;
				}
				break;
			}
			case AddressIdleSt:
			{
				SetPrintColor(BLACK_COLOR, HIGH_INTENSITY);
				printf("%c",PrevChar);
				RstColor();
				if(IsComment(PrevChar))
				{
					Address[AddressIndex].NoInst += 1;
					State = CommentSt;
				}
				if(IsNextLine(PrevChar))
				{
					State = IdleSt;
					Line ++;
					PrintLineNumberOnCode(Line,Counter->Lines);
				}
				if(((IsSpace(PrevChar)) || (IsComment(PrevChar)) || (IsNextLine(PrevChar))) == 0)
				{
					SetPrintColor(RED_COLOR, HIGH_INTENSITY);
					printf("-> Error: Invalid character detected {%c,%u}",PrevChar,PrevChar);
					RstColor();
					State = ErrorSt;
				}
				break;
			}
			case CommentSt:
			{
				SetPrintColor(GREEN_COLOR, BOLD_HIGH_INT);
				printf("%c",NextChar);
				RstColor();
				if(IsNextLine(PrevChar))
				{
					State = IdleSt;
					Line++;
					printf("\n");
					PrintLineNumberOnCode(Line,Counter->Lines);
				}
				break;
			}
			case ErrorSt:
			{
				if(PreventRead == -1)
				{
					Errors[ErrorIndex] = Line;
					ErrorIndex ++;
					State = IdleSt;
					Line ++;
					SaveError = 1;
					printf("\n");
					PrintLineNumberOnCode(Line,Counter->Lines);
				}
				else
				{
					if(SaveError == 1)
					{
						Errors[ErrorIndex] = Line;
						ErrorIndex ++;
						SaveError = 0;
						PreventRead = 0;
					}
					if(IsNextLine(PrevChar))
					{
						State = IdleSt;
						Line ++;
						SaveError = 1;
						printf("\n");
						PrintLineNumberOnCode(Line,Counter->Lines);
					}
				}
				break;
			}
			default:
			{
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf(" D: ");
				RstColor();
			}
		}
	}

	CloseAsmCodeFile();

	if((ErrorIndex > 0) || (FatalError > 0))
	{
		printf("\n \n");
		if(FatalError > 0)
		{
			SetPrintColor(RED_COLOR, HIGH_INTENSITY);
			printf(" ** %u Fatal Errors found: \n\n",ErrorIndex);
			RstColor();
		}
		SetPrintColor(RED_COLOR, BOLD_STYLE);
		printf("    %u Errors found: \n\n",ErrorIndex);
		uint i;
		for(i = 0; i < ErrorIndex; i++)
		{
			printf(" -> Error on line %u \n",Errors[i]);
		}
		printf("\n");
		printf("    Assembler program will NOT  generate binary files \n \n");
		RstColor();
		return 1;
	}
	return 0;
}

RdSt GetInstruction(CounterT *Counter , InstructionT Instructions[Counter->Code], char  PrevChar ,
                    char      NextChar, uint         i                  , uint *Line     )
{
	static char         Tier    = 1;
	static InstStatesT1 StateT1 = Error1;
	static InstStatesT2 StateT2 = Error2;
	static InstStatesT3 StateT3 = Error3;
	static InstStatesT4 StateT4 = Error4;
	static InstStatesT5 StateT5 = Error5;
	static InstStatesT6 StateT6 = Error6;
	static InstStatesT7 StateT7 = Error7;
	switch (Tier)
	{
		case 1:
		{
			StateT1 = InstTier1(NextChar);
			Tier = 2;
			if(StateT1 == Error1)
			{
				Tier = 0x0A;
			}
			break;
		}
		case 2:
		{
			StateT2 = InstTier2(NextChar, StateT1);
			Tier = 3;
			if(StateT2 == Error2)
			{
				Tier = 0x0A;
			}
			break;
		}
		case 3:
		{
			StateT3 = InstTier3(NextChar, StateT2);
			Tier = 4;
			if(StateT3 == Error3)
			{
				Tier = 0x0A;
			}
			if(StateT3 == LB_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lb;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT3 == LH_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lh;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT3 == LW_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lw;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT3 == OR_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Or;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT3 == SB_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sb;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT3 == SH_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sh;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT3 == SW_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sw;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			break;
		}
		case 4:
		{
			StateT4 = InstTier4(NextChar, StateT3,PrevChar);
			Tier = 5;
			if(StateT4 == Error4)
			{
				Tier = 0x0A;
			}
			if(StateT4 == ADD_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Add;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == AND_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = And;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == BEQ_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Beq;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT4 == BGE_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Bge;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT4 == BLT_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Blt;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT4 == BNE_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Bne;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT4 == DIV_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Div;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == JAL_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Jal;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT4 == LBU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lbu;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT4 == LHU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lhu;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT4 == LUI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Lui;
				Instructions[i].Imm.Class   = ClassImmU;
			}
			if(StateT4 == MUL_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Mul;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == Mret_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Mret;
				Instructions[i].Imm.Class   = ClassReturn;
				*Line = *Line + 1;
				printf("\n");
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			if(StateT4 == ORI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = OrI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT4 == REM_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Rem;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == SLL_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sll;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == SLT_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Slt;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == SRA_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sra;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == Sret_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Sret;
				Instructions[i].Imm.Class   = ClassReturn;
				*Line = *Line + 1;
				printf("\n");
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			if(StateT4 == SRL_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Srl;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == SUB_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sub;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == XOR_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Xor;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT4 == NoOp_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction =       Add;
				Instructions[i].Imm.Class   = ClassImmR;
				Instructions[i].Rs1.Val     =         0;
				Instructions[i].Rs2.Val     =         0;
				Instructions[i].Rd .Val     =         0;
				*Line = *Line + 1;
				printf("\n");
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			if(StateT4 == Uret_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Uret;
				Instructions[i].Imm.Class   = ClassReturn;
				*Line = *Line + 1;
				printf("\n");
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			break;
		}
		case 5:
		{
			StateT5 = InstTier5(NextChar, StateT4);
			Tier = 6;
			if(StateT5 == Error5)
			{
				Tier = 0x0A;
			}
			if(StateT5 == ADDI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = AddI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT5 == ANDI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = AndI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT5 == BGEU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Bgeu;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT5 == BLTU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Bltu;
				Instructions[i].Imm.Class   = ClassImmS;
			}
			if(StateT5 == DIVU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Divu;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == JALR_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Jalr;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT5 == MRET_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Mret;
				Instructions[i].Imm.Class   = ClassReturn;
				if((IsNextLine(PrevChar)) || (IsNextLine(NextChar)))
				{
					*Line = *Line + 1;
					printf("\n");
					PrintLineNumberOnCode(*Line,Counter->Lines);
					return IdleSt;
				}
				return NoArgumentSt;
			}
			if(StateT5 == MULH_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Mulh;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == NOOP_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction =       Add;
				Instructions[i].Imm.Class   = ClassImmR;
				Instructions[i].Rs1.Val     =         0;
				Instructions[i].Rs2.Val     =         0;
				Instructions[i].Rd .Val     =         0;
				if((IsNextLine(PrevChar)) || (IsNextLine(NextChar)))
				{
					*Line = *Line + 1;
					printf("\n");
					PrintLineNumberOnCode(*Line,Counter->Lines);
					return IdleSt;
				}
				return NoArgumentSt;
			}
			if(StateT5 == REMU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Remu;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == SLLI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = SllI;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == SLTI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = SltI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT5 == SLTU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Sltu;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == SRAI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = SraI;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == SRET_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Sret;
				Instructions[i].Imm.Class   = ClassReturn;
				if((IsNextLine(PrevChar)) || (IsNextLine(NextChar)))
				{
					*Line = *Line + 1;
					printf("\n");
					PrintLineNumberOnCode(*Line,Counter->Lines);
					return IdleSt;
				}
				return NoArgumentSt;
			}
			if(StateT5 == SRLI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = SrlI;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT5 == URET_)
			{
				StateT1 = Error1;
				StateT2 = Error2;
				StateT3 = Error3;
				StateT4 = Error4;
				StateT5 = Error5;
				StateT6 = Error6;
				StateT7 = Error7;
				Tier    = 1     ;
				Instructions[i].Instruction = Uret;
				Instructions[i].Imm.Class   = ClassReturn;
				if((IsNextLine(PrevChar)) || (IsNextLine(NextChar)))
				{
					*Line = *Line + 1;
					printf("\n");
					PrintLineNumberOnCode(*Line,Counter->Lines);
					return IdleSt;
				}
				return NoArgumentSt;
			}
			if(StateT5 == XORI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = XorI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			break;
		}
		case 6:
		{
			StateT6 = InstTier6(NextChar, StateT5);
			Tier = 7;
			if(StateT6 == Error6)
			{
				Tier = 0x0A;
			}
			if(StateT6 == AUIPC_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = AuiPc;
				Instructions[i].Imm.Class   = ClassImmU;
			}
			if(StateT6 == CSRRC_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Csrrc;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT6 == CSRRS_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Csrrs;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT6 == CSRRW_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Csrrw;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT6 == MULHU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Mulhu;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			if(StateT6 == SLTIU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = SltIu;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			break;
		}
		case 7:
		{
			StateT7 = InstTier7(NextChar, StateT6);
			Tier = 8;
			if(StateT7 == Error7)
			{
				Tier = 0x0A;
			}
			if(StateT7 == CSRRCI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = CsrrcI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT7 == CSRRSI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = CsrrsI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT7 == CSRRWI_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = CsrrwI;
				Instructions[i].Imm.Class   = ClassImmI;
			}
			if(StateT7 == MULHSU_)
			{
				Tier = 0x00;
				Instructions[i].Instruction = Mulhsu;
				Instructions[i].Imm.Class   = ClassImmR;
			}
			break;
		}
		default:
		{
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> Invalid Instruction, default Case ");
			RstColor();
			StateT1 = Error1;
			StateT2 = Error2;
			StateT3 = Error3;
			StateT4 = Error4;
			StateT5 = Error5;
			StateT6 = Error6;
			StateT7 = Error7;
			Tier    = 1     ;
			return ErrorSt;
		}
	}
	if(Tier == 0x0A)
	{
		SetPrintColor(RED_COLOR, NO_STYLE);
		printf("-> Invalid Instruction ");
		RstColor();
		StateT1 = Error1;
		StateT2 = Error2;
		StateT3 = Error3;
		StateT4 = Error4;
		StateT5 = Error5;
		StateT6 = Error6;
		StateT7 = Error7;
		Tier    = 1     ;
		return ErrorSt;
	}
	if(Tier == 0x00)
	{
		StateT1 = Error1;
		StateT2 = Error2;
		StateT3 = Error3;
		StateT4 = Error4;
		StateT5 = Error5;
		StateT6 = Error6;
		StateT7 = Error7;
		Tier    = 1     ;
		return Argument1St;
	}
	return InstructionSt;
}

StT1 InstTier1(char NextChar                )
{
	if((NextChar == 'A') || (NextChar == 'a'))
	{
		return A;
	}
	if((NextChar == 'B') || (NextChar == 'b'))
	{
		return B;
	}
	if((NextChar == 'C') || (NextChar == 'c'))
	{
		return C;
	}
	if((NextChar == 'D') || (NextChar == 'd'))
	{
		return D;
	}
	if((NextChar == 'J') || (NextChar == 'j'))
	{
		return J;
	}
	if((NextChar == 'L') || (NextChar == 'l'))
	{
		return L;
	}
	if((NextChar == 'M') || (NextChar == 'm'))
	{
		return M;
	}
	if((NextChar == 'N') || (NextChar == 'n'))
	{
		return N;
	}
	if((NextChar == 'O') || (NextChar == 'o'))
	{
		return O;
	}
	if((NextChar == 'R') || (NextChar == 'r'))
	{
		return R;
	}
	if((NextChar == 'S') || (NextChar == 's'))
	{
		return S;
	}
	if((NextChar == 'U') || (NextChar == 'u'))
	{
		return U;
	}
	if((NextChar == 'X') || (NextChar == 'x'))
	{
		return X;
	}
	return Error1;
}

StT2 InstTier2(char NextChar, StT1 PrevState)
{
	switch (PrevState)
	{
		case A:
		{
			if((NextChar == 'D') || (NextChar == 'd'))
			{
				return AD;
			}
			if((NextChar == 'N') || (NextChar == 'n'))
			{
				return AN;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return AU;
			}
			return Error2;
		}
		case B:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return BE;
			}
			if((NextChar == 'G') || (NextChar == 'g'))
			{
				return BG;
			}
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return BL;
			}
			if((NextChar == 'N') || (NextChar == 'n'))
			{
				return BN;
			}
			return Error2;
		}
		case C:
		{
			if((NextChar == 'S') || (NextChar == 's'))
			{
				return CS;
			}
			return Error2;
			break;
		}
		case D:
		{
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return DI;
			}
			return Error2;
			break;
		}
		case J:
		{
			if((NextChar == 'A') || (NextChar == 'a'))
			{
				return JA;
			}
			return Error2;
			break;
		}
		case L:
		{
			if((NextChar == 'B') || (NextChar == 'b'))
			{
				return LB;
			}
			if((NextChar == 'H') || (NextChar == 'h'))
			{
				return LH;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return LU;
			}
			if((NextChar == 'W') || (NextChar == 'w'))
			{
				return LW;
			}
			return Error2;
			break;
		}
		case M:
		{
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return MR;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return MU;
			}
			return Error2;
			break;
		}
		case N:
		{
			if((NextChar == 'O') || (NextChar == 'o'))
			{
				return NO;
			}
			return Error2;
			break;
		}
		case O:
		{
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return OR;
			}
			return Error2;
			break;
		}
		case R:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return RE;
			}
			return Error2;
			break;
		}
		case S:
		{
			if((NextChar == 'B') || (NextChar == 'b'))
			{
				return SB;
			}
			if((NextChar == 'H') || (NextChar == 'h'))
			{
				return SH;
			}
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return SL;
			}
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return SR;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return SU;
			}
			if((NextChar == 'W') || (NextChar == 'w'))
			{
				return SW;
			}
			return Error2;
			break;
		}
		case U:
		{
			if((NextChar == 'R') || (NextChar == 'R'))
			{
				return UR;
			}
			return Error2;
			break;
		}
		case X:
		{
			if((NextChar == 'O') || (NextChar == 'o'))
			{
				return XO;
			}
			return Error2;
			break;
		}
		default:
		{
			return Error2;
		}
	}
	return Error2;
}

StT3 InstTier3(char NextChar, StT2 PrevState)
{
	switch (PrevState)
	{
		case AD:
		{
			if((NextChar == 'D') || (NextChar == 'd'))
			{
				return ADD;
			}
			return Error3;
		}
		case AN:
		{
			if((NextChar == 'D') || (NextChar == 'd'))
			{
				return AND;
			}
			return Error3;
		}
		case AU:
		{
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return AUI;
			}
			return Error3;
		}
		case BE:
		{
			if((NextChar == 'Q') || (NextChar == 'q'))
			{
				return BEQ;
			}
			return Error3;
		}
		case BG:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return BGE;
			}
			return Error3;
		}
		case BL:
		{
			if((NextChar == 'T') || (NextChar == 't'))
			{
				return BLT;
			}
			return Error3;
		}
		case BN:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return BNE;
			}
			return Error3;
		}
		case CS:
		{
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return CSR;
			}
			return Error3;
		}
		case DI:
		{
			if((NextChar == 'V') || (NextChar == 'v'))
			{
				return DIV;
			}
			return Error3;
		}
		case JA:
		{
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return JAL;
			}
			return Error3;
		}
		case LB:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LB_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return LBU;
			}
			return Error3;
		}
		case LH:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LH_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return LHU;
			}
			return Error3;
		}
		case LU:
		{
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return LUI;
			}
			return Error3;
		}
		case LW:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LW_;
			}
			return Error3;
		}
		case MR:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return MRE;
			}
			return Error3;
		}
		case MU:
		{
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return MUL;
			}
			return Error3;
		}
		case NO:
		{
			if((NextChar == 'O') || (NextChar == 'o'))
			{
				return NOO;
			}
			return Error3;
		}
		case OR:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return OR_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return ORI;
			}
			return Error3;
		}
		case RE:
		{
			if((NextChar == 'M') || (NextChar == 'm'))
			{
				return REM;
			}
			return Error3;
		}
		case SB:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SB_;
			}
			return Error3;
		}
		case SH:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SH_;
			}
			return Error3;
		}
		case SL:
		{
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return SLL;
			}
			if((NextChar == 'T') || (NextChar == 't'))
			{
				return SLT;
			}
			return Error3;
		}
		case SR:
		{
			if((NextChar == 'A') || (NextChar == 'a'))
			{
				return SRA;
			}
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return SRE;
			}
			if((NextChar == 'L') || (NextChar == 'l'))
			{
				return SRL;
			}
			return Error3;
		}
		case SU:
		{
			if((NextChar == 'B') || (NextChar == 'b'))
			{
				return SUB;
			}
			return Error3;
		}
		case SW:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SW_;
			}
			return Error3;
		}
		case UR:
		{
			if((NextChar == 'E') || (NextChar == 'e'))
			{
				return URE;
			}
			return Error3;
		}
		case XO:
		{
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return XOR;
			}
			return Error3;
		}
		default:
		{
			return Error3;
		}
	}
	return Error3;
}

StT4 InstTier4(char NextChar, StT3 PrevState, char PrevChar)
{
	switch (PrevState)
	{
		case ADD:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return ADD_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return ADDI;
			}
			return Error4;
		}
		case AND:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return AND_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return ANDI;
			}
			return Error4;
		}
		case AUI:
		{
			if((NextChar == 'P') || (NextChar == 'p'))
			{
				return AUIP;
			}
			return Error4;
		}
		case BEQ:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BEQ_;
			}
			return Error4;
		}
		case BGE:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BGE_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return BGEU;
			}
			return Error4;
		}
		case BLT:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BLT_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return BLTU;
			}
			return Error4;
		}
		case BNE:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BNE_;
			}
			return Error4;
		}
		case CSR:
		{
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return CSRR;
			}
			return Error4;
		}
		case DIV:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return DIV_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return DIVU;
			}
			return Error4;
		}
		case JAL:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return JAL_;
			}
			if((NextChar == 'R') || (NextChar == 'r'))
			{
				return JALR;
			}
			return Error4;
		}
		case LBU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LBU_;
			}
			return Error4;
		}
		case LHU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LHU_;
			}
			return Error4;
		}
		case LUI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return LUI_;
			}
			return Error4;
		}
		case MRE:
		{
			if((NextChar == 'T') || (NextChar == 't'))
			{
				if(IsNextLine(PrevChar))
				{
					return Mret_;
				}
				return MRET;
			}
			return Error4;
		}
		case MUL:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return MUL_;
			}
			if((NextChar == 'H') || (NextChar == 'h'))
			{
				return MULH;
			}
			return Error4;
		}
		case NOO:
		{
			if((NextChar == 'P') || (NextChar == 'p'))
			{
				if(IsNextLine(PrevChar))
				{
					return NoOp_;
				}
				return NOOP;
			}
			return Error4;
		}
		case ORI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return ORI_;
			}
			return Error4;
		}
		case REM:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return REM_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return REMU;
			}
			return Error4;
		}
		case SLL:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLL_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return SLLI;
			}
			return Error4;
		}
		case SLT:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLT_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return SLTI;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return SLTU;
			}
			return Error4;
		}
		case SRA:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SRA_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return SRAI;
			}
			return Error4;
		}
		case SRE:
		{
			if((NextChar == 'T') || (NextChar == 't'))
			{
				if(IsNextLine(PrevChar))
				{
					return Sret_;
				}
				return SRET;
			}
			return Error4;
		}
		case SRL:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SRL_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return SRLI;
			}
			return Error4;
		}
		case SUB:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SUB_;
			}
			return Error4;
		}
		case URE:
		{
			if((NextChar == 'T') || (NextChar == 't'))
			{
				if(IsNextLine(PrevChar))
				{
					return Uret_;
				}
				return URET;
			}
			return Error4;
		}
		case XOR:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return XOR_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return XORI;
			}
			return Error4;
		}
		default:
		{
			return Error4;
		}
	}
	return Error4;
}

StT5 InstTier5(char NextChar, StT4 PrevState)
{
	switch (PrevState)
	{
		case ADDI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return ADDI_;
			}
			return Error5;
		}
		case ANDI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return ANDI_;
			}
			return Error5;
		}
		case AUIP:
		{
			if((NextChar == 'C') || (NextChar == 'c'))
			{
				return AUIPC;
			}
			return Error5;
		}
		case BGEU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BGEU_;
			}
			return Error5;
		}
		case BLTU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return BLTU_;
			}
			return Error5;
		}
		case CSRR:
		{
			if((NextChar == 'C') || (NextChar == 'c'))
			{
				return CSRRC;
			}
			if((NextChar == 'S') || (NextChar == 's'))
			{
				return CSRRS;
			}
			if((NextChar == 'W') || (NextChar == 'w'))
			{
				return CSRRW;
			}
			return Error5;
		}
		case DIVU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return DIVU_;
			}
			return Error5;
		}
		case JALR:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return JALR_;
			}
			return Error5;
		}
		case MRET:
		{
			if((NextChar == ' ') || (NextChar == '	') || (IsNextLine(NextChar)))
			{
				return MRET_;
			}
			return Error5;
		}
		case MULH:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return MULH_;
			}
			if((NextChar == 'S') || (NextChar == 's'))
			{
				return MULHS;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return MULHU;
			}
			return Error5;
		}
		case NOOP:
		{
			if((NextChar == ' ') || (NextChar == '	') || (IsNextLine(NextChar)))
			{
				return NOOP_;
			}
			return Error5;
		}
		case REMU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return REMU_;
			}
			return Error5;
		}
		case SLLI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLLI_;
			}
			return Error5;
		}
		case SLTI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLTI_;
			}
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return SLTIU;
			}
			return Error5;
		}
		case SLTU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLTU_;
			}
			return Error5;
		}
		case SRAI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SRAI_;
			}
			return Error5;
		}
		case SRET:
		{
			if((NextChar == ' ') || (NextChar == '	') || (IsNextLine(NextChar)))
			{
				return SRET_;
			}
			return Error5;
		}
		case SRLI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SRLI_;
			}
			return Error5;
		}
		case URET:
		{
			if((NextChar == ' ') || (NextChar == '	') || (IsNextLine(NextChar)))
			{
				return URET_;
			}
			return Error5;
		}
		case XORI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return XORI_;
			}
			return Error5;
		}
		default:
		{
			return Error5;
		}
	}
	return Error5;
}

StT6 InstTier6(char NextChar, StT5 PrevState)
{
	switch (PrevState)
	{
		case AUIPC:
		{
			if(IsSpace(NextChar))
			{
				return AUIPC_;
			}
			return Error6;
		}
		case CSRRC:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRC_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return CSRRCI;
			}
			return Error6;
		}
		case CSRRS:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRS_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return CSRRSI;
			}
			return Error6;
		}
		case CSRRW:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRW_;
			}
			if((NextChar == 'I') || (NextChar == 'i'))
			{
				return CSRRWI;
			}
			return Error6;
		}
		case MULHS:
		{
			if((NextChar == 'U') || (NextChar == 'u'))
			{
				return MULHSU;
			}
			return Error6;
		}
		case MULHU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return MULHU_;
			}
			return Error6;
		}
		case SLTIU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return SLTIU_;
			}
			return Error6;
		}
		default:
		{
			return Error6;
		}
	}
	return Error6;
}

StT7 InstTier7(char NextChar, StT6 PrevState)
{
	switch (PrevState)
	{
		case CSRRCI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRCI_;
			}
			return Error7;
		}
		case CSRRSI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRSI_;
			}
			return Error7;
		}
		case CSRRWI:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return CSRRWI_;
			}
			return Error7;
		}
		case MULHSU:
		{
			if((NextChar == ' ') || (NextChar == '	'))
			{
				return MULHSU_;
			}
			return Error7;
		}
		default:
		{
			return Error7;
		}
	}
	return Error7;
}

RdSt GetArgument1(CounterT *Counter , InstructionT Instructions[Counter->Code], char  PrevChar   ,
                  char      NextChar, uint         i                  , char *PreventRead)
{
	static char RegAddress = 0;
	static char ValidReg   = 0;
	static char Finished   = 0;

	switch (ValidReg)
	{
		case 0:
		{
			if((NextChar =='R') || (NextChar == 'r') || (NextChar == '$'))
			{
				ValidReg = 1;
				return Argument1St;
			}
			if(IsSpace(NextChar))
			{
				return Argument1St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 1st Argument is invalid, expected R or $ to express register ");
			RstColor();
			RegAddress = 0;
			ValidReg   = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		case 1:
		{
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = NextChar - 0x30;
				ValidReg = 2;
				return Argument1St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 1st Argument is invalid, expected number to express register ");
			RstColor();
			RegAddress = 0;
			ValidReg   = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = 1;
			}
			return ErrorSt;
		}
		case 2:
		{
			if(IsSpace(NextChar))
			{
				if(Instructions[i].Instruction == Sb)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Sh)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Sw)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Beq)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bne)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Blt)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bge)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bltu)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bgeu)
				{
					Instructions[i].Rs1.Val=RegAddress;
					Finished = 1;
				}
				if(Finished != 1)
				{
					Instructions[i].Rd.Val=RegAddress;
				}
				RegAddress = 0;
				ValidReg   = 0;
				Finished   = 0;
				return Argument2St;
			}
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = (NextChar - 0x30) + (RegAddress * 10);
				if(RegAddress > 31)
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 1st Argument is invalid, register address beyond 31 ");
					RstColor();
					RegAddress = 0;
					ValidReg   = 0;
					return ErrorSt;
				}
				return Argument1St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 1st Argument is invalid, expected a 2nd number or space to express register address ");
			RstColor();
			RegAddress = 0;
			ValidReg   = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		default:
		{
			RegAddress = 0;
			ValidReg   = 0;
			return ErrorSt;
		}
	}
}

RdSt GetArgument2(CounterT *Counter , InstructionT Instructions[Counter->Code], char PrevChar    ,
                  char      NextChar, uint         i                  , char *PreventRead)
{
	static char RegAddress = 0;
	static uint Immediate  = 0;
	static char Validation = 0;
	static char Finished   = 0;

	if((Instructions[i].Instruction == Lui) || (Instructions[i].Instruction == AuiPc))
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = NextChar - 0x30;
					Validation = 1;
					return Argument2St;
				}
				if(IsSpace(NextChar))
				{
					return Argument2St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = (Immediate * 10) + (NextChar - 0x30);
					return Argument2St;
				}
				if(IsSpace(NextChar))
				{
					if(Immediate <= 0x000FFFFF)
					{
						Instructions[i].Imm.Value = Immediate;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						if(IsComment(PrevChar))
						{
							return CommentSt;
						}
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 2nd Argument is invalid, value has over 20 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					if(IsNextLine(NextChar))
					{
						*PreventRead = -1;
					}
					return ErrorSt;
				}
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, must be a number ");
				RstColor();
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}

	if((Instructions[i].Instruction == CsrrwI) || (Instructions[i].Instruction == CsrrcI) ||
	   (Instructions[i].Instruction == CsrrsI))
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					RegAddress  = NextChar - 0x30;
					Validation = 1;
					return Argument2St;
				}
				if(NextChar == 'D')
				{
					Validation = 1;
					return Argument2St;
				}
				if(IsSpace(NextChar))
				{
					return Argument2St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					RegAddress  = (RegAddress * 10) + (NextChar - 0x30);
					return Argument2St;
				}
				if(IsSpace(NextChar))
				{
					if(RegAddress <= 0x0000001F)
					{
						Instructions[i].Rs2.Val = RegAddress;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						return Argument3St;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 2nd Argument is invalid, value has over 5 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					if(IsNextLine(NextChar))
					{
						*PreventRead = -1;
					}
					return ErrorSt;
				}
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, must be a number ");
				RstColor();
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}

	if(Instructions[i].Instruction == Jal)
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = NextChar - 0x30;
					Validation = 1;
					return Argument2St;
				}
				if(IsSpace(NextChar))
				{
					return Argument2St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = (Immediate * 10) + (NextChar - 0x30);
					return Argument2St;
				}
				if((IsSpace(NextChar)) || (IsNextLine(NextChar)))
				{
					if(IsNextLine(NextChar))
					{
						*PreventRead = -1;
					}
					if(Immediate <= 0x00000FFF)
					{
						Instructions[i].Imm.Value = Immediate;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						if(IsComment(PrevChar))
						{
							return CommentSt;
						}
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 2nd Argument is invalid, value has over 12 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 2nd Argument is invalid, must be a number ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}
	switch (Validation)
	{
		case 0:
		{
			if((NextChar =='R') || (NextChar == 'r') || (NextChar == '$'))
			{
				Validation = 1;
				return Argument2St;
			}
			if(IsSpace(NextChar))
			{
				return Argument2St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 2nd Argument is invalid, expected R or $ to express register ");
			RstColor();
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		case 1:
		{
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = NextChar - 0x30;
				Validation = 2;
				return Argument2St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 2nd Argument is invalid, expected number to express register ");
			RstColor();
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		case 2:
		{
			if(IsSpace(NextChar))
			{
				if(Instructions[i].Instruction == Sb)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Sh)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Sw)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Beq)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bne)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Blt)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bge)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bltu)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Instructions[i].Instruction == Bgeu)
				{
					Instructions[i].Rs2.Val=RegAddress;
					Finished = 1;
				}
				if(Finished != 1)
				{
					Instructions[i].Rs1.Val=RegAddress;
				}
				RegAddress = 0;
				Validation = 0;
				Finished   = 0;
				return Argument3St;
			}
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = (NextChar - 0x30) + (RegAddress * 10);
				if(RegAddress > 31)
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 2nd Argument is invalid, register address beyond 31 ");
					RstColor();
					RegAddress = 0;
					Validation   = 0;
					return ErrorSt;
				}
				return Argument2St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 2nd Argument is invalid, expected a 2nd number or space to express register address ");
			RstColor();
			RegAddress = 0;
			Validation = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		default:
		{
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			return ErrorSt;
		}
	}
	// Imm-I para Jal -> return Idle con 0x0A
	// Imm-U para Lui y AuiPc -> return Idle con 0x0A
	// Rs2 SB SH SW Branches BXXx
	// Rs1 para todos
}

RdSt GetArgument3(CounterT *Counter    , InstructionT Instructions[Counter->Code], char  PrevChar ,
                  char      NextChar   , uint         i                  , uint *Line     ,
                  char     *PreventRead)
{
	static char RegAddress = 0;
	static uint Immediate  = 0;
	static char Validation = 0;

	if((Instructions[i].Imm.Class == ClassImmI) || (Instructions[i].Imm.Class == ClassImmS))
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate = NextChar - 0x30;
					Validation = 1;
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					return Argument3St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = (Immediate * 10) + (NextChar - 0x30);
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					if(Immediate <= 0x00000FFF)
					{
						Instructions[i].Imm.Value = Immediate;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						if(PrevChar == '@')
						{
							return CommentSt;
						}
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 12 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				if(IsNextLine(NextChar))
				{
					if(Immediate <= 0x00000FFF)
					{
						Instructions[i].Imm.Value = Immediate;
						RegAddress   = 0;
						Immediate    = 0;
						Validation   = 0;
						*PreventRead = 1;
						*Line = *Line + 1;
						PrintLineNumberOnCode(*Line,Counter->Lines);
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 12 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, must be a number ");
				RstColor();
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}

	if((Instructions[i].Instruction == SllI) || (Instructions[i].Instruction == SrlI))
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate = NextChar - 0x30;
					Validation = 1;
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					return Argument3St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = (Immediate * 10) + (NextChar - 0x30);
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					if(Immediate <= 0x0000001F)
					{
						Instructions[i].Rs2.Val = Immediate;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						if(PrevChar == '@')
						{
							return CommentSt;
						}
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 5 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				if(IsNextLine(NextChar))
				{
					if(Immediate <= 0x0000001F)
					{
						Instructions[i].Rs2.Val = Immediate;
						RegAddress   = 0;
						Immediate    = 0;
						Validation   = 0;
						*PreventRead = 1;
						*Line = *Line + 1;
						PrintLineNumberOnCode(*Line,Counter->Lines);
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 5 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, must be a number ");
				RstColor();
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}

	if (Instructions[i].Instruction == SraI)
	{
		switch (Validation)
		{
			case 0:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate = NextChar - 0x30;
					Validation = 1;
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					return Argument3St;
				}
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, expected Immediate data ");
				RstColor();
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				if(IsNextLine(NextChar))
				{
					*PreventRead = -1;
				}
				return ErrorSt;
			}
			case 1:
			{
				if((NextChar >= '0') && (NextChar <= '9'))
				{
					Immediate  = (Immediate * 10) + (NextChar - 0x30);
					return Argument3St;
				}
				if(IsSpace(NextChar))
				{
					if(Immediate <= 0x0000001F)
					{
						Instructions[i].Rs2.Val = Immediate;
						RegAddress = 0;
						Immediate  = 0;
						Validation = 0;
						if(PrevChar == '@')
						{
							return CommentSt;
						}
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 5 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				if(IsNextLine(NextChar))
				{
					if(Immediate <= 0x0000001F)
					{
						Instructions[i].Rs2.Val = Immediate;
						RegAddress   = 0;
						Immediate    = 0;
						Validation   = 0;
						*PreventRead = 1;
						*Line = *Line + 1;
						PrintLineNumberOnCode(*Line,Counter->Lines);
						return IdleSt;
					}
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3th Argument is invalid, value has over 5 bits ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> 3th Argument is invalid, must be a number ");
				RstColor();
				return ErrorSt;
			}
			default:
			{
				RegAddress = 0;
				Immediate  = 0;
				Validation = 0;
				return ErrorSt;
			}
		}
	}

	switch (Validation)
	{
		case 0:
		{
			if((NextChar =='R') || (NextChar == 'r') || (NextChar == '$'))
			{
				Validation = 1;
				return Argument3St;
			}
			if(IsSpace(NextChar))
			{
				return Argument3St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 3rd Argument is invalid, expected R or $ to express register ");
			RstColor();
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		case 1:
		{
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = NextChar - 0x30;
				Validation = 2;
				return Argument3St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 3rd Argument is invalid, expected number to express register ");
			RstColor();
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			if(IsNextLine(NextChar))
			{
				*PreventRead = -1;
			}
			return ErrorSt;
		}
		case 2:
		{
			if(IsSpace(NextChar))
			{
				Instructions[i].Rs2.Val=RegAddress;
				RegAddress = 0;
				Validation = 0;
				Immediate  = 0;
				if(PrevChar == '@')
				{
					return CommentSt;
				}
				return IdleSt;
			}
			if(IsNextLine(NextChar))
			{
				Instructions[i].Rs2.Val=RegAddress;
				RegAddress   = 0;
				Validation   = 0;
				Immediate    = 0;
				*PreventRead = 1;
				*Line = *Line + 1;
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			if((NextChar >= '0') && (NextChar <= '9'))
			{
				RegAddress = (NextChar - 0x30) + (RegAddress * 10);
				if(RegAddress > 31)
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> 3rd Argument is invalid, register address beyond 31 ");
					RstColor();
					RegAddress = 0;
					Immediate  = 0;
					Validation = 0;
					return ErrorSt;
				}
				return Argument3St;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> 3rd Argument is invalid, expected a 2nd number or space to express register address ");
			RstColor();
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			return ErrorSt;
		}
		default:
		{
			RegAddress = 0;
			Immediate  = 0;
			Validation = 0;
			return ErrorSt;
		}
	}
	// Imm-I para instrucciones tipo I
	// Imm-S para instrucciones tipo S
	// Rs2 para todos
}

RdSt GetAddress(CounterT *Counter    , AddressT *TmpAddress , char  PrevChar    ,
                char      NextChar   , uint     *Line       , char *PreventRead)
{
	static uchar State = 0;
	static uchar Index = 0;
	static uchar First = 1;
	uint         j        ;

	if(First == 1)
	{
		for(j = 0; j < 50; j++)
		{
			TmpAddress->Name[j] = ' ';
		}
		TmpAddress->NoInst = 0;
		TmpAddress->Value  = 0;
		First = 0;
	}

	switch (State)
	{
		case 0: // Address Name
		{
			if((('A' <= PrevChar) && (PrevChar <= 'Z')) ||
			   (('a' <= PrevChar) && (PrevChar <= 'z')) ||
			   (('0' <= PrevChar) && (PrevChar <= '9')) ||
			   ((PrevChar == '_') || (PrevChar == '-'))  )
			{
				TmpAddress->Name[Index] = PrevChar;
				Index++;
				State = 1;
				return AddressSt;
			}
			if(IsNextLine(PrevChar))
			{
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("-> No address Name provided");
				RstColor();
				*PreventRead = 1;
				State = 0;
				Index = 0;
				First = 1;
				return ErrorSt;
			}
			if(IsSpace(PrevChar))
			{
				State = 0;
				Index = 0;
				return AddressSt;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> Wrong address Name, the address identifier has an invalid character ");
			RstColor();
			State = 0;
			Index = 0;
			First = 1;
			return ErrorSt;
		}
		case 1:
		{
			if((('A' <= PrevChar) && (PrevChar <= 'Z')) ||
			   (('a' <= PrevChar) && (PrevChar <= 'z')) ||
			   (('0' <= PrevChar) && (PrevChar <= '9')) ||
			   ((PrevChar == '_') || (PrevChar == '-'))  )
			{
				TmpAddress->Name[Index] = PrevChar;
				Index++;
				if(Index == 50)
				{
					SetPrintColor(RED_COLOR, NO_STYLE);
					printf("-> Address Name is over 50 characters ");
					RstColor();
					State = 0;
					Index = 0;
					First = 1;
					return ErrorSt;
				}
				return AddressSt;
			}
			if(IsSpace(PrevChar))
			{
				State = 0;
				Index = 0;
				First = 1;
				return AddressIdleSt;
			}
			if(IsNextLine(PrevChar))
			{
				State = 0;
				Index = 0;
				First = 1;
				*Line = *Line + 1;
				PrintLineNumberOnCode(*Line,Counter->Lines);
				return IdleSt;
			}
			SetPrintColor(RED_COLOR, NO_STYLE);
			printf("-> Wrong address Name, the address identifier has an invalid character ");
			RstColor();
			State = 0;
			Index = 0;
			First = 1;
			return ErrorSt;
		}
		default:
		{
			State = 0;
			Index = 0;
			First = 1;
			return ErrorSt;
		}
	}
	return IdleSt;
}

void AssignOpCodes(CounterT *Counter, InstructionT Instructions[Counter->Code])
{
	uint i;
	for(i = 0; i < Counter->Code; i++)
	{
		switch (Instructions[i].Instruction)
		{
			case Lui:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '1';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				break;
			}
			case AuiPc:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '1';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				break;
			}
			case AddI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case SltI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case SltIu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case XorI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case OrI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case AndI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case SllI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case SrlI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case SraI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '1';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Add:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Sub:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '1';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Sll:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Slt:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Sltu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Xor:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Srl:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Sra:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '1';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Or:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case And:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Csrrw:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Csrrs:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Csrrc:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case CsrrwI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case CsrrsI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case CsrrcI:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Uret:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				Instructions[i].Rd    .Bin   [0] = '0';
				Instructions[i].Rd    .Bin   [1] = '0';
				Instructions[i].Rd    .Bin   [2] = '0';
				Instructions[i].Rd    .Bin   [3] = '0';
				Instructions[i].Rd    .Bin   [4] = '0';
				Instructions[i].Rs1   .Bin   [0] = '0';
				Instructions[i].Rs1   .Bin   [1] = '0';
				Instructions[i].Rs1   .Bin   [2] = '0';
				Instructions[i].Rs1   .Bin   [3] = '0';
				Instructions[i].Rs1   .Bin   [4] = '0';
				Instructions[i].Rs2   .Bin   [0] = '0';
				Instructions[i].Rs2   .Bin   [1] = '1';
				Instructions[i].Rs2   .Bin   [2] = '0';
				Instructions[i].Rs2   .Bin   [3] = '0';
				Instructions[i].Rs2   .Bin   [4] = '0';
				break;
			}
			case Sret:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '1';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				Instructions[i].Rd    .Bin   [0] = '0';
				Instructions[i].Rd    .Bin   [1] = '0';
				Instructions[i].Rd    .Bin   [2] = '0';
				Instructions[i].Rd    .Bin   [3] = '0';
				Instructions[i].Rd    .Bin   [4] = '0';
				Instructions[i].Rs1   .Bin   [0] = '0';
				Instructions[i].Rs1   .Bin   [1] = '0';
				Instructions[i].Rs1   .Bin   [2] = '0';
				Instructions[i].Rs1   .Bin   [3] = '0';
				Instructions[i].Rs1   .Bin   [4] = '0';
				Instructions[i].Rs2   .Bin   [0] = '0';
				Instructions[i].Rs2   .Bin   [1] = '1';
				Instructions[i].Rs2   .Bin   [2] = '0';
				Instructions[i].Rs2   .Bin   [3] = '0';
				Instructions[i].Rs2   .Bin   [4] = '0';
				break;
			}
			case Mret:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '0';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '1';
				Instructions[i].OpCode.Funct7[4] = '1';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				Instructions[i].Rd    .Bin   [0] = '0';
				Instructions[i].Rd    .Bin   [1] = '0';
				Instructions[i].Rd    .Bin   [2] = '0';
				Instructions[i].Rd    .Bin   [3] = '0';
				Instructions[i].Rd    .Bin   [4] = '0';
				Instructions[i].Rs1   .Bin   [0] = '0';
				Instructions[i].Rs1   .Bin   [1] = '0';
				Instructions[i].Rs1   .Bin   [2] = '0';
				Instructions[i].Rs1   .Bin   [3] = '0';
				Instructions[i].Rs1   .Bin   [4] = '0';
				Instructions[i].Rs2   .Bin   [0] = '0';
				Instructions[i].Rs2   .Bin   [1] = '1';
				Instructions[i].Rs2   .Bin   [2] = '0';
				Instructions[i].Rs2   .Bin   [3] = '0';
				Instructions[i].Rs2   .Bin   [4] = '0';
				break;
			}
			case Lb:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Lh:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Lw:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Lbu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Lhu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '0';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Sb:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Sh:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Sw:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Jal:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '1';
				Instructions[i].OpCode.OpCode[3] = '1';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Jalr:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '1';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Beq:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Bne:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				break;
			}
			case Blt:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Bge:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Bltu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Bgeu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '0';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '1';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				break;
			}
			case Mul:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Mulh:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Mulhsu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Mulhu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '0';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Div:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Divu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '0';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Rem:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '0';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			case Remu:
			{
				Instructions[i].OpCode.OpCode[0] = '1';
				Instructions[i].OpCode.OpCode[1] = '1';
				Instructions[i].OpCode.OpCode[2] = '0';
				Instructions[i].OpCode.OpCode[3] = '0';
				Instructions[i].OpCode.OpCode[4] = '1';
				Instructions[i].OpCode.OpCode[5] = '1';
				Instructions[i].OpCode.OpCode[6] = '0';
				Instructions[i].OpCode.Funct3[0] = '1';
				Instructions[i].OpCode.Funct3[1] = '1';
				Instructions[i].OpCode.Funct3[2] = '1';
				Instructions[i].OpCode.Funct7[0] = '1';
				Instructions[i].OpCode.Funct7[1] = '0';
				Instructions[i].OpCode.Funct7[2] = '0';
				Instructions[i].OpCode.Funct7[3] = '0';
				Instructions[i].OpCode.Funct7[4] = '0';
				Instructions[i].OpCode.Funct7[5] = '0';
				Instructions[i].OpCode.Funct7[6] = '0';
				break;
			}
			default:
			{
				Instructions[i].OpCode.OpCode[0] = '9';
				Instructions[i].OpCode.OpCode[1] = '9';
				Instructions[i].OpCode.OpCode[2] = '9';
				Instructions[i].OpCode.OpCode[3] = '9';
				Instructions[i].OpCode.OpCode[4] = '9';
				Instructions[i].OpCode.OpCode[5] = '9';
				Instructions[i].OpCode.OpCode[6] = '9';
				Instructions[i].OpCode.Funct3[0] = '9';
				Instructions[i].OpCode.Funct3[1] = '9';
				Instructions[i].OpCode.Funct3[2] = '9';
				Instructions[i].OpCode.Funct7[0] = '9';
				Instructions[i].OpCode.Funct7[1] = '9';
				Instructions[i].OpCode.Funct7[2] = '9';
				Instructions[i].OpCode.Funct7[3] = '9';
				Instructions[i].OpCode.Funct7[4] = '9';
				Instructions[i].OpCode.Funct7[5] = '9';
				Instructions[i].OpCode.Funct7[6] = '9';
			}
		}
	}
}

void BinaryConversion(CounterT *Counter, InstructionT Instructions[Counter->Code])
{
	uint i;
	for(i = 0; i < Counter->Code; i++)
	{
		if((Instructions[i].Rd .Val <= 31) && (Instructions[i].Rd .Val >= 0))
		{
			Dec2Bin(Instructions[i].Rd .Val,5,Instructions[i].Rd .Bin);
		}
		if((Instructions[i].Rs1.Val <= 31) && (Instructions[i].Rs1.Val >= 0))
		{
			Dec2Bin(Instructions[i].Rs1.Val,5,Instructions[i].Rs1.Bin);
		}
		if((Instructions[i].Rs2.Val <= 31) && (Instructions[i].Rs2.Val >= 0))
		{
			Dec2Bin(Instructions[i].Rs2.Val,5,Instructions[i].Rs2.Bin);
		}
		switch (Instructions[i].Imm.Class)
		{
			case ClassImmI:
			{
				Dec2Bin(Instructions[i].Imm.Value,12,Instructions[i].Imm.Bin.I);
				break;
			}
			case ClassImmU:
			{
				Dec2Bin(Instructions[i].Imm.Value,20,Instructions[i].Imm.Bin.U);
				break;
			}
			case ClassImmS:
			{
				char TempBin[12];
				Dec2Bin(Instructions[i].Imm.Value,12,TempBin);
				Instructions[i].Imm.Bin.Sl[0] = TempBin[ 0];
				Instructions[i].Imm.Bin.Sl[1] = TempBin[ 1];
				Instructions[i].Imm.Bin.Sl[2] = TempBin[ 2];
				Instructions[i].Imm.Bin.Sl[3] = TempBin[ 3];
				Instructions[i].Imm.Bin.Sl[4] = TempBin[ 4];
				Instructions[i].Imm.Bin.Sh[0] = TempBin[ 5];
				Instructions[i].Imm.Bin.Sh[1] = TempBin[ 6];
				Instructions[i].Imm.Bin.Sh[2] = TempBin[ 7];
				Instructions[i].Imm.Bin.Sh[3] = TempBin[ 8];
				Instructions[i].Imm.Bin.Sh[4] = TempBin[ 9];
				Instructions[i].Imm.Bin.Sh[5] = TempBin[10];
				Instructions[i].Imm.Bin.Sh[6] = TempBin[11];
				break;
			}
			default:
			{
			}
		}
	}
}

void Dec2Bin(uint Num, char Size, char Bin[Size])
{
	int i;
	for(i = 0; i < Size; i++)
	{
		Bin[i] = (Num % 2) + '0';
		Num = Num /2;
	}
}

uint CreateAddressValues(CounterT *Counter    , AddressT Address     [Counter->Address ], char SliceSize)
{
	int i;
	uint CurrentAddress = 0;
	Address[0].Value = 0;
	for (i = 1; i < Counter->Address; ++i)
	{
		CurrentAddress += (Address[i-1].NoInst - 1) + 1;
		while((CurrentAddress % SliceSize) != 0)
		{
			CurrentAddress++;
		}
		Address[i].Value = CurrentAddress;
	}
	return CurrentAddress;
}


#include "BinaryAssembly.h"

char AssembleCode(CounterT *Counter   , InstructionT  Instructions[Counter->Code    ] ,
                  char      SliceSice , AddressT      Address     [Counter->Address ] ,
                  uint      MaxAddress, BinaryInstT   BinaryInst  [Counter->Code    ])
{
	char Status;
	Status = AssembleInst(Counter, Instructions, SliceSice, Address, MaxAddress, BinaryInst);
	PrintAssembly        (Counter,BinaryInst,Instructions);
	Pause();
	Cls();
	return Status;
}

char AssembleInst(CounterT *Counter   , InstructionT  Instructions[Counter->Code    ] ,
                  char      SliceSice , AddressT      Address     [Counter->Address ] ,
                  uint      MaxAddress, BinaryInstT   BinaryInst  [Counter->Code    ])
{
	uint  i             ;
	uint  j             ;
	uint  ActAddress = 0;
	uchar ActSegment = 0;
	for(i = 0 ; i < Counter->Code ; i++)
	{
		switch (Instructions[i].Imm.Class)
		{
			case ClassImmI:
			{
				BinaryInst[i].Instruction[ 0] = Instructions[i].OpCode.OpCode[ 0];
				BinaryInst[i].Instruction[ 1] = Instructions[i].OpCode.OpCode[ 1];
				BinaryInst[i].Instruction[ 2] = Instructions[i].OpCode.OpCode[ 2];
				BinaryInst[i].Instruction[ 3] = Instructions[i].OpCode.OpCode[ 3];
				BinaryInst[i].Instruction[ 4] = Instructions[i].OpCode.OpCode[ 4];
				BinaryInst[i].Instruction[ 5] = Instructions[i].OpCode.OpCode[ 5];
				BinaryInst[i].Instruction[ 6] = Instructions[i].OpCode.OpCode[ 6];
				BinaryInst[i].Instruction[ 7] = Instructions[i].Rd    .Bin   [ 0];
				BinaryInst[i].Instruction[ 8] = Instructions[i].Rd    .Bin   [ 1];
				BinaryInst[i].Instruction[ 9] = Instructions[i].Rd    .Bin   [ 2];
				BinaryInst[i].Instruction[10] = Instructions[i].Rd    .Bin   [ 3];
				BinaryInst[i].Instruction[11] = Instructions[i].Rd    .Bin   [ 4];
				BinaryInst[i].Instruction[12] = Instructions[i].OpCode.Funct3[ 0];
				BinaryInst[i].Instruction[13] = Instructions[i].OpCode.Funct3[ 1];
				BinaryInst[i].Instruction[14] = Instructions[i].OpCode.Funct3[ 2];
				BinaryInst[i].Instruction[15] = Instructions[i].Rs1   .Bin   [ 0];
				BinaryInst[i].Instruction[16] = Instructions[i].Rs1   .Bin   [ 1];
				BinaryInst[i].Instruction[17] = Instructions[i].Rs1   .Bin   [ 2];
				BinaryInst[i].Instruction[18] = Instructions[i].Rs1   .Bin   [ 3];
				BinaryInst[i].Instruction[19] = Instructions[i].Rs1   .Bin   [ 4];
				BinaryInst[i].Instruction[20] = Instructions[i].Imm   .Bin.I [ 0];
				BinaryInst[i].Instruction[21] = Instructions[i].Imm   .Bin.I [ 1];
				BinaryInst[i].Instruction[22] = Instructions[i].Imm   .Bin.I [ 2];
				BinaryInst[i].Instruction[23] = Instructions[i].Imm   .Bin.I [ 3];
				BinaryInst[i].Instruction[24] = Instructions[i].Imm   .Bin.I [ 4];
				BinaryInst[i].Instruction[25] = Instructions[i].Imm   .Bin.I [ 5];
				BinaryInst[i].Instruction[26] = Instructions[i].Imm   .Bin.I [ 6];
				BinaryInst[i].Instruction[27] = Instructions[i].Imm   .Bin.I [ 7];
				BinaryInst[i].Instruction[28] = Instructions[i].Imm   .Bin.I [ 8];
				BinaryInst[i].Instruction[29] = Instructions[i].Imm   .Bin.I [ 9];
				BinaryInst[i].Instruction[30] = Instructions[i].Imm   .Bin.I [10];
				BinaryInst[i].Instruction[31] = Instructions[i].Imm   .Bin.I [11];
				break;
			}
			case ClassImmU:
			{
				BinaryInst[i].Instruction[ 0] = Instructions[i].OpCode.OpCode[ 0];
				BinaryInst[i].Instruction[ 1] = Instructions[i].OpCode.OpCode[ 1];
				BinaryInst[i].Instruction[ 2] = Instructions[i].OpCode.OpCode[ 2];
				BinaryInst[i].Instruction[ 3] = Instructions[i].OpCode.OpCode[ 3];
				BinaryInst[i].Instruction[ 4] = Instructions[i].OpCode.OpCode[ 4];
				BinaryInst[i].Instruction[ 5] = Instructions[i].OpCode.OpCode[ 5];
				BinaryInst[i].Instruction[ 6] = Instructions[i].OpCode.OpCode[ 6];
				BinaryInst[i].Instruction[ 7] = Instructions[i].Rd    .Bin   [ 0];
				BinaryInst[i].Instruction[ 8] = Instructions[i].Rd    .Bin   [ 1];
				BinaryInst[i].Instruction[ 9] = Instructions[i].Rd    .Bin   [ 2];
				BinaryInst[i].Instruction[10] = Instructions[i].Rd    .Bin   [ 3];
				BinaryInst[i].Instruction[11] = Instructions[i].Rd    .Bin   [ 4];
				BinaryInst[i].Instruction[12] = Instructions[i].Imm   .Bin.U [ 0];
				BinaryInst[i].Instruction[13] = Instructions[i].Imm   .Bin.U [ 1];
				BinaryInst[i].Instruction[14] = Instructions[i].Imm   .Bin.U [ 2];
				BinaryInst[i].Instruction[15] = Instructions[i].Imm   .Bin.U [ 3];
				BinaryInst[i].Instruction[16] = Instructions[i].Imm   .Bin.U [ 4];
				BinaryInst[i].Instruction[17] = Instructions[i].Imm   .Bin.U [ 5];
				BinaryInst[i].Instruction[18] = Instructions[i].Imm   .Bin.U [ 6];
				BinaryInst[i].Instruction[19] = Instructions[i].Imm   .Bin.U [ 7];
				BinaryInst[i].Instruction[20] = Instructions[i].Imm   .Bin.U [ 8];
				BinaryInst[i].Instruction[21] = Instructions[i].Imm   .Bin.U [ 9];
				BinaryInst[i].Instruction[22] = Instructions[i].Imm   .Bin.U [10];
				BinaryInst[i].Instruction[23] = Instructions[i].Imm   .Bin.U [11];
				BinaryInst[i].Instruction[24] = Instructions[i].Imm   .Bin.U [12];
				BinaryInst[i].Instruction[25] = Instructions[i].Imm   .Bin.U [13];
				BinaryInst[i].Instruction[26] = Instructions[i].Imm   .Bin.U [14];
				BinaryInst[i].Instruction[27] = Instructions[i].Imm   .Bin.U [15];
				BinaryInst[i].Instruction[28] = Instructions[i].Imm   .Bin.U [16];
				BinaryInst[i].Instruction[29] = Instructions[i].Imm   .Bin.U [17];
				BinaryInst[i].Instruction[30] = Instructions[i].Imm   .Bin.U [18];
				BinaryInst[i].Instruction[31] = Instructions[i].Imm   .Bin.U [19];
				break;
			}
			case ClassImmR:
			{
				BinaryInst[i].Instruction[ 0] = Instructions[i].OpCode.OpCode[ 0];
				BinaryInst[i].Instruction[ 1] = Instructions[i].OpCode.OpCode[ 1];
				BinaryInst[i].Instruction[ 2] = Instructions[i].OpCode.OpCode[ 2];
				BinaryInst[i].Instruction[ 3] = Instructions[i].OpCode.OpCode[ 3];
				BinaryInst[i].Instruction[ 4] = Instructions[i].OpCode.OpCode[ 4];
				BinaryInst[i].Instruction[ 5] = Instructions[i].OpCode.OpCode[ 5];
				BinaryInst[i].Instruction[ 6] = Instructions[i].OpCode.OpCode[ 6];
				BinaryInst[i].Instruction[ 7] = Instructions[i].Rd    .Bin   [ 0];
				BinaryInst[i].Instruction[ 8] = Instructions[i].Rd    .Bin   [ 1];
				BinaryInst[i].Instruction[ 9] = Instructions[i].Rd    .Bin   [ 2];
				BinaryInst[i].Instruction[10] = Instructions[i].Rd    .Bin   [ 3];
				BinaryInst[i].Instruction[11] = Instructions[i].Rd    .Bin   [ 4];
				BinaryInst[i].Instruction[12] = Instructions[i].OpCode.Funct3[ 0];
				BinaryInst[i].Instruction[13] = Instructions[i].OpCode.Funct3[ 1];
				BinaryInst[i].Instruction[14] = Instructions[i].OpCode.Funct3[ 2];
				BinaryInst[i].Instruction[15] = Instructions[i].Rs1   .Bin   [ 0];
				BinaryInst[i].Instruction[16] = Instructions[i].Rs1   .Bin   [ 1];
				BinaryInst[i].Instruction[17] = Instructions[i].Rs1   .Bin   [ 2];
				BinaryInst[i].Instruction[18] = Instructions[i].Rs1   .Bin   [ 3];
				BinaryInst[i].Instruction[19] = Instructions[i].Rs1   .Bin   [ 4];
				BinaryInst[i].Instruction[20] = Instructions[i].Rs2   .Bin   [ 0];
				BinaryInst[i].Instruction[21] = Instructions[i].Rs2   .Bin   [ 1];
				BinaryInst[i].Instruction[22] = Instructions[i].Rs2   .Bin   [ 2];
				BinaryInst[i].Instruction[23] = Instructions[i].Rs2   .Bin   [ 3];
				BinaryInst[i].Instruction[24] = Instructions[i].Rs2   .Bin   [ 4];
				BinaryInst[i].Instruction[25] = Instructions[i].OpCode.Funct7[ 0];
				BinaryInst[i].Instruction[26] = Instructions[i].OpCode.Funct7[ 1];
				BinaryInst[i].Instruction[27] = Instructions[i].OpCode.Funct7[ 2];
				BinaryInst[i].Instruction[28] = Instructions[i].OpCode.Funct7[ 3];
				BinaryInst[i].Instruction[29] = Instructions[i].OpCode.Funct7[ 4];
				BinaryInst[i].Instruction[30] = Instructions[i].OpCode.Funct7[ 5];
				BinaryInst[i].Instruction[31] = Instructions[i].OpCode.Funct7[ 6];
				break;
			}
			case ClassImmS:
			{
				BinaryInst[i].Instruction[ 0] = Instructions[i].OpCode.OpCode[ 0];
				BinaryInst[i].Instruction[ 1] = Instructions[i].OpCode.OpCode[ 1];
				BinaryInst[i].Instruction[ 2] = Instructions[i].OpCode.OpCode[ 2];
				BinaryInst[i].Instruction[ 3] = Instructions[i].OpCode.OpCode[ 3];
				BinaryInst[i].Instruction[ 4] = Instructions[i].OpCode.OpCode[ 4];
				BinaryInst[i].Instruction[ 5] = Instructions[i].OpCode.OpCode[ 5];
				BinaryInst[i].Instruction[ 6] = Instructions[i].OpCode.OpCode[ 6];
				BinaryInst[i].Instruction[ 7] = Instructions[i].Imm.Bin.Sl   [ 0];
				BinaryInst[i].Instruction[ 8] = Instructions[i].Imm.Bin.Sl   [ 1];
				BinaryInst[i].Instruction[ 9] = Instructions[i].Imm.Bin.Sl   [ 2];
				BinaryInst[i].Instruction[10] = Instructions[i].Imm.Bin.Sl   [ 3];
				BinaryInst[i].Instruction[11] = Instructions[i].Imm.Bin.Sl   [ 4];
				BinaryInst[i].Instruction[12] = Instructions[i].OpCode.Funct3[ 0];
				BinaryInst[i].Instruction[13] = Instructions[i].OpCode.Funct3[ 1];
				BinaryInst[i].Instruction[14] = Instructions[i].OpCode.Funct3[ 2];
				BinaryInst[i].Instruction[15] = Instructions[i].Rs1   .Bin   [ 0];
				BinaryInst[i].Instruction[16] = Instructions[i].Rs1   .Bin   [ 1];
				BinaryInst[i].Instruction[17] = Instructions[i].Rs1   .Bin   [ 2];
				BinaryInst[i].Instruction[18] = Instructions[i].Rs1   .Bin   [ 3];
				BinaryInst[i].Instruction[19] = Instructions[i].Rs1   .Bin   [ 4];
				BinaryInst[i].Instruction[20] = Instructions[i].Rs2   .Bin   [ 0];
				BinaryInst[i].Instruction[21] = Instructions[i].Rs2   .Bin   [ 1];
				BinaryInst[i].Instruction[22] = Instructions[i].Rs2   .Bin   [ 2];
				BinaryInst[i].Instruction[23] = Instructions[i].Rs2   .Bin   [ 3];
				BinaryInst[i].Instruction[24] = Instructions[i].Rs2   .Bin   [ 4];
				BinaryInst[i].Instruction[25] = Instructions[i].Imm.Bin.Sh   [ 0];
				BinaryInst[i].Instruction[26] = Instructions[i].Imm.Bin.Sh   [ 1];
				BinaryInst[i].Instruction[27] = Instructions[i].Imm.Bin.Sh   [ 2];
				BinaryInst[i].Instruction[28] = Instructions[i].Imm.Bin.Sh   [ 3];
				BinaryInst[i].Instruction[29] = Instructions[i].Imm.Bin.Sh   [ 4];
				BinaryInst[i].Instruction[30] = Instructions[i].Imm.Bin.Sh   [ 5];
				BinaryInst[i].Instruction[31] = Instructions[i].Imm.Bin.Sh   [ 6];
				break;
			}
			case ClassReturn:
			{
				BinaryInst[i].Instruction[ 0] = Instructions[i].OpCode.OpCode[ 0];
				BinaryInst[i].Instruction[ 1] = Instructions[i].OpCode.OpCode[ 1];
				BinaryInst[i].Instruction[ 2] = Instructions[i].OpCode.OpCode[ 2];
				BinaryInst[i].Instruction[ 3] = Instructions[i].OpCode.OpCode[ 3];
				BinaryInst[i].Instruction[ 4] = Instructions[i].OpCode.OpCode[ 4];
				BinaryInst[i].Instruction[ 5] = Instructions[i].OpCode.OpCode[ 5];
				BinaryInst[i].Instruction[ 6] = Instructions[i].OpCode.OpCode[ 6];
				BinaryInst[i].Instruction[ 7] =                               '0';
				BinaryInst[i].Instruction[ 8] =                               '0';
				BinaryInst[i].Instruction[ 9] =                               '0';
				BinaryInst[i].Instruction[10] =                               '0';
				BinaryInst[i].Instruction[11] =                               '0';
				BinaryInst[i].Instruction[12] = Instructions[i].OpCode.Funct3[ 0];
				BinaryInst[i].Instruction[13] = Instructions[i].OpCode.Funct3[ 1];
				BinaryInst[i].Instruction[14] = Instructions[i].OpCode.Funct3[ 2];
				BinaryInst[i].Instruction[15] =                               '0';
				BinaryInst[i].Instruction[16] =                               '0';
				BinaryInst[i].Instruction[17] =                               '0';
				BinaryInst[i].Instruction[18] =                               '0';
				BinaryInst[i].Instruction[19] =                               '0';
				BinaryInst[i].Instruction[20] =                               '0';
				BinaryInst[i].Instruction[21] =                               '1';
				BinaryInst[i].Instruction[22] =                               '0';
				BinaryInst[i].Instruction[23] =                               '0';
				BinaryInst[i].Instruction[24] =                               '0';
				BinaryInst[i].Instruction[25] = Instructions[i].OpCode.Funct7[ 0];
				BinaryInst[i].Instruction[26] = Instructions[i].OpCode.Funct7[ 1];
				BinaryInst[i].Instruction[27] = Instructions[i].OpCode.Funct7[ 2];
				BinaryInst[i].Instruction[28] = Instructions[i].OpCode.Funct7[ 3];
				BinaryInst[i].Instruction[29] = Instructions[i].OpCode.Funct7[ 4];
				BinaryInst[i].Instruction[30] = Instructions[i].OpCode.Funct7[ 5];
				BinaryInst[i].Instruction[31] = Instructions[i].OpCode.Funct7[ 6];
				break;
			}
			default:
			{
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("Error, Instruction type  not found, verify compilation comments . . . \n\n");
				printf("       Instruction %u : ",i);
				PrintInstructionName(Counter, Instructions, i);
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("\n");
				printf("       Type : %u",Instructions[i].Imm.Class);
				RstColor();
				Pause();
				Cls();
				return 0;
			}
		}
		for(j = 0; j < 31; j++)
		{
			if((BinaryInst[i].Instruction[j] != '0') && (BinaryInst[i].Instruction[j] != '1'))
			{
				char Error = BinaryInst[i].Instruction[j];
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("Error: Instruction contains values different than 0 or 1 . . . \n\n");
				printf("       Instruction %u : ",i);
				PrintInstructionName(Counter, Instructions, i);
				SetPrintColor(RED_COLOR, NO_STYLE);
				printf("\n");
				printf("       Wrong Value    : [%c - %u] \n",Error,Error);
				printf("       Bit Number     : %u \n",j);
				RstColor();
				Pause();
				Cls();
				return 0;
			}
		}
		////////// Solve addresses
		if(Instructions[i].Segment == ActSegment)
		{
			BinaryInst[i].Address = ActAddress;
			ActAddress ++;
		}
		else
		{
			ActSegment ++;
			ActAddress = Address[ActSegment].Value;
			BinaryInst[i].Address = ActAddress;
			ActAddress ++;
		}
	}
	return 1;
}

char ExportCode  (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ],
				  uint      MemorySize                                               )
{
	int Selector;
	printf("Select output format: \n");
	printf("1. CSV      (comma-separated values                          )\n");
	printf("2. VHDL ROM (Hardware description language - Read only memory)\n");
	printf("3. MIF      (Memory initialization file                      )\n");
	scanf ("%d",&Selector);
	Cls();
	OpenBinaryOutputFile(Selector);
	switch(Selector)
	{
		case 1:
		{
			ExportCsv (Counter,BinaryInst);
			break;
		}
		case 2:
		{
			ExportVhdl(Counter,BinaryInst);
			break;
		}
		case 3:
		{
			ExportMif (Counter,BinaryInst,MemorySize);
			break;
		}
		default:
		{
			ExportCsv(Counter,BinaryInst);
		}
	}
	CloseBinaryOutputFile();
	return 1;
}

void ExportCsv  (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ])
{
	int i;
	int j;
	for(i = 0; i < Counter->Code; i++)
	{
		fprintf(BinaryOutputFile,"0d%010u",BinaryInst[i].Address);
		printf (                 "0d%010u",BinaryInst[i].Address);
		fprintf(BinaryOutputFile,"	");
		printf (                 "	");
		for(j = 31; j >= 0; j--)
		{
			fprintf(BinaryOutputFile,"%c",BinaryInst[i].Instruction[j]);
			printf (                 "%c",BinaryInst[i].Instruction[j]);
		}
		fprintf(BinaryOutputFile,"\n");
		printf (                 "\n");
	}
}

void ExportVhdl (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ])
{
	int i = 0;
	int j = 0;
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"--                              Ivan Ricardo Diaz Gamarra                               --\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"--  Project:                                                                            --\n");
	fprintf(BinaryOutputFile,"--  Date:                                                                               --\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"--                                                                                      --\n");
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"LIBRARY IEEE;\n"                                                                             );
	fprintf(BinaryOutputFile,"USE IEEE.STD_LOGIC_1164.ALL;\n"                                                              );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"USE WORK.BasicPackage.ALL;\n"                                                                );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"ENTITY MainMemoryTestbench IS\n"                                                             );
	fprintf(BinaryOutputFile,"    \n"                                                                                      );
	fprintf(BinaryOutputFile,"    PORT   (DataRd     : IN  uint32;\n"                                                      );
	fprintf(BinaryOutputFile,"            Address    : IN  uint32;\n"                                                      );
	fprintf(BinaryOutputFile,"            RdWrEnable : IN  uint02;\n"                                                      );
	fprintf(BinaryOutputFile,"            DataWr     : OUT uint32 \n"                                                      );
	fprintf(BinaryOutputFile,"           );\n"                                                                             );
	fprintf(BinaryOutputFile,"    \n"                                                                                      );
	fprintf(BinaryOutputFile,"END ENTITY MainMemoryTestbench;\n"                                                           );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"ARCHITECTURE TbArch OF MainMemoryTestbench IS\n"                                             );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"SIGNAL Tmp : uint32;\n"                                                                      );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"BEGIN\n"                                                                                     );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"------------------------------------------------------------\n"                              );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"------------------------------------------------------------\n"                              );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"WITH RdWrEnable SELECT\n"                                                                    );
	fprintf(BinaryOutputFile,"DataWr <= Tmp         WHEN "                                                                 );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,"10"                                                                                          );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,",\n"                                                                                         );
	fprintf(BinaryOutputFile,"          Tmp         WHEN "                                                                 );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,"11"                                                                                          );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,",\n"                                                                                         );
	fprintf(BinaryOutputFile,"          x"                                                                                 );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,"FFFFFFFF"                                                                                    );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile," WHEN OTHERS;\n"                                                                             );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"WITH Address SELECT\n"                                                                       );
	fprintf(BinaryOutputFile,"Tmp    <= "                                                                                  );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "--                              Ivan Ricardo Diaz Gamarra                               --\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "--  Project:                                                                            --\n");
	printf (                 "--  Date:                                                                               --\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "--                                                                                      --\n");
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "\n"                                                                                          );
	printf (                 "LIBRARY IEEE;\n"                                                                             );
	printf (                 "USE IEEE.STD_LOGIC_1164.ALL;\n"                                                              );
	printf (                 "\n"                                                                                          );
	printf (                 "USE WORK.BasicPackage.ALL;\n"                                                                );
	printf (                 "\n"                                                                                          );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "\n"                                                                                          );
	printf (                 "ENTITY MainMemoryTestbench IS\n"                                                             );
	printf (                 "    \n"                                                                                      );
	printf (                 "    PORT   (DataRd     : IN  uint32;\n"                                                      );
	printf (                 "            Address    : IN  uint32;\n"                                                      );
	printf (                 "            RdWrEnable : IN  uint02;\n"                                                      );
	printf (                 "            DataWr     : OUT uint32 \n"                                                      );
	printf (                 "           );\n"                                                                             );
	printf (                 "    \n"                                                                                      );
	printf (                 "END ENTITY MainMemoryTestbench;\n"                                                           );
	printf (                 "\n"                                                                                          );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "\n"                                                                                          );
	printf (                 "ARCHITECTURE TbArch OF MainMemoryTestbench IS\n"                                             );
	printf (                 "\n"                                                                                          );
	printf (                 "SIGNAL Tmp : uint32;\n"                                                                      );
	printf (                 "\n"                                                                                          );
	printf (                 "BEGIN\n"                                                                                     );
	printf (                 "\n"                                                                                          );
	printf (                 "------------------------------------------------------------\n"                              );
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- \n"                                                                                       );
	printf (                 "------------------------------------------------------------\n"                              );
	printf (                 "\n"                                                                                          );
	printf (                 "WITH RdWrEnable SELECT\n"                                                                    );
	printf (                 "DataWr <= Tmp         WHEN "                                                                 );
	printf (                 "%c",0x22                                                                                     );
	printf (                 "10"                                                                                          );
	printf (                 "%c",0x22                                                                                     );
	printf (                 ",\n"                                                                                         );
	printf (                 "          Tmp         WHEN "                                                                 );
	printf (                 "%c",0x22                                                                                     );
	printf (                 "11"                                                                                          );
	printf (                 "%c",0x22                                                                                     );
	printf (                 ",\n"                                                                                         );
	printf (                 "          x"                                                                                 );
	printf (                 "%c",0x22                                                                                     );
	printf (                 "FFFFFFFF"                                                                                    );
	printf (                 "%c",0x22                                                                                     );
	printf (                 " WHEN OTHERS;\n"                                                                             );
	printf (                 "\n"                                                                                          );
	printf (                 "WITH Address SELECT\n"                                                                       );
	printf (                 "Tmp    <= "                                                                                  );
	printf (                 "%c",0x22                                                                                     );
	for(j = 31; j >= 0; j--)
	{
		fprintf(BinaryOutputFile,"%c",BinaryInst[i].Instruction[j]                                                         );
		printf (                 "%c",BinaryInst[i].Instruction[j]                                                         );
	}
	fprintf(BinaryOutputFile,"%c WHEN (Int2Slv(%03u,32)),\n",0x22,BinaryInst[i].Address                                    );
	printf (                 "%c WHEN (Int2Slv(%03u,32)),\n",0x22,BinaryInst[i].Address                                    );
	for(i = 0; i < Counter->Code; i++)
	{
		printf (                 "          "                                                                              );
		printf (                 "%c",0x22                                                                                 );
		fprintf(BinaryOutputFile,"          "                                                                              );
		fprintf(BinaryOutputFile,"%c",0x22                                                                                 );
		for(j = 31; j >= 0; j--)
		{
			printf (                 "%c",BinaryInst[i].Instruction[j]                                                     );
			fprintf(BinaryOutputFile,"%c",BinaryInst[i].Instruction[j]                                                     );
		}
		printf (                 "%c WHEN (Int2Slv(%03u,32)),\n",0x22,BinaryInst[i].Address                                );
		fprintf(BinaryOutputFile,"%c WHEN (Int2Slv(%03u,32)),\n",0x22,BinaryInst[i].Address                                );
	}
	printf (                 "          "                                                                                  );
	printf (                 "%c",0x22                                                                                     );
	printf (                 "11111111111111111111111111111111"                                                            );
	printf (                 "%c WHEN OTHERS;\n",0x22                                                                      );
	printf (                 "END TbArch;\n"                                                                               );
	printf (                 "\n"                                                                                          );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "-- \n"                                                                                       );
	printf (                 "-- Summon This Block:\n"                                                                     );
	printf (                 "-- \n"                                                                                       );
	printf (                 "------------------------------------------------------------------------------------------\n");
	printf (                 "--BlockN: ENTITY WORK.MainMemoryTestbench(TbArch)\n"                                         );
	printf (                 "--PORT MAP   (DataRd     => SLV,\n"                                                          );
	printf (                 "--            Address    => SLV,\n"                                                          );
	printf (                 "--            RdWrEnable => SLV,\n"                                                          );
	printf (                 "--            DataWr     => SLV\n"                                                           );
	printf (                 "--           );\n"                                                                           );
	printf (                 "------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"          "                                                                                  );
	fprintf(BinaryOutputFile,"%c",0x22                                                                                     );
	fprintf(BinaryOutputFile,"11111111111111111111111111111111"                                                            );
	fprintf(BinaryOutputFile,"%c WHEN OTHERS;\n",0x22                                                                      );
	fprintf(BinaryOutputFile,"END TbArch;\n"                                                                               );
	fprintf(BinaryOutputFile,"\n"                                                                                          );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"-- Summon This Block:\n"                                                                     );
	fprintf(BinaryOutputFile,"-- \n"                                                                                       );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
	fprintf(BinaryOutputFile,"--BlockN: ENTITY WORK.MainMemoryTestbench(TbArch)\n"                                         );
	fprintf(BinaryOutputFile,"--PORT MAP   (DataRd     => SLV,\n"                                                          );
	fprintf(BinaryOutputFile,"--            Address    => SLV,\n"                                                          );
	fprintf(BinaryOutputFile,"--            RdWrEnable => SLV,\n"                                                          );
	fprintf(BinaryOutputFile,"--            DataWr     => SLV\n"                                                           );
	fprintf(BinaryOutputFile,"--           );\n"                                                                           );
	fprintf(BinaryOutputFile,"------------------------------------------------------------------------------------------\n");
}


void ExportMif   (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ],
				  uint      MemorySize                                               )
{
	uint Depth        = MemorySize;
	uint FinalAddress = BinaryInst[Counter->Code - 1].Address;
	int  i;
	int  j;
	int PrevAddress = 0;
	printf (                 "-- ArkI Assembler ganarated Memory Initialization File (.mif)\n");
	printf (                 "\n"                                                             );
	printf (                 "WIDTH = 32;\n"                                                  );
	printf (                 "DEPTH = %u;\n",Depth                                            );
	printf (                 "\n"                                                             );
	printf (                 "ADDRESS_RADIX = UNS;\n"                                         );
	printf (                 "DATA_RADIX = BIN;\n"                                            );
	printf (                 "\n"                                                             );
	printf (                 "CONTENT BEGIN"                                                  );
	fprintf(BinaryOutputFile,"-- ArkI Assembler ganarated Memory Initialization File (.mif)\n");
	fprintf(BinaryOutputFile,"\n"                                                             );
	fprintf(BinaryOutputFile,"WIDTH = 32;\n"                                                  );
	fprintf(BinaryOutputFile,"DEPTH = %u;\n",Depth                                            );
	fprintf(BinaryOutputFile,"\n"                                                             );
	fprintf(BinaryOutputFile,"ADDRESS_RADIX = UNS;\n"                                         );
	fprintf(BinaryOutputFile,"DATA_RADIX = BIN;\n"                                            );
	fprintf(BinaryOutputFile,"\n"                                                             );
	fprintf(BinaryOutputFile,"CONTENT BEGIN"                                                  );
	for(i = 0; i < Counter->Code; i++)
	{
		if(BinaryInst[i].Address <= (PrevAddress + 1))
		{
			printf (                 "\n"                                                     );
			printf (                 "%u : ",BinaryInst[i].Address                            );
			fprintf(BinaryOutputFile,"\n"                                                     );
			fprintf(BinaryOutputFile,"%u : ",BinaryInst[i].Address                            );
			PrevAddress = BinaryInst[i].Address;
		}
		else
		{
			printf (                 "\n"                                                     );
			printf (                 "[%u..%u] : ",PrevAddress + 1,BinaryInst[i].Address - 1  );
			printf (                 "00000000000000000000000000000000;\n"                    );
			printf (                 "%u : ",BinaryInst[i].Address                            );
			fprintf(BinaryOutputFile,"\n"                                                     );
			fprintf(BinaryOutputFile,"[%u..%u] : ",PrevAddress + 1,BinaryInst[i].Address - 1  );
			fprintf(BinaryOutputFile,"00000000000000000000000000000000;\n"                    );
			fprintf(BinaryOutputFile,"%u : ",BinaryInst[i].Address                            );
			PrevAddress = BinaryInst[i].Address;
		}
		for(j = 31; j >= 0; j--)
		{
			printf (                 "%c",BinaryInst[i].Instruction[j]                        );
			fprintf(BinaryOutputFile,"%c",BinaryInst[i].Instruction[j]                        );
		}
		printf (                 ";"                                                          );
		fprintf(BinaryOutputFile,";"                                                          );
	}
	printf (                 "\n"                                                             );
	fprintf(BinaryOutputFile,"\n"                                                             );
	if((FinalAddress + 1) < (MemorySize - 1))
	{
		printf (                 "[%u..%u] : ",FinalAddress + 1, MemorySize - 1               );
		fprintf(BinaryOutputFile,"[%u..%u] : ",FinalAddress + 1, MemorySize - 1               );
		printf (                 "00000000000000000000000000000000;\n"                        );
		fprintf(BinaryOutputFile,"00000000000000000000000000000000;\n"                        );
	}
	printf (                 "END;"                                                           );
	printf (                 "\n"                                                             );
	printf (                 "\n"                                                             );
	fprintf(BinaryOutputFile,"END;"                                                           );
}



#include "FileManagment.h"

uint OpenAsmCodeFile()
{
	/***************************************************************************
	**
	** Open the Text file containing the assembler code
	**
	***************************************************************************/

	AsmCodeFile = fopen("AsmCode.asm","r");
	if(AsmCodeFile == NULL)
	{
		SetPrintColor(RED_COLOR, UNDERLINE_STYLE);
		printf("Error: could not open Assembler Code File \n");
		Pause();
		return 1;
	}
	return 0;
}


void CloseAsmCodeFile()
{
	fclose(AsmCodeFile);
}

uint OpenBinaryOutputFile(char Type)
{
	/***************************************************************************
	**
	** Open the Text file indicated by the FileId
	**
	***************************************************************************/

	switch(Type)
	{
		case 1:
		{
			BinaryOutputFile = fopen("BinaryOuput.csv","w");
			break;
		}
		case 2:
		{
			BinaryOutputFile = fopen("BinaryOuput.vhd","w");
			break;
		}
		case 3:
		{
			BinaryOutputFile = fopen("BinaryOuput.mif","w");
			break;
		}
		default:
		{
			BinaryOutputFile = fopen("BinaryOuput.arki","w");
		}
	}
	if(BinaryOutputFile == NULL)
	{
		SetPrintColor(RED_COLOR, UNDERLINE_STYLE);
		printf("Error: could not open Binary Output File \n");
		Pause();
		return 1;
	}
	return 0;
}

void CloseBinaryOutputFile()
{
	fclose(BinaryOutputFile);
}

#ifndef SRC_GLOBAL_H_
#define SRC_GLOBAL_H_

#include <stdlib.h>
#include <stdio.h>
#include "InstructionId.h"

FILE *AsmCodeFile;
FILE *BinaryOutputFile;

typedef unsigned int  uint ;

typedef unsigned char uchar;

typedef struct CounterS CounterT;
struct CounterS
{
	uint Code    ;
	uint Address ;
	uint Lines   ;
};

typedef struct OpCodeS OpCodeT;
struct OpCodeS
{
	char OpCode[7];
	char Funct3[3];
	char Funct7[7];
};

typedef struct Binary5S Binary5T;
struct Binary5S
{
	uint Val   ;
	char Bin[5];
	char Dec[2];
	char Hex[2];
};

typedef struct ImmBinaryS ImmBinaryT;
struct ImmBinaryS
{
	char U [20];
	char I [12];
	char Sh[ 7];
	char Sl[ 5];
};

typedef struct ImmediateS ImmediateT;
struct ImmediateS
{
	ImmBinaryT Bin     ;
	uint       Value   ;
	uint       ConstId ;
	ImmClassT  Class   ; // U I S
};

typedef struct InstructionS InstructionT;
struct InstructionS
{
	InstIdT    Instruction  ;
	OpCodeT    OpCode       ;
	Binary5T   Rd           ;
	Binary5T   Rs1          ;
	Binary5T   Rs2          ;
	ImmediateT Imm          ;
	uchar      Segment      ;
};

typedef struct AddressS AddressT;
struct AddressS
{
	char Name[50];
	int  Value   ;
	int  NoInst  ;
};

typedef struct BinaryInstS BinaryInstT;
struct BinaryInstS
{
	char Instruction[32];
	uint Address        ;
};

#define ShowCounterValues 0x01
#define ShowInstructions  0x02
#define ShowAddress       0x04
#define ShowAssembly      0x08

char Verbose;

#endif /* SRC_GLOBAL_H_ */

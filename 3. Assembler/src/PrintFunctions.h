#ifndef PRINTFUNCTIONS_H_
#define PRINTFUNCTIONS_H_

#include "Util.h"

void  PrintInstructions     (CounterT *Counter, InstructionT Instructions[Counter->Code]         );
void  PrintInstructionName  (CounterT *Counter, InstructionT Instructions[Counter->Code], int Pos);

void  PrintAddresses        (CounterT *Counter, AddressT     Address     [Counter->Address]      );

uchar GetNumOfDigits        (uint Number                                                         );
void  PrintLineNumber       (uint Line        , uint         MaxLines                            );
void  PrintLineNumberOnCode (uint Line        , uint         MaxLines                            );

void PrintAssembly          (CounterT *Counter, BinaryInstT  BinaryInst  [Counter->Code]          ,
                                                InstructionT Instructions[Counter->Code]         );

#endif /* PRINTFUNCTIONS_H_ */

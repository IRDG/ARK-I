#ifndef CODEPROCESSING_H_
#define CODEPROCESSING_H_

#include "Util.h"
#include "FileManagment.h"
#include "PrintFunctions.h"

#include "EnumeratedItems.h"

#define  IsSpace(X)    ((X == ' ') || (X == '	') || (X == 0x09))
#define  IsNextLine(X)  (X == 0x0A)
#define  IsAddress(X)  ((X == '&') || (X == '*'))
#define  IsComment(X)   (X == '@')

char IsLetter             (char Character                                                                     );
void GetCodeLines         (CounterT *Counter                                                                  );
char GetCode              (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           char      SliceSice                 , AddressT      Address     [Counter->Address ] ,
                           uint     *MaxAddress                                                               );
void EmptyInstructionArray(CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           AddressT  Address[Counter->Address ]                                               );

char GetData              (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           AddressT  Address[Counter->Address ]                                               );

RdSt GetInstruction       (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           char      PrevChar                  , char          NextChar                        ,
                           uint      i                         , uint         *Line                           );
StT1 InstTier1            (char      NextChar                                                                 );
StT2 InstTier2            (char      NextChar                  , StT1          PrevState                      );
StT3 InstTier3            (char      NextChar                  , StT2          PrevState                      );
StT4 InstTier4            (char      NextChar                  , StT3          PrevState                       ,
                           char      PrevChar                                                                 );
StT5 InstTier5            (char      NextChar                  , StT4          PrevState                      );
StT6 InstTier6            (char      NextChar                  , StT5          PrevState                      );
StT7 InstTier7            (char      NextChar                  , StT6          PrevState                      );

RdSt GetArgument1         (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           char      PrevChar                  , char          NextChar                        ,
                           uint      i                         , char         *PreventRead                    );

RdSt GetArgument2         (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           char      PrevChar                  , char          NextChar                        ,
                           uint      i                         , char         *PreventRead                    );

RdSt GetArgument3         (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ] ,
                           char      PrevChar                  , char          NextChar                        ,
                           uint      i                         , uint         *Line                            ,
                           char     *PreventRead                                                              );

RdSt GetAddress           (CounterT *Counter                   , AddressT     *TmpAddress                      ,
                           char      PrevChar                  , char          NextChar                        ,
                           uint     *Line                      ,char          *PreventRead                    );

void AssignOpCodes        (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ]);
void BinaryConversion     (CounterT *Counter                   , InstructionT  Instructions[Counter->Code    ]);
void Dec2Bin              (uint      Num                       , char          Size                            ,
                           char      Bin    [Size]                                                            );

uint CreateAddressValues  (CounterT *Counter                   , AddressT      Address     [Counter->Address ] ,
                           char      SliceSize                                                                );

#endif /* CODEPROCESSING_H_ */

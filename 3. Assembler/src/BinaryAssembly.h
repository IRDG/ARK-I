/*
 * BinaryAssembly.h
 *
 *  Created on: Feb 13, 2024
 *      Author: etria
 */

#ifndef BINARYASSEMBLY_H_
#define BINARYASSEMBLY_H_

#include "Util.h"
#include "PrintFunctions.h"
#include "FileManagment.h"

char AssembleCode(CounterT *Counter   , InstructionT  Instructions[Counter->Code    ] ,
                  char      SliceSice , AddressT      Address     [Counter->Address ] ,
                  uint      MaxAddress, BinaryInstT   BinaryInst  [Counter->Code    ]);

char AssembleInst(CounterT *Counter   , InstructionT  Instructions[Counter->Code    ] ,
                  char      SliceSice , AddressT      Address     [Counter->Address ] ,
                  uint      MaxAddress, BinaryInstT   BinaryInst  [Counter->Code    ]);

char ExportCode  (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ],
				  uint      MemorySize                                               );
void ExportCsv   (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ]);
void ExportVhdl  (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ]);
void ExportMif   (CounterT *Counter   , BinaryInstT   BinaryInst  [Counter->Code    ],
				  uint      MemorySize                                               );

#endif /* BINARYASSEMBLY_H_ */

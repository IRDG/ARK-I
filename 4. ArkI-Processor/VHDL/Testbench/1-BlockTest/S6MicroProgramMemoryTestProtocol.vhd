LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

USE WORK.BasicPackage.ALL;

ENTITY S6MicroProgramMemoryTestProtocol IS
END S6MicroProgramMemoryTestProtocol;

ARCHITECTURE S6MicroProgramMemoryTestProtocolArch OF S6MicroProgramMemoryTestProtocol IS

SIGNAL OpCode           : STD_LOGIC_VECTOR( 6 DOWNTO 0);
SIGNAL Funct3           : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL Funct7           : STD_LOGIC_VECTOR( 6 DOWNTO 0);

SIGNAL ControlWord      : ControlWordDecode            ;
SIGNAL ImmSext          : STD_LOGIC                    ;
SIGNAL Format           : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL AluOperation     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL AluSource        : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL CsrOperation     : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL MdrOperation     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL WbDataSrc        : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL GprWrEna         : STD_LOGIC                    ;

SIGNAL UnknownInst      : STD_LOGIC                    ;
SIGNAL BranchType       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL GprUsed          : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempImmSext      : STD_LOGIC                    ;
SIGNAL TempFormat       : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempAluOperation : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempAluSource    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempCsrOperation : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempMdrOperation : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempWbDataSrc    : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempGprWrEna     : STD_LOGIC                    ;
SIGNAL TempUnknownInst  : STD_LOGIC                    ;
SIGNAL TempBranchType   : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempGprUsed      : STD_LOGIC_VECTOR( 2 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.MicroProgramMemory(MainArch)
PORT MAP   (OpCode      => OpCode     ,
            Funct3      => Funct3     ,
            Funct7      => Funct7     ,
            ControlWord => ControlWord,
            UnknownInst => UnknownInst,
            BranchType  => BranchType ,
            GprUsed     => GprUsed     
           );

ImmSext          <= ControlWord.DecStage.ImmSext     ;
Format           <= ControlWord.DecStage.Format      ;
AluOperation     <= ControlWord.AluStage.AluOperation;
AluSource        <= ControlWord.AluStage.AluSource   ;
CsrOperation     <= ControlWord.AluStage.CsrOperation;
MdrOperation     <= ControlWord.MStage  .MdrOperation;
WbDataSrc        <= ControlWord.WbStage .WbDataSrc   ;
GprWrEna         <= ControlWord.WbStage .GprWrEna    ;

TestBench: PROCESS
    
    VARIABLE ReadCol         : LINE                         ;
    VARIABLE WriteCol        : LINE                         ;
    
    VARIABLE ValOpCode       : STD_LOGIC_VECTOR( 6 DOWNTO 0);
    VARIABLE ValFunct3       : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValFunct7       : STD_LOGIC_VECTOR( 6 DOWNTO 0);
    VARIABLE ValImmSext      : STD_LOGIC                    ;
    VARIABLE ValFormat       : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValAluOperation : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValAluSource    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValCsrOperation : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValMdrOperation : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValWbDataSrc    : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValGprWrEna     : STD_LOGIC                    ;
    VARIABLE ValUnknownInst  : STD_LOGIC                    ;
    VARIABLE ValBranchType   : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValGprUsed      : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValComma        : CHARACTER                    ;
    VARIABLE GoodNum         : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S6MicroProgramMemoryTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S6MicroProgramMemoryTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#OpCode       ,Funct3       ,Funct7       ,ImmSext      ,Format       ,AluOperation ,AluSource    ,CsrOperation ,MdrOperation ,WbDataSrc    ,GprWrEna     ,UnknownInst  ,BranchType   ,GprUsed      ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        READ    (ReadCol, ValOpCode       , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValFunct3       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Funct3";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValFunct7       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Funct7";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValImmSext               );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValFormat                );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValAluOperation          );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValAluSource             );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValCsrOperation          );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValMdrOperation          );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValWbDataSrc             );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValGprWrEna              );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValUnknownInst           );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValBranchType            );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValGprUsed               );
        
        OpCode           <= ValOpCode       ;
        Funct3           <= ValFunct3       ;
        Funct7           <= ValFunct7       ;
        TempImmSext      <= ValImmSext      ;
        TempFormat       <= ValFormat       ;
        TempAluOperation <= ValAluOperation ;
        TempAluSource    <= ValAluSource    ;
        TempCsrOperation <= ValCsrOperation ;
        TempMdrOperation <= ValMdrOperation ;
        TempWbDataSrc    <= ValWbDataSrc    ;
        TempGprWrEna     <= ValGprWrEna     ;
        TempUnknownInst  <= ValUnknownInst  ;
        TempBranchType   <= ValBranchType   ;
        TempGprUsed      <= ValGprUsed      ;
        
--        ImmSext          <= ControlWord.DecStage.ImmSext     ;
--        Format           <= ControlWord.DecStage.Format      ;
--        AluOperation     <= ControlWord.AluStage.AluOperation;
--        AluSource        <= ControlWord.AluStage.AluSource   ;
--        CsrOperation     <= ControlWord.AluStage.CsrOperation;
--        MdrOperation     <= ControlWord.MStage.MdrOperation  ;
--        WbDataSrc        <= ControlWord.WbStage.WbDataSrc    ;
--        GprWrEna         <= ControlWord.WbStage.GprWrEna     ;

        WAIT FOR 20 ns;
        
        WRITE (WriteCol, OpCode       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Funct3       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Funct7       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, ImmSext      );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Format       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, AluOperation );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, AluSource    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, CsrOperation );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, MdrOperation );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, WbDataSrc    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, GprWrEna     );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, UnknownInst  );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, BranchType   );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, GprUsed      );
        WRITE (WriteCol, STRING'(",") );
        
        IF(TempImmSext /= ImmSext) THEN
            
            WRITE (WriteCol, STRING'("ImmSext ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ImmSext OK   ,"));
            
        END IF;
        
        IF(TempFormat /= Format) THEN
            
            WRITE (WriteCol, STRING'("Format ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Format OK   ,"));
            
        END IF;
        
        IF(TempAluOperation /= AluOperation) THEN
            
            WRITE (WriteCol, STRING'("AluOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluOperation OK   ,"));
            
        END IF;
        
        IF(TempAluSource /= AluSource) THEN
            
            WRITE (WriteCol, STRING'("AluSource ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluSource OK   ,"));
            
        END IF;
        
        IF(TempCsrOperation /= CsrOperation) THEN
            
            WRITE (WriteCol, STRING'("CsrOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("CsrOperation OK   ,"));
            
        END IF;
        
        IF(TempMdrOperation /= MdrOperation) THEN
            
            WRITE (WriteCol, STRING'("MdrOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("MdrOperation OK   ,"));
            
        END IF;
        
        IF(TempWbDataSrc /= WbDataSrc) THEN
            
            WRITE (WriteCol, STRING'("WbDataSrc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("WbDataSrc OK   ,"));
            
        END IF;
        
        IF(TempGprWrEna /= GprWrEna) THEN
            
            WRITE (WriteCol, STRING'("GprWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprWrEna OK   ,"));
            
        END IF;
        
        IF(TempUnknownInst /= UnknownInst) THEN
            
            WRITE (WriteCol, STRING'("UnknownInst ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("UnknownInst OK   ,"));
            
        END IF;
        
        IF(TempBranchType /= BranchType) THEN
            
            WRITE (WriteCol, STRING'("BranchType ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("BranchType OK   ,"));
            
        END IF;
        
        IF(TempGprUsed /= GprUsed) THEN
            
            WRITE (WriteCol, STRING'("GprUsed ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprUsed OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S6MicroProgramMemoryTestProtocolArch;

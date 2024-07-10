------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Proyect:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                                                                      --
--                                                                                      --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

USE WORK.BasicPackage.ALL;

ENTITY S3AdderSubtractorTestProtocol IS
END S3AdderSubtractorTestProtocol;

ARCHITECTURE S3AdderSubtractorTestProtocolArch OF S3AdderSubtractorTestProtocol IS

SIGNAL NumA         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NumB         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Subtract     : STD_LOGIC                    ;
SIGNAL Result       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Overflow     : STD_LOGIC                    ;
SIGNAL TempResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOverflow : STD_LOGIC                    ;

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.AdderSubtractor(MainArch)
GENERIC MAP(Size     => 32
           )
PORT MAP   (NumA     => NumA    ,
            NumB     => NumB    ,
            Subtract => Subtract,
            Result   => Result  ,
            Overflow => Overflow 
           );

TestBench: PROCESS
    
    VARIABLE ReadCol     : LINE                         ;
    VARIABLE WriteCol    : LINE                         ;
    
    VARIABLE ValNumA     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNumB     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValSubtract : STD_LOGIC                    ;
    VARIABLE ValResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOverflow : STD_LOGIC                    ;
    VARIABLE ValComma    : CHARACTER                    ;
    VARIABLE GoodNum     : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AdderSubtractorTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AdderSubtractorTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#NumA     ,NumB     ,Subtract ,Result   ,Overflow ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValNumA     , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValNumB     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to NumB";
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValSubtract , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Subtract";
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValResult            );
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValOverflow          );
        
        
        NumA         <= ValNumA     ;
        NumB         <= ValNumB     ;
        Subtract     <= ValSubtract ;
        TempResult   <= ValResult   ;
        TempOverflow <= ValOverflow ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, NumA        );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, NumB        );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Subtract    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Result      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Overflow    );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempResult /= Result) THEN
            
            WRITE (WriteCol, STRING'("Result ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Result OK   ,"));
            
        END IF;
        
        IF(TempOverflow /= Overflow) THEN
            
            WRITE (WriteCol, STRING'("Overflow ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Overflow OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S3AdderSubtractorTestProtocolArch;

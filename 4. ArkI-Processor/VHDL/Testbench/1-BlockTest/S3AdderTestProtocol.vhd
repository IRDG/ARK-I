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

ENTITY S3AdderTestProtocol IS
END S3AdderTestProtocol;

ARCHITECTURE S3AdderTestProtocolArch OF S3AdderTestProtocol IS

SIGNAL NumA         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NumB         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CarryIn      : STD_LOGIC                    ;
SIGNAL Result       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CarryOut     : STD_LOGIC                    ;
SIGNAL TempResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempCarryOut : STD_LOGIC                    ;

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.Adder(CarryLookAhead)
PORT MAP   (NumA     => NumA    ,
            NumB     => NumB    ,
            CarryIn  => CarryIn ,
            Result   => Result  ,
            CarryOut => CarryOut 
           );

TestBench: PROCESS
    
    VARIABLE ReadCol     : LINE                         ;
    VARIABLE WriteCol    : LINE                         ;
    
    VARIABLE ValNumA     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNumB     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCarryIn  : STD_LOGIC                    ;
    VARIABLE ValResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCarryOut : STD_LOGIC                    ;
    VARIABLE ValComma    : CHARACTER                    ;
    VARIABLE GoodNum     : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AdderTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AdderTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#NumA     ,NumB     ,CarryIn  ,Result   ,CarryOut ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValNumA     , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValNumB     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to NumB";
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValCarryIn  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CarryIn";
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValResult            );
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValCarryOut          );
        
        
        NumA         <= ValNumA     ;
        NumB         <= ValNumB     ;
        CarryIn      <= ValCarryIn  ;
        TempResult   <= ValResult   ;
        TempCarryOut <= ValCarryOut ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, NumA        );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, NumB        );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CarryIn     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Result      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CarryOut    );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempResult /= Result) THEN
            
            WRITE (WriteCol, STRING'("Result ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Result OK   ,"));
            
        END IF;
        
        IF(TempCarryOut /= CarryOut) THEN
            
            WRITE (WriteCol, STRING'("CarryOut ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("CarryOut OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S3AdderTestProtocolArch;

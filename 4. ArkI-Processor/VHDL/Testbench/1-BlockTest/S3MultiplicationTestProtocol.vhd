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

ENTITY S3MultiplicationTestProtocol IS
END S3MultiplicationTestProtocol;

ARCHITECTURE S3MultiplicationTestProtocolArch OF S3MultiplicationTestProtocol IS

SIGNAL A            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ResultL      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ResultH      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Overflow     : STD_LOGIC                    ;
SIGNAL TempResultL  : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempResultH  : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOverflow : STD_LOGIC                    ;

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.Multiplier(FullCombinatory)
PORT MAP  (A        => A       ,
           B        => B       ,
           ResultL  => ResultL ,
           ResultH  => ResultH ,
           Overflow => Overflow 
          );

TestBench: PROCESS
    
    VARIABLE ReadCol     : LINE                         ;
    VARIABLE WriteCol    : LINE                         ;
    
    VARIABLE ValA        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValB        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValResultL  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValResultH  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOverflow : STD_LOGIC                    ;
    VARIABLE ValComma    : CHARACTER                    ;
    VARIABLE GoodNum     : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3MultiplicationTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3MultiplicationTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#A        ,B        ,ResultL  ,ResultH  ,Overflow ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValA        , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValB        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to B";
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValResultL           );
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValResultH           );
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValOverflow          );
        
        A            <= ValA        ;
        B            <= ValB        ;
        TempResultL  <= ValResultL  ;
        TempResultH  <= ValResultH  ;
        TempOverflow <= ValOverflow ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, A           );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, B           );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ResultL     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ResultH     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Overflow    );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempResultL /= ResultL) THEN
            
            WRITE (WriteCol, STRING'("ResultL ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ResultL OK   ,"));
            
        END IF;
        
        IF(TempResultH /= ResultH) THEN
            
            WRITE (WriteCol, STRING'("ResultH ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ResultH OK   ,"));
            
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

END S3MultiplicationTestProtocolArch;


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

ENTITY S2ComparatorTestProtocol IS
END S2ComparatorTestProtocol;

ARCHITECTURE S2ComparatorTestProtocolArch OF S2ComparatorTestProtocol IS

SIGNAL A               : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B               : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Comparisson     : STD_LOGIC_VECTOR( 5 DOWNTO 0);
SIGNAL TempComparisson : STD_LOGIC_VECTOR( 5 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.Comparator(MainArch)
PORT MAP   (A           => A          ,
            B           => B          ,
            Comparisson => Comparisson 
           );

TestBench: PROCESS
    
    VARIABLE ReadCol        : LINE                         ;
    VARIABLE WriteCol       : LINE                         ;
    
    VARIABLE ValA           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValB           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComparisson : STD_LOGIC_VECTOR( 5 DOWNTO 0);
    VARIABLE ValComma       : CHARACTER                    ;
    VARIABLE GoodNum        : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2ComparatorTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2ComparatorTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#A           ,B           ,Comparisson ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValA           , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValB           , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to B";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValComparisson          );
        
        
        A               <= ValA           ;
        B               <= ValB           ;
        TempComparisson <= ValComparisson ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, A           );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, B           );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Comparisson );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempComparisson /= Comparisson) THEN
            
            WRITE (WriteCol, STRING'("Comparisson ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Comparisson OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S2ComparatorTestProtocolArch;

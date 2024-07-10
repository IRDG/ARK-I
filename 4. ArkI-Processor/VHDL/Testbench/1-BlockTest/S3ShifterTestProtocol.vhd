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

ENTITY S3ShifterTestProtocol IS
END S3ShifterTestProtocol;

ARCHITECTURE S3ShifterTestProtocolArch OF S3ShifterTestProtocol IS

SIGNAL Input        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Shamt        : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL ArithRlN     : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL Output       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutput   : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.Shifter(MainArch)
PORT MAP  (Input    => Input   ,
           Shamt    => Shamt   ,
           ArithRlN => ArithRlN,
           Output   => Output   
          );

TestBench: PROCESS
    
    VARIABLE ReadCol     : LINE                         ;
    VARIABLE WriteCol    : LINE                         ;
    
    VARIABLE ValInput    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValShamt    : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValArithRlN : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValOutput   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma    : CHARACTER                    ;
    VARIABLE GoodNum     : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3ShifterTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3ShifterTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#Input    ,Shamt    ,ArithRlN ,Output   ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValInput    , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValShamt    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Shamt";
        
        READ    (ReadCol, ValComma             );
        READ    (ReadCol, ValArithRlN , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ArithRlN";
        
        READ    (ReadCol, ValComma             );
        HREAD   (ReadCol, ValOutput            );
        
        Input        <= ValInput    ;
        Shamt        <= ValShamt    ;
        ArithRlN     <= ValArithRlN ;
        TempOutput   <= ValOutput   ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, Input       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Shamt       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ArithRlN    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Output      );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempOutput /= Output) THEN
            
            WRITE (WriteCol, STRING'("Output ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Output OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S3ShifterTestProtocolArch;

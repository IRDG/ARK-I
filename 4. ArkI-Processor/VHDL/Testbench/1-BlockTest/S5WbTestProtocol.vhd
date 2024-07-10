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

ENTITY S5WbTestProtocol IS
END S5WbTestProtocol;

ARCHITECTURE S5WbTestProtocolArch OF S5WbTestProtocol IS

SIGNAL AluResult     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MemData       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ImmData       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CsrData       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Negative      : STD_LOGIC                    ;
SIGNAL PcNext        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WbDataSrc     : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL WbData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempWbData    : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.WriteBackSelectionBlock(MainArch)
PORT MAP   (AluResult => AluResult,
            MemData   => MemData  ,
            ImmData   => ImmData  ,
            CsrData   => CsrData  ,
            Negative  => Negative ,
            PcNext    => PcNext   ,
            WbDataSrc => WbDataSrc,
            WbData    => WbData    
           );

TestBench: PROCESS
    
    VARIABLE ReadCol      : LINE                         ;
    VARIABLE WriteCol     : LINE                         ;
    
    VARIABLE ValAluResult : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMemData   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValImmData   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCsrData   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNegative  : STD_LOGIC                    ;
    VARIABLE ValPcNext    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValWbDataSrc : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValWbData    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma     : CHARACTER                    ;
    VARIABLE GoodNum      : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S5WbTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S5WbTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#AluResult ,MemData   ,ImmData   ,CsrData   ,Negative  ,PcNext    ,WbDataSrc ,WbData    ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValAluResult , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValMemData   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to MemData";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValImmData   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ImmData";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValCsrData   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CsrData";
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValNegative  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Negative";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValPcNext    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to PcNext";
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValWbDataSrc , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to WbDataSrc";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValWbData             );
        
        
        AluResult     <= ValAluResult ;
        MemData       <= ValMemData   ;
        ImmData       <= ValImmData   ;
        CsrData       <= ValCsrData   ;
        Negative      <= ValNegative  ;
        PcNext        <= ValPcNext    ;
        WbDataSrc     <= ValWbDataSrc ;
        TempWbData    <= ValWbData    ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, AluResult   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, MemData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ImmData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CsrData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Negative    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, PcNext      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WbDataSrc   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WbData      );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempWbData /= WbData) THEN
            
            WRITE (WriteCol, STRING'("WbData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("WbData OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S5WbTestProtocolArch;

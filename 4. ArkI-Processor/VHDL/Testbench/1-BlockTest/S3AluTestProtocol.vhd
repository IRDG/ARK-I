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

ENTITY S3AluTestProtocol IS
END S3AluTestProtocol;

ARCHITECTURE S3AluTestProtocolArch OF S3AluTestProtocol IS

SIGNAL Operation     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL Source        : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL CmpRes        : STD_LOGIC_VECTOR( 5 DOWNTO 0);
SIGNAL Shamt         : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL ImmData       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL GprData1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL GprData2      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Pc            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mtvec         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ExcOp         : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL AluResult     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL AluFlags      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempAluResult : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempAluFlags  : STD_LOGIC_VECTOR( 3 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.ArithmeticLogicUnit(MainArch)
PORT MAP  (Operation => Operation,
           Source    => Source   ,
           CmpRes    => CmpRes   ,
           Shamt     => Shamt    ,
           ImmData   => ImmData  ,
           GprData1  => GprData1 ,
           GprData2  => GprData2 ,
           Pc        => Pc       ,
           Mtvec     => Mtvec    ,
           ExcOp     => ExcOp    ,
           AluResult => AluResult,
           AluFlags  => AluFlags  
          );

TestBench: PROCESS
    
    VARIABLE ReadCol      : LINE                         ;
    VARIABLE WriteCol     : LINE                         ;
    
    VARIABLE ValOperation : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValSource    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValCmpRes    : STD_LOGIC_VECTOR( 5 DOWNTO 0);
    VARIABLE ValShamt     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValImmData   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValGprData1  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValGprData2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValPc        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMtvec     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValExcOp     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValAluResult : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValAluFlags  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValComma     : CHARACTER                    ;
    VARIABLE GoodNum      : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AluTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S3AluTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#Operation ,Source    ,CmpRes    ,Shamt     ,ImmData   ,GprData1  ,GprData2  ,Pc        ,Mtvec     ,ExcOp     ,AluResult ,AluFlags  ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        READ    (ReadCol, ValOperation , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValSource    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Source";
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValCmpRes    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CmpRes";
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValShamt     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Shamt";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValImmData   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ImmData";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValGprData1  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprData1";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValGprData2  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprData2";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValPc        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Pc";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValMtvec     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Mtvec";
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValExcOp     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcOp";
        
        READ    (ReadCol, ValComma              );
        HREAD   (ReadCol, ValAluResult          );
        
        READ    (ReadCol, ValComma              );
        READ    (ReadCol, ValAluFlags           );
        
        Operation     <= ValOperation ;
        Source        <= ValSource    ;
        CmpRes        <= ValCmpRes    ;
        Shamt         <= ValShamt     ;
        ImmData       <= ValImmData   ;
        GprData1      <= ValGprData1  ;
        GprData2      <= ValGprData2  ;
        Pc            <= ValPc        ;
        Mtvec         <= ValMtvec     ;
        ExcOp         <= ValExcOp     ;
        TempAluResult <= ValAluResult ;
        TempAluFlags  <= ValAluFlags  ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, Operation   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Source      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CmpRes      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Shamt       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ImmData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, GprData1    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, GprData2    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Pc          );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Mtvec       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ExcOp       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, AluResult   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, AluFlags    );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempAluResult /= AluResult) THEN
            
            WRITE (WriteCol, STRING'("AluResult ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluResult OK   ,"));
            
        END IF;
        
        IF(TempAluFlags /= AluFlags) THEN
            
            WRITE (WriteCol, STRING'("AluFlags ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluFlags OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S3AluTestProtocolArch;

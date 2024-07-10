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

ENTITY S7BpuTestProtocol IS
END S7BpuTestProtocol;

ARCHITECTURE S7BpuTestProtocolArch OF S7BpuTestProtocol IS

SIGNAL BranchType       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL CmpRes           : STD_LOGIC_VECTOR( 5 DOWNTO 0);
SIGNAL PcPlusImm        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Pc               : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL BpuMode          : STD_LOGIC                    ;
SIGNAL CacheMiss        : STD_LOGIC                    ;
SIGNAL Dependency       : STD_LOGIC                    ;
SIGNAL Rst              : STD_LOGIC                    ;
SIGNAL Clk              : STD_LOGIC                    ;
SIGNAL NewPc            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL EnaLoad          : STD_LOGIC                    ;
SIGNAL ClrPipeline      : STD_LOGIC                    ;
SIGNAL BranchResult     : STD_LOGIC                    ;
SIGNAL TempNewPc        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempEnaLoad      : STD_LOGIC                    ;
SIGNAL TempClrPipeline  : STD_LOGIC                    ;
SIGNAL TempBranchResult : STD_LOGIC                    ;

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.BranchPredictionUnit(MainArch)
PORT MAP   (BranchType   => BranchType  ,
            CmpRes       => CmpRes      ,
            PcPlusImm    => PcPlusImm   ,
            Pc           => Pc          ,
            BpuMode      => BpuMode     ,
            CacheMiss    => CacheMiss   ,
            Dependency   => Dependency  ,
            Rst          => Rst         ,
            Clk          => Clk         ,
            NewPc        => NewPc       ,
            EnaLoad      => EnaLoad     ,
            ClrPipeline  => ClrPipeline ,
            BranchResult => BranchResult 
           );

TestBench: PROCESS
    
    VARIABLE ReadCol         : LINE                         ;
    VARIABLE WriteCol        : LINE                         ;
    
    VARIABLE ValBranchType   : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValCmpRes       : STD_LOGIC_VECTOR( 5 DOWNTO 0);
    VARIABLE ValPcPlusImm    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValPc           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValBpuMode      : STD_LOGIC                    ;
    VARIABLE ValCacheMiss    : STD_LOGIC                    ;
    VARIABLE ValDependency   : STD_LOGIC                    ;
    VARIABLE ValRst          : STD_LOGIC                    ;
    VARIABLE ValClk          : STD_LOGIC                    ;
    VARIABLE ValNewPc        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValEnaLoad      : STD_LOGIC                    ;
    VARIABLE ValClrPipeline  : STD_LOGIC                    ;
    VARIABLE ValBranchResult : STD_LOGIC                    ;
    VARIABLE ValComma        : CHARACTER                    ;
    VARIABLE GoodNum         : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S7BpuTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S7BpuTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#BranchType   ,CmpRes       ,PcPlusImm    ,Pc           ,BpuMode      ,CacheMiss    ,Dependency   ,Rst          ,Clk          ,NewPc        ,EnaLoad      ,ClrPipeline  ,BranchResult ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValBranchType   , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValCmpRes       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CmpRes";
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValPcPlusImm    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to PcPlusImm";
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValPc           , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Pc";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValBpuMode      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to BpuMode";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValCacheMiss    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CacheMiss";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValDependency   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Dependency";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValRst          , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValClk          , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValNewPc                 );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValEnaLoad               );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValClrPipeline           );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValBranchResult          );
        
        
        BranchType       <= ValBranchType   ;
        CmpRes           <= ValCmpRes       ;
        PcPlusImm        <= ValPcPlusImm    ;
        Pc               <= ValPc           ;
        BpuMode          <= ValBpuMode      ;
        CacheMiss        <= ValCacheMiss    ;
        Dependency       <= ValDependency   ;
        Rst              <= ValRst          ;
        Clk              <= ValClk          ;
        TempNewPc        <= ValNewPc        ;
        TempEnaLoad      <= ValEnaLoad      ;
        TempClrPipeline  <= ValClrPipeline  ;
        TempBranchResult <= ValBranchResult ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, BranchType   );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, CmpRes       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, PcPlusImm    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Pc           );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, BpuMode      );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, CacheMiss    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Dependency   );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Rst          );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, Clk          );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, NewPc        );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, EnaLoad      );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, ClrPipeline  );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, BranchResult );
        WRITE (WriteCol, STRING'(",") );
        
        IF(TempNewPc /= NewPc) THEN
            
            WRITE (WriteCol, STRING'("NewPc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("NewPc OK   ,"));
            
        END IF;
        
        IF(TempEnaLoad /= EnaLoad) THEN
            
            WRITE (WriteCol, STRING'("EnaLoad ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("EnaLoad OK   ,"));
            
        END IF;
        
        IF(TempClrPipeline /= ClrPipeline) THEN
            
            WRITE (WriteCol, STRING'("ClrPipeline ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ClrPipeline OK   ,"));
            
        END IF;
        
        IF(TempBranchResult /= BranchResult) THEN
            
            WRITE (WriteCol, STRING'("BranchResult ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("BranchResult OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S7BpuTestProtocolArch;

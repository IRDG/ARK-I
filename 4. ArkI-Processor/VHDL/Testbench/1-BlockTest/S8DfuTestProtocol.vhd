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

ENTITY S8DfuTestProtocol IS
END S8DfuTestProtocol;

ARCHITECTURE S8DfuTestProtocolArch OF S8DfuTestProtocol IS

SIGNAL AluResult          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ImmData            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RdAddress          : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL CsrData            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Negative           : STD_LOGIC                    ;
SIGNAL PcNext             : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL DfuMode            : STD_LOGIC                    ;
SIGNAL CacheMiss          : STD_LOGIC                    ;
SIGNAL GprRsX1            : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL GprRsX2            : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL GprRdX             : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL Inst               : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL Rst                : STD_LOGIC                    ;
SIGNAL Clk                : STD_LOGIC                    ;
SIGNAL DfuWrEna           : STD_LOGIC                    ;
SIGNAL DfuAddress         : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL DfuData            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL EnaPipeline        : STD_LOGIC                    ;
SIGNAL DataDependency     : STD_LOGIC                    ;
SIGNAL TempDfuWrEna       : STD_LOGIC                    ;
SIGNAL TempDfuAddress     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempDfuData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempEnaPipeline    : STD_LOGIC                    ;
SIGNAL TempDataDependency : STD_LOGIC                    ;

SIGNAL DfuDataIn          : DfuInBusT                    ;
SIGNAL DfuDataOut         : DfuOutBusT                   ;

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.DataForwardingUnit(MainArch)
PORT MAP   (DfuDataIn      => DfuDataIn     ,
            DfuMode        => DfuMode       ,
            CacheMiss      => CacheMiss     ,
            GprRsX1        => GprRsX1       ,
            GprRsX2        => GprRsX2       ,
            GprRdX         => GprRdX        ,
            Inst           => Inst          ,
            Rst            => Rst           ,
            Clk            => Clk           ,
            DfuDataOut     => DfuDataOut    ,
            EnaPipeline    => EnaPipeline   ,
            DataDependency => DataDependency 
           );

DfuDataIn .AluResult <= AluResult;
DfuDataIn .ImmData   <= ImmData;
DfuDataIn .RdAddress <= RdAddress;
DfuDataIn .CsrData   <= CsrData;
DfuDataIn .Negative  <= Negative;
DfuDataIn .PcNext    <= PcNext;

DfuWrEna   <= DfuDataOut.DfuWrEna  ;
DfuAddress <= DfuDataOut.DfuAddress;
DfuData    <= DfuDataOut.DfuData   ;

TestBench: PROCESS
    
    VARIABLE ReadCol           : LINE                         ;
    VARIABLE WriteCol          : LINE                         ;
    
    VARIABLE ValAluResult      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValImmData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValRdAddress      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValCsrData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNegative       : STD_LOGIC                    ;
    VARIABLE ValPcNext         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValDfuMode        : STD_LOGIC                    ;
    VARIABLE ValCacheMiss      : STD_LOGIC                    ;
    VARIABLE ValGprRsX1        : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValGprRsX2        : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValGprRdX         : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValInst           : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValRst            : STD_LOGIC                    ;
    VARIABLE ValClk            : STD_LOGIC                    ;
    VARIABLE ValDfuWrEna       : STD_LOGIC                    ;
    VARIABLE ValDfuAddress     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValDfuData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValEnaPipeline    : STD_LOGIC                    ;
    VARIABLE ValDataDependency : STD_LOGIC                    ;
    VARIABLE ValComma          : CHARACTER                    ;
    VARIABLE GoodNum           : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S8DfuTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S8DfuTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#AluResult      ,ImmData        ,RdAddress      ,CsrData        ,Negative       ,PcNext         ,DfuMode        ,CacheMiss      ,GprRsX1        ,GprRsX2        ,GprRdX         ,Inst           ,Rst            ,Clk            ,DfuWrEna       ,DfuAddress     ,DfuData        ,EnaPipeline    ,DataDependency ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValAluResult      , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValImmData        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ImmData";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValRdAddress      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to RdAddress";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValCsrData        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CsrData";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValNegative       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Negative";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValPcNext         , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to PcNext";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValDfuMode        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DfuMode";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValCacheMiss      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CacheMiss";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValGprRsX1        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprRsX1";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValGprRsX2        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprRsX2";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValGprRdX         , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprRdX";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInst           , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Inst";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValRst            , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValClk            , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValDfuWrEna                );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValDfuAddress              );
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValDfuData                 );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValEnaPipeline             );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValDataDependency          );
        
        
        AluResult          <= ValAluResult      ;
        ImmData            <= ValImmData        ;
        RdAddress          <= ValRdAddress      ;
        CsrData            <= ValCsrData        ;
        Negative           <= ValNegative       ;
        PcNext             <= ValPcNext         ;
        DfuMode            <= ValDfuMode        ;
        CacheMiss          <= ValCacheMiss      ;
        GprRsX1            <= ValGprRsX1        ;
        GprRsX2            <= ValGprRsX2        ;
        GprRdX             <= ValGprRdX         ;
        Inst               <= ValInst           ;
        Rst                <= ValRst            ;
        Clk                <= ValClk            ;
        TempDfuWrEna       <= ValDfuWrEna       ;
        TempDfuAddress     <= ValDfuAddress     ;
        TempDfuData        <= ValDfuData        ;
        TempEnaPipeline    <= ValEnaPipeline    ;
        TempDataDependency <= ValDataDependency ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, AluResult      );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, ImmData        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, RdAddress      );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, CsrData        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Negative       );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, PcNext         );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, DfuMode        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, CacheMiss      );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, GprRsX1        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, GprRsX2        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, GprRdX         );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Inst           );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Rst            );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Clk            );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, DfuWrEna       );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, DfuAddress     );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, DfuData        );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, EnaPipeline    );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, DataDependency );
        WRITE (WriteCol, STRING'(",")   );
        
        IF(TempDfuWrEna /= DfuWrEna) THEN
            
            WRITE (WriteCol, STRING'("DfuWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DfuWrEna OK   ,"));
            
        END IF;
        
        IF(TempDfuAddress /= DfuAddress) THEN
            
            WRITE (WriteCol, STRING'("DfuAddress ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DfuAddress OK   ,"));
            
        END IF;
        
        IF(TempDfuData /= DfuData) THEN
            
            WRITE (WriteCol, STRING'("DfuData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DfuData OK   ,"));
            
        END IF;
        
        IF(TempEnaPipeline /= EnaPipeline) THEN
            
            WRITE (WriteCol, STRING'("EnaPipeline ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("EnaPipeline OK   ,"));
            
        END IF;
        
        IF(TempDataDependency /= DataDependency) THEN
            
            WRITE (WriteCol, STRING'("DataDependency ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DataDependency OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S8DfuTestProtocolArch;

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

ENTITY S9PipelineRegisterTestProtocol IS
END S9PipelineRegisterTestProtocol;

ARCHITECTURE S9PipelineRegisterTestProtocolArch OF S9PipelineRegisterTestProtocol IS

SIGNAL InImmData          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InRdAddress        : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL InRs1Address       : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL InRs2Address       : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL InPcNext           : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InPc               : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InAluOperation     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL InAluSource        : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL InCsrOperation     : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL InMdrOperation     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL InWbDataSrc        : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL InGprWrEna         : STD_LOGIC                    ;
SIGNAL PipelineMode       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL Rst                : STD_LOGIC                    ;
SIGNAL Clk                : STD_LOGIC                    ;
SIGNAL OutAluResult       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OutMemData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OutImmData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OutRdAddress       : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL OutCsrData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OutNegative        : STD_LOGIC                    ;
SIGNAL OutPcNext          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OutWbDataSrc       : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL OutGprWrEna        : STD_LOGIC                    ;
SIGNAL TempOutAluResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutMemData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutImmData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutRdAddress   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempOutCsrData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutNegative    : STD_LOGIC                    ;
SIGNAL TempOutPcNext      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempOutWbDataSrc   : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempOutGprWrEna    : STD_LOGIC                    ;

SIGNAL DataIn             : DecodeStageDataT             ;
SIGNAL ControlWordIn      : ControlWordReg               ;
SIGNAL DataOut            : MemStageDataT                ;
SIGNAL ControlWordOut     : ControlWordWb                ;

FILE   InputBuff          : TEXT;
FILE   OutputBuff         : TEXT;

BEGIN

X1: ENTITY WORK.PipelineRegisters(MainArchitecture)
PORT MAP   (DataIn         => DataIn        ,
            ControlWordIn  => ControlWordIn ,
            PipelineMode   => PipelineMode  ,
            Rst            => Rst           ,
            Clk            => Clk           ,
            DataOut        => DataOut       ,
            ControlWordOut => ControlWordOut 
           );

DataIn.ImmData      <= InImmData   ;
DataIn.RdAddress    <= InRdAddress ;
DataIn.Rs1Address   <= InRs1Address;
DataIn.Rs2Address   <= InRs2Address;
DataIn.PcNext       <= InPcNext    ;
DataIn.Pc           <= InPc        ;

ControlWordIn .AluStage.AluOperation <= InAluOperation;
ControlWordIn .AluStage.AluSource    <= InAluSource   ;
ControlWordIn .AluStage.CsrOperation <= InCsrOperation;
ControlWordIn .MStage  .MdrOperation <= InMdrOperation;
ControlWordIn .WbStage .WbDataSrc    <= InWbDataSrc   ;
ControlWordIn .WbStage .GprWrEna     <= InGprWrEna    ;
ControlWordIn .InstId                <= InstNoOp      ;

OutAluResult   <= DataOut       .AluResult            ;
OutMemData     <= DataOut       .MemData              ;
OutImmData     <= DataOut       .ImmData              ;
OutRdAddress   <= DataOut       .RdAddress            ;
OutCsrData     <= DataOut       .CsrData              ;
OutNegative    <= DataOut       .Negative             ;
OutPcNext      <= DataOut       .PcNext               ;

OutWbDataSrc   <= ControlWordOut.WbStage .WbDataSrc   ;
OutGprWrEna    <= ControlWordOut.WbStage .GprWrEna    ;

TestBench: PROCESS
    
    VARIABLE ReadCol           : LINE                         ;
    VARIABLE WriteCol          : LINE                         ;
    
    VARIABLE ValInImmData      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValInRdAddress    : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValInRs1Address   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValInRs2Address   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValInPcNext       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValInPc           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValInAluOperation : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValInAluSource    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValInCsrOperation : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValInMdrOperation : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValInWbDataSrc    : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValInGprWrEna     : STD_LOGIC                    ;
    VARIABLE ValPipelineMode   : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValRst            : STD_LOGIC                    ;
    VARIABLE ValClk            : STD_LOGIC                    ;
    VARIABLE ValOutAluResult   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOutMemData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOutImmData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOutRdAddress   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValOutCsrData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOutNegative    : STD_LOGIC                    ;
    VARIABLE ValOutPcNext      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValOutWbDataSrc   : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValOutGprWrEna    : STD_LOGIC                    ;
    VARIABLE ValComma          : CHARACTER                    ;
    VARIABLE GoodNum           : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S9PipelineRegisterTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S9PipelineRegisterTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#InImmData      ,InRdAddress    ,InRs1Address   ,InRs2Address   ,InPcNext       ,InPc           ,InAluOperation ,InAluSource    ,InCsrOperation ,InMdrOperation ,InWbDataSrc    ,InGprWrEna     ,PipelineMode   ,Rst            ,Clk            ,OutAluResult   ,OutMemData     ,OutImmData     ,OutRdAddress   ,OutCsrData     ,OutNegative    ,OutPcNext      ,OutWbDataSrc   ,OutGprWrEna    ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValInImmData      , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInRdAddress    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InRdAddress";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInRs1Address   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InRs1Address";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInRs2Address   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InRs2Address";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValInPcNext       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InPcNext";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValInPc           , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InPc";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInAluOperation , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InAluOperation";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInAluSource    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InAluSource";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInCsrOperation , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InCsrOperation";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValInMdrOperation , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InMdrOperation";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInWbDataSrc    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InWbDataSrc";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValInGprWrEna     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to InGprWrEna";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValPipelineMode   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to PipelineMode";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValRst            , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValClk            , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValOutAluResult            );
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValOutMemData              );
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValOutImmData              );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValOutRdAddress            );
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValOutCsrData              );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValOutNegative             );
        
        READ    (ReadCol, ValComma                   );
        HREAD   (ReadCol, ValOutPcNext               );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValOutWbDataSrc            );
        
        READ    (ReadCol, ValComma                   );
        READ    (ReadCol, ValOutGprWrEna             );
        
        
        InImmData          <= ValInImmData      ;
        InRdAddress        <= ValInRdAddress    ;
        InRs1Address       <= ValInRs1Address   ;
        InRs2Address       <= ValInRs2Address   ;
        InPcNext           <= ValInPcNext       ;
        InPc               <= ValInPc           ;
        InAluOperation     <= ValInAluOperation ;
        InAluSource        <= ValInAluSource    ;
        InCsrOperation     <= ValInCsrOperation ;
        InMdrOperation     <= ValInMdrOperation ;
        InWbDataSrc        <= ValInWbDataSrc    ;
        InGprWrEna         <= ValInGprWrEna     ;
        PipelineMode       <= ValPipelineMode   ;
        Rst                <= ValRst            ;
        Clk                <= ValClk            ;
        TempOutAluResult   <= ValOutAluResult   ;
        TempOutMemData     <= ValOutMemData     ;
        TempOutImmData     <= ValOutImmData     ;
        TempOutRdAddress   <= ValOutRdAddress   ;
        TempOutCsrData     <= ValOutCsrData     ;
        TempOutNegative    <= ValOutNegative    ;
        TempOutPcNext      <= ValOutPcNext      ;
        TempOutWbDataSrc   <= ValOutWbDataSrc   ;
        TempOutGprWrEna    <= ValOutGprWrEna    ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, InImmData      );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InRdAddress    );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InRs1Address   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InRs2Address   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InPcNext       );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InPc           );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InAluOperation );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InAluSource    );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InCsrOperation );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InMdrOperation );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InWbDataSrc    );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, InGprWrEna     );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, PipelineMode   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Rst            );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, Clk            );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutAluResult   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutMemData     );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutImmData     );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutRdAddress   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutCsrData     );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutNegative    );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutPcNext      );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutWbDataSrc   );
        WRITE (WriteCol, STRING'(",")   );
        WRITE (WriteCol, OutGprWrEna    );
        WRITE (WriteCol, STRING'(",")   );
        
        IF(TempOutAluResult /= OutAluResult) THEN
            
            WRITE (WriteCol, STRING'("OutAluResult ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutAluResult OK   ,"));
            
        END IF;
        
        IF(TempOutMemData /= OutMemData) THEN
            
            WRITE (WriteCol, STRING'("OutMemData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutMemData OK   ,"));
            
        END IF;
        
        IF(TempOutImmData /= OutImmData) THEN
            
            WRITE (WriteCol, STRING'("OutImmData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutImmData OK   ,"));
            
        END IF;
        
        IF(TempOutRdAddress /= OutRdAddress) THEN
            
            WRITE (WriteCol, STRING'("OutRdAddress ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutRdAddress OK   ,"));
            
        END IF;
        
        IF(TempOutCsrData /= OutCsrData) THEN
            
            WRITE (WriteCol, STRING'("OutCsrData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutCsrData OK   ,"));
            
        END IF;
        
        IF(TempOutNegative /= OutNegative) THEN
            
            WRITE (WriteCol, STRING'("OutNegative ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutNegative OK   ,"));
            
        END IF;
        
        IF(TempOutPcNext /= OutPcNext) THEN
            
            WRITE (WriteCol, STRING'("OutPcNext ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutPcNext OK   ,"));
            
        END IF;
        
        IF(TempOutWbDataSrc /= OutWbDataSrc) THEN
            
            WRITE (WriteCol, STRING'("OutWbDataSrc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutWbDataSrc OK   ,"));
            
        END IF;
        
        IF(TempOutGprWrEna /= OutGprWrEna) THEN
            
            WRITE (WriteCol, STRING'("OutGprWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("OutGprWrEna OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S9PipelineRegisterTestProtocolArch;

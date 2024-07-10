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

ENTITY S6ControlUnitTestProtocol IS
END S6ControlUnitTestProtocol;

ARCHITECTURE S6ControlUnitTestProtocolArch OF S6ControlUnitTestProtocol IS

SIGNAL Instruction           : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mps                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mie                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mnev                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL DfuDataDependency     : STD_LOGIC                    ;
SIGNAL BranchResult          : STD_LOGIC                    ;
SIGNAL IrqX                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL CacheMiss             : STD_LOGIC                    ;
SIGNAL Rst                   : STD_LOGIC                    ;
SIGNAL Clk                   : STD_LOGIC                    ;
SIGNAL ImmSext               : STD_LOGIC                    ;
SIGNAL Format                : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL AluOperation          : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL AluSource             : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL CsrOperation          : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL MdrOperation          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL WbDataSrc             : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL GprWrEna              : STD_LOGIC                    ;
SIGNAL PcMode                : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL ClkConfig             : STD_LOGIC                    ;
SIGNAL ExcPcWrEna            : STD_LOGIC                    ;
SIGNAL ExcCsrWrEna           : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL ExcCsrData            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ExcCsrAddress         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CycleMepc             : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL ExcMemRd              : STD_LOGIC                    ;
SIGNAL ExcAluOp              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL BranchType            : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL BpuMode               : STD_LOGIC                    ;
SIGNAL GprRsX1               : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL GprRsX2               : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL GprRdX                : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL DfuMode               : STD_LOGIC                    ;
SIGNAL PipelineMode          : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL AckX                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempImmSext           : STD_LOGIC                    ;
SIGNAL TempFormat            : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempAluOperation      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempAluSource         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempCsrOperation      : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempMdrOperation      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempWbDataSrc         : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TempGprWrEna          : STD_LOGIC                    ;
SIGNAL TempPcMode            : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempClkConfig         : STD_LOGIC                    ;
SIGNAL TempExcPcWrEna        : STD_LOGIC                    ;
SIGNAL TempExcCsrWrEna       : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempExcCsrData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempExcCsrAddress     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempCycleMepc         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempExcMemRd          : STD_LOGIC                    ;
SIGNAL TempExcAluOp          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempBranchType        : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL TempBpuMode           : STD_LOGIC                    ;
SIGNAL TempGprRsX1           : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempGprRsX2           : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempGprRdX            : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL TempDfuMode           : STD_LOGIC                    ;
SIGNAL TempPipelineMode      : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempAckX              : STD_LOGIC_VECTOR( 3 DOWNTO 0);

SIGNAL ControlWord           : ControlWordDecode            ;
SIGNAL ExcCtrlWord           : CtrlExcT                     ;

FILE   InputBuff             : TEXT;
FILE   OutputBuff            : TEXT;

BEGIN

X1: ENTITY WORK.ControlUnit(MainArch)
PORT MAP   (Instruction       => Instruction      ,
            Mps               => Mps              ,
            Mie               => Mie              ,
            Mnev              => Mnev             ,
            DfuDataDependency => DfuDataDependency,
            BranchResult      => BranchResult     ,
            IrqX              => IrqX             ,
            CacheMiss         => CacheMiss        ,
            Rst               => Rst              ,
            Clk               => Clk              ,
            ControlWord       => ControlWord      ,
            PcMode            => PcMode           ,
            ClkConfig         => ClkConfig        ,
            ExcCtrlWord       => ExcCtrlWord      ,
            BranchType        => BranchType       ,
            BpuMode           => BpuMode          ,
            GprRsX1           => GprRsX1          ,
            GprRsX2           => GprRsX2          ,
            GprRdX            => GprRdX           ,
            DfuMode           => DfuMode          ,
            PipelineMode      => PipelineMode     ,
            AckX              => AckX              
           );

ImmSext       <= ControlWord.DecStage.ImmSext     ;
Format        <= ControlWord.DecStage.Format      ;
AluOperation  <= ControlWord.AluStage.AluOperation;
AluSource     <= ControlWord.AluStage.AluSource   ;
CsrOperation  <= ControlWord.AluStage.CsrOperation;
MdrOperation  <= ControlWord.MStage  .MdrOperation;
WbDataSrc     <= ControlWord.WbStage .WbDataSrc   ;
GprWrEna      <= ControlWord.WbStage .GprWrEna    ;

ExcPcWrEna    <= ExcCtrlWord.ExcPcWrEna   ;
ExcCsrWrEna   <= ExcCtrlWord.ExcCsrWrEna  ;
ExcCsrData    <= ExcCtrlWord.ExcCsrData   ;
ExcCsrAddress <= ExcCtrlWord.ExcCsrAddress;
CycleMepc     <= ExcCtrlWord.CycleMepc    ;
ExcMemRd      <= ExcCtrlWord.ExcMemRd     ;
ExcAluOp      <= ExcCtrlWord.ExcAluOp     ;

TestBench: PROCESS
    
    VARIABLE ReadCol              : LINE                         ;
    VARIABLE WriteCol             : LINE                         ;
    
    VARIABLE ValInstruction       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMps               : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMie               : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMnev              : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValDfuDataDependency : STD_LOGIC                    ;
    VARIABLE ValBranchResult      : STD_LOGIC                    ;
    VARIABLE ValIrqX              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValCacheMiss         : STD_LOGIC                    ;
    VARIABLE ValRst               : STD_LOGIC                    ;
    VARIABLE ValClk               : STD_LOGIC                    ;
    VARIABLE ValImmSext           : STD_LOGIC                    ;
    VARIABLE ValFormat            : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValAluOperation      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValAluSource         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValCsrOperation      : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValMdrOperation      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValWbDataSrc         : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValGprWrEna          : STD_LOGIC                    ;
    VARIABLE ValPcMode            : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValClkConfig         : STD_LOGIC                    ;
    VARIABLE ValExcPcWrEna        : STD_LOGIC                    ;
    VARIABLE ValExcCsrWrEna       : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValExcCsrData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValExcCsrAddress     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCycleMepc         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValExcMemRd          : STD_LOGIC                    ;
    VARIABLE ValExcAluOp          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValBranchType        : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValBpuMode           : STD_LOGIC                    ;
    VARIABLE ValGprRsX1           : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValGprRsX2           : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValGprRdX            : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValDfuMode           : STD_LOGIC                    ;
    VARIABLE ValPipelineMode      : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValAckX              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValComma             : CHARACTER                    ;
    VARIABLE GoodNum              : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S6ControlUnitTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S6ControlUnitTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#Instruction       ,Mps               ,Mie               ,Mnev              ,DfuDataDependency ,BranchResult      ,IrqX              ,CacheMiss         ,Rst               ,Clk               ,ImmSext           ,Format            ,AluOperation      ,AluSource         ,CsrOperation      ,MdrOperation      ,WbDataSrc         ,GprWrEna          ,PcMode            ,ClkConfig         ,ExcPcWrEna        ,ExcCsrWrEna       ,ExcCsrData        ,ExcCsrAddress     ,CycleMepc         ,ExcMemRd          ,ExcAluOp          ,BranchType        ,BpuMode           ,GprRsX1           ,GprRsX2           ,GprRdX            ,DfuMode           ,Inst              ,PipelineMode      ,AckX              ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        READ    (ReadCol, ValInstruction       , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValMps               , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Mps";
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValMie               , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Mie";
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValMnev              , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Mnev";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValDfuDataDependency , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DfuDataDependency";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValBranchResult      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to BranchResult";
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValIrqX              , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to IrqX";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValCacheMiss         , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CacheMiss";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValRst               , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValClk               , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValImmSext                    );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValFormat                     );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValAluOperation               );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValAluSource                  );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValCsrOperation               );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValMdrOperation               );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValWbDataSrc                  );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValGprWrEna                   );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValPcMode                     );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValClkConfig                  );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValExcPcWrEna                 );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValExcCsrWrEna                );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValExcCsrData                 );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValExcCsrAddress              );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValCycleMepc                  );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValExcMemRd                   );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValExcAluOp                   );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValBranchType                 );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValBpuMode                    );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValGprRsX1                    );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValGprRsX2                    );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValGprRdX                     );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValDfuMode                    );
        
        READ    (ReadCol, ValComma                      );
        READ    (ReadCol, ValPipelineMode               );
        
        READ    (ReadCol, ValComma                      );
        HREAD   (ReadCol, ValAckX                       );
        
        
        Instruction           <= ValInstruction       ;
        Mps                   <= ValMps               ;
        Mie                   <= ValMie               ;
        Mnev                  <= ValMnev              ;
        DfuDataDependency     <= ValDfuDataDependency ;
        BranchResult          <= ValBranchResult      ;
        IrqX                  <= ValIrqX              ;
        CacheMiss             <= ValCacheMiss         ;
        Rst                   <= ValRst               ;
        Clk                   <= ValClk               ;
        TempImmSext           <= ValImmSext           ;
        TempFormat            <= ValFormat            ;
        TempAluOperation      <= ValAluOperation      ;
        TempAluSource         <= ValAluSource         ;
        TempCsrOperation      <= ValCsrOperation      ;
        TempMdrOperation      <= ValMdrOperation      ;
        TempWbDataSrc         <= ValWbDataSrc         ;
        TempGprWrEna          <= ValGprWrEna          ;
        TempPcMode            <= ValPcMode            ;
        TempClkConfig         <= ValClkConfig         ;
        TempExcPcWrEna        <= ValExcPcWrEna        ;
        TempExcCsrWrEna       <= ValExcCsrWrEna       ;
        TempExcCsrData        <= ValExcCsrData        ;
        TempExcCsrAddress     <= ValExcCsrAddress     ;
        TempCycleMepc         <= ValCycleMepc         ;
        TempExcMemRd          <= ValExcMemRd          ;
        TempExcAluOp          <= ValExcAluOp          ;
        TempBranchType        <= ValBranchType        ;
        TempBpuMode           <= ValBpuMode           ;
        TempGprRsX1           <= ValGprRsX1           ;
        TempGprRsX2           <= ValGprRsX2           ;
        TempGprRdX            <= ValGprRdX            ;
        TempDfuMode           <= ValDfuMode           ;
        TempPipelineMode      <= ValPipelineMode      ;
        TempAckX              <= ValAckX              ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, Instruction       );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Mps               );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Mie               );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Mnev              );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, DfuDataDependency );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, BranchResult      );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, IrqX              );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, CacheMiss         );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Rst               );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Clk               );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ImmSext           );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, Format            );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, AluOperation      );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, AluSource         );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, CsrOperation      );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, MdrOperation      );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, WbDataSrc         );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, GprWrEna          );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, PcMode            );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ClkConfig         );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcPcWrEna        );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcCsrWrEna       );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcCsrData        );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcCsrAddress     );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, CycleMepc         );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcMemRd          );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, ExcAluOp          );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, BranchType        );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, BpuMode           );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, GprRsX1           );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, GprRsX2           );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, GprRdX            );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, DfuMode           );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, PipelineMode      );
        WRITE (WriteCol, STRING'(",")      );
        WRITE (WriteCol, AckX              );
        WRITE (WriteCol, STRING'(",")      );
        
        IF(TempImmSext /= ImmSext) THEN
            
            WRITE (WriteCol, STRING'("ImmSext ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ImmSext OK   ,"));
            
        END IF;
        
        IF(TempFormat /= Format) THEN
            
            WRITE (WriteCol, STRING'("Format ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Format OK   ,"));
            
        END IF;
        
        IF(TempAluOperation /= AluOperation) THEN
            
            WRITE (WriteCol, STRING'("AluOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluOperation OK   ,"));
            
        END IF;
        
        IF(TempAluSource /= AluSource) THEN
            
            WRITE (WriteCol, STRING'("AluSource ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AluSource OK   ,"));
            
        END IF;
        
        IF(TempCsrOperation /= CsrOperation) THEN
            
            WRITE (WriteCol, STRING'("CsrOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("CsrOperation OK   ,"));
            
        END IF;
        
        IF(TempMdrOperation /= MdrOperation) THEN
            
            WRITE (WriteCol, STRING'("MdrOperation ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("MdrOperation OK   ,"));
            
        END IF;
        
        IF(TempWbDataSrc /= WbDataSrc) THEN
            
            WRITE (WriteCol, STRING'("WbDataSrc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("WbDataSrc OK   ,"));
            
        END IF;
        
        IF(TempGprWrEna /= GprWrEna) THEN
            
            WRITE (WriteCol, STRING'("GprWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprWrEna OK   ,"));
            
        END IF;
        
        IF(TempPcMode /= PcMode) THEN
            
            WRITE (WriteCol, STRING'("PcMode ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("PcMode OK   ,"));
            
        END IF;
        
        IF(TempClkConfig /= ClkConfig) THEN
            
            WRITE (WriteCol, STRING'("ClkConfig ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ClkConfig OK   ,"));
            
        END IF;
        
        IF(TempExcPcWrEna /= ExcPcWrEna) THEN
            
            WRITE (WriteCol, STRING'("ExcPcWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcPcWrEna OK   ,"));
            
        END IF;
        
        IF(TempExcCsrWrEna /= ExcCsrWrEna) THEN
            
            WRITE (WriteCol, STRING'("ExcCsrWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcCsrWrEna OK   ,"));
            
        END IF;
        
        IF(TempExcCsrData /= ExcCsrData) THEN
            
            WRITE (WriteCol, STRING'("ExcCsrData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcCsrData OK   ,"));
            
        END IF;
        
        IF(TempExcCsrAddress /= ExcCsrAddress) THEN
            
            WRITE (WriteCol, STRING'("ExcCsrAddress ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcCsrAddress OK   ,"));
            
        END IF;
        
        IF(TempCycleMepc /= CycleMepc) THEN
            
            WRITE (WriteCol, STRING'("CycleMepc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("CycleMepc OK   ,"));
            
        END IF;
        
        IF(TempExcMemRd /= ExcMemRd) THEN
            
            WRITE (WriteCol, STRING'("ExcMemRd ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcMemRd OK   ,"));
            
        END IF;
        
        IF(TempExcAluOp /= ExcAluOp) THEN
            
            WRITE (WriteCol, STRING'("ExcAluOp ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("ExcAluOp OK   ,"));
            
        END IF;
        
        IF(TempBranchType /= BranchType) THEN
            
            WRITE (WriteCol, STRING'("BranchType ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("BranchType OK   ,"));
            
        END IF;
        
        IF(TempBpuMode /= BpuMode) THEN
            
            WRITE (WriteCol, STRING'("BpuMode ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("BpuMode OK   ,"));
            
        END IF;
        
        IF(TempGprRsX1 /= GprRsX1) THEN
            
            WRITE (WriteCol, STRING'("GprRsX1 ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprRsX1 OK   ,"));
            
        END IF;
        
        IF(TempGprRsX2 /= GprRsX2) THEN
            
            WRITE (WriteCol, STRING'("GprRsX2 ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprRsX2 OK   ,"));
            
        END IF;
        
        IF(TempGprRdX /= GprRdX) THEN
            
            WRITE (WriteCol, STRING'("GprRdX ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprRdX OK   ,"));
            
        END IF;
        
        IF(TempDfuMode /= DfuMode) THEN
            
            WRITE (WriteCol, STRING'("DfuMode ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DfuMode OK   ,"));
            
        END IF;
        
        IF(TempPipelineMode /= PipelineMode) THEN
            
            WRITE (WriteCol, STRING'("PipelineMode ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("PipelineMode OK   ,"));
            
        END IF;
        
        IF(TempAckX /= AckX) THEN
            
            WRITE (WriteCol, STRING'("AckX ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AckX OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S6ControlUnitTestProtocolArch;

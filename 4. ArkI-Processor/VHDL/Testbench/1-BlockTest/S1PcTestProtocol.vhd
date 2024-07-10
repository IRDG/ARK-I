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

ENTITY S1PcTestProtocol IS
END S1PcTestProtocol;

ARCHITECTURE S1PcTestProtocolArch OF S1PcTestProtocol IS

SIGNAL ImmData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NewPc          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MePcRd         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL EnaLoad        : STD_LOGIC                    ;
SIGNAL AluResult      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NewExcPc       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PcMode         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL ExcPcWrEna     : STD_LOGIC                    ;
SIGNAL Rst            : STD_LOGIC                    ;
SIGNAL Clk            : STD_LOGIC                    ;
SIGNAL Pc             : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NextPc         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PcPlusImm      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempPc         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempNextPc     : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempPcPlusImm  : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.ProgramCounter(MainArch)
GENERIC MAP(CoreId     => 0
           )
PORT MAP   (ImmData    => ImmData   ,
            NewPc      => NewPc     ,
            MePcRd     => MePcRd    ,
            EnaLoad    => EnaLoad   ,
            AluResult  => AluResult ,
            NewExcPc   => NewExcPc  ,
            PcMode     => PcMode    ,
            ExcPcWrEna => ExcPcWrEna,
            Rst        => Rst       ,
            Clk        => Clk       ,
            Pc         => Pc        ,
            NextPc     => NextPc    ,
            PcPlusImm  => PcPlusImm  
           );

TestBench: PROCESS
    
    VARIABLE ReadCol       : LINE                         ;
    VARIABLE WriteCol      : LINE                         ;
    
    VARIABLE ValImmData    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNewPc      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMePcRd     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValEnaLoad    : STD_LOGIC                    ;
    VARIABLE ValAluResult  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNewExcPc   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValPcMode     : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValExcPcWrEna : STD_LOGIC                    ;
    VARIABLE ValRst        : STD_LOGIC                    ;
    VARIABLE ValClk        : STD_LOGIC                    ;
    VARIABLE ValPc         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNextPc     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValPcPlusImm  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma      : CHARACTER                    ;
    VARIABLE GoodNum       : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S1PcTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S1PcTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#ImmData    ,NewPc      ,MePcRd     ,EnaLoad    ,AluResult  ,NewExcPc   ,PcMode     ,ExcPcWrEna ,Rst        ,Clk        ,Pc         ,NextPc     ,PcPlusImm  ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValImmData    , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValNewPc      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to NewPc";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValMePcRd     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to MePcRd";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValEnaLoad    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to EnaLoad";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValAluResult  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to AluResult";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValNewExcPc   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to NewExcPc";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValPcMode     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to PcMode";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValExcPcWrEna , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcPcWrEna";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValRst        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValClk        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValPc                  );
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValNextPc              );
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValPcPlusImm           );
        
        ImmData        <= ValImmData    ;
        NewPc          <= ValNewPc      ;
        MePcRd         <= ValMePcRd     ;
        EnaLoad        <= ValEnaLoad    ;
        AluResult      <= ValAluResult  ;
        NewExcPc       <= ValNewExcPc   ;
        PcMode         <= ValPcMode     ;
        ExcPcWrEna     <= ValExcPcWrEna ;
        Rst            <= ValRst        ;
        Clk            <= ValClk        ;
        TempPc         <= ValPc         ;
        TempNextPc     <= ValNextPc     ;
        TempPcPlusImm  <= ValPcPlusImm  ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, ImmData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, NewPc       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, MePcRd      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, EnaLoad     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, AluResult   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, NewExcPc    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, PcMode      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ExcPcWrEna  );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Rst         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Clk         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Pc          );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, NextPc      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, PcPlusImm   );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempPc /= Pc) THEN
            
            WRITE (WriteCol, STRING'("Pc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Pc OK   ,"));
            
        END IF;
        
        IF(TempNextPc /= NextPc) THEN
            
            WRITE (WriteCol, STRING'("NextPc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("NextPc OK   ,"));
            
        END IF;
        
        IF(TempPcPlusImm /= PcPlusImm) THEN
            
            WRITE (WriteCol, STRING'("PcPlusImm ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("PcPlusImm OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S1PcTestProtocolArch;

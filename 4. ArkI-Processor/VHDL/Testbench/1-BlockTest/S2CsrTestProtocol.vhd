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

ENTITY S2CsrTestProtocol IS
END S2CsrTestProtocol;

ARCHITECTURE S2CsrTestProtocolArch OF S2CsrTestProtocol IS

SIGNAL RdAddress       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MepcWr          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WrOperation     : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL ExcWrEna        : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL ExcData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ExcAddress      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CycleMepc       : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL WrAddress       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL GprData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ImmData         : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL Rst             : STD_LOGIC                    ;
SIGNAL Clk             : STD_LOGIC                    ;
SIGNAL MepcRd          : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mtvec           : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mnev            : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mie             : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mps             : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CsrData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempMepcRd      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempMtvec       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempMnev        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempMie         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempMps         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempCsrData     : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.ControlAndStatusRegisters(MainArch)
PORT MAP   (RdAddress   => RdAddress  ,
            MepcWr      => MepcWr     ,
            WrOperation => WrOperation,
            ExcWrEna    => ExcWrEna   ,
            ExcData     => ExcData    ,
            ExcAddress  => ExcAddress ,
            CycleMepc   => CycleMepc  ,
            WrAddress   => WrAddress  ,
            GprData     => GprData    ,
            ImmData     => ImmData    ,
            Rst         => Rst        ,
            Clk         => Clk        ,
            MepcRd      => MepcRd     ,
            Mtvec       => Mtvec      ,
            Mnev        => Mnev       ,
            Mie         => Mie        ,
            Mps         => Mps        ,
            CsrData     => CsrData     
           );

TestBench: PROCESS
    
    VARIABLE ReadCol        : LINE                         ;
    VARIABLE WriteCol       : LINE                         ;
    
    VARIABLE ValRdAddress   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMepcWr      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValWrOperation : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    VARIABLE ValExcWrEna    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValExcData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValExcAddress  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCycleMepc   : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValWrAddress   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValGprData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValImmData     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValRst         : STD_LOGIC                    ;
    VARIABLE ValClk         : STD_LOGIC                    ;
    VARIABLE ValMepcRd      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMtvec       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMnev        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMie         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValMps         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValCsrData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma       : CHARACTER                    ;
    VARIABLE GoodNum        : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2CsrTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2CsrTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#RdAddress   ,MepcWr      ,WrOperation ,ExcWrEna    ,ExcData     ,ExcAddress  ,CycleMepc   ,WrAddress   ,GprData     ,ImmData     ,Rst         ,Clk         ,MepcRd      ,Mtvec       ,Mnev        ,Mie         ,Mps         ,CsrData     ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValRdAddress   , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMepcWr      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to MepcWr";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValWrOperation , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to WrOperation";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValExcWrEna    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcWrEna";
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValExcData     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcData";
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValExcAddress  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcAddress";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValCycleMepc   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to CycleMepc";
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValWrAddress   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to WrAddress";
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValGprData     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to GprData";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValImmData     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ImmData";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValRst         , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma                );
        READ    (ReadCol, ValClk         , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMepcRd               );
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMtvec                );
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMnev                 );
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMie                  );
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValMps                  );
        
        READ    (ReadCol, ValComma                );
        HREAD   (ReadCol, ValCsrData              );
        
        
        RdAddress       <= ValRdAddress   ;
        MepcWr          <= ValMepcWr      ;
        WrOperation     <= ValWrOperation ;
        ExcWrEna        <= ValExcWrEna    ;
        ExcData         <= ValExcData     ;
        ExcAddress      <= ValExcAddress  ;
        CycleMepc       <= ValCycleMepc   ;
        WrAddress       <= ValWrAddress   ;
        GprData         <= ValGprData     ;
        ImmData         <= ValImmData     ;
        Rst             <= ValRst         ;
        Clk             <= ValClk         ;
        TempMepcRd      <= ValMepcRd      ;
        TempMtvec       <= ValMtvec       ;
        TempMnev        <= ValMnev        ;
        TempMie         <= ValMie         ;
        TempMps         <= ValMps         ;
        TempCsrData     <= ValCsrData     ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, RdAddress   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, MepcWr      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WrOperation );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ExcWrEna    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ExcData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ExcAddress  );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CycleMepc   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WrAddress   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, GprData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, ImmData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Rst         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Clk         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, MepcRd      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Mtvec       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Mnev        );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Mie         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Mps         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, CsrData     );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempMepcRd /= MepcRd) THEN
            
            WRITE (WriteCol, STRING'("MepcRd ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("MepcRd OK   ,"));
            
        END IF;
        
        IF(TempMtvec /= Mtvec) THEN
            
            WRITE (WriteCol, STRING'("Mtvec ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Mtvec OK   ,"));
            
        END IF;
        
        IF(TempMnev /= Mnev) THEN
            
            WRITE (WriteCol, STRING'("Mnev ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Mnev OK   ,"));
            
        END IF;
        
        IF(TempMie /= Mie) THEN
            
            WRITE (WriteCol, STRING'("Mie ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Mie OK   ,"));
            
        END IF;
        
        IF(TempMps /= Mps) THEN
            
            WRITE (WriteCol, STRING'("Mps ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("Mps OK   ,"));
            
        END IF;
        
        IF(TempCsrData /= CsrData) THEN
            
            WRITE (WriteCol, STRING'("CsrData ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("CsrData OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S2CsrTestProtocolArch;

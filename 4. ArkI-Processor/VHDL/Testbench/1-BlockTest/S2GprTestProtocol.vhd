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

ENTITY S2GprTestProtocol IS
END S2GprTestProtocol;

ARCHITECTURE S2GprTestProtocolArch OF S2GprTestProtocol IS

SIGNAL R1Address      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL R2Address      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL RdAddress      : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL WbData         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WrEna          : STD_LOGIC                    ;
SIGNAL DfuAddress     : STD_LOGIC_VECTOR( 4 DOWNTO 0);
SIGNAL DfuData        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL DfuWrEna       : STD_LOGIC                    ;
SIGNAL Rst            : STD_LOGIC                    ;
SIGNAL Clk            : STD_LOGIC                    ;
SIGNAL GprData1       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL GprData2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempGprData1   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempGprData2   : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff     : TEXT;
FILE   OutputBuff    : TEXT;

BEGIN

X1: ENTITY WORK.GeneralPurposeRegisters(MainArch)
PORT MAP   (R1Address  => R1Address ,
            R2Address  => R2Address ,
            RdAddress  => RdAddress ,
            WbData     => WbData    ,
            WrEna      => WrEna     ,
            DfuAddress => DfuAddress,
            DfuData    => DfuData   ,
            DfuWrEna   => DfuWrEna  ,
            Rst        => Rst       ,
            Clk        => Clk       ,
            GprData1   => GprData1  ,
            GprData2   => GprData2   
           );

TestBench: PROCESS
    
    VARIABLE ReadCol       : LINE                         ;
    VARIABLE WriteCol      : LINE                         ;
    
    VARIABLE ValR1Address  : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValR2Address  : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValRdAddress  : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValWbData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValWrEna      : STD_LOGIC                    ;
    VARIABLE ValDfuAddress : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    VARIABLE ValDfuData    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValDfuWrEna   : STD_LOGIC                    ;
    VARIABLE ValRst        : STD_LOGIC                    ;
    VARIABLE ValClk        : STD_LOGIC                    ;
    VARIABLE ValGprData1   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValGprData2   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma      : CHARACTER                    ;
    VARIABLE GoodNum       : BOOLEAN                      ;
    
BEGIN
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2GprTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S2GprTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#R1Address  ,R2Address  ,RdAddress  ,WbData     ,WrEna      ,DfuAddress ,DfuData    ,DfuWrEna   ,Rst        ,Clk        ,GprData1   ,GprData2   ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        READ    (ReadCol, ValR1Address  , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValR2Address  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to R2Address";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValRdAddress  , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to RdAddress";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValWbData     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to WbData";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValWrEna      , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to WrEna";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValDfuAddress , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DfuAddress";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValDfuData    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DfuData";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValDfuWrEna   , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DfuWrEna";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValRst        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Rst";
        
        READ    (ReadCol, ValComma               );
        READ    (ReadCol, ValClk        , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to Clk";
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValGprData1            );
        
        READ    (ReadCol, ValComma               );
        HREAD   (ReadCol, ValGprData2            );
        
        
        R1Address      <= ValR1Address  ;
        R2Address      <= ValR2Address  ;
        RdAddress      <= ValRdAddress  ;
        WbData         <= ValWbData     ;
        WrEna          <= ValWrEna      ;
        DfuAddress     <= ValDfuAddress ;
        DfuData        <= ValDfuData    ;
        DfuWrEna       <= ValDfuWrEna   ;
        Rst            <= ValRst        ;
        Clk            <= ValClk        ;
        TempGprData1   <= ValGprData1   ;
        TempGprData2   <= ValGprData2   ;
        
        WAIT FOR 10 ns;
        
        Clk <= NOT Clk;
        
        WAIT FOR 10 ns;
        
        WRITE (WriteCol, R1Address   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, R2Address   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, RdAddress   );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WbData      );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, WrEna       );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, DfuAddress  );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, DfuData     );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, DfuWrEna    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Rst         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, Clk         );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, GprData1    );
        WRITE (WriteCol, STRING'(","));
        WRITE (WriteCol, GprData2    );
        WRITE (WriteCol, STRING'(","));
        
        IF(TempGprData1 /= GprData1) THEN
            
            WRITE (WriteCol, STRING'("GprData1 ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprData1 OK   ,"));
            
        END IF;
        
        IF(TempGprData2 /= GprData2) THEN
            
            WRITE (WriteCol, STRING'("GprData2 ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("GprData2 OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S2GprTestProtocolArch;

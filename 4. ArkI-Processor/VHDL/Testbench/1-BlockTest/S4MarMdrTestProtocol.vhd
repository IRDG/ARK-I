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

ENTITY S4MarMdrTestProtocol IS
END S4MarMdrTestProtocol;

ARCHITECTURE S4MarMdrTestProtocolArch OF S4MarMdrTestProtocol IS

CONSTANT HighZ          : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => ('Z'));

SIGNAL AddressIn        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL DataWr           : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ExcVTable        : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ExcMemRd         : STD_LOGIC                    ;
SIGNAL MdrOperation     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL BusData          : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
SIGNAL AddressOut       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RdWrEna          : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL DataRd           : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL NewExcPc         : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempAddressOut   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempRdWrEna      : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL TempDataRd       : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TempNewExcPc     : STD_LOGIC_VECTOR(31 DOWNTO 0);

FILE   InputBuff        : TEXT;
FILE   OutputBuff       : TEXT;

BEGIN

X1: ENTITY WORK.MemoryDataRegisterAndMemoryAddressRegister(MainArch)
PORT MAP   (AddressIn    => AddressIn   ,
            DataWr       => DataWr      ,
            ExcVTable    => ExcVTable   ,
            ExcMemRd     => ExcMemRd    ,
            MdrOperation => MdrOperation,
            BusData      => BusData     ,
            AddressOut   => AddressOut  ,
            RdWrEna      => RdWrEna     ,
            DataRd       => DataRd      ,
            NewExcPc     => NewExcPc     
           );

BusData <= HighZ       AFTER  20 ns,
           HighZ       AFTER  40 ns,
           HighZ       AFTER  60 ns,
           x"00000000" AFTER  80 ns,
           x"AAAAAAAA" AFTER 100 ns,
           x"AAAAAAAA" AFTER 120 ns,
           x"2754F234" AFTER 140 ns,
           x"AAAAAAAA" AFTER 160 ns,
           x"AAAAAAAA" AFTER 180 ns,
           x"00000017" AFTER 200 ns,
           x"0000037F" AFTER 220 ns,
           x"00000DC6" AFTER 240 ns,
           x"00001EA5" AFTER 260 ns;

TestBench: PROCESS
    
    VARIABLE ReadCol         : LINE                         ;
    VARIABLE WriteCol        : LINE                         ;
    
    VARIABLE ValAddressIn    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValDataWr       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValExcVTable    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValExcMemRd     : STD_LOGIC                    ;
    VARIABLE ValMdrOperation : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    VARIABLE ValAddressOut   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValRdWrEna      : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    VARIABLE ValDataRd       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValNewExcPc     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE ValComma        : CHARACTER                    ;
    VARIABLE GoodNum         : BOOLEAN                      ;
    
BEGIN
    
    file_open(InputBuff ,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S4MarMdrTest-Input.csv" , read_mode );
    file_open(OutputBuff,"C:/Users/etria/OneDrive/DOCUMENTOS/Academic/Master/3Semester/Thesis/4. ArkI-Processor/RiscV-Core/CSV/S4MarMdrTest-Output.csv", write_mode);
    
    WRITE    (WriteCol, STRING'("#AddressIn    ,DataWr       ,ExcVTable    ,ExcMemRd     ,MdrOperation ,BusData      ,AddressOut   ,RdWrEna      ,DataRd       ,NewExcPc     ,"));
    WRITELINE(OutputBuff,WriteCol);
    
    WHILE (NOT (ENDFILE (InputBuff))) LOOP
        
        READLINE(InputBuff, ReadCol);
        
        HREAD   (ReadCol, ValAddressIn    , GoodNum);
        NEXT WHEN NOT GoodNum;
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValDataWr       , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to DataWr";
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValExcVTable    , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcVTable";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValExcMemRd     , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to ExcMemRd";
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValMdrOperation , GoodNum);
        ASSERT  GoodNum REPORT "Bad value assigned to MdrOperation";
        
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValAddressOut            );
        
        READ    (ReadCol, ValComma                 );
        READ    (ReadCol, ValRdWrEna               );
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValDataRd                );
        
        READ    (ReadCol, ValComma                 );
        HREAD   (ReadCol, ValNewExcPc              );
        
        
        AddressIn        <= ValAddressIn    ;
        DataWr           <= ValDataWr       ;
        ExcVTable        <= ValExcVTable    ;
        ExcMemRd         <= ValExcMemRd     ;
        MdrOperation     <= ValMdrOperation ;
        TempAddressOut   <= ValAddressOut   ;
        TempRdWrEna      <= ValRdWrEna      ;
        TempDataRd       <= ValDataRd       ;
        TempNewExcPc     <= ValNewExcPc     ;
        
        WAIT FOR 20 ns;
        
        WRITE (WriteCol, AddressIn    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, DataWr       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, ExcVTable    );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, ExcMemRd     );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, MdrOperation );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, AddressOut   );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, RdWrEna      );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, DataRd       );
        WRITE (WriteCol, STRING'(",") );
        WRITE (WriteCol, NewExcPc     );
        WRITE (WriteCol, STRING'(",") );
        
        IF(TempAddressOut /= AddressOut) THEN
            
            WRITE (WriteCol, STRING'("AddressOut ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("AddressOut OK   ,"));
            
        END IF;
        
        IF(TempRdWrEna /= RdWrEna) THEN
            
            WRITE (WriteCol, STRING'("RdWrEna ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("RdWrEna OK   ,"));
            
        END IF;
        
        IF(TempDataRd /= DataRd) THEN
            
            WRITE (WriteCol, STRING'("DataRd ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("DataRd OK   ,"));
            
        END IF;
        
        IF(TempNewExcPc /= NewExcPc) THEN
            
            WRITE (WriteCol, STRING'("NewExcPc ERROR,"));
            
        ELSE
            
            WRITE (WriteCol, STRING'("NewExcPc OK   ,"));
            
        END IF;
        
        WRITELINE(OutputBuff,WriteCol);
        
    END LOOP;
    
    file_close(InputBuff );
    file_close(OutputBuff);
    
    WAIT;
    
END PROCESS TestBench;

END S4MarMdrTestProtocolArch;

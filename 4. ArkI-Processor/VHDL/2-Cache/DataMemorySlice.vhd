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

USE WORK.BasicPackage.ALL;
USE WORK.CachePackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY DataMemorySlice IS
    
    GENERIC(SliceId        : INTEGER := 15
           );
    PORT   (RdWrAddress    : IN  uint32    ;
            WrData         : IN  uint32    ;
            RdWrEnable     : IN  uint02    ;
            ReplaceData    : IN  uint32    ;
            ReplaceAddress : IN  uint32    ;
            ReplaceEnaRd   : IN  uint01    ;
            ReplaceEnaWr   : IN  uint01    ;
            FreezeRatings  : IN  uint01    ;
            Rst            : IN  uint01    ;
            Clk            : IN  uint01    ;
            RdData         : OUT uint32    ;
            MemoryDataWr   : OUT uint32    ;
            SliceAddress   : OUT uint33    ;
            Miss           : OUT uint01    ;
            UsageRating    : OUT RatingType 
           );
    
END ENTITY DataMemorySlice;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF DataMemorySlice IS

SIGNAL CountRating : CounterType;
SIGNAL Hit         : uint01     ;
SIGNAL CurrentTag  : TagType    ;

SIGNAL WrEnable    : uint02     ;
SIGNAL RdEnable    : uint01     ;

SIGNAL NextWrData  : WordField  ;
SIGNAL NextReplace : WordFIeld  ;
SIGNAL NextFields  : WordField  ;
SIGNAL PrevFields  : WordField  ;

SIGNAL CounterEna  : uint01     ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

AddressMem: ENTITY WORK.AddressMemory(MainArch)
PORT MAP   (RdAddress      => RdWrAddress   ,
            ReplaceEnaWr   => ReplaceEnaWr  ,
            ReplaceAddress => ReplaceAddress,
            Rst            => Rst           ,
            Clk            => Clk           ,
            SliceAddress   => SliceAddress  ,
            Hit            => Hit            
           );

Miss <= NOT Hit;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WrEnable(0) <= ReplaceEnaWr ;
WrEnable(1) <= RdWrEnable(0);

FieldInputGenerator : FOR I IN 0 TO NoFields GENERATE
    
    NextWrData (I) <= WrData         WHEN (Slv2Int(RdWrAddress   (FieldSize-1 DOWNTO 0)) = I) ELSE
                      PrevFields(I);
    
    NextReplace(I) <= ReplaceData    WHEN (Slv2Int(ReplaceAddress(FieldSize-1 DOWNTO 0)) = I) ELSE
                      PrevFields(I);
    
    WITH WrEnable SELECT
    NextFields (I) <= NextReplace(I) WHEN "01",
                      NextWrData(I)  WHEN "10",
                      NextReplace(I) WHEN "11",
                      PrevFields(I)  WHEN OTHERS;
    
END GENERATE FieldInputGenerator;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

MainMemory: PROCESS(Clk, Rst, NextFields)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevFields <= EmptyFields;
        
    ELSIF (FALLING_EDGE(Clk)) THEN
        
        PrevFields <= NextFields;
        
    END IF;
    
END PROCESS MainMemory;

CurrentTag   <= RdWrAddress(FieldSize-1 DOWNTO 0);

RdEnable     <= Hit AND RdWrEnable(1);

WITH ReplaceEnaRd SELECT
MemoryDataWr <= PrevFields(Slv2Int(CurrentTag)) WHEN '1',
                NoData                          WHEN OTHERS;

WITH RdEnable SELECT
RdData       <= PrevFields(Slv2Int(CurrentTag)) WHEN '1',
                NoData                          WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

UsageRating <= CountRating & Int2Slv(SliceId,SliceSize);

CounterEna  <= (NOT(ReplaceEnaRd OR ReplaceEnaWr)) AND (NOT FreezeRatings);

RatingCounter: ENTITY WORK.LinearRateCounter(MainArch)
GENERIC MAP(Size     => RatingCounterSize
           )
PORT MAP   (Ena      => CounterEna ,
            Up       => Hit        ,
            MR       => Rst        ,
            SR       => '0'        ,
            Clk      => Clk        ,
            MaxCount => OPEN       ,
            Count    => CountRating 
           );

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.DataMemorySlice(MainArch)
--GENERIC MAP(SliceId        => # 
--           )
--PORT MAP   (RdWrAddress    => SLV,
--            WrData         => SLV,
--            RdWrEnable     => SLV,
--            ReplaceData    => SLV,
--            ReplaceAddress => SLV,
--            ReplaceEnaRd   => SLV,
--            ReplaceEnaWr   => SLV,
--            FreezeRatings  => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            RdData         => SLV,
--            MemoryDataRd   => SLV,
--            SliceAddress   => SLV,
--            Miss           => SLV,
--            UsageRating    => SLV 
--           );
------------------------------------------------------------------------------------------
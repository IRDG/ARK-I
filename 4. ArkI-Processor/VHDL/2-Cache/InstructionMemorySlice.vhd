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

ENTITY InstructionMemorySlice IS
    
    GENERIC(SliceId        : INTEGER := 15
           );
    PORT   (RdAddress      : IN  uint32    ;
            ReplaceData    : IN  uint32    ;
            ReplaceAddress : IN  uint32    ;
            ReplaceEnaWr   : IN  uint01    ;
            FreezeRatings  : IN  uint01    ;
            Rst            : IN  uint01    ;
            Clk            : IN  uint01    ;
            RdData         : OUT uint32    ;
            Miss           : OUT uint01    ;
            UsageRating    : OUT RatingType 
           );
    
END ENTITY InstructionMemorySlice;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF InstructionMemorySlice IS

SIGNAL CountRating : CounterType;
SIGNAL Hit         : uint01     ;
SIGNAL CurrentTag  : TagType    ;

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
PORT MAP   (RdAddress      => RdAddress     ,
            ReplaceEnaWr   => ReplaceEnaWr  ,
            ReplaceAddress => ReplaceAddress,
            Rst            => Rst           ,
            Clk            => Clk           ,
            SliceAddress   => OPEN          ,
            Hit            => Hit            
           );

Miss <= NOT Hit;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

FieldInputGenerator : FOR I IN 0 TO NoFields GENERATE
    
    NextFields(I) <= ReplaceData  WHEN (Slv2Int(ReplaceAddress(FieldSize-1 DOWNTO 0)) = I) ELSE
                     PrevFields(I);
    
END GENERATE FieldInputGenerator;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

MainMemory: PROCESS(Clk, Rst, NextFields, ReplaceEnaWr)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevFields <= EmptyFields;
        
    ELSIF (FALLING_EDGE(Clk)) THEN
        
        IF (ReplaceEnaWr = '1') THEN
            
            PrevFields <= NextFields;
            
        END IF;
        
    END IF;
    
END PROCESS MainMemory;

CurrentTag <= RdAddress(FieldSize-1 DOWNTO 0);

WITH Hit SELECT
RdData     <= PrevFields(Slv2Int(CurrentTag)) WHEN '1',
              NoData                          WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

UsageRating <= CountRating & Int2Slv(SliceId,SliceSize);

CounterEna  <= (NOT ReplaceEnaWr) AND (NOT FreezeRatings);

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
--BlockN: ENTITY WORK.InstructionMemorySlice(MainArch)
--GENERIC MAP(SliceId        => # 
--           )
--PORT MAP   (RdAddress      => SLV,
--            ReplaceData    => SLV,
--            ReplaceAddress => SLV,
--            ReplaceEnaWr   => SLV,
--            FreezeRatings  => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            RdData         => SLV,
--            Miss           => SLV,
--            UsageRating    => SLV 
--           );
------------------------------------------------------------------------------------------
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

USE WORK.BasicPackage.ALL;
USE WORK.CachePackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY LinearRateCounter IS
    
    GENERIC(
               Size    : INTEGER
           );
    PORT   (
              Ena      : IN  uint01     ;
              Up       : IN  uint01     ;
              MR       : IN  uint01     ;
              SR       : IN  uint01     ;
              Clk      : IN  uint01     ;
              MaxCount : OUT uint01     ;
              Count    : OUT CounterType 
           );
    
END ENTITY LinearRateCounter;

ARCHITECTURE MainArch OF LinearRateCounter IS

CONSTANT UpValue    : STD_LOGIC_VECTOR(Size-1 DOWNTO 0) := (Int2Slv(12,Size));
CONSTANT DwValue    : STD_LOGIC_VECTOR(Size-1 DOWNTO 0) := (Int2Slv( 1,Size));

CONSTANT Zero       : STD_LOGIC_VECTOR(Size-1 DOWNTO 0) := (OTHERS => ('0'));
CONSTANT Ones       : STD_LOGIC_VECTOR(Size-1 DOWNTO 0) := (OTHERS => ('1'));

SIGNAL   PrevCount  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   TempCount  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   NextCount  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

SIGNAL   Number     : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   Sign       : uint01                           ;
SIGNAL   Overflow   : uint01                           ;
SIGNAL   CountCtrl  : uint05                           ;
SIGNAL   MinCount   : uint01                           ;
SIGNAL   LowerLimit : uint01                           ;
SIGNAL   UpperLimit : uint01                           ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Up SELECT
Number <= UpValue WHEN '1',
          DwValue WHEN '0',
          Zero    WHEN OTHERS;

WITH Up SELECT
Sign   <= '0'     WHEN '1',
          '1'     WHEN '0',
          '0'     WHEN OTHERS;

SumNextCount: ENTITY WORK.AdderSubtractor(MainArch)
GENERIC MAP(Size     => Size
           )
PORT MAP   (NumA     => PrevCount,
            NumB     => Number,
            Subtract => Sign,
            Result   => TempCount,
            Overflow => Overflow
           );

LowerLimit <= MinCount AND (NOT Up);
UpperLimit <= Overflow AND (    Up);
CountCtrl  <= SR & LowerLimit & UpperLimit & Up & Ena;

WITH CountCtrl SELECT
NextCount <= PrevCount WHEN "00000",
             TempCount WHEN "00001",
             PrevCount WHEN "00010",
             TempCount WHEN "00011",
             Ones      WHEN "00100",
             TempCount WHEN "00101",
             Ones      WHEN "00110",
             Ones      WHEN "00111",
             Zero      WHEN "01000",
             Zero      WHEN "01001",
             Zero      WHEN "01010",
             TempCount WHEN "01011",
             Zero      WHEN "01100", -- Impossible
             Zero      WHEN OTHERS;

Counting:Process(Clk,MR)

BEGIN
    
    IF (MR = '1') THEN
        
        PrevCount <= Zero;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        
        PrevCount <= NextCount;
        
        
    END IF;
    
END PROCESS Counting;

Count    <= PrevCount;

MaxCount <= '1' WHEN (PrevCount = Ones) ELSE
            '0';

MinCount <= '1' WHEN (PrevCount = Zero) ELSE
            '0';

END MainArch;
------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.LinearRateCounter(MainArch)
--GENERIC MAP(Size => #
--           )
--PORT MAP   (Ena      => SLV,
--            Up       => SLV,
--            MR       => SLV,
--            SR       => SLV,
--            Clk      => SLV,
--            MaxCount => SLV,
--            Count    => SLV
--           );
------------------------------------------------------------------------------------------
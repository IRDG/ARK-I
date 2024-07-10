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

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY GralCounter IS
    
    GENERIC(
               Size: INTEGER := 8
           );
    PORT   (
              Ena      : IN  STD_LOGIC;
              MR       : IN  STD_LOGIC;
              SR       : IN  STD_LOGIC;
              Clk      : IN  STD_LOGIC;
              MaxCount : OUT STD_LOGIC;
              Count    : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
           );
    
END ENTITY GralCounter;

ARCHITECTURE MainArch OF GralCounter IS

CONSTANT Ones     : UNSIGNED (Size-1 DOWNTO 0) := (OTHERS=>'1');
CONSTANT Zeros    : UNSIGNED (Size-1 DOWNTO 0) := (OTHERS=>'0');

SIGNAL CountS     : UNSIGNED (Size-1 DOWNTO 0);
SIGNAL CountNext  : UNSIGNED (Size-1 DOWNTO 0);

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

CountNext <= (OTHERS=>'0') WHEN (SR         = '1') ELSE
             (CountS + 1 ) WHEN (Ena        = '1') ELSE
             (CountS     );

Counting:Process(Clk,MR)

Variable Temp : UNSIGNED (Size-1 DOWNTO 0);

BEGIN
    
    IF (MR = '1') THEN
        
        Temp := (OTHERS=>'0');
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF    (SR  = '1') THEN
            
            Temp := (OTHERS=>'0');
            
        ELSIF (Ena = '1') THEN
            
            Temp:= CountNext;
            
        END IF;
        
    END IF;
    
    Count  <= STD_LOGIC_VECTOR(Temp);
    CountS <= Temp;
    
END PROCESS Counting;

MaxCount <= '1' WHEN (CountS = Ones) ELSE
            '0';

END MainArch;
------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.GralCounter(MainArch)
--GENERIC MAP(Size => #
--           )
--PORT MAP   (Ena      => SLV,
--            MR       => SLV,
--            SR       => SLV,
--            Clk      => SLV,
--            MaxCount => SLV,
--            Count    => SLV
--           );
------------------------------------------------------------------------------------------
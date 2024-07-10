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

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY AdderSubtractor IS
    
    GENERIC(Size     : INTEGER := 32
           );
    PORT   (NumA     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            NumB     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            Subtract : IN  STD_LOGIC;
            Result   : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            Overflow : OUT STD_LOGIC
           );
    
END ENTITY AdderSubtractor;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF AdderSubtractor IS

SIGNAL RealB : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RealNumGenerator: FOR I IN 0 TO Size-1 GENERATE
    
    RealB(I) <= NumB(I) XOR Subtract;
    
END GENERATE RealNumGenerator;

Add: ENTITY WORK.Adder(CarryLookAhead)
GENERIC MAP(Size     => Size
           )
PORT MAP   (NumA     => NumA,
            NumB     => RealB,
            CarryIn  => Subtract,
            Result   => Result,
            CarryOut => Overflow
           );

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.AdderSubtractor(MainArch)
--GENERIC MAP(Size     => #
--           )
--PORT MAP   (NumA     => SLV,
--            NumB     => SLV,
--            Subtract => SLV,
--            Result   => SLV,
--            Overflow => SLV
--           );
------------------------------------------------------------------------------------------
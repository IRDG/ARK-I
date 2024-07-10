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

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY Adder IS
    
    GENERIC(Size     : INTEGER := 32
           );
    PORT   (NumA     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            NumB     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            CarryIn  : IN  STD_LOGIC;
            Result   : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
            CarryOut : OUT STD_LOGIC
           );

END ENTITY Adder;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE RippleCarry OF Adder IS

SIGNAL Carry : STD_LOGIC_VECTOR(Size   DOWNTO 0);

BEGIN

----------------------------------------------------------
-- 
-- Set the first carry signal to the value of CarryIn to
-- add one when CarryIning, thus making a 2s complement
-- of the number B
-- 
-- Set the overflow value to the final carry generated
-- 
----------------------------------------------------------

Carry( 0) <= CarryIn;
CarryOut  <= Carry(Size);

----------------------------------------------------------
-- 
-- Summon the FullAdderHalfAdder using a for generate to
-- allow the generic implementation
-- 
----------------------------------------------------------

AdderGenerator:FOR I IN 0 TO (Size-1) GENERATE
    
    FA: ENTITY WORK.FullAdderHalfAdder(FullAdder)
    PORT MAP   (A    => NumA  (I  ),
                B    => NumB  (I  ),
                Cin  => Carry (I  ),
                R    => Result(I  ),
                Cout => Carry (I+1)
               );
    
END GENERATE AdderGenerator;


END RippleCarry;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE CarryLookAhead OF Adder IS

SIGNAL Gen   : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Prop  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Carry : STD_LOGIC_VECTOR(Size   DOWNTO 0);

BEGIN

----------------------------------------------------------
-- 
-- Summon the FullAdderHalfAdder using a for generate to
-- allow the generic implementation
-- 
----------------------------------------------------------

AdderGenerator: FOR I IN 0 TO (Size-1) GENERATE
    
    FA: ENTITY WORK.FullAdderHalfAdder(FullAdder)
    PORT MAP   (A    => NumA  (I  ),
                B    => NumB  (I  ),
                Cin  => Carry (I  ),
                R    => Result(I  ),
                Cout => OPEN
               );
    
END GENERATE AdderGenerator;

----------------------------------------------------------
-- 
-- Describe the Carry Look Ahead logic
-- 
-- Here the propagate, generate and carry terms are
-- calculated
-- 
-- The first Generate, propagate and carry terms are
-- calculated outside the for generate as the first
-- carry requires the special input for CarryIning
-- 
-- The last carry is also described outside the for
-- generate statement
-- 
----------------------------------------------------------

Gen  (0) <= NumA(0) AND NumB(0);
Prop (0) <= NumA(0) OR  NumB(0);
Carry(0) <= CarryIn;
CarryOut <= Carry(Size);

ClaGenerator: FOR I IN 1 TO (Size-1) GENERATE
    
    Gen  (I) <= NumA(I  ) AND  NumB(I  );
    Prop (I) <= NumA(I  ) OR   NumB(I  );
    Carry(I) <= Gen (I-1) OR  (Prop(I-1) AND Carry(I-1));
    
END GENERATE ClaGenerator;

Carry(Size) <= Gen(Size-1) OR (Prop(Size-1) AND Carry(Size-1));

END CarryLookAhead;


------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.Adder(RippleCarry CarryLookAhead)
--GENERIC MAP(Size     => #
--           )
--PORT MAP   (NumA     => SLV,
--            NumB     => SLV,
--            CarryIn  => SLV,
--            Result   => SLV,
--            CarryOut => SLV
--           );
------------------------------------------------------------------------------------------
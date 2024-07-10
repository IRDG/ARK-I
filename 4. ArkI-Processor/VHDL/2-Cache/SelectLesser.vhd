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

ENTITY SelectLesser IS
    
    PORT   (RatingArray   : IN  RatingArrayT;
            Miss          : IN  uint01      ;
            ReplaceSelect : OUT SliceVectorT 
           );
    
END ENTITY SelectLesser;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE SelectLesserArch OF SelectLesser IS

TYPE   CompareT1 IS ARRAY (0 TO 7) OF RatingType;
TYPE   CompareT2 IS ARRAY (0 TO 3) OF RatingType;
TYPE   CompareT3 IS ARRAY (0 TO 1) OF RatingType;

SIGNAL Dm1         : CompareT1   ;
SIGNAL Dm2         : CompareT2   ;
SIGNAL Dm3         : CompareT3   ;

SIGNAL Dmin        : RatingType  ;
SIGNAL ReplaceTemp : SliceVectorT;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Dm1(0) <= CompareMin(RatingArray( 0),RatingArray( 1));
Dm1(1) <= CompareMin(RatingArray( 2),RatingArray( 3));
Dm1(2) <= CompareMin(RatingArray( 4),RatingArray( 5));
Dm1(3) <= CompareMin(RatingArray( 6),RatingArray( 7));
Dm1(4) <= CompareMin(RatingArray( 8),RatingArray( 9));
Dm1(5) <= CompareMin(RatingArray(10),RatingArray(11));
Dm1(6) <= CompareMin(RatingArray(12),RatingArray(13));
Dm1(7) <= CompareMin(RatingArray(14),RatingArray(15));

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Dm2(0) <= CompareMin(Dm1        ( 0),Dm1        ( 1));
Dm2(1) <= CompareMin(Dm1        ( 2),Dm1        ( 3));
Dm2(2) <= CompareMin(Dm1        ( 4),Dm1        ( 5));
Dm2(3) <= CompareMin(Dm1        ( 6),Dm1        ( 7));

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Dm3(0) <= CompareMin(Dm2        ( 0),Dm2        ( 1));
Dm3(1) <= CompareMin(Dm2        ( 2),Dm2        ( 3));

Dmin   <= CompareMin(Dm3        ( 0),Dm3        ( 1));

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

ReplaceIndex: FOR I IN 0 TO 15 GENERATE
    
    ReplaceTemp(I) <= '1' WHEN (Slv2Int(Dmin) = Slv2Int(RatingArray(I))) ELSE
                      '0';
    
    ReplaceSelect(I) <= ReplaceTemp(I) AND Miss;
    
END GENERATE ReplaceIndex;

END SelectLesserArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.SelectLesser(SelectLesserArch)
--PORT MAP   (RatingArray   => SLV,
--            Miss          => SLV,
--            ReplaceSelect => SLV
--           );
------------------------------------------------------------------------------------------
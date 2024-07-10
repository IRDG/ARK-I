------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Proyect:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                       Package                                        --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;

PACKAGE CachePackage IS

CONSTANT MemoryDelay : INTEGER := 2;

------------------------------------------------------------------------------------------
-- 
-- SliceSize         -> Bus size according to the number of slices
-- NoSlices          -> Number of slices defined
-- 
-- RatingCounterSize -> Bus size for the Counter Rating signal
-- RatingSize        -> Bus size for the Rating signal
-- 
-- FieldSize         -> Bus size for the fields. Each field contains one word
-- NoFields          -> Number of fields inside each slice
-- 
------------------------------------------------------------------------------------------

CONSTANT SliceSize         : INTEGER   :=  4                             ;
CONSTANT NoSlices          : INTEGER   := (2 ** SliceSize) - 1           ;

CONSTANT RatingCounterSize : INTEGER   :=  8                             ;
CONSTANT RatingSize        : INTEGER   := (RatingCounterSize + SliceSize);

CONSTANT FieldSize         : INTEGER   :=  4                             ;
CONSTANT NoFields          : INTEGER   := (2 ** FieldSize) - 1           ;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

SUBTYPE  uint33        IS STD_LOGIC_VECTOR(                 32 DOWNTO 0);

SUBTYPE  CounterType   IS STD_LOGIC_VECTOR(RatingCounterSize-1 DOWNTO 0);
SUBTYPE  RatingType    IS STD_LOGIC_VECTOR(       RatingSize-1 DOWNTO 0);
SUBTYPE  TagType       IS STD_LOGIC_VECTOR(        FieldSize-1 DOWNTO 0);

SUBTYPE  SliceVectorT  IS STD_LOGIC_VECTOR(         NoSlices   DOWNTO 0);

TYPE     WordField     IS ARRAY (0 TO NoFields) OF uint32    ;
TYPE     RdDataArrayT  IS ARRAY (0 TO NoSlices) OF uint32    ;
TYPE     RatingArrayT  IS ARRAY (0 TO NoSlices) OF RatingType;
TYPE     SliceAddressT IS ARRAY (0 TO NoSlices) OF uint33    ;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

CONSTANT EmptyFields       : WordField    := (OTHERS => (OTHERS => ('0')))  ;
CONSTANT NoData            : uint32       := (           OTHERS => ('0') )  ;
CONSTANT StartingTag       : TagType      := (           OTHERS => ('0') )  ;
CONSTANT FinalTag          : TagType      := (           OTHERS => ('1') )  ;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

PURE FUNCTION IsInRange(Min   : STD_LOGIC_VECTOR;
                        Input : STD_LOGIC_VECTOR;
                        Max   : STD_LOGIC_VECTOR)
RETURN STD_LOGIC;

--PURE FUNCTION OneHotDecoder(OneHot : STD_LOGIC_VECTOR;
--                            Size   : NATURAL         )
--RETURN STD_LOGIC_VECTOR;

PURE FUNCTION CompareMin(X : STD_LOGIC_VECTOR;
                         Y : STD_LOGIC_VECTOR)
RETURN STD_LOGIC_VECTOR;

END PACKAGE CachePackage;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

PACKAGE BODY CachePackage IS

PURE FUNCTION IsInRange(Min   : STD_LOGIC_VECTOR;
                        Input : STD_LOGIC_VECTOR;
                        Max   : STD_LOGIC_VECTOR)
RETURN STD_LOGIC IS

BEGIN
    
    IF((UNSIGNED(Min) <= UNSIGNED(Input)) AND (UNSIGNED(Input) <= UNSIGNED(Max))) THEN
        
        RETURN '1';
        
    ELSE
        
        RETURN '0';
        
    END IF;
    
END IsInRange;

--PURE FUNCTION OneHotDecoder(OneHot : STD_LOGIC_VECTOR;
--                            Size   : NATURAL         )
--RETURN STD_LOGIC_VECTOR IS
--
--VARIABLE Temp : STD_LOGIC_VECTOR(Size DOWNTO 0);
--
--BEGIN
--    
--    Temp := (OTHERS => ('0'));
--    
--    
--    FOR I IN 0 TO Size LOOP
--        
--        IF (OneHot(I) = '1') THEN
--            
--            Temp := Temp OR (Int2Slv(I,Size));
--            
--        END IF;
--        
--    END LOOP;
--    
--    RETURN Temp;
--    
--END OneHotDecoder;

PURE FUNCTION CompareMin(X : STD_LOGIC_VECTOR;
                         Y : STD_LOGIC_VECTOR)
RETURN STD_LOGIC_VECTOR IS

BEGIN
    
    IF (UNSIGNED(X) <= UNSIGNED(Y)) THEN
        
        RETURN X;
        
    ELSE
        
        RETURN Y;
        
    END IF;
    
END CompareMin;

END CachePackage;
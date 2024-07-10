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

ENTITY InstructionCache IS
    
    PORT   (RdAddress      : IN  uint32;
            ReplaceData    : IN  uint32;
            ReplaceAddress : IN  uint32;
            ReplaceSliceWr : IN  uint01;
            Rst            : IN  uint01;
            Clk            : IN  uint01;
            RdData         : OUT uint32;
            Miss           : OUT uint01 
           );
    
END ENTITY InstructionCache;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF InstructionCache IS


CONSTANT TotalMiss      : SliceVectorT := (OTHERS => ('1'));

SIGNAL   RdDataArray      : RdDataArrayT;
SIGNAL   MissVector       : SliceVectorT;
SIGNAL   RatingArray      : RatingArrayT;
SIGNAL   ReplaceEnaWr     : SliceVectorT;
SIGNAL   SliceSelector    : SliceVectorT;
SIGNAL   FinalMiss        : uint01      ;
SIGNAL   TempMiss         : uint01      ;

SIGNAL   UsageRating      : RatingType  ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Miss      <= FinalMiss;
FinalMiss <= TempMiss OR ReplaceSliceWr;

WITH MissVector SELECT
TempMiss  <= '1' WHEN "1111111111111111",
             '0' WHEN OTHERS;

GetMinRating: ENTITY WORK.SelectLesser(SelectLesserArch)
PORT MAP   (RatingArray   => RatingArray  ,
            Miss          => FinalMiss    ,
            ReplaceSelect => SliceSelector 
           );

Decoder: ENTITY WORK.CacheOutputDecoder(MainArch)
PORT MAP   (Miss         => MissVector ,
            RdDataArray  => RdDataArray,
            SliceDataOut => RdData      
           );

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

SliceGenerate: FOR I IN 0 TO NoSlices GENERATE
    
    ReplaceEnaWr(I) <= SliceSelector(I) AND ReplaceSliceWr;
    
    SliceN: ENTITY WORK.InstructionMemorySlice(MainArch)
    GENERIC MAP(SliceId        => I
               )
    PORT MAP   (RdAddress      => RdAddress      ,
                ReplaceData    => ReplaceData    ,
                ReplaceAddress => ReplaceAddress ,
                ReplaceEnaWr   => ReplaceEnaWr(I),
                FreezeRatings  => ReplaceSliceWr ,
                Rst            => Rst            ,
                Clk            => Clk            ,
                RdData         => RdDataArray(I) ,
                Miss           => MissVector (I) ,
                UsageRating    => RatingArray(I)  
               );
    
END GENERATE SliceGenerate;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.InstructionCache(MainArch)
--PORT MAP   (RdAddress      => SLV,
--            ReplaceData    => SLV,
--            ReplaceAddress => SLV,
--            ReplaceSliceWr => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            RdData         => SLV,
--            Miss           => SLV
--           );
------------------------------------------------------------------------------------------
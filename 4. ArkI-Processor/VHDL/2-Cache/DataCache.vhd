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

ENTITY DataCache IS
    
    PORT   (RdWrAddress      : IN  uint32;
            WrData           : IN  uint32;
            RdWrEnable       : IN  uint02;
            ReplaceData      : IN  uint32;
            ReplaceAddress   : IN  uint32;
            ReplaceSliceRd   : IN  uint01;
            ReplaceSliceWr   : IN  uint01;
            Rst              : IN  uint01;
            Clk              : IN  uint01;
            RdData           : OUT uint32;
            MemoryDataWr     : OUT uint32;
            PrevSliceAddress : OUT uint32;
            PrevSliceValid   : OUT uint01;
            Miss             : OUT uint01 
           );
    
END ENTITY DataCache;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF DataCache IS


CONSTANT TotalMiss        : SliceVectorT := (OTHERS => ('1'));

SIGNAL   RdDataArray      : RdDataArrayT ;
SIGNAL   RdMemrArray      : RdDataArrayT ;
SIGNAL   MissVector       : SliceVectorT ;
SIGNAL   RatingArray      : RatingArrayT ;
SIGNAL   ReplaceEnaWr     : SliceVectorT ;
SIGNAL   ReplaceEnaRd     : SliceVectorT ;
SIGNAL   SliceSelector    : SliceVectorT ;
SIGNAL   SliceAddress     : SliceAddressT;
SIGNAL   FinalMiss        : uint01       ;
SIGNAL   TempMiss         : uint01       ;
SIGNAL   ReplaceSlice     : uint01       ;

SIGNAL   UsageRating      : RatingType   ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Miss      <= FinalMiss;

WITH RdWrEnable SELECT
FinalMiss <= '0'                                          WHEN "00",
             '0'                                          WHEN "11",
             TempMiss OR ReplaceSliceRd OR ReplaceSliceWr WHEN OTHERS;

WITH MissVector SELECT
TempMiss  <= '1' WHEN "1111111111111111",
             '0' WHEN OTHERS;

GetMinRating: ENTITY WORK.SelectLesser(SelectLesserArch)
PORT MAP   (RatingArray   => RatingArray  ,
            Miss          => FinalMiss    ,
            ReplaceSelect => SliceSelector 
           );

DataRdDecoder  : ENTITY WORK.CacheOutputDecoder(MainArch)
PORT MAP   (Miss         => MissVector ,
            RdDataArray  => RdDataArray,
            SliceDataOut => RdData      
           );

WITH ReplaceEnaRd SELECT
PrevSliceAddress <= SliceAddress( 0)(31 DOWNTO 0) WHEN x"0001",
                    SliceAddress( 1)(31 DOWNTO 0) WHEN x"0002",
                    SliceAddress( 2)(31 DOWNTO 0) WHEN x"0004",
                    SliceAddress( 3)(31 DOWNTO 0) WHEN x"0008",
                    SliceAddress( 4)(31 DOWNTO 0) WHEN x"0010",
                    SliceAddress( 5)(31 DOWNTO 0) WHEN x"0020",
                    SliceAddress( 6)(31 DOWNTO 0) WHEN x"0040",
                    SliceAddress( 7)(31 DOWNTO 0) WHEN x"0080",
                    SliceAddress( 8)(31 DOWNTO 0) WHEN x"0100",
                    SliceAddress( 9)(31 DOWNTO 0) WHEN x"0200",
                    SliceAddress(10)(31 DOWNTO 0) WHEN x"0400",
                    SliceAddress(11)(31 DOWNTO 0) WHEN x"0800",
                    SliceAddress(12)(31 DOWNTO 0) WHEN x"1000",
                    SliceAddress(13)(31 DOWNTO 0) WHEN x"2000",
                    SliceAddress(14)(31 DOWNTO 0) WHEN x"4000",
                    SliceAddress(15)(31 DOWNTO 0) WHEN x"8000",
                    x"00000000"                   WHEN OTHERS;

WITH ReplaceEnaWr SELECT
MemoryDataWr     <= RdMemrArray( 0)               WHEN x"0001",
                    RdMemrArray( 1)               WHEN x"0002",
                    RdMemrArray( 2)               WHEN x"0004",
                    RdMemrArray( 3)               WHEN x"0008",
                    RdMemrArray( 4)               WHEN x"0010",
                    RdMemrArray( 5)               WHEN x"0020",
                    RdMemrArray( 6)               WHEN x"0040",
                    RdMemrArray( 7)               WHEN x"0080",
                    RdMemrArray( 8)               WHEN x"0100",
                    RdMemrArray( 9)               WHEN x"0200",
                    RdMemrArray(10)               WHEN x"0400",
                    RdMemrArray(11)               WHEN x"0800",
                    RdMemrArray(12)               WHEN x"1000",
                    RdMemrArray(13)               WHEN x"2000",
                    RdMemrArray(14)               WHEN x"4000",
                    RdMemrArray(15)               WHEN x"8000",
                    x"00000000"                   WHEN OTHERS;

WITH SliceSelector SELECT
PrevSliceValid   <= SliceAddress( 0)(32)          WHEN x"0001",
                    SliceAddress( 1)(32)          WHEN x"0002",
                    SliceAddress( 2)(32)          WHEN x"0004",
                    SliceAddress( 3)(32)          WHEN x"0008",
                    SliceAddress( 4)(32)          WHEN x"0010",
                    SliceAddress( 5)(32)          WHEN x"0020",
                    SliceAddress( 6)(32)          WHEN x"0040",
                    SliceAddress( 7)(32)          WHEN x"0080",
                    SliceAddress( 8)(32)          WHEN x"0100",
                    SliceAddress( 9)(32)          WHEN x"0200",
                    SliceAddress(10)(32)          WHEN x"0400",
                    SliceAddress(11)(32)          WHEN x"0800",
                    SliceAddress(12)(32)          WHEN x"1000",
                    SliceAddress(13)(32)          WHEN x"2000",
                    SliceAddress(14)(32)          WHEN x"4000",
                    SliceAddress(15)(32)          WHEN x"8000",
                    '0'                           WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

ReplaceSlice <= ReplaceSliceRd OR ReplaceSliceWr;

SliceGenerate: FOR I IN 0 TO NoSlices GENERATE
    
    ReplaceEnaWr(I) <= SliceSelector(I) AND ReplaceSliceWr;
    ReplaceEnaRd(I) <= SliceSelector(I) AND ReplaceSliceRd;
    
    SliceN: ENTITY WORK.DataMemorySlice(MainArch)
    GENERIC MAP(SliceId        => I
               )
    PORT MAP   (RdWrAddress    => RdWrAddress    ,
                WrData         => WrData         ,
                RdWrEnable     => RdWrEnable     ,
                ReplaceData    => ReplaceData    ,
                ReplaceAddress => ReplaceAddress ,
                ReplaceEnaRd   => ReplaceEnaRd(I),
                ReplaceEnaWr   => ReplaceEnaWr(I),
                FreezeRatings  => ReplaceSlice   ,
                Rst            => Rst            ,
                Clk            => Clk            ,
                RdData         => RdDataArray(I) ,
                MemoryDataWr   => RdMemrArray(I) ,
                SliceAddress   => SliceAddress(I),
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
--BlockN: ENTITY WORK.DataCache(MainArch)
--PORT MAP   (RdWrAddress      => SLV,
--            WrData           => SLV,
--            RdWrEnable       => SLV,
--            ReplaceData      => SLV,
--            ReplaceAddress   => SLV,
--            ReplaceSliceRd   => SLV,
--            ReplaceSliceWr   => SLV,
--            Rst              => SLV,
--            Clk              => SLV,
--            RdData           => SLV,
--            MemoryDataWr     => SLV,
--            PrevSliceAddress => SLV,
--            PrevSliceValid   => SLV,
--            Miss             => SLV
--           );
------------------------------------------------------------------------------------------
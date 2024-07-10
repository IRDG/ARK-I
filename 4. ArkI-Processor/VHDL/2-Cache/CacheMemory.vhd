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

ENTITY CacheMemory IS
    
    PORT   (Pc             : IN  uint32;
            RdWrAddress    : IN  uint32;
            WrData         : IN  uint32;
            RdWrEnable     : IN  uint02;
            MemoryDataRd   : IN  uint32;
            Rst            : IN  uint01;
            Clk            : IN  uint01;
            Instruction    : OUT uint32;
            RdData         : OUT uint32;
            MemoryDataWr   : OUT uint32;
            MemoryAddress  : OUT uint32;
            MemoryRdWrEna  : OUT uint02;
            CacheMiss      : OUT uint01 
           );
    
END ENTITY CacheMemory;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF CacheMemory IS

SIGNAL ReplaceAddress   : uint32;
SIGNAL ReplaceEnaInstWr : uint01;
SIGNAL ReplaceEnaDataWr : uint01;
SIGNAL ReplaceEnaDataRd : uint01;

SIGNAL InstMiss         : uint01;
SIGNAL DataMiss         : uint01;
SIGNAL RealDataMiss     : uint01;
SIGNAL RealRdWrEnable   : uint02;
SIGNAL PrevSliceAddress : uint32;
SIGNAL PrevSliceValid   : uint01;

SIGNAL TmpCacheMiss     : uint01;
SIGNAL TmpInstruction   : uint32;
SIGNAL TmpRdData        : uint32;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RealDataMiss      <= DataMiss AND (RdWrEnable(1) OR RdWrEnable(0));

RealRdWrEnable(0) <= RdWrEnable(0) AND (NOT InstMiss);
RealRdWrEnable(1) <= RdWrEnable(1) AND (NOT InstMiss);

CacheMiss         <= TmpCacheMiss;

TmpCacheMiss      <= (InstMiss OR ReplaceEnaInstWr) OR (RealDataMiss OR (ReplaceEnaDataWr OR ReplaceEnaDataRd));

WITH TmpCacheMiss SELECT
Instruction       <= x"00000000"    WHEN '1'   ,
                     TmpInstruction WHEN '0'   ,
                     x"00000000"    WHEN OTHERS;

WITH TmpCacheMiss SELECT
RdData            <= x"00000000"    WHEN '1'   ,
                     TmpRdData      WHEN '0'   ,
                     x"00000000"    WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Arcu: ENTITY WORK.AddressReplacementControlUnit(MainArch)
PORT MAP   (InstMiss         => InstMiss        ,
            DataMiss         => RealDataMiss    ,
            Pc               => Pc              ,
            RdWrAddress      => RdWrAddress     ,
            PrevSliceAddress => PrevSliceAddress,
            PrevSliceValid   => PrevSliceValid  ,
            Rst              => Rst             ,
            Clk              => Clk             ,
            ReplaceAddress   => ReplaceAddress  ,
            MemoryAddress    => MemoryAddress   ,
            MemoryRdWrEna    => MemoryRdWrEna   ,
            ReplaceEnaInstWr => ReplaceEnaInstWr,
            ReplaceEnaDataWr => ReplaceEnaDataWr,
            ReplaceEnaDataRd => ReplaceEnaDataRd 
           );

InsCache: ENTITY WORK.InstructionCache(MainArch)
PORT MAP   (RdAddress        => Pc               ,
            ReplaceData      => MemoryDataRd     ,
            ReplaceAddress   => ReplaceAddress   ,
            ReplaceSliceWr   => ReplaceEnaInstWr ,
            Rst              => Rst              ,
            Clk              => Clk              ,
            RdData           => TmpInstruction   ,
            Miss             => InstMiss          
           );

DatCache: ENTITY WORK.DataCache(MainArch)
PORT MAP   (RdWrAddress      => RdWrAddress     ,
            WrData           => WrData          ,
            RdWrEnable       => RealRdWrEnable  ,
            ReplaceData      => MemoryDataRd    ,
            ReplaceAddress   => ReplaceAddress  ,
            ReplaceSliceRd   => ReplaceEnaDataRd,
            ReplaceSliceWr   => ReplaceEnaDataWr,
            Rst              => Rst             ,
            Clk              => Clk             ,
            RdData           => TmpRdData       ,
            MemoryDataWr     => MemoryDataWr    ,
            PrevSliceAddress => PrevSliceAddress,
            PrevSliceValid   => PrevSliceValid  ,
            Miss             => DataMiss         
           );

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.CacheMemory(MainArch)
--PORT MAP   (Pc            => SLV,
--            RdWrAddress   => SLV,
--            WrData        => SLV,
--            RdWrEnable    => SLV,
--            ReplaceData   => SLV,
--            Rst           => SLV,
--            Clk           => SLV,
--            Instruction   => SLV,
--            RdData        => SLV,
--            MemoryDataWr  => SLV,
--            MemoryAddress => SLV,
--            MemoryRdWrEna => SLV,
--            CacheMiss     => SLV
--           );
------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY CacheAndPeripheralAddressSolver IS
    
    PORT   (CoreAck          : IN  uint04;
            CoreWrData       : IN  uint32;
            CoreDataAddress  : IN  uint32;
            CoreRdWrEna      : IN  uint02;
            CacheRdData      : IN  uint32;
            PerRdData        : IN  uint32;
            PerIrq           : IN  uint04;
            CoreIrq          : OUT uint04;
            CoreRdData       : OUT uint32;
            CacheWrData      : OUT uint32;
            CacheDataAddress : OUT uint32;
            CacheRdWrEna     : OUT uint02;
            PerWrData        : OUT uint32;
            PerDataAddress   : OUT uint32;
            PerRdWrEna       : OUT uint02;
            PerAck           : OUT uint04 
           );
    
END ENTITY CacheAndPeripheralAddressSolver;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF CacheAndPeripheralAddressSolver IS

CONSTANT Zero02             : uint02 := (OTHERS => ('0'));
CONSTANT Zero32             : uint32 := (OTHERS => ('0'));
CONSTANT PerStartAddress    : uint32 :=       x"FFFF0000";

SIGNAL   AddressTargetCache : uint03;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

AddressTargetCache(2) <= CoreRdWrEna(1);
AddressTargetCache(1) <= CoreRdWrEna(0);
AddressTargetCache(0) <= '1' WHEN (UNSIGNED(CoreDataAddress) < UNSIGNED(PerStartAddress)) ELSE
                         '0';

CoreIrq          <= PerIrq ;
PerAck           <= CoreAck;


WITH AddressTargetCache SELECT
CoreRdData       <= CacheRdData     WHEN "101",
                    PerRdData       WHEN "100",
                    Zero32          WHEN OTHERS;

WITH AddressTargetCache SELECT
CacheWrData      <= CoreWrData      WHEN "011",
                    Zero32          WHEN OTHERS;

WITH AddressTargetCache SELECT
CacheDataAddress <= CoreDataAddress WHEN "011",
                    CoreDataAddress WHEN "101",
                    Zero32          WHEN OTHERS;

WITH AddressTargetCache SELECT
CacheRdWrEna     <= CoreRdWrEna     WHEN "011",
                    CoreRdWrEna     WHEN "101",
                    Zero02          WHEN OTHERS;

WITH AddressTargetCache SELECT
PerWrData        <= CoreWrData      WHEN "010",
                    Zero32          WHEN OTHERS;

WITH AddressTargetCache SELECT
PerDataAddress   <= CoreDataAddress WHEN "010",
                    CoreDataAddress WHEN "100",
                    Zero32          WHEN OTHERS;

WITH AddressTargetCache SELECT
PerRdWrEna       <= CoreRdWrEna     WHEN "010",
                    CoreRdWrEna     WHEN "100",
                    Zero02          WHEN OTHERS;

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.MiddleAddressModule(MainArchitecture)
--PORT MAP   (CoreAck          => SLV,
--            CoreWrData       => SLV,
--            CoreDataAddress  => SLV,
--            CoreRdWrEna      => SLV,
--            CacheWrData      => SLV,
--            CacheDataAddress => SLV,
--            CacheRdWrEna     => SLV,
--            PerWrData        => SLV,
--            PerDataAddress   => SLV,
--            PerRdWrEna       => SLV,
--            PerIrq           => SLV,
--            CoreIrq          => SLV,
--            CoreRdData       => SLV,
--            CacheRdData      => SLV,
--            PerRdData        => SLV,
--            PerAck           => SLV 
--           );
------------------------------------------------------------------------------------------
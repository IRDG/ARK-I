------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Project:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                                                                      --
--                                                                                      --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL  ;

USE WORK.BasicPackage.ALL    ;
USE WORK.ProcessorPackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY ArkIProcessor IS
    
    PORT   (PerRdData      : IN  uint32CoreBus;
            IRQ            : IN  uint04CoreBus;
            Rst            : IN  uint01       ;
            ClkIn          : IN  uint01       ;
            PerWrData      : OUT uint32CoreBus;
            PerDataAddress : OUT uint32CoreBus;
            PerRdWrEna     : OUT uint02CoreBus;
            ACK            : OUT uint04CoreBus 
           );
    
END ENTITY ArkIProcessor;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ArkIProcessor IS

SIGNAL MemoryDataRd  : uint32CoreBus;
SIGNAL MemoryDataWr  : uint32CoreBus;
SIGNAL MemoryAddress : uint32CoreBus;
SIGNAL MemoryRdWrEna : uint02CoreBus;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------


Memory: ENTITY WORK.MainMemory(IpInstantiation)
PORT MAP   (DataRd1     => MemoryDataWr (0),
            DataRd2     => MemoryDataWr (1),
            Address1    => MemoryAddress(0),
            Address2    => MemoryAddress(1),
            RdWrEnable1 => MemoryRdWrEna(0),
            RdWrEnable2 => MemoryRdWrEna(1),
            Clk         => ClkIn           ,
            DataWr1     => MemoryDataRd (0),
            DataWr2     => MemoryDataRd (1) 
           );

ArkI1: ENTITY WORK.ArkICore(ArkICoreArch)
PORT MAP   (MemoryDataRd   => MemoryDataRd  (0),
            PerRdData      => PerRdData     (0),
            CoreId         => '0'              ,
            IRQ            => IRQ           (0),
            Rst            => Rst              ,
            ClkIn          => ClkIn            ,
            MemoryDataWr   => MemoryDataWr  (0),
            MemoryAddress  => MemoryAddress (0),
            MemoryRdWrEna  => MemoryRdWrEna (0),
            PerWrData      => PerWrData     (0),
            PerDataAddress => PerDataAddress(0),
            PerRdWrEna     => PerRdWrEna    (0),
            ACK            => ACK           (0) 
           );

ArkI2: ENTITY WORK.ArkICore(ArkICoreArch)
PORT MAP   (MemoryDataRd   => MemoryDataRd  (1),
            PerRdData      => PerRdData     (1),
            CoreId         => '1'              ,
            IRQ            => IRQ           (1),
            Rst            => Rst              ,
            ClkIn          => ClkIn            ,
            MemoryDataWr   => MemoryDataWr  (1),
            MemoryAddress  => MemoryAddress (1),
            MemoryRdWrEna  => MemoryRdWrEna (1),
            PerWrData      => PerWrData     (1),
            PerDataAddress => PerDataAddress(1),
            PerRdWrEna     => PerRdWrEna    (1),
            ACK            => ACK           (1) 
           );

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ArkIProcessor(MainArch)
--PORT MAP   (PerRdData      => SLV,
--            IRQ            => SLV,
--            Rst            => SLV,
--            ClkIn          => SLV,
--            PerWrData      => SLV,
--            PerDataAddress => SLV,
--            PerRdWrEna     => SLV,
--            ACK            => SLV
--           );
------------------------------------------------------------------------------------------
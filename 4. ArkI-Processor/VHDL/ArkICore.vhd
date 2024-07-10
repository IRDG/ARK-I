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
-- 27800@ares
-- 
------------------------------------------------------------------------------------------

ENTITY ArkICore IS
    
    PORT   (MemoryDataRd   : IN  uint32;
            PerRdData      : IN  uint32;
            CoreId         : IN  uint01;
            IRQ            : IN  uint04;
            Rst            : IN  uint01;
            ClkIn          : IN  uint01;
            MemoryDataWr   : OUT uint32;
            MemoryAddress  : OUT uint32;
            MemoryRdWrEna  : OUT uint02;
            PerWrData      : OUT uint32;
            PerDataAddress : OUT uint32;
            PerRdWrEna     : OUT uint02;
            ACK            : OUT uint04
           );
    
END ENTITY ArkICore;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE ArkICoreArch OF ArkICore IS

SIGNAL Instruction      : uint32;
SIGNAL CoreIrq          : uint04;
SIGNAL CacheMiss        : uint01;
SIGNAL PcAddress        : uint32;
SIGNAL CoreAck          : uint04;

SIGNAL CoreWrData       : uint32;
SIGNAL CoreDataAddress  : uint32;
SIGNAL CoreRdWrEna      : uint02;
SIGNAL CacheWrData      : uint32;
SIGNAL CacheDataAddress : uint32;
SIGNAL CacheRdWrEna     : uint02;
SIGNAL CoreRdData       : uint32;
SIGNAL CacheRdData      : uint32;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

ArkI: ENTITY WORK.RiscVCore(MainArchitecture)
PORT MAP   (Instruction => Instruction    ,
            RdData      => CoreRdData     ,
            IRQ         => CoreIrq        ,
            CacheMiss   => CacheMiss      ,
            CoreId      => CoreId         ,
            Rst         => Rst            ,
            ClkIn       => ClkIn          ,
            WrData      => CoreWrData     ,
            PcAddress   => PcAddress      ,
            DataAddress => CoreDataAddress,
            RdWrEna     => CoreRdWrEna    ,
            Ack         => CoreAck         
           );

Cache: ENTITY WORK.CacheMemory(MainArch)
PORT MAP   (Pc            => PcAddress       ,
            RdWrAddress   => CacheDataAddress,
            WrData        => CacheWrData     ,
            RdWrEnable    => CacheRdWrEna    ,
            MemoryDataRd  => MemoryDataRd    ,
            Rst           => Rst             ,
            Clk           => ClkIn           ,
            Instruction   => Instruction     ,
            RdData        => CacheRdData     ,
            MemoryDataWr  => MemoryDataWr    ,
            MemoryAddress => MemoryAddress   ,
            MemoryRdWrEna => MemoryRdWrEna   ,
            CacheMiss     => CacheMiss        
           );

AddressSolver: ENTITY WORK.CacheAndPeripheralAddressSolver(MainArchitecture)
PORT MAP   (CoreAck          => CoreAck         ,
            CoreWrData       => CoreWrData      ,
            CoreDataAddress  => CoreDataAddress ,
            CoreRdWrEna      => CoreRdWrEna     ,
            CacheRdData      => CacheRdData     ,
            PerRdData        => PerRdData       ,
            PerIrq           => IRQ             ,
            CoreIrq          => CoreIrq         ,
            CoreRdData       => CoreRdData      ,
            CacheWrData      => CacheWrData     ,
            CacheDataAddress => CacheDataAddress,
            CacheRdWrEna     => CacheRdWrEna    ,
            PerWrData        => PerWrData       ,
            PerDataAddress   => PerDataAddress  ,
            PerRdWrEna       => PerRdWrEna      ,
            PerAck           => ACK              
           );

END ArkICoreArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ArkICore(ArkICoreArch)
--PORT MAP   (MemoryDataRd   => SLV,
--            PerRdData      => SLV,
--            CoreId         => SLV,
--            IRQ            => SLV,
--            Rst            => SLV,
--            ClkIn          => SLV,
--            MemoryDataWr   => SLV,
--            MemoryAddress  => SLV,
--            MemoryRdWrEna  => SLV,
--            PerWrData      => SLV,
--            PerDataAddress => SLV,
--            PerRdWrEna     => SLV,
--            ACK            => SLV
--           );
------------------------------------------------------------------------------------------
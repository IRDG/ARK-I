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

ENTITY AddressMemory IS
    
    PORT   (RdAddress      : IN  uint32;
            ReplaceEnaWr   : IN  uint01;
            ReplaceAddress : IN  uint32;
            Rst            : IN  uint01;
            Clk            : IN  uint01;
            SliceAddress   : OUT uint33;
            Hit            : OUT uint01 
           );
    
END ENTITY AddressMemory;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF AddressMemory IS

SIGNAL NextAddress  : uint33;
SIGNAL PrevAddress  : uint33;
SIGNAL FinalAddress : uint33;
SIGNAL ExtRdAddress : uint33;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

ExtRdAddress  <= '0' & RdAddress;

Hit           <= IsInRange(PrevAddress, ExtRdAddress, FinalAddress);

SliceAddress  <= PrevAddress;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

FinalAddress <=       PrevAddress   (32 DOWNTO FieldSize) & FinalTag   ;

NextAddress  <= '0' & ReplaceAddress(31 DOWNTO FieldSize) & StartingTag;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

AddressStorage: PROCESS(Clk, Rst, NextAddress, ReplaceEnaWr)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevAddress <= '1' & NoData;
        
    ELSIF (FALLING_EDGE(Clk)) THEN
        
        IF (ReplaceEnaWr = '1') THEN
            
            PrevAddress <= NextAddress;
            
        END IF;
        
    END IF;
    
END PROCESS AddressStorage;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.AddressMemory(MainArch)
--PORT MAP   (RdAddress      => SLV,
--            ReplaceEnaWr   => SLV,
--            ReplaceAddress => SLV,
--            Rst            => SLV,
--            Clk            => SLV,
--            SliceAddress   => SLV,
--            Hit            => SLV 
--           );
------------------------------------------------------------------------------------------
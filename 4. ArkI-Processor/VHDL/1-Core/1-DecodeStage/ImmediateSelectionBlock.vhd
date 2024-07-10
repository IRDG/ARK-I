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

ENTITY ImmediateSelectionBlock IS
    
    PORT   (ImmUData    : IN  uint20;
            ImmIData    : IN  uint12;
            ImmSDataIn  : IN  uint12;
            ImmSext     : IN  uint01;
            Format      : IN  uint02;
            ImmData     : OUT uint32;
            ImmSDataOut : OUT uint32 
           );
    
END ENTITY ImmediateSelectionBlock;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ImmediateSelectionBlock IS

CONSTANT UnsignedExtended : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => ('0'));
CONSTANT ZeroImmData      : uint32                        := (OTHERS => ('0'));

SIGNAL   SignExtendedI    : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL   SignExtendedS    : STD_LOGIC_VECTOR(19 DOWNTO 0);

SIGNAL   RealImmUData     : uint32;
SIGNAL   RealImmIData     : uint32;
SIGNAL   RealImmSData     : uint32;

BEGIN

------------------------------------------------------------
-- 
-- Set the extended values for the different formats of 
-- immediate data
-- 
------------------------------------------------------------

RealImmUData  <= ImmUData & "000000000000";

SignExtendedI <= (OTHERS => (ImmIData  (11)));

WITH ImmSext SELECT
RealImmIData  <= (SignExtendedI    & ImmIData) WHEN '1',
                 (UnsignedExtended & ImmIData) WHEN OTHERS;

SignExtendedS <= (OTHERS => (ImmSDataIn(11)));

RealImmSData  <= (SignExtendedS    & ImmSDataIn);

------------------------------------------------------------
-- 
-- Select and set both outputs
-- 
------------------------------------------------------------

ImmSDataOut <= RealImmSData;

WITH Format SELECT
ImmData <= RealImmUData WHEN "01",
           RealImmIData WHEN "10",
           RealImmSData WHEN "11",
           ZeroImmData  WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ImmediateSelectionBlock(MainArch)
--PORT MAP   (ImmUData    => SLV,
--            ImmIData    => SLV,
--            ImmSDataIn  => SLV,
--            ImmSext     => SLV,
--            Format      => SLV,
--            ImmData     => SLV,
--            ImmSDataOut => SLV
--           );
------------------------------------------------------------------------------------------
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

ENTITY InstructionRegister IS
    
    PORT   (Instruction : IN  uint32;
            ImmUData    : OUT uint20;
            ImmIData    : OUT uint12;
            ImmSData    : OUT uint12;
            RdAddress   : OUT uint05;
            Rs1Address  : OUT uint05;
            Rs2Address  : OUT uint05 
           );
    
END ENTITY InstructionRegister;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF InstructionRegister IS

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

ImmUData   <= Instruction(31 DOWNTO 12);

ImmIData   <= Instruction(31 DOWNTO 20);

ImmSData   <= Instruction(31 DOWNTO 25) & Instruction(11 DOWNTO 7);

RdAddress  <= Instruction(11 DOWNTO  7);

Rs1Address <= Instruction(19 DOWNTO 15);

Rs2Address <= Instruction(24 DOWNTO 20);

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.InstructionRegister(MainArch)
--PORT MAP   (Instruction => SLV,
--            ImmUData    => SLV,
--            ImmIData    => SLV,
--            ImmSData    => SLV,
--            RdAddress   => SLV,
--            Rs1Address  => SLV,
--            Rs2Address  => SLV
--           );
------------------------------------------------------------------------------------------
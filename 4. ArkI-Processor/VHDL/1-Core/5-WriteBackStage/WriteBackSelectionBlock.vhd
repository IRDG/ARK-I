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

ENTITY WriteBackSelectionBlock IS
    
    PORT   (AluResult : IN  uint32;
            MemData   : IN  uint32;
            ImmData   : IN  uint32;
            CsrData   : IN  uint32;
            Negative  : IN  uint01;
            PcNext    : IN  uint32;
            WbDataSrc : IN  uint03;
            WbData    : OUT uint32 
           );
    
END ENTITY WriteBackSelectionBlock;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF WriteBackSelectionBlock IS

SIGNAL SetValue : uint32;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Negative SELECT
SetValue <= x"00000000" WHEN '0',
            x"00000001" WHEN OTHERS;

WITH WbDataSrc SELECT
WbData <= CsrData     WHEN "000",
          MemData     WHEN "001",
          ImmData     WHEN "010",
          AluResult   WHEN "011",
          PcNext      WHEN "100",
          SetValue    WHEN "101",
          x"00000000" WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.WriteBackSelectionBlock(MainArch)
--PORT MAP   (AluResult => SLV,
--            MemData   => SLV,
--            ImmData   => SLV,
--            CsrData   => SLV,
--            Negative  => SLV,
--            PcNext    => SLV,
--            WbDataSrc => SLV,
--            WbData    => SLV
--           );
------------------------------------------------------------------------------------------
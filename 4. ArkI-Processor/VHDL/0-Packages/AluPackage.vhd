------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Proyect:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                       Package                                        --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;

PACKAGE AluPackage IS

TYPE    uint32Vector    IS ARRAY (0 TO 16) OF uint32;
TYPE    uint05Vector    IS ARRAY (0 TO 16) OF uint05;
TYPE    PartialProductT IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

END PACKAGE AluPackage;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

PACKAGE BODY AluPackage IS

END AluPackage;
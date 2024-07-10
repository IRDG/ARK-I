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

PACKAGE ProcessorPackage IS

CONSTANT NumberOfCores : INTEGER := 2;

TYPE uint32CoreBus IS ARRAY (0 TO NumberOfCores - 1) OF uint32;
TYPE uint04CoreBus IS ARRAY (0 TO NumberOfCores - 1) OF uint04;
TYPE uint02CoreBus IS ARRAY (0 TO NumberOfCores - 1) OF uint02;

END PACKAGE ProcessorPackage;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

PACKAGE BODY ProcessorPackage IS

END ProcessorPackage;
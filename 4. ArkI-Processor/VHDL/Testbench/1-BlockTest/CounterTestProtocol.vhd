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
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.CachePackage.ALL;

ENTITY CounterTestProtocol IS
END CounterTestProtocol;

ARCHITECTURE CounterTestProtocolArch OF CounterTestProtocol IS

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

SIGNAL Ena      : uint01      := '0';
SIGNAL Up       : uint01      := '0';
SIGNAL MR       : uint01      := '1';
SIGNAL SR       : uint01      := '0';
SIGNAL Clk      : uint01      := '1';
SIGNAL MaxCount : uint01            ;
SIGNAL Count    : CounterType       ;

BEGIN

X1: ENTITY WORK.LinearRateCounter(MainArch)
GENERIC MAP(Size => RatingCounterSize --4
           )
PORT MAP   (Ena      => Ena     ,
            Up       => Up      ,
            MR       => MR      ,
            SR       => SR      ,
            Clk      => Clk     ,
            MaxCount => MaxCount,
            Count    => Count    
           );

Clk <= NOT Clk AFTER  10 ns;

MR  <= '0'     AFTER  20 ns;

SR  <= '1'     AFTER 400 ns,
       '0'     AFTER 420 ns;

Ena <= '1'     AFTER  20 ns,
       '0'     AFTER 200 ns,
       '1'     AFTER 270 ns;

Up  <= '1'     AFTER  20 ns,
       '0'     AFTER 120 ns,
       '1'     AFTER 200 ns,
       '0'     AFTER 240 ns,
       '1'     AFTER 280 ns,
       '0'     AFTER 340 ns;

END CounterTestProtocolArch;

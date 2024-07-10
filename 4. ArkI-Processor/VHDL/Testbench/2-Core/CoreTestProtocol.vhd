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
USE IEEE.std_logic_1164.ALL  ;
USE IEEE.numeric_std.ALL     ;

USE WORK.BasicPackage.ALL    ;
USE WORK.ProcessorPackage.ALL;

ENTITY CoreTestProtocol IS
END CoreTestProtocol;

ARCHITECTURE CoreTestProtocolArch OF CoreTestProtocol IS

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

SIGNAL PerRdData      : uint32CoreBus := (x"00000000",x"00000000");
SIGNAL IRQ            : uint04CoreBus := (x"0"       , x"0"      );
SIGNAL Rst            : uint01        :=                      '1' ;
SIGNAL ClkIn          : uint01        :=                      '1' ;
SIGNAL PerWrData      : uint32CoreBus                             ;
SIGNAL PerDataAddress : uint32CoreBus                             ;
SIGNAL PerRdWrEna     : uint02CoreBus                             ;
SIGNAL ACK            : uint04CoreBus                             ;

BEGIN

X1: ENTITY WORK.ArkIProcessor(MainArch)
PORT MAP   (PerRdData      => PerRdData     ,
            IRQ            => IRQ           ,
            Rst            => Rst           ,
            ClkIn          => ClkIn         ,
            PerWrData      => PerWrData     ,
            PerDataAddress => PerDataAddress,
            PerRdWrEna     => PerRdWrEna    ,
            ACK            => ACK            
           );

ClkIn <= NOT ClkIn AFTER 10 ns;

Rst   <= '0' AFTER 20 ns;

IRQ   <= (x"1",x"0") AFTER 28440 ns,
         (x"0",x"0") AFTER 28460 ns,
         (x"1",x"0") AFTER 30020 ns,
         (x"2",x"0") AFTER 30040 ns,
         (x"4",x"0") AFTER 30060 ns,
         (x"8",x"0") AFTER 30080 ns,
         (x"0",x"0") AFTER 30100 ns;

END CoreTestProtocolArch;

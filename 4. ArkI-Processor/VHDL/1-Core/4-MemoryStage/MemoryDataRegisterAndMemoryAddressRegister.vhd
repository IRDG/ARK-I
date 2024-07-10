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

ENTITY MemoryDataRegisterAndMemoryAddressRegister IS
    
    PORT   (AddressIn    : IN  uint32;
            DataWr       : IN  uint32;
            ExcVTable    : IN  uint32;
            ExcMemRd     : IN  uint01;
            MdrOperation : IN  uint04;
            RdDataBus    : IN  uint32;
            WrDataBus    : OUT uint32;
            AddressOut   : OUT uint32;
            RdWrEna      : OUT uint02;
            DataRd       : OUT uint32;
            NewExcPc     : OUT uint32 
           );
    
END ENTITY MemoryDataRegisterAndMemoryAddressRegister;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF MemoryDataRegisterAndMemoryAddressRegister IS

CONSTANT Zero32   : uint32 :=       x"00000000";
CONSTANT Zero24   : uint24 :=         x"000000";
CONSTANT Zero16   : uint16 :=           x"0000";

SIGNAL   Control  : uint05;
SIGNAL   SextByte : uint16;
SIGNAL   SextHex  : uint24;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Control <= ExcMemRd & MdrOperation;

SextByte <= RdDataBus(15) & RdDataBus(15) & RdDataBus(15) & RdDataBus(15) &
            RdDataBus(15) & RdDataBus(15) & RdDataBus(15) & RdDataBus(15) &
            RdDataBus(15) & RdDataBus(15) & RdDataBus(15) & RdDataBus(15) &
            RdDataBus(15) & RdDataBus(15) & RdDataBus(15) & RdDataBus(15) ;

SextHex  <= RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) &
            RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) &
            RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) &
            RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) &
            RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) &
            RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) & RdDataBus( 7) ;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Control SELECT -- Wr >> Rd(1)Wr(0)
RdWrEna(0) <= '1' WHEN "01101",
              '1' WHEN "01110",
              '1' WHEN "01111",
              '0' WHEN OTHERS ;

WITH Control SELECT -- Rd >> Rd(1)Wr(0)
RdWrEna(1) <= '1' WHEN "10000",
              '1' WHEN "10001",
              '1' WHEN "10010",
              '1' WHEN "10011",
              '1' WHEN "10100",
              '1' WHEN "10101",
              '1' WHEN "10110",
              '1' WHEN "10111",
              '1' WHEN "11000",
              '1' WHEN "11001",
              '1' WHEN "11010",
              '1' WHEN "11011",
              '1' WHEN "11100",
              '1' WHEN "11101",
              '1' WHEN "11110",
              '1' WHEN "11111",
              '1' WHEN "01000",
              '1' WHEN "01001",
              '1' WHEN "01010",
              '1' WHEN "01011",
              '1' WHEN "01100",
              '0' WHEN OTHERS ;

WITH Control(4 DOWNTO 3) SELECT
AddressOut <= AddressIn WHEN "01",
              ExcVTable WHEN "10",
              ExcVTable WHEN "11",
              Zero32    WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH ExcMemRd SELECT
NewExcPc  <= (RdDataBus                        ) WHEN '1',
             (Zero32                           ) WHEN OTHERS;

WITH Control SELECT
DataRd    <= (Zero24   & RdDataBus( 7 DOWNTO 0)) WHEN "01000",
             (Zero16   & RdDataBus(15 DOWNTO 0)) WHEN "01001",
             (           RdDataBus             ) WHEN "01010",
             (SextByte & RdDataBus(15 DOWNTO 0)) WHEN "01011",
             (SextHex  & RdDataBus( 7 DOWNTO 0)) WHEN "01100",
             (Zero32                           ) WHEN OTHERS ;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Control SELECT
WrDataBus <= (           DataWr              ) WHEN "01101",
             (Zero24   & DataWr( 7 DOWNTO 0) ) WHEN "01110",
             (Zero16   & DataWr(15 DOWNTO 0) ) WHEN "01111",
             (           Zero32              ) WHEN OTHERS ;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.MemoryDataRegisterAndMemoryAddressRegister(MainArch)
--PORT MAP   (AddressIn    => SLV,
--            DataWr       => SLV,
--            ExcVTable    => SLV,
--            ExcMemRd     => SLV,
--            MdrOperation => SLV,
--            RdDataBus    => SLV,
--            WrDataBus    => SLV,
--            AddressOut   => SLV,
--            RdWrN        => SLV,
--            DataRd       => SLV,
--            NewExcPc     => SLV
--           );
------------------------------------------------------------------------------------------
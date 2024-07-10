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
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY GeneralPurposeRegisters IS
    
    PORT   (R1Address  : IN  uint05;
            R2Address  : IN  uint05;
            RdAddress  : IN  uint05;
            WbData     : IN  uint32;
            WrEna      : IN  uint01;
            DfuAddress : IN  uint05;
            DfuData    : IN  uint32;
            DfuWrEna   : IN  uint01;
            Rst        : IN  uint01;
            Clk        : IN  uint01;
            GprData1   : OUT uint32;
            GprData2   : OUT uint32 
           );
    
END ENTITY GeneralPurposeRegisters;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF GeneralPurposeRegisters IS

TYPE     Reg32 IS ARRAY (0 TO 31) OF uint32;

CONSTANT Zero             : uint32 := (OTHERS => ('0' ));
CONSTANT Empty            : Reg32  := (OTHERS => (Zero));

SIGNAL   WbEnable         : uint01              ;
SIGNAL   DfuEnable        : uint01              ;
SIGNAL   RegData          : Reg32               ;
SIGNAL   NewWbData        : uint32              ;
SIGNAL   NewDfuData       : uint32              ;
SIGNAL   WbWrAddress      : uint05              ;
SIGNAL   DfuWrAddress     : uint05              ;
SIGNAL   WrControl        : uint02              ;
SIGNAL   AddressZeroWb    : uint01              ;
SIGNAL   AddressZeroDfu   : uint01              ;
SIGNAL   R1ZeroAddress    : uint01              ;
SIGNAL   R2ZeroAddress    : uint01              ;
SIGNAL   UnsgDfuWrAddress : UNSIGNED(4 DOWNTO 0);
SIGNAL   UnsgWbWrAddress  : UNSIGNED(4 DOWNTO 0);

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WbWrAddress  <= RdAddress ;
DfuWrAddress <= DfuAddress;

WbEnable  <= '1' WHEN ((WrEna    = '1') AND (((UnsgDfuWrAddress /= UnsgWbWrAddress) AND (DfuWrEna = '1')) OR (DfuWrEna = '0'))) ELSE
             '0';

DfuEnable <= '1' WHEN ( DfuWrEna = '1'                                           ) ELSE
             '0';

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

UnsgDfuWrAddress <= UNSIGNED(DfuWrAddress);
UnsgWbWrAddress  <= UNSIGNED(WbWrAddress );

AddressZeroWb    <= '1' WHEN (UnsgWbWrAddress     = 0) ELSE
                    '0';

AddressZeroDfu   <= '1' WHEN (UnsgDfuWrAddress    = 0) ELSE
                    '0';

R1ZeroAddress    <= '1' WHEN (UNSIGNED(R1Address) = 0) ELSE
                    '0';

R2ZeroAddress    <= '1' WHEN (UNSIGNED(R2Address) = 0) ELSE
                    '0';

NewDfuData <= DfuData;
NewWbData  <= WbData ;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RegisterBlock:PROCESS(Clk, Rst, WbEnable, DfuEnable)
BEGIN
    
    IF (Rst = '1') THEN
        
        RegData <= Empty;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF ((DfuEnable = '1') AND (AddressZeroDfu = '0')) THEN
            
            RegData(Slv2Int(DfuWrAddress)) <= NewDfuData;
            
        END IF;
        
        IF ((WbEnable  = '1') AND (AddressZeroWb  = '0')) THEN
            
            RegData(Slv2Int(WbWrAddress)) <= NewWbData ;
            
        END IF;
        
    END IF;
    
END PROCESS RegisterBlock;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH R1ZeroAddress SELECT
GprData1 <= RegData(Slv2Int(R1Address)) WHEN '0',
            Zero                        WHEN OTHERS;

WITH R2ZeroAddress SELECT
GprData2 <= RegData(Slv2Int(R2Address)) WHEN '0',
            Zero                        WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.GeneralPurposeRegisters(MainArch)
--PORT MAP   (R1Address  => SLV,
--            R2Address  => SLV,
--            RdAddress  => SLV,
--            WbData     => SLV,
--            WrEna      => SLV,
--            DfuAddress => SLV,
--            DfuData    => SLV,
--            DfuWrEna   => SLV,
--            Rst        => SLV,
--            Clk        => SLV,
--            GprData1   => SLV,
--            GprData2   => SLV
--           );
------------------------------------------------------------------------------------------
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

ENTITY ControlAndStatusRegisters IS
    
    PORT   (RdAddress   : IN  uint32;
            MepcWr      : IN  uint32;
            MipWr       : IN  uint32;
            ExcMipWrEna : IN  uint01;
            WrOperation : IN  uint03;
            ExcWrEna    : IN  uint02;
            ExcData     : IN  uint32;
            ExcAddress  : IN  uint32;
            CycleMepc   : IN  uint02;
            WrAddress   : IN  uint32;
            GprData     : IN  uint32;
            ImmData     : IN  uint05;
            CoreId      : IN  uint01;
            Rst         : IN  uint01;
            Clk         : IN  uint01;
            MepcRd      : OUT uint32;
            Mtvec       : OUT uint32;
            Mnev        : OUT uint32;
            Mie         : OUT uint32;
            Mps         : OUT uint32;
            MipRd       : OUT uint32;
            CsrData     : OUT uint32 
           );
    
END ENTITY ControlAndStatusRegisters;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ControlAndStatusRegisters IS

CONSTANT MisaAddress        : uint32 := x"00000301";
CONSTANT MieAddress         : uint32 := x"00000304";
CONSTANT MtvecAddress       : uint32 := x"00000305";
CONSTANT McauseAddress      : uint32 := x"00000342";
CONSTANT MtvalAddress       : uint32 := x"00000343";
CONSTANT MipAddress         : uint32 := x"00000344";
CONSTANT MarchIdAddress     : uint32 := x"00000F12";
CONSTANT MimpIdAddress      : uint32 := x"00000F13";
CONSTANT MhartIdAddress     : uint32 := x"00000F14";
CONSTANT MpsAddress         : uint32 := x"00000FFA";
CONSTANT MnevAddress        : uint32 := x"00000FFB";
CONSTANT Mepc0Address       : uint32 := x"00000FFC";
CONSTANT Mepc1Address       : uint32 := x"00000FFD";
CONSTANT Mepc2Address       : uint32 := x"00000FFE";
CONSTANT Mepc3Address       : uint32 := x"00000FFF";



CONSTANT Zero               : uint32 := (OTHERS => ('0'));

SIGNAL   PrevMisa           : uint32;
SIGNAL   PrevMie            : uint32;
SIGNAL   NextMie            : uint32;
SIGNAL   PrevMtvec          : uint32;
SIGNAL   NextMtvec          : uint32;
SIGNAL   PrevMcause         : uint32;
SIGNAL   NextMcause         : uint32;
SIGNAL   PrevMtval          : uint32;
SIGNAL   NextMtval          : uint32;
SIGNAL   PrevMip            : uint32;
SIGNAL   NextMip            : uint32;
SIGNAL   PrevMarchid        : uint32;
SIGNAL   PrevMimpid         : uint32;
SIGNAL   PrevMhartid        : uint32;
SIGNAL   PrevMps            : uint32;
SIGNAL   NextMps            : uint32;
SIGNAL   PrevMnev           : uint32;
SIGNAL   NextMnev           : uint32;
SIGNAL   DataWrMnev         : uint32;
SIGNAL   PrevMepc0          : uint32;
SIGNAL   NextMepc0          : uint32;
SIGNAL   PrevMepc1          : uint32;
SIGNAL   NextMepc1          : uint32;
SIGNAL   PrevMepc2          : uint32;
SIGNAL   NextMepc2          : uint32;
SIGNAL   PrevMepc3          : uint32;
SIGNAL   NextMepc3          : uint32;

SIGNAL   MieAddressMode     : uint02;
SIGNAL   MtvecAddressMode   : uint02;
SIGNAL   McauseAddressMode  : uint02;
SIGNAL   MtvalAddressMode   : uint02;
SIGNAL   MipAddressMode     : uint02;
SIGNAL   MpsAddressMode     : uint02;
SIGNAL   MnevAddressMode    : uint02;
SIGNAL   Mepc0AddressMode   : uint02;

SIGNAL   MpsDataWr          : uint32;

SIGNAL   PrevRd             : uint32;
SIGNAL   NextRd             : uint32;

SIGNAL   Hart               : uint32;
SIGNAL   DataWr             : uint32;
SIGNAL   WrEna              : uint01;
SIGNAL   WrEnable           : uint01;
SIGNAL   UnsDat             : uint32;
SIGNAL   TmpNextMepc0       : uint32;
SIGNAL   Mepc0Enable        : uint03;

BEGIN

------------------------------------------------------------
-- 
-- Generate the needed hart id, depending on the core
-- ID.
-- 
------------------------------------------------------------

WITH CoreId SELECT
Hart <= x"00000000" WHEN '0',
        x"00000001" WHEN '1',
        x"FFFFFFFF" WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH WrOperation SELECT
WrEna    <= '1' WHEN "000",
            '1' WHEN "001",
            '1' WHEN "010",
            '1' WHEN "011",
            '1' WHEN "100",
            '1' WHEN "101",
            '1' WHEN "110",
            '0' WHEN "111",
            '0' WHEN OTHERS;

WrEnable <= WrEna OR ExcWrEna(1) OR ExcWrEna(0) OR CycleMepc(1) OR CycleMepc(0);

UnsDat   <= x"000000" & "000" & ImmData;

WITH WrOperation SELECT
DataWr   <= (                GprData ) WHEN "000",
            (PrevRd OR       GprData ) WHEN "001",
            (PrevRd AND (NOT GprData)) WHEN "010",
            (                UnsDat  ) WHEN "011",
            (PrevRd OR       UnsDat  ) WHEN "100",
            (PrevRd AND (NOT UnsDat )) WHEN "101",
            (Zero                    ) WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

MieAddressMode    (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MieAddress    ))ELSE
                         '0';
MtvecAddressMode  (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MtvecAddress  ))ELSE
                         '0';
McauseAddressMode (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(McauseAddress ))ELSE
                         '0';
MtvalAddressMode  (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MtvalAddress  ))ELSE
                         '0';
MipAddressMode    (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MipAddress    ))ELSE
                         '0';
MpsAddressMode    (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MpsAddress    ))ELSE
                         '0';
MnevAddressMode   (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(MnevAddress   ))ELSE
                         '0';
Mepc0AddressMode  (0) <= '1' WHEN (Slv2Int(WrAddress ) = Slv2Int(Mepc0Address  ))ELSE
                         '0';

MieAddressMode    (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MieAddress    ))ELSE
                         '0';
MtvecAddressMode  (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MtvecAddress  ))ELSE
                         '0';
McauseAddressMode (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(McauseAddress ))ELSE
                         '0';
MtvalAddressMode  (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MtvalAddress  ))ELSE
                         '0';
MipAddressMode    (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MipAddress    ))ELSE
                         '0';
MpsAddressMode    (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MpsAddress    ))ELSE
                         '0';
MnevAddressMode   (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(MnevAddress   ))ELSE
                         '0';
Mepc0AddressMode  (1) <= '1' WHEN (Slv2Int(ExcAddress) = Slv2Int(Mepc0Address  ))ELSE
                         '0';

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Mepc0Enable <= Mepc0AddressMode(0) & CycleMepc(1) & CycleMepc(0);

WITH Mepc0Enable SELECT
NextMepc0    <= PrevMepc0    WHEN "000",
                TmpNextMepc0 WHEN "001",
                TmpNextMepc0 WHEN "010",
                PrevMepc0    WHEN "011",
                DataWr       WHEN "100",
                TmpNextMepc0 WHEN "101",
                TmpNextMepc0 WHEN "110",
                DataWr       WHEN "111",
                PrevMepc0    WHEN OTHERS;

WITH CycleMepc SELECT
TmpNextMepc0 <= MepcWr       WHEN "01",
                PrevMepc1    WHEN "10",
                PrevMepc0    WHEN OTHERS;

WITH CycleMepc SELECT
NextMepc1    <= PrevMepc0    WHEN "01",
                PrevMepc2    WHEN "10",
                PrevMepc1    WHEN OTHERS;

WITH CycleMepc SELECT
NextMepc2    <= PrevMepc1    WHEN "01",
                PrevMepc3    WHEN "10",
                PrevMepc2    WHEN OTHERS;

WITH CycleMepc SELECT
NextMepc3    <= PrevMepc2    WHEN "01",
                Zero         WHEN "10",
                PrevMepc3    WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH MieAddressMode     SELECT
NextMie     <= DataWr      WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMie     WHEN OTHERS;

WITH MtvecAddressMode   SELECT
NextMtvec   <= DataWr      WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMtvec   WHEN OTHERS;

WITH MipAddressMode     SELECT
NextMip     <= DataWr      WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMip     WHEN OTHERS;


WITH McauseAddressMode  SELECT
NextMcause  <= DataWr      WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMcause  WHEN OTHERS;

WITH MtvalAddressMode   SELECT
NextMtval   <= DataWr      WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMtval   WHEN OTHERS;

WITH MpsAddressMode     SELECT
NextMps     <= MpsDataWr   WHEN "01",
               ExcData     WHEN "10",
               ExcData     WHEN "11",
               PrevMps     WHEN OTHERS;

DataWrMnev <= PrevMnev(31 DOWNTO 17) & DataWr(16 DOWNTO 4) & PrevMnev(3 DOWNTO 1) & DataWr(0);
WITH MnevAddressMode    SELECT
NextMnev     <= DataWrMnev  WHEN "01",
                ExcData     WHEN "10",
                ExcData     WHEN "11",
                PrevMnev    WHEN OTHERS;

MepcRd      <= PrevMepc0;
Mtvec       <= PrevMtvec;
Mnev        <= PrevMnev ;
Mie         <= PrevMie  ;
Mps         <= PrevMps  ;
MipRd       <= PrevMip  ;

MpsDataWr   <= DataWr;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------


PrevMisa    <= x"40001100"; -- RV32IM
PrevMarchid <= x"65827573"; -- ARKI
PrevMimpid  <= x"00000001";
PrevMhartid <=        Hart;

CSRegisters: PROCESS (Rst       , Clk      , NextMie  , NextMtvec,
                      NextMcause, NextMtval, NextMps  , NextMnev ,
                      NextMepc0 , NextMepc1, NextMepc2, NextMepc3,
                      Hart      , NextRd   , WrEnable )
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevMie     <=        Zero;
        PrevMtvec   <= x"00000008";
        PrevMcause  <=        Zero;
        PrevMtval   <=        Zero;
        PrevMps     <=        Zero;
        PrevMnev    <=        Zero;
        PrevMepc0   <=        Zero;
        PrevMepc1   <=        Zero;
        PrevMepc2   <=        Zero;
        PrevMepc3   <=        Zero;
        PrevRd      <=        Zero;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF (WrEnable = '1') THEN
            
            PrevMie     <= NextMie    ;
            PrevMtvec   <= NextMtvec  ;
            PrevMcause  <= NextMcause ;
            PrevMtval   <= NextMtval  ;
            PrevMps     <= NextMps    ;
            PrevMnev    <= NextMnev   ;
            PrevMepc0   <= NextMepc0  ;
            PrevMepc1   <= NextMepc1  ;
            PrevMepc2   <= NextMepc2  ;
            PrevMepc3   <= NextMepc3  ;
            PrevRd      <= NextRd     ;
            
        ELSE
            
            PrevMie     <= PrevMie    ;
            PrevMtvec   <= PrevMtvec  ;
            PrevMcause  <= PrevMcause ;
            PrevMtval   <= PrevMtval  ;
            PrevMps     <= PrevMps    ;
            PrevMnev    <= PrevMnev   ;
            PrevMepc0   <= PrevMepc0  ;
            PrevMepc1   <= PrevMepc1  ;
            PrevMepc2   <= PrevMepc2  ;
            PrevMepc3   <= PrevMepc3  ;
            PrevRd      <= PrevRd     ;
            
        END IF;        
    END IF;
    
END PROCESS CSRegisters;

MipRegister: PROCESS (Rst       , Clk      , NextMip)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevMip     <=        Zero;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF    (ExcMipWrEna = '1') THEN
            
            PrevMip     <= MipWr      ;
            
        ELSIF (WrEnable    = '1') THEN
            
            PrevMip     <= NextMip    ;
            
        ELSE
            
            PrevMip     <= PrevMip    ;
            
        END IF;
        
    END IF;
    
END PROCESS MipRegister;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

CsrData <= NextRd;

WITH RdAddress SELECT
NextRd <= PrevMisa    WHEN MisaAddress   ,
          PrevMie     WHEN MieAddress    ,
          PrevMtvec   WHEN MtvecAddress  ,
          PrevMcause  WHEN McauseAddress ,
          PrevMtval   WHEN MtvalAddress  ,
          PrevMip     WHEN MipAddress    ,
          PrevMarchid WHEN MarchIdAddress,
          PrevMimpid  WHEN MimpIdAddress ,
          PrevMhartid WHEN MhartIdAddress,
          PrevMps     WHEN MpsAddress    ,
          PrevMnev    WHEN MnevAddress   ,
          PrevMepc0   WHEN Mepc0Address  ,
          PrevMepc1   WHEN Mepc1Address  ,
          PrevMepc2   WHEN Mepc2Address  ,
          PrevMepc3   WHEN Mepc3Address  ,
          Zero        WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ControlAndStatusRegisters(MainArch)
--PORT MAP   (RdAddress   => SLV,
--            MepcWr      => SLV,
--            MipWr       => SLV,
--            ExcMipWrEna => SLV,
--            WrOperation => SLV,
--            ExcWrEna    => SLV,
--            ExcData     => SLV,
--            ExcAddress  => SLV,
--            CycleMepc   => SLV,
--            WrAddress   => SLV,
--            GprData     => SLV,
--            ImmData     => SLV,
--            CoreId      => SLV,
--            Rst         => SLV,
--            Clk         => SLV,
--            MepcRd      => SLV,
--            Mtvec       => SLV,
--            Mnev        => SLV,
--            Mie         => SLV,
--            Mps         => SLV,
--            MipRd       => SLV,
--            CsrData     => SLV
--           );
------------------------------------------------------------------------------------------
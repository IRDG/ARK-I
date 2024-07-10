------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Project:                                                                            --
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

USE WORK.BasicPackage.ALL  ;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY MainMemory IS
    
    PORT   (DataRd1     : IN  uint32;
            DataRd2     : IN  uint32;
            Address1    : IN  uint32;
            Address2    : IN  uint32;
            RdWrEnable1 : IN  uint02;
            RdWrEnable2 : IN  uint02;
            Clk         : IN  uint01;
            DataWr1     : OUT uint32;
            DataWr2     : OUT uint32 
           );
    
END ENTITY MainMemory;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE IpInstantiation OF MainMemory IS

COMPONENT Ram2Port
PORT (address_a : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
      address_b : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
      clock     : IN  STD_LOGIC                    ;
      data_a    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_b    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      rden_a    : IN  STD_LOGIC                    ;
      rden_b    : IN  STD_LOGIC                    ;
      wren_a    : IN  STD_LOGIC                    ;
      wren_b    : IN  STD_LOGIC                    ;
      q_a       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      q_b       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
END COMPONENT Ram2Port;

CONSTANT MaxAddress   : uint32 := x"00001000";
CONSTANT Zero         : uint12 :=      x"000";

SIGNAL   RdEna1       : uint01;
SIGNAL   RdEna2       : uint01;
SIGNAL   WrEna1       : uint01;
SIGNAL   WrEna2       : uint01;

SIGNAL   RealAddress1 : uint12;
SIGNAL   RealAddress2 : uint12;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RealAddress1 <= (Address1(11 DOWNTO 0)) WHEN (Slv2Int(Address1) < Slv2Int(MaxAddress)) ELSE
                 Zero;

RealAddress2 <= (Address2(11 DOWNTO 0)) WHEN (Slv2Int(Address2) < Slv2Int(MaxAddress)) ELSE
                 Zero;

RdEna1       <= (RdWrEnable1(1)       ) WHEN (Slv2Int(Address1) < Slv2Int(MaxAddress)) ELSE
                '0';

RdEna2       <= (RdWrEnable2(1)       ) WHEN (Slv2Int(Address1) < Slv2Int(MaxAddress)) ELSE
                '0';

WrEna1       <= (RdWrEnable1(0)       ) WHEN (Slv2Int(Address1) < Slv2Int(MaxAddress)) ELSE
                '0';

WrEna2       <= (RdWrEnable2(0)       ) WHEN (Slv2Int(Address1) < Slv2Int(MaxAddress)) ELSE
                '0';

Ram: Ram2Port
PORT MAP(address_a => RealAddress1,
         address_b => RealAddress2,
         clock     => Clk         ,
         data_a    => DataRd1     ,
         data_b    => DataRd2     ,
         rden_a    => RdEna1      ,
         rden_b    => RdEna2      ,
         wren_a    => WrEna1      ,
         wren_b    => WrEna2      ,
         q_a       => DataWr1     ,
         q_b       => DataWr2      
        );

END IpInstantiation;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.MainMemory(IpInstantiation)
--PORT MAP   (DataRd1     => SLV,
--            DataRd2     => SLV,
--            Address1    => SLV,
--            Address2    => SLV,
--            RdWrEnable1 => SLV,
--            RdWrEnable2 => SLV,
--            Clk         => SLV,
--            DataWr1     => SLV,
--            DataWr2     => SLV
--           );
------------------------------------------------------------------------------------------
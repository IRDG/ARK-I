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

ENTITY ArithmeticLogicUnit IS
    
    PORT   (Operation : IN  uint05;
            Source    : IN  uint02;
            CmpRes    : IN  uint06;
            Shamt     : IN  uint05;
            ImmData   : IN  uint32;
            GprData1  : IN  uint32;
            GprData2  : IN  uint32;
            Pc        : IN  uint32;
            Mtvec     : IN  uint32;
            ExcOp     : IN  uint04;
            AluResult : OUT uint32;
            AluFlags  : OUT uint04 
           );
    
END ENTITY ArithmeticLogicUnit;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ArithmeticLogicUnit IS

CONSTANT Zero          : uint32 := (OTHERS => '0');

SIGNAL   AluResultTemp : uint32;

SIGNAL   NumA          : uint32;
SIGNAL   NumB          : uint32;
SIGNAL   RealA         : uint32;
SIGNAL   RealB         : uint32;

SIGNAL   AddrResult    : uint32;
SIGNAL   MultResultL   : uint32;
SIGNAL   MultResultH   : uint32;
SIGNAL   DivResultQuo  : uint32;
SIGNAL   DivResultRem  : uint32;
SIGNAL   ShftResult    : uint32;
SIGNAL   ExtExcOp      : uint32;

SIGNAL   AndResult     : uint32;
SIGNAL   XorResult     : uint32;
SIGNAL   OrResult      : uint32;

SIGNAL   ShiftCtrl     : uint02;
SIGNAL   AdderCtrl     : uint01;

SIGNAL   RealShamt     : uint05;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Source SELECT
NumA  <= Pc       WHEN "01",
         GprData1 WHEN "10",
         GprData1 WHEN "11",
         Zero     WHEN OTHERS;

WITH Source SELECT
NumB  <= ImmData  WHEN "01",
         ImmData  WHEN "10",
         GprData2 WHEN "11",
         Zero     WHEN OTHERS;

WITH ExcOp(0) SELECT
RealA <= NumA     WHEN '0',
         Mtvec    WHEN '1',
         Zero     WHEN OTHERS;

WITH ExcOp(0) SELECT
RealB <= NumB     WHEN '0',
         ExtExcOp WHEN '1',
         Zero     WHEN OTHERS;

ExtExcOp <= x"0000000" & "0" & ExcOp(3 DOWNTO 1);

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH Operation SELECT
ShiftCtrl <= "00" WHEN "10000", -- Sign Unextended Right Shift
             "01" WHEN "10001", -- Sign   Extended Right Shift
             "10" WHEN "10010", --                 Left  Shift
             "00" WHEN "10100", -- Sign Unextended Right Shift immediate
             "01" WHEN "10101", -- Sign   Extended Right Shift immediate
             "10" WHEN "10110", --                 Left  Shift immediate
             "11" WHEN OTHERS ;

WITH Operation SELECT
AdderCtrl <= '0' WHEN "00100",
             '1' WHEN "00110",
             '1' WHEN "00111",
             '0' WHEN OTHERS ;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

DivResultQuo <= Zero;
DivResultRem <= Zero;

LogicGenerator: FOR I IN 0 TO 31 GENERATE
    
    AndResult(I) <= RealA(I) AND RealB(I);
    OrResult (I) <= RealA(I) OR  RealB(I);
    XorResult(I) <= RealA(I) XOR RealB(I);
    
END GENERATE LogicGenerator;

WITH Operation SELECT
RealShamt <= GprData2(4 DOWNTO 0) WHEN "10000", -- Sign Unextended Right Shift
             GprData2(4 DOWNTO 0) WHEN "10001", -- Sign   Extended Right Shift
             GprData2(4 DOWNTO 0) WHEN "10010", --                 Left  Shift
             Shamt                WHEN "10100", -- Sign Unextended Right Shift immediate
             Shamt                WHEN "10101", -- Sign   Extended Right Shift immediate
             Shamt                WHEN "10110", --                 Left  Shift immediate
             "00000"              WHEN OTHERS ;


Shft: ENTITY WORK.Shifter(MainArch)
PORT MAP   (Input    => RealA,
            Shamt    => RealShamt,
            ArithRlN => ShiftCtrl,
            Output   => ShftResult
           );

Mult: ENTITY WORK.Multiplier(FullCombinatory)
PORT MAP   (A        => RealA,
            B        => RealB,
            ResultL  => MultResultL,
            ResultH  => MultResultH,
            Overflow => OPEN
           );

AddSub: ENTITY WORK.AdderSubtractor(MainArch)
GENERIC MAP(Size     => 32
           )
PORT MAP   (NumA     => RealA,
            NumB     => RealB,
            Subtract => AdderCtrl,
            Result   => AddrResult,
            Overflow => OPEN
           );

------------------------------------------------------------
-- 
-- 
-- 
-- AluFlags(0) -> Negative
-- AluFlags(1) -> Zero
-- AluFlags(2) -> Parity
-- AluFlags(3) -> Carry
-- 
------------------------------------------------------------

AluFlags(0)   <= AluResultTemp(31);
AluFlags(1)   <= '0';
AluFlags(2)   <= '0';
AluFlags(3)   <= '0';

WITH Operation SELECT
AluResultTemp <= AddrResult   WHEN "00100",
                 AddrResult   WHEN "00110",
                 AddrResult   WHEN "00111",
                 DivResultQuo WHEN "01101",
                 DivResultQuo WHEN "01100",
                 DivResultRem WHEN "01111",
                 DivResultRem WHEN "01110",
                 MultResultH  WHEN "01011",
                 MultResultH  WHEN "01010",
                 MultResultH  WHEN "01000",
                 MultResultL  WHEN "11000",
                 ShftResult   WHEN "10010",
                 ShftResult   WHEN "10001",
                 ShftResult   WHEN "10000",
                 ShftResult   WHEN "10110",
                 ShftResult   WHEN "10101",
                 ShftResult   WHEN "10100",
                 AndResult    WHEN "00000",
                 XorResult    WHEN "00010",
                 OrResult     WHEN "00001",
                 Zero         WHEN OTHERS ;


WITH ExcOp(0) SELECT
AluResult     <= AddrResult    WHEN '1',
                 AluResultTemp WHEN OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ArithmeticLogicUnit(MainArch)
--PORT MAP   (Operation => SLV,
--            Source    => SLV,
--            CmpRes    => SLV,
--            Shamt     => SLV,
--            ImmData   => SLV,
--            GprData1  => SLV,
--            GprData2  => SLV,
--            Pc        => SLV,
--            Mtvec     => SLV,
--            ExcOp     => SLV,
--            AluResult => SLV,
--            AluFlags  => SLV
--           );
------------------------------------------------------------------------------------------
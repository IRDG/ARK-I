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
USE WORK.AluPackage  .ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY Multiplier IS
    
    PORT   (A        : IN  uint32;
            B        : IN  uint32;
            ResultL  : OUT uint32;
            ResultH  : OUT uint32;
            Overflow : OUT STD_LOGIC
           );
    
END ENTITY Multiplier;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE FullCombinatory OF Multiplier IS

TYPE   AdderInputAT    IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(30 DOWNTO  0);
TYPE   AdderInputBT    IS ARRAY (0 TO  7) OF STD_LOGIC_VECTOR(30 DOWNTO  0);
TYPE   AdderInputCT    IS ARRAY (0 TO  3) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   AdderInputDT    IS ARRAY (0 TO  1) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   AdderInputET    IS ARRAY (0 TO  0) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   AdderInputFT    IS ARRAY (0 TO  0) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   PartialSumAT    IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(30 DOWNTO  0);
TYPE   PartialSumBT    IS ARRAY (0 TO  7) OF STD_LOGIC_VECTOR(30 DOWNTO  0);
TYPE   PartialSumCT    IS ARRAY (0 TO  3) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   PartialSumDT    IS ARRAY (0 TO  1) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   PartialSumET    IS ARRAY (0 TO  0) OF STD_LOGIC_VECTOR(31 DOWNTO  0);
TYPE   PartialSumFT    IS ARRAY (0 TO  0) OF STD_LOGIC_VECTOR(31 DOWNTO  0);

TYPE InputC IS RECORD
    
    A    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    B    : STD_LOGIC;
    C    : STD_LOGIC;
    
END RECORD InputC;

TYPE ExtraC IS RECORD
    
    A    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    B    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    C    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
END RECORD ExtraC;

TYPE   InputExtraAT    IS ARRAY (0 TO 7) OF STD_LOGIC;
TYPE   InputExtraBT    IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR( 1 DOWNTO  0);
TYPE   InputExtraCT    IS ARRAY (0 TO 1) OF InputC;
TYPE   InputExtraDT    IS ARRAY (0 TO 0) OF STD_LOGIC_VECTOR( 1 DOWNTO  0);
TYPE   PartialExtraAT  IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR( 1 DOWNTO  0);
TYPE   PartialExtraBT  IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR( 2 DOWNTO  0);
TYPE   PartialExtraCT  IS ARRAY (0 TO 1) OF ExtraC;
TYPE   PartialExtraDT  IS ARRAY (0 TO 0) OF STD_LOGIC_VECTOR( 2 DOWNTO  0);

SIGNAL PP           : PartialProductT;

SIGNAL AdderAInput1 : AdderInputAT;
SIGNAL AdderBInput1 : AdderInputBT;
SIGNAL AdderCInput1 : AdderInputCT;
SIGNAL AdderDInput1 : AdderInputDT;
SIGNAL AdderEInput1 : AdderInputET;
SIGNAL AdderFInput1 : AdderInputFT;

SIGNAL AdderAInput2 : AdderInputAT;
SIGNAL AdderBInput2 : AdderInputBT;
SIGNAL AdderCInput2 : AdderInputCT;
SIGNAL AdderDInput2 : AdderInputDT;
SIGNAL AdderEInput2 : AdderInputET;
SIGNAL AdderFInput2 : AdderInputFT;

SIGNAL PsA          : PartialSumAT;
SIGNAL CPsA         : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PsB          : PartialSumBT;
SIGNAL CPsB         : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL PsC          : PartialSumCT;
SIGNAL CPsC         : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL PsD          : PartialSumDT;
SIGNAL CPsD         : STD_LOGIC_VECTOR( 1 DOWNTO 0);
SIGNAL PsE          : PartialSumET;
SIGNAL CPsE         : STD_LOGIC;
SIGNAL PsF          : PartialSumFT;
SIGNAL CPsF         : STD_LOGIC;

SIGNAL ExtraAInput1 : InputExtraAT;
SIGNAL ExtraBInput1 : InputExtraBT;
SIGNAL ExtraCInput1 : InputExtraCT;
SIGNAL ExtraDInput1 : InputExtraDT;

SIGNAL ExtraAInput2 : InputExtraAT;
SIGNAL ExtraBInput2 : InputExtraBT;
SIGNAL ExtraCInput2 : InputExtraCT;
SIGNAL ExtraDInput2 : InputExtraDT;

SIGNAL PeA          : PartialExtraAT;
SIGNAL PeB          : PartialExtraBT;
SIGNAL PeC          : PartialExtraCT;
SIGNAL PeD          : PartialExtraDT;

BEGIN

----------------------------------------------------------
-- 
-- Calculate partial products
-- 
----------------------------------------------------------

PartProd: ENTITY WORK.PartialProduct(MainArch)
PORT MAP   (A  => A,
            B  => B,
            PP => PP
           );

----------------------------------------------------------
-- 
-- Set the neccesary bits for each partial sum input
-- 
-- The first sum uses most of the partial products (PP)
-- and then its results are added gradually.
-- 
-- The idea is to take as many bits per operation as
-- possible, therefore from the second sum onwwards 
-- 
-- As the first three layers of FullAdderHalfAdder are described
-- using a FOR GENERATE sentence, their input here is
-- also described using the same structure
-- 
----------------------------------------------------------

AdderInputA: FOR I IN 0 TO 15 GENERATE
    
    AdderAInput1(I) <= PP((2 * I)    )(31 DOWNTO 1);
    AdderAInput2(I) <= PP((2 * I) + 1)(30 DOWNTO 0);
    
END GENERATE AdderInputA;

AdderInputB: FOR I IN 0 TO 7 GENERATE
    
    AdderBInput1(I) <= (PP ((4 * I) + 1)(          31)) &
                       (PsA((2 * I)    )(30 DOWNTO  2)) &
                       (PsA((2 * I)    )(           1));
    
    AdderBInput2(I) <= (PsA((2 * I) + 1)(          29)) &
                       (PsA((2 * I) + 1)(28 DOWNTO  0)) &
                       (PP ((4 * I) + 2)(           0));
    
END GENERATE AdderInputB;

AdderInputC: FOR I IN 0 TO 3 GENERATE
    
    AdderCInput1(I) <= (PeA(( 2 * I)    )              ) &
                       (PsA(( 4 * I) + 1)(          30)) &
                       (PsB(( 2 * I)    )(30 DOWNTO  4)) &
                       (PsB(( 2 * I)    )(           3)) &
                       (PsB(( 2 * I)    )(           2));
    
    AdderCInput2(I) <= (PsB(( 2 * I) + 1)(29 DOWNTO 28)) &
                       (PsB(( 2 * I) + 1)(          27)) &
                       (PsB(( 2 * I) + 1)(26 DOWNTO  0)) &
                       (PsA(( 4 * I) + 2)(           0)) &
                       (PP (( 8 * I) + 4)(           0));
    
END GENERATE AdderInputC;

AdderInputD: FOR I IN 0 TO 1 GENERATE
    
    AdderDInput1(I) <= (PeA(( 4 * I) + 1)              ) &
                       (PeB(( 2 * I)    )( 1 DOWNTO  0)) &
                       (PsC(( 2 * I)    )(31 DOWNTO  8)) &
                       (PsC(( 2 * I)    )( 7 DOWNTO  6)) &
                       (PsC(( 2 * I)    )(           5)) &
                       (PsC(( 2 * I)    )(           4));
    
    AdderDInput2(I) <= (PsC(( 2 * I) + 1)(27 DOWNTO 26)) &
                       (PsC(( 2 * I) + 1)(25 DOWNTO 24)) &
                       (PsC(( 2 * I) + 1)(23 DOWNTO  0)) &
                       (PsB(( 4 * I) + 2)( 1 DOWNTO  0)) &
                       (PsA(( 8 * I) + 4)(           0)) &
                       (PP ((16 * I) + 8)(           0));
    
END GENERATE AdderInputD;

AdderEInput1(0) <= (PeA ( 3)  (           1)) &
                   (PeC ( 0).C(           0)) &
                   (PeB ( 1)  (           1)) &
                   (PeC ( 1).B(           0)) &
                   (PsC ( 1)  (31 DOWNTO 30)) &
                   (PeC ( 0).A( 1 DOWNTO  0)) &
                   (PsD ( 0)  (31 DOWNTO 16)) &
                   (PsD ( 0)  (15 DOWNTO 12)) &
                   (PsD ( 0)  (11 DOWNTO 10)) &
                   (PsD ( 0)  (           9)) &
                   (PsD ( 0)  (           8));

AdderEInput2(0) <= (PsD ( 1)  (          23)) &
                   (PsD ( 1)  (          22)) &
                   (PsD ( 1)  (          21)) &
                   (PsD ( 1)  (          20)) &
                   (PsD ( 1)  (19 DOWNTO 18)) &
                   (PsD ( 1)  (17 DOWNTO 16)) &
                   (PsD ( 1)  (15 DOWNTO  0)) &
                   (PsC ( 2)  ( 3 DOWNTO  0)) &
                   (PsB ( 4)  ( 1 DOWNTO  0)) &
                   (PsA ( 8)  (           0)) &
                   (PP  (16)  (           0));

AdderFInput1(0) <= (PeA ( 7)  (           1)) &
                   (PeC ( 1).C(           0)) &
                   (PeB ( 3)  (           1)) &
                   (PeC ( 1).B(           0)) &
                   (PsC ( 3)  (31 DOWNTO 30)) &
                   (PeC ( 1).A( 1 DOWNTO  0)) &
                   (PsD ( 1)  (31 DOWNTO 26)) &
                   (PeD ( 0)  ( 1 DOWNTO  0)) &
                   (PsE ( 0)  (31 DOWNTO 16));

AdderFInput2(0) <= (PeC ( 1).C(           1)) &
                   ('0'                     ) &
                   (PeC ( 1).B(           1)) &
                   ("00"                    ) &
                   (PeC ( 1).A(           2)) &
                   ('0'                     ) &
                   (CPsD( 1)                ) &
                   ('0'                     ) &
                   (PeB ( 2)  (           2)) &
                   ('0'                     ) &
                   (CPsC( 2)                ) &
                   ('0'                     ) &
                   (PeD ( 0)  (           2)) &
                   ('0'                     ) &
                   (CPsE                    ) &
                   (PeC ( 0).C(           1)) &
                   ('0'                     ) &
                   (PeC ( 0).B(           1)) &
                   ("00"                    ) &
                   (PeC ( 0).A(           2)) &
                   ('0'                     ) &
                   (CPsD( 1)                ) &
                   ('0'                     ) &
                   (PeB ( 0)  (           2)) &
                   ('0'                     ) &
                   (CPsC( 3)                ) &
                   ("00"                    ) &
                   (CPsB( 0)                ) &
                   (CPsA( 0)                ) ;

----------------------------------------------------------
-- 
-- Set the neccesary bits for each partial extra sum input
-- 
----------------------------------------------------------

ExtraAdderInputA: FOR I IN 0 TO 7 GENERATE
    
    ExtraAInput1(I)   <= (PP  ((4 * I) + 3)(          31));
    ExtraAInput2(I)   <= (CPsA((2 * I) + 1)              );
    
END GENERATE ExtraAdderInputA;

ExtraAdderInputB: FOR I IN 0 TO 3 GENERATE
    
    ExtraBInput1(I)   <= (PsA ((4 * I) + 3)(          30)) &
                         (PsB ((2 * I) + 1)(          30));
    
    ExtraBInput2(I)   <= (CPsB((2 * I) + 1)              ) &
                         (CPsA((4 * I) + 2)              );
    
END GENERATE ExtraAdderInputB;

ExtraAdderInputC: FOR I IN 0 TO 1 GENERATE
    
    ExtraCInput1(I).A <= (PsC ((2 * I) + 1)(29 DOWNTO 28));
    ExtraCInput2(I).A <= (CPsB((4 * I) + 2)              ) &
                         (CPsA((8 * I) + 4)              );
    
    ExtraCInput1(I).B <= (PeB ((2 * I) + 1)(           0));
    ExtraCInput2(I).B <= (CPsC((2 * I) + 1)              );
    
    ExtraCInput1(I).C <= (PeA ((4 * I) + 3)(           0));
    ExtraCInput2(I).C <= (PeB ((2 * I) + 1)(           2));
    
END GENERATE ExtraAdderInputC;

ExtraDInput1(0) <= PsD(1)(25 DOWNTO 24);
ExtraDInput2(0) <= CPsB(4) & CPsA(8);

----------------------------------------------------------
-- 
-- Calculate partial sums
-- 
-- Each layer calculate a sum of partial products and/or 
-- prevoisly calculated partial sums or even extra sums 
-- described after this section
-- 
-- The idea is to do as many parallel sums as possible 
-- to accelerate the process
-- 
----------------------------------------------------------

FirstSumLayer: FOR I IN 0 TO 15 GENERATE
    
    AdderA: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 31
               )
    PORT MAP   (NumA     => AdderAInput1(I),
                NumB     => AdderAInput2(I),
                CarryIn  => '0',
                Result   => PsA(I),
                CarryOut => CPsA(I)
               );
    
END GENERATE FirstSumLayer;

SecondSumLayer: FOR I IN 0 TO 7 GENERATE
    
    AdderB: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 31
               )
    PORT MAP   (NumA     => AdderBInput1(I),
                NumB     => AdderBInput2(I),
                CarryIn  => '0',
                Result   => PsB(I),
                CarryOut => CPsB(I)
               );
    
END GENERATE SecondSumLayer;

ThirdSumLayer: FOR I IN 0 TO 3 GENERATE
    
    AdderC: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 32
               )
    PORT MAP   (NumA     => AdderCInput1(I),
                NumB     => AdderCInput2(I),
                CarryIn  => '0',
                Result   => PsC(I),
                CarryOut => CPsC(I)
               );
    
END GENERATE ThirdSumLayer;

FourthSumLayer: FOR I IN 0 TO 1 GENERATE
    
    AdderD: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 32
               )
    PORT MAP   (NumA     => AdderDInput1(I),
                NumB     => AdderDInput2(I),
                CarryIn  => '0',
                Result   => PsD(I),
                CarryOut => CPsD(I)
               );
    
END GENERATE FourthSumLayer;

AdderE: ENTITY WORK.Adder(CarryLookAhead)
GENERIC MAP(Size     => 32
           )
PORT MAP   (NumA     => AdderEInput1(0),
            NumB     => AdderEInput2(0),
            CarryIn  => '0',
            Result   => PsE(0),
            CarryOut => CPsE
           );

AdderF: ENTITY WORK.Adder(CarryLookAhead)
GENERIC MAP(Size     => 32
           )
PORT MAP   (NumA     => AdderFInput1(0),
            NumB     => AdderFInput2(0),
            CarryIn  => '0',
            Result   => PsF(0),
            CarryOut => CPsF
           );

----------------------------------------------------------
-- 
-- Calculate extra sums
-- 
----------------------------------------------------------

FirstExtraSumLayer: FOR I IN 0 TO 7 GENERATE
    
    ExtraA: ENTITY WORK.FullAdderHalfAdder(HalfAdder)
    PORT MAP   (A    => ExtraAInput1(I),
                B    => ExtraAInput2(I),
                Cin  => '0',
                R    => PeA(I)(0),
                Cout => PeA(I)(1)
               );
    
END GENERATE FirstExtraSumLayer;

SecondExtraLayer: FOR I IN 0 TO 3 GENERATE
    
    ExtraB: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 2
               )
    PORT MAP   (NumA     => ExtraBInput1(I),
                NumB     => ExtraBInput2(I),
                CarryIn  => '0',
                Result   => PeB(I)(1 DOWNTO 0),
                CarryOut => PeB(I)(2)
               );
    
END GENERATE SecondExtraLayer;

ThirdExtraLayer: FOR I IN 0 TO 1 GENERATE
    
    ExtraCA: ENTITY WORK.Adder(CarryLookAhead)
    GENERIC MAP(Size     => 2
               )
    PORT MAP   (NumA     => ExtraCInput1(I).A,
                NumB     => ExtraCInput2(I).A,
                CarryIn  => '0',
                Result   => PeC(I).A(1 DOWNTO 0),
                CarryOut => PeC(I).A(2)
               );
    
    ExtraCB: ENTITY WORK.FullAdderHalfAdder(HalfAdder)
    PORT MAP   (A    => ExtraCInput1(I).B,
                B    => ExtraCInput2(I).B,
                Cin  => '0',
                R    => PeC(I).B(0),
                Cout => PeC(I).B(1)
               );
    
    ExtraCC: ENTITY WORK.FullAdderHalfAdder(HalfAdder)
    PORT MAP   (A    => ExtraCInput1(I).C,
                B    => ExtraCInput2(I).C,
                Cin  => '0',
                R    => PeC(I).C(0),
                Cout => PeC(I).C(1)
               );
    
END GENERATE ThirdExtraLayer;

ExtraD: ENTITY WORK.Adder(CarryLookAhead)
GENERIC MAP(Size     => 2
           )
PORT MAP   (NumA     => ExtraDInput1(0),
            NumB     => ExtraDInput2(0),
            CarryIn  => '0',
            Result   => PeD(0)(1 DOWNTO 0),
            CarryOut => PeD(0)(2)
           );

----------------------------------------------------------
-- 
-- Set the result signals to the High and Low outputs
-- 
----------------------------------------------------------

ResultL( 0) <= PP (0)( 0);
ResultL( 1) <= PsA(0)( 0);
ResultL( 2) <= PsB(0)( 0);
ResultL( 3) <= PsB(0)( 1);
ResultL( 4) <= PsC(0)( 0);
ResultL( 5) <= PsC(0)( 1);
ResultL( 6) <= PsC(0)( 2);
ResultL( 7) <= PsC(0)( 3);
ResultL( 8) <= PsD(0)( 0);
ResultL( 9) <= PsD(0)( 1);
ResultL(10) <= PsD(0)( 2);
ResultL(11) <= PsD(0)( 3);
ResultL(12) <= PsD(0)( 4);
ResultL(13) <= PsD(0)( 5);
ResultL(14) <= PsD(0)( 6);
ResultL(15) <= PsD(0)( 7);
ResultL(16) <= PsE(0)( 0);
ResultL(17) <= PsE(0)( 1);
ResultL(18) <= PsE(0)( 2);
ResultL(19) <= PsE(0)( 3);
ResultL(20) <= PsE(0)( 4);
ResultL(21) <= PsE(0)( 5);
ResultL(22) <= PsE(0)( 6);
ResultL(23) <= PsE(0)( 7);
ResultL(24) <= PsE(0)( 8);
ResultL(25) <= PsE(0)( 9);
ResultL(26) <= PsE(0)(10);
ResultL(27) <= PsE(0)(11);
ResultL(28) <= PsE(0)(12);
ResultL(29) <= PsE(0)(13);
ResultL(30) <= PsE(0)(14);
ResultL(31) <= PsE(0)(15);

ResultH( 0) <= PsF(0)( 0);
ResultH( 1) <= PsF(0)( 1);
ResultH( 2) <= PsF(0)( 2);
ResultH( 3) <= PsF(0)( 3);
ResultH( 4) <= PsF(0)( 4);
ResultH( 5) <= PsF(0)( 5);
ResultH( 6) <= PsF(0)( 6);
ResultH( 7) <= PsF(0)( 7);
ResultH( 8) <= PsF(0)( 8);
ResultH( 9) <= PsF(0)( 9);
ResultH(10) <= PsF(0)(10);
ResultH(11) <= PsF(0)(11);
ResultH(12) <= PsF(0)(12);
ResultH(13) <= PsF(0)(13);
ResultH(14) <= PsF(0)(14);
ResultH(15) <= PsF(0)(15);
ResultH(16) <= PsF(0)(16);
ResultH(17) <= PsF(0)(17);
ResultH(18) <= PsF(0)(18);
ResultH(19) <= PsF(0)(19);
ResultH(20) <= PsF(0)(20);
ResultH(21) <= PsF(0)(21);
ResultH(22) <= PsF(0)(22);
ResultH(23) <= PsF(0)(23);
ResultH(24) <= PsF(0)(24);
ResultH(25) <= PsF(0)(25);
ResultH(26) <= PsF(0)(26);
ResultH(27) <= PsF(0)(27);
ResultH(28) <= PsF(0)(28);
ResultH(29) <= PsF(0)(29);
ResultH(30) <= PsF(0)(30);
ResultH(31) <= PsF(0)(31);

Overflow    <= CPsF;

END FullCombinatory;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.Multiplier(FullCombinatory)
--PORT MAP   (A        => SLV,
--            B        => SLV,
--            ResultL  => SLV,
--            ResultH  => SLV,
--            Overflow => SLV
--           );
------------------------------------------------------------------------------------------
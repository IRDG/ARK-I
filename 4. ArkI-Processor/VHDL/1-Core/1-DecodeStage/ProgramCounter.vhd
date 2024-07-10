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

ENTITY ProgramCounter IS
    
    PORT   (ImmData    : IN  uint32;
            NewPc      : IN  uint32;
            MePcRd     : IN  uint32;
            EnaLoad    : IN  uint01;
            EnaLoadMS  : IN  uint01;
            AluResult  : IN  uint32;
            NewExcPc   : IN  uint32;
            PcMode     : IN  uint02;
            ExcPcWrEna : IN  uint01;
            CoreId     : IN  uint01;
            Rst        : IN  uint01;
            Clk        : IN  uint01;
            Pc         : OUT uint32;
            NextPc     : OUT uint32;
            PcPlusImm  : OUT uint32 
           );
    
END ENTITY ProgramCounter;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF ProgramCounter IS

SIGNAL FinalEnaLoad   : uint01;
SIGNAL RealEnaLoad    : uint02;

SIGNAL PcTmp          : uint32;
SIGNAL PcNext         : uint32;
SIGNAL StdNextPc      : UNSIGNED(31 DOWNTO 0);
SIGNAL BpuNextPc      : UNSIGNED(31 DOWNTO 0);
SIGNAL PcNextCounter  : UNSIGNED(31 DOWNTO 0);
SIGNAL PcCounter      : UNSIGNED(31 DOWNTO 0);

SIGNAL DataLoad       : uint32;
SIGNAL PLoad          : uint01;
SIGNAL EnableSelector : uint04;
SIGNAL Enable         : uint01;

SIGNAL PcInitValue    : uint32;

BEGIN

------------------------------------------------------------
-- 
-- Connect the intermediate signals to the output ports
-- 
-- Enable the counter in all cases, except when the PC is in
-- stall mode
-- 
------------------------------------------------------------

Pc             <= PcTmp ;
NextPc         <= PcNext;

RealEnaLoad    <= EnaLoad  & EnaLoadMS;
FinalEnaLoad   <= EnaLoad OR EnaLoadMS;
EnableSelector <= PcMode & FinalEnaLoad & ExcPcWrEna;

WITH EnableSelector SELECT
Enable <= '0' WHEN "0000",
          '1' WHEN "0100",
          '1' WHEN "1000",
          '1' WHEN "1100",
          '1' WHEN "0010",
          '1' WHEN "0110",
          '1' WHEN "1010",
          '1' WHEN "1110",
          '1' WHEN "0001",
          '1' WHEN "0011",
          '1' WHEN "0101",
          '1' WHEN "0111",
          '1' WHEN "1001",
          '1' WHEN "1011",
          '1' WHEN "1101",
          '1' WHEN "1111",
          '0' WHEN OTHERS;

------------------------------------------------------------
-- 
-- Generate the needed initial values, depending on the core
-- ID
-- 
------------------------------------------------------------

WITH CoreId SELECT
PcInitValue <= Core1PcInitValue WHEN '0',
               Core2PcInitValue WHEN '1',
               x"00000020"      WHEN OTHERS;

------------------------------------------------------------
-- 
-- A three layer of multiplexers is used to select the value
-- of the next program counter, usually that value is 
-- selected by the signal PcMode, however when the branch
-- predicting unit (BPU) needs to upload a value it has
-- priority.
-- 
-- But there is one case that has the highest priority of
-- all, when it comes to write a value to the PC, and that
-- is when an exception happens, in whic case the PC takes
-- the value from the NewExcPc signal.
-- 
------------------------------------------------------------

WITH PcMode SELECT
StdNextPc     <= PcCounter           WHEN "00",
                 PcCounter + 1       WHEN "01",
                 UNSIGNED(AluResult) WHEN "10",
                 UNSIGNED(MePcRd   ) WHEN "11",
                 PcCounter           WHEN OTHERS;

WITH RealEnaLoad SELECT
BpuNextPc     <= UNSIGNED(NewPc)     WHEN "10",
                 UNSIGNED(AluResult) WHEN "01",
                 UNSIGNED(NewPc)     WHEN "11",
                 StdNextPc           WHEN OTHERS;

WITH ExcPcWrEna SELECT
PcNextCounter <= UNSIGNED(NewExcPc)  WHEN '1',
                 BpuNextPc           WHEN OTHERS;

------------------------------------------------------------
-- 
-- This process generates the needed flip flops to store the
-- PC value.
-- 
------------------------------------------------------------

Counting:PROCESS(Clk, Rst, Enable, PcInitValue, PcNextCounter)
BEGIN
    
    IF(Rst = '1') THEN
        
        PcCounter <= UNSIGNED(PcInitValue);
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF(Enable = '1')THEN
            
            PcCounter <= PcNextCounter;
            
        END IF;
        
    END IF;
    
END PROCESS Counting;

------------------------------------------------------------
-- 
-- As the PC registers are used in UNSIGNED type, is
-- necessary to cast them back to STD_LOGIC_VECTOR
-- 
------------------------------------------------------------

PcTmp  <= STD_LOGIC_VECTOR(PcCounter    );
PcNext <= STD_LOGIC_VECTOR(PcNextCounter);

------------------------------------------------------------
-- 
-- Later on the core needs the vcalue of the current PC
-- added to the ImmData, therefore a 32 bit adder is
-- summoned to do said operation as quickly as possible
-- 
------------------------------------------------------------

ImmAdder: ENTITY WORK.Adder(CarryLookAhead)
GENERIC MAP(Size     => 32
           )
PORT MAP   (NumA     => ImmData,
            NumB     => PcTmp,
            CarryIn  => '0',
            Result   => PcPlusImm,
            CarryOut => OPEN
           );

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.ProgramCounter(MainArch)
--PORT MAP   (ImmData    => SLV,
--            NewPc      => SLV,
--            MePcRd     => SLV,
--            EnaLoad    => SLV,
--            EnaLoadMS  => SLV,
--            AluResult  => SLV,
--            NewExcPc   => SLV,
--            PcMode     => SLV,
--            ExcPcWrEna => SLV,
--            CoreId     => SLV,
--            Rst        => SLV,
--            Clk        => SLV,
--            Pc         => SLV,
--            NextPc     => SLV,
--            PcPlusImm  => SLV
--           );
------------------------------------------------------------------------------------------
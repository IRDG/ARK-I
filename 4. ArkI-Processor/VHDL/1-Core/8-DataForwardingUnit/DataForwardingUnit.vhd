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

ENTITY DataForwardingUnit IS
    
    PORT   (DfuDataIn       : IN  DfuInBusT  ;
            DfuMode         : IN  uint01     ;
            CacheMiss       : IN  uint01     ;
            GprAddress      : IN  RegAddressT;
            WbDataSrc       : IN  uint03     ;
            DsOpCode        : IN  uint05     ;
            PipelineMode    : IN  uint01     ;
            Rst             : IN  uint01     ;
            Clk             : IN  uint01     ;
            DfuDataOut      : OUT DfuOutBusT ;
            DisablePipeline : OUT uint01     ;
            DataDependency  : OUT uint01      
           );
    
END ENTITY DataForwardingUnit;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF DataForwardingUnit IS



CONSTANT ZeroReg : DfuRegT := (RS => (Pc  => (OTHERS => '0'),
                                      Rs1 => (OTHERS => '0'),
                                      Rs2 => (OTHERS => '0'),
                                      Rd  => (OTHERS => '0') 
                                     ),
                               AS => (Pc  => (OTHERS => '0'),
                                      Rs1 => (OTHERS => '0'),
                                      Rs2 => (OTHERS => '0'),
                                      Rd  => (OTHERS => '0') 
                                     ),
                               MS => (Pc  => (OTHERS => '0'),
                                      Rs1 => (OTHERS => '0'),
                                      Rs2 => (OTHERS => '0'),
                                      Rd  => (OTHERS => '0') 
                                     ) 
                              );

SIGNAL   PrevReg        : DfuRegT;
SIGNAL   NextReg        : DfuRegT;
SIGNAL   Rs1DepDsToRs   : uint01 ;
SIGNAL   Rs2DepDsToRs   : uint01 ;
SIGNAL   Rs1DepDsToAs   : uint01 ;
SIGNAL   Rs2DepDsToAs   : uint01 ;
SIGNAL   Rs1DepRsToAs   : uint01 ;
SIGNAL   Rs2DepRsToAs   : uint01 ;
SIGNAL   RsDependency   : uint01 ;
SIGNAL   DsDependency   : uint01 ;
SIGNAL   PrevDependency : uint01 ;
SIGNAL   NextDependency : uint01 ;
SIGNAL   FinalDep       : uint01 ;
SIGNAL   WrData         : uint32 ;
SIGNAL   ValidOpCode    : uint01 ;

SIGNAL   DfuActive      : uint01 ;
SIGNAL   PrevDfuActive  : uint01 ;
SIGNAL   NextDfuActive  : uint01 ;

BEGIN

------------------------------------------------------------
-- 
-- Ignore Load isntructions, as these cannot be forwarded
-- 
------------------------------------------------------------

WITH DsOpCode SELECT
ValidOpCode <= '0' WHEN "00000",
               '1' WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH PrevDependency SELECT
NextReg.RS.Pc  <= GprAddress.Pc  WHEN '0',
                  x"00000000"    WHEN OTHERS;
WITH PrevDependency SELECT
NextReg.RS.Rs1 <= GprAddress.Rs1 WHEN '0',
                  "00000"        WHEN OTHERS;
WITH PrevDependency SELECT
NextReg.RS.Rs2 <= GprAddress.Rs2 WHEN '0',
                  "00000"        WHEN OTHERS;
WITH PrevDependency SELECT
NextReg.RS.Rd  <= GprAddress.Rd  WHEN '0',
                  "00000"        WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH DfuActive SELECT
NextReg.AS.Pc  <= PrevReg.RS.Pc  WHEN '1',
                  PrevReg.AS.Pc  WHEN OTHERS;

WITH DfuActive SELECT
NextReg.AS.Rs1 <= PrevReg.RS.Rs1 WHEN '1',
                  PrevReg.AS.Rs1 WHEN OTHERS;

WITH DfuActive SELECT
NextReg.AS.Rs2 <= PrevReg.RS.Rs2 WHEN '1',
                  PrevReg.AS.Rs2 WHEN OTHERS;

WITH DfuActive SELECT
NextReg.AS.Rd  <= PrevReg.RS.Rd  WHEN '1',
                  PrevReg.AS.Rd  WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

WITH DfuActive SELECT
NextReg.MS.Pc  <= PrevReg.AS.Pc  WHEN '1',
                  PrevReg.MS.Pc  WHEN OTHERS;

WITH DfuActive SELECT
NextReg.MS.Rs1 <= PrevReg.AS.Rs1 WHEN '1',
                  PrevReg.MS.Rs1 WHEN OTHERS;

WITH DfuActive SELECT
NextReg.MS.Rs2 <= PrevReg.AS.Rs2 WHEN '1',
                  PrevReg.MS.Rs2 WHEN OTHERS;

WITH DfuActive SELECT
NextReg.MS.Rd  <= PrevReg.AS.Rd  WHEN '1',
                  PrevReg.MS.Rd  WHEN OTHERS;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

DfuActive              <= PrevDfuActive;

DfuRegisters: PROCESS (Rst, Clk,NextReg,NextDependency,NextDfuActive)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevReg        <= ZeroReg;
        PrevDependency <= '0';
        PrevDfuActive  <= '0';
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        PrevReg        <= NextReg       ;
        PrevDependency <= NextDependency;
        PrevDfuActive  <= NextDfuActive ;
        
    END IF;
    
END PROCESS DfuRegisters;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

Rs1DepDsToRs <= ((Equal(GprAddress.Rs1 , PrevReg.RS.Rd)) AND (NOT(Equal("00000", PrevReg.RS.Rd))));
Rs2DepDsToRs <= ((Equal(GprAddress.Rs2 , PrevReg.RS.Rd)) AND (NOT(Equal("00000", PrevReg.RS.Rd))));

Rs1DepDsToAs <= ((Equal(GprAddress.Rs1 , PrevReg.AS.Rd)) AND (NOT(Equal("00000", PrevReg.AS.Rd))));
Rs2DepDsToAs <= ((Equal(GprAddress.Rs2 , PrevReg.AS.Rd)) AND (NOT(Equal("00000", PrevReg.AS.Rd))));

DsDependency <= Rs1DepDsToRs OR Rs2DepDsToRs OR Rs1DepDsToAs OR Rs2DepDsToAs;

Rs1DepRsToAs <= ((Equal(PrevReg.RS.Rs1 , PrevReg.AS.Rd)) AND (NOT(Equal("00000", PrevReg.AS.Rd))));
Rs2DepRsToAs <= ((Equal(PrevReg.RS.Rs2 , PrevReg.AS.Rd)) AND (NOT(Equal("00000", PrevReg.AS.Rd))));

RsDependency <= Rs1DepRsToAs OR Rs2DepRsToAs;

WITH CacheMiss SELECT
NextDependency <= ((RsDependency OR DsDependency) AND ValidOpCode) WHEN '0',
                  ( PrevDependency                               ) WHEN OTHERS;

FinalDep       <= NextDependency OR PrevDependency;

DataDependency <= FinalDep;

------------------------------------------------------------
-- 
-- Use the Wb block to get the desired write data
-- 
------------------------------------------------------------

WITH DfuActive SELECT
DfuDataOut.DfuAddress <= DfuDataIn.RdAddress WHEN '1',
                         "00000"             WHEN OTHERS;

WITH DfuActive SELECT
DfuDataOut.DfuData    <= WrData              WHEN '1',
                         x"00000000"         WHEN OTHERS;

Selection: ENTITY WORK.WriteBackSelectionBlock(MainArch)
PORT MAP   (AluResult => DfuDataIn.AluResult,
            MemData   => x"00000000"        ,
            ImmData   => DfuDataIn.ImmData  ,
            CsrData   => DfuDataIn.CsrData  ,
            Negative  => DfuDataIn.Negative ,
            PcNext    => DfuDataIn.PcNext   ,
            WbDataSrc => WbDataSrc          ,
            WbData    => WrData              
           );

------------------------------------------------------------
-- 
-- The DFU is only active with pipelined cores, this is seen
-- in the DfuMode signal
-- 
-- If there is a cache miss the DFU unit must disable
-- 
-- The Wr operation to the registers is enabled only if the
-- DFU is enable and at the very end of a dependency
-- 
------------------------------------------------------------


NextDfuActive       <= (NOT (CacheMiss)) AND (PipelineMode);

DfuDataOut.DfuWrEna <= (DfuActive                              ) AND
                       (Equal(DfuDataIn.RdAddress,PrevReg.MS.Rd) AND
                       (PrevDependency AND NextDependency      ) AND
                       (NOT(Equal("00000"        ,PrevReg.MS.Rd))));

DisablePipeline     <= FinalDep;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.DataForwardingUnit(MainArch)
--PORT MAP   (DfuDataIn       => SLV,
--            DfuMode         => SLV,
--            CacheMiss       => SLV,
--            GprAddress      => SLV,
--            PipelineMode    => SLV,
--            Inst            => SLV,
--            Rst             => SLV,
--            Clk             => SLV,
--            DfuDataOut      => SLV,
--            DisablePipeline => SLV,
--            DataDependency  => SLV
--           );
------------------------------------------------------------------------------------------
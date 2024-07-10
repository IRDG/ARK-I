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

ENTITY WriteBackStage IS
    
    PORT   (MemoryData    : IN  MemStageDataT    ;
            ControlWordIn : IN  ControlWordWb    ;
            WbData        : OUT uint32           ;
            RdAddress     : OUT uint05           ;
            GprWrEna      : OUT STD_LOGIC         
           );
    
END ENTITY WriteBackStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArchitecture OF WriteBackStage IS

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

RdAddress <= MemoryData.RdAddress          ;

GprWrEna  <= ControlWordIn.WbStage.GprWrEna;

WbSelB: ENTITY WORK.WriteBackSelectionBlock(MainArch)
PORT MAP   (AluResult => MemoryData.AluResult,
            MemData   => MemoryData.MemData  ,
            ImmData   => MemoryData.ImmData  ,
            CsrData   => MemoryData.CsrData  ,
            Negative  => MemoryData.Negative ,
            PcNext    => MemoryData.PcNext   ,
            WbDataSrc => ControlWordIn.WbStage.WbDataSrc,
            WbData    => WbData
           );

END MainArchitecture;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.WriteBackStage(MainArchitecture)
--PORT MAP   (MemoryData    => SLV,
--            ControlWordIn => SLV,
--            WbData        => SLV,
--            RdAddress     => SLV,
--            GprWrEna      => SLV
--           );
------------------------------------------------------------------------------------------
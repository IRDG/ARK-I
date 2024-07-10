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

ENTITY AluStageToMemoryStage IS
    
    PORT   (DataIn  : IN  AluStageDataT    ;
            CtrlIn  : IN  ControlWordMemory;
            Mode    : IN  uint04           ;
            Rst     : IN  uint01           ;
            Clk     : IN  uint01           ;
            DataOut : OUT AluStageDataT    ;
            CtrlOut : OUT ControlWordMemory 
           );
    
END ENTITY AluStageToMemoryStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF AluStageToMemoryStage IS

CONSTANT Zero32      : uint32           := x"00000000";
CONSTANT Zero05      : uint05           :=     "00000";

SIGNAL   RegData     : AluStageDataT    ;
SIGNAL   NextRegData : AluStageDataT    ;
SIGNAL   RegCtrl     : ControlWordMemory;
SIGNAL   NextRegCtrl : ControlWordMemory;

BEGIN

------------------------------------------------------------
-- 
-- Control register to propagate the signals from one stage
-- to the next.
-- 
-- If mode is set to 0, then the pipeline system is disabled
-- and the input signal must be bypassed to the output
-- signal
-- 
------------------------------------------------------------

WITH Mode(0) SELECT
CtrlOut <= RegCtrl WHEN '1',
           CtrlIn  WHEN OTHERS;

WITH Mode(2 DOWNTO 1) SELECT
NextRegCtrl <= CtrlIn  WHEN "00",
               RegCtrl WHEN "01",
               CtrlIn  WHEN "10",
               RegCtrl WHEN "11",
               RegCtrl WHEN OTHERS;

PROCESS(Clk, Rst, Mode, CtrlIn)
BEGIN
    
    IF(Rst='1')THEN
        
        RegCtrl.MStage  .PcEnaLoadAlu <= PcDisableAlu     ;
        RegCtrl.MStage  .MdrOperation <= MdrNullOperation ;
        RegCtrl.WbStage .WbDataSrc    <= WbDataNoSource   ;
        RegCtrl.WbStage .GprWrEna     <= GprWrDisable     ;
        RegCtrl.InstId                <= NoOperationId    ;
        
    ELSIF(Rising_Edge(Clk))THEN
        
        IF (Mode(0) = '1') THEN
            
            RegCtrl <= NextRegCtrl;
            
        ELSE
            
            RegCtrl.MStage  .PcEnaLoadAlu <= PcDisableAlu     ;
            RegCtrl.MStage  .MdrOperation <= MdrNullOperation ;
            RegCtrl.WbStage .WbDataSrc    <= WbDataNoSource   ;
            RegCtrl.WbStage .GprWrEna     <= GprWrDisable     ;
            RegCtrl.InstId                <= NoOperationId    ;
            
        END IF;
        
    END IF;
    
END PROCESS;

------------------------------------------------------------
-- 
-- Data register to propagate the signals from one stage
-- to the next.
-- 
-- If mode is set to 0, then the pipeline system is disabled
-- and the input signal must be bypassed to the output
-- signal
-- 
------------------------------------------------------------

WITH Mode(0) SELECT
DataOut <= RegData WHEN '1',
           DataIn  WHEN OTHERS;

WITH Mode(2 DOWNTO 1) SELECT
NextRegData <= DataIn  WHEN "00",
               RegData WHEN "01",
               DataIn  WHEN "10",
               RegData WHEN "11",
               RegData WHEN OTHERS;

PROCESS(Clk, Rst, Mode, DataIn)
BEGIN
    
    IF(Rst='1')THEN
        
        RegData.AluResult  <= Zero32;
        RegData.GprData2   <= Zero32;
        RegData.ImmData    <= Zero32;
        RegData.RdAddress  <= Zero05;
        RegData.CsrData    <= Zero32;
        RegData.Negative   <= '0'   ;
        RegData.PcNext     <= Zero32;
        
    ELSIF(Rising_Edge(Clk))THEN
        
        IF (Mode(0) = '1') THEN
            
            RegData <= NextRegData;
            
        ELSE
            
            RegData.AluResult  <= Zero32;
            RegData.GprData2   <= Zero32;
            RegData.ImmData    <= Zero32;
            RegData.RdAddress  <= Zero05;
            RegData.CsrData    <= Zero32;
            RegData.Negative   <= '0'   ;
            RegData.PcNext     <= Zero32;
            
        END IF;
        
    END IF;
    
END PROCESS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.AluStageToMemoryStage(MainArch)
--PORT MAP   (DataIn  => SLV,
--            CtrlIn  => SLV,
--            Mode    => SLV,
--            Rst     => SLV,
--            Clk     => SLV,
--            DataOut => SLV,
--            CtrlOut => SLV
--           );
------------------------------------------------------------------------------------------
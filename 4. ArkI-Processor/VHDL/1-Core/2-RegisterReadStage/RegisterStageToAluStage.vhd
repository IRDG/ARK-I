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

ENTITY RegisterStageToAluStage IS
    
    PORT   (DataIn  : IN  RegisterStageDataT;
            CtrlIn  : IN  ControlWordAlu    ;
            Mode    : IN  uint04            ;
            Rst     : IN  uint01            ;
            Clk     : IN  uint01            ;
            DataOut : OUT RegisterStageDataT;
            CtrlOut : OUT ControlWordAlu     
           );
    
END ENTITY RegisterStageToAluStage;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF RegisterStageToAluStage IS

CONSTANT Zero32      : uint32            := x"00000000";
CONSTANT Zero05      : uint05            :=     "00000";

SIGNAL   RegData     : RegisterStageDataT;
SIGNAL   NextRegData : RegisterStageDataT;
SIGNAL   RegCtrl     : ControlWordAlu    ;
SIGNAL   NextRegCtrl : ControlWordAlu    ;

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
CtrlOut     <= RegCtrl WHEN '1',
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
        
        RegCtrl.AluStage.AluOperation <= AluNullOperation ;
        RegCtrl.AluStage.AluSource    <= AluNullSource    ;
        RegCtrl.AluStage.CsrOperation <= CsrNotWrOPeration;
        RegCtrl.MStage  .PcEnaLoadAlu <= PcDisableAlu     ;
        RegCtrl.MStage  .MdrOperation <= MdrNullOperation ;
        RegCtrl.WbStage .WbDataSrc    <= WbDataNoSource   ;
        RegCtrl.WbStage .GprWrEna     <= GprWrDisable     ;
        RegCtrl.InstId                <= NoOperationId    ;
        
    ELSIF(Rising_Edge(Clk))THEN
        
        IF    (Mode(3) = '1') THEN
            
            RegCtrl.AluStage.AluOperation <= AluNullOperation ;
            RegCtrl.AluStage.AluSource    <= AluNullSource    ;
            RegCtrl.MStage  .PcEnaLoadAlu <= PcDisableAlu     ;
            RegCtrl.AluStage.CsrOperation <= CsrNotWrOPeration;
            RegCtrl.MStage  .MdrOperation <= MdrNullOperation ;
            RegCtrl.WbStage .WbDataSrc    <= WbDataNoSource   ;
            RegCtrl.WbStage .GprWrEna     <= GprWrDisable     ;
            RegCtrl.InstId                <= NoOperationId    ;
            
        ELSIF (Mode(0) = '1') THEN
            
            RegCtrl <= NextRegCtrl;
            
        ELSE
            
            RegCtrl.AluStage.AluOperation <= AluNullOperation ;
            RegCtrl.AluStage.AluSource    <= AluNullSource    ;
            RegCtrl.MStage  .PcEnaLoadAlu <= PcDisableAlu     ;
            RegCtrl.AluStage.CsrOperation <= CsrNotWrOPeration;
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
DataOut     <= RegData WHEN '1',
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
        
        RegData.CmpRes     <= "000000";
        RegData.GprData1   <= Zero32  ;
        RegData.GprData2   <= Zero32  ;
        RegData.ImmData    <= Zero32  ;
        RegData.RdAddress  <= Zero05  ;
        RegData.CsrImmData <= Zero05  ;
        RegData.Shamt      <= Zero05  ;
        RegData.PcNext     <= Zero32  ;
        RegData.Pc         <= Zero32  ;
        RegData.CsrData    <= Zero32  ;
        
    ELSIF(Rising_Edge(Clk))THEN
        
        IF    (Mode(3) = '1') THEN
            
            RegData.CmpRes     <= "000000";
            RegData.GprData1   <= Zero32  ;
            RegData.GprData2   <= Zero32  ;
            RegData.ImmData    <= Zero32  ;
            RegData.RdAddress  <= Zero05  ;
            RegData.CsrImmData <= Zero05  ;
            RegData.Shamt      <= Zero05  ;
            RegData.PcNext     <= Zero32  ;
            RegData.Pc         <= Zero32  ;
            RegData.CsrData    <= Zero32  ;
            
        ELSIF (Mode(0) = '1') THEN
            
            RegData <= NextRegData;
            
        ELSE
            
            RegData.CmpRes     <= "000000";
            RegData.GprData1   <= Zero32  ;
            RegData.GprData2   <= Zero32  ;
            RegData.ImmData    <= Zero32  ;
            RegData.RdAddress  <= Zero05  ;
            RegData.CsrImmData <= Zero05  ;
            RegData.Shamt      <= Zero05  ;
            RegData.PcNext     <= Zero32  ;
            RegData.Pc         <= Zero32  ;
            RegData.CsrData    <= Zero32  ;
            
        END IF;
        
    END IF;
    
END PROCESS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.RegisterStageToAluStage(MainArch)
--PORT MAP   (DataIn  => SLV,
--            CtrlIn  => SLV,
--            Mode    => SLV,
--            Rst     => SLV,
--            Clk     => SLV,
--            DataOut => SLV,
--            CtrlOut => SLV
--           );
------------------------------------------------------------------------------------------
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

ENTITY BpuFiniteStateMachine IS
    
    PORT   (BranchResult : IN  uint01;
            Enable       : IN  uint01;
            Rst          : IN  uint01;
            Clk          : IN  uint01;
            Jump         : OUT uint01
           );
    
END ENTITY BpuFiniteStateMachine;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF BpuFiniteStateMachine IS

TYPE StateType IS (JumpStrong     ,
                   JumpWeak       ,
                   DoNotJumpStrong,
                   DoNotJumpWeak   
                  );

SIGNAL PrevState : StateType;
SIGNAL NextState : StateType;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

StateMemory: PROCESS (Rst, Clk,NextState)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevState <= JumpWeak;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        IF(Enable = '1') THEN
            
            PrevState <= NextState;
            
        END IF;
        
    END IF;
    
END PROCESS StateMemory;

StateChange: PROCESS (PrevState, BranchResult)
BEGIN
    
    CASE PrevState IS
    ----------------------------------------------------------
        WHEN JumpStrong =>
            
            Jump <= '1';
            
            IF (BranchResult = '0')THEN
                
                NextState <= JumpWeak;
                
            ELSE
                
                NextState <= JumpStrong;
                
            END IF;
    ----------------------------------------------------------
        WHEN JumpWeak =>
            
            Jump <= '1';
            
            IF (BranchResult = '0')THEN
                
                NextState <= DoNotJumpStrong;
                
            ELSE
                
                NextState <= JumpStrong;
                
            END IF;
    ----------------------------------------------------------
        WHEN DoNotJumpWeak =>
            
            Jump <= '0';
            
            IF (BranchResult = '0')THEN
                
                NextState <= JumpStrong;
                
            ELSE
                
                NextState <= DoNotJumpStrong;
                
            END IF;
    ----------------------------------------------------------
        WHEN DoNotJumpStrong =>
            
            Jump <= '0';
            
            IF (BranchResult = '0')THEN
                
                NextState <= DoNotJumpWeak;
                
            ELSE
                
                NextState <= DoNotJumpStrong;
                
            END IF;
    ----------------------------------------------------------
    END CASE;
    
END PROCESS StateChange;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.BpuFiniteStateMachine(MainArch)
--PORT MAP   (BranchResult => SLV,
--            Enable       => SLV,
--            Rst          => SLV,
--            Clk          => SLV,
--            Jump         => SLV
--           );
------------------------------------------------------------------------------------------
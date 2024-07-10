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
USE WORK.CachePackage.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY AddressReplacementControlUnit IS
    
    PORT   (InstMiss         : IN  uint01;
            DataMiss         : IN  uint01;
            Pc               : IN  uint32;
            RdWrAddress      : IN  uint32;
            PrevSliceAddress : IN  uint32;
            PrevSliceValid   : IN  uint01;
            Rst              : IN  uint01;
            Clk              : IN  uint01;
            ReplaceAddress   : OUT uint32;
            MemoryAddress    : OUT uint32;
            MemoryRdWrEna    : OUT uint02;
            ReplaceEnaInstWr : OUT uint01;
            ReplaceEnaDataWr : OUT uint01;
            ReplaceEnaDataRd : OUT uint01 
           );
    
END ENTITY AddressReplacementControlUnit;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF AddressReplacementControlUnit IS

TYPE StateType IS (Idle, ReplaceInstructions, ReplaceDataRd, ReplaceDataIdle, ReplaceDataWr);

SIGNAL EnableFieldCounter     : uint01   ;
SIGNAL EnableDelayCounter     : uint01   ;
SIGNAL ResetCounters          : uint01   ;
SIGNAL ResetDelay             : uint01   ;

SIGNAL FieldCounterEna        : uint01   ;
SIGNAL MaxFields              : TagType  ;
SIGNAL MaxDelay               : TagType  ;
SIGNAL FieldCount             : TagType  ;
SIGNAL MaxDelayCount          : uint01   ;

SIGNAL NextState              : StateType;
SIGNAL PrevState              : StateType;

SIGNAL PcTagged               : uint32   ;
SIGNAL RdWrAddressTagged      : uint32   ;
SIGNAL PrevSliceAddressTagged : uint32   ;

SIGNAL EnableRdWrCounter      : uint01   ;
SIGNAL RdWrCounterReset       : uint01   ;
SIGNAL RdWrMaxCount           : uint01   ;

BEGIN

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

MaxFields              <= Int2Slv(NoFields   , FieldSize);
MaxDelay               <= Int2Slv(MemoryDelay, FieldSize);

PcTagged               <= Pc              (31 DOWNTO FieldSize) & FieldCount;
RdWrAddressTagged      <= RdWrAddress     (31 DOWNTO FieldSize) & FieldCount;
PrevSliceAddressTagged <= PrevSliceAddress(31 DOWNTO FieldSize) & FieldCount;

FieldCounterEna        <= MaxDelayCount AND EnableFieldCounter;

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

FieldCounter: ENTITY WORK.GralLimCounter(MainArch)
GENERIC MAP(Size     => FieldSize
           )
PORT MAP   (Ena      => FieldCounterEna     ,
            Limit    => MaxFields           ,
            MR       => Rst                 ,
            SR       => ResetCounters       ,
            Clk      => Clk                 ,
            MaxCount => OPEN                ,
            Count    => FieldCount           
           );

DelayCounter: ENTITY WORK.GralLimCounter(MainArch)
GENERIC MAP(Size     => FieldSize
           )
PORT MAP   (Ena      => EnableDelayCounter  ,
            Limit    => MaxDelay            ,
            MR       => Rst                 ,
            SR       => ResetCounters       ,
            Clk      => Clk                 ,
            MaxCount => MaxDelayCount       ,
            Count    => OPEN                 
           );

RdWrCounter: ENTITY WORK.GralLimCounter(MainArch)
GENERIC MAP(Size     => 3
           )
PORT MAP   (Ena      => EnableRdWrCounter   ,
            Limit    => "111"               ,
            MR       => Rst                 ,
            SR       => RdWrCounterReset    ,
            Clk      => Clk                 ,
            MaxCount => RdWrMaxCount        ,
            Count    => OPEN                 
           );

------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------

StateMemory: PROCESS (Rst, Clk, NextState)
BEGIN
    
    IF (Rst = '1') THEN
        
        PrevState <= Idle;
        
    ELSIF (RISING_EDGE(Clk)) THEN
        
        PrevState <= NextState;
        
    END IF;
    
END PROCESS StateMemory;

StateChange: PROCESS (PrevState        , InstMiss  , DataMiss , Pc           , RdWrAddress , PcTagged      ,
                      RdWrAddressTagged, FieldCount, MaxFields, MaxDelayCount, RdWrMaxCount, PrevSliceValid,
                      PrevSliceAddressTagged       )
BEGIN
    
    CASE PrevState IS
    ----------------------------------------------------------
        WHEN Idle =>
            
            ResetCounters      <=                    '1';
            EnableFieldCounter <=                    '0';
            EnableDelayCounter <=                    '0';
            
            EnableRdWrCounter  <=                    '0';
            RdWrCounterReset   <=                    '1';
            
            MemoryAddress      <=            x"00000000";
            ReplaceAddress     <=            x"00000000";
            ReplaceEnaInstWr   <=                    '0';
            ReplaceEnaDataWr   <=                    '0';
            ReplaceEnaDataRd   <=                    '0';
            MemoryRdWrEna      <=                   "00";
            
            IF    ((InstMiss = '1')                           ) THEN
                
                NextState <= ReplaceInstructions;
                
            ELSIF ((DataMiss = '1') AND (PrevSliceValid = '0')) THEN
                
                NextState <= ReplaceDataWr;
                
            ELSIF ((DataMiss = '1') AND (PrevSliceValid = '1')) THEN
                
                NextState <= ReplaceDataRd;
                
            ELSE
                
                NextState <= PrevState;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ReplaceInstructions =>
            
            ResetCounters      <=                    '0';
            EnableFieldCounter <=                    '1';
            EnableDelayCounter <=                    '1';
            
            EnableRdWrCounter  <=                    '0';
            RdWrCounterReset   <=                    '1';
            
            MemoryAddress      <=               PcTagged;
            ReplaceAddress     <=               PcTagged;
            ReplaceEnaInstWr   <=                    '1';
            ReplaceEnaDataWr   <=                    '0';
            ReplaceEnaDataRd   <=                    '0';
            MemoryRdWrEna      <=                   "10";
            
            IF ((Slv2Int(FieldCount) = Slv2Int(MaxFields)) AND (MaxDelayCount = '1')) THEN
                
                NextState <= Idle;
                
            ELSE
                
                NextState <= PrevState;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ReplaceDataWr =>
            
            ResetCounters      <=                    '0';
            EnableFieldCounter <=                    '1';
            EnableDelayCounter <=                    '1';
            
            EnableRdWrCounter  <=                    '0';
            RdWrCounterReset   <=                    '1';
            
            MemoryAddress      <= PrevSliceAddressTagged;
            ReplaceAddress     <= PrevSliceAddressTagged;
            ReplaceEnaInstWr   <=                    '0';
            ReplaceEnaDataWr   <=                    '0';
            ReplaceEnaDataRd   <=                    '1';
            MemoryRdWrEna      <=                   "01";
            
            IF ((Slv2Int(FieldCount) = Slv2Int(MaxFields)) AND (MaxDelayCount = '1')) THEN
                
                NextState <= ReplaceDataIdle;
                
            ELSE
                
                NextState <= PrevState;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ReplaceDataIdle =>
            
            ResetCounters      <=                    '1';
            EnableFieldCounter <=                    '0';
            EnableDelayCounter <=                    '0';
            
            EnableRdWrCounter  <=                    '1';
            RdWrCounterReset   <=                    '0';
            
            MemoryAddress      <=            x"00000000";
            ReplaceAddress     <=            x"00000000";
            ReplaceEnaInstWr   <=                    '0';
            ReplaceEnaDataWr   <=                    '0';
            ReplaceEnaDataRd   <=                    '0';
            MemoryRdWrEna      <=                   "00";
            
            IF (RdWrMaxCount = '1') THEN
                
                NextState <= ReplaceDataRd  ;
                
            ELSE
                
                NextState <= ReplaceDataIdle;
                
            END IF;
            
    ----------------------------------------------------------
        WHEN ReplaceDataRd =>
            
            ResetCounters      <=                    '0';
            EnableFieldCounter <=                    '1';
            EnableDelayCounter <=                    '1';
            
            EnableRdWrCounter  <=                    '0';
            RdWrCounterReset   <=                    '1';
            
            MemoryAddress      <=      RdWrAddressTagged;
            ReplaceAddress     <=      RdWrAddressTagged;
            ReplaceEnaInstWr   <=                    '0';
            ReplaceEnaDataWr   <=                    '1';
            ReplaceEnaDataRd   <=                    '0';
            MemoryRdWrEna      <=                   "10";
            
            IF ((Slv2Int(FieldCount) = Slv2Int(MaxFields)) AND (MaxDelayCount = '1')) THEN
                
                NextState <= Idle;
                
            ELSE
                
                NextState <= PrevState;
                
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
--BlockN: ENTITY WORK.AddressReplacementControlUnit(MainArch)
--PORT MAP   (InstMiss         => SLV,
--            DataMiss         => SLV,
--            Pc               => SLV,
--            RdWrAddress      => SLV,
--            PrevSliceAddress => SLV,
--            PrevSliceValid   => SLV,
--            Rst              => SLV,
--            Clk              => SLV,
--            ReplaceAddress   => SLV,
--            MemoryAddress    => SLV,
--            MemoryRdWrEna    => SLV,
--            ReplaceEnaInstWr => SLV,
--            ReplaceEnaDataWr => SLV,
--            ReplaceEnaDataRd => SLV
--           );
------------------------------------------------------------------------------------------
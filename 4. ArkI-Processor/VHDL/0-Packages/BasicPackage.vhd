------------------------------------------------------------------------------------------
--                                                                                      --
--                              Ivan Ricardo Diaz Gamarra                               --
--                                                                                      --
--  Proyect:                                                                            --
--  Date:                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                       Package                                        --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE BasicPackage IS

------------------------------------------------------------------------------------------
-- 
-- Basic subtypes used.
-- 
-- * uint32 is a 32 bit STD_LOGIC vector, which is used to create the word size for most
--   signals in the core
-- 
-- * uint05 is a 5 bit STD_LOGIC vector, which is used in signals such as GPR's addresses
--   or some fields.
-- 
------------------------------------------------------------------------------------------

SUBTYPE uint32 IS STD_LOGIC_VECTOR(31 DOWNTO 0);
SUBTYPE uint24 IS STD_LOGIC_VECTOR(23 DOWNTO 0);
SUBTYPE uint20 IS STD_LOGIC_VECTOR(19 DOWNTO 0);
SUBTYPE uint16 IS STD_LOGIC_VECTOR(15 DOWNTO 0);
SUBTYPE uint12 IS STD_LOGIC_VECTOR(11 DOWNTO 0);
SUBTYPE uint08 IS STD_LOGIC_VECTOR( 7 DOWNTO 0);
SUBTYPE uint07 IS STD_LOGIC_VECTOR( 6 DOWNTO 0);
SUBTYPE uint06 IS STD_LOGIC_VECTOR( 5 DOWNTO 0);
SUBTYPE uint05 IS STD_LOGIC_VECTOR( 4 DOWNTO 0);
SUBTYPE uint04 IS STD_LOGIC_VECTOR( 3 DOWNTO 0);
SUBTYPE uint03 IS STD_LOGIC_VECTOR( 2 DOWNTO 0);
SUBTYPE uint02 IS STD_LOGIC_VECTOR( 1 DOWNTO 0);
SUBTYPE uint01 IS STD_LOGIC                    ;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

TYPE InstructionIdT IS (InstLui   , InstAuiPc ,InstAddi   ,InstSlti   ,InstSltiu  ,
                        InstXori  , InstOri   , InstAndi  , InstSlli  , InstSrli  ,
                        InstSrai  , InstAdd   , InstSub   , InstSll   , InstSlt   ,
                        InstSltu  , InstXor   , InstSrl   , InstSra   , InstOr    ,
                        InstAnd   , InstCsrrw , InstCsrrs , InstCsrrc , InstCsrrwi,
                        InstCsrrsi, InstCsrrci, InstRet   , InstLb    , InstLh    ,
                        InstLw    , InstLbu   , InstLhu   , InstSb    , InstSh    ,
                        InstSw    , InstJal   , InstJalr  , InstBeq   , InstBne   ,
                        InstBlt   , InstBge   , InstBltu  , InstBgeu  , InstMul   ,
                        InstMulh  , InstMulhsu, InstMulhu , InstDiv   , InstDivu  ,
                        InstRem   , InstRemu  , InstNoOp                           
                       );

TYPE DecodeStageControlT IS RECORD
    
    ImmSext      : uint01;
    Format       : uint02;
    
END RECORD DecodeStageControlT;

TYPE AluStageControlT IS RECORD
    
    AluOperation : uint05;
    AluSource    : uint02;
    CsrOperation : uint03;
    
END RECORD AluStageControlT;

TYPE MemoryStageControlT IS RECORD
    
    PcEnaLoadAlu : uint01;
    MdrOperation : uint04;
    
END RECORD MemoryStageControlT;

TYPE WriteBackStageControlT IS RECORD
    
    WbDataSrc    : uint03;
    GprWrEna     : uint01;
    
END RECORD WriteBackStageControlT;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

TYPE ControlWordWb IS RECORD
    
    WbStage  : WriteBackStageControlT;
    InstId   : InstructionIdT        ;
    
END RECORD ControlWordWb;

TYPE ControlWordMemory IS RECORD
    
    MStage   : MemoryStageControlT   ;
    WbStage  : WriteBackStageControlT;
    InstId   : InstructionIdT        ;
    
END RECORD ControlWordMemory;

TYPE ControlWordAlu IS RECORD
    
    AluStage : AluStageControlT      ;
    MStage   : MemoryStageControlT   ;
    WbStage  : WriteBackStageControlT;
    InstId   : InstructionIdT        ;
    
END RECORD ControlWordAlu;

TYPE ControlWordReg IS RECORD
    
    AluStage : AluStageControlT      ;
    MStage   : MemoryStageControlT   ;
    WbStage  : WriteBackStageControlT;
    InstId   : InstructionIdT        ;
    
END RECORD ControlWordReg;

TYPE ControlWordDecode IS RECORD
    
    DecStage : DecodeStageControlT   ;
    AluStage : AluStageControlT      ;
    MStage   : MemoryStageControlT   ;
    WbStage  : WriteBackStageControlT;
    InstId   : InstructionIdT        ;
    
END RECORD ControlWordDecode;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

TYPE DecodeStageDataT IS RECORD
    
    ImmData    : uint32;
    RdAddress  : uint05;
    Rs1Address : uint05;
    Rs2Address : uint05;
    PcNext     : uint32;
    Pc         : uint32;
    
END RECORD DecodeStageDataT;

TYPE RegisterStageDataT IS RECORD
    
    CmpRes     : uint06;
    GprData1   : uint32;
    GprData2   : uint32;
    ImmData    : uint32;
    RdAddress  : uint05;
    CsrImmData : uint05;
    Shamt      : uint05;
    PcNext     : uint32;
    Pc         : uint32;
    CsrData    : uint32;
    
END RECORD RegisterStageDataT;

TYPE AluStageDataT IS RECORD
    
    AluResult  : uint32;
    GprData2   : uint32;
    ImmData    : uint32;
    RdAddress  : uint05;
    CsrData    : uint32;
    Negative   : uint01;
    PcNext     : uint32;
    
END RECORD AluStageDataT;

TYPE MemStageDataT IS RECORD
    
    AluResult  : uint32;
    MemData    : uint32;
    ImmData    : uint32;
    RdAddress  : uint05;
    CsrData    : uint32;
    Negative   : uint01;
    PcNext     : uint32;
    
END RECORD MemStageDataT;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

TYPE DfuInBusT IS RECORD
    
    AluResult : uint32;
    ImmData   : uint32;
    RdAddress : uint05;
    CsrData   : uint32;
    Negative  : uint01;
    PcNext    : uint32;
    
END RECORD DfuInBusT;

TYPE DfuOutBusT IS RECORD
    
    DfuWrEna   : uint01;
    DfuAddress : uint05;
    DfuData    : uint32;
    
END RECORD DfuOutBusT;

TYPE PcExcControlT IS RECORD
    
    ExcPcWrEna : uint01;
    NewExcPc   : uint32;
    
END RECORD PcExcControlT;

TYPE CsrExcBusT IS RECORD
    
    ExcCsrWrEna   : uint02;
    ExcCsrData    : uint32;
    ExcCsrAddress : uint32;
    
END RECORD CsrExcBusT;

TYPE CtrlExcT IS RECORD
    
    ExcPcWrEna    : uint01;
    ExcCsrWrEna   : uint02;
    ExcCsrData    : uint32;
    ExcCsrAddress : uint32;
    CycleMepc     : uint02;
    ExcMemRd      : uint01;
    ExcAluOp      : uint04;
    
END RECORD CtrlExcT;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

TYPE RegAddressT IS RECORD
    
    Pc  : uint32;
    Rs1 : uint05;
    Rs2 : uint05;
    Rd  : uint05;
    
END RECORD RegAddressT;

TYPE DfuRegT IS RECORD
    
    RS : RegAddressT;
    AS : RegAddressT;
    MS : RegAddressT;
    
END RECORD DfuRegT;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

CONSTANT NoOperationId     : InstructionIdT               :=    InstNoOp;

CONSTANT AluNullOperation  : STD_LOGIC_VECTOR(4 DOWNTO 0) :=     "11111";
CONSTANT AluNullSource     : STD_LOGIC_VECTOR(1 DOWNTO 0) :=        "00";
CONSTANT CsrNotWrOPeration : uint03                       :=       "111";

CONSTANT PcDisableAlu      : uint01                       :=         '0';
CONSTANT MdrNullOperation  : uint04                       :=      "0000";

CONSTANT WbDataNoSource    : uint03                       :=       "111";
CONSTANT GprWrDisable      : uint01                       :=         '0';

CONSTANT Core1PcInitValue  : uint32                       := x"00000000";
CONSTANT Core2PcInitValue  : uint32                       := x"00000010";

CONSTANT NoOpControlWord   : ControlWordDecode            := 
                           (---------------------------------------------------------------------------------------
                            DecStage => (                            --                                
                                         ImmSext      => '0'    ,    -- Enables Sign extended        : No
                                         Format       => "00"        -- Immediate data Format        : R
                                        ),                           --                                
                            AluStage => (                            --                                
                                         AluOperation => "11111",    -- Alu Operation Id             : None
                                         AluSource    => "00"   ,    -- Alu Operands source          : None
                                         CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                                        ),                           --                                
                            MStage   => (                            --                                
                                         PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                                         MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                                        ),                           --                                
                            WbStage  => (                            --                                
                                         WbDataSrc    => "111"  ,    -- Select data Source to write  : No Source
                                         GprWrEna     => '0'         -- Enables Writing data to GPR  : No
                                        ),                           --                                
                            InstId   => InstNoOp                     -- Instruction                  : No Op
                           );---------------------------------------------------------------------------------------

CONSTANT NoOpCtrlWordDsAs  : ControlWordReg               := 
                           (---------------------------------------------------------------------------------------
                            AluStage => (                            --                                
                                         AluOperation => "11111",    -- Alu Operation Id             : None
                                         AluSource    => "00"   ,    -- Alu Operands source          : None
                                         CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                                        ),                           --                                
                            MStage   => (                            --                                
                                         PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                                         MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                                        ),                           --                                
                            WbStage  => (                            --                                
                                         WbDataSrc    => "111"  ,    -- Select data Source to write  : No Source
                                         GprWrEna     => '0'         -- Enables Writing data to GPR  : No
                                        ),                           --                                
                            InstId   => InstNoOp                     -- Instruction                  : No Op
                           );---------------------------------------------------------------------------------------

CONSTANT NoOpDataDsAs      : DecodeStageDataT             :=
                           (---------------------------------------------------------------------------------------
                            ImmData    => x"00000000",
                            RdAddress  =>     "00000",
                            Rs1Address =>     "00000",
                            Rs2Address =>     "00000",
                            PcNext     => x"00000000",
                            Pc         => x"00000000" 
                           );---------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 
-- Slv2Int is a Pure function that cast a STD_LOGIC_VECTOR input into an integer
--         It will give an INTEGER result
--         The result is calculated using UNSIGNED() and TO_INTEGER() functions
-- 
------------------------------------------------------------------------------------------
-- 
-- Int2Slv is a Pure function that cast an INTEGER input into a STD_LOGIC_VECTOR
--         It will give a STD_LOGIC_VECTOR result
--         The result is calculated using TO_UNSIGNED() and STD_LOGIC_VECTOR() functions
-- 
------------------------------------------------------------------------------------------

PURE FUNCTION Slv2Int(Input : STD_LOGIC_VECTOR)
RETURN INTEGER;

PURE FUNCTION Int2Slv(Input : INTEGER;
                      Size  : NATURAL)
RETURN STD_LOGIC_VECTOR;

PURE FUNCTION Equal(A : STD_LOGIC_VECTOR;
                    B : STD_LOGIC_VECTOR)
RETURN uint01;

END PACKAGE BasicPackage;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

PACKAGE BODY BasicPackage IS

------------------------------------------------------------------------------------------
-- 
-- Implementation of function Slv2Int
-- 
-- 
-- Slv2Int is a Pure function that cast a STD_LOGIC_VECTOR input into an integer
--         It will give an INTEGER result
--         The result is calculated using UNSIGNED() and TO_INTEGER() functions
-- 
------------------------------------------------------------------------------------------

PURE FUNCTION Slv2Int(Input : STD_LOGIC_VECTOR)
RETURN INTEGER IS

BEGIN
    
    RETURN TO_INTEGER(UNSIGNED(Input));
    
END Slv2Int;

------------------------------------------------------------------------------------------
-- 
-- Implementation of function Int2StdVector
-- 
-- 
-- Int2Slv is a Pure function that cast an INTEGER input into a STD_LOGIC_VECTOR
--         It will give a STD_LOGIC_VECTOR result
--         The result is calculated using TO_UNSIGNED() and STD_LOGIC_VECTOR() functions
-- 
------------------------------------------------------------------------------------------

PURE FUNCTION Int2Slv(Input : INTEGER;
                      Size  : NATURAL)
RETURN STD_LOGIC_VECTOR IS

BEGIN
    
    RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(Input,Size));
    
END Int2Slv;

------------------------------------------------------------------------------------------
-- 
-- Implementation of function Equal
-- 
-- 
-- Int2Slv is a Pure function that cast an INTEGER input into a STD_LOGIC_VECTOR
--         It will give a STD_LOGIC_VECTOR result
--         The result is calculated using TO_UNSIGNED() and STD_LOGIC_VECTOR() functions
-- 
------------------------------------------------------------------------------------------

PURE FUNCTION Equal(A : STD_LOGIC_VECTOR;
                    B : STD_LOGIC_VECTOR)
RETURN uint01 IS

BEGIN
    
    IF (Slv2Int(A) = Slv2Int(B)) THEN
        
        RETURN '1';
        
    ELSE
        
        RETURN '0';
        
    END IF;
END Equal;

END BasicPackage;
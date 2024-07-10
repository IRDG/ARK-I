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

ENTITY MicroProgramMemory IS
    
    PORT   (OpCode      : IN  uint07           ;
            Funct3      : IN  uint03           ;
            Funct7      : IN  uint07           ;
            ControlWord : OUT ControlWordDecode;
            UnknownInst : OUT uint01           ;
            BranchType  : OUT uint04           ;
            GprUsed     : OUT uint03            
           );
    
END ENTITY MicroProgramMemory;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ARCHITECTURE MainArch OF MicroProgramMemory IS

SIGNAL Instruction : InstructionIdT;

SIGNAL Spec        : STD_LOGIC                    ;
SIGNAL FinalSelect : STD_LOGIC_VECTOR( 5 DOWNTO 0);

SIGNAL SingleSel   : STD_LOGIC_VECTOR( 6 DOWNTO 0);
SIGNAL DoubleSel   : STD_LOGIC_VECTOR( 9 DOWNTO 0);
SIGNAL TripleSel   : STD_LOGIC_VECTOR(16 DOWNTO 0);

SIGNAL SingleCtrl  : ControlWordDecode            ;
SIGNAL DoubleCtrl  : ControlWordDecode            ;
SIGNAL TripleCtrl  : ControlWordDecode            ;

SIGNAL SingleGprId : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL DoubleGprId : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL TripleGprId : STD_LOGIC_VECTOR( 2 DOWNTO 0);

SIGNAL SingleUnkwn : STD_LOGIC                    ;
SIGNAL DoubleUnkwn : STD_LOGIC                    ;
SIGNAL TripleUnkwn : STD_LOGIC                    ;

BEGIN

------------------------------------------------------------
-- 
-- Create the select signals for each kind of instruction
-- 
------------------------------------------------------------

SingleSel   <=                   OpCode;

DoubleSel   <=          Funct3 & OpCode;

TripleSel   <= Funct7 & Funct3 & OpCode;

WITH DoubleSel SELECT
Spec <= '1' WHEN ("0010010011"),
        '1' WHEN ("1010010011"),
        '1' WHEN ("0001110011"),
        '0' WHEN         OTHERS;

FinalSelect <= Spec & OpCode(6 DOWNTO 2);

------------------------------------------------------------
-- 
-- Select the final control word based on the opcode and
-- the previosly stated special cases
-- 
-- Using the same signal, select the value for the unknown
-- flag, which is up when the read instruction is not on
-- the micro program memory
-- 
------------------------------------------------------------

WITH FinalSelect SELECT
ControlWord <= SingleCtrl  WHEN "001101",
               SingleCtrl  WHEN "000101",
               DoubleCtrl  WHEN "000100",
               TripleCtrl  WHEN "100100",
               TripleCtrl  WHEN "001100",
               DoubleCtrl  WHEN "011100",
               TripleCtrl  WHEN "111100",
               DoubleCtrl  WHEN "000000",
               DoubleCtrl  WHEN "001000",
               DoubleCtrl  WHEN "011011",
               DoubleCtrl  WHEN "011001",
               DoubleCtrl  WHEN "011000",
               SingleCtrl  WHEN   OTHERS;

WITH FinalSelect SELECT
UnknownInst <= SingleUnkwn WHEN "001101",
               SingleUnkwn WHEN "000101",
               DoubleUnkwn WHEN "000100",
               TripleUnkwn WHEN "100100",
               TripleUnkwn WHEN "001100",
               DoubleUnkwn WHEN "011100",
               TripleUnkwn WHEN "111100",
               DoubleUnkwn WHEN "000000",
               DoubleUnkwn WHEN "001000",
               DoubleUnkwn WHEN "011011",
               DoubleUnkwn WHEN "011001",
               DoubleUnkwn WHEN "011000",
               SingleUnkwn WHEN   OTHERS;

WITH FinalSelect SELECT
GprUsed     <= SingleGprId WHEN "001101",
               SingleGprId WHEN "000101",
               DoubleGprId WHEN "000100",
               TripleGprId WHEN "100100",
               TripleGprId WHEN "001100",
               DoubleGprId WHEN "011100",
               TripleGprId WHEN "111100",
               DoubleGprId WHEN "000000",
               DoubleGprId WHEN "001000",
               DoubleGprId WHEN "011011",
               DoubleGprId WHEN "011001",
               DoubleGprId WHEN "011000",
               SingleGprId WHEN   OTHERS;

------------------------------------------------------------
-- 
-- Select the control word if the instruction depends on
-- op code
-- 
-- Use the same process to get the unkown signals for this
-- case
-- 
------------------------------------------------------------

WITH SingleSel SELECT
SingleCtrl <=  (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "01"        -- Immediate data Format        : U
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
                             WbDataSrc    => "010"  ,    -- Select data Source to write  : Imm Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLui                      -- Instruction                  : Lui
               )-------------------------------------------------------------------------------------------------------------
               WHEN (                    "0110111"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "01"        -- Immediate data Format        : U
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "01"   ,    -- Alu Operands source          : Pc, Imm Data
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstAuipc                    -- Instruction                  : Auipc
               )-------------------------------------------------------------------------------------------------------------
               WHEN (                    "0010111"),
               
               (-------------------------------------------------------------------------------------------------------------
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
               )-------------------------------------------------------------------------------------------------------------
               WHEN                          OTHERS;

WITH SingleSel SELECT
SingleUnkwn <= '0' WHEN ("0110111"),
               '0' WHEN ("0010111"),
               '1' WHEN      OTHERS;

WITH SingleSel SELECT
SingleGprId <=  "100" WHEN (                    "0110111"),
                "100" WHEN (                    "0010111"),
                "000" WHEN                          OTHERS;

------------------------------------------------------------
-- 
-- Select the control word if the instruction depends on
-- op code
-- 
-- Use the same process to get the unkown signals for this
-- case
-- 
------------------------------------------------------------

WITH DoubleSel SELECT
DoubleCtrl <=  (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstAddi                     -- Instruction                  : Addi
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0000010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00111",    -- Alu Operation Id             : Substract Signed
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "101"  ,    -- Select data Source to write  : Set Value
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSlti                     -- Instruction                  : Slti
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0100010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00110",    -- Alu Operation Id             : Substract
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "101"  ,    -- Select data Source to write  : Set Value
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSltiu                    -- Instruction                  : Sltiu
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0110010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00010",    -- Alu Operation Id             : Xor
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstXori                     -- Instruction                  : Xori
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1000010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00001",    -- Alu Operation Id             : Or
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstOri                      -- Instruction                  : Ori
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1100010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00000",    -- Alu Operation Id             : And
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstAndi                     -- Instruction                  : Andi
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1110010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "000"       -- CSR Logical Operation        : Write GPR
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrw                    -- Instruction                  : Csrrw
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0011110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "001"       -- CSR Logical Operation        : Write (Csr OR Gpr)
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrs                    -- Instruction                  : Csrrs
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0101110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "010"       -- CSR Logical Operation        : Write (Csr AND NOT Gpr)
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrc                    -- Instruction                  : Csrrc
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0111110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "011"       -- CSR Logical Operation        : Write (Unsigned Data)
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrwi                   -- Instruction                  : Csrrwi
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1011110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "100"       -- CSR Logical Operation        : Write (Csr OR Unsigned Data)
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrsi                   -- Instruction                  : Csrrsi
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1101110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11111",    -- Alu Operation Id             : None
                             AluSource    => "00"   ,    -- Alu Operands source          : None
                             CsrOperation => "101"       -- CSR Logical Operation        : Write (Csr AND NOT Unsigned Data)
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "000"  ,    -- Select data Source to write  : Csr Data
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstCsrrci                   -- Instruction                  : Csrrci
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1111110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1100"      -- Rd/Wr And Data Size          : Read Byte
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "001"  ,    -- Select data Source to write  : Mem Data Rd
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLb                       -- Instruction                  : Lb
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0000000011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1011"      -- Rd/Wr And Data Size          : Read Hex
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "001"  ,    -- Select data Source to write  : Mem Data Rd
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLh                       -- Instruction                  : Lh
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0010000011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1010"      -- Rd/Wr And Data Size          : Read Word
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "001"  ,    -- Select data Source to write  : Mem Data Rd
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLw                       -- Instruction                  : Lw
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0100000011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1000"      -- Rd/Wr And Data Size          : Read Unsigned Byte
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "001"  ,    -- Select data Source to write  : Mem Data Rd
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLbu                      -- Instruction                  : Lbu
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1000000011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1001"      -- Rd/Wr And Data Size          : Read Unigned Hex
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "001"  ,    -- Select data Source to write  : Mem Data Rd
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstLhu                      -- Instruction                  : Lhu
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1010000011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1110"      -- Rd/Wr And Data Size          : Write Signed Byte
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "111"  ,    -- Select data Source to write  : No Source
                             GprWrEna     => '0'         -- Enables Writing data to GPR  : No
                            ),                           --                                
                InstId   => InstSb                       -- Instruction                  : Sb
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0000100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1111"      -- Rd/Wr And Data Size          : Write Signed Hex
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "111"  ,    -- Select data Source to write  : No Source
                             GprWrEna     => '0'         -- Enables Writing data to GPR  : No
                            ),                           --                                
                InstId   => InstSh                       -- Instruction                  : Sh
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0010100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "1101"      -- Rd/Wr And Data Size          : Write Word
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "111"  ,    -- Select data Source to write  : No Source
                             GprWrEna     => '0'         -- Enables Writing data to GPR  : No
                            ),                           --                                
                InstId   => InstSw                       -- Instruction                  : Sw
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0100100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "01"   ,    -- Alu Operands source          : Pc , Imm Data
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '1'    ,    -- Enables Alu writing on pc    : AluRes
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "100"  ,    -- Select data Source to write  : PcNext
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstJal                      -- Instruction                  : Jal
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0001101111"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '1'    ,    -- Enables Sign extended        : Yes
                             Format       => "10"        -- Immediate data Format        : I
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "10"   ,    -- Alu Operands source          : GprData1, ImmData
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '1'    ,    -- Enables Alu writing on pc    : AluRes
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "100"  ,    -- Select data Source to write  : PcNext
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstJalr                     -- Instruction                  : Jalr
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0001100111"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBeq                      -- Instruction                  : Beq
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0001100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBne                      -- Instruction                  : Bne
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "0011100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBlt                      -- Instruction                  : Blt
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1001100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBge                      -- Instruction                  : Bge
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1011100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBltu                     -- Instruction                  : Bltu
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1101100011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "11"        -- Immediate data Format        : S
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
                InstId   => InstBgeu                     -- Instruction                  : Bgeu
               )-------------------------------------------------------------------------------------------------------------
               WHEN (            "1111100011"),
               
               (-------------------------------------------------------------------------------------------------------------
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
               )-------------------------------------------------------------------------------------------------------------
               WHEN                     OTHERS;

WITH DoubleSel SELECT
DoubleUnkwn <=  '0' WHEN ("0000010011"),
                '0' WHEN ("0100010011"),
                '0' WHEN ("0110010011"),
                '0' WHEN ("1000010011"),
                '0' WHEN ("1100010011"),
                '0' WHEN ("1110010011"),
                '0' WHEN ("0011110011"),
                '0' WHEN ("0101110011"),
                '0' WHEN ("0111110011"),
                '0' WHEN ("1011110011"),
                '0' WHEN ("1101110011"),
                '0' WHEN ("1111110011"),
                '0' WHEN ("0000000011"),
                '0' WHEN ("0010000011"),
                '0' WHEN ("0100000011"),
                '0' WHEN ("1000000011"),
                '0' WHEN ("1010000011"),
                '0' WHEN ("0000100011"),
                '0' WHEN ("0010100011"),
                '0' WHEN ("0100100011"),
                '0' WHEN ("0001101111"),
                '0' WHEN ("0001100111"),
                '0' WHEN ("0001100011"),
                '0' WHEN ("0011100011"),
                '0' WHEN ("1001100011"),
                '0' WHEN ("1011100011"),
                '0' WHEN ("1101100011"),
                '0' WHEN ("1111100011"),
                '1' WHEN         OTHERS;

WITH DoubleSel SELECT
DoubleGprId <= "101" WHEN (            "0000010011"),
               "101" WHEN (            "0100010011"),
               "101" WHEN (            "0110010011"),
               "101" WHEN (            "1000010011"),
               "101" WHEN (            "1100010011"),
               "101" WHEN (            "1110010011"),
               "101" WHEN (            "0011110011"),
               "101" WHEN (            "0101110011"),
               "101" WHEN (            "0111110011"),
               "100" WHEN (            "1011110011"),
               "100" WHEN (            "1101110011"),
               "100" WHEN (            "1111110011"),
               "101" WHEN (            "0000000011"),
               "101" WHEN (            "0010000011"),
               "101" WHEN (            "0100000011"),
               "101" WHEN (            "1000000011"),
               "101" WHEN (            "1010000011"),
               "011" WHEN (            "0000100011"),
               "011" WHEN (            "0010100011"),
               "011" WHEN (            "0100100011"),
               "100" WHEN (            "0001101111"),
               "101" WHEN (            "0001100111"),
               "011" WHEN (            "0001100011"),
               "011" WHEN (            "0011100011"),
               "011" WHEN (            "1001100011"),
               "011" WHEN (            "1011100011"),
               "011" WHEN (            "1101100011"),
               "011" WHEN (            "1111100011"),
               "000" WHEN                     OTHERS;

------------------------------------------------------------
-- 
-- Select the control word if the instruction depends on
-- op code
-- 
-- Use the same process to get the unkown signals for this
-- case
-- 
------------------------------------------------------------

WITH TripleSel SELECT
TripleCtrl <=  (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10110",    -- Alu Operation Id             : SLL/I
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSlli                     -- Instruction                  : Slli
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000010010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10100",    -- Alu Operation Id             : SRL/I
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSrli                     -- Instruction                  : Srli
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000001010010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10101",    -- Alu Operation Id             : SRA/I
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSrai                     -- Instruction                  : Srai
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("01000001010010011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00100",    -- Alu Operation Id             : Add
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstAdd                      -- Instruction                  : Add
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000000110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00110",    -- Alu Operation Id             : Substract
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSub                      -- Instruction                  : Sub
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("01000000000110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10010",    -- Alu Operation Id             : SLL
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSll                      -- Instruction                  : Sll
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000010110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00111",    -- Alu Operation Id             : Substract Signed
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "101"  ,    -- Select data Source to write  : Set Value
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSlt                      -- Instruction                  : Slt
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000100110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00110",    -- Alu Operation Id             : Substract
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "101"  ,    -- Select data Source to write  : Set Value
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSltu                     -- Instruction                  : Sltu
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000110110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00010",    -- Alu Operation Id             : Xor
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstXor                      -- Instruction                  : Xor
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000001000110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10000",    -- Alu Operation Id             : SRL
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSrl                      -- Instruction                  : Srl
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000001010110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "10001",    -- Alu Operation Id             : SRA
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstSra                      -- Instruction                  : Sra
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("01000001010110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00001",    -- Alu Operation Id             : OR
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstOr                       -- Instruction                  : Or
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000001100110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "00000",    -- Alu Operation Id             : AND
                             AluSource    => "11"   ,    -- Alu Operands source          : GpreData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstAnd                      -- Instruction                  : And
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000001110110011"),
               
               (-------------------------------------------------------------------------------------------------------------
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
                InstId   => InstRet                      -- Instruction                  : U Return
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000000001110011"),
               
               (-------------------------------------------------------------------------------------------------------------
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
                InstId   => InstRet                      -- Instruction                  : S Return
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00010000001110011"),
               
               (-------------------------------------------------------------------------------------------------------------
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
                InstId   => InstRet                      -- Instruction                  : M Return
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00110000001110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "11000",    -- Alu Operation Id             : Multiply Low
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstMul                      -- Instruction                  : Mul
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000010000110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01011",    -- Alu Operation Id             : Multiply High SS
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstMulh                     -- Instruction                  : Mulh
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000010010110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01010",    -- Alu Operation Id             : Multiply High SU
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstMulhsu                   -- Instruction                  : Mulhsu
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000010100110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01000",    -- Alu Operation Id             : Multiply High UU
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstMulhu                    -- Instruction                  : Mulhu
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000010110110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01101",    -- Alu Operation Id             : Divide signed
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstDiv                      -- Instruction                  : Div
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000011000110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01100",    -- Alu Operation Id             : Divide Unsigned
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstDivu                     -- Instruction                  : Divu
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000011010110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01111",    -- Alu Operation Id             : Remainder Signed
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstRem                      -- Instruction                  : Rem
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000011100110011"),
               
               (-------------------------------------------------------------------------------------------------------------
                DecStage => (                            --                                
                             ImmSext      => '0'    ,    -- Enables Sign extended        : No
                             Format       => "00"        -- Immediate data Format        : R
                            ),                           --                                
                AluStage => (                            --                                
                             AluOperation => "01110",    -- Alu Operation Id             : Remainder Unsigned
                             AluSource    => "11"   ,    -- Alu Operands source          : GprData1, GprData2
                             CsrOperation => "111"       -- CSR Logical Operation        : Do Not Write
                            ),                           --                                
                MStage   => (                            --                                
                             PcEnaLoadAlu => '0'    ,    -- Disables Alu writing on pc   : Do Nothing
                             MdrOperation => "0000"      -- Rd/Wr And Data Size          : Do nothing
                            ),                           --                                
                WbStage  => (                            --                                
                             WbDataSrc    => "011"  ,    -- Select data Source to write  : Alu Result
                             GprWrEna     => '1'         -- Enables Writing data to GPR  : Yes
                            ),                           --                                
                InstId   => InstRemu                     -- Instruction                  : Remu
               )-------------------------------------------------------------------------------------------------------------
               WHEN ("00000011110110011"),
               
               (-------------------------------------------------------------------------------------------------------------
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
               )-------------------------------------------------------------------------------------------------------------
               WHEN                OTHERS;

WITH TripleSel SELECT
TripleUnkwn <= '0' WHEN ("00000000010010011"),
               '0' WHEN ("00000001010010011"),
               '0' WHEN ("01000001010010011"),
               '0' WHEN ("00000000000110011"),
               '0' WHEN ("01000000000110011"),
               '0' WHEN ("00000000010110011"),
               '0' WHEN ("00000000100110011"),
               '0' WHEN ("00000000110110011"),
               '0' WHEN ("00000001000110011"),
               '0' WHEN ("00000001010110011"),
               '0' WHEN ("01000001010110011"),
               '0' WHEN ("00000001100110011"),
               '0' WHEN ("00000001110110011"),
               '0' WHEN ("00000000001110011"),
               '0' WHEN ("00010000001110011"),
               '0' WHEN ("00110000001110011"),
               '0' WHEN ("00000010000110011"),
               '0' WHEN ("00000010010110011"),
               '0' WHEN ("00000010100110011"),
               '0' WHEN ("00000010110110011"),
               '0' WHEN ("00000011000110011"),
               '0' WHEN ("00000011010110011"),
               '0' WHEN ("00000011100110011"),
               '0' WHEN ("00000011110110011"),
               '1' WHEN                OTHERS;

WITH TripleSel SELECT
TripleGprId <= "101" WHEN ("00000000010010011"),
               "101" WHEN ("00000001010010011"),
               "101" WHEN ("01000001010010011"),
               "111" WHEN ("00000000000110011"),
               "111" WHEN ("01000000000110011"),
               "111" WHEN ("00000000010110011"),
               "111" WHEN ("00000000100110011"),
               "111" WHEN ("00000000110110011"),
               "111" WHEN ("00000001000110011"),
               "111" WHEN ("00000001010110011"),
               "111" WHEN ("01000001010110011"),
               "111" WHEN ("00000001100110011"),
               "111" WHEN ("00000001110110011"),
               "000" WHEN ("00000000001110011"),
               "000" WHEN ("00010000001110011"),
               "000" WHEN ("00110000001110011"),
               "111" WHEN ("00000010000110011"),
               "111" WHEN ("00000010010110011"),
               "111" WHEN ("00000010100110011"),
               "111" WHEN ("00000010110110011"),
               "111" WHEN ("00000011000110011"),
               "111" WHEN ("00000011010110011"),
               "111" WHEN ("00000011100110011"),
               "111" WHEN ("00000011110110011"),
               "000" WHEN                OTHERS;

------------------------------------------------------------
-- 
-- Use the branch-specific opcode to set the branch value
-- to the respective output
-- 
------------------------------------------------------------

WITH OpCode SELECT
BranchType <=   ('1' & Funct3) WHEN ("1100011"),
                (      "0000") WHEN      OTHERS;

END MainArch;

------------------------------------------------------------------------------------------
-- 
-- Summon This Block:
-- 
------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.MicroProgramMemory(MainArch)
--PORT MAP   (OpCode      => SLV,
--            Funct3      => SLV,
--            Funct7      => SLV,
--            ControlWord => SLV,
--            UnknownInst => SLV,
--            BranchType  => SLV,
--            GprUsed     => SLV 
--           );
------------------------------------------------------------------------------------------
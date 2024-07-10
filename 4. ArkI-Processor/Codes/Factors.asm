@ Instruction Order : Rd Rs1 Rs2 Imm

@ Each one of the following segments is intended for max 16 instructions
& StartCore0
@ Pc initial value = 0d000 = 0x00
LUI    R21  1048560 @ R21 <= 000F FFF0 << 12 = FFFF 0000     | Pc =   0 =000
ADDI   R27 R00 2048 @ Set the eleventh bit to one            | Pc =   1 =001
JALR   R00 R00   64 @ Jump to the main program               | Pc =   2 =002

& StartCore1
@ Pc initial value = 0d016 = 0x10
JALR   R00 R00   16 @ Disable 2nd core                       | Pc =  16 =010

& ErrorRoutine
@ Pc initial value = 0d032 = 0x20
JALR   R00 R00   32 @ Jump to This address                   | Pc =  32 =020
MRET                @ Return from exception                  | Pc =  33 =021

& LoadData
@ Pc initial value = 0d048 = 0x30
LW     R20 R21    0 @ Read info from peripheral to R20       | Pc =  48 =030
ADDI   R31 R00    1 @ Set Start Flag to One                  | Pc =  49 =031
NoOp                @                                        | Pc =  50 =032
NoOp                @                                        | Pc =  51 =033
NoOp                @                                        | Pc =  52 =034
NoOp                @                                        | Pc =  53 =035
NoOp                @                                        | Pc =  54 =036
MRET                @ Return from exception                  | Pc =  55 =037
@-------------------------------------------------------------------------------
@ M[0xFFFF0000] => Number whose factors are going to be
@                  calculated
@ 
@ M[0xFFFF0001] => registers to store the first 32 factors
@       .
@       . to
@       .
@ M[0xFFFF0020]
@-------------------------------------------------------------------------------

& MainProgram
@ Pc initial value = 0d064 = 0x40
ADDI   R20 R00    0 @ Initialize the R20 register to 0       | Pc =  64 =040
CSRRS  R00 R27  772 @ Enable interruptions                   | Pc =  65 =041
ADDI   R31 R00    0 @ Set Start Flag to zero                 | Pc =  66 =042
ADDI   R30 R00    1 @ Set Constant value 1                   | Pc =  67 =043
ADDI   R29 R00    6 @ Set Constant value 6                   | Pc =  68 =044
ADDI   R01 R00    2 @ Initialize TestVal1     to 2           | Pc =  69 =045
ADDI   R02 R00    3 @ Initialize TestVal2     to 3           | Pc =  70 =046
ADDI   R03 R00    4 @ Initialize TestVal3     to 4           | Pc =  71 =047
ADDI   R04 R00    5 @ Initialize TestVal4     to 5           | Pc =  72 =048
ADDI   R05 R00    6 @ Initialize TestVal5     to 6           | Pc =  73 =049
ADDI   R06 R00    7 @ Initialize TestVal6     to 7           | Pc =  74 =04A
ADDI   R07 R00    1 @ Initialize Counter      to 1           | Pc =  75 =04B
ADDI   R11 R00    0 @ Initialize Result1      to 0           | Pc =  76 =04C
ADDI   R12 R00    0 @ Initialize Result2      to 0           | Pc =  77 =04D
ADDI   R13 R00    0 @ Initialize Result3      to 0           | Pc =  78 =04E
ADDI   R14 R00    0 @ Initialize Result4      to 0           | Pc =  79 =04F
ADDI   R15 R00    0 @ Initialize Result5      to 0           | Pc =  80 =050
ADDI   R16 R00    0 @ Initialize Result6      to 0           | Pc =  81 =051
ADDI   R17 R21    1 @ Get Memory write address               | Pc =  82 =052
BEQ    R31 R30   13 @ Go to Get Factors                      | Pc =  83 =053
JALR   R00 R00   82 @ Jump to previous BEQ                   | Pc =  84 =054
@-------------------------------------------------------------------------------
@ R01 to R06 : Test values, a collection of the six possible
@              factor values to be tested (TV)
@ 
@ R07        : Counter used to test each possible test value
@ 
@ R11 to R16 : Partial results (PR)
@ R17        : Memory write address
@ 
@ R20        : Number whose factors are going to be
@              calculated
@ 
@ R21        : base address for peripheral communication
@ 
@ R27        : Constant 0x00000400
@ R28        : Auxiliar variable
@ R29        : Constant 6
@ R30        : Constant 1
@ R31        : Start Flag; Initial value = 0
@-------------------------------------------------------------------------------

&GetFactors
@ Pc initial value = 0d096 = 0x60
CSRRC  R00 R27  772            @ Disable interruptions       |Pc =  96 =060
SRL    R28 R20  R30            @ R28 <= R20/2                |Pc =  97 =061
NoOp                           @                             |Pc =  98 =062
NoOp                           @                             |Pc =  99 =063
NoOp                           @                             |Pc = 100 =064
NoOp                           @                             |Pc = 101 =065
NoOp                           @                             |Pc = 102 =066
ADD    R28 R28 R29             @ R28 <= R28 + 6              |Pc = 103 =067
@ 1st cycle
    @2nd Cycle
        MUL    R11 R01 R07     @ PR(1) <= TV(1) * Counter    |Pc = 104 =068
        MUL    R12 R02 R07     @ PR(2) <= TV(2) * Counter    |Pc = 105 =069
        MUL    R13 R03 R07     @ PR(3) <= TV(3) * Counter    |Pc = 106 =06A
        MUL    R14 R04 R07     @ PR(4) <= TV(4) * Counter    |Pc = 107 =06B
        MUL    R15 R05 R07     @ PR(5) <= TV(5) * Counter    |Pc = 108 =06C
        MUL    R16 R06 R07     @ PR(6) <= TV(6) * Counter    |Pc = 109 =06D
        ADDI   R07 R07    1    @ Counter up by one           |Pc = 110 =06E
        BNE    R11 R20    8    @ GoTo 106 if PR(1) != R20    |Pc = 111 =06F
            SW     R17 R01   0 @ Store a result              |Pc = 112 =070
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 113 =071
            NoOp               @                             |Pc = 114 =072
            NoOp               @                             |Pc = 115 =073
            NoOp               @                             |Pc = 116 =074
            NoOp               @                             |Pc = 117 =075
            NoOp               @                             |Pc = 118 =076
                               @                             |
        BNE    R12 R20    8    @ GoTo 117 if PR(2) != R20    |Pc = 119 =077
            SW     R17 R02   0 @ Store a result              |Pc = 120 =078
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 121 =079
            NoOp               @                             |Pc = 122 =07A
            NoOp               @                             |Pc = 123 =07B
            NoOp               @                             |Pc = 124 =07C
            NoOp               @                             |Pc = 125 =07D
            NoOp               @                             |Pc = 126 =07E
                               @                             |
        BNE    R13 R20    8    @ GoTo 120 if PR(3) != R20    |Pc = 127 =07F
            SW     R17 R03   0 @ Store a result              |Pc = 128 =080
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 129 =081
            NoOp               @                             |Pc = 130 =082
            NoOp               @                             |Pc = 131 =083
            NoOp               @                             |Pc = 132 =084
            NoOp               @                             |Pc = 133 =085
            NoOp               @                             |Pc = 134 =086
                               @                             |
        BNE    R14 R20    8    @ GoTo 123 if PR(4) != R20    |Pc = 135 =087
            SW     R17 R04   0 @ Store a result              |Pc = 136 =088
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 137 =089
            NoOp               @                             |Pc = 138 =08A
            NoOp               @                             |Pc = 139 =08B
            NoOp               @                             |Pc = 140 =08C
            NoOp               @                             |Pc = 141 =08D
            NoOp               @                             |Pc = 142 =08E
                               @                             |
        BNE    R15 R20    8    @ GoTo 126 if PR(5) != R20    |Pc = 143 =08F
            SW     R17 R05   0 @ Store a result              |Pc = 144 =090
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 145 =091
            NoOp               @                             |Pc = 146 =092
            NoOp               @                             |Pc = 147 =093
            NoOp               @                             |Pc = 148 =094
            NoOp               @                             |Pc = 149 =095
            NoOp               @                             |Pc = 150 =096
                               @                             |
        BNE    R16 R20    8    @ GoTo 129 if PR(6) != R20    |Pc = 151 =097
            SW     R17 R06   0 @ Store a result              |Pc = 152 =098
            ADDI   R17 R17   1 @ Memory write address + 1    |Pc = 153 =099
            NoOp               @                             |Pc = 154 =09A
            NoOp               @                             |Pc = 155 =09B
            NoOp               @                             |Pc = 156 =09C
            NoOp               @                             |Pc = 157 =09D
            NoOp               @                             |Pc = 158 =09E
                               @                             |
        BGE    R28 R07 4041    @ GoTo 104 if R28 >= R07      |Pc = 159 =09F
                               @                             |
    ADDI   R07 R00   2         @ Reset Counter value         |Pc = 160 =0A0
    ADD    R01 R01 R29         @ Increase TV(1) by 6         |Pc = 161 =0A1
    ADD    R02 R02 R29         @ Increase TV(2) by 6         |Pc = 162 =0A2
    ADD    R03 R03 R29         @ Increase TV(3) by 6         |Pc = 163 =0A3
    ADD    R04 R04 R29         @ Increase TV(4) by 6         |Pc = 164 =0A4
    ADD    R05 R05 R29         @ Increase TV(5) by 6         |Pc = 165 =0A5
    ADD    R06 R06 R29         @ Increase TV(6) by 6         |Pc = 166 =0A6
    NoOp                       @                             |Pc = 167 =0A7
    NoOp                       @                             |Pc = 168 =0A8
    NoOp                       @                             |Pc = 169 =0A9
    NoOp                       @                             |Pc = 170 =0AA
    NoOp                       @                             |Pc = 171 =0AB
    BGE    R28 R06 4028        @ GoTo 104 if R28 >= TV(6)    |Pc = 172 =0AC
                               @                             |
ADDI   R31 R00    0 @ Set Start Flag to zero                 |Pc = 173 =0AD
JALR   R00 R00   64 @ Jump to previous BEQ                   |Pc = 174 =0AE
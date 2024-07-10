@ Instruction Order : Rd Rs1 Rs2 Imm

@ Each one of the following segments is intended for max 16 instructions
& StartCore0
@ Pc initial value = 0d000 = 0x00
LUI    R28   524288 @ R31 <= 0008 0000 << 12 = 8000 0000     | Pc =   0 =000
NoOp                @                                        | Pc =   1 =001
NoOp                @                                        | Pc =   2 =002
NoOp                @                                        | Pc =   3 =003
CSRRW  R29 R28 4090 @ Toggle core to act as a monocycle core | Pc =   4 =004
NoOp                @                                        | Pc =   5 =005
NoOp                @                                        | Pc =   6 =006
NoOp                @                                        | Pc =   7 =007
NoOp                @                                        | Pc =   8 =008
NoOp                @                                        | Pc =   9 =009
JALR   R00 R00  176 @ Jump to Main Program                   | Pc =  10 =00A


& StartCore1
@ Pc initial value = 0d016 = 0x10
NoOp                @                                        | Pc =  16 =010
NoOp                @                                        | Pc =  17 =011
NoOp                @                                        | Pc =  18 =012
NoOp                @                                        | Pc =  19 =013
NoOp                @                                        | Pc =  20 =014
NoOp                @                                        | Pc =  21 =015
NoOp                @                                        | Pc =  22 =016
NoOp                @                                        | Pc =  23 =017
NoOp                @                                        | Pc =  24 =018
NoOp                @                                        | Pc =  25 =019
NoOp                @                                        | Pc =  26 =01A
NoOp                @                                        | Pc =  27 =01B
NoOp                @                                        | Pc =  28 =01C
NoOp                @                                        | Pc =  29 =01D
JALR   R00 R00  176 @ Jump to Main Program                   | Pc =  30 =01E
NoOp                @                                        | Pc =  31 =01F

& ErrorRoutine
@ Pc initial value = 0d032 = 0x20
JALR   R00 R00  208 @ Jump to the program's end              | Pc =  32 =020
MRET                @ Return from exception                  | Pc =  33 =021

& Interruption0Core0
@ Pc initial value = 0d048 = 0x30
MRET                @ Return from exception                  | Pc =  48 =030

& Interruption1Core0
@ Pc initial value = 0d064 = 0x40
MRET                @ Return from exception                  | Pc =  64 =040

& Interruption2Core0
@ Pc initial value = 0d080 = 0x50
MRET                @ Return from exception                  | Pc =  80 =050

& Interruption3Core0
@ Pc initial value = 0d096 = 0x60
MRET                @ Return from exception                  | Pc = 106 =060

& Interruption0Core1
@ Pc initial value = 0d112 = 0x70
MRET                @ Return from exception                  | Pc = 112 =070

& Interruption1Core1
@ Pc initial value = 0d128 = 0x80
MRET                @ Return from exception                  | Pc = 138 =080

& Interruption2Core1
@ Pc initial value = 0d144 = 0x90
MRET                @ Return from exception                  | Pc = 144 =090

& Interruption3Core1
@ Pc initial value = 0d160 = 0xA0
MRET                @ Return from exception                  | Pc = 160 =0A0

& MainProgram
@ Pc initial value = 0d176 = 0xB0
@-------------------------------------------------------------------------------
@ Set initial values
@-------------------------------------------------------------------------------
LUI    R10       12 @ R05 <= 0000 000C << 12 = 0000 C000     | Pc = 176 =0B0
ADDI   R01 R00    0 @ R01 <= 0  + 0          = 0             | Pc = 177 =0B1
ADDI   R02 R00    1 @ R02 <= 0  + 1          = 1             | Pc = 178 =0B2
ADDI   R11 R00    1 @ R06 <= 0  + 1          = 1             | Pc = 179 =0B3
SRLI   R10 R10   12 @ R05 <= R05 >> 12 = 0000 000C           | Pc = 180 =0B4
NoOp                @                                        | Pc = 181 =0B5
NoOp                @                                        | Pc = 182 =0B6
NoOp                @                                        | Pc = 183 =0B7
NoOp                @                                        | Pc = 184 =0B8
@-------------------------------------------------------------------------------
@ F(n) => Fibonacci term number n
@ 
@ R01: F(n-2), Initially 0
@ R02: F(n-1), Initially 1
@ R03: F(n  )
@ R04: F(n-3), uninitialized
@ R05: F(n-4), uninitialized
@ R06: F(n-5), uninitialized
@ R07: F(n-6), uninitialized
@ R08: F(n-7), uninitialized
@ R09: F(n-8), uninitialized
@ 
@ R10: Final term of the series
@ R11: Term that is being calculated currently, Initially 1
@-------------------------------------------------------------------------------

@-------------------------------------------------------------------------------
@ Verify final term for cases 0 and 1
@-------------------------------------------------------------------------------
ADDI   R03 R00    0 @ Set 0th term in R3                     | Pc = 185 =0B9
BEQ    R00 R10   22 @ Go to end if final term is zero        | Pc = 186 =0BA
ADDI   R03 R00    1 @ Set 1st term in R3                     | Pc = 187 =0BB
BEQ    R02 R10   20 @ Go to end if final term is One         | Pc = 188 =0BC

@-------------------------------------------------------------------------------
@ Calculate the nth fibonacci number
@-------------------------------------------------------------------------------
ADDI   R11 R11    1 @ Add 1 to the Current Term counter      | Pc = 189 =0BD
NoOp                @                                        | Pc = 190 =0BE
ADD    R03 R01 R02  @ F(n) <= F(n-2) + F(n-1)                | Pc = 191 =0BF
ADD    R09 R08 R00  @ Set in R9 the F(n-8) Value             | Pc = 192 =0C0
ADD    R08 R07 R00  @ Set in R8 the F(n-7) Value             | Pc = 193 =0C1
ADD    R07 R06 R00  @ Set in R7 the F(n-6) Value             | Pc = 194 =0C2
ADD    R06 R05 R00  @ Set in R6 the F(n-5) Value             | Pc = 195 =0C3
ADD    R05 R04 R00  @ Set in R5 the F(n-4) Value             | Pc = 196 =0C4
ADD    R04 R01 R00  @ Set in R4 the F(n-3) Value             | Pc = 197 =0C5
ADD    R01 R02 R00  @ Set in R1 the F(n-2) Value             | Pc = 198 =0C6
ADD    R02 R03 R00  @ Set in R2 the F(n-1) Value             | Pc = 199 =0C7
BNE    R11 R10 4085 @ Go back 5 instructions if R06 < R05    | Pc = 200 =0C8
JALR   R00 R00  208 @ Jump to the program's end              | Pc = 201 =0C9

& End
@ Pc initial value = 0d192 = 0xD0
JALR   R00 R00  208 @ Jump to this position                  | Pc = 208 =0D0
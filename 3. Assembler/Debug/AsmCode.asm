@ Instruction Order : Rd Rs1 Rs2 Imm

@ Each one of the following segments is intended for max 16 instructions
& StartCore0
@ Pc initial value = 0d000 = 0x00
JAL    R10      176 @ Jump to MainCore1                          | Pc =   0 =000

& StartCore1
@ Pc initial value = 0d016 = 0x10
LUI    R28   524288 @ R31 <= 0008 0000 << 12 = 8000 0000         | Pc =  16 =010
NoOp                @                                            | Pc =  17 =011
NoOp                @                                            | Pc =  18 =012
NoOp                @                                            | Pc =  19 =013
CSRRW  R29 R28 4090 @ Toggle core to act as a single cycle core  | Pc =  20 =014
JAL    R10        2 @                                            | Pc =  21 =015
NoOp                @                                            | Pc =  22 =016
NoOp                @                                            | Pc =  23 =017
NoOp                @                                            | Pc =  24 =018
NoOp                @                                            | Pc =  25 =019
JALR   R00 R00  464 @ Jump to SecondCore                         | Pc =  26 =01A

& ErrorRoutine
@ Pc initial value = 0d032 = 0x20
LUI    R01        0 @ R01 <= 0000 0000 << 12 = 0000 0000         | Pc =  32 =021
LUI    R31        0 @ R31 <= 0000 0000 << 12 = 0000 0000         | Pc =  33 =022
LUI    R15   493440 @ R15 <= 0007 8780 << 12 = 7878 0000         | Pc =  34 =023
JALR   R00 R00  448 @                                            | Pc =  35 =024
MRET                @ Return from exception                      | Pc =  36 =025

& Interruption0Core0
@ Pc initial value = 0d048 = 0x30
CSRRW  R11 R01 4091 @ Misa    = R01           , R11 = Misa       | Pc = 311 =137
LUI    R21    65537 @ R21 <= 0001 0001 << 12 = 1000 1000         | Pc =  48 =030
LUI    R22    65537 @ R22 <= 0001 0001 << 12 = 1000 1000         | Pc =  49 =031
LUI    R23    65537 @ R23 <= 0001 0001 << 12 = 1000 1000         | Pc =  50 =032
LUI    R24    65537 @ R24 <= 0001 0001 << 12 = 1000 1000         | Pc =  51 =033
MRET                @ Return from exception                      | Pc =  52 =034

& Interruption1Core0
@ Pc initial value = 0d064 = 0x40
LUI    R21   131074 @ R21 <= 0002 0002 << 12 = 2000 2000         | Pc =  64 =040
LUI    R22   131074 @ R22 <= 0002 0002 << 12 = 2000 2000         | Pc =  65 =041
LUI    R23   131074 @ R23 <= 0002 0002 << 12 = 2000 2000         | Pc =  66 =042
LUI    R24   131074 @ R24 <= 0002 0002 << 12 = 2000 2000         | Pc =  67 =043
MRET                @ Return from exception                      | Pc =  68 =044

& Interruption2Core0
@ Pc initial value = 0d080 = 0x50
LUI    R21   196611 @ R21 <= 0003 0003 << 12 = 3000 3000         | Pc =  80 =050
LUI    R22   196611 @ R22 <= 0003 0003 << 12 = 3000 3000         | Pc =  81 =051
LUI    R23   196611 @ R23 <= 0003 0003 << 12 = 3000 3000         | Pc =  82 =052
LUI    R24   196611 @ R24 <= 0003 0003 << 12 = 3000 3000         | Pc =  83 =053
MRET                @ Return from exception                      | Pc =  84 =054

& Interruption3Core0
@ Pc initial value = 0d096 = 0x60
LUI    R21   262148 @ R21 <= 0004 0004 << 12 = 4000 4000         | Pc =  96 =060
LUI    R22   262148 @ R22 <= 0004 0004 << 12 = 4000 4000         | Pc =  97 =061
LUI    R23   262148 @ R23 <= 0004 0004 << 12 = 4000 4000         | Pc =  98 =062
LUI    R24   262148 @ R24 <= 0004 0004 << 12 = 4000 4000         | Pc =  99 =063
MRET                @ Return from exception                      | Pc = 100 =064

& Interruption0Core1
@ Pc initial value = 0d112 = 0x70
LUI    R21    65793 @ R21 <= 0001 0101 << 12 = 1010 1000         | Pc = 112 =070
LUI    R22    65793 @ R22 <= 0001 0101 << 12 = 1010 1000         | Pc = 113 =071
LUI    R23    65793 @ R23 <= 0001 0101 << 12 = 1010 1000         | Pc = 114 =072
LUI    R24    65793 @ R24 <= 0001 0101 << 12 = 1010 1000         | Pc = 115 =073
MRET                @ Return from exception                      | Pc = 116 =074

& Interruption1Core1
@ Pc initial value = 0d128 = 0x80
LUI    R21   131330 @ R21 <= 0002 0102 << 12 = 2010 2000         | Pc = 128 =080
LUI    R22   131330 @ R22 <= 0002 0102 << 12 = 2010 2000         | Pc = 129 =081
LUI    R23   131330 @ R23 <= 0002 0102 << 12 = 2010 2000         | Pc = 130 =082
LUI    R24   131330 @ R24 <= 0002 0102 << 12 = 2010 2000         | Pc = 131 =083
MRET                @ Return from exception                      | Pc = 132 =084

& Interruption2Core1
@ Pc initial value = 0d144 = 0x90
LUI    R21   196867 @ R21 <= 0003 0103 << 12 = 3010 3000         | Pc = 144 =090
LUI    R22   196867 @ R22 <= 0003 0103 << 12 = 3010 3000         | Pc = 145 =091
LUI    R23   196867 @ R23 <= 0003 0103 << 12 = 3010 3000         | Pc = 146 =092
LUI    R24   196867 @ R24 <= 0003 0103 << 12 = 3010 3000         | Pc = 147 =093
MRET                @ Return from exception                      | Pc = 148 =094

& Interruption3Core1
@ Pc initial value = 0d160 = 0xA0
LUI    R21   262404 @ R21 <= 0004 0104 << 12 = 4010 4000         | Pc = 160 =0A0
LUI    R22   262404 @ R22 <= 0004 0104 << 12 = 4010 4000         | Pc = 161 =0A1
LUI    R23   262404 @ R23 <= 0004 0104 << 12 = 4010 4000         | Pc = 162 =0A2
LUI    R24   262404 @ R24 <= 0004 0104 << 12 = 4010 4000         | Pc = 163 =0A3
MRET                @ Return from exception                      | Pc = 164 =0A4

& MainCore1
@-------------------------------------------------------------------------------
@ Pc initial value = 0d176 = 0xB0
@ Upload initial values, by usong LUI and then SRL
@ none of the following instructions generate a data dependency
@ however the 3rd and 4th SRLI and the ADDIs are in the limit for said condition
@ 
@ Here is also tested NoOp as a way to avoid stalls
@-------------------------------------------------------------------------------
LUI    R11        1 @ R11 <= 0000 0001 << 12 = 0000 1000         | Pc = 176 =0B0
LUI    R12  1048575 @ R12 <= 000F FFFF << 12 = FFFF F000         | Pc = 177 =0B1
LUI    R13       31 @ R13 <= 0000 001F << 12 = 0001 F000         | Pc = 178 =0B2
LUI    R14   699050 @ R14 <= 000A AAAA << 12 = AAAA A000         | Pc = 179 =0B3
LUI    R15   349525 @ R15 <= 0005 5555 << 12 = 5555 5000         | Pc = 180 =0B4
LUI    R16       17 @ R16 <= 0000 0011 << 12 = 0001 1000         | Pc = 181 =0B5
LUI    R17   524288 @ R17 <= 0008 0000 << 12 = 8000 0000         | Pc = 182 =0B6
SRLI   R01 R11   12 @ R01 <= R11 >> 12 = 0000 0001               | Pc = 183 =0B7
SRLI   R02 R12   12 @ R02 <= R12 >> 12 = 000F FFFF               | Pc = 184 =0B8
SRLI   R31 R12    0 @ R31 <= R12 >>  0 = FFFF F000               | Pc = 185 =0B9
LUI    R18   698880 @ R17 <= 000A AA00 << 12 = AAA0 0000         | Pc = 186 =0BA
SRLI   R03 R13   12 @ R03 <= R13 >> 12 = 0000 001F               | Pc = 187 =0BB
SRLI   R04 R14   12 @ R04 <= R14 >> 12 = 000A AAAA               | Pc = 188 =0BC
SRLI   R05 R15   12 @ R05 <= R15 >> 12 = 0005 5555               | Pc = 189 =0BD
SRLI   R06 R16   12 @ R06 <= R16 >> 12 = 0000 0011               | Pc = 190 =0BE
ADDI   R31 R00 4095 @ R31 <= R00 + FFF = FFFF FFFF               | Pc = 191 =0BF
NoOp                @                                            | Pc = 192 =0C0
NoOp                @                                            | Pc = 193 =0C1
NoOp                @                                            | Pc = 194 =0C2
ADD    R07 R18 R04  @ R07 <= R18 + R04 = AAAA AAAA               | Pc = 195 =0C3
SUB    R30 R31 R17  @ R30 <= R31 - R17 = 7FFF FFFF               | Pc = 196 =0C4
NoOp                @                                            | Pc = 197 =0C5
NoOp                @                                            | Pc = 198 =0C6
NoOp                @                                            | Pc = 199 =0C7

@-------------------------------------------------------------------------------
@ Registers Values:
@ 
@      Decimal          Hexa   
@  1:             1 : 0000 0001
@  2:     1 048 575 : 000F FFFF
@  3:            31 : 0000 001F
@  4:       699 050 : 000A AAAA
@  5:       349 525 : 0005 5555
@  6:            17 : 0000 0011
@  7: 2 863 311 530 : AAAA AAAA
@
@ 30: 2 147 483 647 : 7FFF FFFF
@ 31: 4 294 967 295 : FFFF FFFF
@-------------------------------------------------------------------------------

@-------------------------------------------------------------------------------
@ Test Immediate instructions
@-------------------------------------------------------------------------------
AUIPC  R10        1 @ R10 <= C8 + (1 << 12)= 0d4111 = 0x10C8     | Pc = 200 =0C8
ADDI   R10 R00  225 @ R10 <= 0  + 225      = 0d225  = 0xE1       | Pc = 201 =0C9
ADDI   R10 R01    0 @ R10 <= 1  + 0        = 0d1                 | Pc = 202 =0CA
ADDI   R10 R01 4095 @ R10 <= 1  + (-1)     = 0d0                 | Pc = 203 =0CB
SLTI   R10 R00    1 @ R10 <= 1  ~ 0  <  1  ? Is true             | Pc = 204 =0CC
SLTI   R10 R00 4095 @ R10 <= 0  ~ 0  < -1  ? Is false            | Pc = 205 =0CD
SLTI   R10 R00 2047 @ R10 <= 1  ~ 0  < 2047? Is true             | Pc = 206 =0CE
SLTI   R10 R00    0 @ R10 <= 0  ~ 0  <  0  ? Is false            | Pc = 207 =0CF
SLTI   R10 R03   32 @ R10 <= 1  ~ 31 < 32  ? Is True             | Pc = 208 =0D0
SLTI   R10 R01    0 @ R10 <= 0  ~ 1  <  0  ? Is false            | Pc = 209 =0D1
SLTIU  R10 R00    1 @ R10 <= 1  ~ 0  <  1  ? Is true             | Pc = 210 =0D2
SLTIU  R10 R00 4095 @ R10 <= 1  ~ 0  < 4095? Is TRUE             | Pc = 211 =0D3
SLTIU  R10 R00 2047 @ R10 <= 1  ~ 0  < 2047? Is true             | Pc = 212 =0D4
SLTIU  R10 R00    0 @ R10 <= 0  ~ 0  <  0  ? Is false            | Pc = 213 =0D5
SLTIU  R10 R03   32 @ R10 <= 1  ~ 31 < 32  ? Is True             | Pc = 214 =0D6
SLTIU  R10 R01    0 @ R10 <= 0  ~ 1  <  0  ? Is false            | Pc = 215 =0D7
XORI   R10 R01    3 @ R10 <= 1  ^ 3        = 2                   | Pc = 216 =0D8
ORI    R10 R01    3 @ R10 <= 1  | 3        = 3                   | Pc = 217 =0D9
ANDI   R10 R01    3 @ R10 <= 1  & 3        = 1                   | Pc = 218 =0DA
SLLI   R10 R01    3 @ R10 <= 1 << 3        = 8                   | Pc = 219 =0DB
SRLI   R10 R31    0 @ R10 <= R31 >>u 0     = 0xFFFF FFFF         | Pc = 220 =0DC
SRLI   R10 R31    1 @ R10 <= R31 >>u 1     = 0x7FFF FFFF         | Pc = 221 =0DD
SRLI   R10 R31    8 @ R10 <= R31 >>u 8     = 0x00FF FFFF         | Pc = 222 =0DE
SRLI   R10 R31   31 @ R10 <= R31 >>u 31    = 0x0000 0001         | Pc = 223 =0DF
SRAI   R10 R07    0 @ R10 <= R31 >>S 0     = 0xAAAA AAAA         | Pc = 224 =0E0
SRAI   R10 R07    1 @ R10 <= R31 >>S 1     = 0xD555 5555         | Pc = 225 =0E1
SRAI   R10 R07    8 @ R10 <= R31 >>S 8     = 0xFFAA AAAA         | Pc = 226 =0E2
SRAI   R10 R07   31 @ R10 <= R31 >>S 31    = 0xFFFF FFFF         | Pc = 227 =0E3

@-------------------------------------------------------------------------------
@ Test ALU instructions
@ this test will also test data dependencies
@-------------------------------------------------------------------------------

ADD    R10 R04 R05  @ R10 <= R04 + R05                           | Pc = 228 =0E4
SUB    R11 R00 R01  @ R11 <= R00 - R01                           | Pc = 229 =0E5
                    @ Single dependency                          |  
SUB    R11 R00 R11  @ R11 <= R00 - R11                           | Pc = 230 =0E6
SUB    R11 R00 R00  @ R11 <= R00 - R00                           | Pc = 231 =0E7
SUB    R11 R03 R06  @ R11 <= R03 - R06                           | Pc = 232 =0E8
SLL    R10 R01 R01  @ R10 <= R01 << 1                            | Pc = 233 =0E9
SLL    R10 R01 R06  @ R10 <= R01 << 17                           | Pc = 234 =0EA
SLL    R10 R01 R03  @ R10 <= R01 << 31                           | Pc = 235 =0EB
SLL    R10 R01 R31  @ R10 <= R01 << 31 (MSBs Ignored)            | Pc = 236 =0EC
SLT    R10 R00 R31  @ R10 <= 0 ~ R00 <  R31 ? Is false           | Pc = 237 =0ED
SLT    R10 R00 R01  @ R10 <= 1 ~ R00 <  R01 ? Is true            | Pc = 238 =0EE
SLT    R10 R06 R03  @ R10 <= 1 ~ R06 <  R03 ? Is true            | Pc = 239 =0EF
SLT    R10 R06 R30  @ R10 <= 0 ~ R06 <  R30 ? Is false           | Pc = 240 =0F0
SLT    R10 R01 R00  @ R10 <= 0 ~ R01 <  R00 ? Is false           | Pc = 241 =0F1
SLTU   R10 R00 R31  @ R10 <= 1 ~ R00 <u R31 ? Is true            | Pc = 242 =0F2
SLTU   R10 R00 R01  @ R10 <= 1 ~ R00 <u R01 ? Is true            | Pc = 243 =0F3
SLTU   R10 R06 R03  @ R10 <= 1 ~ R06 <u R03 ? Is true            | Pc = 244 =0F4
SLTU   R10 R06 R30  @ R10 <= 0 ~ R06 <u R30 ? Is false           | Pc = 245 =0F5
SLTU   R10 R01 R00  @ R10 <= 0 ~ R01 <u R00 ? Is false           | Pc = 246 =0F6
XOR    R11 R04 R02  @ R11 <= R04 XOR R02                         | Pc = 247 =0F7
XOR    R11 R04 R04  @ R11 <= R04 XOR R04                         | Pc = 248 =0F8
OR     R11 R04 R02  @ R11 <= R04 OR  R02                         | Pc = 249 =0F9
OR     R11 R04 R04  @ R11 <= R04 OR  R04                         | Pc = 250 =0FA
AND    R11 R04 R02  @ R11 <= R04 AND R02                         | Pc = 251 =0FB
AND    R11 R04 R04  @ R11 <= R04 AND R04                         | Pc = 252 =0FC
SRL    R10 R31 R01  @ R10 <= R31 >>u R01                         | Pc = 253 =0FD
SRL    R10 R31 R06  @ R10 <= R31 >>u R06                         | Pc = 254 =0FE
SRL    R10 R31 R03  @ R10 <= R31 >>u R03                         | Pc = 255 =0FF
SRL    R10 R31 R31  @ R10 <= R31 >>u R31                         | Pc = 256 =100
SRA    R10 R31 R01  @ R10 <= R31 >>S R01                         | Pc = 257 =101
SRA    R10 R31 R06  @ R10 <= R31 >>S R06                         | Pc = 258 =102
SRA    R10 R31 R31  @ R10 <= R31 >>S R31                         | Pc = 259 =103
SRA    R10 R31 R01  @ R10 <= R31 >>S R01                         | Pc = 260 =104
MUL    R12 R01 R00  @ R12 <= R01  *  R00 (31 LSB)                | Pc = 261 =105
MUL    R12 R01 R31  @ R12 <= R01  *  R31 (31 LSB)                | Pc = 262 =106
MUL    R12 R06 R03  @ R12 <= R06  *  R03 (31 LSB)                | Pc = 263 =107
MUL    R12 R31 R31  @ R12 <= R31  *  R31 (31 LSB)                | Pc = 264 =108
MUL    R12 R31 R30  @ R12 <= R31  *  R00 (31 LSB)                | Pc = 265 =109
MUL    R12 R30 R31  @ R12 <= R30  *  R31 (31 LSB)                | Pc = 266 =10A
MUL    R12 R30 R30  @ R12 <= R30  *  R30 (31 LSB)                | Pc = 267 =10B
MULH   R13 R01 R00  @ R13 <= R01 S*S R00 (31 MSB)                | Pc = 268 =10C
MULH   R13 R01 R31  @ R13 <= R01 S*S R31 (31 MSB)                | Pc = 269 =10D
MULH   R13 R06 R03  @ R13 <= R06 S*S R03 (31 MSB)                | Pc = 270 =10E
MULH   R13 R31 R31  @ R13 <= R31 S*S R31 (31 MSB)                | Pc = 271 =10F
MULH   R13 R31 R30  @ R13 <= R31 S*S R30 (31 MSB)                | Pc = 272 =110
MULH   R13 R30 R31  @ R13 <= R30 S*S R31 (31 MSB)                | Pc = 273 =111
MULH   R13 R30 R30  @ R13 <= R30 S*S R30 (31 MSB)                | Pc = 274 =112
MULHSU R13 R01 R00  @ R13 <= R01 S*U R00 (31 MSB)                | Pc = 275 =113
MULHSU R13 R01 R31  @ R13 <= R01 S*U R31 (31 MSB)                | Pc = 276 =114
MULHSU R13 R06 R03  @ R13 <= R06 S*U R03 (31 MSB)                | Pc = 277 =115
MULHSU R13 R31 R31  @ R13 <= R31 S*U R31 (31 MSB)                | Pc = 278 =116
MULHSU R13 R31 R30  @ R13 <= R31 S*U R30 (31 MSB)                | Pc = 279 =117
MULHSU R13 R30 R31  @ R13 <= R30 S*U R31 (31 MSB)                | Pc = 280 =118
MULHSU R13 R30 R30  @ R13 <= R30 S*U R30 (31 MSB)                | Pc = 281 =119
MULHU  R13 R01 R00  @ R13 <= R01 U*U R00 (31 MSB)                | Pc = 282 =11A
MULHU  R13 R01 R31  @ R13 <= R01 U*U R31 (31 MSB)                | Pc = 283 =11B
MULHU  R13 R06 R03  @ R13 <= R06 U*U R03 (31 MSB)                | Pc = 284 =11C
MULHU  R13 R31 R31  @ R13 <= R31 U*U R31 (31 MSB)                | Pc = 285 =11D
MULHU  R13 R31 R30  @ R13 <= R31 U*U R30 (31 MSB)                | Pc = 286 =11E
MULHU  R13 R30 R31  @ R13 <= R30 U*U R31 (31 MSB)                | Pc = 287 =11F
MULHU  R13 R30 R30  @ R13 <= R30 U*U R30 (31 MSB)                | Pc = 288 =120
DIV    R13 R01 R00  @ R13 <= 0                                   | Pc = 289 =121
DIVU   R12 R01 R00  @ R13 <= 0                                   | Pc = 290 =122
REM    R11 R01 R00  @ R13 <= 0                                   | Pc = 291 =123
REMU   R13 R01 R00  @ R13 <= 0                                   | Pc = 292 =124
@ Test 2 to 5 chained dependencies                               |   
SLLI   R10 R01    1 @ chain start    --  2                       | Pc = 293 =125
SLLI   R10 R10    1 @ 1st dependency --  4                       | Pc = 294 =126
SLLI   R10 R10    1 @ 2nd dependency --  8                       | Pc = 295 =127
SLLI   R11 R01    1 @ chain start    --  2                       | Pc = 296 =128
SLLI   R11 R11    1 @ 1st dependency --  4                       | Pc = 297 =129
SLLI   R11 R11    1 @ 2nd dependency --  8                       | Pc = 298 =12A
SLLI   R11 R11    1 @ 3rd dependency -- 10                       | Pc = 299 =12B
SLLI   R12 R01    1 @ chain start    --  2                       | Pc = 300 =12C
SLLI   R12 R12    1 @ 1st dependency --  4                       | Pc = 301 =12D
SLLI   R12 R12    1 @ 2nd dependency --  8                       | Pc = 302 =12E
SLLI   R12 R12    1 @ 3rd dependency -- 10                       | Pc = 303 =12F
SLLI   R12 R12    1 @ 4th dependency -- 20                       | Pc = 304 =130
SLLI   R10 R01    1 @ chain start    --  2                       | Pc = 305 =131
SLLI   R10 R10    1 @ 1st dependency --  4                       | Pc = 306 =132
SLLI   R10 R10    1 @ 2nd dependency --  8                       | Pc = 307 =133
SLLI   R10 R10    1 @ 3rd dependency -- 10                       | Pc = 308 =134
SLLI   R10 R10    1 @ 4th dependency -- 20                       | Pc = 309 =135
SLLI   R10 R10    1 @ 5th dependency -- 40                       | Pc = 310 =136

@-------------------------------------------------------------------------------
@ Test CSR instructions
@-------------------------------------------------------------------------------

CSRRW  R11 R05  769 @ Misa    =/ R05          , R11 = Misa       | Pc = 311 =137
CSRRW  R11 R05  772 @ Mie     =  R05          , R11 = Mie        | Pc = 312 =138
CSRRW  R11 R01  773 @ Mtvec   =  R05          , R11 = Mtvec      | Pc = 313 =139
CSRRW  R11 R05  834 @ Mcause  =  R05          , R11 = Mcause     | Pc = 314 =13A
CSRRW  R11 R05  835 @ Mtval   =  R05          , R11 = Mtval      | Pc = 315 =13B
CSRRW  R11 R05 3858 @ MarchId =/ R05          , R11 = MarcId     | Pc = 316 =13C
CSRRW  R11 R05 3859 @ MimpId  =/ R05          , R11 = MimpId     | Pc = 317 =13D
CSRRW  R11 R05 3860 @ MhartId =/ R05          , R11 = MhartId    | Pc = 318 =13E
CSRRW  R11 R05 4090 @ Mps     =  R05          , R11 = Mps        | Pc = 319 =13F
CSRRW  R11 R05 4091 @ Mnev    =  R05          , R11 = Mnev       | Pc = 320 =140
CSRRW  R11 R05 4092 @ MePc0   =  R05          , R11 = MePc0      | Pc = 321 =141
CSRRS  R12 R31 4092 @ MePc0   =  MePc0 |  R31 , R12 = MePc0      | Pc = 322 =142
CSRRC  R12 R31 4092 @ MePc0   =  MePc0 & ~R31 , R12 = MePc0      | Pc = 323 =143
CSRRS  R12 R00 4092 @ MePc0   =  MePc0 |  R00 , R12 = MePc0      | Pc = 324 =144
CSRRS  R12 R31 4092 @ MePc0   =  MePc0 |  R31 , R12 = MePc0      | Pc = 325 =145
CSRRC  R12 R00 4092 @ MePc0   =  MePc0 & ~R00 , R12 = MePc0      | Pc = 326 =146
CSRRWI R13  15 4091 @ Mnev    =  15           , R13 = Mnev       | Pc = 327 =147
CSRRSI R13  31 4092 @ MePc0   =  MePc0 |  31  , R13 = MePc0      | Pc = 328 =148
CSRRCI R13  31 4091 @ Mnev    =  Mnev  & ~31  , R13 = Mnev       | Pc = 329 =149
CSRRSI R13   0 4092 @ MePc0   =  MePc0 |  0   , R13 = MePc0      | Pc = 330 =14A
CSRRSI R13  31 4091 @ Mnev    =  Mnev  |  31  , R13 = Mnev       | Pc = 331 =14B
CSRRCI R13   0 4093 @ MePc1   =  MePc1 & ~0   , R13 = MePc1      | Pc = 332 =14C

@-------------------------------------------------------------------------------
@ Test Load and store instructions
@-------------------------------------------------------------------------------

SB     R00 R07  464 @ M[R00+464] <= R07( 7:0)                    | Pc = 333 =14D
SH     R00 R07  465 @ M[R00+465] <= R07(15:0)                    | Pc = 334 =14E
SW     R00 R07  466 @ M[R00+466] <= R07(31:0)                    | Pc = 335 =14F
LB     R10 R00    6 @ R10       = sign   extended M[R00+6]( 7:0) | Pc = 336 =150
LB     R10 R00    7 @ R10       = sign   extended M[R00+7]( 7:0) | Pc = 337 =151
LB     R10 R00    8 @ R10       = sign   extended M[R00+8]( 7:0) | Pc = 338 =152
LH     R10 R00    6 @ R10       = sign   extended M[R00+6](15:0) | Pc = 339 =153
LH     R10 R00    7 @ R10       = sign   extended M[R00+7](15:0) | Pc = 340 =154
LH     R10 R00    8 @ R10       = sign   extended M[R00+8](15:0) | Pc = 341 =155
LW     R10 R00    6 @ R10       = sign   extended M[R00+6](31:0) | Pc = 342 =156
LW     R10 R00    7 @ R10       = sign   extended M[R00+7](31:0) | Pc = 343 =157
LW     R10 R00    8 @ R10       = sign   extended M[R00+8](31:0) | Pc = 344 =158
LBU    R10 R00    6 @ R10       = sign unextended M[R00+6]( 7:0) | Pc = 345 =159
LBU    R10 R00    7 @ R10       = sign unextended M[R00+7]( 7:0) | Pc = 346 =15A
LBU    R10 R00    8 @ R10       = sign unextended M[R00+8]( 7:0) | Pc = 347 =15B
LHU    R10 R00    6 @ R10       = sign unextended M[R00+6]( 7:0) | Pc = 348 =15C
LHU    R10 R00    7 @ R10       = sign unextended M[R00+7]( 7:0) | Pc = 349 =15D
LHU    R10 R00    8 @ R10       = sign unextended M[R00+8]( 7:0) | Pc = 350 =15E

@-------------------------------------------------------------------------------
@ Test Branch Instructions
@-------------------------------------------------------------------------------
@ The goal is to do :
@  - 6 consecutive fails, testing each instruction
@  - 1 successful branch
@  - 2 successful branches
@  - 3 successful branches
@  - 4 successful branches
@  - 1 failed     branch  , then 1 successful
@  - 2 failed     branches, then 1 successful
@  - 3 failed     branches, then 1 successful
@  - 4 failed     branches, then 1 successful
@  - 4 failed     branches, then 2 successful
@  - 1 failed     branch
@-------------------------------------------------------------------------------

@ 6 consecutive fails, testing each instruction
BEQ    R00 R01   97 @ Fail 1                                     | Pc = 351 =15F
BNE    R03 R03   96 @ Fail 2                                     | Pc = 352 =160
BLT    R03 R06   95 @ Fail 3                                     | Pc = 353 =161
BGE    R06 R03   94 @ Fail 4                                     | Pc = 354 =162
BLTU   R31 R03   93 @ Fail 5                                     | Pc = 355 =163
BGEU   R03 R31   92 @ Fail 6                                     | Pc = 356 =164

@ 1 successful branch
BEQ    R00 R00   11 @ Ok 1 ~ Pc <= 357 + 11   = 368 ~ TwoFourOk  | Pc = 357 =165
JALR   R00 R00  358 @ Jump to this address                       | Pc = 358 =166

& TwoFourOk
@ Pc Initial Value = 368
                    @ 2 successful branches
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 368 + 2    = 370              | Pc = 368 =170
JALR   R00 R00  369 @ Jump to this address                       | Pc = 369 =171
BEQ    R00 R00   30 @ Ok 2 ~ Pc <= 370 + 30   = 400 ~ ThreeOk    | Pc = 370 =172
JALR   R00 R00  371 @ Jump to this address                       | Pc = 371 =173
                    @ 4 successful branches
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 372 + 2    = 374              | Pc = 372 =174
JALR   R00 R00  373 @ Jump to this address                       | Pc = 373 =175
BEQ    R00 R00    2 @ Ok 2 ~ Pc <= 374 + 2    = 376              | Pc = 374 =176
JALR   R00 R00  375 @ Jump to this address                       | Pc = 375 =177
BEQ    R00 R00    2 @ Ok 3 ~ Pc <= 376 + 2    = 378              | Pc = 376 =178
JALR   R00 R00  377 @ Jump to this address                       | Pc = 377 =179
BEQ    R00 R00    6 @ Ok 4 ~ Pc <= 378 + 6    = 384 ~ OneThreeF  | Pc = 378 =17A
JALR   R00 R00  379 @ Jump to this address                       | Pc = 379 =17B

& OneThreeF
@ Pc Initial Value = 384
                    @ 1 failed     branch  , then 1 successful
BEQ    R01 R00    2 @ F  1 ~ Pc <= 384 + 2    = 386              | Pc = 384 =180
BEQ    R00 R00   31 @ Ok 1 ~ Pc <= 385 + 31   = 416 ~ TwoFourF   | Pc = 385 =181
JALR   R00 R00  386 @ Jump to this address                       | Pc = 386 =182
                    @ 3 failed     branch  , then 1 successful
BEQ    R01 R00    4 @ F  1 ~ Pc <= 387 + 4    = 391              | Pc = 387 =183
BEQ    R01 R00    3 @ F  2 ~ Pc <= 388 + 3    = 391              | Pc = 388 =184
BEQ    R01 R00    2 @ F  3 ~ Pc <= 389 + 2    = 391              | Pc = 389 =185
BEQ    R00 R00   30 @ Ok 1 ~ Pc <= 390 + 30   = 420 ~ TwoFourF   | Pc = 390 =186
JALR   R00 R00  391 @ Jump to this address                       | Pc = 391 =187

& ThreeOk
@ Pc Initial Value = 400
                    @ 3 successful branches
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 400 + 2    = 402              | Pc = 400 =190
JALR   R00 R00  401 @ Jump to this address                       | Pc = 401 =191
BEQ    R00 R00    2 @ Ok 2 ~ Pc <= 402 + 2    = 404              | Pc = 402 =192
JALR   R00 R00  402 @ Jump to this address                       | Pc = 403 =193
BEQ    R00 R00 4064 @ Ok 3 ~ Pc <= 404 + 4064 = 372 ~ TwoFourOk  | Pc = 404 =194
JALR   R00 R00  405 @ Jump to this address                       | Pc = 405 =195

& TwoFourF
@ Pc Initial Value = 416
                    @ 2 failed     branch  , then 1 successful
BEQ    R01 R00    3 @ F  1 ~ Pc <= 416 + 3    = 419              | Pc = 416 =1A0
BEQ    R01 R00    2 @ F  2 ~ Pc <= 417 + 2    = 419              | Pc = 417 =1A1
BEQ    R00 R00 4065 @ Ok 1 ~ Pc <= 418 + 4065 = 387 ~ OneThreeF  | Pc = 418 =1A2
JALR   R00 R00  419 @ Jump to this address                       | Pc = 419 =1A3
                    @ 4 failed     branch  , then 1 successful
BEQ    R01 R00    5 @ F  1 ~ Pc <= 420 + 5    = 425              | Pc = 420 =1A4
BEQ    R01 R00    4 @ F  2 ~ Pc <= 421 + 4    = 425              | Pc = 421 =1A5
BEQ    R01 R00    3 @ F  3 ~ Pc <= 422 + 3    = 425              | Pc = 422 =1A6
BEQ    R01 R00    2 @ F  4 ~ Pc <= 423 + 2    = 425              | Pc = 423 =1A7
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 424 + 2    = 426              | Pc = 424 =1A8
JALR   R00 R00  425 @ Jump to this address                       | Pc = 425 =1A9
                    @ 4 failed     branch  , then 2 successful
BEQ    R01 R00    5 @ F  1 ~ Pc <= 426 + 5    = 431              | Pc = 426 =1AA
BEQ    R01 R00    4 @ F  2 ~ Pc <= 427 + 4    = 431              | Pc = 427 =1AB
BEQ    R01 R00    3 @ F  3 ~ Pc <= 428 + 3    = 431              | Pc = 428 =1AC
BEQ    R01 R00    2 @ F  4 ~ Pc <= 429 + 2    = 431              | Pc = 429 =1AD
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 430 + 2    = 432              | Pc = 430 =1AE
JALR   R00 R00  431 @ Jump to this address                       | Pc = 431 =1AF
BEQ    R00 R00    2 @ Ok 2 ~ Pc <= 432 + 2    = 434              | Pc = 432 =1B0
JALR   R00 R00  433 @ Jump to this address                       | Pc = 433 =1B1
                    @ 1 failed     branch
NoOp                @                                            | Pc = 434 =1B2
CSRRW  R13 R31  772 @ Enable interruptions                       | Pc = 435 =1B3
BEQ    R00 R00   12 @ F  1 ~ Pc <= 436 + 12   = 448              | Pc = 436 =1B4

& EndProgram
@ Pc Initial Value = 448
JALR   R00 R00  448 @ Jump to this address                       | Pc = 448 =1C0

& SecondCore
@-------------------------------------------------------------------------------
@ Pc Initial Value = 464
@ Upload initial values, by usong LUI and then SRL
@ none of the following instructions generate a data dependency
@ however the 3rd and 4th SRLI and the ADDIs are in the limit for said condition
@ 
@ Here is also tested NoOp as a way to avoid stalls
@-------------------------------------------------------------------------------
LUI    R11        1 @ R11 <= 0000 0001 << 12 = 0000 1000         | Pc = 464 =1D0
LUI    R12  1048575 @ R12 <= 000F FFFF << 12 = FFFF F000         | Pc = 465 =1D1
LUI    R13       31 @ R13 <= 0000 001F << 12 = 0001 F000         | Pc = 466 =1D2
LUI    R14   699050 @ R14 <= 000A AAAA << 12 = AAAA A000         | Pc = 467 =1D3
LUI    R15   349525 @ R15 <= 0005 5555 << 12 = 5555 5000         | Pc = 468 =1D4
LUI    R16       17 @ R16 <= 0000 0011 << 12 = 0001 1000         | Pc = 469 =1D5
LUI    R17   524288 @ R17 <= 0008 0000 << 12 = 8000 0000         | Pc = 470 =1D6
SRLI   R01 R11   12 @ R01 <= R11 >> 12 = 0000 0001               | Pc = 471 =1D7
SRLI   R02 R12   12 @ R02 <= R12 >> 12 = 000F FFFF               | Pc = 472 =1D8
SRLI   R31 R12    0 @ R31 <= R12 >>  0 = FFFF F000               | Pc = 473 =1D9
LUI    R18   698880 @ R17 <= 000A AA00 << 12 = AAA0 0000         | Pc = 474 =1DA
SRLI   R03 R13   12 @ R03 <= R13 >> 12 = 0000 001F               | Pc = 475 =1DB
SRLI   R04 R14   12 @ R04 <= R14 >> 12 = 000A AAAA               | Pc = 476 =1DC
SRLI   R05 R15   12 @ R05 <= R15 >> 12 = 0005 5555               | Pc = 477 =1DD
SRLI   R06 R16   12 @ R06 <= R16 >> 12 = 0000 0011               | Pc = 478 =1DE
ADDI   R31 R00 4095 @ R31 <= R00 + FFF = FFFF FFFF               | Pc = 479 =1DF
NoOp                @                                            | Pc = 470 =1E0
NoOp                @                                            | Pc = 481 =1E1
NoOp                @                                            | Pc = 482 =1E2
ADD    R07 R18 R04  @ R07 <= R18 + R04 = AAAA AAAA               | Pc = 483 =1E3
SUB    R30 R31 R17  @ R30 <= R31 - R17 = 7FFF FFFF               | Pc = 484 =1E4
NoOp                @                                            | Pc = 485 =1E5
NoOp                @                                            | Pc = 486 =1E6
NoOp                @                                            | Pc = 487 =1E7

@-------------------------------------------------------------------------------
@ Registers Values:
@ 
@      Decimal          Hexa   
@  1:             1 : 0000 0001
@  2:     1 048 575 : 000F FFFF
@  3:            31 : 0000 001F
@  4:       699 050 : 000A AAAA
@  5:       349 525 : 0005 5555
@  6:            17 : 0000 0011
@  7: 2 863 311 530 : AAAA AAAA
@
@ 30: 2 147 483 647 : 7FFF FFFF
@ 31: 4 294 967 295 : FFFF FFFF
@-------------------------------------------------------------------------------

@ Test Alu Imm Operations
ADDI   R10 R00  225 @ R10 <= 0  + 225      = 0d225  = 0xE1       | Pc = 488 =1E8
ADDI   R10 R01    0 @ R10 <= 1  + 0        = 0d1                 | Pc = 489 =1E9
@ Test Alu operations
SLTU   R10 R01 R00  @ R10 <= 0 ~ R01 <u R00 ? Is false           | Pc = 490 =1EA
XOR    R11 R04 R02  @ R11 <= R04 XOR R02                         | Pc = 491 =1EB
@ Test Data Dependency
SLLI   R11 R01    1 @ chain start                                | Pc = 492 =1EC
SLLI   R10 R10    1 @ 1st dependency                             | Pc = 493 =1ED
@ Test Branches
BGEU   R03 R31    2 @ Fail 6                                     | Pc = 494 =1EE
BEQ    R00 R00    2 @ Ok 1 ~ Pc <= 357 + 11   = 368 ~ TwoFourOk  | Pc = 495 =1EF
JALR   R00 R00  448 @ Jump to the program's end                  | Pc = 496 =1F0
CSRRW  R29 R28 4090 @ Toggle core to act as a pipelined core     | Pc = 497 =1F1
NoOp                @                                            | Pc = 498 =1F2
NoOp                @                                            | Pc = 499 =1F3
NoOp                @                                            | Pc = 500 =1F4
ADDI   R10 R00  225 @ R10 <= 0  + 225      = 0d225  = 0xE1       | Pc = 501 =1F5
ADDI   R10 R01    0 @ R10 <= 1  + 0        = 0d1                 | Pc = 502 =1F6
JALR   R00 R00  448 @ Jump to the program's end                  | Pc = 503 =1F7
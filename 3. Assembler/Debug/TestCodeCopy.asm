@ Instruction Order : Rd Rs1 Rs2 Imm

@ Each one of the following segments is intended for max 16 instructions
& StartCore0
@ Pc initial value = 0d000 = 0x00
JAL R10 176

& StartCore1
@ Pc initial value = 0d016 = 0x10
JALR R00 R00 16 @ Jump to: R00 + 16 (This same address)

& ErrorRoutine
@ Pc initial value = 0d032 = 0x20
MRET

& Interruption0Core0
@ Pc initial value = 0d048 = 0x30
MRET

& Interruption1Core0
@ Pc initial value = 0d064 = 0x40
MRET

& Interruption2Core0
@ Pc initial value = 0d080 = 0x50
MRET

& Interruption3Core0
@ Pc initial value = 0d096 = 0x60
MRET

& Interruption0Core1
@ Pc initial value = 0d112 = 0x70
MRET

& Interruption1Core1
@ Pc initial value = 0d128 = 0x80
MRET

& Interruption2Core1
@ Pc initial value = 0d144 = 0x90
MRET

& Interruption3Core1
@ Pc initial value = 0d160 = 0xA0
MRET

& MainCore1
@-------------------------------------------------------------------------------
@ Pc initial value = 0d176 = 0xB0
@ Upload initial values, by usong LUI and then SRL
@ none of the following instructions generate a data dependency
@ however the 3rd and 4th SRLI and the ADDIs are in the limit for said condition
@ 
@ Here is also tested NoOp as a way to avoid stalls
@-------------------------------------------------------------------------------
LUI    R11 1        @ R11 <= 0000 0001 << 12 = 0000 1000         | Pc = 176 =0B0
LUI    R12 1048575  @ R12 <= 000F FFFF << 12 = FFFF F000         | Pc = 177 =0B1
LUI    R13 31       @ R13 <= 0000 001F << 12 = 0001 F000         | Pc = 178 =0B2
LUI    R14 699050   @ R14 <= 000A AAAA << 12 = AAAA A000         | Pc = 179 =0B3
LUI    R15 349525   @ R15 <= 0005 5555 << 12 = 5555 5000         | Pc = 180 =0B4
LUI    R16 17       @ R16 <= 0000 0011 << 12 = 0001 1000         | Pc = 181 =0B5
LUI    R17 524288   @ R17 <= 0008 0000 << 12 = 8000 0000         | Pc = 182 =0B6
SRLI   R01 R11 12   @ R01 <= R11 >> 12 = 0000 0001               | Pc = 183 =0B7
SRLI   R02 R12 12   @ R02 <= R12 >> 12 = 000F FFFF               | Pc = 184 =0B8
SRLI   R31 R12 0    @ R31 <= R12 >>  0 = FFFF F000               | Pc = 185 =0B9
LUI    R18 698880   @ R17 <= 000A AA00 << 12 = AAA0 0000         | Pc = 186 =0BA
SRLI   R03 R13 12   @ R03 <= R13 >> 12 = 0000 001F               | Pc = 187 =0BB
SRLI   R04 R14 12   @ R04 <= R14 >> 12 = 000A AAAA               | Pc = 188 =0BC
SRLI   R05 R15 12   @ R05 <= R15 >> 12 = 0005 5555               | Pc = 189 =0BD
SRLI   R06 R16 12   @ R06 <= R16 >> 12 = 0000 0011               | Pc = 190 =0BE
ADDI   R31 R00 4095 @ R31 <= R00 + FFF = FFFF FFFF               | Pc = 191 =0BF
SUB    R30 R31 R17  @ R30 <= R31 - R17 = 7FFF FFFF               | Pc = 192 =0C0
NoOp                @                                            | Pc = 193 =0C1
NoOp                @                                            | Pc = 194 =0C2
NoOp                @                                            | Pc = 195 =0C3
ADD    R07 R18 R04  @ R07 <= R07 + R04 = AAAA AAAA               | Pc = 196 =0C4
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
AUIPC  R10 1        @ R10 <= C8 + (1 << 12)= 0d4111 = 0x10C8     | Pc = 200 =0C8
ADDI   R10 R00 225  @ R10 <= 0  + 225      = 0d225  = 0xE1       | Pc = 201 =0C9
ADDI   R10 R01 0    @ R10 <= 1  + 0        = 0d1                 | Pc = 202 =0CA
ADDI   R10 R01 4095 @ R10 <= 1  + (-1)     = 0d0                 | Pc = 203 =0CB
SLTI   R10 R00 1    @ R10 <= 1  ~ 0  <  1  ? Is true             | Pc = 204 =0CC
SLTI   R10 R00 4095 @ R10 <= 0  ~ 0  < -1  ? Is false            | Pc = 205 =0CD
SLTI   R10 R00 2047 @ R10 <= 1  ~ 0  < 2047? Is true             | Pc = 206 =0CE
SLTI   R10 R00 0    @ R10 <= 0  ~ 0  <  0  ? Is false            | Pc = 207 =0CF
SLTI   R10 R03 32   @ R10 <= 1  ~ 31 < 32  ? Is True             | Pc = 208 =0D0
SLTI   R10 R01 0    @ R10 <= 0  ~ 1  <  0  ? Is false            | Pc = 209 =0D1
SLTIU  R10 R00 1    @ R10 <= 1  ~ 0  <  1  ? Is true             | Pc = 210 =0D2
SLTIU  R10 R00 4095 @ R10 <= 1  ~ 0  < 4095? Is TRUE             | Pc = 211 =0D3
SLTIU  R10 R00 2047 @ R10 <= 1  ~ 0  < 2047? Is true             | Pc = 212 =0D4
SLTIU  R10 R00 0    @ R10 <= 0  ~ 0  <  0  ? Is false            | Pc = 213 =0D5
SLTIU  R10 R03 32   @ R10 <= 1  ~ 31 < 32  ? Is True             | Pc = 214 =0D6
SLTIU  R10 R01 0    @ R10 <= 0  ~ 1  <  0  ? Is false            | Pc = 215 =0D7
XORI   R10 R01 3    @ R10 <= 1  ^ 3        = 2                   | Pc = 216 =0D8
ORI    R10 R01 3    @ R10 <= 1  | 3        = 3                   | Pc = 217 =0D9
ANDI   R10 R01 3    @ R10 <= 1  & 3        = 1                   | Pc = 218 =0DA
SLLI   R10 R01 3    @ R10 <= 1 << 3        = 8                   | Pc = 219 =0DB
SRLI   R10 R31 0    @ R10 <= R31 >>u 0     = 0xFFFF FFFF         | Pc = 220 =0DC
SRLI   R10 R31 1    @ R10 <= R31 >>u 1     = 0x7FFF FFFF         | Pc = 221 =0DD
SRLI   R10 R31 8    @ R10 <= R31 >>u 8     = 0x00FF FFFF         | Pc = 222 =0DE
SRLI   R10 R31 31   @ R10 <= R31 >>u 31    = 0x0000 0001         | Pc = 223 =0DF
SRAI   R10 R07 0    @ R10 <= R31 >>S 0     = 0xAAAA AAAA         | Pc = 224 =0E0
SRAI   R10 R07 1    @ R10 <= R31 >>S 1     = 0xD555 5555         | Pc = 225 =0E1
SRAI   R10 R07 8    @ R10 <= R31 >>S 8     = 0xFFAA AAAA         | Pc = 226 =0E2
SRAI   R10 R07 31   @ R10 <= R31 >>S 31    = 0xFFFF FFFF         | Pc = 227 =0E3

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
SLL    R10 R01 R31  @ R10 <= R01 << 32 (MSBs Ignored)            | Pc = 236 =0EC
SLT    R10 R00 R31  @ R10 <= 1 ~ R00 <  R31 ? Is false           | Pc = 237 =0ED
SLT    R10 R00 R01  @ R10 <= 1 ~ R00 <  R01 ? Is true            | Pc = 238 =0EE
SLT    R10 R06 R03  @ R10 <= 1 ~ R06 <  R03 ? Is true            | Pc = 239 =0EF
SLT    R10 R06 R30  @ R10 <= 0 ~ R06 <  R30 ? Is false           | Pc = 240 =0F0
SLT    R10 R01 R00  @ R10 <= 0 ~ R01 <  R00 ? Is false           | Pc = 241 =0F1
SLTU   R10 R00 R31  @ R10 <= 1 ~ R00 <u R31 ? Is true            | Pc = 242 =0F2
SLTU   R10 R00 R01  @ R10 <= 1 ~ R00 <u R01 ? Is true            | Pc = 243 =0F3
SLTU   R10 R06 R03  @ R10 <= 1 ~ R06 <u R03 ? Is true            | Pc = 244 =0F4
SLTU   R10 R06 R30  @ R10 <= 1 ~ R06 <u R30 ? Is false           | Pc = 245 =0F5
SLTU   R10 R01 R00  @ R10 <= 1 ~ R01 <u R00 ? Is false           | Pc = 246 =0F6
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
REMU   R10 R01 R00  @ R13 <= 0                                   | Pc = 292 =124
@ Test 2 to 5 chained dependencies                               |   
SLLI   R10 R01 1    @ chain start                                | Pc = 293 =125
SLLI   R10 R10 1    @ 1st dependency                             | Pc = 294 =126
SLLI   R10 R10 1    @ 2nd dependency                             | Pc = 295 =127
SLLI   R10 R01 1    @ chain start                                | Pc = 296 =128
SLLI   R10 R10 1    @ 1st dependency                             | Pc = 297 =129
SLLI   R10 R10 1    @ 2nd dependency                             | Pc = 298 =12A
SLLI   R10 R10 1    @ 3rd dependency                             | Pc = 299 =12B
SLLI   R11 R01 1    @ chain start                                | Pc = 300 =12C
SLLI   R10 R10 1    @ 1st dependency                             | Pc = 301 =12D
SLLI   R10 R10 1    @ 2nd dependency                             | Pc = 302 =12E
SLLI   R10 R10 1    @ 3rd dependency                             | Pc = 303 =12F
SLLI   R10 R10 1    @ 4th dependency                             | Pc = 304 =130
SLLI   R11 R01 1    @ chain start                                | Pc = 305 =131
SLLI   R10 R10 1    @ 1st dependency                             | Pc = 306 =132
SLLI   R10 R10 1    @ 2nd dependency                             | Pc = 307 =133
SLLI   R10 R10 1    @ 3rd dependency                             | Pc = 308 =134
SLLI   R10 R10 1    @ 4th dependency                             | Pc = 309 =135
SLLI   R10 R10 1    @ 5th dependency                             | Pc = 310 =136

@-------------------------------------------------------------------------------
@ Test CSR instructions
@-------------------------------------------------------------------------------

CSRRW  R11 R05 769  @ Misa    =/ R05          , R11 = Misa       | Pc = 311 =137
CSRRW  R11 R05 772  @ Mie     =  R05          , R11 = Mie        | Pc = 312 =138
CSRRW  R11 R05 773  @ Mtvec   =  R05          , R11 = Mtvec      | Pc = 313 =139
CSRRW  R11 R05 834  @ Mcause  =  R05          , R11 = Mcause     | Pc = 314 =13A
CSRRW  R11 R05 835  @ Mtval   =  R05          , R11 = Mtval      | Pc = 315 =13B
CSRRW  R11 R05 3858 @ MarchId =/ R05          , R11 = MarcId     | Pc = 316 =13C
CSRRW  R11 R05 3859 @ MimpId  =/ R05          , R11 = MimpId     | Pc = 317 =13D
CSRRW  R11 R05 3860 @ MhartId =/ R05          , R11 = MhartId    | Pc = 318 =13E
CSRRW  R11 R05 4090 @ Mps     =  R05          , R11 = Mps        | Pc = 319 =13F
CSRRW  R11 R05 4091 @ Mnev    =  R05          , R11 = Mnev       | Pc = 320 =140
CSRRW  R11 R05 4092 @ MePc0   =  R05          , R11 = MePc0      | Pc = 321 =141
                    @ (Dependency on MePc0?)                     |   
CSRRS  R12 R31 4092 @ MePc0   =  MePc0 |  R31 , R12 = MePc0      | Pc = 322 =142
CSRRC  R12 R31 4092 @ MePc0   =  MePc0 & ~R31 , R12 = MePc0      | Pc = 323 =143
CSRRS  R12 R00 4092 @ MePc0   =  MePc0 |  R00 , R12 = MePc0      | Pc = 324 =144
CSRRS  R12 R31 4092 @ MePc0   =  MePc0 |  R31 , R12 = MePc0      | Pc = 325 =145
CSRRC  R12 R00 4092 @ MePc0   =  MePc0 & ~R00 , R12 = MePc0      | Pc = 326 =146
CSRRWI R13 15  4093 @ MePc1   =  15           , R13 = MePc1      | Pc = 327 =147
CSRRSI R13 31  4093 @ MePc1   =  MePc1 |  31  , R13 = MePc1      | Pc = 328 =148
CSRRCI R13 31  4093 @ MePc1   =  MePc1 & ~31  , R13 = MePc1      | Pc = 329 =149
CSRRSI R13 0   4093 @ MePc1   =  MePc1 |  0   , R13 = MePc1      | Pc = 330 =14A
CSRRSI R13 31  4093 @ MePc1   =  MePc1 |  31  , R13 = MePc1      | Pc = 331 =14B
CSRRCI R13 0   4093 @ MePc1   =  MePc1 & ~0   , R13 = MePc1      | Pc = 332 =14C

@-------------------------------------------------------------------------------
@ Test Load and store instructions
@-------------------------------------------------------------------------------

SB     R04 R07 0    @ M[R04+0] <= R07( 7:0)                      | Pc = 333 =14D
SH     R05 R07 0    @ M[R05+0] <= R07(15:0)                      | Pc = 334 =14E
SW     R02 R07 0    @ M[R02+0] <= R07(31:0)                      | Pc = 335 =14F
LB     R10 R04 0    @ R10       = sign   extended M[R04+0]( 7:0) | Pc = 336 =150
LB     R10 R05 0    @ R10       = sign   extended M[R05+0]( 7:0) | Pc = 337 =151
LB     R10 R02 0    @ R10       = sign   extended M[R02+0]( 7:0) | Pc = 338 =152
LH     R10 R04 0    @ R10       = sign   extended M[R04+0](15:0) | Pc = 339 =153
LH     R10 R05 0    @ R10       = sign   extended M[R05+0](15:0) | Pc = 340 =154
LH     R10 R02 0    @ R10       = sign   extended M[R02+0](15:0) | Pc = 341 =155
LW     R10 R04 0    @ R10       = sign   extended M[R04+0](31:0) | Pc = 342 =156
LW     R10 R05 0    @ R10       = sign   extended M[R05+0](31:0) | Pc = 343 =157
LW     R10 R02 0    @ R10       = sign   extended M[R02+0](31:0) | Pc = 344 =158
LBU    R10 R04 0    @ R10       = sign unextended M[R04+0]( 7:0) | Pc = 345 =159
LBU    R10 R05 0    @ R10       = sign unextended M[R05+0]( 7:0) | Pc = 346 =15A
LBU    R10 R02 0    @ R10       = sign unextended M[R02+0]( 7:0) | Pc = 347 =15B
LHU    R10 R04 0    @ R10       = sign unextended M[R04+0]( 7:0) | Pc = 348 =15C
LHU    R10 R05 0    @ R10       = sign unextended M[R05+0]( 7:0) | Pc = 349 =15D
LHU    R10 R02 0    @ R10       = sign unextended M[R02+0]( 7:0) | Pc = 350 =15E

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
BEQ    R00 R01 448  @ Fail 1                                     | Pc = 351 =15F
BNE    R03 R03 448  @ Fail 2                                     | Pc = 352 =160
BLT    R03 R06 448  @ Fail 3                                     | Pc = 353 =161
BGE    R06 R03 448  @ Fail 4                                     | Pc = 354 =162
BLTU   R03 R31 448  @ Fail 5                                     | Pc = 355 =163
BGEU   R31 R03 448  @ Fail 6                                     | Pc = 356 =164

@ 1 successful branch
BEQ    R00 R00 11   @ Ok 1 ~ Pc <= 357 + 11   = 368 ~ TwoFourOk  | Pc = 357 =165
JALR   R00 R00 358  @ Jump to this address                       | Pc = 358 =166

& TwoFourOk
@ Pc Initial Value = 368
                    @ 2 successful branches
BEQ    R00 R00 2    @ Ok 1 ~ Pc <= 368 + 2    = 370              | Pc = 368 =170
JALR   R00 R00 369  @ Jump to this address                       | Pc = 369 =171
BEQ    R00 R00 30   @ Ok 2 ~ Pc <= 370 + 30   = 400 ~ ThreeOk    | Pc = 370 =172
JALR   R00 R00 371  @ Jump to this address                       | Pc = 371 =173
                    @ 4 successful branches
BEQ    R00 R00 2    @ Ok 1 ~ Pc <= 372 + 2    = 374              | Pc = 372 =174
JALR   R00 R00 373  @ Jump to this address                       | Pc = 373 =175
BEQ    R00 R00 2    @ Ok 2 ~ Pc <= 374 + 2    = 376              | Pc = 374 =176
JALR   R00 R00 375  @ Jump to this address                       | Pc = 375 =177
BEQ    R00 R00 2    @ Ok 3 ~ Pc <= 376 + 2    = 378              | Pc = 376 =178
JALR   R00 R00 377  @ Jump to this address                       | Pc = 377 =179
BEQ    R00 R00 6    @ Ok 4 ~ Pc <= 378 + 6    = 384 ~ OneThreeF  | Pc = 378 =17A
JALR   R00 R00 379  @ Jump to this address                       | Pc = 379 =17B

& OneThreeF
@ Pc Initial Value = 384
                    @ 1 failed     branch  , then 1 successful
BEQ    R01 R00 2    @ F  1 ~ Pc <= 384 + 2    = 386              | Pc = 384 =180
BEQ    R00 R00 31   @ Ok 1 ~ Pc <= 385 + 31   = 416 ~ TwoFourF   | Pc = 385 =181
JALR   R00 R00 386  @ Jump to this address                       | Pc = 386 =182
                    @ 3 failed     branch  , then 1 successful
BEQ    R01 R00 4    @ F  1 ~ Pc <= 387 + 4    = 391              | Pc = 387 =183
BEQ    R01 R00 3    @ F  2 ~ Pc <= 388 + 3    = 391              | Pc = 388 =184
BEQ    R01 R00 2    @ F  3 ~ Pc <= 389 + 2    = 391              | Pc = 389 =185
BEQ    R00 R00 30   @ Ok 1 ~ Pc <= 390 + 30   = 420 ~ TwoFourF   | Pc = 390 =186
JALR   R00 R00 391  @ Jump to this address                       | Pc = 391 =187

& ThreeOk
@ Pc Initial Value = 400
                    @ 3 successful branches
BEQ    R00 R00 2    @ Ok 1 ~ Pc <= 400 + 2    = 402              | Pc = 400 =190
JALR   R00 R00 401  @ Jump to this address                       | Pc = 401 =191
BEQ    R00 R00 2    @ Ok 2 ~ Pc <= 402 + 2    = 404              | Pc = 402 =192
JALR   R00 R00 402  @ Jump to this address                       | Pc = 403 =193
BEQ    R00 R00 4060 @ Ok 3 ~ Pc <= 404 + 4064 = 372 ~ TwoFourOk  | Pc = 404 =194
JALR   R00 R00 405  @ Jump to this address                       | Pc = 405 =195

& TwoFourF
@ Pc Initial Value = 416
                    @ 2 failed     branch  , then 1 successful
BEQ    R01 R00 3    @ F  1 ~ Pc <= 416 + 3    = 419              | Pc = 416 =1A0
BEQ    R01 R00 2    @ F  2 ~ Pc <= 417 + 2    = 419              | Pc = 417 =1A1
BEQ    R00 R00 4065 @ Ok 1 ~ Pc <= 418 + 4065 = 387 ~ OneThreeF  | Pc = 418 =1A2
JALR   R00 R00 419  @ Jump to this address                       | Pc = 419 =1A3
                    @ 4 failed     branch  , then 1 successful
BEQ    R01 R00 5    @ F  1 ~ Pc <= 420 + 5    = 425              | Pc = 420 =1A4
BEQ    R01 R00 4    @ F  2 ~ Pc <= 421 + 4    = 425              | Pc = 421 =1A5
BEQ    R01 R00 3    @ F  3 ~ Pc <= 422 + 3    = 425              | Pc = 422 =1A6
BEQ    R01 R00 2    @ F  4 ~ Pc <= 423 + 2    = 425              | Pc = 423 =1A7
BEQ    R00 R00 2    @ Ok 1 ~ Pc <= 424 + 2    = 426              | Pc = 424 =1A8
JALR   R00 R00 425  @ Jump to this address                       | Pc = 425 =1A9
                    @ 4 failed     branch  , then 2 successful
BEQ    R01 R00 5    @ F  1 ~ Pc <= 426 + 5    = 431              | Pc = 426 =1AA
BEQ    R01 R00 4    @ F  2 ~ Pc <= 427 + 4    = 431              | Pc = 427 =1AB
BEQ    R01 R00 3    @ F  3 ~ Pc <= 428 + 3    = 431              | Pc = 428 =1AC
BEQ    R01 R00 2    @ F  4 ~ Pc <= 429 + 2    = 431              | Pc = 429 =1AD
BEQ    R00 R00 2    @ Ok 1 ~ Pc <= 430 + 2    = 432              | Pc = 430 =1AE
JALR   R00 R00 431  @ Jump to this address                       | Pc = 431 =1AF
BEQ    R00 R00 2    @ Ok 2 ~ Pc <= 432 + 2    = 434              | Pc = 432 =1B0
JALR   R00 R00 433  @ Jump to this address                       | Pc = 433 =1B1
                    @ 1 failed     branch
BEQ    R01 R00 448  @ F  1 ~ Pc <= 434 + 14   = 448              | Pc = 434 =1B2

& EndMainCore1
@ Pc Initial Value = 448
JALR   R00 R00 448  @ Jump to this address                       | Pc = 448 =1C0
#ifndef ENUMERATEDITEMS_H_
#define ENUMERATEDITEMS_H_

typedef enum
{
	InstructionSt, Argument1St, Argument2St , Argument3St, CommentSt    , ConstantSt,
	AddressSt    , ErrorSt    , NoArgumentSt, IdleSt     , AddressIdleSt, ValueSt
} RdSt;

typedef enum
{
	A ,B ,C ,D ,J ,L ,M ,N ,O ,R ,S ,U ,X , Error1
} InstStatesT1;

typedef InstStatesT1 StT1;

typedef enum
{
	AD ,AN ,AU ,BE ,BG ,BL ,BN ,CS ,DI ,JA    ,LB ,LH ,LU ,LW ,MR ,MU ,NO ,OR ,
	RE ,SB ,SH ,SL ,SR ,SU ,SW ,UR ,XO ,Error2
} InstStatesT2;

typedef InstStatesT2 StT2;

typedef enum
{
	ADD ,AND ,AUI ,BEQ   ,BGE ,BLT ,BNE ,CSR ,DIV ,JAL ,LB_ ,LBU ,LH_ ,LHU ,LUI ,
	LW_ ,MRE ,MUL ,NOO   ,OR_ ,ORI ,REM ,SB_ ,SH_ ,SLL ,SLT ,SRA ,SRE ,SRL ,SUB ,
	SW_ ,URE ,XOR ,Error3
} InstStatesT3;

typedef InstStatesT3 StT3;

typedef enum
{
	ADD_ ,ADDI ,AND_ ,ANDI ,AUIP  ,BEQ_  ,BGE_  ,BGEU  ,BLT_  ,BLTU ,BNE_ ,CSRR ,
	DIV_ ,DIVU ,JAL_ ,JALR ,LBU_  ,LHU_  ,LUI_  ,MRET  ,MUL_  ,MULH ,NOOP ,ORI_ ,
	REM_ ,REMU ,SLL_ ,SLLI ,SLT_  ,SLTI  ,SLTU  ,SRA_  ,SRAI  ,SRET ,SRL_ ,SRLI ,
	SUB_ ,URET ,XOR_ ,XORI ,Error4,NoOp_ ,Mret_ ,Sret_ ,Uret_
} InstStatesT4;

typedef InstStatesT4 StT4;

typedef enum
{
	ADDI_ ,ANDI_ ,AUIPC ,BGEU_ ,BLTU_ ,CSRRC ,CSRRS ,CSRRW ,DIVU_ ,JALR_ ,
	MRET_ ,MULH_ ,MULHS ,MULHU ,NOOP_ ,REMU_ ,SLLI_ ,SLTI_ ,SLTIU ,SLTU_ ,
	SRAI_ ,SRET_ ,SRLI_ ,URET_ ,XORI_ ,Error5
} InstStatesT5;

typedef InstStatesT5 StT5;

typedef enum
{
	AUIPC_ ,CSRRC_ ,CSRRCI ,CSRRS_ ,CSRRSI ,CSRRW_ ,CSRRWI ,MULHSU ,MULHU_ ,
	SLTIU_ ,Error6
} InstStatesT6;

typedef InstStatesT6 StT6;

typedef enum
{
	CSRRCI_, CSRRSI_, CSRRWI_ ,MULHSU_ ,Error7
} InstStatesT7;

typedef InstStatesT7 StT7;

#endif /* ENUMERATEDITEMS_H_ */




























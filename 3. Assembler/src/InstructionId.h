
#ifndef INSTRUCTIONID_H_
#define INSTRUCTIONID_H_

typedef enum
{
	Lui  , AuiPc, AddI  , SltI  , SltIu , XorI , OrI , AndI, SllI, SrlI, SraI ,
	Add  , Sub  , Sll   , Slt   , Sltu  , Xor  , Srl , Sra , Or  , And , Csrrw,
	Csrrs, Csrrc, CsrrwI, CsrrsI, CsrrcI, Uret , Sret, Mret, Lb  , Lh  , Lw   ,
	Lbu  , Lhu  , Sb    , Sh    , Sw    , Jal  , Jalr, Beq , Bne , Blt , Bge  ,
	Bltu , Bgeu , Mul   , Mulh  , Mulhsu, Mulhu, Div , Divu, Rem , Remu, NoOp ,
	None
} InstIdT;

typedef enum
{
	ClassImmR   , ClassImmI, ClassImmU , ClassImmS, ClassReturn, ClassImmNone
}ImmClassT;

#endif /* INSTRUCTIONID_H_ */

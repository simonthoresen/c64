// change all macros to be clear on registers used
// f.ex. sta_val16

.pseudocommand inc16 arg 
{
    inc arg
    bne no_carry
    inc _hi_byte(arg)
no_carry:
}

.pseudocommand add16 arg1 : arg2 : tar 
{
    .if (tar.getType() == AT_NONE) {
    	.eval tar = arg1
    }
    clc
    lda arg1
    adc arg2
    sta tar
    lda _hi_byte(arg1)
    adc _hi_byte(arg2)
    sta _hi_byte(tar)
}

.pseudocommand dec16 arg {
	lda arg
    bne can_dec
    dec _hi_byte(arg) 
    // fall through and wrap lo-byte
can_dec:
	dec arg
}

.pseudocommand mov16 src : tar {
	lda src
	sta tar
	lda _hi_byte(src)
	sta _hi_byte(tar)
}




.macro cpy_val16(val, dst) {
	lda #<val
	sta dst
	lda #>val
	sta dst+1
}

.macro cpy_adr16(src, dst) {
	lda src
	sta dst
	lda src+1
	sta dst+1
}


// Compares 16 bit values in given memory addresses.
//
//                 (BCC/BCS)     (BEQ/BNE)     (BMI/BPL)
// src1 = src2 : Carry =  SET   Zero =  SET   Neg = CLEAR
// src1 > src2 : Carry =  SET   Zero = CLEAR  Neg = CLEAR
// src1 < src2 : Carry = CLEAR  Zero = CLEAR  Neg =  SET
.macro cmp_adr16(src1, src2) {
    lda src1
    sec
    sbc src2
    php
    lda src1+1
    sbc src2+1
    php
    pla
    sta ADR_TMP
    pla
    and #%00000010
    ora #%11111101
    and ADR_TMP
    pha
    plp
}

.macro cmp_val16(src, val) {
    lda src
    sec
    sbc #<val
    php
    lda src+1
    sbc #>val
    php
    pla
    sta ADR_TMP
    pla
    and #%00000010
    ora #%11111101
    and ADR_TMP
    pha
    plp	
}

.macro add_a8s_to_a16u(dst16, a8s) 
{
	add_signed8(a8s, dst16)
}

.macro add_signed8(src8, dst16) {
	clc
 	lda src8
	adc dst16
 	sta dst16
 
	// sign-extend the high byte
	lda src8
	and #$80	// extract the sign bit
	beq !+		// if zero, add #$00 (+carry)
  	lda #$ff	// else, add $ff (+ carry)
!: 	adc dst16+1
 	sta dst16+1
}

.macro inc16(adr) {
	inc adr
	bne !+ // not-equal means non-zero means not wrapped
	inc adr+1
!:
}

.macro dec16(adr) {
	dec adr
	lda adr
	cmp #$ff
	bne !+
	dec adr+1
!:
}

.macro add_val8(val8, dst16) {
	clc
	lda dst16
	adc #val8
	sta dst16

	lda dst16+1
	adc #$00
	sta dst16+1
}

.macro add_val16(val, dst) {
	clc
	lda dst
	adc #<val
	sta dst

	lda dst+1
	adc #>val
	sta dst+1
}

.macro sub_val8(val8, dst16) {
	sec
	lda dst16
	sbc #val8
	sta dst16

	lda dst16+1
	sbc #$00
	sta dst16+1
}

.macro sub_val16(val, dst) {
	sec
	lda dst
	sbc #<val
	sta dst

	lda dst+1
	sbc #>val
	sta dst+1
}

.macro add_mem8(src8, dst16) {
	clc
	lda dst16
	adc src8
	sta dst16

	lda dst16+1
	adc #$00
	sta dst16+1		
}

.macro add_adr16(src, dst) {
	clc
	lda dst
	adc src
	sta dst

	lda dst+1
	adc src+1
	sta dst+1
}

.macro sub_mem8(src8, dst16) {
	sec
	lda dst16
	sbc src8
	sta dst16

	lda dst16+1
	sbc #$00
	sta dst16+1	
}

.macro sub_adr16(src, dst) {
	sec
	lda dst
	sbc src
	sta dst

	lda dst+1
	sbc src+1
	sta dst+1
}

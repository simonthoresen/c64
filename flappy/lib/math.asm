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
	bne !+
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

.macro add_mem16(src, dst) {
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

.macro sub_mem16(src, dst) {
	sec
	lda dst
	sbc src
	sta dst

	lda dst+1
	sbc src+1
	sta dst+1
}

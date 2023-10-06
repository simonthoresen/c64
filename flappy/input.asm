.macro drawJoyState() {
    inc $0425
    lda #'u'
    sta $0426
	lda #'f'
    sta $0427
    lda #'l'
    sta $044d
    lda #'d'
    sta $044e
    lda #'r'
    sta $044f

    lda #JOY_UP
    bit JOY1_STATE
	bne !+
	lda $0426
	ora #$80
	sta $0426
!:

	lda #JOY_FIRE
    bit JOY1_STATE
	bne !+
	lda $0427
	ora #$80
	sta $0427
!:

	lda #JOY_LEFT
    bit JOY1_STATE
	bne !+
	lda $044d
	ora #$80
	sta $044d
!:

	lda #JOY_DOWN
    bit JOY1_STATE
	bne !+
	lda $044e
	ora #$80
	sta $044e
!:

	lda #JOY_RIGHT
    bit JOY1_STATE
	bne !+
	lda $044f
	ora #$80
	sta $044f
!:
}
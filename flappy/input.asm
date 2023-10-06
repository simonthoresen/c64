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

	lda JOY1_STATE
	and #JOY_UP
	bne !+
	lda $0426
	ora #$80
	sta $0426
!:

	lda JOY1_STATE
	and #JOY_FIRE
	bne !+
	lda $0427
	ora #$80
	sta $0427
!:

	lda JOY1_STATE
	and #JOY_LEFT
	bne !+
	lda $044d
	ora #$80
	sta $044d
!:

	lda JOY1_STATE
	and #JOY_DOWN
	bne !+
	lda $044e
	ora #$80
	sta $044e
!:

	lda JOY1_STATE
	and #JOY_RIGHT
	bne !+
	lda $044f
	ora #$80
	sta $044f
!:
}
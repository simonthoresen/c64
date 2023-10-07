.macro draw_joy_state() {
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

    lda #MSK_JOY_UP
    bit ADR_JOY1_STATE
	bne !+
	lda $0426
	ora #$80
	sta $0426
!:

	lda #MSK_JOY_FIRE
    bit ADR_JOY1_STATE
	bne !+
	lda $0427
	ora #$80
	sta $0427
!:

	lda #MSK_JOY_LEFT
    bit ADR_JOY1_STATE
	bne !+
	lda $044d
	ora #$80
	sta $044d
!:

	lda #MSK_JOY_DOWN
    bit ADR_JOY1_STATE
	bne !+
	lda $044e
	ora #$80
	sta $044e
!:

	lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
	bne !+
	lda $044f
	ora #$80
	sta $044f
!:
}
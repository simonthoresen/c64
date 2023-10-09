.macro set_border_color(col) {
	lda #col
	sta ADR_BORDER_COL
}

.macro set_background_color(col) {
	lda #col
	sta ADR_BACKGROUND_COL
}

.macro clear_screen(clearByte) {
	lda #clearByte
	ldx #$00
!:
	sta ADR_SCREEN, x
	sta ADR_SCREEN + $0100, x
	sta ADR_SCREEN + $0200, x
	sta ADR_SCREEN + $0300, x
	inx
	bne !-
}

.macro sta_val16(val, dst) {
	lda #<val
	sta dst
	lda #>val
	sta dst+1
}

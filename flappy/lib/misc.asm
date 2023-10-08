.macro set_border_color(col) {
	lda #col
	sta ADR_BORDER_COL
}

.macro set_background_color(col) {
	lda #col
	sta ADR_BACKGROUND_COL
}

.macro clear_screen(screen, clearByte) {
	lda #clearByte
	ldx #$00
!:
	sta screen, x
	sta screen + $0100, x
	sta screen + $0200, x
	sta screen + $0300, x
	inx
	bne !-
}

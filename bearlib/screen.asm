.macro set_border_color(col) 
{
	lda #col
	sta ADR_BORDER_COL
}

.macro set_background_color(col) 
{
	lda #col
	sta ADR_BACKGROUND_COL
}

.macro clear_screen(clearByte) 
{
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

.macro clear_colors(clearByte) 
{
	lda #clearByte
	ldx #$00
!:
	sta ADR_COLOR, x
	sta ADR_COLOR + $0100, x
	sta ADR_COLOR + $0200, x
	sta ADR_COLOR + $0300, x
	inx
	bne !-	
}

.macro wait_vblank() {
!:  // in case the raster is on our marker line, we wait for it increment
    lda $d012
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda $d012
    cmp #$fa // line 250
    bne !-    
}
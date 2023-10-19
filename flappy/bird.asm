.macro show_bird(sprite_id, col)
{
	lda #BLACK
	sta C64__SPRITE_COLOR+1
	lda #col
	sta C64__SPRITE_COLOR+2
	lda #YELLOW
	sta C64__SPRITE_COLOR+3

	tick_bird(sprite_id)

	lda #($0e << 4 * sprite_id)
	eor #$ff
	and C64__SPRITE_COLORED
	sta C64__SPRITE_COLORED

	lda #($0e << 4 * sprite_id)
	ora C64__SPRITE_ENABLED
	sta C64__SPRITE_ENABLED
}

.macro tick_bird(sprite_id)
{
	lda #sprite_id
	asl
	tax

	lda C64__SPRITE_POS,x
	sta C64__SPRITE_POS+2,x
	sta C64__SPRITE_POS+4,x
	sta C64__SPRITE_POS+6,x

	lda C64__SPRITE_POS+1,x
	sta C64__SPRITE_POS+3,x
	sta C64__SPRITE_POS+5,x
	sta C64__SPRITE_POS+7,x

	lda C64__SPRITE_POS_UPPER
	and #($01 << sprite_id)
	cmp #$00
	beq !+
	lda #($0f << 4 * sprite_id)
	ora C64__SPRITE_POS_UPPER
	jmp !++
!:
	lda #$ff
	eor #($0f << 4 * sprite_id)
	and C64__SPRITE_POS_UPPER
!:
	sta C64__SPRITE_POS_UPPER


	ldx #sprite_id
	lda C64__SPRITE_POINTERS, x
	adc #$05
	sta C64__SPRITE_POINTERS + 1, x 
	adc #$05
	sta C64__SPRITE_POINTERS + 2, x 	
	lda #$0f // beak is static
	sta C64__SPRITE_POINTERS + 3, x 
}

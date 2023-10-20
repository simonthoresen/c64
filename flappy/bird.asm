.macro show_bird(sprite_id, col)
{	
	.var mask = (sprite_id == $00) ? $0e : $e0

	lda #C64__BLACK
	sta C64__SPRITE_COLOR + sprite_id + 1
	lda #col
	sta C64__SPRITE_COLOR + sprite_id + 2
	lda #C64__YELLOW
	sta C64__SPRITE_COLOR + sprite_id + 3

	lda #$ff
	eor #mask
	and C64__SPRITE_COLORED
	sta C64__SPRITE_COLORED

	tick_bird(sprite_id)

	lda #mask
	ora C64__SPRITE_ENABLED
	sta C64__SPRITE_ENABLED
}

.macro tick_bird(sprite_id)
{
	.var mask = (sprite_id == $00) ? $0e : $e0

	lda C64__SPRITE_POS + sprite_id * 2 + 0
	sta C64__SPRITE_POS + sprite_id * 2 + 2
	sta C64__SPRITE_POS + sprite_id * 2 + 4
	sta C64__SPRITE_POS + sprite_id * 2 + 6

	lda #(1 << sprite_id)
	and C64__SPRITE_POS_UPPER
	cmp #$00
	beq no_upper
upper_on:
	lda C64__SPRITE_POS_UPPER
	ora #mask
	jmp !+
no_upper:
	lda #$ff
	eor #mask
	and C64__SPRITE_POS_UPPER
!:
	sta C64__SPRITE_POS_UPPER


	lda C64__SPRITE_POS + sprite_id * 2 + 1
	sta C64__SPRITE_POS + sprite_id * 2 + 3
	sta C64__SPRITE_POS + sprite_id * 2 + 5
	sta C64__SPRITE_POS + sprite_id * 2 + 7 

	ldx C64__SPRITE_POINTERS + sprite_id
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 1
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 2
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 3
}

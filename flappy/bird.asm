.macro show_bird(sprite_id, bird_mask, col)
{
	lda #C64__BLACK
	sta C64__SPRITE_COLOR + sprite_id + 1
	lda #C64__LGREY
	sta C64__SPRITE_COLOR + sprite_id + 2
	lda #C64__YELLOW
	sta C64__SPRITE_COLOR + sprite_id + 3

	lda $ff
	eor #bird_mask
	and C64__SPRITE_COLORED
	sta C64__SPRITE_COLORED

	tick_bird(sprite_id, bird_mask)

	lda #bird_mask
	ora C64__SPRITE_ENABLED
	sta C64__SPRITE_ENABLED
}

.macro tick_bird(sprite_id, bird_mask)
{
	lda C64__SPRITE_POS + sprite_id
	sta C64__SPRITE_POS + sprite_id + 2
	sta C64__SPRITE_POS + sprite_id + 4
	sta C64__SPRITE_POS + sprite_id + 6

	lda #(1 << sprite_id *4)
	bit C64__SPRITE_POS_UPPER
	beq !+ // no upper
	lda C64__SPRITE_POS_UPPER
	eor #bird_mask
	jmp !++
!:
	lda C64__SPRITE_POS_UPPER
	ora #bird_mask
!:
	sta C64__SPRITE_POS_UPPER

	lda C64__SPRITE_POS + sprite_id + 1
	sta C64__SPRITE_POS + sprite_id + 3
	sta C64__SPRITE_POS + sprite_id + 5
	sta C64__SPRITE_POS + sprite_id + 7

	ldx C64__SPRITE_POINTERS + sprite_id
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 1
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 2
	inx
	stx C64__SPRITE_POINTERS + sprite_id + 3
}

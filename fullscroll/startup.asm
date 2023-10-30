BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

_seed: 
    alloc_seed()
_world_x:
    .byte $ff
_walls:
	.byte $00
_frame:
	.byte $00
_title:
	//    "0123456789012345678901234567890123456789"
	.text "score: 000       flappy       score: 000"

startup:
	enter_startup()
	setup_irq($00, irq0)
	leave_startup()

main:
	init_screen()

main_loop:
	// color border so that white means we use cpu, black means we idle for
	// there to be smooth scrolling, the cpu needs to be released before 
	// the rastering begins
	lda #$00
	sta C64__COLOR_BORDER
	wait_vblank()
	lda #$01
	sta C64__COLOR_BORDER

	// perform smooth scroll until we are ready to hard scroll the
	// screen data
	inc _world_x
	left_scroll_on($00, 02, 2)
	left_scroll_on($01, 04, 3)
	left_scroll_on($02, 07, 3)
	left_scroll_on($03, 10, 3)
	left_scroll_on($04, 13, 3)
	left_scroll_on($05, 16, 3)
	left_scroll_on($06, 19, 3)
	left_scroll_on($07, 22, 2)
	jmp main_loop

.macro left_scroll_on(band, row, num_rows)
{
	lda _world_x
	and #$07 // isolate lower 3 bits
	cmp #band
	bne !+
	left_scroll(band, row, num_rows)
!:
}

.macro left_scroll(band, row, num_rows)
{
	ldx #$00
!:
	.var adr_dat = C64__SCREEN_DATA + $28 * row
	.var adr_col = C64__SCREEN_COLOR + $28 * row
	.for (var i = 0; i < num_rows; i++) {
		lda adr_dat + $28 * i + $01, x
		sta adr_dat + $28 * i + $00, x

		lda adr_col + $28 * i + $01, x
		sta adr_col + $28 * i + $00, x
	}
	inx
	cpx #$27
	bne !-
	next_col(band, row, num_rows)
}

//                0123456789abcdef               
_WALL_TOP: .text "123             "
_WALL_MID: .text "456             "
_WALL_BOT: .text "789             "
_EMPTY_BG: .text "                "
_BIT_MASK: .byte $01, $02, $04, $08, $10, $20, $40, $80

maybe_create_next:
	lda _world_x
	and #$7f
	cmp #$00
	beq !+
	rts
!:
	lda_rand(_seed)
	and #$07
	tax
	lda _BIT_MASK, x
	eor #$ff
	sta _walls
	print_byte(_walls, 0, 0)
	rts

.macro next_col(band, row, num_rows)
{
	.var adr_dat = C64__SCREEN_DATA + $28 * row + $27
	.var adr_col = C64__SCREEN_COLOR + $28 * row + $27

	// randomize current wall
	jsr maybe_create_next

	// draw walls according to template
	lda _world_x
	lsr // get rid of offset bits
	lsr
	lsr
	and #$0f
	tax

	lda _walls
	and #(1 << band)
	cmp #$00
	bne insert_wall

insert_air:
	lda _EMPTY_BG, x
	.for (var i = 0; i < num_rows; i++) {
		sta adr_dat + $28 * i
	}
	jmp done

insert_wall:
	lda _WALL_TOP, x
	sta adr_dat
	lda _WALL_MID, x
	.for (var i = 1; i < num_rows - 1; i++) {
		sta adr_dat + $28 * i
	}
	lda _WALL_BOT, x
	sta adr_dat + $28 * (num_rows - 1)

	// randomize color on segment start
	cpx #$00
	bne done
	lda_rand(_seed)
	and #$0f
	.for (var i = 0; i < num_rows; i++) {
		sta adr_col + $28 * i
	}

done:
}

.macro init_screen()
{
	ldx #$00
!:
	lda _title, x
	sta C64__SCREEN_DATA + $28 * 00, x
	lda #'x'
    sta C64__SCREEN_DATA + $28 * 01, x
	lda #' '
	.for (var i = 2; i < 24; i++) {
		sta C64__SCREEN_DATA + $28 * i, x
	}
	lda #'x'
    sta C64__SCREEN_DATA + $28 * 24, x
	inx
	cpx #$28
    bne !-
}

irq0: // score line
	enter_irq()
	scroll_screen_x_i8($00)
	setup_irq($3a, irq1)
	leave_irq()
	rti
irq1: // ceiling
	do_irq(0, $42, irq2)
	rti
irq2: // row 0
	do_irq(0, $52, irq3)
	rti
irq3: // row 1
	do_irq(1, $6a, irq4)
	rti
irq4: // row 2
	do_irq(2, $82, irq5)
	rti
irq5: // row 3
	do_irq(3, $9a, irq6)
	rti
irq6: // row 4
	do_irq(4, $b2, irq7)
	rti
irq7: // row 5
	do_irq(5, $ca, irq8)
	rti
irq8: // row 6
	do_irq(6, $e2, irq9)
	rti
irq9: // row 7
	do_irq(7, $f2, irq10)
	rti
irq10: // floor
	do_irq(0, $00, irq0)
	rti

.macro do_irq(scroll_offset, next_raster, next_handler)
{
	enter_irq()
	lda _world_x
	eor #$ff
	clc
	adc #scroll_offset
	sta C64__ZEROP_BYTE
	scroll_screen_x_a8(C64__ZEROP_BYTE)
	setup_irq(next_raster, next_handler)
	leave_irq()
}

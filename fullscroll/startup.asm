BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"
#import "data.asm"

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

*=$4000 "Main Program"
startup:
	enter_startup()
	setup_irq($00, irq0)
	setup_charset()
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

	jsr scroll_world
	jmp main_loop


scroll_world:
	inc _world_x
	lda _world_x
	and #$07

	cmp #$00
	bne !+
	left_rotate(1)
	left_rotate(24)
!:

	lda _world_x
	and #$07
	check_band($00, 02, 2)
	check_band($01, 04, 3)
	check_band($02, 07, 3)
	check_band($03, 10, 3)
	check_band($04, 13, 3)
	check_band($05, 16, 3)
	check_band($06, 19, 3)
	check_band($07, 22, 2)
	rts

.macro check_band(band, row, num_rows)
{
	cmp #band
	bne !+
	left_scroll(band, row, num_rows)
	rts
!:
}

.macro left_rotate(row)
{
	.var adr_dat = C64__SCREEN_DATA + $28 * row
	.var adr_col = C64__SCREEN_COLOR + $28 * row
	lda adr_dat
	pha
	lda adr_col
	pha

	ldx #$00
!:
	lda adr_dat + $01, x
	sta adr_dat + $00, x
	lda adr_col + $01, x
	sta adr_col + $00, x
	inx
	cpx #$27
	bne !-

	pla 
	sta adr_col, x
	pla
	sta adr_dat, x
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
_WALL_TOP: .byte $77, $78, $79, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_WALL_MID: .byte $71, $72, $73, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_WALL_BOT: .byte $74, $75, $76, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_EMPTY_BG: .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_BIT_MASK: .byte $01, $02, $04, $08, $10, $20, $40, $80

_WALL_MID_C: .byte $09, $0B, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_WALL_BOT_C: .byte $0B, $0B, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_WALL_TOP_C: .byte $09, $0F, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
_EMPTY_BG_C: .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


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

done:
	.for (var i = 0; i < num_rows; i++) {
		ldx adr_dat + $28 * i
		//lda $3000, x
		//and #$0f
		jsr lda_char_col
		sta adr_col + $28 * i
	}
}

lda_char_col:
	lda $3000, x
	and #$0f
	rts

.macro init_screen()
{
	clear_screen($00)

	//    "0123456789012345678901234567890123456789"
	.var font_adr = $2800 + $0495
	.var font_chars = @" abcdefghijklmnopqrstuvwxyz0123456789.,?!'\"()-+:"
	.var title_line = "score: 000       flappy       score: 000"

	ldx #$11
	.for (var i = 0; i < title_line.size(); i++) {
		lda #font_adr + index_of(title_line.charAt(i), font_chars)
		sta C64__SCREEN_DATA + i
		stx C64__SCREEN_COLOR + i
	}

	ldx #$0f
	lda $3000 + $0f
	and #$0f
	.for (var i = 0; i < 40; i += 2) {
		stx C64__SCREEN_DATA  + $28 * 01 + i
		sta C64__SCREEN_COLOR + $28 * 01 + i
		stx C64__SCREEN_DATA  + $28 * 24 + i
		sta C64__SCREEN_COLOR + $28 * 24 + i
	}

	ldx #$10
	lda $3000 + $10
	and #$0f
	.for (var i = 1; i < 40; i += 2) {
		stx C64__SCREEN_DATA  + $28 * 01 + i
		sta C64__SCREEN_COLOR + $28 * 01 + i
		stx C64__SCREEN_DATA  + $28 * 24 + i
		sta C64__SCREEN_COLOR + $28 * 24 + i
	}
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

.macro setup_charset()
{
	lda C64__SCREEN_CTRL2
	ora #%00010000 // multicolor
	sta C64__SCREEN_CTRL2


	lda #$00
	sta C64__COLOR_BG0
	lda #$0e
	sta C64__COLOR_BG1
	lda #$06
	sta C64__COLOR_BG2


	lda C64__MEM_SETUP
	and #%11110001
	ora #%00001010 // $2800-$2fff
	sta C64__MEM_SETUP
}
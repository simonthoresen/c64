BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"


/*
 * 40x25
 * 0: score
 * 1: ceiling
 * 2-23: 6 + 5 + 5 + 6
 * 2 + 3 + 3 + 3 + 3 + 3 + 3 + 2
 * 24: floor
 * 
 * Split the screen into 4 horizontal sections (e.g. 6 rows each).
 *
 * Stagger the horizontal fine scroll offsets by 2 pixels per section (compared to the section above) 
 * using raster interrupts with accurate delays timing delays.
 *
 * Scroll the horizontal fine scroll register every frame, offset by 2 for each section
 * 
 * Only scroll the screen and color memory for 1 section at a time (when your fine scroll wraps
 * around for that section).
 */

_seed: 
    alloc_seed()
_world_x16:
    .word $ffff
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
	inc__a16(_world_x16)
	left_scroll_on($00, 02, 2)
	left_scroll_on($01, 04, 3)
	left_scroll_on($02, 07, 3)
	left_scroll_on($03, 10, 3)
	left_scroll_on($04, 13, 3)
	left_scroll_on($05, 16, 3)
	left_scroll_on($06, 19, 3)
	left_scroll_on($07, 22, 2)
	jmp main_loop

.macro left_scroll_on(when, row, num_rows)
{
	lda _world_x16
	and #$07 // isolate lower 3 bits
	cmp #when
	bne !+
	left_scroll(row, num_rows)
!:
}

.macro left_scroll(row, num_rows)
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
	next_col(row, num_rows)
}

.macro next_col(row, num_rows)
{
	.var adr_dat = C64__SCREEN_DATA + $28 * row
	.var adr_col = C64__SCREEN_COLOR + $28 * row

	lda_rand(_seed)
	and #$01
	clc
	adc #' '-1
	.for (var i = 0; i < num_rows; i++) {
		sta adr_dat + $28 * i + $00, x
	}
	lda_rand(_seed)
	and #$0f
	.for (var i = 0; i < num_rows; i++) {
		sta adr_col + $28 * i + $00, x
	}
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
	lda _world_x16
	eor #$ff
	clc
	adc #scroll_offset
	sta C64__ZEROP_BYTE
	scroll_screen_x_a8(C64__ZEROP_BYTE)
	setup_irq(next_raster, next_handler)
	leave_irq()
}


.macro left_scroll_8th(row)
{
    ldx #$00
!:  lda C64__SCREEN_DATA + $0001 + row * $80, x
    sta C64__SCREEN_DATA + $0000 + row * $80, x
    inx
    cpx #$80 // 128
    bne !-
}
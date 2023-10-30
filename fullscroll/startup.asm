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
_scroll:
    .byte $00
_frame:
	.byte $00

startup:
	enter_startup()
	setup_irq($00, irq0)
	leave_startup()

main:
	ldx #$00
!:
.for (var i = 0; i < 4; i++) {
	//lda_rand(_seed)
	txa
	and #%00000111
	clc
	adc #'0'
    sta C64__SCREEN_DATA + $0100*i, x
}
	inx    
    bne !-

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
	dec _scroll
	left_scroll_on($07, C64__SCREEN_DATA + $28 * 02, 2)
	left_scroll_on($06, C64__SCREEN_DATA + $28 * 04, 3)
	left_scroll_on($05, C64__SCREEN_DATA + $28 * 07, 3)
	left_scroll_on($04, C64__SCREEN_DATA + $28 * 10, 3)
	left_scroll_on($03, C64__SCREEN_DATA + $28 * 13, 3)
	left_scroll_on($02, C64__SCREEN_DATA + $28 * 16, 3)
	left_scroll_on($01, C64__SCREEN_DATA + $28 * 19, 3)
	left_scroll_on($00, C64__SCREEN_DATA + $28 * 22, 2)
	jmp main_loop

.macro left_scroll_on(when, adr, num_rows)
{
	lda _scroll	
	and #$07 // isolate lower 3 bits
	cmp #when
	bne !+
	left_scroll(adr, num_rows)
!:
}

.macro left_scroll(adr, num_rows)
{
	ldx #$00
!:
	.for (var i = 0; i < num_rows; i++) {
		lda adr + $28 * i + $01, x
		sta adr + $28 * i + $00, x
	}
	inx
	cpx #$27
	bne !-
	lda #'x'
	.for (var i = 0; i < num_rows; i++) {
		sta adr + $28 * i + $00, x
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
	lda _scroll
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
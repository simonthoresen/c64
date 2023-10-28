BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"


/*
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

startup:
	enter_startup()
	setup_irq($00, irq0)
	leave_startup()

main:
	ldx #$00
!:
.for (var i = 0; i < 4; i++) {
	lda_rand(_seed)
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
.if (false)
{
	dec _scroll
	lda _scroll
    and #%00000111
	cmp #%00000111
	bne main_loop
}

	jmp main_loop


irq0:
	enter_irq()
	scroll_screen_x_i8($07)
    left_scroll_8th(0)
	setup_irq($00, irq1)
	leave_irq()
	rti

irq1:
	enter_irq()
	scroll_screen_x_i8($06)
    left_scroll_8th(1)
	setup_irq($00, irq2)
	leave_irq()
	rti

irq2:
	enter_irq()
	scroll_screen_x_i8($05)
    left_scroll_8th(2)
	setup_irq($00, irq3)
	leave_irq()
	rti

irq3:
	enter_irq()
	scroll_screen_x_i8($04)
    left_scroll_8th(3)
	setup_irq($00, irq4)
	leave_irq()
	rti

irq4:
	enter_irq()
	scroll_screen_x_i8($03)
    left_scroll_8th(4)
	setup_irq($00, irq5)
	leave_irq()
	rti

irq5:
	enter_irq()
	scroll_screen_x_i8($02)
    left_scroll_8th(5)
	setup_irq($00, irq6)
	leave_irq()
	rti

irq6:
	enter_irq()
	scroll_screen_x_i8($01)
    left_scroll_8th(6)
	setup_irq($00, irq7)
	leave_irq()
	rti

irq7:
	enter_irq()
	scroll_screen_x_i8($00)
    left_scroll_8th(7)
	setup_irq($00, irq0)
	leave_irq()
	rti


.macro left_scroll_8th(row)
{
    ldx #$00
!:  lda C64__SCREEN_DATA + $0001 + row * $80, x
    sta C64__SCREEN_DATA + $0000 + row * $80, x
    inx
    cpx #$80 // 128
    bne !-
}
BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

_seed: 
    alloc_seed()
_scroll:
    .byte $00

startup:
	enter_startup()
	setup_irq($00, irq)
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

.for (var i = 0; i < 4; i++) 
{    
    ldx #$00
!:  lda C64__SCREEN_DATA + $0001 + i * $0100, x
    sta C64__SCREEN_DATA + $0000 + i * $0100, x
    inx
    cpx #$00
    bne !-
}
	jmp main_loop


irq:
	enter_irq()
	scroll_screen_x_a8(_scroll)
	leave_irq()
	rti


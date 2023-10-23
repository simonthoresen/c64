main_init:
	sei
	register_irq($00, irq1)
	cli
	rts

main_irq:
	rts

_x: .byte $00

irq1:
	enter_irq()
	register_irq($3a, irq2)

	count_vblank()

    lda _x
    cmp #$00
    beq !+
    dec _x
    jmp !++
!:
	lda #$07
	sta _x
!:
	scroll_screen_x_a8(_x)
	scroll_screen_y_i8($03)
	leave_irq()
	rti

irq2:
	enter_irq()
	register_irq($00, irq1)
	scroll_screen_x_i8($00)
	scroll_screen_y_a8(_x)
    leave_irq()
	rti


main:
/*
	lda C64__SCREEN_CTRL1
	ora #%00010000 // multicolor
	sta C64__SCREEN_CTRL1
*/

	lda C64__MEM_SETUP
	and #%11110001
	ora #%00001010 // $2800-$2fff
	sta C64__MEM_SETUP

    lda #$00
    ldx #$00
!:
    sta C64__SCREEN_DATA + $0000, x
    sta C64__SCREEN_DATA + $0100, x
    sta C64__SCREEN_DATA + $0200, x
    sta C64__SCREEN_DATA + $0300, x
    adc #$01
	inx    
    bne !-


    lda #$00
    ldx #$27
!:
    sta C64__SCREEN_DATA + $0000, x
    adc #$01
    dex
    bpl !-





main_loop:
	sync_tick(0)
/*
	dec C64__SCREEN_CTRL2
	lda C64__SCREEN_CTRL2
	and #$07
	cmp #$00
	bne main_loop

	lda #$07
	ora C64__SCREEN_CTRL2
	sta C64__SCREEN_CTRL2
*/
	lda _x
	cmp #$00
	bne main_loop

hard:
	lda C64__SCREEN_DATA + $0000
	pha
	ldx #$00
!:
	lda C64__SCREEN_DATA + $0001, x
	sta C64__SCREEN_DATA + $0000, x
	inx
	cpx #$27
	bne !-
	pla
	sta C64__SCREEN_DATA + $0027
	jmp main_loop




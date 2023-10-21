main_init:
	sei
	
	lda #$00   // this is how to tell at which rasterline we want the irq to be triggered
    sta $d012

    lda #<irq1  // this is how we set up
    sta $fffe  // the address of our interrupt code
    lda #>irq1
    sta $ffff

	cli
	rts

main_irq:
	rts

_x: .byte $00

irq1:
	pha
	txa
	pha
	tya
	pha
	lda #$ff   // this is the orthodox and safe way of clearing the interrupt condition of the VICII.
    sta $d019

	lda #$3a   // this is how to tell at which rasterline we want the irq to be triggered
    sta $d012
    lda #<irq2  // this is how we set up
    sta $fffe  // the address of our interrupt code
    lda #>irq2
    sta $ffff

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

	lda C64__SCREEN_CTRL2
	and #%11111000
	ora _x
	sta C64__SCREEN_CTRL2

	pla
	tay
	pla
	tax
	pla
	rti

irq2:
	pha
	txa
	pha
	tya
	pha
	lda #$ff
    sta $d019

	lda #$00 
    sta $d012
    lda #<irq1
    sta $fffe
    lda #>irq1
    sta $ffff

    lda C64__SCREEN_CTRL2
    and #%11111000
    sta C64__SCREEN_CTRL2

	pla
	tay
	pla
	tax
	pla
	rti


main:
/*
	lda C64__SCREEN_CTRL1
	ora #%00010000 // multicolor
	sta C64__SCREEN_CTRL1
*/
/*
	lda C64__MEM_SETUP
	and #%11110001
	ora #%00001010 // $2800-$2fff
	sta C64__MEM_SETUP
*/

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
.for(var y = 0; y < 25; y++) {

	lda C64__SCREEN_DATA + $0000 + $28*y
	pha
	ldx #$00
!:
	lda C64__SCREEN_DATA + $0001 + $28*y, x
	sta C64__SCREEN_DATA + $0000 + $28*y, x
	inx
	cpx #$27
	bne !-
	pla
	sta C64__SCREEN_DATA + $0027 + $28*y
}




	jmp main_loop




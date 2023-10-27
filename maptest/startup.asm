BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"
#import "data.asm"

.const WALL_L = $0f
.const WALL_R = $10
.const WALL_UL = $77
.const WALL_UC = $78
.const WALL_UR = $79
.const WALL_ML = $71
.const WALL_MC = $72
.const WALL_MR = $73
.const WALL_BL = $74
.const WALL_BC = $75
.const WALL_BR = $76

_scroll_x: 		.word $00
_walls_data: 	.fill $40, $00 // 64 bytes cyclic buffer
_walls_head:	.byte $00 // pointer to slot 0 in buffer
_walls_seed: 	alloc_seed()


*=$4000 "Main Program"
startup:
	enter_startup()
	//setup_irq($00, irq1)
	leave_startup()

main:
/*
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

	draw_level()
*/
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
	dec _scroll_x
	lda _scroll_x
	and #%00000111
	cmp #%00000111
	bne main_loop

hard:
	jsr scroll_walls
	//1a: print_walls()
	//1b: shift_screen()




	jmp main_loop


// extend current wall segment (bit 4+5)
// bits 0-1; running counter of current segment (air or wall), value 0-3
// bits 0-3; running counter of current block (consists of 1x wall and 3x air), value 0-16
// bits 4-7; height of wall in current block, value 0-16
scroll_walls:
	// increment the head-pointer of the walls
	inc _walls_head
	lda _walls_head
	and #%00111111
	sta _walls_head

	// store the new tail-pointer in y
	ldy _walls_head
	dey 
	tya
	and #%00111111
	tay

	// store the old tail-pointer in x
	tax
	dex
	txa
	and #%00111111
	tax

	// read out the wall in prev and prepare next
	lda _walls_data, x
	clc
	adc #$01
	and #%00001111 // keep lower nibble / block index
	sta C64__ZEROP_BYTE
	cmp #$00 // end of segment
	beq create_wall
extend_wall:
	lda _walls_data, x
	jmp !+
create_wall:
	lda_rand(_walls_seed)
	// fall through	
!:
	and #%11110000 // keep upper nibble of wall
	ora C64__ZEROP_BYTE // join with lower nibble counter
	sta _walls_data, y
	rts


irq1:
	enter_irq()
	setup_irq($3a, irq2)
	scroll_screen_x_i8($00)
	leave_irq()
	rti

irq2:
	enter_irq()
	setup_irq($00, irq1)
	scroll_screen_x_a8(_scroll_x)
    leave_irq()
	rti


.macro shift_screen()
{
	.for (var i = 1; i < 25; i++) {

		lda C64__SCREEN_DATA + $0000 + 40*i
		pha
		ldx #$00
	!:
		lda C64__SCREEN_DATA + $0001 + 40*i, x
		sta C64__SCREEN_DATA + $0000 + 40*i, x
		tay
		lda $3000,y // char color
		and #$0f
		sta C64__SCREEN_COLOR + $0000 + 40*i,x	

		inx
		cpx #$27
		bne !-
		pla
		sta C64__SCREEN_DATA + $0027 + 40*i
		tay
		lda $3000,y // char color
		and #$0f
		sta C64__SCREEN_COLOR + $0027 + 40*i,x	
	}
}

.macro draw_level()
{
   ldx #$00
!:
.for (var i = 0; i < 4; i++) {
	lda _level + $0100*i,x
    sta C64__SCREEN_DATA + $0100*i, x
    tay
    lda $3000,y // char color
    and #$0f
    sta C64__SCREEN_COLOR + $0100*i,x	
}

	inx    
    bne !-
}

_level:
	.byte $0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$77,$78,$78,$79,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$74,$75,$75,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$77,$78,$79,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$71,$72,$73,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$74,$75,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10,$0f,$10


.macro print_walls()
{
	ldx _walls_head
	ldy #$00
!:
	lda _walls_data, x
	and #%00001111
	clc 
	adc #'0'
	sta C64__SCREEN_DATA, y

	lda _walls_data, x
	lsr
	lsr
	lsr
	lsr
	clc 
	adc #'0'
	sta C64__SCREEN_DATA + $28, y

	// increment wall buf ptr
	inx
	txa 
	and #%00111111
	tax

	// increment screen pos
	iny
	cpy #$28
	bne !-
}

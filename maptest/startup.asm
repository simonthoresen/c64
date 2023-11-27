BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"
#import "data.asm"

.const C64__ZEROP_BYTE = C64__ZEROP_BYTE0
.const C64__ZEROP_BYTE2 = C64__ZEROP_FREE + 0

.const BEAM_L = $0f
.const BEAM_R = $10
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
_walls_data: 	.fill $40, %00001100 // 64 bytes cyclic buffer
_walls_head:	.byte $00 // pointer to slot 0 in buffer
_walls_seed: 	alloc_seed()


*=$4000 "Main Program"
startup:
	enter_startup()
	setup_irq($00, irq1)
	leave_startup()

main:
	setup_charset()
	clear_screen($00)
	//draw_level()

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
.if (false) {
	dec _scroll_x
	lda _scroll_x
	and #%00000111
	cmp #%00000111
	bne main_loop
}

hard:
	jsr scroll_walls
//	print_walls()
//  shift_screen()

	// run from left to right
	// consider the current segment (16 columns), aka lower nibble
	// if in the first 4 columns (upper 2 bits of nibble is empty), we have a wall
	// the start of the wall is given by upper nibble
	// the length of the wall is always 25 - 2 (border) - 16 (start) = 7
	lda _walls_head
	sta C64__ZEROP_BYTE1
	lda #$00
	sta C64__ZEROP_BYTE2

!:
	ldy C64__ZEROP_BYTE2
	ldx C64__ZEROP_BYTE1
	lda _walls_data, x
	and #%00001111
	// todo: clever layout of the below memory so that
	// todo: we can simply jump based on value of acc	
	cmp #$00
	beq wall_lhs
	cmp #$01
	beq wall_mid
	cmp #$02
	beq wall_mid
	cmp #$03
	beq wall_rhs
	cmp #$04
	beq wall_clr
	jmp wall_end

wall_lhs:
	lda _walls_data, x
	lsr
	lsr
	lsr
	lsr
	
	lda #WALL_UL
	sta C64__SCREEN_DATA + $28*5, y	
	lda $3000 + WALL_UL
	and #$0f
	sta C64__SCREEN_COLOR + $28*5, y
	jmp wall_end

wall_mid:
	lda #WALL_UC
	sta C64__SCREEN_DATA + $28*5, y	
	lda $3000 + WALL_UC
	and #$0f
	sta C64__SCREEN_COLOR + $28*5, y
	jmp wall_end

wall_rhs:
	lda #WALL_UR
	sta C64__SCREEN_DATA + $28*5, y	
	lda $3000 + WALL_UR
	and #$0f
	sta C64__SCREEN_COLOR + $28*5, y
	jmp wall_end

wall_clr:
	lda #$00
	sta C64__SCREEN_DATA + $28*5, y	
	jmp wall_end

wall_end:


	// increment wall buf ptr
	inc C64__ZEROP_BYTE1
	lda C64__ZEROP_BYTE1
	and #%00111111
	sta C64__ZEROP_BYTE1

	// increment screen pos
	inc C64__ZEROP_BYTE2
	lda C64__ZEROP_BYTE2
	cmp #$28
	bne !-

	jmp main_loop


// bits 0-3; running counter of current segment, value 0-16
// bits 4-7; height of wall in current segment, value 0-16
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


_screen_data_row:
	.fill 25, C64__SCREEN_DATA + $28 * i
_screen_color_row:
	.fill 25, C64__SCREEN_COLOR + $28 * i


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

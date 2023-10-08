.const ADR_JOY1_STATE			= $dc01
.const ADR_JOY2_STATE			= $dc00

.const MSK_JOY_UP 				= $01
.const MSK_JOY_DOWN 			= $02
.const MSK_JOY_LEFT 			= $04
.const MSK_JOY_RIGHT 			= $08
.const MSK_JOY_FIRE 			= $10

.const COL_BLACK       			= $00
.const COL_WHITE       			= $01
.const COL_RED       			= $02
.const COL_CYAN       			= $03
.const COL_PURPLE      			= $04
.const COL_GREEN       			= $05
.const COL_BLUE       			= $06
.const COL_YELLOW       		= $07
.const COL_ORANGE       		= $08
.const COL_BROWN       			= $09
.const COL_LRED       			= $0a
.const COL_DGREY       			= $0b
.const COL_GREY       			= $0c
.const COL_LGREEN       		= $0d
.const COL_LBLUE       			= $0e
.const COL_LGREY       			= $0f

.const ADR_BORDER_COL        	= $d020
.const ADR_BACKGROUND_COL    	= $d021
.const ADR_SCREEN				= $0400	// default, 1000 bytes

.const ADR_SPRITE_ENABLE 		= $d015
.const ADR_SPRITE_MCOL_ENABLE	= $d01c
.const ADR_SPRITE_MCOL0			= $d025
.const ADR_SPRITE_MCOL1			= $d026
.const ADR_SPRITE_POINTERS		= ADR_SCREEN + $03f8
.const ADR_SPRITE_POSX_BIT9     = $d010

.const ADR_SPR0_COLOR  		    = $d027
.const ADR_SPR0_POSX 			= $d000
.const ADR_SPR0_POSY 			= $d001
.const ADR_SPR0_POINTER			= ADR_SPRITE_POINTERS + 0

.const SPRITE_NUM_BYTES			= $40 // 64 bytes



.macro adc_8_to_16 (in8, in16, out16) {
	lda in16
	clc
	adc in8
	sta out16
	lda in16+1
	adc #$00
	sta out16+1		
}

.macro adc_16 (in1, in2, out) {
	lda in1
	clc
	adc in2
	sta out

	lda in1+1
	adc in2+1
	sta out+1
}
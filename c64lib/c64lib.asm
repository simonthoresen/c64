// ------------------------------------------------------------
//
// C64 constants
//
// ------------------------------------------------------------
.label C64__ARG0_LO             = $0002
.label C64__ARG0_HI             = $0003
.label C64__ARG0                = C64__ARG0_LO
.label C64__ARG1_LO             = $0004
.label C64__ARG1_HI             = $0005
.label C64__ARG1                = C64__ARG1_LO
.label C64__ARG2_LO             = $00fb
.label C64__ARG2_HI             = $00fc
.label C64__ARG2                = C64__ARG2_LO
.label C64__COLOR               = $0286
.label C64__JOY1                = $dc01
.label C64__JOY2                = $dc00
.label C64__JOY_UP              = %00000001
.label C64__JOY_DOWN            = %00000010
.label C64__JOY_LEFT            = %00000100
.label C64__JOY_RIGHT           = %00001000
.label C64__JOY_FIRE            = %00010000
.label C64__MEM_SETUP           = $d018
.label C64__RASTER_LINE         = $d012
.label C64__SCREEN_CTRL1        = $d011
.label C64__SCREEN_CTRL2        = $d016
.label C64__SCREEN_DATA         = $0400
.label C64__SCREEN_COLOR        = $d800
.label C64__SCROLL_X            = C64__SCREEN_CTRL2
.label C64__SCROLL_Y            = C64__SCREEN_CTRL1
.label C64__SPRITE_COLOR0       = $d027
.label C64__SPRITE_COLOR        = C64__SPRITE_COLOR0
.label C64__SPRITE_COLOR1       = $d025
.label C64__SPRITE_COLOR2       = $d026
.label C64__SPRITE_COLORED      = $d01c
.label C64__SPRITE_ENABLED      = $d015
.label C64__SPRITE_POINTERS     = $07f8
.label C64__SPRITE_POS          = $d000
.label C64__SPRITE_POS_UPPER    = $d010
.label C64__ZEROP_BYTE1         = $002a
.label C64__ZEROP_BYTE          = C64__ZEROP_BYTE1
.label C64__ZEROP_BYTE2         = $0052
.label C64__ZEROP_WORD_LO       = $00fd
.label C64__ZEROP_WORD_HI       = $00fe
.label C64__ZEROP_WORD          = C64__ZEROP_WORD_LO

.label C64__BLACK               = $00
.label C64__WHITE               = $01
.label C64__RED                 = $02
.label C64__CYAN                = $03
.label C64__PURPLE              = $04
.label C64__GREEN               = $05
.label C64__BLUE                = $06
.label C64__YELLOW              = $07
.label C64__ORANGE              = $08
.label C64__BROWN               = $09
.label C64__LRED                = $0a
.label C64__DGREY               = $0b
.label C64__GREY                = $0c
.label C64__LGREEN              = $0d
.label C64__LBLUE               = $0e
.label C64__LGREY               = $0f


// ------------------------------------------------------------
//
// Permutations of getters and setters.
//
// ------------------------------------------------------------
.macro set__a8(a8_var, a8_val)
{
    lda a8_val
    sta a8_var
}

.macro set__i8(a8_var, i8_val)
{
    lda #i8_val
    sta a8_var
}

.macro set__a16(a16_var, a16_val)
{
    lda a16_val
    sta a16_var
    lda a16_val + 1
    sta a16_var + 1
}

.macro set__i16(a16_var, i16_val)
{
    lda #<i16_val
    sta a16_var
    lda #>i16_val
    sta a16_var + 1
}

.macro inc__a16(a16_var)
{
    inc a16_var
    bne no_carry
    inc a16_var + 1
no_carry:
}

.macro add__a16_i8(a16_var, i8_val)
{
    clc
    lda #i8_val
    adc a16_var
    sta a16_var
    lda #$00
    adc a16_var + 1
}

.macro add__a16_i8s(a16_var, i8s_val)
{
    clc
    lda #i8s_val
    adc a16_var
    sta a16_var

    // sign-extend the high byte
    lda #i8s_val
    and #$80    // extract the sign bit
    beq !+      // if zero, add #$00 (+carry)
    lda #$ff    // else, add $ff (+ carry)
!:  adc a16_var + 1
    sta a16_var + 1
}

.macro add__a16_a8s(a16_var, a8s_val)
{
    clc
    lda a8s_val
    adc a16_var
    sta a16_var

    // sign-extend the high byte
    lda a8s_val
    and #$80    // extract the sign bit
    beq !+      // if zero, add #$00 (+carry)
    lda #$ff    // else, add $ff (+ carry)
!:  adc a16_var + 1
    sta a16_var + 1
}


// ------------------------------------------------------------
//
// Fill the screen with a byte or a color.
//
// ------------------------------------------------------------
.macro clear_screen(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta C64__SCREEN_DATA, x
    sta C64__SCREEN_DATA + $0100, x
    sta C64__SCREEN_DATA + $0200, x
    sta C64__SCREEN_DATA + $0300, x
    inx
    bne !-
}

.macro clear_colors(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta C64__SCREEN_COLOR, x
    sta C64__SCREEN_COLOR + $0100, x
    sta C64__SCREEN_COLOR + $0200, x
    sta C64__SCREEN_COLOR + $0300, x
    inx
    bne !-  
}


// ------------------------------------------------------------
//
// Printing to the screen.
//
// ------------------------------------------------------------
.macro print_word(src, pos_x, pos_y) {
    print_byte(src+1, pos_x, pos_y)
    print_byte(src, pos_x + 2, pos_y)
}

.macro print_byte(src, pos_x, pos_y) {
    lda src
    ldx #(pos_y * 40 + pos_x)
    jsr print.byte
}

.namespace print {

byte:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr nibble
    
    pla
    and #$0f
    inx
    jsr nibble
    rts

nibble:
    cmp #$0a
    bcs letter

digit:
    ora #$30
    jmp !+

letter:
    clc
    sbc #$08

!:
    sta C64__SCREEN_DATA, x

    lda C64__COLOR
    sta C64__SCREEN_COLOR, x
    rts

} 
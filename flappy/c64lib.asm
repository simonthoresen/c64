// ------------------------------------------------------------
//
// C64 constants
//
// ------------------------------------------------------------
.label C64__SCREEN_DAT       = $0400
.label C64__SCREEN_COL       = $d800
.label C64__COLOR            = $0286
.label C64__SPRITE_POINTERS  = $07f8
.label C64__RASTER_LINE      = $d012
.label C64__SPRITE_COLOR     = $d027
.label C64__SPRITE_COLOR_1   = $d025
.label C64__SPRITE_COLOR_2   = $d026
.label C64__SPRITE_COLORED   = $d01c
.label C64__SPRITE_ENABLED   = $d015
.label C64__SPRITE_POS_UPPER = $d010
.label C64__SPRITE_POS       = $d000

.label C64__BLACK            = $00
.label C64__WHITE            = $01
.label C64__RED              = $02
.label C64__CYAN             = $03
.label C64__PURPLE           = $04
.label C64__GREEN            = $05
.label C64__BLUE             = $06
.label C64__YELLOW           = $07
.label C64__ORANGE           = $08
.label C64__BROWN            = $09
.label C64__LRED             = $0a
.label C64__DGREY            = $0b
.label C64__GREY             = $0c
.label C64__LGREEN           = $0d
.label C64__LBLUE            = $0e
.label C64__LGREY            = $0f

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


// ------------------------------------------------------------
//
// Wait for the next vertical blank. Good for syncing the main
// loop to a fixed frequency.
//
// ------------------------------------------------------------
.macro wait_vblank() {
!:  // in case the raster is on our marker line, we wait for it increment
    lda C64__RASTER_LINE
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda C64__RASTER_LINE
    cmp #$fa // line 250
    bne !-    
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
    sta C64__SCREEN_DAT, x
    sta C64__SCREEN_DAT + $0100, x
    sta C64__SCREEN_DAT + $0200, x
    sta C64__SCREEN_DAT + $0300, x
    inx
    bne !-
}

.macro clear_colors(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta C64__SCREEN_COL, x
    sta C64__SCREEN_COL + $0100, x
    sta C64__SCREEN_COL + $0200, x
    sta C64__SCREEN_COL + $0300, x
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
    ldx #pos_y * 40 + pos_x
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
    sta C64__SCREEN_DAT, x

    lda C64__COLOR
    sta C64__SCREEN_COL, x
    rts

} 
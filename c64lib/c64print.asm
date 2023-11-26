#importonce
#import "c64lib.asm"
#define ENABLE_PRINT
#define ENABLE_PRINT_FONT
.const PRINT_FONT = @" abcdefghijklmnopqrstuvwxyz"

// ------------------------------------------------------------
//
// Variables
//
// ------------------------------------------------------------

#if ENABLE_PRINT
.namespace print {

_cursor_x: 
    .byte $00
_cursor_y: 
    .byte $00
_charmap:
    .const C64__CHARSET = @"@abcdefghijklmnopqrstuvwxyz[£]↑← !\"#$%&'()*+,-./0123456789:;<=>?"
    #if ENABLE_PRINT_FONT
        .fill 64, index_of(C64__CHARSET.charAt(i), PRINT_FONT, $ff)
    #else
        .fill 64, C64__CHARSET.charAt(i)
    #endif
}
#endif

// ------------------------------------------------------------
//
// Methods
//
// ------------------------------------------------------------
.macro print_at(i8_x, i8_y) { 
#if ENABLE_PRINT

    pha
    lda #i8_x
    sta print._cursor_x
    lda #i8_y
    sta print._cursor_y
    pla

#endif
}

.macro print_string(str) {
#if ENABLE_PRINT

    .for (var i = 0; i < str.size(); i++) {
        print_char__i8(str.charAt(i))
    }

#endif
}

.macro print__i8_i8_i8(i8_val, i8_x, i8_y) {
#if ENABLE_PRINT

    .error "not implemented"

#endif
}

.macro print__a8_i8_i8()
{
    .error "not implemented"        
}

.macro print__a8_a8_a8()
{
    .error "not implemented"    
}

.macro print_a__i8(i8_x, i8_y)
{
    .error "not implemented"
}

.macro print_a__a8(a8_x, a8_y)
{
    .error "not implemented"
}

.macro print_axy()
{    
    .error "not implemented"
}

.macro print_char__i8(i8) {
#if ENABLE_PRINT

    lda #i8
    ldx print._cursor_x
    ldy print._cursor_y
    jsr print.print_char_xya

    iny
    cpy #$28
    bne store_x
    ldy #$00
    ldx print._cursor_y
    inx
    cpx #$19
    bne store_y
    ldx #$00
store_y:
    stx print._cursor_y
store_x:
    sty print._cursor_x

#endif
}

#if ENABLE_PRINT
.namespace print {

print_char_xya:
    pha
    set__i16(C64__ZEROP_WORD0, C64__SCREEN_DATA)
    cpx #$00
    beq !++
!:  add__a16_i8(C64__ZEROP_WORD0, $28)
    dex
    bne !-
!:  
    pla
    jsr map_char
    sta (C64__ZEROP_WORD0), y
    rts

map_char:
    stx C64__ZEROP_BYTE0
    tax
    lda print._charmap, x
    ldx C64__ZEROP_BYTE0
    rts

}
#endif


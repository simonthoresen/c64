// Declare the following #defines before importing this file to 
// enable printing and custom fonts:
//
// #define ENABLE_PRINT
// #define ENABLE_PRINT_FONT
// .const PRINT_FONT = @" abcdefghijklmnopqrstuvwxyz"
// 
#importonce
#import "c64lib.asm"

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

#if ENABLE_PRINT_FONT
_char_map:
    .fill 256, index_of(i, PRINT_FONT, $ff)
#endif

}
#endif


// ------------------------------------------------------------
//
// Print a single character from the accumulator.
//
// ------------------------------------------------------------
#if ENABLE_PRINT
.namespace print {

print_acc:
    // backup value of y-reg because we need the register
    sta C64__ZEROP_BYTE0
    tya
    pha

    // compute screen-address of cursor
    set__i16(C64__ZEROP_WORD0, C64__SCREEN_DATA)
    ldy _cursor_y
    cpy #$00
    beq !++
!:  add__a16_i8(C64__ZEROP_WORD0, $28)
    dey
    bne !-
!:

    // write value in acc to screen
#if ENABLE_PRINT_FONT
    ldy C64__ZEROP_BYTE0
    lda print._char_map, y
#else
    lda C64__ZEROP_BYTE0
#endif
    ldy _cursor_x
    sta (C64__ZEROP_WORD0), y

    // move the cursor ahead
    inc _cursor_x
    lda _cursor_x
    cmp #$28
    bne !+

    lda #$00
    sta _cursor_x

    inc _cursor_y
    lda _cursor_y
    cmp #$19
    bne !+

    lda #$00
    sta _cursor_y  
!:

    // restore y-register 
    pla
    tay
    rts

}
#endif


// ------------------------------------------------------------
//
// Print the value in the accumulator as a hexadecimal string.
//
// ------------------------------------------------------------
#if ENABLE_PRINT
.namespace print {

print_hex:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr print_nibble
    
    pla
    and #$0f

print_nibble:
    cmp #$0a
    bcs print_letter

print_digit:
    ora #$30
    jmp !+

print_letter:
    clc
    sbc #$08

!:
    jsr print_acc
    rts

}
#endif


// ------------------------------------------------------------
//
// Helpers
//
// ------------------------------------------------------------
.macro print_acc() {
#if ENABLE_PRINT

    jsr print.print_acc

#endif
}

.macro print_acc__a8(a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_acc()

#endif
}

.macro print_acc__i8(i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_acc()

#endif
}

.macro print_x() {
#if ENABLE_PRINT

    pha
    txa
    print_acc()
    pla

#endif
}

.macro print_x__a8(a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_x()

#endif
}

.macro print_x__i8(i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_x()

#endif
}

.macro print_y() {
#if ENABLE_PRINT

    pha
    tya
    print_acc()
    pla

#endif
}

.macro print_y__a8(a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_y()

#endif
}

.macro print_y__i8(i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_y()

#endif
}

.macro print__i8(i8_val) {
#if ENABLE_PRINT

    pha
    lda #i8_val
    print_acc() 
    pla

#endif
}

.macro print__i8_a8(i8_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print__i8(i8_val)

#endif
}

.macro print__i8_i8(i8_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print__i8(i8_val)

#endif
}

.macro print__a8(a8_val) {
#if ENABLE_PRINT

    pha
    lda a8_val
    print_acc()
    pla

#endif
}

.macro print__a8_a8(a8_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print__a8(a8_val)

#endif
}

.macro print__a8_i8(a8_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print__a8(a8_val)

#endif
}

.macro print_string(str) {
#if ENABLE_PRINT

    pha 
    .for (var i = 0; i < str.size(); i++) {
        lda #str.charAt(i)
        print_acc()
    }
    pla

#endif
}

.macro print_string__a8(str, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_string(str)

#endif
}

.macro print_string__i8(str, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_string(str)

#endif
}

.macro print_hex() {
#if ENABLE_PRINT

    jsr print.print_hex

#endif
}

.macro print_hex__a8(a8_val) {
#if ENABLE_PRINT

    pha
    lda a8_val
    print_hex()
    pla

#endif
}

.macro print_hex__a8_a8(a8_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_hex__a8(a8_val)

#endif
}

.macro print_hex__a8_i8(a8_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_hex__a8(a8_val)

#endif
}

.macro print_hex__i8(i8_val) {
#if ENABLE_PRINT

    pha
    lda #i8_val
    print_hex()
    pla

#endif
}

.macro print_hex__i8_a8(i8_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_hex__i8(i8_val)

#endif
}

.macro print_hex__i8_i8(i8_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_hex__i8(i8_val)

#endif
}

.macro print_hex__a16(a16_val) {
#if ENABLE_PRINT

    print_hex__a8(a16_val + 1)
    print_hex__a8(a16_val)

#endif
}

.macro print_hex__a16_a8(a16_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_hex__a16(a16_val)

#endif
}

.macro print_hex__a16_i8(a16_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_hex__a16(a16_val)

#endif
}

.macro print_hex__i16(i16_val) {
#if ENABLE_PRINT

    print_hex__i8(i16_val >> 8)
    print_hex__i8(i16_val & $ff)

#endif
}

.macro print_hex__i16_a8(i16_val, a8_x, a8_y) {
#if ENABLE_PRINT

    set_cursor__a8(a8_x, a8_y)
    print_hex__i16(i16_val)

#endif
}

.macro print_hex__i16_i8(i16_val, i8_x, i8_y) {
#if ENABLE_PRINT

    set_cursor__i8(i8_x, i8_y)
    print_hex__i16(i16_val)

#endif
}


// ------------------------------------------------------------
//
// Accessors
//
// ------------------------------------------------------------
.macro set_cursor__a8(a8_x, a8_y) { 
#if ENABLE_PRINT

    pha
    lda a8_x
    sta_cursor_x()
    lda a8_y
    sta_cursor_y()
    pla

#endif
}

.macro set_cursor__i8(i8_x, i8_y) { 
#if ENABLE_PRINT

    pha
    lda #i8_x
    sta_cursor_x()
    lda #i8_y
    sta_cursor_y()
    pla

#endif
}

.macro sta_cursor_x() {
#if ENABLE_PRINT

    sta print._cursor_x

#endif
}

.macro stx_cursor_x() {
#if ENABLE_PRINT

    stx print._cursor_x

#endif
}

.macro sty_cursor_x() {
#if ENABLE_PRINT

    sty print._cursor_x

#endif
}

.macro sta_cursor_y() {
#if ENABLE_PRINT

    sta print._cursor_y

#endif
}

.macro stx_cursor_y() {
#if ENABLE_PRINT

    stx print._cursor_y

#endif
}

.macro sty_cursor_y() {
#if ENABLE_PRINT

    sty print._cursor_y

#endif
}

BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

.label CURSOR__X = 0
.label CURSOR__Y = 1
.label CURSOR__NUM_BYTES = 2

.var   CURSOR__FONT = @"@abcdefghijklmnopqrstuvwxyz[£]↑← !\"#$%&'()*+,-./0123456789:;<=>?"
.label CURSOR__CHAR0 = $20
.label CURSOR__CHAR1 = $80

*=$4000
_cursor:
    alloc_cursor()

startup:
    do_startup()
    clear_screen($20)

    set_cursor_x__i8(_cursor, 0)
    set_cursor_y__i8(_cursor, 2)
main:
    .for (var i = 0; i < 6; i++) {
    wait_vblank()
    print_string(_cursor, "." + i)
    }
    jmp main




.macro set_font(str) 
{
    .eval CURSOR__FONT = str
}

.macro alloc_cursor()
{
    .fill CURSOR__NUM_BYTES, $00
}

.macro tick_cursor()
{

}

.macro print_string(this, str)
{
    .for (var i = 0; i < str.size(); i++) {
        print_char__i8(this, str.charAt(i))
    }
}

.macro print_char__i8(this, i8)
{
    lda #index_of(i8, CURSOR__FONT)
    ldx a8__get_cursor_y(this)
    ldy a8__get_cursor_x(this)
    jsr cursor.print_char_xya

    iny
    cpy #$28
    bne store_x
    ldy #$00
    inc C64__COLOR_BORDER
    ldx a8__get_cursor_y(this)
    inx
    cpx #$19
    bne store_y
    ldx #$00
store_y:
    stx_cursor_y(this)
store_x:
    sty_cursor_x(this)
}

.label CURSOR__SCREEN_ADR = C64__ZEROP_FREE + 0 //..1

.namespace cursor 
{
print_char_xya:
    pha
    set__i16(CURSOR__SCREEN_ADR, C64__SCREEN_DATA)
    cpx #$00
    beq !++
!:  add__a16_i8(CURSOR__SCREEN_ADR, $28)
    dex
    bne !-
!:  
    pla   
    sta (CURSOR__SCREEN_ADR), y
    rts
}


// ------------------------------------------------------------
//
// Accessors
//
// ------------------------------------------------------------
.macro set_cursor_x__i8(this, i8)
{
    pha
    lda #i8
    sta_cursor_x(this)
    pla
}

.macro set_cursor_x__a8(this, a8)
{
    pha
    lda a8
    sta_cursor_x(this)
    pla
}

.macro set_cursor_y__i8(this, i8)
{
    pha
    lda #i8
    sta_cursor_y(this)
    pla
}

.macro set_cursor_y__a8(this, a8)
{
    pha
    lda a8
    sta_cursor_y(this)
    pla
}

.macro sta_cursor_x(this)
{
    sta a8__get_cursor_x(this)
}

.macro sta_cursor_y(this) 
{
    sta a8__get_cursor_y(this)
}

.macro stx_cursor_x(this)
{
    stx a8__get_cursor_x(this)
}

.macro stx_cursor_y(this) 
{
    stx a8__get_cursor_y(this)
}

.macro sty_cursor_x(this)
{
    sty a8__get_cursor_x(this)
}

.macro sty_cursor_y(this) 
{
    sty a8__get_cursor_y(this)
}

.function a8__get_cursor_x(this)
{
    .return this + CURSOR__X
}

.function a8__get_cursor_y(this)
{
    .return this + CURSOR__Y
}


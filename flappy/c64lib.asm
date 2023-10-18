// ------------------------------------------------------------
//
// C64 constants
//
// ------------------------------------------------------------
.label ADR_SCREEN_DAT = $0400
.label ADR_SCREEN_COL = $d800
.label ADR_COLOR      = $0286


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
    lda i8_val
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
    lda $d012
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda $d012
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
    sta ADR_SCREEN_DAT, x
    sta ADR_SCREEN_DAT + $0100, x
    sta ADR_SCREEN_DAT + $0200, x
    sta ADR_SCREEN_DAT + $0300, x
    inx
    bne !-
}

.macro clear_colors(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta ADR_SCREEN_COL, x
    sta ADR_SCREEN_COL + $0100, x
    sta ADR_SCREEN_COL + $0200, x
    sta ADR_SCREEN_COL + $0300, x
    inx
    bne !-  
}


// ------------------------------------------------------------
//
// Pseudocommands for repeating certain opcodes.
//
// ------------------------------------------------------------
.macro assert_immediate(arg) 
{
    .if (arg.getType() != AT_IMMEDIATE) {
        .error "The argument must be immediate!" 
    }
}

.pseudocommand asl x 
{
    assert_immediate(x)
    .for (var i = 0; i < x.getValue(); i++) {
        asl
    }
}

.pseudocommand lsr x 
{
    assert_immediate(x)
    .for (var i = 0; i < x.getValue(); i++) {
        lsr
    }
}

.pseudocommand rol x 
{
    assert_immediate(x)
    .for (var i = 0; i < x.getValue(); i++) {
        rol
    }
}

.pseudocommand ror x 
{
    assert_immediate(x)
    .for (var i = 0; i < x.getValue(); i++) {
        ror
    }
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
    sta ADR_SCREEN_DAT,x

    lda ADR_COLOR
    sta ADR_SCREEN_COL,x
    rts

} 
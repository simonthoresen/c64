.macro print_word(src, pos) {
    print_byte(src+1, pos)
    print_byte(src, pos+2)
}

.macro print_byte(src, pos) {
    lda src
    ldx #pos
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
    sta ADR_SCREEN,x
    rts

} 
// ------------------------------------------------------------
//
// Declare local variables.
//
// ------------------------------------------------------------
_num_ticks:   .byte $00
_num_vblanks: .byte $00


// ------------------------------------------------------------
//
// Helper macros to track screen refresh and game loop.
//
// ------------------------------------------------------------
.macro count_vblank()
{
    dec _num_vblanks
    bpl end // return if less than a second

    lda #$32
    cmp _num_ticks
    beq !+
    lda #RED
    jmp !++
!:
    lda #GREEN
!:
    sta C64__COLOR

    print_byte(_num_ticks, 38, 0)
    lda #$31
    sta _num_vblanks
    lda #$00
    sta _num_ticks

end:
}

.macro sync_tick(cnt)
{
    ldx #cnt
!:
    wait_vblank()
    dex
    bpl !-
    inc _num_ticks
}

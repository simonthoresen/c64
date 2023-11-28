BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

_sin:
    .fill 256, $32 + $5a + $5a * sin(toRadians((i * 2 * 360) / 256))

startup:
    clear_screen($20)

    lda #$00
    sta C64__SCREEN_CTRL1 // turn off screen
    sta C64__COLOR_BORDER

    ldy #$00
main:
    //wait_vline($0001)

top:
    ldy #$7a
    ldx #$00

loop:
!:  cpy C64__RASTER_LINE
    bne !-

    lda _colors, x
    sta C64__COLOR_BORDER

    inx
    cpx #$34
    beq top

    iny
    jmp loop


_colors:
    .byte $06,$06,$06,$0e,$06,$0e
    .byte $0e,$06,$0e,$0e,$0e,$03
    .byte $0e,$03,$03,$0e,$03,$03
    .byte $03,$01,$03,$01,$01,$03
    .byte $01,$01,$01,$03,$01,$01
    .byte $03,$01,$03,$03,$03,$0e
    .byte $03,$03,$0e,$03,$0e,$0e
    .byte $0e,$06,$0e,$0e,$06,$0e
    .byte $06,$06,$06,$00,$00,$00
    


fast_irq:
      sta _mya + 1
      stx _myx + 1
      sty _myy + 1

      lsr $d019    // as stated earlier this might fail only on exotic HW like c65 etc.
                   // lda #$ff sta $d019 is equally fast, but uses two more bytes and
                   // trashes A

_mya: lda #$00
_myx: ldx #$00
_myy: ldy #$00
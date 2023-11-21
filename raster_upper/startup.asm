BasicUpstart2(startup)
*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

_raster_upper:
    .byte $00

startup:
    enter_startup()
    //setup_irq($00, my_irq0)
    leave_startup()

main:
    lda C64__SCREEN_CTRL1
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$01
    sta C64__COLOR_BORDER
    inc C64__SCREEN_DATA
    jmp main

my_irq0:
    enter_irq()
    lda #$00
    sta _raster_upper
    setup_irq($0100, my_irq1)
    leave_irq()
    rti

my_irq1:
    enter_irq()
    lda #$01
    sta _raster_upper
    setup_irq($0001, my_irq0)
    leave_irq()
    rti

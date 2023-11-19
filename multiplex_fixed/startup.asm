BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

startup:
    do_startup()
    clear_screen($20)
    lda #$00
    sta C64__COLOR_BORDER
    sta C64__COLOR_BG
    
    .for (var i = 0; i < 8; i++) {
        lda #(DATA_BLOCK + 1 + i)
        sta C64__SPRITE_POINTERS + i
        lda #($18 + $18 * i)
        sta C64__SPRITE_POS + 0 + i * 2
        lda #$32
    	sta C64__SPRITE_POS + 1 + i * 2
        lda #($02 + i)
        sta C64__SPRITE_COLOR + i
    }
    lda #$00
	sta C64__SPRITE_POS_UPPER
    lda #$ff
    sta C64__SPRITE_ENABLED
    lda #$ff
    sta C64__SPRITE_COLORED
    lda #$00
    sta C64__SPRITE_COLOR1
    lda #$01
    sta C64__SPRITE_COLOR2   


//            BCC/BCS BEQ/BNE BMI/BPL
// acc = arg:  Carry,  Zero,  !Neg
// acc > arg:  Carry, !Zero,  !Neg
// acc < arg: !Carry, !Zero,   Neg


main:
    ldx #$00
!:
    .for (var i = 0; i < 11; i++) {
        lda #($30 + $16 * i)        
!:
        cmp C64__RASTER_LINE // 4 cycle
        bne !- // 4 cycle

        inc C64__COLOR_BORDER
        clc
        adc #$02
        .for (var j = 0; j < 8; j++) {
            sta C64__SPRITE_POS + j * 2 + 1
        }
        txa
        clc
        adc #($03 * i)
        and #$3f
        tay
        .for (var j = 0; j < 8; j++) {
            lda _sin, y
            sta C64__SPRITE_POS + j * 2 + 0
            tya
            clc
            adc #$03
            and #$3f
            tay
        }
        dec C64__COLOR_BORDER
    }
    inx
    cpx #$40
    beq !+
    jmp !-
!:
    jmp main

_sin:
    .fill 64, $18 + ($76 + $76 * sin(toRadians((i * 360) / 64)))

_text:
    .text "the quick brown fox jumps over the lazy dog "
    .const FONT = " abcdefghijklmnopqrstuvwxyz0123456789"

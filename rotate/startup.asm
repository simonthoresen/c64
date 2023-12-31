BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

startup:
    do_rotate()

    lda #DATA_BLOCK
    sta C64__SPRITE_POINTERS

    lda #$00
	sta C64__SPRITE_POS_UPPER

    lda #$18
	sta C64__SPRITE_POS
    lda #$32
	sta C64__SPRITE_POS + 1

    lda #$ff
    sta C64__SPRITE_ENABLED

main:
    lda #DATA_BLOCK
    sta C64__SPRITE_POINTERS
    ldx #$00
!:
    wait_vblank()
    inc C64__SPRITE_POINTERS
    inx
    cpx #30
    bne !-     
    jmp main

.macro do_rotate()
{
    .var src = List()
    .eval src.add("000000000000000000000000")
    .eval src.add("000000000000000000000000")
    .eval src.add("000000000000000000000000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000011111111111111100000")
    .eval src.add("000000000000000000000000")
    .eval src.add("000000000000000000000000")
    .eval src.add("000000000000000000000000")

    .var cx = 11
    .var cy = 10

    .for (var ra = 0; ra < 90; ra = ra + 3) {
        .var rm = RotationMatrix(0, 0, toRadians(-ra))
        .for (var dy = 0; dy < C64__SPRITE_H; dy++) {
            .var str = ".byte %"
            .for (var dx = 0; dx < C64__SPRITE_W; dx++) {
                .if (dx > 0 && mod(dx, 8) == 0) {
                    .eval str = str + ",%"
                }
                .var rv = rm * Vector(dx - cx, dy - cy, 0)
                .var sx = cx + round(rv.getX())
                .var sy = cy + round(rv.getY())
                .if (sx >= 0 && sx < C64__SPRITE_W && 
                    sy >= 0 && sy < C64__SPRITE_H) 
                {
                    .eval str = str + src.get(sy).charAt(sx)                
                }
                else
                {
                    .eval str = str + "0"
                }
            }
            .print str
        }
        .print ".byte $00"
    }
}

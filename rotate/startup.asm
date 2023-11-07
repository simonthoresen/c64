BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

.const C64__SPRITE_W = 24
.const C64__SPRITE_H = 21

.const ADR_DATA = $2000
.const ADR_DATA_64 = ADR_DATA/64
*=ADR_DATA "Data"
_sprite0: // 24 x 21
    .byte %00000000,%00000000,%00000000
    .byte %00000000,%00000000,%00000000
    .byte %00000000,%00000000,%00000000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11101111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00001111,%11111111,%11100000
    .byte %00000000,%00000000,%00000000
    .byte %00000000,%00000000,%00000000
    .byte %00000000,%00000000,%00000000
 	.byte $00
    .fill 64, $00

*=$4000 "Main Program"
startup:
    do_rotate()
    //rotate_sprite(_sprite0, _sprite0 + 64, 11, 10, 5)

    lda #ADR_DATA_64 + 0
    sta C64__SPRITE_POINTERS

    lda #ADR_DATA_64 + 1
    sta C64__SPRITE_POINTERS + 1

    lda #$00
	sta C64__SPRITE_POS_UPPER

    lda #$18
	sta C64__SPRITE_POS
    lda #$32
	sta C64__SPRITE_POS + 1

    lda #$38
	sta C64__SPRITE_POS + 2
    lda #$32
	sta C64__SPRITE_POS + 3

    lda #$ff
    sta C64__SPRITE_ENABLED
    
    jmp *

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

    .for (var ra = 0; ra <= 360; ra = ra + 10) {
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

.macro rotate_sprite(src, dst, cx, cy, rot)
{
    .var rm = RotationMatrix(0, 0, toRadians(rot))    
    .for (var sy = 0; sy < C64__SPRITE_H; sy++) {
        .for (var sx = 0; sx < C64__SPRITE_W; sx++) {
            .var dv = rm * Vector(sx - cx, sy - cy, 0)
            .var dx = cx + round(dv.getX())
            .var dy = cy + round(dv.getY())
            .if (dx >= 0 && dx < C64__SPRITE_W && 
                 dy >= 0 && dy < C64__SPRITE_H) 
            {
                copy_pixel(src, sx, sy, dst, dx, dy)
            }
        }
    }
}

.macro copy_pixel(src, sx, sy, dst, dx, dy) 
{
    .var src_idx = floor(sx / 8) + sy * 3
    .var src_msk = 1 << mod(sx, 8)
    .var dst_idx = floor(dx / 8) + dy * 3
    .var dst_msk = 1 << mod(dx, 8)

    .print("(" + sx + "," + sy + ") i:" + src_idx + " m:" + toBinaryString(src_msk, 8) + " -> " +
           "(" + dx + "," + dy + ") i:" + dst_idx + " m:" + toBinaryString(dst_msk, 8))

    lda src + src_idx
    and #src_msk
    cmp #$00
    beq no_pixel
set_pixel:
    lda dst + dst_idx
    ora #dst_msk
    sta dst + dst_idx
no_pixel:
}

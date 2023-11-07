BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

startup:
    do_rotate()
    //rotate_sprite(_sprite0, _sprite0 + 64, 11, 10, 5)

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
    cpx #$09
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

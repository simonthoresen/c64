BasicUpstart2(startup)

// ------------------------------------------------------------
//
// Constants
//
// ------------------------------------------------------------
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
.const FONT = " abcdefghijklmnopqrstuvwxyz0123456789"
.const TEXT = "012345678901234567890"
.const NUM_SPRITES = $18


// ------------------------------------------------------------
//
// Data
//
// ------------------------------------------------------------
*=ADR_DATA "Program Data"
#import "data.asm"


// ------------------------------------------------------------
//
// Variables
//
// ------------------------------------------------------------
.function path_x(i) {
    .return $18 + $94 + $94 * cos(toRadians((i * 1 * 360) / 256))
}
.function path_y(i) {
//    .return $32 + $5a + $5a * sin(toRadians((i * 3 * 360) / 256))
//    .return $40 + $50 + $50 * sin(toRadians((i * 3 * 360) / 256))
    .return $60 + $40 + $40 * sin(toRadians((i * 3 * 360) / 256))
}
_path_xl:
    .fill 256, path_x(i) & $ff
_path_xh:
    .fill 256, path_x(i) >> 8
_path_y:
    .fill 256, path_y(i)
_text:
    .fill TEXT.size(), index_of(TEXT.charAt(i), FONT)
    .byte $ff
_tick:
    .byte $00    
_vsprites_xl:
    .fill NUM_SPRITES, $00
_vsprites_xh:
    .fill NUM_SPRITES, $00
_vsprites_y:
    .fill NUM_SPRITES, $00
_vsprites_gfx:
    .fill NUM_SPRITES, DATA_BLOCK + index_of(TEXT.charAt(mod(i, TEXT.size())), FONT)
_ysort_vhead:
    .fill 256, $ff
_ysort_vnext:
    .fill NUM_SPRITES, $ff
_rsort_vsprite:
    .fill NUM_SPRITES, $ff
_rsort_ywait:
    .fill NUM_SPRITES, $00

BIT_MASK:
    .fill 8, (1 << i) & $ff
BIT_MASK_INV:
    .fill 8, (1 << i) ^ $ff


// ------------------------------------------------------------
//
// Program
//
// ------------------------------------------------------------
*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

startup:
    do_startup()
    clear_screen($20)
    jsr enable_psprites

main:
    lda #$00
    sta C64__COLOR_BORDER
    .for (var i = 0; i < 1; i++) {
        wait_vblank()
    }
    inc _tick

    inc C64__COLOR_BORDER    
    jsr tick_vsprites // white
    inc C64__COLOR_BORDER
    jsr ysort_sprites // red
    inc C64__COLOR_BORDER
    jsr rsort_sprites // cyan
    lda #$00
    sta C64__COLOR_BORDER
    jsr render_rsort

    jmp main



// ------------------------------------------------------------
//
// Rendering the sprites are done by running through the sort-
// table and positioning the next sprite as long as there are 
// free hardware sprites available. When we run out of sprites,
// we wait for the last raster-line of the oldest sprite so 
// that it can be reused.
//
// ------------------------------------------------------------
.label _vsprite_id  = C64__ZEROP_WORD1_LO
.label _psprite_id1 = C64__ZEROP_WORD1_HI
.label _psprite_id2 = C64__ZEROP_WORD2_LO
.label _rsprite_idx = C64__ZEROP_WORD2_HI

_psprites_done:
    .fill 8, $00

render_rsort:
{
    lda #$00
    sta _psprite_id1
    sta _psprite_id2
    .for (var i = 0; i < 8; i++) {
        sta _psprites_done + i
    }
    sta _rsprite_idx

!:
    inc C64__COLOR_BORDER

    ldy _rsprite_idx
    lda _rsort_vsprite, y
    sta _vsprite_id
    jsr render_vsprite

    inc _rsprite_idx
    lda _rsprite_idx
    cmp #NUM_SPRITES
    bne !-

    rts
}

render_vsprite:
{
    inc _psprite_id1
    lda _psprite_id1
    and #$07
    sta _psprite_id1
    asl
    sta _psprite_id2

    ldx _psprite_id1
    lda _psprites_done, x
!:
    cmp C64__RASTER_LINE
    bpl !-

    // store x coord
    ldx _vsprite_id
    lda _vsprites_xl, x
    ldx _psprite_id2
    sta C64__SPRITE_POS + 0, x

    ldx _vsprite_id
    lda _vsprites_xh, x
    beq no_upper
upper_on:
    ldx _psprite_id1
    lda BIT_MASK, x
    ora C64__SPRITE_POS_UPPER
    sta C64__SPRITE_POS_UPPER
    jmp !+
no_upper:
    ldx _psprite_id1
    lda BIT_MASK_INV, x
    and C64__SPRITE_POS_UPPER
    sta C64__SPRITE_POS_UPPER
!:

    // store y coord
    ldx _vsprite_id
    lda _vsprites_y, x
    ldx _psprite_id2
    sta C64__SPRITE_POS + 1, x

    // register boundary y
    clc
    adc #$15
    ldx _psprite_id1
    sta _psprites_done, x

    // store gfx pointer
    ldx _vsprite_id
    lda _vsprites_gfx, x
    ldx _psprite_id1
    sta C64__SPRITE_POINTERS, x
    rts
}


// ------------------------------------------------------------
//
// Now sort the msprites by y-coord, and compute the necessary
// wait that should happen after rendering it for multiplexing
// to work.
//
// ------------------------------------------------------------
.label RSORT_IDX = C64__ZEROP_BYTE
rsort_sprites:
{
    ldy #$00
    sty RSORT_IDX
sort_y:
    // look for a sprite in the y-table
    lda _ysort_vhead, y
    cmp #$ff
    beq next_y
!:  
    // found one, insert in rsort list
    ldx RSORT_IDX
    inc RSORT_IDX
    sta _rsort_vsprite, x

    // borrow acc to compute ywait
    pha
    tya
    clc
    adc #$15
    sta _rsort_ywait, x
    pla

    // look for a next-sprite behind it
    tax
    lda _ysort_vnext, x
    cmp #$ff
    bne !- // found one, loop back

next_y:
    // no more sprites on this y, increment
    iny
    beq !+
    jmp sort_y
!:
    // all ys checked, return
    rts
}


// ------------------------------------------------------------
//
// Run through all virtual sprites in sequence and register 
// them in the y-sort table. If multiple sprites appear on the
// same y coordinate, use a linked-list to manage those.
//
// ------------------------------------------------------------
ysort_sprites:
{
    lda #$00
    sta _vsprite_id

sort_loop:
    ldx _vsprite_id
    lda #$ff
    sta _ysort_vnext, x

    ldy _vsprites_y, x
    lda _ysort_vhead, y // acc is cursor of linked-list
    cmp #$ff
    beq empty_row

not_empty:
    tax                 // transfer linked-list cursor from acc to x
    lda _ysort_vnext, x // read from linked-list using x
    cmp #$ff            // compare with no-sprite identifier
    bne not_empty       // loop until we found the tail

    lda _vsprite_id
    sta _ysort_vnext, x
    jmp continue

empty_row:
    txa
    sta _ysort_vhead, y

continue:
    inc _vsprite_id
    lda _vsprite_id
    cmp #NUM_SPRITES
    bne sort_loop
    rts
}

// ------------------------------------------------------------
//
// Calculate sprite x and y positions.
//
// ------------------------------------------------------------
.label PATH_IDX = C64__ZEROP_BYTE

tick_vsprites:
{
    lda _tick
    sta PATH_IDX

    ldx #$00
!:
    ldy _vsprites_y, x
    lda #$ff
    sta _ysort_vhead, y

    lda PATH_IDX
    adc #$fc
    sta PATH_IDX
    tay

    lda _path_xl, y
    sta _vsprites_xl, x
    lda _path_xh, y
    sta _vsprites_xh, x
    lda _path_y, y
    sta _vsprites_y, x
 
    inx
    cpx #NUM_SPRITES
    bne !-
    rts
}


// ------------------------------------------------------------
//
// Macros
//
// ------------------------------------------------------------
enable_psprites:
{
    lda #$00
    .for(var i = 0; i < 8; i++)  {
        sta C64__SPRITE_POS + i * 2 + 0
        sta C64__SPRITE_POS + i * 2 + 1
    }
    sta C64__SPRITE_POS_UPPER
    lda #$ff
    sta C64__SPRITE_ENABLED
    lda #$ff
    sta C64__SPRITE_COLORED
    lda #$02
    .for(var i = 0; i < 16; i++)  {
        sta C64__SPRITE_COLOR0 + i        
    }
    lda #$00
    sta C64__SPRITE_COLOR1
    lda #$01
    sta C64__SPRITE_COLOR2   
    rts
}

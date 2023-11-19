BasicUpstart2(startup)

// ------------------------------------------------------------
//
// Constants
//
// ------------------------------------------------------------
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
.const FONT = " abcdefghijklmnopqrstuvwxyz0123456789"
.const TEXT = "abcdefghijklmnopqrstuvwxyz"
.const NUM_SPRITES = $08


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
_sin_xl:
    .fill 256, ($18 + $94 + $94 * cos(toRadians((i * 360) / 256))) & $ff
_sin_xh:
    .fill 256, ($18 + $94 + $94 * cos(toRadians((i * 360) / 256))) >> 8
_sin_y:
    .fill 256, $32 + ($5a + $5a * sin(toRadians((i * 360) / 256)))
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
_ysort_mhead:
    .fill 256, $ff
_ysort_mnext:
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
    
    jsr tick_vsprites
    jsr clear_ysort_table
    jsr ysort_sprites
    jsr rsort_sprites
    jsr render_sprites

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
/*
_render_y:
    .byte $00
_vsprite_id:
    .byte $00
_psprite_id: 
    .byte $00
_psprite_id_x2: 
    .byte $00
*/
.label _render_y = C64__ZEROP_WORD1_LO
.label _vsprite_id = C64__ZEROP_WORD1_HI
.label _psprite_id = C64__ZEROP_WORD2_LO
.label _psprite_id_x2 = C64__ZEROP_WORD2_HI

render_sprites:
{
    lda #$00
    sta _render_y

render_y:
    // look for a sprite in the y-table
    ldx _render_y
    lda _ysort_mhead, x
    cmp #$ff
    beq next_y
!:  
    // found it, now render it
    sta _vsprite_id
    inc C64__COLOR_BORDER
    jsr render_vsprite

    // look for a next-sprite behind it
    ldx _vsprite_id
    lda _ysort_mnext, x
    cmp #$ff
    bne !- // found one, loop back

next_y:
    // no more sprites on this y, increment
    inc _render_y
    beq !+
    jmp render_y
!:
    // all ys checked, return
    rts
}


render_vsprite:
{
    inc _psprite_id
    and #$07
    sta _psprite_id
    asl
    sta _psprite_id_x2

/*
    lda _vsprite_id
    sta _psprite_id
    asl
    sta _psprite_id_x2
*/

    // store x coord
    ldx _vsprite_id
    lda _vsprites_xl, x
    ldx _psprite_id_x2
    sta C64__SPRITE_POS + 0, x

    ldx _vsprite_id
    lda _vsprites_xh, x
    cmp #$00
    beq no_upper
upper_on:
    ldx _psprite_id
    lda BIT_MASK, x
    ora C64__SPRITE_POS_UPPER
    sta C64__SPRITE_POS_UPPER
    jmp !+
no_upper:
    ldx _psprite_id
    lda BIT_MASK_INV, x
    and C64__SPRITE_POS_UPPER
    sta C64__SPRITE_POS_UPPER
!:

    // store y coord
    ldx _psprite_id_x2
    lda _render_y
    sta C64__SPRITE_POS + 1, x

    ldx _vsprite_id
    lda _vsprites_gfx, x
    ldx _psprite_id
    sta C64__SPRITE_POINTERS, x
    rts
}


// ------------------------------------------------------------
//
// Sprites are sorted by iterating through all sprites to 
// compute their updated y-position, and then registering their
// id in the sort-table.
//
// ------------------------------------------------------------
rsort_sprites:
{
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
    ldy _vsprites_y, x
    lda _ysort_mhead, y // acc is cursor of linked-list
    cmp #$ff
    beq empty_row

not_empty:
    tax                  // transfer linked-list cursor from acc to x
    lda _ysort_mnext, x // read from linked-list using x
    cmp #$ff             // compare with no-sprite identifier
    bne not_empty        // loop until we found the tail

    lda _vsprite_id
    sta _ysort_mnext, x
    jmp continue

empty_row:
    txa
    sta _ysort_mhead, y

continue:
    inc _vsprite_id
    lda _vsprite_id
    cmp #NUM_SPRITES
    bne sort_loop
    rts
}

// ------------------------------------------------------------
//
// The sort-table has one entry per y-position on the screen. 
// The entry in the table is the id of the first sprite to be
// rendered on that y-position. If there are multiple sprites
// on the same row, these are stored as a linked list that is
// indexed by the sprite id.
//
// ------------------------------------------------------------
clear_ysort_table:
{
    lda #$ff
    ldx #$00
!:
    sta _ysort_mhead, x
    sta _ysort_mnext, x
    inx
    cpx #NUM_SPRITES
    bne !-
!:
    sta _ysort_mhead, x
    inx
    bne !-
    rts
}

// ------------------------------------------------------------
//
// Calculate sprite x and y positions.
//
// ------------------------------------------------------------
tick_vsprites:
{
    ldx #$00
!:
    // do some silly math to find a sine-table index for x
    txa
    eor #$ff
    asl
    asl
    asl
    clc
    adc _tick
    tay
    lda _sin_xl, y
    sta _vsprites_xl, x
    lda _sin_xh, y
    sta _vsprites_xh, x

    // and similar but off-frequency lookup for y
    txa
    eor #$ff
    asl
    asl
    asl
    clc
    adc _tick
    adc _tick
    adc _tick
    tay
    lda _sin_y, y
    sta _vsprites_y, x
 
    // and repeat for each sprite
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

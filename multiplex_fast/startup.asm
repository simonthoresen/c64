BasicUpstart2(startup)

// This program can bug out if the time spent sorting sprites 
// does not align with the raster getting to reset back to the
// top of the screen. This is because the raster-line wraps
// just after the bottom border is hit. When we compute the 
// boundary-y of a psprite, it can wrap back to top of the 
// screen which the raster will suggest has already passed.

// ------------------------------------------------------------
//
// Constants
//
// ------------------------------------------------------------
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
.const FONT = " abcdefghijklmnopqrstuvwxyz0123456789"
.const TEXT = "0123456789"
.const NUM_SPRITES = $20


// ------------------------------------------------------------
//
// Data
//
// ------------------------------------------------------------
*=ADR_DATA "Program Data"
#import "data.asm"

BIT_MASK:
    .fill 8, (1 << i) & $ff
BIT_MASK_INV:
    .fill 8, (1 << i) ^ $ff


// ------------------------------------------------------------
//
// Variables
//
// ------------------------------------------------------------
.function path_x(i) {
    .return $18 + $94 + $94 * cos(toRadians((i * 1 * 360) / 256))
}
.function path_y(i) {
    .return $32 + $5a + $5a * sin(toRadians((i * 4 * 360) / 256))
}
_path_xl:
    .fill 256, path_x(i) & $ff
_path_xh:
    .fill 256, path_x(i) >> 8
_path_y:
    .fill 256, path_y(i)
_frame:
    .byte $00
_tick:
    .byte $1d
_vsprites_xl:
    .fill NUM_SPRITES, $00
_vsprites_xh:
    .fill NUM_SPRITES, $00
_vsprites_y:
    .fill NUM_SPRITES, $00
_vsprites_gfx:
    .fill NUM_SPRITES, DATA_BLOCK + index_of(TEXT.charAt(mod(i, TEXT.size())), FONT)

.label _path_idx = C64__ZEROP_FREE + $01
.label _vsprite_id  = C64__ZEROP_FREE + $02
.label _psprite_id1 = C64__ZEROP_FREE + $03
.label _psprite_id2 = C64__ZEROP_FREE + $04
.label _ysort_outer_i = C64__ZEROP_FREE + $05
.label _ysort_outer_v = C64__ZEROP_FREE + $06
.label _vsprites_ysort = $20 // ..NUM_SPRITES

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

    .for(var i = 0; i < NUM_SPRITES; i++) {
        lda #i
        sta _vsprites_ysort + i
    }
main:
    inc C64__COLOR_BORDER    
    jsr tick_vsprites // white
    inc C64__COLOR_BORDER
    jsr ysort_vsprites // red

    lda #$00
    sta C64__COLOR_BORDER
/*
    lda C64__SCREEN_CTRL1
    and #$80
    cmp #$80
    bne !+
    lda #$32
    cmp C64__RASTER_LINE
    bcc !+
*/
    wait_vtop()
!:
    inc _frame

    inc C64__COLOR_BORDER
    jsr render_vsprites // cyan

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
_psprites_done:
    .fill 8, $00

render_vsprites:
{
    lda #$00
    sta _psprite_id1
    sta _psprite_id2
    .for (var i = 0; i < 8; i++) {
        sta _psprites_done + i
    }

    ldy #$00
!:
    inc C64__COLOR_BORDER

    // retrieve id of next vsprite to render
    ldx _vsprites_ysort, y
    stx _vsprite_id

    // prep psprite identifiers for quick access
    inc _psprite_id1
    lda _psprite_id1
    and #$07
    sta _psprite_id1
    asl
    sta _psprite_id2

    // render vsprite as psprite
    jsr render_vsprite

    // next sprite
    iny
    cpy #NUM_SPRITES
    bne !-

    rts
}

// x holds sprite id to render
render_vsprite:
{
    ldx _psprite_id1
    lda _psprites_done, x
    cmp #$ff
    bne !+
    rts
!:
    cmp C64__RASTER_LINE
    bcs !-

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
    cmp #$15
    bcs !+
    lda #$ff
!:
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
// Sort all sprites using insert-sort algorithm according to
// their y-coordinate.
//
// ------------------------------------------------------------
ysort_vsprites:
{
    ldy #$01 // outer counter 1..NUM_SPRITES
outer:
    ldx _vsprites_ysort, y
    lda _vsprites_y, x
    sty _ysort_outer_i // save outer counter
    stx _ysort_outer_v // save outer vsprite id
inner:
    ldx _vsprites_ysort - 1, y 
    cmp _vsprites_y, x
    bcs insert
    stx _vsprites_ysort, y
    dey // y is insertion cursor
    bne inner
insert:
    ldx _ysort_outer_v // pull outer vsprite id
    stx _vsprites_ysort, y
    ldy _ysort_outer_i // pull outer counter
    iny
    cpy #NUM_SPRITES
    bne outer

    rts
}

// ------------------------------------------------------------
//
// Calculate sprite x and y positions.
//
// ------------------------------------------------------------
tick_vsprites:
{
//#define PAUSE
#if PAUSE
    jsr check_input
#else  
    inc _tick
#endif 

    lda _tick
    sta _path_idx

    ldx #$00
!:
    lda _path_idx
    clc
    adc #$fd
    sta _path_idx
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

check_input:
{
    lda #C64__JOY_LEFT
    bit C64__JOY1
    beq joy_left
    lda #C64__JOY_RIGHT
    bit C64__JOY1
    beq joy_right
    jmp !+
joy_left:
    dec _tick
    jmp !+
joy_right:
    inc _tick
!:
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

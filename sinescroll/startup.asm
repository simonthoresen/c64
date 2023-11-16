BasicUpstart2(startup)

// ------------------------------------------------------------
//
// Constants
//
// ------------------------------------------------------------
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
.const FONT = " abcdefghijklmnopqrstuvwxyz0123456789"
.const TEXT = "the quick brown fox jumps over the lazy dog "
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
_sin_x:
    .fill 256, $18 + ($76 + $76 * sin(toRadians((i * 360) / 256)))
_sin_y:
    .fill 256, $32 + ($5a + $5a * sin(toRadians((i * 360) / 256)))
_text:
    .fill TEXT.size(), index_of(TEXT.charAt(i), FONT)
    .byte $ff

_frame:
    .byte $00
    

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
    jsr enable_sprites

main:
    lda #$00
    sta C64__COLOR_BORDER
.for (var i = 0; i < 1; i++) {
    wait_vblank()
}
    lda #$02
    sta C64__COLOR_BORDER
    inc _frame

    jsr update_sprites_xy
    jsr clear_sort_table
    jsr sort_sprites
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
_sprite_idx: 
    .byte $00
_sprite_idx2: 
    .byte $00
_free_y: 
    .byte $00

render_sprites:
{
    lda #$00
    sta _sprite_idx
    sta _free_y

    ldy #$00 // current row in the sort-table
render_y:   
    lda _sort_ytable, y // x is sprite-id
    cmp #$ff
    beq next_y

    sta _sprite_idx
    asl
    sta _sprite_idx2

    //inc C64__COLOR_BG // debug

    // render sprite x at position y
    ldx _sprite_idx
    lda _sprites_x, x
    ldx _sprite_idx2
    sta C64__SPRITE_POS + 0, x

    // store y coord
    ldx _sprite_idx2
    tya
    sta C64__SPRITE_POS + 1, x

    ldx _sprite_idx
    txa

    clc
    adc #DATA_BLOCK + 1
    sta C64__SPRITE_POINTERS, x

    lda #$ff
    sta _free_y

next_y:
    iny
    beq render_done // y looped, we are done
    //cpy _free_y
    //bmi next_y // ignore y if we have no free sprite
    //print_byte(_free_y, 6, 3)
    jmp render_y

render_done:
    rts
}

// ------------------------------------------------------------
//
// Sprites are sorted by iterating through all sprites to 
// compute their updated y-position, and then registering their
// id in the sort-table.
//
// ------------------------------------------------------------
sort_sprites:
{
    ldx #$00 // x is sprite-id
sort_loop:
    // store the sprite-id in the sort-table
    ldy _sprites_y, x
    lda _sort_ytable, y
    cmp #$ff
    beq empty_row
not_empty:
    inc C64__COLOR_BG
    // TODO: implement
    jmp !+
empty_row:
    txa
    sta _sort_ytable, y
!:
    inx
    cpx #NUM_SPRITES
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
_sort_ytable:
    .fill 256, $00
_sort_xlinks:
    .fill 256, $00

clear_sort_table:
{
    lda #$ff
    ldx #$00
!:
    sta _sort_ytable, x
    sta _sort_xlinks, x
    inx
    bne !-
    rts
}

// ------------------------------------------------------------
//
// Calculate sprite x and y positions.
//
// ------------------------------------------------------------
_sprites_x:
    .fill 256, $00
_sprites_y:
    .fill 256, $00

update_sprites_xy:
{
    ldx #$00
!:
    // do some silly math to find a sine-table index for x
    txa
    asl
    asl
    asl
    clc
    adc _frame
    tay
    lda _sin_x, y
    sta _sprites_x, x

    // and similar but off-frequency lookup for y
    txa
    asl
    asl
    asl
    clc
    adc _frame
    adc _frame
    tay
    lda _sin_y, y
    sta _sprites_y, x
  
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
enable_sprites:
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

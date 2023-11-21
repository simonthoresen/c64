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
.const NUM_SPRITES = $20


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
_vsprites_xl:
    .fill NUM_SPRITES, $18 + i * 2
_vsprites_xh:
    .fill NUM_SPRITES, $00
_vsprites_y:
    .fill NUM_SPRITES, $32 + i * $20
_vsprites_gfx:
    .fill NUM_SPRITES, DATA_BLOCK + index_of(TEXT.charAt(mod(i, TEXT.size())), FONT)


// ------------------------------------------------------------
//
// Program
//
// ------------------------------------------------------------
*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

//.label _raster_upper = C64__ZEROP_FREE + $14
_raster_upper: 
    .byte $00

irq1:
    enter_irq()
    inc C64__COLOR_BORDER
/*    lda #$00
    sta _raster_upper
    setup_irq($00, irq_at0)*/
    leave_irq()
    rti

irq_at0:
    enter_irq()
    inc C64__COLOR_BORDER
/*    lda _raster_upper
    eor #$01
    sta C64__COLOR_BORDER
    sta _raster_upper
 */   leave_irq()
    rti

startup:
	enter_startup()
	setup_irq($00, irq1)
	leave_startup()
    jmp *

    enter_startup()
    setup_irq($fa, irq1)
    leave_startup()
    clear_screen($20)
    enable_psprites()
    fill_jtable()
    jmp *

main:
    lda #$00
    sta C64__COLOR_BORDER
    wait_vtop()
/*
    lda $00
!:
    cmp _raster_upper
    beq !- // wait for us to be in upper
!:
    cmp _raster_upper
    bne !- // wait for us to hit lower
*/
    lda #$00
    .for (var i = 0; i < 8; i++) {
        sta _psprites_yfree + i
    }
    sta _psprites_off
    sta _cursor
    .for (var i = 0; i < NUM_SPRITES; i++) {
        inc C64__COLOR_BORDER
        ldx #i
        ldy #mod(i, 1)
        jsr render_vsprite
    }
    jmp main

.macro wait_vtop() 
{    
    lda #$ff // can only happen on upper half
!:  cmp C64__RASTER_LINE
    bne !-
    lda #$01 // wait for first wrap
!:  cmp C64__RASTER_LINE
    bne !-
    lda #$00 // wait for top of screen
!:  cmp C64__RASTER_LINE
    bne !-
}


.label _render_jtable_lo = C64__ZEROP_FREE + $00 // ..$08
.label _render_jtable_hi = C64__ZEROP_FREE + $08 // ..$0f
.macro fill_jtable() 
{
    add_jrow(render_vsprite0, 0)
    add_jrow(render_vsprite1, 1)
    add_jrow(render_vsprite2, 2)
    add_jrow(render_vsprite3, 3)
    add_jrow(render_vsprite4, 4)
    add_jrow(render_vsprite5, 5)
    add_jrow(render_vsprite6, 6)
    add_jrow(render_vsprite7, 7)
}
.macro add_jrow(label, row)
{
    lda #<label
    sta _render_jtable_lo + row
    lda #>label
    sta _render_jtable_hi + row
}

// x is vsprite id, y is psprite id
.label _render_jmp_lo = C64__ZEROP_FREE + $10
.label _render_jmp_hi = C64__ZEROP_FREE + $11
render_vsprite:
    lda _render_jtable_lo, y
    sta _render_jmp_lo
    lda _render_jtable_hi, y
    sta _render_jmp_hi
    jmp (_render_jmp_lo)
render_vsprite0: 
    render_vsprite(0)
render_vsprite1: 
    render_vsprite(1)
render_vsprite2: 
    render_vsprite(2)
render_vsprite3: 
    render_vsprite(3)
render_vsprite4: 
    render_vsprite(4)
render_vsprite5: 
    render_vsprite(5)
render_vsprite6: 
    render_vsprite(6)
render_vsprite7: 
    render_vsprite(7)
    rts

// x as vsprite id, y is free
.label _psprites_yfree = C64__ZEROP_LAST - $40 // last 64 bytes on zeropage
.label _psprites_off = C64__ZEROP_FREE + $12
.label _cursor = C64__ZEROP_FREE + $13

.macro render_vsprite(psprite)
{
    lda _psprites_off
    and #(1 << psprite)
    cmp #$00
    beq !+
    rts
!:
    lda _psprites_yfree + psprite
    cmp #$ff
    bne !+
    rts
!:
    cmp C64__RASTER_LINE
    bcs !-

    // store x coord
    lda _vsprites_xl, x
    sta C64__SPRITE_POS + psprite * 2 + 0

    lda _vsprites_xh, x
    beq no_upper
upper_on:
    lda #(1 << psprite)
    ora C64__SPRITE_POS_UPPER
    jmp !+
no_upper:
    lda #(1 << psprite) ^ $ff
    and C64__SPRITE_POS_UPPER
!:
    sta C64__SPRITE_POS_UPPER

    // store y coord
    lda _vsprites_y, x
    sta C64__SPRITE_POS + psprite * 2 + 1

    // register boundary y
#if DEBUG
    pha
    txa
    pha
    lda _vsprites_y, x
    ldx _cursor
    jsr print.byte
    inc _cursor
    inc _cursor
    inc _cursor
    pla
    tax
    pla
#endif
    clc
    adc #$15
    cmp #$15
    bcs !+ // equal or larger
    lda #(1 << psprite)
    ora _psprites_off
    sta _psprites_off
/*
    txa
    pha
    lda _psprites_off
    ldx #$10
    jsr print.byte
    pla
    tax
*/  
    lda #$ff
!:
    sta _psprites_yfree + psprite
#if DEBUG
    pha
    txa
    pha
    lda _psprites_yfree + psprite
    ldx _cursor
    jsr print.byte
    inc _cursor
    inc _cursor
    inc _cursor
    inc _cursor
    pla
    tax
    pla
#endif

    // store gfx pointer
    lda _vsprites_gfx, x
    sta C64__SPRITE_POINTERS + psprite
    rts
}

// ------------------------------------------------------------
//
// Macros
//
// ------------------------------------------------------------
.macro enable_psprites()
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
}

// object anim
// idea: define in this header how many bytes are needed
//       for an anim. create a const for it. then the 
//		 use of the lib will have to reserve those bytes
// this library then creates functions to manipulate aspects
// of the anim, with a pointer to the anim object
/*.const ADR_SPRITE_POINTERS		= ADR_SCREEN + $03f8
.const ADR_SPRITE_POSX_BIT9     = $d010

.const ADR_SPR0_COLOR  		    = $d027
.const ADR_SPR0_POSX 			= $d000
.const ADR_SPR0_POSY 			= $d001
.const ADR_SPR0_POINTER			= ADR_SPRITE_POINTERS + 0
*/

.enum {
	_ANIM_REEL = 0,
	_ANIM_FRAME = 2,
	_ANIM_WAIT_MAX,
	_ANIM_WAIT_VAL,
	_ANIM_DATA_BLOCK,

	_ANIM_SIZE
}

.macro alloc_sprite()
{
	.fill _ANIM_SIZE, $00
}

.macro set_anim_wait(adr_sprite, val) 
{
	lda #val
	sta adr_sprite + _ANIM_WAIT_MAX
	sta adr_sprite + _ANIM_WAIT_VAL
}

.macro set_anim_reel16(adr_sprite, adr_reel)
{
	cmp_val16(adr_reel, adr_sprite + _ANIM_REEL)
	beq no_change
    cpy_val16(adr_reel, adr_sprite + _ANIM_REEL)
    lda #$00
    sta adr_sprite + _ANIM_FRAME
no_change:	
}

.macro set_anim_data_block(adr_sprite, val) 
{
	lda #val
	sta adr_sprite + _ANIM_DATA_BLOCK
}

.macro draw_sprite(adr_sprite, sprite_id)
{
    cpy_adr16(adr_sprite + _ANIM_REEL, ADR_IIDX)
    ldy adr_sprite + _ANIM_FRAME
    lda (ADR_IIDX),y
    clc
    adc adr_sprite + _ANIM_DATA_BLOCK
    sta ADR_SPRITE_POINTERS + sprite_id
}

.macro inc_anim(adr_sprite)
{
	dec adr_sprite + _ANIM_WAIT_VAL
	bpl end // branch if dec did not wrap
	lda adr_sprite + _ANIM_WAIT_MAX
	sta adr_sprite + _ANIM_WAIT_VAL
    inc adr_sprite + _ANIM_FRAME

    cpy_adr16(adr_sprite + _ANIM_REEL, ADR_IIDX)
    ldy adr_sprite + _ANIM_FRAME
    lda (ADR_IIDX),y
    cmp #$ff // end of reel
    bne end
    ldy #$00
    sty adr_sprite + _ANIM_FRAME

end:
}

.macro update_sprite(adr_sprite)
{
	inc_anim(adr_sprite)
}

.macro set_sprite_screen_x16(sprite_id, adr16)
{
    lda adr16
    sta $d000 + sprite_id

    lda $d010 // sprite x upper
    ldx adr16 + 1
    cpx #$00
    beq !+
    ora #%00000001
    jmp !++
!:
    and #%11111110
!:
    sta $d010
}

.macro set_sprite_screen_y(sprite_id, adr8)
{
	lda adr8
	sta $d001 + sprite_id
}

.macro set_sprite_col(sprite_id, val)
{
	lda #val
	sta $d027 + sprite_id
}

.macro set_sprite_col1(val)
{
	lda #val
	sta $d025
}

.macro set_sprite_col2(val)
{
	lda #val
	sta $d026
}

.macro enable_mcol_sprites(val)
{
	enable_sprites(val)
	lda #val
	ora $d01c
	sta $d01c
}

.macro enable_mono_sprites(val)
{
	enable_sprites(val)
	lda $ff
	eor #val
	and $d01c
	sta $d01c
}

.macro enable_sprites(val)
{
	lda #val
	ora $d015
	sta $d015
}

.macro disable_sprites(val) 
{
	lda $ff
	eor #val
	and $d015
	sta $d015	
}


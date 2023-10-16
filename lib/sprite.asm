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

.macro set_sprite_screen_x16(sprite_id, mem16)
{
    lda mem16
    sta $d000

    lda $d010 // sprite x upper
    ldx mem16 + 1
    cpx #$00
    beq !+
    ora #%00000001
    jmp !++
!:
    and #%11111110
!:
    sta $d010
}

.macro set_sprite_screen_y(sprite_id, mem8)
{
	lda mem8
	sta $d001 + sprite_id
}

.macro set_sprite_col(sprite_id, val)
{
	lda #val
	sta $d027 + sprite_id
}

.macro set_sprites_mcols(val0, val1)
{
	lda #val0
	sta $d025
	lda #val1
	sta $d026
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

.macro enable_sprites_mcol(val)
{
	lda #val
	ora $d01c
	sta $d01c
}

.macro disable_sprites_mcol(val)
{
	lda $ff
	eor #val
	and $d01c
	sta $d01c
}

.macro set_anim_speed(obj, speed) 
{

}

.macro set_anim_reel(obj, reel)
{

}


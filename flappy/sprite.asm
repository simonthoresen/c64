// ------------------------------------------------------------
//
// Object fields
//
// ------------------------------------------------------------
.enum {
	SPRITE__ID = 0,
	SPRITE__POS_X,
	SPRITE__POS_Y = SPRITE__POS_X + 2,
	SPRITE__ACTUAL_VEL_X = SPRITE__POS_Y + 2,
	SPRITE__ACTUAL_VEL_Y,
	SPRITE__TARGET_VEL_X,
	SPRITE__TARGET_VEL_Y,

	SPRITE__ANIM,
	SPRITE__ANIM_TPF = SPRITE__ANIM + 2,
	SPRITE__FRAME,
	SPRITE__TICK,

	SPRITE__NUM_BYTES
}


// ------------------------------------------------------------
//
// Object methods
//
// ------------------------------------------------------------
.macro alloc_sprite()
{
	.fill SPRITE__NUM_BYTES, $00
}

.macro show_sprite(this)
{

}


// ------------------------------------------------------------
//
// Static methods
//
// ------------------------------------------------------------
// e.g., set_sprite_mcols
.macro set_sprite_screen_x__a16(sprite_id, adr16)
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

.macro set_sprite_screen_y__a8(sprite_id, adr8)
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


// ------------------------------------------------------------
//
// Accessors
//
// ------------------------------------------------------------
.macro set_sprite_id__a8(this, a8)
{
	set__a8(a8__get_sprite_id(this), a8)
}

.macro set_sprite_id__i8(this, i8)
{
	set__i8(a8__get_sprite_id(this), i8)
}

.function a8__get_sprite_id(this)
{
	.return this + SPRITE__ID
}

.macro set_sprite_pos__a16(this, a16_x, a16_y)
{
	set_sprite_pos_x__a16(this, a16_x)
	set_sprite_pos_y__a16(this, a16_y)
}

.macro set_sprite_pos__i16(this, i16_x, i16_y)
{
	set_sprite_pos_x__i16(this, i16_x)
	set_sprite_pos_y__i16(this, i16_y)
}

.macro set_sprite_pos_x__a16(this, a16)
{
	set__a16(a16__get_sprite_pos_x(this), a16)
}

.macro set_sprite_pos_x__i16(this, i16)
{
	set__i16(a16__get_sprite_pos_x(this), i16)
}

.function a16__get_sprite_pos_x(this)
{
	.return this + SPRITE__POS_X
}

.macro set_sprite_pos_y__a16(this, a16)
{
	set__a16(a16__get_sprite_pos_y(this), a16)
}

.macro set_sprite_pos_y__i16(this, i16)
{
	set__i16(a16__get_sprite_pos_y(this), i16)
}

.function a16__get_sprite_pos_y(this)
{
	.return this + SPRITE__POS_Y
}

.macro set_sprite_actual_vel_x__a8s(this, a8s)
{
	set__a8(a8s__get_sprite_actual_vel_x(this), a8s)
}

.macro set_sprite_actual_vel_x__i8s(this, i8s)
{
	set__i8(a8s__get_sprite_actual_vel_x(this), i8s)
}

.function a8s__get_sprite_actual_vel_x(this)
{
	.return this + SPRITE__ACTUAL_VEL_X
}

.macro set_sprite_actual_vel_y__a8s(this, a8s)
{
	set__a8(a8s__get_sprite_actual_vel_y(this), a8s)
}

.macro set_sprite_actual_vel_y__i8s(this, i8s)
{
	set__i8(a8s__get_sprite_actual_vel_y(this), i8s)
}

.function a8s__get_sprite_actual_vel_y(this)
{
	.return this + SPRITE__ACTUAL_VEL_Y
}

.macro set_sprite_target_vel_x__a8s(this, a8s)
{
	set__a8(a8s__get_sprite_target_vel_x(this), a8s)
}

.macro set_sprite_target_vel_x__i8s(this, i8s)
{
	set__i8(a8s__get_sprite_target_vel_x(this), i8s)
}

.function a8s__get_sprite_target_vel_x(this)
{
	.return this + SPRITE__TARGET_VEL_X
}

.macro set_sprite_target_vel_y__a8s(this, a8s)
{
	set__a8(a8s__get_sprite_target_vel_y(this), a8s)
}

.macro set_sprite_target_vel_y__i8s(this, i8s)
{
	set__i8(a8s__get_sprite_target_vel_y(this), i8s)
}

.function a8s__get_sprite_target_vel_y(this)
{
	.return this + SPRITE__TARGET_VEL_Y
}

.macro set_sprite_anim__i16(this, i16)
{
	set__i16(a16__get_sprite_anim(this), i16)
}

.macro set_sprite_anim__a16(this, a16)
{
	set__a16(a16__get_sprite_anim(this), a16)
}

.function a16__get_sprite_anim(this)
{
	.return this + SPRITE__ANIM
}

.macro set_sprite_anim_tpf__a8(this, a8)
{
	set__a8(a8__get_sprite_anim_tpf(this), a8)
}

.macro set_sprite_anim_tpf__i8(this, i8)
{
	set__i8(a8__get_sprite_anim_tpf(this), i8)
}

.function a8__get_sprite_anim_tpf(this)
{
	.return this + SPRITE__ANIM_TPF
}

.macro set_sprite_frame__a8(this, a8)
{
	set__a8(a8__get_sprite_frame(this), a8)
}

.macro set_sprite_frame__i8(this, i8)
{
	set__i8(a8__get_sprite_frame(this), i8)
}

.function a8__get_sprite_frame(this)
{
	.return this + SPRITE__FRAME
}

.macro set_sprite_tick__a8(this, a8)
{
	set__a8(a8__get_sprite_tick(this), a8)
}

.macro set_sprite_tick__i8(this, i8)
{
	set__i8(a8__get_sprite_tick(this), i8)
}

.function a8__get_sprite_tick(this)
{
	.return this + SPRITE__TICK
}


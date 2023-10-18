// ------------------------------------------------------------
//
// Object fields
//
// ------------------------------------------------------------
.enum {
	_POS_X = 0,
	_POS_Y = _POS_X + 2,
	_ACTUAL_VEL_X = _POS_Y + 2,
	_ACTUAL_VEL_Y,
	_TARGET_VEL_X,
	_TARGET_VEL_Y,

	_ANIM,
	_ANIM_TPF = _ANIM + 2,
	_FRAME,
	_TICK,

	_SPRITE_SIZE
}

.macro alloc_sprite()
{
	.fill _SPRITE_SIZE, $00
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

.macro set_sprite_pos_y__a16(this, a16)
{
	set__a16(a16__get_sprite_pos_y(this), a16)
}

.macro set_sprite_pos_y__i16(this, i16)
{
	set__i16(a16__get_sprite_pos_y(this), i16)
}

.function a16__get_sprite_pos_x(this)
{
	.return this + _POS_X
}

.function a16__get_sprite_pos_y(this)
{
	.return this + _POS_Y
}

.function a8s__get_sprite_actual_vel_x(this)
{
	.return this + _ACTUAL_VEL_X
}

.function a8s__get_sprite_actual_vel_y(this)
{
	.return this + _ACTUAL_VEL_Y
}

.function a8s__get_sprite_target_vel_x(this)
{
	.return this + _TARGET_VEL_X
}

.function a8s__get_sprite_target_vel_y(this)
{
	.return this + _TARGET_VEL_Y
}

.function a16__get_sprite_anim(this)
{
	.return this + _ANIM
}

.function a8__get_sprite_anim_tpf(this)
{
	.return this + _ANIM_TPF
}

.function a8__get_sprite_frame(this)
{
	.return this + _FRAME
}

.function a8__get_sprite_tick(this)
{
	.return this + _TICK
}


// ------------------------------------------------------------
//
// Object methods
//
// ------------------------------------------------------------


// ------------------------------------------------------------
//
// Static methods
//
// ------------------------------------------------------------
// e.g., set_sprite_mcols

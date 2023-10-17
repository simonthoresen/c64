// object movement contains
.enum {
	_POS_X = 0,
	_POS_Y = 2,
	_VEL_X = 4,
	_VEL_X_TARGET,
	_VEL_Y,
	_VEL_Y_TARGET,

	_OBJECT_SIZE
}

.macro alloc_obj()
{
	.fill _OBJECT_SIZE, $00
}

.macro tick(this)
{
	check_vel_x:
		lda this + _VEL_X_TARGET
		cmp this + _VEL_X
		bpl inc_vel_x
		beq check_vel_y
	dec_vel_x:
		dec this + _VEL_X
		jmp check_vel_y
	inc_vel_x:
		inc this + _VEL_X
		// fall through 

	check_vel_y:
		lda this + _VEL_Y_TARGET
		cmp this + _VEL_Y
		bpl inc_vel_y
		beq move
	dec_vel_y:
		dec this + _VEL_Y
		jmp move
	inc_vel_y:
		inc this + _VEL_Y
		// fall through 

	move:
		add__a8s(this + _POS_X, this + _VEL_X)
		add__a8s(this + _POS_Y, this + _VEL_Y)
}

.macro set_pos_x__i16u(this, val16)
{
	set__i16u(this + _POS_X, val16)
}

.macro set_pos_y__i16u(this, val16)
{
	set__i16u(this + _POS_Y, val16)
}

.macro set_vel_x_target__i16u(this, val16)
{
	set__i16u(this + _VEL_X_TARGET, val16)
}

.macro set_vel_y_target__i16u(this, val16)
{
	set__i16u(get_vel_y_target__a16u(this), val16)
}


// ------------------------------------------------------------
//
// Static helper functions.
//
// ------------------------------------------------------------

.macro set__i8u(dst8, i8u)
{
	lda #i8u
	sta dst8
}

.macro set__i16u(dst16, i16u)
{
	lda #<i16u
	sta dst16
	lda #>i16u
	sta dst16 + 1
}

.function get_vel_y_target__a16u(this)
{
	.return this + _POS_X
}

.macro get_screen_y__a16u(obj)
{

}
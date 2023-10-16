// object movement contains
.const _POS_X = 0
.const _POS_Y = 2
.const _VEL_X = 3
.const _VEL_Y = 4
.const _TARGET_X = 5
.const _TARGET_Y = 6

.const _MOVE_SIZE = 7

.macro alloc_move()
{
	.fill _MOVE_SIZE, $00
}

.macro init_move(obj)
{
	set_pos_x(obj, $0000)
/*	set_pos_y(obj, $0000)
	set_vel_x(obj, $0000)
	set_vel_y(obj, $0000)
	set_target_x(obj, $0000)
	set_target_y(obj, $0000)*/
}

.macro set_pos_x(obj, val16)
{
	lda <val16
	sta obj + _POS_X + 0

	lda >val16
	sta obj + _POS_X + 1
}

.macro set_vel(obj, val8)
{

}

.macro update(obj) 
{

}

.macro get_screen_x(obj)
{

}

.macro get_screen_y(obj)
{

}
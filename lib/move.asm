// object movement contains
.filenamespace obj

.const IDX_POS_X = 0
.const IDX_POS_Y = 2
.const IDX_VEL_X = 3
.const IDX_VEL_Y = 4
.const IDX_TARGET_X = 5
.const IDX_TARGET_Y = 6

.macro @init_move(obj)
{
	set_pos_x(obj, $0000)

}

.macro set_pos_x(obj, val16)
{
	lda <val16
	sta obj + IDX_POS_X + 0

	lda >val16
	sta obj + IDX_POS_X + 1
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
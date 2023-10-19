// ------------------------------------------------------------
//
// Object fields
//
// ------------------------------------------------------------
.label SPRITE__ID = 0
.label SPRITE__ID_MASK = 1
.label SPRITE__POS_X = 2
.label SPRITE__POS_Y = 4
.label SPRITE__ACTUAL_VEL_X = 6
.label SPRITE__ACTUAL_VEL_Y = 7
.label SPRITE__TARGET_VEL_X = 8
.label SPRITE__TARGET_VEL_Y = 9
.label SPRITE__COLOR = 10
.label SPRITE__COLORED = 11
.label SPRITE__ANIM = 12
.label SPRITE__ANIM_TPF = 14
.label SPRITE__FRAME = 15
.label SPRITE__TICK = 16
.label SPRITE__NUM_BYTES = 17


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
	lda a8__get_sprite_color(this)
	ldx a8__get_sprite_id(this)
	sta C64__SPRITE_COLOR

	position_sprite(this)
	reference_frame(this)

	print_byte(a8__get_sprite_colored(this), 0, 3)

	lda a8__get_sprite_colored(this)
	cmp #$00
	beq no_col
	lda a8__get_sprite_id_mask(this)
	ora C64__SPRITE_COLORED // enable
	jmp !+
no_col:
	lda #$ff
	eor a8__get_sprite_id_mask(this)
	and C64__SPRITE_COLORED
!:
	sta C64__SPRITE_COLORED

	lda a8__get_sprite_id_mask(this)
	ora C64__SPRITE_ENABLED
	sta C64__SPRITE_ENABLED
}

.macro hide_sprite(this)
{
	lda #$ff
	eor a8__get_sprite_id_mask(this)
	and C64__SPRITE_ENABLED
	sta C64__SPRITE_ENABLED
}

.macro position_sprite(this)
{
	lda a8__get_sprite_id(this)
	asl
	tax


	// position x
	lda a8__get_sprite_pos_x_lo(this)
	lsr
	lsr
	lsr
	lsr
	sta $d000,x // C64_SPRITE_POS

	lda a8__get_sprite_pos_x_hi(this)
	asl
	asl
	asl
	asl
	ora $d000,x
	sta $d000,x

	lda a8__get_sprite_pos_x_hi(this)
	cmp #$10
	bcs !+
	lda $ff // invert id mask to unset upper
	eor a8__get_sprite_id_mask(this) 
	and $d010 
	jmp !++
!:
	lda $d010
	ora a8__get_sprite_id_mask(this) // set bit
!:
	sta $d010 // C64_SPRITE_POS_UPPER


	// position y
	lda a8__get_sprite_pos_y_lo(this)
	lsr
	lsr
	lsr
	lsr
	sta $d001,x // C64_SPRITE_POS
	lda a8__get_sprite_pos_y_hi(this)
	asl
	asl
	asl
	asl
	ora $d001,x
	sta $d001,x
}

.macro reference_frame(this)
{
	ldx a8__get_sprite_id(this)
	lda #DATA_BLOCK

	// todo: add anim

	sta C64__SPRITE_POINTERS, x
}

.macro tick_sprite(this)
{

}


// ------------------------------------------------------------
//
// Static methods
//
// ------------------------------------------------------------
.macro set_sprite_color_1(val)
{
	lda #val
	sta C64__SPRITE_COLOR_1
}

.macro set_sprite_color_2(val)
{
	lda #val
	sta C64__SPRITE_COLOR_2
}



// ------------------------------------------------------------
//
// Accessors
//
// ------------------------------------------------------------
.macro set_sprite_id__i8(this, i8)
{
	set__i8(a8__get_sprite_id(this), i8)
	set__i8(a8__get_sprite_id_mask(this), 1 << i8)
}

.function a8__get_sprite_id(this)
{
	.return this + SPRITE__ID
}

.macro set_sprite_id_mask__i8(this, i8)
{
	set__i8(a8__get_sprite_id_mask(this), i8)
}

.function a8__get_sprite_id_mask(this)
{
	.return this + SPRITE__ID_MASK
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

.function a8__get_sprite_pos_x_lo(this)
{
	.return this + SPRITE__POS_X
}

.function a8__get_sprite_pos_x_hi(this)
{
	.return this + SPRITE__POS_X + 1
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

.function a8__get_sprite_pos_y_lo(this)
{
	.return this + SPRITE__POS_Y
}

.function a8__get_sprite_pos_y_hi(this)
{
	.return this + SPRITE__POS_Y + 1
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

.macro set_sprite_color__i8(this, i8)
{
	set__i8(a8__get_sprite_color(this), i8)
}

.function a8__get_sprite_color(this)
{
	.return this + SPRITE__COLOR
}

.macro set_sprite_colored__i8(this, i8)
{
	set__i8(a8__get_sprite_colored(this), i8)
}

.function a8__get_sprite_colored(this)
{
	.return this + SPRITE__COLORED
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


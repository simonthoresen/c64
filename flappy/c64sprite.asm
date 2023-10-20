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
.label SPRITE__TPF = 14
.label SPRITE__TICK = 15
.label SPRITE__FRAME = 16
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
	// set sprite color
	lda a8__get_sprite_color(this)
	ldx a8__get_sprite_id(this)
	sta C64__SPRITE_COLOR, x

	// set sprite position on screen
	position_sprite(this)

	// set sprite data pointer
	reference_frame(this)

	// set colored flag
	lda a8__get_sprite_colored(this)
	cmp #$00
	beq no_color
	lda a8__get_sprite_id_mask(this)
	ora C64__SPRITE_COLORED // enable
	jmp !+
no_color:
	lda #$ff
	eor a8__get_sprite_id_mask(this)
	and C64__SPRITE_COLORED
!:
	sta C64__SPRITE_COLORED

	// set enabled flag
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
	sta C64__SPRITE_POS,x // C64_SPRITE_POS

	lda a8__get_sprite_pos_x_hi(this)
	asl
	asl
	asl
	asl
	ora C64__SPRITE_POS,x
	sta C64__SPRITE_POS,x

	lda a8__get_sprite_pos_x_hi(this)
	cmp #$10
	bcs !+ // a >= %0001000
	lda #$ff // invert id mask to unset upper
	eor a8__get_sprite_id_mask(this) 
	and C64__SPRITE_POS_UPPER 
	jmp !++
!:
	lda C64__SPRITE_POS_UPPER
	ora a8__get_sprite_id_mask(this) // set bit
!:
	sta C64__SPRITE_POS_UPPER


	// position y
	lda a8__get_sprite_pos_y_lo(this)
	lsr
	lsr
	lsr
	lsr
	sta C64__SPRITE_POS+1,x
	lda a8__get_sprite_pos_y_hi(this)
	asl
	asl
	asl
	asl
	ora C64__SPRITE_POS+1,x
	sta C64__SPRITE_POS+1,x
}

.macro reference_frame(this)
{
	set__a16(C64__ZEROP_WORD, a16__get_sprite_anim(this))
	ldy a8__get_sprite_frame(this)

	clc
	lda (C64__ZEROP_WORD),y
	adc #DATA_BLOCK

	ldx a8__get_sprite_id(this)
	sta C64__SPRITE_POINTERS, x
}

.macro tick_move(this)
{
	// velocity x
	lda a8s__get_sprite_actual_vel_x(this)
	cmp a8s__get_sprite_target_vel_x(this)
	beq on_target_x

	sec
	sbc a8s__get_sprite_target_vel_x(this)
	bvc !+
	eor #$80
!:
	bmi below_target_x
	dec a8s__get_sprite_actual_vel_x(this)
	jmp on_target_x
below_target_x:
	inc a8s__get_sprite_actual_vel_x(this)
on_target_x:

	add__a16_a8s(a16__get_sprite_pos_x(this),
		 		 a8s__get_sprite_actual_vel_x(this))


	// velocity y
	lda a8s__get_sprite_actual_vel_y(this)
	cmp a8s__get_sprite_target_vel_y(this)
	beq on_target_y

	sec
	sbc a8s__get_sprite_target_vel_y(this)
	bvc !+
	eor #$80
!:
	bmi below_target_y
	dec a8s__get_sprite_actual_vel_y(this)
	jmp on_target_y
below_target_y:
	inc a8s__get_sprite_actual_vel_y(this)
on_target_y:

	add__a16_a8s(a16__get_sprite_pos_y(this),
		 		 a8s__get_sprite_actual_vel_y(this))


	position_sprite(this)
}

.macro tick_anim(this) 
{
	dec a8__get_sprite_tick(this)
	bpl same_frame // did not wrap yet
	lda a8__get_sprite_tpf(this)
	sta a8__get_sprite_tick(this)
	inc a8__get_sprite_frame(this)

	set__a16(C64__ZEROP_WORD, a16__get_sprite_anim(this))
	ldy a8__get_sprite_frame(this)
	lda (C64__ZEROP_WORD),y
	cmp #$ff // end of anim
	bne !+
	ldy #$00
	sty a8__get_sprite_frame(this)
!:
	reference_frame(this)

same_frame:
}

.macro tick_sprite(this)
{
	tick_move(this)
	tick_anim(this)
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

.macro set_sprite_tpf__a8(this, a8)
{
	set__a8(a8__get_sprite_tpf(this), a8)
}

.macro set_sprite_tpf__i8(this, i8)
{
	set__i8(a8__get_sprite_tpf(this), i8)
}

.function a8__get_sprite_tpf(this)
{
	.return this + SPRITE__TPF
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


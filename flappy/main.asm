#import "bird.asm"

// ------------------------------------------------------------
//
// Variables
//
// ------------------------------------------------------------
_player_1_spr: 
    alloc_sprite()

_player_2_spr: 
    alloc_sprite()


// ------------------------------------------------------------
//
// Program
//
// ------------------------------------------------------------
main_init:
	rts

main_irq:
	rts

main:
	clear_screen($20)
	set_sprite_color_1(C64__BLACK)
	set_sprite_color_2(C64__WHITE)

	set_sprite_pos__i16(_player_1_spr, $0180, $0320)
	set_sprite_anim__i16(_player_1_spr, ANIM_BIRD)
	set_sprite_id__i8(_player_1_spr, PLAYER_1_ID)
	set_sprite_color__i8(_player_1_spr, C64__RED)
	set_sprite_colored__i8(_player_1_spr, $00)
	set_sprite_tpf__i8(_player_1_spr, $02)
	set_sprite_target_vel_x__i8s(_player_1_spr, $08)
	set_sprite_target_vel_y__i8s(_player_1_spr, $2f)
	show_sprite(_player_1_spr)
	show_bird(PLAYER_1_ID, C64__LRED)

	set_sprite_pos__i16(_player_2_spr, $0f80, $0320)
	set_sprite_anim__i16(_player_2_spr, ANIM_BIRD)
	set_sprite_id__i8(_player_2_spr, PLAYER_2_ID)
	set_sprite_color__i8(_player_2_spr, C64__GREEN)
	set_sprite_colored__i8(_player_2_spr, $00)
	set_sprite_tpf__i8(_player_2_spr, $01)
	set_sprite_target_vel_x__i8s(_player_2_spr, $fa)
	set_sprite_target_vel_y__i8s(_player_2_spr, $2f)
	show_sprite(_player_2_spr)
	show_bird(PLAYER_2_ID, C64__LGREEN)

main_loop:
	.for (var i = 0; i < 1; i++) {
	    sync_tick()
	}

    tick_sprite(_player_1_spr)
	tick_bird(PLAYER_1_ID)
	check_input(_player_1_spr, C64__JOY1)

    tick_sprite(_player_2_spr)
	tick_bird(PLAYER_2_ID)
	check_input(_player_2_spr, C64__JOY2)

/*
	print_byte(a8s__get_sprite_target_vel_x(_player_1_spr), 2, 0)
	print_byte(a8s__get_sprite_actual_vel_x(_player_1_spr), 2, 1)
	print_word(a16__get_sprite_pos_x(_player_1_spr), 0, 2)

	print_byte(a8s__get_sprite_target_vel_x(_player_2_spr), 12, 0)
	print_byte(a8s__get_sprite_actual_vel_x(_player_2_spr), 12, 1)
	print_word(a16__get_sprite_pos_x(_player_2_spr), 10, 2)
*/
	jmp main_loop


.macro check_input(sprite, joy)
{
	lda #C64__JOY_FIRE
    bit joy
	bne !+
	set_sprite_actual_vel_y__i8s(sprite, $e8)
!:
	lda #C64__JOY_LEFT
    bit joy
	bne !+
	set_sprite_target_vel_x__i8s(sprite, $f1)
	jmp end
!:
	lda #C64__JOY_RIGHT
    bit joy
	bne !+
	set_sprite_target_vel_x__i8s(sprite, $0f)
	jmp end
!:
	set_sprite_target_vel_x__i8s(sprite, $00)
end:
}	
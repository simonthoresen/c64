.label PLAYER_1_ID = $00
.label PLAYER_2_ID = $04

_player_1_spr: 
	alloc_sprite()

_player_2_spr: 
	alloc_sprite()

main:
	clear_screen($20)
	set_sprite_color_1(C64__BLACK)
	set_sprite_color_2(C64__WHITE)

	set_sprite_pos__i16(_player_1_spr, $0180, $0320)
	set_sprite_anim__i16(_player_1_spr, ANIM_BIRD)
	set_sprite_id__i8(_player_1_spr, PLAYER_1_ID)
	set_sprite_color__i8(_player_1_spr, C64__RED)
	set_sprite_colored__i8(_player_1_spr, $00)
	set_sprite_tpf__i8(_player_1_spr, $06)
	show_sprite(_player_1_spr)
	show_bird(PLAYER_1_ID, C64__LRED)

	set_sprite_pos__i16(_player_2_spr, $0180, $0640)
	set_sprite_anim__i16(_player_2_spr, ANIM_BIRD)
	set_sprite_id__i8(_player_2_spr, PLAYER_2_ID)
	set_sprite_color__i8(_player_2_spr, C64__GREEN)
	set_sprite_colored__i8(_player_2_spr, $00)
	set_sprite_tpf__i8(_player_2_spr, $04)
	set_sprite_target_vel_x__i8s(_player_2_spr, $0f)
	set_sprite_target_vel_y__i8s(_player_2_spr, $04)
	show_sprite(_player_2_spr)
	show_bird(PLAYER_2_ID, C64__LGREEN)


main_loop:
    sync_tick()

    add__a16_i8s(a16__get_sprite_pos_x(_player_1_spr), $0f)
    tick_sprite(_player_1_spr)
	tick_bird(PLAYER_1_ID)

    tick_sprite(_player_2_spr)
	tick_bird(PLAYER_2_ID)
	jmp main_loop
	
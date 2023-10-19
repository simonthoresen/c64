_player_spr: 
	alloc_sprite()

main:
	clear_screen($20)
	set_sprite_pos__i16(_player_spr, $0cf0, $0320)//$0180, $0320)
	set_sprite_anim__i16(_player_spr, ANIM_BIRD)
	set_sprite_id__i8(_player_spr, $00)
	set_sprite_color__i8(_player_spr, C64__RED)//GREY)
	set_sprite_colored__i8(_player_spr, $00)
	set_sprite_color_1(BLACK)
	set_sprite_color_2(WHITE)
	show_sprite(_player_spr)
	show_bird($00, $0e, BLUE)

main_loop:
    sync_tick()

    add__a16_i8s(a16__get_sprite_pos_x(_player_spr), $0f)

    print_word(a16__get_sprite_pos_x(_player_spr), 0, 5)
    tick_sprite(_player_spr)
	tick_bird($00, $0e)
	jmp main_loop
	
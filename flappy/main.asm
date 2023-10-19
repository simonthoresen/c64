_player_spr: 
	alloc_sprite()

main:
	clear_screen($20)
	set_sprite_pos__i16(_player_spr, $1180, $0320)
	set_sprite_anim__i16(_player_spr, ANIM_BIRD_L1_R)
	set_sprite_id__i8(_player_spr, $00)
	set_sprite_color__i8(_player_spr, RED)
	set_sprite_colored__i8(_player_spr, $00)
	set_sprite_color_1(BLACK)
	set_sprite_color_2(WHITE)
	show_sprite(_player_spr)

main_loop:
    sync_tick()
	jmp main_loop
	
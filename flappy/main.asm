_player_spr: 
	alloc_sprite()

main:
	clear_screen($20)
	set_sprite_pos__i16(_player_spr, $0018*16, $0032*16)
	set_sprite_anim__i16(_player_spr, ANIM_BEAR_RIGHT)
	set_sprite_id__i8(_player_spr, 0)
	show_sprite(_player_spr)


main_loop:
    sync_tick()
	jmp main_loop
	
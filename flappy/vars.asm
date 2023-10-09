.label SPRITE_POS_X_MIN = $0018
.label SPRITE_POS_X_MAX = $0140
.label SPRITE_POS_Y_MIN = $32
.label SPRITE_POS_Y_MAX = $90


_frame_count: 	.byte $00
_slow_motion:	.byte $00

_player_anim_ptr: .word $0000
_player_frame:    .byte $00

_player_pos_x: 	.word $0000
_player_acc_x: 	.byte $00
_player_vel_x: 	.byte $00
_player_pos_y: 	.byte $00
_player_acc_y: 	.byte $00
_player_vel_y: 	.byte $00

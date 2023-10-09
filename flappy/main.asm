.filenamespace main

main:
    lda #$80 // point to address of sprite in 64 multiples
    sta ADR_SPR0_POINTER  

    lda #%00000001 
    sta ADR_SPRITE_ENABLE
    sta ADR_SPRITE_MCOL_ENABLE

    lda #SPR_BEAR_MCOL0
    sta ADR_SPRITE_MCOL0
    lda #SPR_BEAR_MCOL1
    sta ADR_SPRITE_MCOL1

    lda #COL_BROWN
    sta ADR_SPR0_COLOR


    sta_val16($0018, _player_pos_x)
    lda #$32
    sta _player_pos_y
    lda #$00
    sta _player_acc_x
    sta _player_acc_y
    sta _player_vel_x
    sta _player_vel_y

    lda #$00
    sta _slow_motion

    clear_screen(ADR_SCREEN, $20)

main_loop:
    wait_for_frame()
    inc _frame_count

    dec _slow_motion
    lda _slow_motion
    cmp #$ff
    bne main_loop
    lda #$00
    sta _slow_motion

    read_player_acc()
    calc_player_vel()
    update_player_pos()

    //draw_joy_state()
    draw_player_state()

    anim_player_spr()
    draw_player_spr()

    jmp main_loop


.macro draw_player_state() {
    lda #'x'
    sta ADR_SCREEN
    lda #':'
    sta ADR_SCREEN+1
    draw_mem(_player_pos_x+1, 2)
    draw_mem(_player_pos_x, 4)
    draw_mem(_player_vel_x, 7)
    draw_mem(_player_acc_x, 10)  

    lda #'y'
    sta ADR_SCREEN+40
    lda #':'
    sta ADR_SCREEN+41
    draw_mem(_player_pos_y, 44)
    draw_mem(_player_vel_y, 47)
    draw_mem(_player_acc_y, 50)      
}

.macro draw_acc4(pos) {
    cmp #$0a
    bcs letter

digit:
    ora #$30
    jmp print

letter:
    clc
    sbc #$08

print:
    sta ADR_SCREEN+pos
}

.macro draw_mem(src, pos) {
    lda src
    pha
    lsr
    lsr
    lsr
    lsr
    draw_acc4(pos)
    
    pla
    and #$0f
    draw_acc4(pos+1)
}

.macro draw_player_spr() {
    lda _player_pos_x
    sta ADR_SPR0_POSX

    lda ADR_SPRITE_POSX_BIT9
    ldx _player_pos_x+1
    cpx #$00
    beq !+
    ora #%00000001
    jmp !++
!:
    and #%11111110
!:
    sta ADR_SPRITE_POSX_BIT9

    lda _player_pos_y
    sta ADR_SPR0_POSY
}

.macro anim_player_spr() {
    lda _player_acc_x
    cmp #$00
    bne move

stop:
    ldx #$88
    jmp end

move:
    lda _frame_count
    and #%00001100
    lsr
    lsr
    adc #$80
    tax

    lda _player_acc_x
    and #$80
    cmp #$80
    bne move_right

move_left:
    inx
    inx
    inx
    inx

move_right:

end:
    stx ADR_SPR0_POINTER
}

_sprite_pos_x_min: .word $0018
_sprite_pos_x_max: .word $0140

.macro update_player_pos() {
    add_signed8(_player_vel_x, _player_pos_x)

    cmp16(_player_pos_x, _sprite_pos_x_min)
    bpl !+
    lda _sprite_pos_x_min
    sta _player_pos_x
    lda _sprite_pos_x_min+1
    sta _player_pos_x+1
    jmp end
!:
    cmp16(_player_pos_x, _sprite_pos_x_max)
    bmi !+
    lda _sprite_pos_x_max
    sta _player_pos_x
    lda _sprite_pos_x_max+1
    sta _player_pos_x+1
    jmp end
!:

end:    
}


.macro calc_player_vel() {
    lda _player_acc_x
    cmp #$00
    beq end

    lda _player_vel_x
    clc
    adc _player_acc_x
    sta _player_vel_x

    and #$80
    cmp #$80
    beq cap_neg

cap_pos:
    lda _player_vel_x
    cmp #$06
    bcc end
    lda #$06
    sta _player_vel_x
    jmp end

cap_neg:
    lda _player_vel_x
    cmp #$fa
    bcs end
    lda #$fa
    sta _player_vel_x

end:
}

.macro read_player_acc() {
    // check joystick for acc
    lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
    bne !+
    lda #$01
    sta _player_acc_x
    jmp end
!:
    lda #MSK_JOY_LEFT
    bit ADR_JOY1_STATE
    bne !+
    lda #$ff // -1
    sta _player_acc_x
    jmp end
!:    

    // check velocity for need to slow
    lda _player_vel_x
    cmp #$00
    bne !+
    sta _player_acc_x
    jmp end
!:

    // slow down
    and #%1000000
    cmp #$00
    beq !+ // jmp if negative
    lda #$01
    sta _player_acc_x
    jmp end
!:
    lda #$ff // -1 as signed byte
    sta _player_acc_x

end:
}

.macro wait_for_frame() {
!:  // in case the raster is on our marker line, we wait for it increment
    lda $d012
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda $d012
    cmp #$fa // line 250
    bne !-    
}
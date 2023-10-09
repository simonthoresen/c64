

main:
    lda #$80 // point to address of sprite in 64 multiples
             // this is $2000 (hardcoded in data.asm) / 64
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


    cpy_val16($0018, _player_pos_x)
    lda #$32
    sta _player_pos_y
    lda #$00
    sta _player_acc_x
    sta _player_acc_y
    sta _player_vel_x
    sta _player_vel_y

    set_anim(_anim_bear_stand, 
             _player_anim_ptr, 
             _player_frame)

    lda #$00
    sta _slow_motion

    clear_screen($20)

main_loop:
    wait_for_frame()

    dec _slow_motion
    lda _slow_motion
    cmp #$ff
    bne main_loop
    lda #$00
    sta _slow_motion

    inc _frame_count

    read_player_acc()
    calc_player_vel()
    update_player_pos()

    //debug_joy_state()
    debug_player_state()

    anim_player_spr()
    draw_player_spr()

    jmp main_loop


.macro debug_player_state() {
    lda #'x'
    sta ADR_SCREEN
    lda #':'
    sta ADR_SCREEN+1
    print_word(_player_pos_x, 2)
    print_byte(_player_vel_x, 7)
    print_byte(_player_acc_x, 10)  

    lda #'y'
    sta ADR_SCREEN+40
    lda #':'
    sta ADR_SCREEN+41
    print_byte(_player_pos_y, 44)
    print_byte(_player_vel_y, 47)
    print_byte(_player_acc_y, 50)      
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
    lda _player_anim_ptr
    sta ADR_ZPAGE_U0
    lda _player_anim_ptr+1
    sta ADR_ZPAGE_U1

    lda _frame_count
    and #$03
    cmp #$03
    bne !+
    inc _player_frame
!:
    ldy _player_frame
    lda (ADR_ZPAGE_U0),y
    cmp #$ff
    bne !+
    ldy #$00
    sty _player_frame
    lda (ADR_ZPAGE_U0),y
!:
    clc
    adc #$80 // ADR_SPRITES / 64
    sta ADR_SPR0_POINTER

    print_word(ADR_ZPAGE_U0, 120)
    print_byte(ADR_SPR0_POINTER, 125)
    print_byte(_player_frame, 160)    
}

.macro update_player_pos() {
    add_signed8(_player_vel_x, _player_pos_x)

    cmp_val16(_player_pos_x, SPRITE_POS_X_MIN)
    bpl !+
    cpy_val16(SPRITE_POS_X_MIN, _player_pos_x)
    jmp end
!:
    cmp_val16(_player_pos_x, SPRITE_POS_X_MAX)
    bmi !+
    cpy_val16(SPRITE_POS_X_MAX, _player_pos_x)
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

.macro set_anim(anim_ptr, dst_anim, dst_frame) {
    lda #<anim_ptr
    cmp dst_anim
    bne !+
    lda #>anim_ptr
    cmp dst_anim+1
    beq !++
!:
    cpy_val16(anim_ptr, dst_anim)
    lda #$00
    sta dst_frame
!:
}

.macro read_player_acc() {
    // check joystick for acc
    lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
    bne !+
    lda #$01
    sta _player_acc_x
    set_anim(_anim_bear_walk_right, 
             _player_anim_ptr, 
             _player_frame)
    jmp end
!:
    lda #MSK_JOY_LEFT
    bit ADR_JOY1_STATE
    bne !+
    lda #$ff // -1
    sta _player_acc_x
    set_anim(_anim_bear_walk_left, 
             _player_anim_ptr, 
             _player_frame)
    jmp end
!:    
    set_anim(_anim_bear_stand, 
             _player_anim_ptr, 
             _player_frame)

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
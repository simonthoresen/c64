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


    sta_val16($0010, _player_pos_x)
    lda #$46
    sta _player_pos_y
    lda #$00
    sta _player_acc_x
    sta _player_acc_y
    sta _player_vel_x
    sta _player_vel_y


main_loop:
    wait_for_frame()
    inc _frame_count

    draw_joy_state()

    read_player_acc()
    calc_player_vel()
    update_player_pos()

    anim_player_spr()
    draw_player_spr()

    inc $d020
    jmp main_loop


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
    lda _frame_count
    and #%00001100
    lsr
    lsr
    adc #$80
    sta ADR_SPR0_POINTER
}

.macro update_player_pos() {
    lda _player_vel_x
    cmp #$00
    beq end

    and #%10000000
    cmp #$00
    bne neg
pos:
    add_val8($02, _player_pos_x)
    jmp end
neg:
    sub_val8($02, _player_pos_x)
    // fall through
end:
}

.macro calc_player_vel() {
    lda _player_acc_x

    // todo: smoothen

    sta _player_vel_x
}

.macro read_player_acc() {
    lda #$00
    sta _player_acc_x

    lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
    bne !+
    lda #$01
    sta _player_acc_x
!:

    lda #MSK_JOY_LEFT
    bit ADR_JOY1_STATE
    bne !+
    lda #$81
    sta _player_acc_x
!:
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
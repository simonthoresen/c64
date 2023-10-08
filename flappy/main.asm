main:
    lda #$82 // point to address of sprite in 64 multiples
    sta ADR_SPR0_POINTER  

    lda #%00000001 
    sta ADR_SPRITE_ENABLE
    sta ADR_SPRITE_MCOL_ENABLE

    lda #COL_BLACK
    sta ADR_SPRITE_MCOL0
    lda #COL_WHITE
    sta ADR_SPRITE_MCOL1

    lda #COL_LGREY
    sta ADR_SPR0_COLOR


    lda #$10
    sta _player_pos_x
    lda #$00
    sta _player_pos_x+1
    lda #$46
    sta ADR_SPR0_POSY


main_loop:
    wait_for_frame()
    draw_joy_state()

    inc _frame_count

    lda _frame_count
    and #$04
    lsr
    lsr
    adc #$82
    sta ADR_SPR0_POINTER


    lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
    bne !+
    add_val8($02, _player_pos_x)
!:

    lda #MSK_JOY_LEFT
    bit ADR_JOY1_STATE
    bne !+
    sub_val16($0002, _player_pos_x)
!:


    lda _player_pos_x+1
    adc #'0'
    sta $0400

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


    inc $d020
    jmp main_loop



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
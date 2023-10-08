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


    lda #$64
    sta ADR_SPR0_POSX
    lda #$46
    sta ADR_SPR0_POSY


main_loop:
    :wait_for_frame()
    :draw_joy_state()

    inc _frame_count

    lda _frame_count
    and #$04
    lsr
    lsr
    adc #$82
    sta ADR_SPR0_POINTER

    lda #MSK_JOY_RIGHT
    bit ADR_JOY1_STATE
    bne !++
    lda ADR_SPR0_POSX
    cmp #$ff
    bne !+
    lda #$01
    ora ADR_SPRITE_POSX_BIT9
    sta ADR_SPRITE_POSX_BIT9
!:
    inc ADR_SPR0_POSX
!:
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
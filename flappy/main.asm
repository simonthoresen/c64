
/*
main:
    lda #SPRITE_0_BLOCK
    sta ADR_SPRITE_0

    lda #%00000001
    sta ADR_SPRITE_ENABLE // enable sprite 0, %0000 0001

    lda #BLACK
    sta ADR_SPRITE_0_COLOR

    ldx #$00
build_sprite:
    lda SPRITE_BUG,x 
    sta ADR_SPR0_DATA,x
    inx
    cpx #$3f
    bne build_sprite

*/



 main:
  lda #$0D              // using block 13 for sprite0
  sta ADR_SPR0_INDEX  // set block 13 as target address for Data of Sprite0
 
  lda #%00000001              // enable...
  sta ADR_SPRITE_ENABLE             // ...Sprite 0 => %0000 0001 (all sprites off except Sprite 0)
  
  lda #COLOR_BLACK      // load black color code into A
  sta SPRITE_0_COLOR    // make Sprite0 completely black
  
  // Reset Sprite Data
  ldx #$00    // init x
  lda #$00    // init a
  
clean:
  sta ADR_SPR0_DATA,x   // write 0 into sprite data at x
  inx                   // increment x
  cpx #$7F              // is x <= 127?
  bne clean             // if yes, goto clean
  
  // Build the Sprite
  ldx #$00              // init x
build:
  lda SPRITE_BALL, x     // load data at x
  sta ADR_SPR0_DATA,x   // write into sprite data at x
  inx                   // increment x
  cpx #$7F              // is x <= 127?
  bne build             // if yes, goto build
  
  // Set Start Location of Sprite 0
  ldx #$64                  // initial x position = 100
  ldy #$46                  // initial y position =  70
  stx SPRITE_0_X_POSITION   // move sprite 0 to x position
  sty SPRITE_0_Y_POSITION   // move sprite 0 to y position



    lda #%11111111
    sta ADR_SPRITE_MCOL_ENABLE // enable multicolor for all sprites

    lda #$0f // sprite multicolor 1
    sta ADR_SPRITE_MCOL0
    lda #$02 // sprite multicolor 2
    sta ADR_SPRITE_MCOL1
    lda #GREEN
    sta SPRITE_0_COLOR

main_loop:
    wait_for_frame()
    draw_joy_state()

    inc _frame_count

    lda _frame_count
    and #$04
    lsr
    lsr
    adc #$0d
    sta ADR_SPR0_INDEX

/*
    inc ADR_SPR0_INDEX
    lda ADR_SPR0_INDEX
    cmp #$0F
    bne !+
    lda #$0D              // using block 13 for sprite0   
!:
*/

    lda #JOY_RIGHT
    bit JOY1_STATE
    bne !++
    lda SPRITE_0_X_POSITION
    cmp #$ff
    bne !+
    lda #$01
    ora ADR_SPRITE_UPPER_X
    sta ADR_SPRITE_UPPER_X
!:
    inc SPRITE_0_X_POSITION
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
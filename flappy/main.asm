
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
    sta SPRITE_0_DATA,x
    inx
    cpx #$3f
    bne build_sprite

*/
.const  COLOR_BLACK       = $00
.const  COLOR_GREEN       = $05
.const  COLOR_LIGHTGREEN  = $0D
  
.const  SPRITE_0_X_POSITION = $D000
.const  SPRITE_0_Y_POSITION = $D001
 
.const  BORDER_COLOR        = $D020
.const  BACKGROUND_COLOR    = $D021
 
.const  SPRITE_0_COLOR      = $D027
  
.const  SPRITE_0_POINTER    = $0400 + $03F8
.const  SPRITE_0_DATA       = $0340        

.const  SPRITE_UPPER_X      = $D010

_frameCount: .byte $00

 main:
  lda #$0D              // using block 13 for sprite0
  sta SPRITE_0_POINTER  // set block 13 as target address for Data of Sprite0
 
  lda #$01              // enable...
  sta $D015             // ...Sprite 0 => %0000 0001 (all sprites off except Sprite 0)
  
  lda #COLOR_BLACK      // load black color code into A
  sta SPRITE_0_COLOR    // make Sprite0 completely black
  
  // Reset Sprite Data
  ldx #$00    // init x
  lda #$00    // init a
  
clean:
  sta SPRITE_0_DATA,x   // write 0 into sprite data at x
  inx                   // increment x
  cpx #$7F              // is x <= 127?
  bne clean             // if yes, goto clean
  
  // Build the Sprite
  ldx #$00              // init x
build:
  lda SPRITE_BUG, x     // load data at x
  sta SPRITE_0_DATA,x   // write into sprite data at x
  inx                   // increment x
  cpx #$7F              // is x <= 127?
  bne build             // if yes, goto build
  
  // Set Start Location of Sprite 0
  ldx #$64                  // initial x position = 100
  ldy #$46                  // initial y position =  70
  stx SPRITE_0_X_POSITION   // move sprite 0 to x position
  sty SPRITE_0_Y_POSITION   // move sprite 0 to y position



main_loop:
    waitForFrame()
    drawJoyState()

    inc _frameCount

    lda _frameCount
    and #$04
    lsr
    lsr
    adc #$0d
    sta SPRITE_0_POINTER

/*
    inc SPRITE_0_POINTER
    lda SPRITE_0_POINTER
    cmp #$0F
    bne !+
    lda #$0D              // using block 13 for sprite0   
!:
*/
    lda JOY1_STATE
    and #JOY_RIGHT
    bne !++

    lda SPRITE_0_X_POSITION
    cmp #$ff
    bne !+
    lda #$01
    ora SPRITE_UPPER_X
    sta SPRITE_UPPER_X
!:
    inc SPRITE_0_X_POSITION
!:
    inc $d020
    jmp main_loop


.macro waitForFrame() {
!:  // in case the raster is on our marker line, we wait for it increment
    lda $d012
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda $d012
    cmp #$fa // line 250
    bne !-    
}
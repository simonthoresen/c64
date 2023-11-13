// ------------------------------------------------------------
//
// C64 constants
//
// ------------------------------------------------------------
.label C64__ARG0_LO             = $0002
.label C64__ARG0_HI             = $0003
.label C64__ARG0                = C64__ARG0_LO
.label C64__ARG1_LO             = $0004
.label C64__ARG1_HI             = $0005
.label C64__ARG1                = C64__ARG1_LO
.label C64__ARG2_LO             = $00fb
.label C64__ARG2_HI             = $00fc
.label C64__ARG2                = C64__ARG2_LO
.label C64__COLOR               = $0286
.const C64__COLOR_BORDER        = $d020
.const C64__COLOR_BG0           = $d021
.const C64__COLOR_BG            = C64__COLOR_BG0
.const C64__COLOR_BG1           = $d022
.const C64__COLOR_BG2           = $d023
.const C64__COLOR_BG3           = $d024
.label C64__IRQ_STATUS          = $d019
.label C64__IRQ_CTRL            = $d01a
.label C64__IRQ_LO              = $fffe
.label C64__IRQ_HI              = $ffff
.label C64__JOY1                = $dc01
.label C64__JOY2                = $dc00
.label C64__JOY_UP              = %00000001
.label C64__JOY_DOWN            = %00000010
.label C64__JOY_LEFT            = %00000100
.label C64__JOY_RIGHT           = %00001000
.label C64__JOY_FIRE            = %00010000
.label C64__MEM_SETUP           = $d018
.label C64__RASTER_LINE         = $d012
.label C64__SCREEN_CTRL1        = $d011
.label C64__SCREEN_CTRL2        = $d016
.label C64__SCREEN_DATA         = $0400
.label C64__SCREEN_COLOR        = $d800
.label C64__SPRITE_W            = $18
.label C64__SPRITE_H            = $15
.label C64__SCROLL_X            = C64__SCREEN_CTRL2
.label C64__SCROLL_Y            = C64__SCREEN_CTRL1
.label C64__SPRITE_COLOR0       = $d027
.label C64__SPRITE_COLOR        = C64__SPRITE_COLOR0
.label C64__SPRITE_COLOR1       = $d025
.label C64__SPRITE_COLOR2       = $d026
.label C64__SPRITE_COLORED      = $d01c
.label C64__SPRITE_ENABLED      = $d015
.label C64__SPRITE_POINTERS     = $07f8
.label C64__SPRITE_POS          = $d000
.label C64__SPRITE_POS_UPPER    = $d010
.label C64__ZEROP_BYTE1         = $002a
.label C64__ZEROP_BYTE          = C64__ZEROP_BYTE1
.label C64__ZEROP_BYTE2         = $0052
.label C64__ZEROP_WORD_LO       = $00fd
.label C64__ZEROP_WORD_HI       = $00fe
.label C64__ZEROP_WORD          = C64__ZEROP_WORD_LO

.label C64__BLACK               = $00
.label C64__WHITE               = $01
.label C64__RED                 = $02
.label C64__CYAN                = $03
.label C64__PURPLE              = $04
.label C64__GREEN               = $05
.label C64__BLUE                = $06
.label C64__YELLOW              = $07
.label C64__ORANGE              = $08
.label C64__BROWN               = $09
.label C64__LRED                = $0a
.label C64__DGREY               = $0b
.label C64__GREY                = $0c
.label C64__LGREEN              = $0d
.label C64__LBLUE               = $0e
.label C64__LGREY               = $0f


// ------------------------------------------------------------
//
// Import other library files.
//
// ------------------------------------------------------------
#import "c64sprite.asm"


// ------------------------------------------------------------
//
// Permutations of getters and setters.
//
// ------------------------------------------------------------
.macro set__a8(a8_var, a8_val)
{
    lda a8_val
    sta a8_var
}

.macro set__i8(a8_var, i8_val)
{
    lda #i8_val
    sta a8_var
}

.macro set__a16(a16_var, a16_val)
{
    lda a16_val
    sta a16_var
    lda a16_val + 1
    sta a16_var + 1
}

.macro set__i16(a16_var, i16_val)
{
    lda #<i16_val
    sta a16_var
    lda #>i16_val
    sta a16_var + 1
}

.macro inc__a16(a16_var)
{
    inc a16_var
    bne no_carry
    inc a16_var + 1
no_carry:
}

.macro add__a16_i8(a16_var, i8_val)
{
    clc
    lda #i8_val
    adc a16_var
    sta a16_var
    lda #$00
    adc a16_var + 1
}

.macro add__a16_i8s(a16_var, i8s_val)
{
    clc
    lda #i8s_val
    adc a16_var
    sta a16_var

    // sign-extend the high byte
    lda #i8s_val
    and #$80    // extract the sign bit
    beq !+      // if zero, add #$00 (+carry)
    lda #$ff    // else, add $ff (+ carry)
!:  adc a16_var + 1
    sta a16_var + 1
}

.macro add__a16_a8s(a16_var, a8s_val)
{
    clc
    lda a8s_val
    adc a16_var
    sta a16_var

    // sign-extend the high byte
    lda a8s_val
    and #$80    // extract the sign bit
    beq !+      // if zero, add #$00 (+carry)
    lda #$ff    // else, add $ff (+ carry)
!:  adc a16_var + 1
    sta a16_var + 1
}


//            BCC/BCS BEQ/BNE BMI/BPL
// acc = arg:  Carry,  Zero,  !Neg
// acc > arg:  Carry, !Zero,  !Neg
// acc < arg: !Carry, !Zero,   Neg


// ------------------------------------------------------------
//
// Program setup functions.
//
// ------------------------------------------------------------
.macro do_startup()
{
    enter_startup()
    leave_startup()
}

.macro enter_startup() {
    sei        // disable maskable IRQs

    lda #$7f
    sta $dc0d  // disable timer interrupts which can be generated by the two CIA chips
    sta $dd0d  // the kernal uses such an interrupt to flash the cursor and scan the keyboard, so we better
               // stop it.

    lda $dc0d  // by reading this two registers we negate any pending CIA irqs.
    lda $dd0d  // if we don't do this, a pending CIA irq might occur after we finish setting up our irq.
               // we don't want that to happen.

    lda #$00
    sta C64__IRQ_CTRL

    lda #$35   // we turn off the BASIC and KERNAL rom here
    sta $01    // the cpu now sees RAM everywhere except at $d000-$e000, where still the registers of
               // SID/VICII/etc are visible
}

.macro leave_startup() {
    cli        // enable maskable interrupts again
}


// ------------------------------------------------------------
//
// Wait for the raster to hit the bottom border.
//
// ------------------------------------------------------------
.macro wait_vblank() {
!:  // in case the raster is on our marker line, we wait for it increment
    lda C64__RASTER_LINE
    cmp #$fa
    beq !- 

!:  // wait for the raster to reach our marker line 
    lda C64__RASTER_LINE
    cmp #$fa // line 250
    bne !-    
}


// ------------------------------------------------------------
//
// Fill the screen with a byte or a color.
//
// ------------------------------------------------------------
.macro clear_screen(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta C64__SCREEN_DATA, x
    sta C64__SCREEN_DATA + $0100, x
    sta C64__SCREEN_DATA + $0200, x
    sta C64__SCREEN_DATA + $0300, x
    inx
    bne !-
}

.macro clear_colors(clearByte) 
{
    lda #clearByte
    ldx #$00
!:
    sta C64__SCREEN_COLOR, x
    sta C64__SCREEN_COLOR + $0100, x
    sta C64__SCREEN_COLOR + $0200, x
    sta C64__SCREEN_COLOR + $0300, x
    inx
    bne !-  
}


// ------------------------------------------------------------
//
// Screen scrolling.
//
// ------------------------------------------------------------
.macro scroll_screen_x_a8(a8)
{    
    lda C64__SCREEN_CTRL2    
    and #%11111000
    sta C64__SCREEN_CTRL2    

    lda a8
    and #%00000111
    ora C64__SCREEN_CTRL2
    sta C64__SCREEN_CTRL2
}

.macro scroll_screen_x_i8(i8)
{    
    lda C64__SCREEN_CTRL2    
    and #%11111000
    sta C64__SCREEN_CTRL2    

    lda #i8
    and #%00000111
    ora C64__SCREEN_CTRL2
    sta C64__SCREEN_CTRL2
}

.macro scroll_screen_y_a8(a8)
{
    lda C64__SCREEN_CTRL1
    and #%11111000
    sta C64__SCREEN_CTRL1

    lda a8
    and #%00000111
    ora C64__SCREEN_CTRL1
    sta C64__SCREEN_CTRL1
}


// ------------------------------------------------------------
//
// Interrupt request service helpers.
//
// ------------------------------------------------------------
.macro enter_irq()
{
    // Being all kernal irq handlers switched off we have to do more work by ourselves.
    // When an interrupt happens the CPU will stop what its doing, store the status and return address
    // into the stack, and then jump to the interrupt routine. It will not store other registers, and if
    // we destroy the value of A/X/Y in the interrupt routine, then when returning from the interrupt to
    // what the CPU was doing will lead to unpredictable results (most probably a crash). So we better
    // store those registers, and restore their original value before reentering the code the CPU was
    // interrupted running.

    // If you won't change the value of a register you are safe to not to store / restore its value.
    // However, it's easy to screw up code like that with later modifying it to use another register too
    // and forgetting about storing its state.

    // The method shown here to store the registers is the most orthodox and most failsafe.

    pha                 // store register A in stack
    txa
    pha                 // store register X in stack
    tya
    pha                 // store register Y in stack

    lda #$ff            // this is the orthodox and safe way of clearing the interrupt condition of the VICII.
    sta C64__IRQ_STATUS // if you don't do this the interrupt condition will be present all the time and you end
                        // up having the CPU running the interrupt code all the time, as when it exists the
                        // interrupt, the interrupt request from the VICII will be there again regardless of the
                        // rasterline counter.

                        // it's pretty safe to use inc $d019 (or any other rmw instruction) for brevity, they
                        // will only fail on hardware like c65 or supercpu. c64dtv is ok with this though.

	lda #$02
	sta C64__COLOR_BORDER
}

.macro setup_irq(i16_line, i16_irq)
{
    lda #$81            // this is how to tell the VICII to generate a raster interrupt
    sta C64__IRQ_CTRL

    lda #(i16_line & $ff) // this is how to tell at which rasterline we want the irq to be triggered
    sta C64__RASTER_LINE

    // as there are more than 256 rasterlines, the topmost bit of $d011 serves as
    // the 9th bit for the rasterline we want our irq to be triggered.
    lda C64__SCREEN_CTRL1
    .if (i16_line > $ff) {
        and #$80 // set the msb
    } else {
        and #$7f // clear the msb
    }
    sta C64__SCREEN_CTRL1   

    lda #<i16_irq       // this is how we set up
    sta C64__IRQ_LO     // the address of our interrupt code
    lda #>i16_irq
    sta C64__IRQ_HI
}

.macro leave_irq()
{
	lda #$00
	sta C64__COLOR_BORDER

    pla
    tay                 // restore register Y from stack (remember stack is FIFO: First In First Out)
    pla
    tax                 // restore register X from stack
    pla                 // restore register A from stack
}


// ------------------------------------------------------------
//
// String helper functions.
//
// ------------------------------------------------------------
.function index_of(look_for, look_in) 
{
	.for (var i = 0; i < look_in.size(); i++) {
		.if (look_for == look_in.charAt(i)) {
			.return i
		}
	}
	.error("char '" + look_for + "' not found")
}


// ------------------------------------------------------------
//
// Printing to the screen.
//
// ------------------------------------------------------------
.macro print_word(src, pos_x, pos_y) {
    print_byte(src+1, pos_x, pos_y)
    print_byte(src, pos_x + 2, pos_y)
}

.macro print_byte(src, pos_x, pos_y) {
    lda src
    ldx #(pos_y * 40 + pos_x)
    jsr print.byte
}

.namespace print {

byte:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr nibble
    
    pla
    and #$0f
    inx
    jsr nibble
    rts

nibble:
    cmp #$0a
    bcs letter

digit:
    ora #$30
    jmp !+

letter:
    clc
    sbc #$08

!:
    sta C64__SCREEN_DATA, x

    lda C64__COLOR
    sta C64__SCREEN_COLOR, x
    rts

} 


// ------------------------------------------------------------
//
// 8-bit random number generator.
//
// ------------------------------------------------------------
.macro alloc_seed() 
{
	.byte $14
}

.macro lda_rand(seed)
{
    lda seed
    asl
    bcc !+
    eor #$1d
!:  sta seed
}

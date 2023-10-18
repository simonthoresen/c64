BasicUpstart2(startup)

.const ADR_DATA = $2000
.const DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Data"
#import "data.asm"

*=$4000 "Main Program"
#import "sprite.asm"
#import "c64lib.asm"

#import "main.asm"


startup:
    sei        // disable maskable IRQs

    lda #$7f
    sta $dc0d  // disable timer interrupts which can be generated by the two CIA chips
    sta $dd0d  // the kernal uses such an interrupt to flash the cursor and scan the keyboard, so we better
               // stop it.

    lda $dc0d  // by reading this two registers we negate any pending CIA irqs.
    lda $dd0d  // if we don't do this, a pending CIA irq might occur after we finish setting up our irq.
               // we don't want that to happen.

    lda #$81   // this is how to tell the VICII to generate a raster interrupt
    sta $d01a

    lda #$80   // this is how to tell at which rasterline we want the irq to be triggered
    sta $d012

    lda #$1b   // as there are more than 256 rasterlines, the topmost bit of $d011 serves as
    sta $d011  // the 9th bit for the rasterline we want our irq to be triggered.
               // here we simply set up a character screen, leaving the topmost bit 0.

    lda #$35   // we turn off the BASIC and KERNAL rom here
    sta $01    // the cpu now sees RAM everywhere except at $d000-$e000, where still the registers of
               // SID/VICII/etc are visible

    lda #<irq  // this is how we set up
    sta $fffe  // the address of our interrupt code
    lda #>irq
    sta $ffff

    // TODO: init music

    cli        // enable maskable interrupts again
    jmp main


irq:
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

    pha        // store register A in stack
    txa
    pha        // store register X in stack
    tya
    pha        // store register Y in stack

    lda #$ff   // this is the orthodox and safe way of clearing the interrupt condition of the VICII.
    sta $d019  // if you don't do this the interrupt condition will be present all the time and you end
               // up having the CPU running the interrupt code all the time, as when it exists the
               // interrupt, the interrupt request from the VICII will be there again regardless of the
               // rasterline counter.

               // it's pretty safe to use inc $d019 (or any other rmw instruction) for brevity, they
               // will only fail on hardware like c65 or supercpu. c64dtv is ok with this though.

!irq:               

    count_vblank()

!irq:

    pla
    tay        // restore register Y from stack (remember stack is FIFO: First In First Out)
    pla
    tax        // restore register X from stack
    pla        // restore register A from stack

    rti        // Return From Interrupt, this will load into the Program Counter register the address
               // where the CPU was when the interrupt condition arised which will make the CPU continue
               // the code it was interrupted at also restores the status register of the CPU


// ------------------------------------------------------------
//
// Sync routines for screen refresh and game loop.
//
// ------------------------------------------------------------
.macro count_vblank()
{
    dec _num_vblanks
    bpl end // return if less than a second

    lda #$32
    cmp _num_ticks
    beq !+
    lda #RED
    jmp !++
!:
    lda #GREEN
!:
    sta ADR_COLOR

    print_byte(_num_ticks, 38, 0)
    lda #$31
    sta _num_vblanks
    lda #$00
    sta _num_ticks

end:
}

.macro sync_tick()
{
    wait_vblank()
    inc _num_ticks
}
:BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

startup: 
   enter_startup()
   setup_irq($0034, irq1)

   lda #$0e
   sta C64__COLOR_BORDER
   lda #$06
   sta C64__COLOR_BG
   lda #$00
   sta C64__SPRITE_ENABLED
   clear_screen($20)

   asl C64__IRQ_STATUS
   bit C64__IRQ_CIA1
   bit C64__IRQ_CIA2
   leave_startup()

main:
   jmp main


//===========================================================================================
// Main interrupt handler
// [x] denotes the number of cycles 
//=========================================================================================== 
irq1:
{
	// [7] cycles spent to get in here
   sta _lda + 1 // [4]
   stx _ldx + 1 // [4]
   sty _ldy + 1 // [4]

   // [16] cycles to set next handler
   set__i16(C64__IRQ_LO, _stable_irq) 

   inc C64__RASTER_LINE	// [6] set irq for the next line
   asl C64__IRQ_STATUS	// [6] ack current interrupt
   tsx // [2] store my stack pointer for stable irq
   cli // [2] enable irq to trigger while nop

   // [51] cycles up to this point
   nop // [53]
   nop // [55]
   nop // [57]
   nop // [59]
   nop // [61]
   nop // [63]
   nop // [65]
   // will never get here, stable irq will take over   


_stable_irq:
   // [7] cycles to get here
   txs // [2] restore stack pointer to entry of parent
	
   // [47] busy loop until we get the raster into the right border
   ldx #$09	// [2]
!: dex		// [2]
   bne !-	// [3]
 
   // [66] total cycles spent

   lda #$00
   sta C64__COLOR_BORDER	
   lda #$05
   sta C64__COLOR_BG
 
   set__i16(C64__IRQ, irq3) 

   lda #$68
   sta C64__RASTER_LINE
   asl C64__IRQ_STATUS // ack raster irq

_lda: lda #$00
_ldx:	ldx #$00
_ldy:	ldy #$00

   rti
}


//===========================================================================================
// Part 3 of the Main interrupt handler
//===========================================================================================           
irq3:
{
         sta _lda + 1	//Preserve A,X,and Y
         stx _ldx + 1	//Registers
         sty _ldy + 1         

         ldy #$13	//Waste time so this line is drawn completely
         dey		//	[2]
         bne *-1	//	[3]
			//same line!
         
         lda #$0f	//Back to our original colors
         ldx #$07 
         sta $d020	//
         stx $d021	//
 
         lda #<irq1	//Reset Vectors to
         ldx #>irq1	//first IRQ again
         ldy #$34	//at line $34
         sta $fffe
         stx $ffff
         sty $d012
         asl $d019	//Ack RASTER IRQ
 
_lda: lda #$00	//Reload A,X,and Y
_ldx:	ldx #$00
_ldy:	ldy #$00
 
         rti		//Return from IRQ
}

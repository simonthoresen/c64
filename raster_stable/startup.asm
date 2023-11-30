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


irq1:
   stable_irq(do_irq1)
   rti

do_irq1:
   lda #$00
   sta C64__COLOR_BORDER	
   lda #$05
   sta C64__COLOR_BG

   lda #$68
   sta C64__RASTER_LINE
   set__i16(C64__IRQ, irq2) 
   rts

irq2:
   stable_irq(do_irq2)
   rti

do_irq2:
   lda #$0f
   sta C64__COLOR_BORDER	
   lda #$07
   sta C64__COLOR_BG

   lda #$34
   sta C64__RASTER_LINE
   set__i16(C64__IRQ, irq1) 
   rts
   
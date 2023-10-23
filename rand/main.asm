main_init:
	rts

main_irq:
	rts

main:
	ldx #$00
!:
.for (var i = 0; i < 4; i++) {
	jsr rand
    sta C64__SCREEN_DATA + $0100*i, x
}
	inx    
    bne !-

	jmp *


seed: .byte $14
rand:
    lda seed
    asl
    bcc !+
    eor #$1d
!:  sta seed
	rts
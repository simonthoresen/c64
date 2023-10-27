BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

_seed: 
    alloc_seed()

startup:
	do_startup()

main:
	ldx #$00
!:
.for (var i = 0; i < 4; i++) {
	lda_rand(_seed)
    sta C64__SCREEN_DATA + $0100*i, x
}
	inx    
    bne !-

	jmp *



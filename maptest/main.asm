main_init:
	rts

main_irq:
	rts

main:
	lda C64__SCREEN_CTRL1
	ora #%00010000
	sta C64__SCREEN_CTRL1

main_loop:
	sync_tick(10)
	jmp main_loop

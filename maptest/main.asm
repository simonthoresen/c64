main_init:
	rts

main_irq:
	rts

main:
	sync_tick(10)
	jmp main
	
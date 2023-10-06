.macro readJoyState() {
	lda $dc01
	sta _joy1State

	lda $dc00
	sta _joy2State
}

.macro cmpJoyState(joyState, stateMask) {
	lda joyState
	and #stateMask // AND sets the Z flag, so BEQ and BNE can follow
}

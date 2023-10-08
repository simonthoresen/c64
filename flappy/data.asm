.const SPR_BEAR_MCOL0 = $00
.const SPR_BEAR_MCOL1 = $01

// 2-color sprites are 24x21 pixels
*=$2000

// sprite 0 / multicolor / color: $08
SPR_BEAR_R0:
.byte $00,$00,$00,$00,$11,$40,$00,$66
.byte $40,$00,$69,$40,$00,$5a,$90,$00
.byte $6a,$e0,$00,$6b,$70,$01,$9b,$54
.byte $01,$a7,$64,$01,$aa,$a4,$01,$aa
.byte $58,$01,$9a,$90,$01,$a6,$40,$05
.byte $a9,$00,$06,$6a,$40,$1a,$9a,$40
.byte $1a,$99,$00,$1a,$66,$40,$1a,$56
.byte $90,$1a,$46,$90,$1a,$91,$a4,$88

// sprite 1 / multicolor / color: $08
SPR_BEAR_R1:
.byte $00,$00,$00,$00,$11,$40,$00,$66
.byte $40,$00,$69,$40,$00,$5a,$90,$00
.byte $6a,$e0,$00,$6b,$70,$01,$9b,$54
.byte $01,$a7,$64,$01,$aa,$a4,$01,$aa
.byte $58,$01,$9a,$90,$01,$9a,$40,$01
.byte $a5,$00,$01,$a9,$00,$05,$a6,$00
.byte $06,$66,$40,$06,$9a,$40,$06,$9a
.byte $40,$06,$9a,$40,$06,$a6,$90,$88

// sprite 2 / multicolor / color: $08
SPR_BEAR_R2:
.byte $00,$11,$40,$00,$66,$40,$00,$69
.byte $40,$00,$5a,$90,$00,$6a,$e0,$00
.byte $6b,$70,$01,$ab,$54,$01,$9b,$64
.byte $01,$a6,$a4,$01,$aa,$58,$06,$9a
.byte $90,$06,$9a,$40,$06,$69,$90,$06
.byte $99,$90,$06,$99,$90,$06,$99,$40
.byte $01,$69,$00,$01,$a9,$00,$01,$69
.byte $00,$06,$6a,$40,$06,$6a,$40,$88

// sprite 3 / multicolor / color: $08
SPR_BEAR_R3:
.byte $00,$00,$00,$00,$04,$50,$00,$19
.byte $a0,$00,$1a,$50,$00,$16,$94,$00
.byte $1a,$b8,$00,$1a,$dc,$00,$6a,$d5
.byte $01,$aa,$d9,$06,$aa,$a9,$06,$aa
.byte $96,$1a,$9a,$a4,$1a,$6a,$90,$1a
.byte $6a,$64,$1a,$6a,$69,$05,$aa,$59
.byte $01,$6a,$44,$16,$9a,$90,$1a,$9a
.byte $a4,$1a,$46,$a4,$06,$91,$a4,$88

// sprite 4 / multicolor / color: $08
SPR_BEAR_L0:
.byte $00,$00,$00,$01,$44,$00,$01,$99
.byte $00,$01,$69,$00,$06,$a5,$00,$0b
.byte $a9,$00,$0d,$e9,$00,$15,$e6,$40
.byte $19,$da,$40,$1a,$aa,$40,$25,$aa
.byte $40,$06,$a6,$40,$01,$9a,$40,$00
.byte $6a,$50,$01,$a9,$90,$01,$a6,$a4
.byte $00,$66,$a4,$01,$99,$a4,$06,$95
.byte $a4,$06,$91,$a4,$1a,$46,$a4,$88

// sprite 5 / multicolor / color: $08
SPR_BEAR_L1:
.byte $00,$00,$00,$01,$44,$00,$01,$99
.byte $00,$01,$69,$00,$06,$a5,$00,$0b
.byte $a9,$00,$0d,$e9,$00,$15,$e6,$40
.byte $19,$da,$40,$1a,$aa,$40,$25,$aa
.byte $40,$06,$a6,$40,$01,$a6,$40,$00
.byte $5a,$40,$00,$6a,$40,$00,$9a,$50
.byte $01,$99,$90,$01,$a6,$90,$01,$a6
.byte $90,$01,$a6,$90,$06,$9a,$90,$88

// sprite 6 / multicolor / color: $08
SPR_BEAR_L2:
.byte $01,$44,$00,$01,$99,$00,$01,$69
.byte $00,$06,$a5,$00,$0b,$a9,$00,$0d
.byte $e9,$00,$15,$ea,$40,$19,$e6,$40
.byte $1a,$9a,$40,$25,$aa,$40,$06,$a6
.byte $90,$01,$a6,$90,$06,$69,$90,$06
.byte $66,$90,$06,$66,$90,$01,$66,$90
.byte $00,$69,$40,$00,$6a,$40,$00,$69
.byte $40,$01,$a9,$90,$01,$a9,$90,$88

// sprite 7 / multicolor / color: $08
SPR_BEAR_L3:
.byte $00,$00,$00,$05,$10,$00,$0a,$64
.byte $00,$05,$a4,$00,$16,$94,$00,$2e
.byte $a4,$00,$37,$a4,$00,$57,$a9,$00
.byte $67,$aa,$40,$6a,$aa,$90,$96,$aa
.byte $90,$1a,$a6,$a4,$06,$a9,$a4,$19
.byte $a9,$a4,$69,$a9,$a4,$65,$aa,$50
.byte $11,$a9,$40,$06,$a6,$94,$1a,$a6
.byte $a4,$1a,$91,$a4,$1a,$46,$90,$88

// sprite 8 / multicolor / color: $08
SPR_BEAR_S0:
.byte $00,$00,$00,$05,$01,$40,$1a,$56
.byte $90,$19,$a9,$90,$06,$aa,$40,$06
.byte $ee,$40,$07,$77,$40,$1b,$57,$90
.byte $1b,$57,$90,$6a,$9a,$a4,$6a,$5a
.byte $a4,$66,$a6,$64,$66,$aa,$64,$66
.byte $aa,$64,$69,$a9,$a4,$69,$a9,$a4
.byte $19,$a9,$90,$06,$9a,$40,$1a,$9a
.byte $90,$1a,$9a,$90,$1a,$9a,$90,$88

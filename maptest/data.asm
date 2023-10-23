.var dat = LoadBinary("rambo_v4.ctm")

*=$2800 "Character Set"
/*
.if (dat.uget(3) != $04) .error "unexpected version, got v" + dat.uget(3)
.var len = dat.uget($0a) + dat.uget($0b)*256
.var i = 0;
.for ( ; i < len * 8; i++) {
	.byte dat.uget($18 + i)
}
.for ( ; i < 256 * 8; i++) {
	.byte $00
}
*/

.byte $00,$00,$00,$00,$00,$00,$00,$00,$AA,$FF,$55,$55,$77,$A2,$2A,$8C
.byte $AA,$FF,$55,$55,$55,$FF,$32,$88,$00,$CC,$33,$FC,$F7,$EF,$99,$56
.byte $75,$55,$76,$56,$55,$95,$66,$99,$5A,$65,$99,$56,$65,$9D,$75,$5A
.byte $75,$97,$75,$95,$F7,$95,$57,$75,$AA,$AB,$AA,$BA,$22,$88,$00,$00
.byte $55,$54,$60,$98,$A8,$22,$88,$00,$00,$00,$28,$96,$9D,$7D,$9D,$76
.byte $00,$00,$00,$C0,$B0,$AC,$B0,$AC,$9D,$7F,$9D,$7F,$9D,$7F,$9D,$26
.byte $68,$E0,$68,$E0,$68,$E0,$A8,$00,$1F,$BD,$9F,$7D,$7F,$9F,$7F,$95
.byte $68,$60,$68,$A0,$68,$60,$68,$00,$FF,$AA,$09,$27,$9D,$76,$DA,$55
.byte $FF,$75,$D1,$41,$09,$2B,$AB,$7F,$55,$55,$65,$59,$55,$D5,$7D,$55
.byte $FF,$DD,$F9,$F6,$D9,$F6,$7A,$5A,$DA,$6A,$9A,$A6,$AA,$6A,$A6,$AA
.byte $BA,$EE,$B8,$EA,$A0,$E8,$80,$A0,$00,$00,$0A,$43,$0B,$AB,$1F,$7F
.byte $81,$43,$85,$52,$81,$43,$89,$42,$F3,$3E,$C9,$3A,$F5,$E6,$E5,$A5
.byte $BB,$AA,$6F,$AA,$BB,$AA,$EF,$FA,$FE,$54,$A1,$08,$82,$09,$27,$0F
.byte $00,$00,$00,$08,$02,$08,$02,$08,$AA,$22,$00,$00,$22,$88,$55,$11
.byte $02,$08,$02,$08,$22,$8A,$55,$55,$F7,$AE,$6A,$A8,$AA,$2A,$AA,$A6
.byte $5F,$2F,$07,$0B,$23,$03,$2F,$9F,$81,$43,$81,$C2,$81,$43,$81,$EB
.byte $B5,$00,$0D,$3D,$0D,$3D,$0D,$B5,$FF,$A5,$FF,$7D,$FF,$FF,$7D,$A5
.byte $DA,$00,$60,$E8,$D8,$EA,$00,$AA,$D9,$0A,$81,$C2,$8A,$C2,$C2,$80
.byte $8A,$02,$0A,$C2,$8A,$C2,$8A,$02,$B9,$00,$39,$0D,$39,$0D,$3A,$B9
.byte $88,$01,$8A,$81,$82,$80,$00,$00,$94,$21,$09,$82,$2C,$9D,$75,$D4
.byte $0A,$2F,$AD,$2E,$AC,$2C,$AC,$2C,$95,$FF,$DD,$EE,$CC,$CC,$CC,$CC
.byte $00,$F6,$D4,$D6,$E4,$C6,$C4,$C6,$AC,$24,$AC,$24,$A4,$2A,$0A,$00
.byte $CC,$44,$CC,$44,$88,$AA,$AA,$00,$C8,$C8,$C8,$48,$48,$A8,$A0,$00
.byte $94,$25,$A5,$95,$59,$95,$26,$09,$0D,$35,$36,$D9,$AA,$22,$88,$00
.byte $7F,$55,$5F,$5F,$5F,$5F,$6F,$67,$FF,$5A,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$AB,$F9,$FB,$F1,$FB,$D1,$59,$57,$95,$54,$09,$09,$09,$0A,$09
.byte $6D,$67,$65,$65,$6A,$40,$6A,$00,$FD,$B7,$DE,$B9,$AA,$00,$AA,$00
.byte $52,$5A,$62,$9A,$AA,$02,$AA,$00,$0A,$09,$02,$09,$02,$0A,$0A,$00
.byte $82,$09,$27,$9F,$9F,$27,$89,$82,$00,$55,$FF,$FF,$FF,$FF,$55,$00
.byte $82,$60,$D8,$F6,$F6,$D8,$60,$82,$9F,$7D,$75,$75,$76,$98,$76,$00
.byte $15,$3F,$15,$2A,$00,$22,$2A,$00,$55,$FF,$55,$AA,$00,$AA,$00,$00
.byte $9D,$24,$9D,$9D,$9E,$9D,$9E,$9E,$CC,$08,$8C,$C8,$8C,$C8,$8C,$88
.byte $9E,$9E,$9E,$9E,$9E,$A4,$9E,$A4,$56,$FD,$56,$A8,$00,$A8,$00,$00
.byte $D6,$56,$58,$A0,$00,$00,$00,$00,$05,$04,$00,$08,$08,$22,$88,$00
.byte $08,$09,$09,$0A,$09,$09,$09,$08,$2F,$25,$25,$2A,$00,$00,$00,$00
.byte $00,$00,$2A,$9E,$1E,$1E,$9E,$9E,$00,$00,$08,$00,$08,$08,$04,$08
.byte $54,$FC,$54,$A8,$00,$A8,$00,$00,$7E,$FE,$F6,$58,$A0,$00,$00,$00
.byte $08,$08,$08,$08,$02,$08,$00,$00,$9E,$9E,$9E,$9D,$9D,$24,$9E,$00
.byte $0B,$09,$08,$09,$09,$09,$0A,$09,$28,$96,$7D,$96,$28,$00,$28,$00
.byte $AA,$AA,$00,$FF,$FF,$FF,$FF,$FF,$A8,$A8,$08,$F8,$F8,$F8,$F8,$F8
.byte $FF,$F0,$F0,$F4,$30,$74,$30,$00,$F8,$F8,$F8,$F8,$08,$88,$08,$88
.byte $00,$AA,$FF,$AA,$AA,$00,$AA,$45,$08,$A8,$58,$A8,$A8,$00,$8A,$51
.byte $95,$7F,$FD,$F5,$FD,$F5,$55,$AA,$A8,$D6,$58,$56,$58,$60,$56,$A0
.byte $0A,$3E,$0A,$3E,$0A,$3E,$0A,$3E,$3A,$0E,$3A,$0E,$32,$0C,$00,$00
.byte $00,$00,$00,$0C,$0F,$0E,$0E,$0E,$AA,$AA,$80,$8F,$8F,$8F,$8F,$8F
.byte $8F,$8F,$8F,$8F,$80,$80,$8C,$80,$8C,$80,$AA,$AA,$AA,$00,$A8,$51
.byte $FF,$55,$00,$AA,$A9,$A8,$A8,$A0,$56,$AA,$02,$FE,$FE,$FE,$FE,$FE
.byte $A5,$AA,$00,$2A,$2A,$2A,$2A,$2A,$6A,$40,$00,$40,$00,$40,$00,$00
.byte $3E,$3E,$3E,$1E,$02,$CE,$02,$CE,$0F,$0F,$0C,$0C,$0C,$00,$0C,$00
.byte $02,$AA,$F6,$AA,$AA,$00,$AA,$45,$00,$AA,$FF,$AA,$AA,$00,$AA,$45
.byte $9E,$9E,$9E,$9E,$24,$9E,$24,$9E,$9E,$9E,$1E,$1E,$1E,$1E,$1E,$1E
.byte $0A,$0A,$00,$0F,$0F,$0F,$0F,$0F,$38,$5E,$3C,$1E,$3C,$5E,$3C,$1E
.byte $00,$00,$03,$00,$03,$00,$03,$00,$56,$7E,$9E,$BE,$9E,$3E,$9E,$7E
.byte $03,$00,$0A,$0A,$0A,$00,$0A,$04,$58,$F6,$FD,$7D,$9D,$00,$9E,$00
.byte $57,$65,$94,$25,$29,$05,$0A,$09,$A0,$58,$F4,$7E,$9D,$00,$9D,$00
.byte $52,$62,$12,$22,$22,$22,$20,$20,$75,$75,$5D,$5E,$60,$90,$54,$45
.byte $75,$75,$1D,$9E,$20,$80,$00,$00,$CB,$C9,$C8,$CA,$C9,$C9,$CA,$CA
.byte $77,$1D,$34,$9E,$77,$DD,$77,$DD,$B0,$30,$30,$B0,$70,$F0,$70,$F0
.byte $CB,$CB,$C8,$C9,$C9,$C9,$FF,$00,$57,$17,$14,$55,$75,$57,$FF,$00
.byte $B0,$30,$30,$70,$70,$70,$F0,$00,$00,$FF,$D5,$C0,$CA,$CA,$C9,$C9
.byte $00,$FF,$55,$00,$AA,$AA,$55,$55,$00,$F8,$78,$38,$B8,$B8,$78,$78
.byte $CB,$CB,$C8,$C9,$C9,$CB,$C9,$C9,$67,$99,$58,$A4,$08,$88,$80,$00
.byte $94,$48,$20,$A0,$00,$80,$00,$00,$03,$02,$02,$32,$3F,$0F,$00,$00
.byte $FF,$AA,$09,$27,$9D,$76,$DA,$55,$00,$CC,$33,$FC,$F7,$EF,$99,$56
.byte $FF,$DD,$F9,$F6,$D9,$F6,$7A,$5A,$AA,$FF,$55,$55,$77,$A2,$2A,$8C
.byte $AA,$FF,$55,$55,$77,$A2,$2A,$8C,$BA,$EE,$B8,$EA,$A0,$E8,$80,$A0
.byte $00,$00,$03,$00,$03,$00,$03,$00,$57,$95,$FB,$EE,$40,$20,$5A,$55
.byte $55,$45,$EE,$AA,$00,$A0,$B2,$E2,$54,$15,$FF,$AA,$00,$00,$AA,$FF
.byte $54,$65,$FF,$AA,$00,$00,$A2,$F2,$A2,$E2,$A2,$E2,$A0,$E0,$A0,$E0
.byte $41,$14,$FF,$BB,$00,$00,$AA,$55,$E2,$A2,$E2,$A2,$00,$00,$AA,$55
.byte $E2,$A1,$E2,$A0,$E0,$A2,$E0,$00,$54,$65,$FF,$FF,$00,$00,$3F,$3F
.byte $54,$65,$EE,$BB,$00,$A0,$E2,$E2,$57,$95,$E4,$B2,$02,$02,$AA,$55
.byte $34,$31,$2F,$2A,$00,$00,$AA,$55,$1B,$4F,$FF,$FF,$00,$00,$AA,$55
.byte $F2,$F2,$F2,$72,$F2,$72,$D2,$72,$AA,$FF,$55,$55,$77,$A2,$2A,$8C
.byte $75,$55,$76,$56,$55,$95,$66,$99
.fill $800 - $4A8, $00

// per-char attributes, 149 chars, $9a
*=$3000 "Character Attributes"
.byte $F0,$AA,$FA,$CE,$FB,$2B,$FD,$0A,$0B,$DB,$0E,$0B,$0D,$0B,$FF,$0B
.byte $FB,$5B,$0B,$0B,$FA,$36,$06,$0E,$F8,$36,$7B,$FB,$AB,$FB,$96,$06
.byte $FA,$F9,$FB,$9A,$FA,$8A,$FA,$FB,$F9,$09,$F9,$0B,$0B,$FB,$7B,$7B
.byte $FF,$9F,$3F,$0B,$FF,$0F,$1F,$8E,$FF,$19,$7F,$09,$0B,$F9,$09,$F6
.byte $FB,$09,$FB,$FB,$0B,$0B,$FF,$06,$09,$09,$06,$09,$FB,$09,$FE,$FE
.byte $FE,$0E,$0B,$1E,$AB,$6B,$0E,$0E,$0E,$5E,$1E,$4B,$4B,$3E,$4E,$F6
.byte $0E,$DE,$8D,$0D,$39,$9B,$FE,$5B,$FE,$0B,$0B,$F9,$FB,$3B,$1B,$2B
.byte $FB,$A9,$AB,$FB,$FB,$FB,$FB,$C9,$CF,$3B,$F9,$FD,$FB,$0E,$FB,$FE
.byte $FB,$FC,$AC,$FE,$F8,$FC,$FC,$FC,$1A,$FC,$FC,$1A,$AA,$DA,$4C,$FC
.byte $FA,$FA,$FC,$BC,$FC

/*
.byte $00,$00,$00,$00,$00,$00,$00,$00,$38,$6C,$C6,$C6,$FE,$C6,$C6,$00
.byte $F8,$CC,$CC,$F8,$CC,$C6,$FC,$00,$3C,$66,$C0,$C0,$C0,$66,$3C,$00
.byte $F8,$CC,$C6,$C6,$C6,$CC,$F8,$00,$FC,$C6,$C0,$F8,$C0,$C6,$FC,$00
.byte $FC,$C6,$C0,$F8,$C0,$C0,$C0,$00,$3C,$66,$C0,$DE,$C6,$66,$3C,$00
.byte $C6,$C6,$C6,$FE,$C6,$C6,$C6,$00,$7E,$D8,$18,$18,$18,$18,$7E,$00
.byte $7E,$CC,$0C,$0C,$0C,$D8,$70,$00,$C6,$CC,$D8,$F0,$D8,$CC,$C6,$00
.byte $C0,$C0,$C0,$C0,$C0,$C6,$FC,$00,$C6,$EE,$FE,$D6,$C6,$C6,$C6,$00
.byte $DC,$F6,$E6,$C6,$C6,$C6,$C6,$00,$38,$6C,$C6,$C6,$C6,$6C,$38,$00
.byte $FC,$C6,$C6,$FC,$C0,$C0,$C0,$00,$38,$6C,$C6,$C6,$CA,$6C,$36,$00
.byte $FC,$C6,$C6,$FC,$D8,$CC,$C6,$00,$7C,$C6,$C0,$7C,$0E,$C6,$7C,$00
.byte $7E,$D8,$18,$18,$18,$18,$18,$00,$C6,$C6,$C6,$C6,$C6,$C6,$7C,$00
.byte $C6,$C6,$C6,$C6,$6C,$38,$10,$00,$C6,$D6,$D6,$FE,$EE,$C6,$82,$00
.byte $C6,$C6,$6C,$38,$6C,$C6,$C6,$00,$C6,$C6,$C6,$6C,$38,$30,$60,$00
.byte $7E,$C6,$0C,$18,$30,$66,$FC,$00,$3C,$42,$99,$A1,$A1,$99,$42,$3C
.byte $05,$29,$2B,$AF,$7F,$5A,$6A,$BA,$05,$5A,$AA,$AF,$ED,$F5,$B6,$BA
.byte $00,$D0,$58,$EB,$FE,$AF,$AB,$BF,$FE,$6F,$6B,$5A,$EF,$2A,$1A,$05
.byte $FF,$D7,$69,$69,$BE,$F6,$BA,$70,$DF,$6A,$6A,$BA,$FC,$E8,$A0,$80
.byte $00,$01,$05,$16,$16,$6B,$6B,$9F,$05,$59,$AA,$AB,$E7,$DE,$BE,$B6
.byte $40,$64,$68,$AA,$AA,$F6,$BB,$EB,$59,$6F,$6D,$77,$1A,$19,$1B,$0A
.byte $5A,$6B,$AB,$BD,$F6,$A6,$BB,$FE,$FB,$DF,$6B,$FF,$AE,$BC,$9C,$E0
.byte $00,$01,$05,$05,$06,$15,$19,$5A,$05,$55,$5A,$99,$75,$D6,$9A,$5B
.byte $40,$64,$68,$A8,$6A,$A6,$BA,$EB,$59,$59,$6D,$7A,$26,$19,$1B,$0A
.byte $5A,$6B,$AF,$BE,$EB,$AA,$BB,$FF,$FB,$EF,$AB,$BF,$AC,$BC,$FC,$F0
.byte $00,$04,$69,$18,$AE,$30,$00,$00,$00,$00,$48,$44,$22,$38,$00,$00
.byte $38,$6C,$C6,$C6,$C6,$C6,$6C,$38,$18,$78,$18,$18,$18,$18,$18,$3C
.byte $7C,$C6,$06,$0C,$18,$30,$66,$FE,$7C,$C6,$06,$3C,$0C,$06,$C6,$7C
.byte $1C,$3C,$6C,$CC,$CC,$FE,$0C,$0C,$FC,$C6,$C0,$FC,$06,$06,$CC,$78
.byte $3C,$66,$C0,$FC,$C6,$C6,$6C,$38,$7E,$C6,$06,$0C,$18,$30,$60,$C0
.byte $38,$6C,$C6,$7C,$C6,$C6,$6C,$38,$38,$6C,$C6,$C6,$7E,$06,$CC,$78
.byte $67,$AE,$AB,$AB,$AB,$AE,$AD,$BD,$55,$56,$5A,$6A,$6A,$6A,$AA,$AB
.byte $E9,$F5,$B6,$B6,$B6,$B6,$F6,$F6,$EA,$57,$6B,$AA,$AA,$AA,$AB,$AB
.byte $AF,$BD,$F5,$D6,$DA,$DA,$DA,$DA,$FA,$BF,$AD,$AD,$BD,$AD,$AD,$BD
.byte $6F,$FD,$D6,$DA,$DA,$DA,$DA,$B6,$DA,$B6,$AD,$AF,$AB,$AB,$AF,$AF
.byte $BF,$F7,$D5,$5A,$6A,$6A,$6A,$6A,$5D,$AD,$AD,$FF,$55,$6A,$6A,$FF
.byte $55,$AA,$AA,$FF,$75,$B6,$B6,$FF,$D5,$DA,$DA,$FF,$57,$AB,$AB,$FF
.byte $FF,$FF,$D5,$D5,$DF,$D7,$D5,$D5,$FF,$FF,$55,$7D,$FF,$FF,$FF,$7D
.byte $FF,$FE,$56,$56,$F6,$D6,$56,$56,$D5,$D5,$D7,$DF,$D5,$D5,$EA,$AA
.byte $7D,$FF,$FF,$FF,$7D,$55,$AA,$AA,$56,$56,$D6,$F6,$56,$56,$AA,$AA
.byte $55,$55,$7F,$7F,$7A,$7A,$7A,$7A,$55,$55,$FF,$FF,$AA,$AA,$AA,$AA
.byte $55,$57,$FF,$F7,$A7,$A7,$A7,$A7,$7A,$7A,$7A,$7A,$7A,$65,$BF,$FF
.byte $AA,$AA,$AA,$AA,$AA,$55,$FF,$FF,$A7,$A7,$A7,$A7,$A7,$57,$FF,$FF
.byte $54,$6B,$AB,$AF,$B0,$C0,$00,$00,$54,$6B,$AB,$FB,$0F,$03,$00,$00
.byte $00,$0F,$AF,$B5,$35,$D5,$D5,$AA,$00,$F0,$DA,$6A,$58,$5A,$56,$AA
.byte $00,$00,$AA,$FF,$00,$AA,$FF,$00,$FE,$E6,$C2,$C0,$E0,$FA,$FE,$CC
.byte $03,$07,$FF,$FF,$3F,$1F,$3F,$7F,$C0,$E0,$FF,$FF,$FC,$F8,$FC,$FE
.byte $00,$96,$EB,$FF,$BE,$BE,$96,$EB,$5A,$6B,$AF,$BE,$EB,$AA,$BB,$FF
.byte $FB,$EF,$AB,$BF,$AC,$BC,$FC,$F0,$FF,$F7,$FF,$F7,$FF,$F7,$54,$20
.byte $F7,$F7,$F7,$F7,$F7,$F7,$59,$59,$55,$55,$55,$55,$55,$55,$AA,$AA
.byte $9A,$9A,$9A,$9A,$9A,$9A,$EF,$EF,$BF,$BF,$BF,$BF,$BF,$BF,$FF,$FC
.byte $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
.byte $55,$55,$55,$55,$55,$55,$55,$55,$9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$3F,$57,$FF,$F7,$FF,$F7,$F7,$FF
.byte $FF,$FF,$F7,$F7,$F7,$F7,$F7,$F7,$FF,$FF,$55,$55,$55,$55,$55,$55
.byte $55,$55,$9A,$9A,$9A,$9A,$9A,$9A,$A8,$BF,$BF,$BF,$BF,$BF,$BF,$BF
.byte $0A,$2F,$BF,$BF,$BF,$BF,$BB,$A2,$AA,$FF,$FF,$FF,$FF,$FF,$EB,$96
.byte $A0,$F8,$FE,$FE,$FE,$FE,$EE,$8A,$55,$AA,$3E,$0B,$0B,$1E,$AA,$FF
.byte $55,$AA,$BE,$EB,$EB,$BE,$AA,$FF,$55,$AA,$BC,$E0,$E0,$B8,$AA,$FF
.byte $10,$38,$38,$38,$38,$38,$38,$38,$00,$00,$00,$00,$00,$00,$40,$E0
.byte $04,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$00,$00,$00,$08,$1C,$1C,$1C,$1C
.byte $00,$01,$07,$0F,$1F,$3C,$79,$FF,$3C,$FF,$FF,$FF,$FF,$EF,$FF,$EF
.byte $00,$80,$E0,$F0,$F8,$3C,$9E,$FF,$6A,$AB,$AB,$AB,$AB,$AF,$AF,$BC
.byte $FC,$58,$78,$AC,$AC,$BC,$B0,$B0,$B0,$E0,$70,$B0,$B0,$C0,$C0,$C0
.byte $15,$56,$5A,$5A,$6A,$6A,$6A,$1A,$2F,$15,$16,$1A,$1A,$1A,$1A,$06
.byte $06,$06,$07,$05,$01,$01,$01,$01,$C3,$63,$23,$36,$3E,$7E,$6F,$CD
.byte $07,$06,$86,$CC,$7C,$3C,$0E,$9B,$8C,$CC,$D8,$5C,$7E,$26,$63,$C1
.byte $71,$63,$32,$3E,$7C,$CC,$8E,$87,$FF,$55,$6A,$6A,$6A,$6A,$6A,$FF
.byte $FF,$57,$AB,$AB,$AB,$AB,$AB,$FF,$FF,$57,$6B,$6B,$6B,$6B,$6B,$FF
.byte $02,$19,$16,$1A,$45,$26,$5A,$1A,$A0,$58,$22,$99,$6A,$AA,$98,$16
.byte $48,$54,$68,$A0,$6A,$96,$98,$20,$00,$04,$16,$1A,$44,$26,$11,$04
.byte $00,$58,$22,$59,$14,$62,$98,$00,$40,$14,$48,$A0,$59,$44,$90,$00
.byte $00,$00,$01,$04,$00,$15,$01,$00,$00,$44,$52,$11,$49,$04,$90,$00
.byte $40,$64,$10,$84,$14,$60,$00,$00,$00,$00,$00,$00,$00,$00,$A5,$5A
.byte $56,$5A,$6B,$6A,$6B,$6A,$6B,$BF,$AF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $95,$5A,$AB,$6A,$6B,$AA,$6B,$BF,$16,$1E,$17,$1B,$5A,$6A,$6A,$BF
.byte $BA,$AB,$AF,$BF,$FF,$BF,$FF,$FF,$BA,$DA,$F6,$FF,$FD,$FE,$FF,$FF
.byte $BE,$DB,$DB,$6B,$AB,$AB,$6B,$BF,$00,$00,$00,$00,$00,$01,$06,$06
.byte $00,$00,$01,$15,$5A,$7A,$BA,$BA,$00,$00,$5A,$AB,$AE,$AE,$BA,$BA
.byte $00,$00,$55,$AB,$EA,$BB,$BA,$AF,$55,$AA,$BB,$EE,$BB,$EF,$EF,$FF
.byte $AE,$BE,$BE,$EE,$BE,$FE,$BE,$FF,$80,$80,$B0,$A8,$BC,$EC,$BE,$FE
.byte $00,$00,$55,$BA,$FA,$BF,$EE,$FF,$00,$00,$00,$40,$A0,$AC,$BF,$FF
.byte $7E,$24,$BD,$A5,$FF,$66,$FF,$BD,$1F,$1F,$3F,$3F,$7F,$7F,$FF,$FF
.byte $01,$01,$03,$03,$07,$07,$0F,$0F,$80,$80,$C0,$C0,$E0,$E0,$F0,$F0
.byte $F8,$F8,$FC,$FC,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $01,$03,$06,$0C,$19,$33,$67,$CF,$CF,$67,$33,$19,$0C,$06,$03,$01
.byte $80,$C0,$60,$30,$98,$CC,$E6,$F3,$F3,$E6,$CC,$98,$30,$60,$C0,$80
.byte $00,$00,$00,$05,$0F,$1F,$0F,$6F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $F8,$FE,$FC,$FA,$FC,$FE,$FF,$FE,$FF,$3F,$1F,$3B,$07,$1F,$7F,$3F
.byte $00,$82,$96,$EB,$DF,$FF,$FF,$F7,$00,$00,$00,$80,$84,$D8,$BC,$FE
.byte $FF,$FB,$37,$63,$07,$0F,$1B,$03,$FF,$FE,$EC,$C4,$F0,$E0,$30,$90
.byte $F7,$77,$97,$EB,$D9,$FA,$36,$CE,$FD,$F5,$DB,$EF,$AA,$A7,$B3,$8F
.byte $00,$0D,$3F,$1F,$57,$57,$57,$5F,$5F,$7F,$FF,$FF,$F5,$D5,$D5,$D5
.byte $D5,$D5,$F5,$FF,$7F,$5F,$5F,$5F,$00,$70,$7C,$FC,$F5,$D5,$D5,$D5
.byte $FF,$3F,$00,$00,$00,$00,$00,$00,$D5,$F5,$FF,$2A,$25,$16,$15,$16
.byte $5F,$7F,$FF,$A8,$A8,$A8,$A8,$A8,$F5,$FC,$00,$00,$00,$00,$00,$00
.byte $35,$15,$35,$D5,$7D,$F5,$DD,$FF,$A8,$A8,$6A,$AB,$6A,$AB,$6A,$5A
.byte $03,$37,$1B,$7F,$2F,$FF,$7F,$FF,$3C,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $80,$E8,$D8,$F4,$FC,$FF,$FE,$FF,$7F,$BF,$FF,$7F,$3F,$7F,$FF,$7F
.byte $FE,$FD,$FD,$FF,$FE,$FC,$F5,$FA,$FF,$3F,$7F,$3F,$0D,$03,$02,$00
.byte $FF,$FF,$FF,$FF,$FF,$FD,$D7,$5A,$F1,$DB,$F6,$A8,$F8,$60,$80,$00
.byte $DA,$F6,$D6,$DA,$F6,$D6,$F6,$DA,$7F,$67,$43,$03,$07,$4F,$7F,$33
.byte $03,$01,$33,$3F,$5F,$FF,$3F,$06,$3F,$DF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $00,$00,$00,$8C,$DE,$EF,$FF,$FF,$00,$00,$30,$3B,$5D,$F7,$FF,$FF
.byte $EC,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$C0,$80,$F0,$E0,$FC,$FF,$FC,$68
.byte $FF,$DF,$F7,$57,$F6,$FD,$FD,$FF,$FF,$FF,$F7,$DF,$D9,$67,$6F,$AF
.byte $00,$00,$00,$00,$00,$03,$2E,$78,$00,$00,$00,$00,$00,$B0,$C3,$7B
.byte $00,$00,$00,$00,$00,$10,$7C,$A3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $D5,$DA,$DB,$FF,$5F,$BF,$BF,$FF,$5D,$BF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $55,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$DA,$DA,$FF,$F5,$FE,$FE,$FF
.byte $5D,$AD,$ED,$FF,$F5,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $08,$1B,$3F,$1F,$3F,$3B,$75,$FA,$00,$C6,$FF,$FF,$FF,$FF,$FF,$FF
.byte $00,$00,$FE,$FF,$FF,$FF,$DA,$75,$00,$1D,$FF,$FF,$FF,$7F,$AF,$55
.byte $80,$C0,$E0,$F4,$FE,$FF,$FF,$7F,$75,$7E,$3F,$07,$07,$03,$00,$00
.byte $AA,$DD,$77,$9F,$FE,$F0,$C0,$00,$BF,$FF,$D7,$29,$FF,$33,$00,$00
.byte $55,$AA,$F7,$7F,$BC,$FF,$0C,$00,$FC,$F0,$98,$38,$F0,$C0,$00,$00
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$5D,$AD,$AD,$FF,$55,$6A,$6A,$FF
.byte $55,$AA,$AA,$FF,$75,$B6,$B6,$FF,$15,$57,$5D,$35,$15,$57,$5D,$35
.byte $D6,$5B,$6D,$B6,$D6,$5B,$6D,$B6,$DA,$6C,$BC,$B5,$DA,$6C,$BC,$B5
.byte $55,$AA,$AA,$FF,$75,$B6,$B6,$FF,$55,$AA,$AA,$FF,$75,$B6,$B6,$FF
.byte $01,$03,$01,$03,$03,$01,$02,$0B,$00,$82,$02,$84,$C6,$90,$D1,$C7
.byte $00,$00,$00,$10,$10,$B0,$A0,$90,$0B,$0F,$0F,$07,$0F,$07,$03,$05
.byte $EF,$FE,$FF,$FF,$F7,$3B,$FF,$EF,$E8,$E8,$D8,$F8,$F0,$F0,$F0,$A0
.byte $FF,$FF,$55,$7D,$FF,$FF,$FF,$7D,$0F,$3D,$7F,$0F,$03,$79,$3F,$0F
.byte $01,$E3,$F7,$FF,$FF,$F7,$E3,$01,$81,$C7,$EF,$FF,$FF,$EF,$C7,$81
.byte $FC,$B8,$F0,$E0,$80,$10,$F8,$FC,$18,$2C,$46,$C7,$B9,$7A,$3C,$18
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E7
.byte $FF,$FF,$FF,$FF,$E7,$C3,$81,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$08,$08,$08,$18
.byte $18,$18,$18,$18,$18,$18,$18,$18,$19,$19,$19,$19,$19,$19,$18,$18
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$18,$18,$18,$18,$18,$18
.byte $18,$18,$18,$08,$08,$08,$0F,$0F,$0F,$0F,$0F,$0F,$38,$18,$18,$18
.byte $18,$18,$18,$18,$0F,$0F,$08,$00,$00,$00,$18,$18,$18,$01,$0F,$1F
.byte $08,$08,$01,$0F,$0F,$18,$08,$01,$0F,$1F,$08,$08,$0D,$0D,$1D,$18
.byte $18,$18,$01,$01,$01,$01,$00,$00,$00,$08,$08,$08,$08,$08,$08,$03
.byte $03,$03,$03,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$06
.byte $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
.byte $00,$02,$02,$02,$02,$02,$01,$03,$03,$06,$05,$0D,$05,$05,$05,$05
.byte $05,$05,$0D,$0D,$1A,$1A,$2A,$9A,$1A,$2A,$2A,$2A,$0F,$18,$05,$2D
.byte $05,$05,$05,$05,$1D,$05,$1B,$00,$05,$05,$05,$05,$05,$05,$0D,$0D
.byte $01,$01,$01,$06,$18,$18,$18,$08,$08,$08,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$08,$08,$08,$18,$18,$18,$28,$28,$02,$02,$02,$02
.byte $02,$02,$2F,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07

 */
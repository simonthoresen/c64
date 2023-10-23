
; Generated by CharPad C64 - Subchrist Software, 2003 - 2023.
; Assemble with 64TASS or similar.


; Display mode : Text (Multi-colour).
; Matrix colouring method : Per Character.


; Colour values...

COLR_VIC_BG0 = 0
COLR_VIC_BG1 = 14
COLR_VIC_BG2 = 6
COLR_CMLO_BASE = 3


; Quantities and dimensions...

CHAR_COUNT = 149
TILE_COUNT = 121
TILE_WID = 4
TILE_HEI = 4
MAP_WID = 40
MAP_HEI = 10
MAP_WID_CHRS = 160
MAP_HEI_CHRS = 40
MAP_WID_PXLS = 1280
MAP_HEI_PXLS = 320


; Data block sizes (in bytes)...

SZ_CHARSET_DATA = 1192 ; ($4A8)
SZ_CHARSET_ATTRIB_DATA = 149 ; ($95)
SZ_TILESET_DATA = 1936 ; ($790)
SZ_MAP_DATA = 400 ; ($190)


; Data block addresses (dummy values)...

addr_charset_data = $1000
addr_charset_attrib_L1_data = $1000
addr_chartileset_data = $1000
addr_chartileset_tag_data = $1000
addr_map_data = $1000




; * INSERT EXAMPLE PROGRAM HERE! * (or just include this file in your project).




; CharSet Data...
; 149 images, 8 bytes per image, total size is 1192 ($4A8) bytes.

* = addr_charset_data
charset_data

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



; CharSet Attribute (L1) Data...
; 149 attributes, 1 attribute per image, 8 bits per attribute, total size is 149 ($95) bytes.
; nb. Upper nybbles = material, lower nybbles = colour (colour matrix low).

* = addr_charset_attrib_L1_data
charset_attrib_L1_data

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



; CharTileSet Data...
; 121 tiles, 4x4 (16) cells per tile, 8 bits per cell, total size is 1936 ($790) bytes.

* = addr_chartileset_data
chartileset_data

.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$01,$01
.byte $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $04,$05,$06,$04,$05,$04,$04,$04,$07,$07,$07,$08,$01,$02,$01,$01
.byte $03,$03,$03,$03,$06,$06,$06,$04,$05,$06,$05,$04,$06,$05,$04,$06
.byte $09,$0A,$03,$03,$0B,$0C,$06,$04,$0B,$0C,$04,$04,$0B,$0C,$04,$06
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$07,$01,$02,$01,$01
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$07,$0F,$10,$0F,$10
.byte $04,$04,$11,$04,$11,$04,$04,$11,$07,$07,$07,$07,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$12,$07,$07,$12,$13,$01,$02,$01,$01
.byte $12,$13,$13,$14,$13,$13,$14,$15,$13,$13,$16,$07,$02,$01,$01,$01
.byte $15,$17,$06,$04,$17,$06,$04,$06,$07,$07,$07,$07,$01,$02,$01,$01
.byte $04,$04,$06,$04,$06,$04,$04,$12,$04,$04,$12,$13,$04,$12,$13,$13
.byte $12,$13,$18,$18,$13,$18,$14,$19,$18,$14,$15,$17,$14,$15,$17,$04
.byte $18,$1A,$03,$03,$1B,$1C,$06,$04,$04,$06,$04,$04,$06,$04,$04,$06
.byte $04,$04,$05,$04,$06,$05,$04,$04,$07,$07,$07,$07,$0F,$12,$1D,$1D
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$07,$1D,$1E,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$12,$07,$07,$12,$13,$0F,$10,$0F,$10
.byte $12,$13,$18,$14,$13,$18,$18,$16,$18,$18,$18,$1F,$0F,$10,$0F,$10
.byte $20,$21,$22,$23,$20,$21,$22,$24,$25,$21,$22,$26,$01,$02,$01,$01
.byte $20,$21,$22,$23,$20,$21,$22,$24,$25,$21,$22,$26,$0F,$10,$0F,$10
.byte $03,$03,$03,$03,$27,$06,$06,$04,$04,$06,$04,$04,$06,$04,$04,$06
.byte $03,$03,$03,$03,$28,$29,$29,$2A,$2B,$2C,$2C,$2D,$06,$04,$04,$06
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$04,$07,$07,$07,$08,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$2E,$04,$04,$04,$2F,$07,$07,$07,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$30,$31,$32,$33,$34,$35,$36,$37,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$30,$31,$32,$33,$34,$35,$36,$37,$01,$02,$01,$01
.byte $38,$39,$39,$3A,$06,$06,$06,$04,$04,$06,$04,$05,$06,$04,$05,$06
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$3B,$01,$02,$01,$01
.byte $04,$04,$06,$04,$06,$04,$04,$04,$3C,$3D,$3D,$3D,$01,$02,$01,$01
.byte $04,$04,$3E,$3F,$06,$04,$40,$3F,$3D,$41,$42,$43,$01,$02,$01,$01
.byte $35,$36,$44,$04,$30,$31,$32,$33,$34,$35,$36,$45,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$04,$3D,$3D,$3D,$3D,$01,$02,$01,$01
.byte $03,$03,$46,$47,$06,$06,$3E,$3F,$04,$06,$3E,$3F,$06,$04,$3E,$3F
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$3D,$3D,$3D,$48,$0F,$10,$0F,$10
.byte $3E,$3F,$3E,$3F,$40,$3F,$3E,$3F,$49,$4A,$4B,$4A,$0F,$10,$0F,$10
.byte $46,$47,$46,$47,$3E,$3F,$3E,$3F,$3E,$3F,$3E,$3F,$3E,$3F,$3E,$3F
.byte $3E,$3F,$3E,$3F,$3E,$3F,$3E,$3F,$4B,$4A,$4B,$4A,$0F,$10,$0F,$10
.byte $04,$04,$3E,$3F,$06,$04,$3E,$3F,$3B,$3C,$3D,$3D,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$04,$3D,$3D,$3D,$3D,$0F,$10,$0F,$10
.byte $3E,$3F,$3E,$3F,$30,$31,$32,$4C,$34,$35,$36,$45,$0F,$10,$0F,$10
.byte $04,$04,$3E,$3F,$06,$04,$3E,$3F,$4D,$3C,$3D,$3D,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$12,$07,$07,$12,$13,$1D,$1E,$0F,$10
.byte $4E,$4F,$03,$03,$50,$51,$06,$04,$52,$53,$04,$04,$04,$04,$04,$06
.byte $54,$55,$56,$04,$54,$55,$56,$04,$54,$55,$57,$07,$0F,$10,$0F,$10
.byte $54,$55,$58,$03,$54,$55,$56,$04,$54,$55,$56,$04,$54,$55,$56,$06
.byte $04,$04,$06,$04,$30,$32,$33,$04,$34,$36,$37,$07,$0F,$10,$0F,$10
.byte $04,$04,$54,$55,$04,$04,$54,$55,$07,$07,$54,$55,$0F,$10,$0F,$10
.byte $03,$03,$55,$55,$04,$04,$54,$55,$04,$04,$54,$55,$04,$04,$54,$55
.byte $04,$04,$54,$55,$04,$04,$54,$55,$3D,$3D,$54,$55,$0F,$10,$0F,$10
.byte $54,$55,$58,$59,$54,$55,$56,$5A,$54,$55,$56,$5B,$54,$55,$56,$06
.byte $5C,$5C,$5D,$5E,$5F,$5F,$60,$61,$52,$52,$62,$63,$06,$04,$04,$06
.byte $5C,$5C,$5D,$5E,$5F,$5F,$60,$61,$52,$52,$62,$63,$06,$04,$04,$30
.byte $04,$04,$04,$04,$06,$04,$3B,$3C,$3B,$3C,$3D,$3D,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$0F,$10,$0F,$10
.byte $04,$04,$06,$34,$3D,$30,$31,$32,$3D,$34,$35,$36,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$30,$31,$32,$45,$34,$35,$36,$45,$0F,$10,$0F,$10
.byte $64,$3F,$3E,$3F,$49,$4A,$64,$3F,$3D,$41,$49,$4A,$0F,$10,$0F,$10
.byte $5C,$4F,$54,$55,$5F,$51,$54,$55,$52,$53,$54,$55,$04,$04,$54,$55
.byte $65,$66,$65,$66,$67,$68,$67,$68,$69,$6A,$69,$6A,$3E,$3F,$3E,$3F
.byte $5C,$5C,$65,$66,$5F,$5F,$67,$68,$52,$52,$69,$6A,$06,$04,$3E,$3F
.byte $5C,$5C,$5D,$5E,$5F,$5F,$60,$61,$52,$52,$62,$63,$31,$32,$33,$06
.byte $0B,$0C,$06,$34,$0B,$30,$31,$32,$3D,$34,$35,$36,$0F,$10,$0F,$10
.byte $4E,$4E,$4F,$38,$5F,$5F,$51,$04,$52,$52,$53,$04,$04,$04,$04,$06
.byte $39,$39,$3A,$59,$0B,$0C,$06,$5A,$0B,$0C,$04,$5B,$0B,$0C,$04,$06
.byte $4E,$4E,$4F,$38,$5F,$5F,$51,$04,$52,$52,$53,$04,$31,$32,$33,$06
.byte $39,$39,$3A,$59,$0B,$0C,$06,$5A,$0B,$0C,$04,$5B,$0B,$0C,$04,$30
.byte $54,$55,$56,$04,$54,$55,$56,$04,$54,$55,$3D,$3D,$0F,$10,$0F,$10
.byte $0B,$0C,$06,$04,$3D,$48,$6B,$6C,$6D,$6E,$4B,$37,$0F,$10,$0F,$10
.byte $3E,$3F,$64,$3F,$64,$3F,$6F,$3D,$70,$3D,$3D,$48,$0F,$10,$0F,$10
.byte $3E,$3F,$3E,$3F,$40,$3F,$40,$3F,$4B,$4A,$4B,$4A,$01,$02,$01,$01
.byte $15,$17,$06,$04,$30,$31,$32,$06,$34,$35,$36,$07,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$04,$3D,$3D,$3D,$3D,$0F,$12,$1D,$1D
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$3D,$3D,$1D,$1E,$0F,$10
.byte $71,$72,$73,$04,$71,$72,$73,$04,$74,$75,$76,$07,$01,$02,$01,$01
.byte $77,$78,$79,$03,$71,$72,$73,$04,$71,$72,$73,$04,$71,$72,$73,$04
.byte $71,$72,$73,$04,$71,$72,$73,$04,$74,$75,$76,$07,$0F,$10,$0F,$10
.byte $0B,$0C,$06,$04,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$1D,$1E,$0F,$10
.byte $35,$36,$44,$04,$30,$31,$32,$3D,$34,$35,$36,$45,$0F,$12,$1D,$1D
.byte $77,$78,$79,$59,$71,$72,$73,$5A,$71,$72,$73,$5B,$71,$72,$73,$04
.byte $04,$04,$06,$04,$04,$04,$04,$04,$07,$07,$07,$07,$1D,$1E,$0F,$10
.byte $15,$17,$06,$04,$17,$04,$04,$04,$07,$07,$07,$07,$0F,$12,$1D,$1D
.byte $04,$04,$06,$04,$04,$04,$04,$04,$3D,$3D,$3D,$3D,$1D,$1E,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$12,$07,$07,$12,$13,$0F,$12,$1D,$1D
.byte $12,$13,$18,$14,$13,$18,$18,$16,$18,$18,$18,$1F,$1D,$1E,$0F,$10
.byte $39,$39,$3A,$59,$06,$06,$06,$5A,$06,$06,$04,$5B,$06,$06,$04,$06
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$12,$1D,$1D
.byte $04,$04,$54,$55,$3D,$3D,$54,$55,$3D,$3D,$54,$55,$0F,$10,$0F,$10
.byte $7A,$73,$7A,$73,$7A,$73,$7A,$73,$74,$76,$74,$76,$01,$02,$01,$01
.byte $77,$79,$77,$79,$7A,$73,$7A,$73,$7A,$73,$7A,$73,$7A,$73,$7A,$73
.byte $04,$04,$06,$04,$28,$29,$2A,$04,$2B,$2C,$2D,$08,$01,$02,$01,$01
.byte $04,$04,$06,$04,$28,$29,$2A,$04,$2B,$2C,$2D,$08,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$7B,$04,$04,$7C,$7D,$07,$07,$01,$02,$01,$01
.byte $04,$04,$06,$04,$06,$7B,$04,$04,$7C,$7D,$07,$07,$0F,$10,$0F,$10
.byte $15,$04,$11,$04,$11,$05,$04,$11,$07,$07,$07,$07,$0F,$10,$0F,$10
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$07,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$05,$04,$12,$07,$07,$12,$18,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$05,$04,$04,$07,$07,$07,$18,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$30,$31,$32,$33,$34,$35,$36,$37,$7E,$10,$0F,$10
.byte $15,$04,$11,$04,$11,$05,$04,$11,$07,$07,$07,$07,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$12,$07,$07,$12,$13,$7E,$10,$0F,$10
.byte $7F,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $3E,$3F,$3E,$3F,$3E,$3F,$3E,$3F,$4B,$4A,$4B,$4A,$7E,$10,$0F,$10
.byte $3E,$3F,$3E,$3F,$30,$31,$32,$4C,$34,$35,$36,$26,$7E,$10,$0F,$10
.byte $71,$72,$73,$04,$71,$72,$73,$04,$74,$75,$76,$07,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$80,$07,$07,$12,$13,$0F,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$80,$07,$07,$12,$13,$01,$02,$01,$01
.byte $15,$17,$06,$04,$17,$06,$04,$06,$07,$07,$07,$07,$81,$01,$82,$01
.byte $04,$04,$06,$04,$06,$04,$04,$80,$07,$07,$12,$13,$7E,$10,$0F,$10
.byte $04,$04,$06,$04,$06,$04,$04,$80,$04,$04,$12,$13,$04,$12,$13,$13
.byte $04,$05,$06,$04,$05,$04,$04,$04,$07,$07,$07,$08,$82,$02,$01,$01
.byte $12,$13,$18,$18,$13,$18,$14,$19,$18,$14,$15,$17,$83,$15,$17,$04
.byte $04,$04,$06,$04,$06,$04,$04,$12,$04,$04,$12,$13,$04,$80,$13,$13
.byte $04,$04,$06,$04,$06,$04,$04,$04,$3D,$3D,$3D,$3D,$7E,$10,$0F,$10
.byte $65,$66,$65,$66,$67,$68,$67,$84,$69,$6A,$69,$6A,$3E,$3F,$3E,$3F
.byte $20,$21,$22,$23,$20,$21,$22,$24,$25,$21,$22,$45,$0F,$10,$0F,$7E
.byte $85,$86,$87,$88,$06,$89,$8A,$8B,$3D,$8C,$3D,$3D,$7E,$10,$0F,$10
.byte $8D,$87,$8E,$8F,$90,$91,$92,$04,$3D,$3D,$8C,$3D,$7E,$10,$0F,$10
.byte $20,$21,$22,$23,$20,$21,$22,$24,$25,$21,$22,$26,$01,$82,$01,$93
.byte $0B,$0C,$06,$04,$0B,$0C,$04,$04,$0D,$0E,$07,$07,$01,$02,$82,$01
.byte $03,$03,$03,$03,$06,$06,$06,$04,$05,$06,$05,$04,$94,$05,$04,$06



; CharTileSet Tag Data...
; 121 tags, 1 per tile, 8 bits each, total size is 121 ($79) bytes.

* = addr_chartileset_tag_data
chartileset_tag_data

.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00



; Map Data...
; 40x10 (400) cells, 8 bits per cell, total size is 400 ($190) bytes.

* = addr_map_data
map_data

.byte $32,$33,$33,$33,$34,$41,$40,$33,$33,$33,$3B,$3B,$33,$33,$33,$33
.byte $33,$2B,$1B,$4F,$33,$33,$3C,$3F,$42,$3D,$33,$33,$72,$3F,$55,$33
.byte $3C,$33,$33,$3F,$40,$33,$33,$3A,$2C,$07,$35,$36,$37,$4E,$4D,$36
.byte $38,$38,$39,$25,$62,$19,$62,$0E,$50,$61,$13,$4C,$13,$07,$26,$27
.byte $3E,$1F,$71,$27,$28,$48,$52,$71,$29,$27,$73,$48,$49,$74,$75,$31
.byte $2D,$1B,$24,$1B,$0B,$0C,$0D,$04,$65,$78,$4B,$24,$03,$1B,$0B,$0C
.byte $0D,$1B,$03,$03,$01,$1B,$24,$03,$03,$4B,$01,$03,$70,$0C,$0D,$4B
.byte $24,$15,$0B,$0C,$0D,$04,$01,$30,$2C,$62,$25,$10,$11,$5E,$0E,$0F
.byte $16,$18,$4C,$66,$19,$10,$11,$5E,$17,$13,$17,$17,$16,$19,$67,$0E
.byte $50,$4C,$16,$10,$11,$51,$50,$4C,$25,$10,$11,$47,$0E,$0F,$16,$2F
.byte $2D,$15,$24,$04,$1B,$0B,$0C,$0D,$78,$78,$04,$24,$15,$1B,$03,$04
.byte $1B,$4B,$01,$14,$1B,$03,$0B,$0C,$0D,$4B,$04,$1B,$0B,$6F,$0D,$15
.byte $24,$4B,$15,$0B,$0C,$0D,$04,$30,$2C,$07,$45,$44,$64,$11,$63,$5B
.byte $19,$19,$06,$25,$5D,$61,$0E,$0F,$19,$4C,$16,$61,$0E,$2A,$11,$5E
.byte $2E,$68,$06,$10,$11,$51,$50,$13,$25,$4C,$6C,$11,$63,$0E,$0F,$2F
.byte $2D,$15,$04,$24,$04,$01,$1B,$03,$04,$15,$04,$24,$1B,$0B,$0C,$0D
.byte $4B,$15,$1B,$0B,$0C,$0D,$01,$04,$4B,$03,$15,$1B,$6D,$0C,$0D,$4B
.byte $1B,$04,$1B,$15,$0B,$0C,$0D,$30,$43,$27,$22,$23,$06,$16,$13,$0E
.byte $0F,$5D,$5F,$25,$60,$11,$5E,$5B,$4C,$5D,$69,$11,$5E,$17,$56,$0F
.byte $4C,$07,$62,$53,$54,$47,$2E,$68,$0E,$0F,$13,$69,$11,$47,$35,$57
.byte $04,$15,$1B,$21,$04,$15,$0B,$0C,$0D,$1B,$4B,$24,$03,$15,$03,$1B
.byte $03,$1B,$04,$03,$15,$0B,$0C,$0D,$01,$1B,$0B,$0C,$0D,$4B,$1B,$0B
.byte $0C,$0D,$04,$01,$03,$03,$04,$59,$1C,$1D,$20,$1E,$05,$08,$09,$0A
.byte $12,$1A,$4A,$46,$6E,$5C,$6E,$5A,$12,$1A,$05,$02,$6A,$09,$0A,$02
.byte $00,$08,$09,$6B,$5A,$4A,$6A,$09,$0A,$5A,$05,$00,$6E,$76,$77,$58




BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

.label ADR_CHARS = $2800
*=ADR_CHARS "Character Set"
.byte %11111111
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10100000
.byte %10100000
.byte %10100000
.byte %10100000

.byte %11111111
.byte %00000001
.byte %00000001
.byte %00000101
.byte %00000101
.byte %00000101
.byte %00000101
.byte %00000101

.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10111111
.byte %10000000
.byte %11111111

.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %11111101
.byte %00000001
.byte %11111111

.fill $0800 - $04, $00

*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

_screen:
    .for (var y = 0; y < 8; y++) {
        .for (var x = 0; x < 40; x++) {
            .byte mod(x, 2) + mod(y, 2) * 2
        }
    }

startup:
    jsr swap_charset

    lda #$00
    sta C64__COLOR_BORDER

    ldx #$00
!:
    lda _screen, x
    sta C64__SCREEN_DATA, x
    inx
    cpx #$a0
    bne !-

main:
    wait_vblank()
    inc C64__COLOR_BORDER
    jsr scroll_left

    dec C64__COLOR_BORDER
    jmp main


.const charA = ADR_CHARS + $00
.const charB = ADR_CHARS + $08
.const charC = ADR_CHARS + $10
.const charD = ADR_CHARS + $18

swap_charset:
	lda C64__MEM_SETUP
	and #%11110001
	ora #%00001010 // $2800-$2fff
	sta C64__MEM_SETUP
    rts

copy_charset:
    ldx #$00
!:
    .for (var i = 0; i < 8; i++) {
        lda $d000 + i * $0100, x
        sta ADR_CHARS + i * $0100, x
    }
    inx
    bne !-
    rts


scroll_left:
    ldx #$00
loop1:		
    lda charB,x		// bit7 charB -> carry
    asl				
    rol charA,x		// carry -> bit0 charA
    rol charB,x		// bit7 charA -> bit0 charB
    lda charC,x		// same here with C and D
    asl
    rol charD,x
    rol charC,x
    inx
    cpx #$08
    bne loop1
    rts
BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

.label ADR_CHARS = $2800
*=ADR_CHARS "Character Set"
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000

.byte %11111111
.byte %11111111
.byte %11111111
.byte %11100111
.byte %11100111
.byte %11111111
.byte %11111111
.byte %11111111

.byte %11111111
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000

.byte %11111111
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001

.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %10000000
.byte %11111111

.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %00000001
.byte %11111111


*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

_world_x: 
    .byte $00
_screen:
    .for (var y = 0; y < 8; y++) {
        .for (var x = 0; x < 40; x++) {
            .if (x >= 38 && y > 0 && y < 3) {
                .byte $01
            } else {
                .byte $02 + mod(x, 2) + mod(y, 2) * 2
            }
        }
    }
_color:
    .for (var y = 0; y < 8; y++) {
        .for (var x = 0; x < 40; x++) {
            .if (x >= 38 && y > 0 && y < 3) {
                .byte $02
            } else {
                .byte $01
            }
        }
    }

startup:
    lda #$00
    sta C64__COLOR_BORDER

    clear_screen($00)
    jsr swap_charset
    jsr render_world

main:
    lda #$00
    sta C64__COLOR_BORDER
    wait_vblank()
    lda #$02
    inc C64__COLOR_BORDER

    lda _world_x
    and #$01
    cmp #$01
    bne !+
    jsr rotate_tile_right
!:

    inc _world_x
	lda _world_x
	eor #$ff
	sta C64__ZEROP_BYTE
	scroll_screen_x_a8(C64__ZEROP_BYTE)

    lda _world_x
    and #$07
    cmp #$00
    bne main

hard_scroll:
    .for (var i = 0; i < 4; i++) {
        lda C64__SCREEN_DATA + i * $28 + $00
        pha
        lda C64__SCREEN_COLOR + i * $28 + $00
        pha
        ldx #$00
!:
        lda C64__SCREEN_DATA + i * $28 + $01, x
        sta C64__SCREEN_DATA + i * $28 + $00, x
        lda C64__SCREEN_COLOR + i * $28 + $01, x
        sta C64__SCREEN_COLOR + i * $28 + $00, x
        inx
        cpx #$27
        bne !-
        pla
        sta C64__SCREEN_COLOR + i * $28 + $27
        pla
        sta C64__SCREEN_DATA + i * $28 + $27
    }
    jmp main


render_world:
    ldx #$00
!:
    lda _screen, x
    sta C64__SCREEN_DATA, x
    lda _color, x
    sta C64__SCREEN_COLOR, x
    inx
    cpx #$a0
    bne !-
    rts

swap_charset:
	lda C64__MEM_SETUP
	and #%11110001
	ora #%00001010 // $2800-$2fff
	sta C64__MEM_SETUP
    rts


.const charA = ADR_CHARS + $10
.const charB = ADR_CHARS + $18
.const charC = ADR_CHARS + $20
.const charD = ADR_CHARS + $28

rotate_tile_left:
    ldx #$00
!:  lda charB,x		// bit7 charB -> carry
    asl				
    rol charA,x		// carry -> bit0 charA
    rol charB,x		// bit7 charA -> bit0 charB
    lda charC,x		// same here with C and D
    asl
    rol charD,x
    rol charC,x
    inx
    cpx #$08
    bne !-
    rts

rotate_tile_right:
    ldx #$00
!:  lda charA,x		// bit0 charA -> carry
    lsr				
    ror charB,x		// carry -> bit7 charB
    ror charA,x		// bit0 charB -> bit7 charA
    lda charC,x		// same here with C and D
    lsr
    ror charD,x
    ror charC,x
    inx
    cpx #$08
    bne !-
    rts

rotate_tile_up:
    lda charA		// save byte0 charA	
    pha
    lda charC		// save byte0 charC
    pha
    ldx #$00
!:  lda charA+1,x
    sta charA,x
    lda charC+1,x
    sta charC,x
    inx
    cpx #$07
    bne !-
    pla
    sta charA+7		// byte0 charC -> byte7 charA
    pla
    sta charC+7		// byte0 charA -> byte7 charC		
        
    lda charB		// same here with B and D	
    pha
    lda charD
    pha
    ldx #$00
!:  lda charB+1,x
    sta charB,x
    lda charD+1,x
    sta charD,x
    inx
    cpx #$07
    bne !-
    pla
    sta charB+7
    pla
    sta charD+7				
    rts

rotate_tile_down:
    lda charC+7			
    pha
    lda charA+7
    pha
    ldx #$06
!:  lda charC,x
    sta charC+1,x
    lda charA,x
    sta charA+1,x
    dex
    bpl !-
    pla
    sta charC
    pla
    sta charA	

    lda charD+7			
    pha
    lda charB+7
    pha
    ldx #$06
!:  lda charD,x
    sta charD+1,x
    lda charB,x
    sta charB+1,x
    dex
    bpl !-
    pla
    sta charD
    pla
    sta charB			
    rts
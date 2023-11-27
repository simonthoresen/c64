BasicUpstart2(startup)
#define ENABLE_PRINT
//#define ENABLE_PRINT_FONT
.const PRINT_FONT = @" abcdefghijklmnopqrstuvwxyz"
#import "../c64lib/c64lib.asm"

_char: 
    .byte $00
_val:
    .word $1234

startup:
    do_startup()
    clear_screen($20)

    print_hex__a16_i8(_val, 0, 0)

    set_cursor__i8(20, 15)
main:
    inc C64__COLOR_BORDER
    inc _char
    lda _char
    print_acc()
    print__i8('$')
    print_hex__a8(C64__COLOR_BORDER)
    print__i8(':')
    wait_vblank()
/*    .for (var i = 0; i < 6; i++) {
        wait_vblank()
        print_string("." + i)
    }*/
    jmp main



BasicUpstart2(startup)
#define ENABLE_PRINT
//#define ENABLE_PRINT_FONT
.const PRINT_FONT = @" abcdefghijklmnopqrstuvwxyz"
#import "../c64lib/c64lib.asm"

_char: 
    .byte $00

startup:
    do_startup()
    clear_screen($20)

    set_cursor__i8(20, 15)
main:
    inc C64__COLOR_BORDER
    inc _char
    lda _char
    print_acc()
    wait_vblank()
/*    .for (var i = 0; i < 6; i++) {
        wait_vblank()
        print_string("." + i)
    }*/
    jmp main



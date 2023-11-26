BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

startup:
    do_startup()
    clear_screen($20)

    print_at(0, 2)
main:
    .for (var i = 0; i < 6; i++) {
        wait_vblank()
        print_string("." + i)
    }
    jmp main



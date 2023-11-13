BasicUpstart2(startup)
.label ADR_DATA = $2000
.label DATA_BLOCK = ADR_DATA/64
*=ADR_DATA "Program Data"
#import "data.asm"

*=$4000 "Main Program"
#import "../c64lib/c64lib.asm"

startup:
    do_startup()
    clear_screen($20)

main:
    jmp main

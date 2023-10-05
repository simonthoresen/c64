BasicUpstart2(startup)
    *=$4000 "Main Program"

startup:
    

main:
    inc $d020
    jmp main
    
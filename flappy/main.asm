main:
    // wait for the raster to reach the bottom border
    lda $d011
    rol         // rotate bit 7 into the carry
    bcs main    // branch if carry
!:
    lda $d012
    cmp #$fa    // wait for raster line 250
    bne !-


!:  // getting here means that we have passed into the 
    // bottom border of the screen, and we are in sync
    inc $d020


!:  // wait for the raster to move before looping back
    lda $d011
    cmp #$fa
    beq !- 
    jmp main


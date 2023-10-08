.const ADR_JOY1_STATE			= $dc01
.const ADR_JOY2_STATE			= $dc00

.const ADR_BORDER_COL        	= $d020
.const ADR_BACKGROUND_COL    	= $d021
.const ADR_SCREEN				= $0400	// default, 1000 bytes

.const ADR_SPRITE_ENABLE 		= $d015
.const ADR_SPRITE_MCOL_ENABLE	= $d01c
.const ADR_SPRITE_MCOL0			= $d025
.const ADR_SPRITE_MCOL1			= $d026
.const ADR_SPRITE_POINTERS		= ADR_SCREEN + $03f8
.const ADR_SPRITE_POSX_BIT9     = $d010

.const ADR_SPR0_COLOR  		    = $d027
.const ADR_SPR0_POSX 			= $d000
.const ADR_SPR0_POSY 			= $d001
.const ADR_SPR0_POINTER			= ADR_SPRITE_POINTERS + 0

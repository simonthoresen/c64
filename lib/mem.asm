.const ADR_ARG1_LO				= $0002
.const ADR_ARG1_HI				= $0003
.const ADR_ARG1					= ADR_ARG1_LO
.const ADR_ARG2_LO				= $0004
.const ADR_ARG2_HI				= $0005
.const ADR_ARG2					= ADR_ARG2_LO
.const ADR_ARG3_LO				= $00fb
.const ADR_ARG3_HI				= $00fc
.const ADR_ARG3					= ADR_ARG3_LO
.const ADR_TMP1					= $002a
.const ADR_TMP					= ADR_TMP1
.const ADR_TMP2					= $0052
.const ADR_IIDX_LO				= $00fd
.const ADR_IIDX_HI				= $00fe


.const ADR_JOY1_STATE			= $dc01
.const ADR_JOY2_STATE			= $dc00

.const ADR_BORDER_COL        	= $d020
.const ADR_BACKGROUND_COL    	= $d021
.const ADR_SCREEN				= $0400	// default, 1000 bytes
.const ADR_COLOR                = $d800

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

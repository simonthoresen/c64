.const JOY1_STATE	= $dc01
.const JOY2_STATE	= $dc00
.const JOY_UP 		= $01
.const JOY_DOWN 	= $02
.const JOY_LEFT 	= $04
.const JOY_RIGHT 	= $08
.const JOY_FIRE 	= $10


/*
.const ADR_SCREEN		= $0400
.const BORDER_COLOR			= $D020
.const BACKGROUND_COLOR		= $D021
 
.const ADR_SPRITE_ENABLE	= $d015
.const SPRITE_0_X_POSITION	= $D000
.const SPRITE_0_Y_POSITION	= $D001
.const ADR_SPRITE_0_COLOR	= $D027  
.const ADR_SPRITE_0_BLOCK	= ADR_SCREEN + $03F8 // Last 8 Bytes of Screen RAM
.const SPRITE_0_BLOCK		= $0d
.const SPRITE_NUM_BYTES		= $40
.const ADR_SPR0_DATA		= SPRITE_0_BLOCK * SPRITE_NUM_BYTES // Block 13, 13*64=>832 => $0340
*/

.const  COLOR_BLACK       = $00
.const  COLOR_GREEN       = $05
.const  COLOR_LIGHTGREEN  = $0D
  
.const  SPRITE_0_X_POSITION = $D000
.const  SPRITE_0_Y_POSITION = $D001
 
.const  BORDER_COLOR        = $D020
.const  BACKGROUND_COLOR    = $D021
 
.const  SPRITE_0_COLOR      = $D027
  
.const SPRITE_NUM_BYTES		= $40

.const ADR_SCREEN  	    		= $0400
.const ADR_SPR0_INDEX    		= ADR_SCREEN + $03F8
.const ADR_SPR0_DATA       		= $0340        

.const ADR_SPRITE_UPPER_X       = $d010
.const ADR_SPRITE_ENABLE 		= $d015
.const ADR_SPRITE_MCOL_ENABLE	= $d01c
.const ADR_SPRITE_MCOL0			= $d025
.const ADR_SPRITE_MCOL1			= $d026

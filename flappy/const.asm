

/*
.const ADR_SCREEN		= $0400
.const BORDER_COLOR			= $D020
.const BACKGROUND_COLOR		= $D021
 
.const ADR_SPRITE_ENABLE	= $d015
.const ADR_SPR0_POSX	= $D000
.const ADR_SPR0_POSY	= $D001
.const ADR_ADR_SPR0_COLOR	= $D027  
.const ADR_SPRITE_0_BLOCK	= ADR_SCREEN + $03F8 // Last 8 Bytes of Screen RAM
.const SPRITE_0_BLOCK		= $0d
.const SPRITE_NUM_BYTES		= $40
.const ADR_SPR0_DATA		= SPRITE_0_BLOCK * SPRITE_NUM_BYTES // Block 13, 13*64=>832 => $0340
*/

  
.const ADR_SCREEN  	    		= $0400
.const ADR_SPR0_INDEX    		= ADR_SCREEN + $03F8
.const ADR_SPR0_DATA       		= $0340        


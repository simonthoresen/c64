BasicUpstart2(startup)
#import "../c64lib/c64lib.asm"

.const SND_MOVE_BLOCK = 0
.const SND_ROTATE_BLOCK = 1
.const SND_DROP_BLOCK = 2
.const SND_LINE = 3
.const SND_TETRIS = 4
.const SND_PAUSE_ON = 5
.const SND_PAUSE_OFF = 6
.const SND_OPTION = 7
.const SND_MUSIC_TITLE = 9
.const SND_MUSIC_GAMEOVER = 8

*=$1000 "Music"
.var music = LoadSid("audio.sid")
.fill music.size, music.getData(i)	

*=$4000 "Main Program"
startup:
    enter_startup()
    setup_irq($00fa, my_irq)

	ldx #$00
	ldy #$00
	lda #SND_LINE
	jsr music.init	

    leave_startup()
    clear_screen($20)

main:
    wait_vline($0000)

    maybe_play(C64__JOY_LEFT, SND_MOVE_BLOCK)
    maybe_play(C64__JOY_RIGHT, SND_ROTATE_BLOCK)
    maybe_play(C64__JOY_UP, SND_DROP_BLOCK)
    maybe_play(C64__JOY_DOWN, SND_TETRIS)
    maybe_play(C64__JOY_FIRE, SND_MUSIC_GAMEOVER)
    jmp main

play:
    inc C64__COLOR_BORDER
    ldx #$00
    ldy #$00
    jsr music.init
    jmp main

my_irq:
    enter_irq()
	jsr music.play
    leave_irq()
    rti

.macro maybe_play(input, sound)
{
    lda C64__JOY1
    and #input
    bne !+
    lda #sound
    jmp play
!:
}
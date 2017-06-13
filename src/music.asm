    macro PLAY_MUSIC
        if ENABLE_MUSIC
            call PLY_Play
           ; WAIT_CYCLES 64*4
        else
            WAIT_CYCLES 64*15
        endif
    endm


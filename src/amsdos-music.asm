
    macro PLAY_INTRO_MUSIC

    ld hl,PsgValues
    ld d,0
PsgLoop
    ld c,(hl)
    ld a,d
    call #bd34
    inc hl
    inc d
    ld a,d
    cp 14
    jr nz,PsgLoop

    endm


    macro DATA_INTRO_MUSIC
PsgValues
    ;27e, or 4fc
    dw #27e - 1 ;Period Channel 1
    dw #27e ;Period Channel 2
    dw #27e + 1 ;Period Channel 3
    db 0 ;No noise
    db %111000 ;R7
    db 16, 16, 16 ;Opens hardware volume
    dw 50000 ;Ramp up period
    db 13 ;Ramp up and loop
    endm

;;
; dummy uncrunch routine specific for our curves

; input 
;  - HL=source
;  - DE=destination 
;  - BC size

    macro UNCRUNCH
    xor a
.loop\@
        add (hl)
        ld (de), a
        inc hl
        inc de
        djnz .loop\@
    endm



split_curve
    push hl
    ld de, garbage
    ld bc, 128
    ldir ; copy first half
    ld bc, 128
    ldir ; copy second half

    pop hl
    ld de, garbage + 128
    ld bc, garbage 
    ld a, 128
.loop
    push af
        ld a, (de)
        inc de
        ld (hl), a
        inc hl
        ld a, (bc)
        inc bc
        ld (hl), a
        inc hl
    pop af
    dec a
    jr nz, .loop

    ret


;;
; In mode 0, the best is to display a bar of an even number of pixels in order to take always the same amount of time to display it
;
; Example with 3 pixels
;|--|-.|
;|.-|--|
;
; Each pixel column of each bar is from a differnt ink





bar_mode_0_fat
.read
        ld a, (bc)  ; 2 nops
        add (hl)  ; 2 nops
        inc l  ; 1 nops
        nop  ; 1 nops
        nop  ; 1 nops
        inc c  ; 1 nops

        rra
        exx  ; 1 nops
        ld l, a  ; 1 nops

        
        jp c, .right  ; 3 nops
.left
        ld (hl),  MODE0_INK1_INK2  ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK3_INK4  ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK5_INK6  ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK7_INK8  ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK9_INK10 ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK11_INK12  ; 3 nops
        inc l  ; 1 nops
        ld a, (hl)  ; 2 nops
        and d; 1 nops
        or b  ; 1 nops
        ld (hl), a  ; 3 nops
        jr .displayed
.right
        ld a, (hl) ; get byte  ; 2 nops
        and e ; 1 nop
        or c   ; 1 nops
        ld (hl), a  ; 3 nops
        inc l  ; 1 nops
        ld (hl),   MODE0_INK2_INK3  ; 3 nops
        inc l  ; 1 nops
        ld (hl),   MODE0_INK4_INK5  ; 3 nops
        inc l
        ld (hl),   MODE0_INK6_INK7  ; 3 nops
        inc l
        ld (hl),   MODE0_INK8_INK9  ; 3 nops
        inc l
        ld (hl),   MODE0_INK10_INK11  ; 3 nops
        inc l
        ld (hl),   MODE0_INK12_INK13  ; 3 nops
        nop
        nop
        nop
.displayed
        exx


        defs 64-35  - 4*4
        ret  ; 3 nops

    ; -----.
    macro BAR0_DISPLAY_LEFT_BAR, fast
        ; display the complete bytes
        ld (hl),  MODE0_INK1_INK2  ; 3 nops
        inc l  ; 1 nops
        ld (hl),  MODE0_INK3_INK4  ; 3 nops
        inc l  ; 1 nops

        ; dispay the partial byte
        ld a, (hl)  ; 2 nops
        if 0 == \fast
            and MODE0_MASK_PIXEL1 ; 2 nops
        else
            and d; 1 nops
        endif
        or b  ; 1 nops
        ld (hl), a  ; 3 nops
; Total number of nops = 16

    endm

    ;; Same amount of than the left version
    ; .-----
    macro BAR0_DISPLAY_RIGHT_BAR, fast
        ; Mask first pixel
        ld a, (hl) ; get byte  ; 2 nops
        if 0 == \fast
            and MODE0_MASK_PIXEL0       ; remove pixels we want to smash  ; 2 nops
        else
            and e ; 1 nop
        endif
        or c   ; 1 nops
        ld (hl), a  ; 3 nops
        inc l  ; 1 nops

        ld (hl),   MODE0_INK2_INK3  ; 3 nops
        inc l  ; 1 nops
        ld (hl),   MODE0_INK4_INK5  ; 3 nops
; Total number of nops = 16
    endm

    macro BAR0_DISPLAY, fast
        exx  ; 1 nops
        ld l, a  ; 1 nops


        if 0 == \fast

            repeat 3
                ldi
                inc c
            endrepeat
            ld (de), a
            inc de
            ld l, a
        endif

        jp c, .bar1_\@  ; 3 nops
.bar2_\@
        BAR0_DISPLAY_LEFT_BAR \fast; 16 nops
        jr .eob_\@  ; 2 nops
.bar1_\@
        BAR0_DISPLAY_RIGHT_BAR \fast; 16 nops
        nop ; 1
        nop ; 1
        nop ; 1
.eob_\@
        exx  ; 1 nops
; Total number of nops = 23
    endm


    ;; 
        ; Specify the registers used during the configuration of the effect
    macro BAR0_INIT_EFFECT

    endm

    macro BAR0_DEINIT_EFFECT
.backup_sp equ $+1
        ld sp, 0
    endm


    macro BAR0_MANAGE_POS
        rra     ; => /2 the cruve to have something more beautifull / we know carry is not set  ; 1 nops
        ;srl a   ; => /2 to get the right position/pixel  ; 2 nops
; Total number of nops = 3
    endm


    ;; Generate the code to manage the effect
    macro MANAGE_LINE1
     ; XXX
;      It is necessary to strictly use the inverse computation to restore the background
     ; XXX
        ld a, (bc)  ; 2 nops
        add (hl)  ; 2 nops
        inc c  ; 1 nops
        dec l  ; 1 nops
        dec l  ; 1 nops
        dec l  ; 1 nops
; Total number of nops = 7
        BAR0_MANAGE_POS  ; 1 nops
        BAR0_DISPLAY 0    ; 24 nops
        defs 64 - 6 - 2 - 1 - 24 - 3 - (3*(1+5)+1+4)
        ret  ; 3 nops
    endm

    macro MANAGE_LINE2
.I set 0
        repeat 2
            
        ld a, (bc)  ; 2 nops
        dec c  ; 1 nops
        ;nop
        add (hl)  ; 2 nops
        if .I = 0
            inc l  ; 1 nops
        else
            nop
        endif
        ; Total number of nops = 7

            BAR0_MANAGE_POS  ; 1 nops
            BAR0_DISPLAY 1    ; 24 nops
.I set .I+1
        endrepeat
        defs 64 - (6 + 1 + 22)*2 - 3 -2
        ret  ; 3 nops
    endm




;bar_mode0.display.;
; Really display the effect
bar_mode0_display

.start
    SET_MODE_0
    ld bc, 0x7f04
    out (c), c



    ; Init code called AFTER the halt
            ld (.backup_sp), sp
.stack_pos equ $+1
        ld sp, BAR_DATA.call_table_start

        ld h, 0xc0  ; Address of the screen
.de_value equ $+1
        ; mask for one case, table in another one
        ld de, 0x544b;MODE0_MASK_PIXEL1*256 + MODE0_MASK_PIXEL0
.bc_value equ $+1
        ld bc, 0x7f00;MODE0_PIXEL0_INK5*256 + MODE0_PIXEL1_INK1

        exx
.curve1_pos equ $+1
        ld hl, CURVE1
.curve2_pos equ $+1
        ld bc, CURVE2


.counter_a equ $+1
    ld a, 0 ; 1
    dec a ; 1
    ld (.counter_a), a ; 3
    ex af, af' ; 1

    defs 15 - (1+1+3+1) - 7

    ret ; Call the effect
.end
    BAR0_DEINIT_EFFECT ; (restore the stack pointer)
    jp do_nothing2 + 64-56-3 + 69 ; XXX Verify it generates the right amount of time
;    WAIT_CYCLES 56
;    ret ; Leave the effect

bar_mode0_reversed_init
.curve_step
    ld a, (bar_mode0_display_reversed.curve1_pos)
    sub 1
    ld (bar_mode0_display_reversed.curve1_pos), a

    ld a, (bar_mode0_display_reversed.curve2_pos)
    add 3
    ld (bar_mode0_display_reversed.curve2_pos), a



.counter equ $+1
    ld a, 0
    inc a
    and 1
    ld (.counter), a

    jr z, .odd
.even
    ld bc, 0xbc00 + 12
    ld hl, 0x3000
    out (c),c
    inc b
    out (c), h
    dec b
    inc c
    out (c), c
    inc b
    out (c), l

    ld a, 0xc0
    ld (bar_mode0_display_reversed.screen_clear), a

    ld a, 0x80
    ld hl, BAR_DATA.bar_erase
    ld de, BAR_DATA.bar_erase2_last

    ld (bar_mode0_display_reversed.screen_write), a
    ld (bar_clear_memory_screen.address + 1), a

    ld (bar_mode0_display_reversed.buffer_write), hl
    ld (bar_mode0_display_reversed.buffer_read), de


    call bar_clear_memory_screen
    ret    

.odd
    ld bc, 0xbc00 + 12
    ld hl, 0x2000
    out (c),c
    inc b
    out (c), h
    dec b
    inc c
    out (c), c
    inc b
    out (c), l

    ld a, 0x80
    ld (bar_mode0_display_reversed.screen_clear), a

    ld a, 0xc0
    ld hl, BAR_DATA.bar_erase2
    ld de, BAR_DATA.bar_erase_last

    ld (bar_clear_memory_screen.address + 1), a
    ld (bar_mode0_display_reversed.screen_write), a
    ld (bar_mode0_display_reversed.buffer_write), hl
    ld (bar_mode0_display_reversed.buffer_read), de

    call bar_clear_memory_screen
    ret

bar_mode0_display_reversed
.start
    ld bc, 0x7f8c
    out (c), c
    ; Init code called AFTER the halt
    ld (.backup_sp), sp
.stack_pos equ $+1
        ld sp, BAR_DATA.call_table2_start

.screen_write equ $+1
        ld h, 0xc0  ; Address of the screen
.buffer_write equ $+1
        ; mask for one case, table in another one
        ld de, 0
        ld bc, MODE0_PIXEL0_INK5*256 + MODE0_PIXEL1_INK1

        exx
.buffer_read equ $+1
    ld hl, 0
.screen_clear equ $+1
    ld d, 0

.curve1_pos equ $+2
        ld ix, CURVE1
.curve2_pos equ $+2
        ld iy, CURVE1
    ret ; Call the effect
.end
.backup_sp equ $+1
        ld sp, 0

        defs 128 - 64
    ret ; Leave the effect



;;
; In this cae, we assume the curve table as already been generated in order o earn some nops
; HL' is the current memory screen to write on
; DE' is the current buffer to fill (set to the beginning)
; IX and IY are the sinus table
; DE is the current memory screen displayed on screen
; HL is the buffer to read (set to the end)
bar_mode_0_display_and_remove_one_bar
        ld a, (IX+0)  ; HL and DE are used for something else
        add a, (IY+0) 
        inc iyl
        inc ixl
        inc ixl
        inc ixl
        rra         ; 2 move in the right position
        BAR0_DISPLAY 0    ; 24 nops => save things to be erase on next frame

.erase

        ld e, (hl)
        dec hl
        inc e
        inc e
        ldd ; 5 nops  ; XXX do not care of BC removal now
        ldd ; 5 nops
        ldd ; 5 nops

        defs 128 - 91-1 + 2
    ret ; 3

bar_mode_0_display_one_completebar
        ld a, (IX+0)  ; HL and DE are used for something else
        add a, (IY+0) 
        inc iyl
        inc ixl
        inc ixl
        inc ixl
        rra         ; 2 move in the right position
        BAR0_DISPLAY 0    ; 24 nops => save things to be erase on next frame

.erase

;        ld e, (hl) 2 
;        dec hl ; 2
;        inc e ; 1
;        inc e ; 
;        ldd ; 5 nops  ; XXX do not care of BC removal now
;        ldd ; 5 nops
;        ldd ; 5 nops

        defs 128 - 91 + (2+2+1+1+5+5+5) +1
    ret ; 3



    macro MONOCHROME_BAR, COL

    if \COL = 1
.MONO_DOUBLE SET MODE0_INK4_INK5
.MONO_SINGLE_LEFT SET MODE0_PIXEL0_INK4
.MONO_SINGLE_RIGHT SET MODE0_PIXEL1_INK5
    endif

    if \COL = 2
.MONO_DOUBLE SET MODE0_INK1_INK2
.MONO_SINGLE_LEFT SET MODE0_PIXEL0_INK1
.MONO_SINGLE_RIGHT SET MODE0_PIXEL1_INK2 
    endif



        exx
        ex af, af'
        rra ; 1 nop
        ld l, a  ; 1 nops
        jp c, .bar1\@  ; 3 nops
.bar2\@
        ; display the complete bytes
        ld (hl),  .MONO_DOUBLE ; 3 nops
        inc l  ; 1 nops
        ld (hl),  .MONO_DOUBLE  ; 3 nops
        inc l  ; 1 nops

        ; dispay the partial byte
        ld a, (hl)  ; 2 nops
        and MODE0_MASK_PIXEL1; 2 nops
        or .MONO_SINGLE_LEFT   ; 2 nops
        ld (hl), a  ; 3 nops

        jr .eob\@  ; 2 nops
.bar1\@
        ld a, (hl) ; get byte  ; 2 nops
        and MODE0_MASK_PIXEL0 ; 1 nop
        or .MONO_SINGLE_RIGHT; 2 nops
        ld (hl), a  ; 3 nops
        inc l  ; 1 nops

        ld (hl),   .MONO_DOUBLE; 3 nops
        inc l  ; 1 nops
        ld (hl),   .MONO_DOUBLE

        nop ; 1
        nop ; 1
        nop ; 1
.eob\@
        exx  ; 1 nops
    endm

bar_mode0_monochrome
        ld a, (bc)  ; 2 nops
        add (hl)  ; 2 nops
        dec c  ; 1 nops
       ; dec c  ; 1 nops
        dec l  ; 1 nops


        ex af, af'




        inc a
 ;       and %1111111
        bit 4, a
        jp z, .v2

.v1
        MONOCHROME_BAR 1
        jr .eov
.v2
        MONOCHROME_BAR 2
        nop
        nop
        nop
.eov

 ex af,af'
    exx
        bit 0, a
        jr z, .noa
        out (c), e ; 4
        jr .nob
.noa
        out (c), d
        nop
        nop
.nob
    exx
 ex af, af'
        defs 64 - 50 + 3 -  13 - 2 + 1; XXX Check that
        ret




bar_mode_0_display_one_bar
    MANAGE_LINE1


bar_mode_0_remove_one_bar


.erase



        exx ; 1 nops
        dec de ; fix a wrong positionning
        ld a, (de)
        dec de
        inc a
        inc a
        ld l, a
        ex de, hl
        ldd ; 5 nops  ; XXX do not care of BC removal now
        ldd ; 5 nops
        ldd ; 5 nops
        ex de, hl
        inc de ; restore positionning
        exx ; 1 nops



        defs 64 - 3 - (1+2+2+2+1+1+1+1+5+5+5+1+2+1) - (3+4+2+4+1+2+4+4)

        ld bc, 0x7f00 + BACKGROUND_INKA ; 3
        ld a, BACKGROUND_INKA_COLOR_MIRROR    ; 2
        out (c), c    ; 4
        out (c), a    ; 4
        inc c ; 1
        ld a, BACKGROUND_INKB_COLOR_MIRROR ; 2
        out (c), c ;4 
        out (c), a;4
        ret

        
bar_mode_0_display_two_bars
    MANAGE_LINE2





bar_mode0_frameinit
    ld hl, 0xc000
    ld (bar_clear_memory_screen.address ), hl
    call bar_clear_memory_screen



    ld a, (bar_mode0_display.curve1_pos)
.delta1 equ $+1
    sub 7
    ld (bar_mode0_display.curve1_pos), a

    ld a, (bar_mode0_display.curve2_pos)
.delta2 equ $+1
    add 5
    ld (bar_mode0_display.curve2_pos), a
 
    ld bc, 0xbc00 + 12
    ld hl, 0x3000
    out (c),c
    inc b
    out (c), h
    dec b
    inc c
    out (c), c
    inc b
    out (c), l

    ret

bar_mode0_configuration
    BAR_CONFIGURATION bar_mode0_frameinit, bar_mode0_display.start, do_nothing, bar_mode0_display.end 

bar_mode0_reversed_configuration
    BAR_CONFIGURATION bar_mode0_reversed_init, bar_mode0_display_reversed.start, do_nothing2, bar_mode0_display_reversed.end 


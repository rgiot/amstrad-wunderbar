;;
; Common code for the bars
;


BAR_EFFECT_HEIGHT equ EFFECT_HEIGHT + 9


    ;;
    ; Configuration information of one bar effect
    struct BAR_CONFIGURATION
.frame_init     dw 0    ; Address of the routine to call to initialize the effect at each frame
.effect_start   dw 0    ; Address of the routine to use to start the effect
.main_line_routine dw 0 ; Address of the routine to call at each line
.effect_end     dw 0    ; Address of the routine to use to exit the effect
    endstruct


;;



bar_display_frame
    BREAKPOINT_WINAPE

.crtc_transition
    call secure_vsync

    ; Wait before changing R4/R7 {{{
        LONG_WAIT_CYCLES 200*64
    ; }}}


    ; Reduce screen height {{{
        ld bc, 0xbc00 + 4
        out (c), c
        ld bc, 0xbd00 + (39 - 8-1) - 1 ; 
        out (c), c
    ;}}}

    ; Select the next R7 value {{{
        ld bc, 0xbc00 + 7
        out (c), c
        ld bc, 0xbd00 + 0 ;
        out (c), c
    ; }}}


 
        if  0
            LONG_WAIT_CYCLES 7107- 64  ; => CRTC0 version
        else
            LONG_WAIT_CYCLES 7107  ; => CRTC1 version
        endif

.frame_loop
    xor a       ; R4=R9=0

    ld bc,&BC09
    out (c),c
    inc b
    out (c),a
    ld bc,&BC04
    out (c),c
    inc b
    out (c),a


    ld bc, 0xbc00 + 7
    out (c), c
    ld bc, 0xbd00 + 0xff
    out (c), c

    ld hl, crtc_table ; horizontal pos/ width (previously at 0)
    CRTC_SET_VALS 


    ; Set the line2line splitting
.line2line_start

.select_empty_screen
    ld hl, 0x3000 + 48
     ld bc, 0xbc00 + 12
    out (c),c
    inc b
    out (c), h
    dec b
    inc c
    out (c), c
    inc b
    out (c), l 

.set_color_and_mode
    ld bc, 0x7f8c
    out (c), c

.ga
.palette equ $+1
    ld hl, PALETTE_SINGLE
    ld c, -1
.palette_loop
    inc c
    ld a, (hl)
    out (c), c
    out (c), a

    inc hl

    ld a, 15
    cp c
    jr nz, .palette_loop

    if ENABLE_SOUND_ANALYSIS
        ld hl, PALETTE_SOUND
        ld a, (PLY_PSGReg8)
        ld d, 0
        ld e, a
        add hl, de
        ld a, (hl)
        out (c), c
        out (c), a
    endif
    
    PLAY_MUSIC
 ;   call PLY_SendRegisters_Real
    ei
    

.event_routine equ $+1
    call dummy_method

    ; Call of the frame initialisation routine
.init_routine equ $+1
    call dummy_method


    ; Wait 1st halt
    halt
    di
  ;  BREAKPOINT_WINAPE



    ; Really ask to do the effect
.bar_display_effect equ $+1
    call dummy_method


.line2line_end;



                call PLY_SendRegisters_Real ; 374 nops



 ;               call _setR4R9
                
            ; Waste some cycles
            ;WAIT_CYCLES 249 - 32 - 3*64

                ld bc, 0xbc00 + 7
                out (c), c
                ld bc, 0xbd00 + 0x00
                out (c), c
                ld a, 1
                ; Allo?
              ;  BREAKPOINT_WINAPE
                jr .frame_loop

;;
; Squeleton routine for the bar display stuff
; 

;;
; Routine used to select the variation of the bar effect
; Input :
;  - hl: address on the structure of interest
bar_select_variation
.copy_init_routine_address
    ld de, bar_display_frame.init_routine
    LDI2

.copy_display_effect
    ld de, bar_display_frame.bar_display_effect
    LDI2
;
;.copy_effect_routines
;    ld de, BAR_DATA.call_table_dummy_start
;    LDI2
;    
;    push hl
;    ld h, d
;    ld l, e
;    dec hl
;    dec hl
;    ld bc, BAR_DATA.call_table_dummy_stop - BAR_DATA.call_table_dummy_start - 2
;    ldir
;
;.copy_last_effect_call
;    pop hl
    inc hl
    inc hl
    ld de, BAR_DATA.call_table_dummy_stop
    LDI2

    ret


bar_select_variation2

.copy_init_routine_address
    ld de, bar_display_frame.init_routine
    LDI2

.copy_display_effect
    ld de, bar_display_frame.bar_display_effect
    LDI2


;.copy_effect_routines
;    ld de, BAR_DATA.call_table2_dummy_start
;    LDI2
;    
;    push hl
;    ld h, d
;    ld l, e
;    dec hl
;    dec hl
;    ld bc, BAR_DATA.call_table2_dummy_stop - BAR_DATA.call_table2_dummy_start - 2
;    ldir
;
;.copy_last_effect_call
;    pop hl
;    LDI2
    inc hl
    inc hl
    ld de, BAR_DATA.call_table2_dummy_stop
    LDI2
    ret


;;
; The aim of this method is to clear the memory screen for ALL the variations of bars
; TODO Speed up it ?
; TODO configure it ?
bar_clear_memory_screen
.address equ $+1
    ld hl, 0xc000
.skip_hl
    ld d, h
    ld e, l
    inc de
    
    ld a, MODE0_INK14_INK15
    ld (hl), a

    ld bc, 96-1
    ldir
    ret

; This address embeds a dummy method
dummy_method ret

;;
; progressively patche the call_table in order to make appear the effect
; INPUT:
; - DE
bar_manage_appearance

 if 0
.slow_down equ $+1
    ld a, 1
    or a
    jr z, .no_slow_down

.slow_down_value equ $+1
    ld a, 0
    inc a
.slow_down_factor
    and %11
    ld (.slow_down_value), a
    ret nz

.no_slow_down

    endif

.routine_of_interest equ $+1
    ld de, bar_mode_0_display_one_bar

;.nb_calls equ $+1
    ld b, 5
.loop
    push bc
    call .real_jump
    pop bc
    djnz .loop
    ret

.real_jump
.table_address equ $+1
    ld hl, BAR_DATA.call_table_last_call -1
    
.table_address_test equ $+1
    ld bc, BAR_DATA.call_table_start+1
    sbc hl, bc
    jp c, .event_manage

    ld hl, (.table_address)

    ld (hl), d
    dec hl
    ld (hl), e
    dec hl

    ld (.table_address), hl
    ret
.reset
    ld (.routine_of_interest), hl
    ld (.table_address), de
    ld (.table_address_test), bc
    ret
.event_manage
    pop bc
    pop bc
    jp event_manage
;;


bar_manage_disappearance
.routine_of_interest equ $+1
    ld de, do_nothing

;.nb_calls equ $+1
    ld b, 5
.loop
    push bc
    call .real_jump
    pop bc
    djnz .loop
    ret

.real_jump
.table_address equ $+1
    ld hl, BAR_DATA.call_table_start
.table_address_end equ $+1
    ld bc, BAR_DATA.call_table_last_call
    or a
    sbc hl, bc
    jr z, bar_manage_appearance.event_manage

    ld hl, (.table_address)

    ld (hl), e
    inc hl
    ld (hl), d
    inc hl

    ld (.table_address), hl
    ret

.reset
    ; input de: method
    ld (.routine_of_interest), hl
    ld (.table_address), de
    ld (.table_address_end), bc

    ld hl, bar_manage_disappearance
    ld (bar_display_frame.event_routine), hl
    ret


bar_wait_some_frames
.counter equ $+1
    ld bc, 1
    dec bc
    ld (.counter), bc

    ld a, b
    or a
    ret nz
    cp c
    jp z, event_manage
    ret


do_nothing2
    defs 64
do_nothing
    defs 64-3
    ret



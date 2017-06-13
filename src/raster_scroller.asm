RASTER_SCROLL_EFFECT_HEIGHT equ EFFECT_HEIGHT + 6 - 4 - 2 + 9 


RASTER_SCROLL_BLOC_HEIGHT equ 16+8 
RASTER_SCROLL_NB_BLOCS equ 8
RASTER_SCROLL_NB_VISIBLE_LINES equ RASTER_SCROLL_BLOC_HEIGHT * RASTER_SCROLL_NB_BLOCS
RASTER_SCROLL_NB_LOST_LINES = RASTER_SCROLL_EFFECT_HEIGHT - RASTER_SCROLL_NB_VISIBLE_LINES 
RASTER_SCROLL_BACKGROUND_COLOR equ BACKGROUND_INKA_COLOR
RASTER_SCROLL_LINE_NB_OUT equ 13

OPCODE_OUT_C equ 0x49ed
OPCODE_OUT_E equ 0x59ed

OPCODE_BACKGROUND equ OPCODE_OUT_C
OPCODE_FOREGROUND equ OPCODE_OUT_E



    macro RASTER_SCROLL_GET_OPCODE
        rra
        jr c, .case2\@
.case1\@
        ld hl, OPCODE_BACKGROUND
        jr .endcase\@
.case2\@
        ld hl, OPCODE_FOREGROUND
.endcase\@
    endm



RASTER_SCROLL_LINE_COMMON_TIME equ 3 + 5 + 2 +2 + 4*RASTER_SCROLL_LINE_NB_OUT 
    macro RASTER_SCROLL_LINE_COMMON
        ld e, (hl)  ; 2
        inc hl      ; 2
.opcodes
        repeat RASTER_SCROLL_LINE_NB_OUT
            dw OPCODE_BACKGROUND
        endrepeat    ; 4*12

        defs 64 - RASTER_SCROLL_LINE_COMMON_TIME 
        ret         ; 3 + (5 of call) + 4*12
    endm
        



raster_scroll_line1
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line2
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line3
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line4
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line5
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line6
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line7
    RASTER_SCROLL_LINE_COMMON
raster_scroll_line8
    RASTER_SCROLL_LINE_COMMON







raster_scroll_display
    di


    ; XXX Add wait time

.move_control equ $+1
    jr .move+2
.move
    defs 4



    if 0
    defs 42 - 16 - 10
    ld a, RASTER_SCROLL_NB_LOST_LINES/2
.wait1_loop
    defs 61 - 1 -3
    dec a                   ; 1
    jr nz, .wait1_loop      ; 3
    else
        LONG_WAIT_CYCLES RASTER_SCROLL_NB_LOST_LINES/2*64 + ( 42 - 16 - 13) - 64 +1 -2
    endif

.selected_palette equ $+1
    ld hl, 0000;RASTER_SCROLL_DATA_COLORS_colors_start1
    ld bc, 0x7f00 + RASTER_SCROLL_BACKGROUND_COLOR
    ld a, BACKGROUND_INKA
    out (c), a
    out (c), c




    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line1
    endrepeat
  
    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line2
    endrepeat
    
    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line3
    endrepeat   

    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line4
    endrepeat

    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line5
    endrepeat

    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line6
    endrepeat

    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line7
    endrepeat

    repeat RASTER_SCROLL_BLOC_HEIGHT
        call raster_scroll_line8
    endrepeat



    dw OPCODE_BACKGROUND

    if 0
    ld a, RASTER_SCROLL_NB_LOST_LINES/2
.wait2_loop
    defs 61 - 1 -3
    dec a                   ; 1
    jr nz, .wait2_loop      ; 3
    else
        LONG_WAIT_CYCLES RASTER_SCROLL_NB_LOST_LINES/2*64 + 2*64 
    endif




.move_control2 equ $+1
    jr .move2+2
.move2
    defs 4
    ret

need_to_call_event_manage
    ld c, 7
    ld hl, random_select_color_palette_single.palette_table_single
    call random_select_color_palette_single
    ld (bar_display_frame.palette), bc
    jp event_manage

raster_scroll_frame_init
    ld hl, (raster_scroll_frame_init.scroll_pos)
    ld a, (hl)
    cp 255
    jr z, need_to_call_event_manage

.move_horizontally
    ld a, (raster_scroll_display.move_control)
    inc a
    inc a
    and 3
    ld (raster_scroll_display.move_control), a
    sub 4
    neg
    ld (raster_scroll_display.move_control2), a
    ld a, (raster_scroll_display.move_control)
    cp 0
    ret nz

.scroll_horizontally
    ld hl, raster_scroll_line1.opcodes+2
    ld de, raster_scroll_line1.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line2.opcodes+2
    ld de, raster_scroll_line2.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line3.opcodes+2
    ld de, raster_scroll_line3.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line4.opcodes+2
    ld de, raster_scroll_line4.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line5.opcodes+2
    ld de, raster_scroll_line5.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line6.opcodes+2
    ld de, raster_scroll_line6.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line7.opcodes+2
    ld de, raster_scroll_line7.opcodes
    call .do_scroll_horizontally
    ld hl, raster_scroll_line8.opcodes+2
    ld de, raster_scroll_line8.opcodes
    call .do_scroll_horizontally


.add_column

.get_column_representation ; Return in A the encoding of the char column
.representation_step equ $+1
    ld a, 7
    inc a
    and 7
    ld (.representation_step), a
    jr nz, .no_change
.change_of_char
    
.get_char_address ; Compute the address of the char representation

.get_next_char_code ; Read the text
.scroll_pos equ $+1
    ld hl, RASTER_SCROLL_DATA.text1
    ld a, (hl)
    inc hl
    ld (.scroll_pos), hl

    ld h, 0
    ;sub a, 97-65
    ld l, a
    ld de, FONT_start
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8
    add hl, de





    ld (.char_code_address), hl
.no_change
.char_code_address equ $+1
    ld hl, FONT_start
    ld a, (hl)
    inc hl
    ld (.char_code_address), hl

    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line1.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line2.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line3.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line4.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line5.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line6.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line7.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
    RASTER_SCROLL_GET_OPCODE
    ld (raster_scroll_line8.opcodes + 2*RASTER_SCROLL_LINE_NB_OUT -2), hl
 
    ret

.do_scroll_horizontally
    if 1
        repeat RASTER_SCROLL_LINE_NB_OUT*2
            ldi
        endrepeat
    else
        ld bc, RASTER_SCROLL_LINE_NB_OUT*2
        ldir
    endif
    ret





    macro RASTER_CLEAR
        abyte -32, '   '
    endm




fill_scroll_buffer_table
    ld (hl), d
    inc hl
    ld (hl), e
    ld d, h
    ld e, l
    dec hl
    inc de
    ld bc, EFFECT_HEIGHT-2
    ldir
    ret




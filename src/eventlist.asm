   

event_table
 if 0
;    dw display_scroller5
;        dw appearance_bar1a
;    dw event_wait

;    dw appearance_shades
;  dw event_wait


 ;   dw appearance_bar_fat
 ;   dw event_wait


 ;   dw display_scroller5
    dw appearance_bar_monochrome
   dw event_wait
 ;   dw display_scroller5

     else
    if ACTIVATE_RASTERS
        dw appearance_rasterbar1
        dw event_wait
        dw disappearance_rasterbar1
    endif



    dw display_scroller1
    dw appearance_bar1a
    dw event_wait
    dw disappearance_bar1


    dw display_scroller5
    dw appearance_bar_fat
    dw event_wait
    dw disappearance_bar1

;
    dw display_scroller2
    dw appearance_bar2
    dw event_wait
    dw disappearance_bar5
;
    dw display_scroller3
    dw appearance_bar1b
    dw cut_bar1
    dw event_wait
    dw disappearance_bar1
;
    dw display_scroller4
    dw preparation_bar_reversed
    dw appearance_bar_reversed
    dw event_wait
    dw disappearance_bar_reversed1
    dw disappearance_bar_reversed2

    dw display_scroller7
    dw appearance_bar_monochrome
    dw event_wait
    dw disappearance_bar1



   ; if ENABLE_TAF
        dw display_scroller6
        dw appearance_shades
        dw event_wait
       ; dw fire_transform
       ; dw event_wait
        dw disappearance_bar1
   ; endif
    ;


  ;  dw display_scroller_end
  dw event_wait_music_end
;
 endif
    dw 0
  
 
  
  if ACTIVATE_RASTERS
appearance_rasterbar1
    ld hl, rasterbar_configuration
    call bar_select_variation 

    ld hl, bar_manage_appearance
    ld (bar_display_frame.event_routine), hl

 
 ;   ld a, 1
 ;   ld (bar_manage_appearance.nb_calls),a 

    ld hl, rasterbar_display_one_bar
    ld bc, BAR_DATA.call_table_start+1 + ((BAR_DATA.call_table_last_call  - BAR_DATA.call_table_start) / 2) 
    ld de, BAR_DATA.call_table_last_call - 1
    jp bar_manage_appearance.reset


disappearance_rasterbar1
    ld hl, bar_manage_disappearance
    ld (bar_display_frame.event_routine), hl

 ;   ld a, 5
 ;   ld (bar_manage_disappearance.nb_calls),a 


    ld hl, do_nothing
    ld bc,BAR_DATA.call_table_last_call
    ld de, BAR_DATA.call_table_start
    jp bar_manage_disappearance.reset

    endif

display_scroller1
    ld hl, RASTER_SCROLL_DATA.text1
    jp display_scroller
display_scroller2
    ld hl, RASTER_SCROLL_DATA.text2
    jp display_scroller
display_scroller3
    ld hl, RASTER_SCROLL_DATA.text3
    jp display_scroller
display_scroller4
    ld hl, RASTER_SCROLL_DATA.text4
    jp display_scroller
display_scroller5
    ld hl, RASTER_SCROLL_DATA.text5
    jp display_scroller
display_scroller6
    ld hl, RASTER_SCROLL_DATA.text6
    jp display_scroller
display_scroller7
    ld hl, RASTER_SCROLL_DATA.text7
 ;    jp display_scroller


;display_scroller_end
;    ld hl, RASTER_SCROLL_DATA.text_end
;    ld de, RASTER_SCROLL_DATA_COLORS_colors_start4
display_scroller
    ld (raster_scroll_frame_init.scroll_pos), hl

    ld hl, random_select_color_palette_single.palette_scroller
    ld c, 3
    call random_select_color_palette_single
    ld (raster_scroll_display.selected_palette), bc

    ld hl, raster_scroll_display
    ld de, raster_scroll_frame_init
    ld bc, dummy_method
    ld (bar_display_frame.bar_display_effect), hl
    ld (bar_display_frame.init_routine), de
    ld (bar_display_frame.event_routine), bc
    ret

; Set color value in bc
random_select_color_palette_single
    ld a, r
.previous equ $+1
    xor 0
    ld (.previous), a
 ;   and 7
    and c
    add a
    ld e, a
    ld d, 0
 ;   ld hl, .palette_table_single
    add hl, de
    ld c, (hl)
    inc hl
    ld b, (hl)
    ret


.palette_table_single
    dw PALETTE_MIRROR
    dw PALETTE_DOUBLE
    dw PALETTE_SINGLE
    dw PALETTE_REVERSED
    dw PALETTE_EXTRA5
    dw PALETTE_EXTRA6
    dw PALETTE_EXTRA7
    dw PALETTE_EXTRA8
.end_of_palette
.palette_shades
    dw PALETTE_SHADES
    dw PALETTE_SHADES2
    dw PALETTE_SHADES3
    dw PALETTE_SHADES4
.palette_scroller
    dw RASTER_SCROLL_DATA_COLORS_colors_start1
    dw RASTER_SCROLL_DATA_COLORS_colors_start2
    dw RASTER_SCROLL_DATA_COLORS_colors_start3
    dw RASTER_SCROLL_DATA_COLORS_colors_start4
.palette_fat
    dw PALETTE_FAT1
    dw PALETTE_FAT2
.palette_tramed
    dw PALETTES_TRAMES1
    dw PALETTES_TRAMES2
 ;   dw PALETTES_TRAMES3
 ;   dw PALETTES_TRAMES4

appearance_bar1a
;    ld hl, CURVE1
;    jr appearance_bar1

appearance_bar1b
    ld hl, CURVE1
 ;   jr appearance_bar1

    ; Select mode 0 variation
    ; => make appear
appearance_bar1
    ld (bar_mode0_display.curve2_pos), hl

    ld hl, bar_mode0_configuration
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de
    call bar_select_variation


    ld hl, BAR_DATA.bar_erase
    ld (bar_mode0_display.de_value), hl


 ;   ld a, 5
 ;   ld (bar_manage_appearance.nb_calls),a 

    ld hl, MODE0_PIXEL0_INK5*256 + MODE0_PIXEL1_INK1
    ld (bar_mode0_display.bc_value), hl

    ld de, 0x01fe
    ld a, d
    ld (bar_mode0_frameinit.delta1), a
    ld a, e
    ld (bar_mode0_frameinit.delta2), a

    ld hl, bar_mode_0_display_one_bar
    ld bc, BAR_DATA.call_table_start+1
    ld de, BAR_DATA.call_table_last_call - 1 -2
    jp bar_manage_appearance.reset


appearance_bar_monochrome
    ld hl, random_select_color_palette_single.palette_tramed
    ld c, 1
    call random_select_color_palette_single
    ld (bar_display_frame.palette), bc


    ld hl, CURVE1
    ld (bar_mode0_display.curve2_pos), hl

    ld hl, bar_mode0_configuration
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de
    call bar_select_variation


    ld hl, BAR_DATA.bar_erase
    ld (bar_mode0_display.de_value), hl

    ; XXX keep that to crunch better ...
    ld hl, 0x7f00
    ld (bar_mode0_display.bc_value), hl

    ld hl, (bar_display_frame.palette)
;    ld de, 4
;    add hl, de
    repeat 4
        inc hl
    endrepeat
    ld de, bar_mode0_display.de_value
    ldi 
    ldi

    ld de, 0xfe01
    ld a, d
    ld (bar_mode0_frameinit.delta1), a
    ld a, e
    ld (bar_mode0_frameinit.delta2), a

    ld hl, bar_mode0_monochrome
    ld bc, BAR_DATA.call_table_start+1
    ld de, BAR_DATA.call_table_last_call - 1 -2
    jp bar_manage_appearance.reset




    if ENABLE_TAF
appearance_shades
    ld hl, CURVE2
    ld (bar_mode0_display.curve2_pos), hl

    
    ld hl, bar_mode0_configuration
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de
    call bar_select_variation


    ld hl, BAR_DATA.bar_erase
    ld (bar_mode0_display.de_value), hl


 ;   ld a, 5
 ;   ld (bar_manage_appearance.nb_calls),a 

    ld hl, MODE0_PIXEL0_INK5*256 + MODE0_PIXEL1_INK1
    ld (bar_mode0_display.bc_value), hl

    ld de, 0xffff
  ;  ld a,  -1 ;197
    ld a, d
    ld (bar_mode0_frameinit.delta1), a
   ; ld a, -1 ;-37
    ld a, e
    ld (bar_mode0_frameinit.delta2), a

    ld a, 3
    ld (bar_mode_0_shadebobs.delta1), a

    ld a, 1
    ld (bar_mode_0_shadebobs.delta2), a

    ld hl, random_select_color_palette_single.palette_shades
    ld c, 3
    call random_select_color_palette_single
    ld (bar_display_frame.palette), bc

    ld hl, bar_mode_0_shadebobs
    ld bc, BAR_DATA.call_table_start+1
    ld de, BAR_DATA.call_table_last_call - 1 -2
    jp bar_manage_appearance.reset

 if 0
fire_transform
 if 1
    ld de, 197 + -37*256
    ld d,  a
    ld (bar_mode0_frameinit.delta1), a
    ld e, a
    ld (bar_mode0_frameinit.delta2), a
 endif

    ld de, 31*256 + 197
    ld a, d
    ld (bar_mode_0_shadebobs.delta1), a
    ld a, e
    ld (bar_mode_0_shadebobs.delta2), a
    ret
    endif
 endif

preparation_bar_reversed
    ld hl, bar_mode0_reversed_configuration
    call bar_select_variation2


    ld hl, bar_manage_appearance
    ld (bar_display_frame.event_routine), hl

 ;    ld a, 3
 ;   ld (bar_manage_appearance.nb_calls),a 


    ; This effect takes 2 lines per bar
    ld hl, bar_mode_0_display_one_completebar
    ld bc, BAR_DATA.call_table2_start+1 
    ld de, BAR_DATA.call_table2_last_call - 1
    jp bar_manage_appearance.reset


appearance_bar_reversed
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de

 ;   ld a, 5
 ;   ld (bar_manage_appearance.nb_calls),a 

    ld hl, MODE0_PIXEL0_INK13*256 + MODE0_PIXEL1_INK1
    ld (bar_mode0_display.bc_value), hl


    ; This effect takes 2 lines per bar
    ld hl, bar_mode_0_display_and_remove_one_bar
    ld bc, BAR_DATA.call_table2_start+1 
    ld de, BAR_DATA.call_table2_last_call - 1
    jp bar_manage_appearance.reset


disappearance_bar_reversed1
 ;   ld a, 3
 ;   ld (bar_manage_disappearance.nb_calls),a 


    ; This effect takes 2 lines per bar
    ld hl,  bar_mode_0_display_one_completebar
    ld bc,BAR_DATA.call_table2_last_call
    ld de, BAR_DATA.call_table2_start
    jp bar_manage_disappearance.reset

disappearance_bar_reversed2


 ;   ld a, 2
 ;   ld (bar_manage_disappearance.nb_calls),a 


    ; This effect takes 2 lines per bar
    ld hl,  do_nothing2
    ld bc,BAR_DATA.call_table2_last_call
    ld de, BAR_DATA.call_table2_start
    jp bar_manage_disappearance.reset

    ; wait
event_wait

    
    ld hl, bar_wait_some_frames
    ld (bar_display_frame.event_routine), hl

    ld hl, WAIT_DURATION
    ld (bar_wait_some_frames.counter), hl
    ret


cut_bar1
    ld hl, bar_manage_appearance
    ld (bar_display_frame.event_routine), hl

    ;xor a
    ;ld (bar_manage_appearance.slow_down),a 

 ;   ld a, 1
 ;   ld (bar_manage_appearance.nb_calls),a 

    ld hl, bar_mode_0_remove_one_bar
    ld bc, BAR_DATA.call_table_start+1 + ((BAR_DATA.call_table_last_call  - BAR_DATA.call_table_start) / 2) 
    ld de, BAR_DATA.call_table_last_call - 1
    jp bar_manage_appearance.reset

    ; => make disapear
disappearance_bar1
disappearance_bar5


 ;   ld a, 5
 ;   ld (bar_manage_disappearance.nb_calls),a 


    
    ld hl, do_nothing
    ld bc,BAR_DATA.call_table_last_call
    ld de, BAR_DATA.call_table_start
    jp bar_manage_disappearance.reset




appearance_bar2

    ld hl, CURVE2
    ld (bar_mode0_display.curve2_pos), hl

    ld hl, bar_mode0_configuration
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de
    call bar_select_variation


 ;   ld a, 5
 ;   ld (bar_manage_appearance.nb_calls),a 


    ld hl, MODE0_MASK_PIXEL1*256 + MODE0_MASK_PIXEL0 
    ld (bar_mode0_display.de_value), hl
   
    ld hl, MODE0_PIXEL0_INK5*256 + MODE0_PIXEL1_INK1
    ld (bar_mode0_display.bc_value), hl


    ld de, 0xfe01
    ld a, d
    ld (bar_mode0_frameinit.delta1), a
    ld a, e
    ld (bar_mode0_frameinit.delta2), a

    ld hl, bar_mode_0_display_two_bars
    ld bc, BAR_DATA.call_table_start+1
    ld de, BAR_DATA.call_table_last_call - 1 -2
    jp bar_manage_appearance.reset


appearance_bar_fat

    ld hl, CURVE1
    ld (bar_mode0_display.curve2_pos), hl

        ld hl, bar_mode0_configuration
    ld de, bar_manage_appearance
    ld (bar_display_frame.event_routine), de
    call bar_select_variation


 ;   ld a, 5
 ;   ld (bar_manage_appearance.nb_calls),a 


    ld hl, MODE0_MASK_PIXEL1*256 + MODE0_MASK_PIXEL0 
    ld (bar_mode0_display.de_value), hl

    ld hl, MODE0_PIXEL0_INK13*256 + MODE0_PIXEL1_INK1
    ld (bar_mode0_display.bc_value), hl


    ld de, 0x0103
    ld a, d
    ld (bar_mode0_frameinit.delta1), a
    ld a, e
    ld (bar_mode0_frameinit.delta2), a


    ld hl, random_select_color_palette_single.palette_fat
    ld c, 1
    call random_select_color_palette_single
    ld (bar_display_frame.palette), bc

    ld hl, bar_mode_0_fat
    ld bc, BAR_DATA.call_table_start+1
    ld de, BAR_DATA.call_table_last_call - 1 -2
    jp bar_manage_appearance.reset



event_wait_music_end
    ld hl, wait_end_of_music
    ld (bar_display_frame.event_routine), hl
wait_end_of_music
    ld hl, (PLY_Linker_PT+1)
    ld a,(hl)
    rra
    ret nc
event_manage
.event_address equ $+1
    ld hl, event_table
.restart
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl

    ld a, b
    cp c
    jr z, .reset
.continue
    ld (.event_address), hl

    ld h, b
    ld l, c

    jp (hl)

.reset
    ld hl, event_table
    jr .restart




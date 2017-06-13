    org 0x4000
    assert start == 0x4000

    include lib/crtc.asm
    include lib/ga.asm
    include lib/pixels.asm
    include lib/wait.asm
    include lib/system.asm
    include lib/utils.asm
    include lib/debug.asm
    include config.asm
    if ENABLE_INTRO_SOUND
        include src/amsdos-music.asm
    endif


exo_mapbasebits equ 0xc000 - 256
STACK equ 0xb500
ACTIVATE_RASTERS equ 0
FONT_SIZE equ 255*8
    macro MANAGE_FONT_BIT, bit
        push hl

        ld a, (de)
        inc de
        
        rla
        jr nc, .nobit0\@
        set \bit, (hl)
.nobit0\@
        inc hl

        rla
        jr nc, .nobit1\@
        set \bit, (hl)
.nobit1\@
        inc hl
 
        rla
        jr nc, .nobit2\@
        set \bit, (hl)
.nobit2\@
        inc hl

        rla
        jr nc, .nobit3\@
        set \bit, (hl)
.nobit3\@
        inc hl

        rla
        jr nc, .nobit4\@
        set \bit, (hl)
.nobit4\@
        inc hl

        rla
        jr nc, .nobit5\@
        set \bit, (hl)
.nobit5\@
        inc hl

        rla
        jr nc, .nobit6\@
        set \bit, (hl)
.nobit6\@
        inc hl

        rla
        jr nc, .nobit7\@
        set \bit, (hl)
.nobit7\@

        pop hl
    endm




start

    incbin ./data/KROCKET2.bin
; Include libraries
    include src/music.asm
    include lib/vsync.asm
    if ACTIVATE_RASTERS
       include rasters.asm
    endif
    include src/eventlist.asm
    include src/uncrunch.asm
    if ENABLE_TAF
      include src/shades.asm
    endif

    include raster_scroller.asm

    include src/ArkosTrackerPlayer_CPC_MSX.asm

    if ENABLE_MAZE
        include src/amsdos-leaving.asm
    endif
start_real





    if ENABLE_INTRO_SOUND
       PLAY_INTRO_MUSIC
    endif

    xor a

; Set speed ink
    ld hl,0x0101
    call FIRMWARE.SCR_SET_FLASHING

; Set color background
    ld bc, 1*256 + 1
    call FIRMWARE.SCR_SET_INK
    ld bc, 1*256 + 1
    call FIRMWARE.SCR_SET_BORDER

; Set color foreground
    ld a, 1
    ld bc, 19*256 + 18
    call FIRMWARE.SCR_SET_INK


; Wait in order to hear sound

    call event_manage

; Display one char line less in order to not see its drawing
    ld a, 24
    ld bc, 0xbc00 + 6
    out (c), c
    inc b
    out (c), a
    call get_font

 if ENABLE_MAZE
    ld b, 0
.wait_loop
    push bc
        call secure_vsync
    pop bc
    djnz .wait_loop
    call leaving
 endif
 if ENABLE_TAF
 ;   ld hl, crtc_table_r10
 ;   CRTC_SET_VALS 
    ld bc, 0xbc00 + 1
    out (c), c
    inc b
    dec c
    out (c), c
    call system_build_shadeobs_tables
 endif


 ;   defs 40 ; stack

    KILL_SYSTEM
    ld sp, STACK


init_demo




.uncrunch_curves
    ld hl, CURVE1_crunched
    ld de, CURVE1
    ld b, 0
 ;   call uncrunch
    UNCRUNCH

    ld hl, CURVE1
   ; ld de, CURVE2 It is already the case !
    ld a, 128
.loop_curve1
        ldi
        inc hl
        inc de
        dec a
        jr nz, .loop_curve1

  ld hl, CURVE1+64
    ld de, CURVE2+1
    ld a, 128
.loop_curve2
        ldi
        inc hl
        inc de
        dec a
        jr nz, .loop_curve2



    if 0
    ld hl, CURVE2_crunched
    ld de, CURVE2
    ld b, 128
    call uncrunch
    ld hl, CURVE2 + 32
    ld de, CURVE2 + 127
    ld bc, 128
    ldir
    ld hl, CURVE2
    call split_curve
    endif

    if ACTIVATE_RASTERS
        ld hl, CURVE3
        ld b, 255
        call inplace_uncrunch
    endif





    call get_font
.mirror_font
    ld hl, FONT_start
    ld de, garbage
    ld a, FONT_SIZE/8
.mirror_font_loop
    push af
.manage_one_char

    ; Ensure we erase memory
    ld (hl), 0

    MANAGE_FONT_BIT 0
    MANAGE_FONT_BIT 1
    MANAGE_FONT_BIT 2
    MANAGE_FONT_BIT 3
    MANAGE_FONT_BIT 4
    MANAGE_FONT_BIT 5
    MANAGE_FONT_BIT 6
    MANAGE_FONT_BIT 7

    repeat 8
        inc hl
    endrepeat

    pop af
    dec a
    jp nz, .mirror_font_loop


.manage_sreen
    ld hl, 0xc000 + 96
    ld (bar_clear_memory_screen.address), hl
    call bar_clear_memory_screen
    ld hl, 0xc000
    ld (bar_clear_memory_screen.address), hl
    call bar_clear_memory_screen ; crunch better by ,ot skiping hl


    if ENABLE_MUSIC
.music
    ld de, 0x4000
    call PLY_Init
    endif

.set_scroll_colors
    ld hl, RASTER_SCROLL_DATA_COLORS_colors_start1

    ld de, GA_COL_4*256 + GA_COL_7
    call fill_scroll_buffer_table

    ld hl, RASTER_SCROLL_DATA_COLORS_colors_start2
    ld de, GA_COL_11*256 + GA_COL_10
    call fill_scroll_buffer_table

    ld hl, RASTER_SCROLL_DATA_COLORS_colors_start3
    ld de, GA_COL_13*256 + GA_COL_24
    call fill_scroll_buffer_table

    ld hl, RASTER_SCROLL_DATA_COLORS_colors_start4
    ld de, GA_COL_9*256 + GA_COL_19
    call fill_scroll_buffer_table


.set_bars_colors
.COPY_5 macro
    if 1
        ld bc, 5
        ldir
    else
        ldi
        ldi
        ldi
        ldi
        ldi
    endif
    endm

    if PREPROCESS_BARS_PALETTES

    ld de, BACKGROUND_INKB_COLOR*256 + BACKGROUND_INKA_COLOR
    ld hl, PALETTE_BUILD_START
    ld (hl), e
    inc hl
    ld (hl), d
    ld hl, PALETTE_BUILD_START
    ld de, PALETTE_BUILD_START + 2
    ld bc, PALETTE_BUILD_END - PALETTE_BUILD_START
    ldir

    ld  sp, random_select_color_palette_single.palette_table_single
    ld hl, PALETTE_SIMPLE_REAL_VALUE
    repeat 4
        pop de
        inc de
        .COPY_5
    endrepeat

    ld sp, STACK

    endif

;.crtc
 ;   call secure_vsync
 ;   ld hl, crtc_table
 ;   CRTC_SET_VALS 



;;
; Really launch the demo
play_demo
    include bar.asm
    include bar-mode0.asm







get_font
    call FIRMWARE.kl_l_rom_enable

    ld hl,0x3900
    ld de,garbage
    ld bc,FONT_SIZE
    ldir

    call FIRMWARE.kl_l_rom_disable
    call FIRMWARE.kl_u_rom_disable
    ret





    include src/data.asm




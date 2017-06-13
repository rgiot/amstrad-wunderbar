;;
; In order to improve crunching rate, data are move here

; Not aligned data




    if ENABLE_INTRO_SOUND
        DATA_INTRO_MUSIC
    endif

    if ENABLE_MAZE
AMSDOS_LEAVING_TEXT
    abyte -32, " CPC "
    abyte -32, "RULEZ"
    abyte -32, '     '
    abyte -32, '     '
    abyte -32, '     '
    endif

RASTER_SCROLL_DATA
.text1 
 ;   abyte -32, 'Wunderbar raises the bar at Revision2017'
    abyte -32, ' ', 250, " Wunderbar ", 251
    RASTER_CLEAR
    db 255
.text2
    abyte -32, "Double lust"
    RASTER_CLEAR
    db  255
.text3
    abyte -32, 'Symmetry'
    RASTER_CLEAR
    db 255
.text4
    abyte -32, 'Mirror idol'
    RASTER_CLEAR
    db 255
.text5
    abyte -32, 'Size matters'
    RASTER_CLEAR
    db 255

    if ENABLE_TAF
.text6
    abyte -32,  228, " Revision ", 228
    RASTER_CLEAR
    db 255
    endif


.text7
    abyte -32,  248, " Better naked ", 248
    RASTER_CLEAR
    db 255

;.text_end
;    abyte -32, 'Benediction raised the bar @ Revision2017'
;    RASTER_CLEAR
;    db 255


    macro PALETTE1
    db GA_COL_26
    db GA_COL_25
    db GA_COL_16
    db GA_COL_7
    db GA_COL_4
    endm

    macro PALETTE2
    db GA_COL_26
    db GA_COL_25
    db GA_COL_16
    db GA_COL_7
    db GA_COL_3
    endm

    macro PALETTE3
    db GA_COL_26
    db GA_COL_23
    db GA_COL_22
    db GA_COL_14
    db GA_COL_10
    endm

    macro PALETTE4
    db GA_COL_26
    db GA_COL_25
    db GA_COL_21
    db GA_COL_10
    db GA_COL_9
    endm

    macro PALETTE5 
    db GA_COL_25
    db GA_COL_22
    db GA_COL_14
    db GA_COL_5
    db GA_COL_4
    endm

    macro PALETTE6
    db GA_COL_26
    db GA_COL_24
    db GA_COL_15
    db GA_COL_12
    db GA_COL_4
    endm

    macro PALETTE7
    db GA_COL_26
    db GA_COL_25
    db GA_COL_16
    db GA_COL_8
    db GA_COL_4
    endm

    macro PALETTE8
    db GA_COL_23
    db GA_COL_17
    db GA_COL_8
    db GA_COL_7
    db GA_COL_3
    endm



    if PREPROCESS_BARS_PALETTES

PALETTE_SIMPLE_REAL_VALUE
.mirror
    PALETTE1
.double
    PALETTE2
.single
    PALETTE3
.reversed
    PALETTE4

    else

    macro PALETTE_TABLE_END
        repeat 8
            db 0x54
        endrepeat
        db BACKGROUND_INKA_COLOR
        db BACKGROUND_INKB_COLOR
    endm

PALETTE_MIRROR 
    db 0x54
    PALETTE1
    PALETTE_TABLE_END
PALETTE_DOUBLE
    db 0x54
    PALETTE2
    PALETTE_TABLE_END

PALETTE_SINGLE
    db 0x54
    PALETTE3
    PALETTE_TABLE_END

PALETTE_REVERSED
    db 0x54
    PALETTE4
    PALETTE_TABLE_END


PALETTE_EXTRA5
    db 0x54
    PALETTE5
    PALETTE_TABLE_END


PALETTE_EXTRA6
    db 0x54
    PALETTE6
    PALETTE_TABLE_END


PALETTE_EXTRA7
    db 0x54
    PALETTE7
    PALETTE_TABLE_END


PALETTE_EXTRA8
    db 0x54
    PALETTE8
    PALETTE_TABLE_END


    endif



PALETTES_TRAMES1

;current red
    db &54
    db &5C
    db &58
    db &54
    db &4C
    db &45
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR


PALETTES_TRAMES2
;current green
    db &54
    db &46
    db &56
    db &54
    db &52
    db &59
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db &54
    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR

PALETTE_SHADES
    db &54
    db &44
    db &58
    db &5C
    db &56
    db &4E
    db &52
    db &5A
    db &51
    db &59
    db &5B
    db &4A
    db &43
    db &4B


    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR

PALETTE_SHADES3
    db &54
    db &44
    db &58
    db &5C
    db &4C
    db &45
    db &4E
    db &47
    db &4F
    db &59
    db &5B
    db &4A
    db &43
    db &4B
     
    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR



PALETTE_SHADES2
    db &54
    db &5C
    db &4C
    db &45
    db &4D
    db &4E
    db &47
    db &4F
    db &53
    db &59
    db &5B
    db &4A
    db &43
    db &4B

    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR


PALETTE_SHADES4
    db &54
    db &44
    db &58
    db &5D
    db &5F
    db &4F
    db &41
    db &51
    db &53
    db &59
    db &5B
    db &4A
    db &43
    db &4B

    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR




PALETTE_FAT1
    db &5C
    db &58
    db &45
    db &4D
    db &47
    db &4F
    db &59
    db &4A
    db &4B
    db &43
    db &5B
    db &4F
    db &5F
    db &5D

    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR


PALETTE_FAT2
    db &5C
    db &5C
    db &4C
    db &4D
    db &47
    db &4F
    db &5B
    db &4B
    db &43
    db &59
    db &51
    db &5F
    db &5D
    db &58
    db BACKGROUND_INKA_COLOR
    db BACKGROUND_INKB_COLOR




    if ENABLE_SOUND_ANALYSIS
PALETTE_SOUND
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_1
        db GA_COL_4
    endif




crtc_table
    db CRTC_HORIZONTAL_DISPLAYED_CHARACTER_NUMBER, 96/2
    db CRTC_POSITION_HORIZONTAL_SYNC_PULSE, 50
    db 0xff



; Aligned data
; XXX Add the real data curves
CURVE0_crunched
CURVE1_crunched
    include generated/crunched-curve1.asm
;CURVE2_crunched
;    include generated/crunched-curve2.asm
    if ACTIVATE_RASTERS
CURVE3_crunched
    include generated/crunched-curve3.asm
    endif

    assert CURVE2 == CURVE1 + 256
    if ACTIVATE_RASTERS
    assert CURVE3 == CURVE2 + 256
    endif






; List of data needed by the effect
BAR_DATA
; Each routine is simply called thanks to a ret
.call_table_start
.call_table_dummy_start
    repeat BAR_EFFECT_HEIGHT
        dw do_nothing  ; 64 nops routine
    endrepeat
.call_table_dummy_stop
.call_table_last_call
    dw dummy_method
.call_table_end


.call_table2_start
.call_table2_dummy_start
    repeat BAR_EFFECT_HEIGHT/2
        dw do_nothing2  ; 64 nops routine
    endrepeat
.call_table2_dummy_stop
.call_table2_last_call
    dw dummy_method
.call_table2_end


    repeat BAR_EFFECT_HEIGHT/2
        db MODE0_INK14_INK15, MODE0_INK14_INK15, MODE0_INK14_INK15, 96
    endrepeat

.bar_erase
    repeat BAR_EFFECT_HEIGHT/2
        db 0, 0, 0, 0
    endrepeat
.bar_erase_last equ $-1
.bar_erase2
    repeat BAR_EFFECT_HEIGHT/2
        db 0, 0, 0, 0
    endrepeat
.bar_erase2_last equ $-1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Full of 0


FULL_OF_0 equ $


PSG_START equ FULL_OF_0

;There are two holes in the list, because the Volume registers are set relatively to the Frequency of the same Channel (+7, always).
;Also, the Reg7 is passed as a register, so is not kept in the memory.
PLY_PSGRegistersArray equ PSG_START
PLY_PSGReg0 equ PLY_PSGRegistersArray+0
PLY_PSGReg1  equ PLY_PSGRegistersArray+1
PLY_PSGReg2  equ PLY_PSGRegistersArray+2
PLY_PSGReg3  equ PLY_PSGRegistersArray+3
PLY_PSGReg4  equ PLY_PSGRegistersArray+4
PLY_PSGReg5  equ PLY_PSGRegistersArray+5
PLY_PSGReg6  equ PLY_PSGRegistersArray+6
PLY_PSGReg8  equ PLY_PSGRegistersArray+7
PLY_PSGReg9  equ PLY_PSGRegistersArray+9
PLY_PSGReg10  equ PLY_PSGRegistersArray+11
PLY_PSGReg11   equ PLY_PSGRegistersArray+12
PLY_PSGReg12   equ PLY_PSGRegistersArray+13
PLY_PSGReg13   equ PLY_PSGRegistersArray+14
PLY_PSGRegistersArray_End  equ PLY_PSGRegistersArray+15



PSG_END equ PLY_PSGRegistersArray_End


    if PREPROCESS_BARS_PALETTES
PALETTE_BUILD_START equ PSG_END
PALETTE_MIRROR equ PALETTE_BUILD_START
PALETTE_DOUBLE equ PALETTE_MIRROR + 16
PALETTE_SINGLE equ PALETTE_DOUBLE + 16
PALETTE_REVERSED equ PALETTE_SINGLE + 16
PALETTE_BUILD_END equ PALETTE_REVERSED + 16
    else
PALETTE_BUILD_END equ PSG_END
    endif

RASTER_SCROLL_DATA_COLORS equ PALETTE_BUILD_END

RASTER_SCROLL_DATA_COLORS_colors_start1 equ RASTER_SCROLL_DATA_COLORS
RASTER_SCROLL_DATA_COLORS_colors_start2 equ  RASTER_SCROLL_DATA_COLORS_colors_start1 + EFFECT_HEIGHT
RASTER_SCROLL_DATA_COLORS_colors_start3 equ  RASTER_SCROLL_DATA_COLORS_colors_start2 + EFFECT_HEIGHT
RASTER_SCROLL_DATA_COLORS_colors_start4 equ  RASTER_SCROLL_DATA_COLORS_colors_start3 + EFFECT_HEIGHT
RASTER_SCROLL_DATA_COLORS_END equ RASTER_SCROLL_DATA_COLORS_colors_start4 + EFFECT_HEIGHT


FULL_OF_0_end equ RASTER_SCROLL_DATA_COLORS_END 


ALIGN_START equ 0x7000
    assert FULL_OF_0_end < ALIGN_START

CURVE1 equ ALIGN_START
CURVE2 equ CURVE1 + 0x100
    if ACTIVATE_RASTERS
CURVE3 equ CURVE1 +0x100
AFTER_CURVE equ CURVE3 + 0x100
    else
AFTER_CURVE equ CURVE2 + 0x100
    endif


    if ENABLE_TAF

SHADEBOBS_TABLE_LEFT equ AFTER_CURVE 
SHADEBOBS_TABLE_RIGHT equ SHADEBOBS_TABLE_LEFT + 0x100
SHADEBOBS_TABLE_BOTH equ SHADEBOBS_TABLE_RIGHT + 0x100
SHADEBOBS_TABLE_END equ SHADEBOBS_TABLE_BOTH + 0x100
    else
SHADEBOBS_TABLE_END equ AFTER_CURVE
    endif


FONT_start equ SHADEBOBS_TABLE_END
FONT_end equ FONT_start + FONT_SIZE


garbage equ FONT_end

    assert (garbage+FONT_SIZE) <0x9000

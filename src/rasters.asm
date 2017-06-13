


RASTERS_EFFECT_HEIGHT equ EFFECT_HEIGHT
    assert RASTERS_EFFECT_HEIGHT < 256


rasterbar_frameinit

; Manage the double buffering of the raster table
.flag equ $+1
    ld a, 1
    inc a
    and 1
    ld (.flag), a
    jr z, .step1
.step2   
    ld hl, RASTERS_DATA2.color_table_stop + RASTERS_EFFECT_HEIGHT % 2 
    ld de, RASTERS_DATA2
    ld bc, RASTERS_DATA1
    jr .endstep
.step1
    ld hl, RASTERS_DATA1.color_table_stop + RASTERS_EFFECT_HEIGHT % 2 
    ld de, RASTERS_DATA1
    ld bc, RASTERS_DATA2
.endstep

    ld (rasterbar_clear_raster_table.address), hl
    ld (rasterbar_display.write_table), de
    ld (rasterbar_display.read_table), bc

    call rasterbar_clear_raster_table


    ld a, (rasterbar_display.curve1_pos)
    add 3
    ld (rasterbar_display.curve1_pos), a

  ;  ld a, (rasterbar_display.curve2_pos)
  ;  add 5
  ;  ld (rasterbar_display.curve2_pos), a

    ret


; Really display the effect
rasterbar_display
.start
    ld bc, 0x7f00
    out (c), c
.read_table equ $+1
    ld hl, RASTERS_DATA1
    exx
.write_table equ $+1
        ld de, RASTERS_DATA2
.curve1_pos equ $+1
        ld hl, CURVE3
;.curve2_pos equ $+1
;        ld bc, CURVE2
    exx
    ld (.backup_sp), sp
.stack_pos equ $+1
        ld sp, BAR_DATA.call_table_start
    ret ; Call the effect
.end
.backup_sp equ $+1
        ld sp, 0
    ret ; Leave the effect


    ;;
    ; Manage the raster stuff
    macro RASTERBAR_COMMON
        ld a, (hl)  ; 2
        out (c), a  ; 4
        inc l       ; 1
    endm ; 7


rasterbar_display_one_bar
    RASTERBAR_COMMON ;7
    exx ; 1 nop
        ld e, (hl)  ; 2 nops
        ld a,  2
        add l
        ld l, a

        ;inc l  ; 1 nops
        ;inc l  ; 1 nops
        ;inc l  ; 1 nops
        ;inc l  ; 1 nops
        ;inc l  ; 1 nops

        ex de, hl ; 1
        ld (hl), GA_COL_26 ; 3
        inc l ;1
        ld (hl), 0x40 ; 3
        inc l ;1
        ld (hl), GA_COL_25 ; 3
        inc l ;1
        ld (hl), 0x4b ; 3
        inc l ;1
        ld (hl), GA_COL_24 ; 3
        inc l
        ld (hl), 0x4b; 3
        inc l ;1
        ld (hl), GA_COL_15 ; 3
        inc l ;1
        ld (hl), 0x40 ; 3
        inc l ;1
        ld (hl), GA_COL_6 ; 3
        inc l ;1
        ld (hl), 0x40 ; 3

        ex de, hl ; 1

    exx ;1 nops
; Total number of nops =  1+2+1+2+1+1+1+1+ 5*(3+1) +1
    defs 64 - 7 - 3 - (1+2+1+2+1+1+1+1+ 10*(3+1) + 1) + 2 +1 -4 + 2 + 1 
    ret



rasterbar_display_nothing
    RASTERBAR_COMMON ;7
    defs 64 - 7 - 3
    ret


rasterbar_configuration
    BAR_CONFIGURATION rasterbar_frameinit, rasterbar_display.start, rasterbar_display_nothing, rasterbar_display.end 



rasterbar_clear_raster_table
    di
    ld (.sp), sp

.address equ $+1
    ld sp, RASTERS_DATA1.color_table_stop + RASTERS_EFFECT_HEIGHT % 2 
    ld hl, 0x5454
    repeat RASTERS_EFFECT_HEIGHT/2
        push hl
    endrepeat
.sp equ $+1
    ld sp, 0
    ei
    ret

    align 8
RASTERS_DATA1
.color_table_start
    repeat RASTERS_EFFECT_HEIGHT
        db 0x54
    endr
.color_table_stop
    db 0x54


    align 8
RASTERS_DATA2
.color_table_start
    repeat RASTERS_EFFECT_HEIGHT
        db 0x54
    endr
.color_table_stop
    db 0x54


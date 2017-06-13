CRTC_R0 equ 0
CRTC_R1 equ 1
CRTC_R2 equ 2
CRTC_R3 equ 3
CRTC_R4 equ 4
CRTC_R5 equ 5
CRTC_R6 equ 6
CRTC_R7 equ 7
CRTC_R8 equ 8
CRTC_R9 equ 9
CRTC_R10 equ 10
CRTC_R11 equ 11
CRTC_R12 equ 12
CRTC_R13 equ 13
CRTC_R14 equ 14
CRTC_R15 equ 15
CRTC_R16 equ 16
CRTC_R17 equ 17
CRTC_R31 equ 31

CRTC_R0_DEFAULT equ 63
CRTC_R1_DEFAULT equ 40
CRTC_R2_DEFAULT equ 46
CRTC_R3_DEFAULT equ 0x8e
CRTC_R4_DEFAULT equ 38
CRTC_R5_DEFAULT equ 0
CRTC_R6_DEFAULT equ 25
CRTC_R7_DEFAULT equ 30
CRTC_R8_DEFAULT equ 0
CRTC_R9_DEFAULT equ 7
CRTC_R10_DEFAULT equ 0
CRTC_R11_DEFAULT equ 0
CRTC_R12_DEFAULT equ 0x20
CRTC_R13_DEFAULT equ 0x00
CRTC_R14_DEFAULT equ 0
CRTC_R15_DEFAULT equ 0

CRTC_HORIZONTAL_TOTAL_CHARACTER_COUNTER equ CRTC_R0
CRTC_HORIZONTAL_DISPLAYED_CHARACTER_NUMBER equ CRTC_R1
CRTC_POSITION_HORIZONTAL_SYNC_PULSE equ CRTC_R2
CRTC_WIDTH_SYNC_PULSES equ CRTC_R3
CRTC_VERTICAL_TOTAL_LINE_CHARACTER_NUMBER equ CRTC_R4
CRTC_VERTICAL_RASTER_ADJUST equ CRTC_R5
CRTC_VERTICAL_DISPLAYED_CHARACTER_NUMBER equ CRTC_R6
CRTC_POSITION_VERTICAL_SYNC_PULSE equ CRTC_R7
CRTC_INTERLACED_MPDE equ CRTC_R8
CRTC_MAXIMUM_RASTER equ CRTC_R9
CRTC_CURSOR_START_RASTER equ CRTC_R10
CRTC_CURSOR_END equ CRTC_R11
CRTC_DISPLAY_START_ADDRESS_HIGH equ CRTC_R12
CRTC_DISPLAY_START_ADDRESS_LOW equ CRTC_R13
CRTC_CURSOR_ADDRESS_HIGH equ CRTC_R14
CRTC_CURSOR_ADDRESS_LOW equ CRTC_R15
CRTC_LIGHT_PEN_ADDRESS_HIGH equ CRTC_R16
CRTC_LIGHT_PEN_ADDRESS_LOW equ CRTC_R17
CRTC_SPECIAL equ CRTC_R31


    ;;
    ; Set registers values in a dumb way
    macro CRTC_SET_VAL, reg, val
        ld bc, 0xbc00 + reg
        out (c), c
        ld bd, 0xbd00 + val
        out (c), c
    endm


    ;;
    ; Generate the code supposed to set the value of all crtc things through a table
    macro CRTC_SET_VALS
        ld b, 0xbc
.\@crtc_set_vals_loop
        ld a, (hl)
        cp 0xff
       jr z, .\@crtc_set_vals_end
        inc hl
        out (c), a
        inc b
        ld a, (hl)
        inc hl
        out (c), a
        dec b

        jr .\@crtc_set_vals_loop
.\@crtc_set_vals_end
    endm


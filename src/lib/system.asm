FIRMWARE

.GRA_SET_PEN        equ 0xBBDE
.GRA_TEST_ABSOLUTE  equ 0xBBF0
.GRA_PLOT_ABSOLUTE  equ 0xBBEA 

.SCR_SET_MODE       equ 0xBC0E
.SCR_SET_INK        equ 0xBC32
.SCR_SET_BORDER     equ 0xbc38
.SCR_SET_FLASHING   equ 0xbc3e

.SCR_GET_MODE       equ 0xBC11
.SCR_GET_INK        equ 0xBC35
.SCR_GET_BORDER     equ 0xBC3B
.SCR_GET_FLASHING   equ 0xBC41
.SCR_GET_LOCATION   equ 0xBC0B

.TXT_WR_CHAR        equ 0xbb5d
.TXT_SET_CURSOR     equ 0xbb75

.kl_l_rom_enable equ 0xb906
.kl_l_rom_disable equ 0xb909
.kl_u_rom_disable equ 0xb903

    macro KILL_SYSTEM   
        ld hl, 0xc9fb
        ld (0x38), hl
    endm

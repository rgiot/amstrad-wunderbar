    org 0x1000

    ld hl, intro
    ld de, start
    call deexo
    jp start_real

exo_mapbasebits equ 0xa000
    include lib/deexo.asm
intro
    incbin test.exo

    include entries.sym
    

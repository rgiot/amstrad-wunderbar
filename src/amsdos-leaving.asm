
leaving
.char_width equ 5
.char_height equ 5
.real_width equ .char_width*8
.real_height equ .char_height*8

    if MAZE_MODE = 2
        ld a, 2
        call FIRMWARE.SCR_SET_MODE  

    endif
    



    ld hl, 0x0100 + 28
    call FIRMWARE.TXT_SET_CURSOR



    ld bc, .char_width*256 + .char_height
    ld hl, AMSDOS_LEAVING_TEXT
.loopy
    push bc

    ld bc, 0
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line
    inc c
    call .display_pixel_line



    ld de, .char_width
    add hl, de






.endx
    pop bc
    dec c
    ld a, c
    or a
    jp nz, .loopy
    ret

        if MAZE_MODE = 2
.print_maze
    ld    a, r
    and   1
    or    0xc8
    call  FIRMWARE.TXT_WR_CHAR  
    ret
        endif

.manage_bit
    rla
    push af
    jr c, .do_print_maze
.do_nothing

    if MAZE_MODE = 2
            ld a, ' '
            call 0xbb5a
            ld a, ' '
            call 0xbb5a

    else
            ld a, ' '
            call 0xbb5a
    endif
        jr .leave_manage_bit
.do_print_maze
        if MAZE_MODE = 2
            call .print_maze
            call .print_maze
        else
            ld    a, r
            and   1
            or    0xc8
            call  FIRMWARE.TXT_WR_CHAR  

        endif
.leave_manage_bit
    pop af
    ret

.display_pixel_line
    push hl
    repeat .char_width
        push hl

        ld l, (hl)
        ld h, 0
        add hl, hl ; x2
        add hl, hl ; x4
        add hl, hl ; x8
        ld de, garbage
        add hl, de

        add hl, bc

        ld a, (hl)
        
        push bc
        call .manage_bit
        call .manage_bit
        call .manage_bit
        call .manage_bit
        call .manage_bit
        call .manage_bit
        call .manage_bit
        call .manage_bit
        pop bc

        pop hl
        inc hl
    endrepeat

  ;  push bc
  ;  ld a, 10
  ;  call  0xbb5a
  ;  ld a, 13
  ;  call  0xbb5a
  ;  pop bc

    pop hl
    ret



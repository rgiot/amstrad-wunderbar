
system_build_shadeobs_tables
.targeted_address equ 0xc000
.y_pos equ 398
.x_left_pos equ 0
.x_right_pos equ 4

    xor a 
    call FIRMWARE.SCR_SET_MODE

.table_complete
    ld de, SHADEBOBS_TABLE_BOTH
    ld hl, .targeted_address
.loop
    ; write the byte value
    ld (hl), e


        call .treat_left_pixel
        call .treat_right_pixel

        ; copy the result in the table
        ldi
        dec hl
        
        ; test end of loop
        xor a
        cp e
    jr nz, .loop

.table_left
    ld de, SHADEBOBS_TABLE_LEFT
    ld hl, .targeted_address
.loop_left
    ; write the byte value
    ld (hl), e


        call .treat_left_pixel

        ; copy the result in the table
        ldi
        dec hl
        
        ; test end of loop
        xor a
        cp e
    jr nz, .loop_left



.table_right
    ld de, SHADEBOBS_TABLE_RIGHT
    ld hl, .targeted_address
.loop_right
    ; write the byte value
    ld (hl), e


        call .treat_right_pixel

        ; copy the result in the table
        ldi
        dec hl
        
        ; test end of loop
        xor a
        cp e
    jr nz, .loop_right
    ret

.treat_left_pixel


    push hl
    push de

    ; Read the ink number left and increment it
    ld de, .x_left_pos
    ld hl, .y_pos
    call FIRMWARE.GRA_TEST_ABSOLUTE ; Get pen number
    call .clamp ; ensure it does not go to far
    call FIRMWARE.GRA_SET_PEN ; select it within the firmware
    ld de, .x_left_pos
    ld hl, .y_pos
    call FIRMWARE.GRA_PLOT_ABSOLUTE ; Get pen number
    
    pop de
    pop hl
    ret

.treat_right_pixel
    push hl
    push de

    ; Read the ink number right and increment it
    ld de, .x_right_pos
    ld hl, .y_pos
    call FIRMWARE.GRA_TEST_ABSOLUTE ; Get pen number
    call .clamp ; ensure it does not go to far
    call FIRMWARE.GRA_SET_PEN ; select it within the firmware
    ld de, .x_right_pos
    ld hl, .y_pos
    call FIRMWARE.GRA_PLOT_ABSOLUTE ; Get pen number
    
    pop de
    pop hl
    ret



; 14 and 15 means background => ink 0
.clamp
 if 0
    cp 13
    ret z
    cp 14
    jr z, .clamp_background
    cp 15
    jr z, .clamp_background
    inc a
 endif
    cp 13
    ret z
    jr nc, .clamp_background
    inc a
    ret
.clamp_background
    xor a
    ret





bar_mode_0_shadebobs
.read
        ld a, (bc)  
        add (hl)  


        rra
        exx  
        ld l, a  

        jp c, .right  
.left

        ld d, >SHADEBOBS_TABLE_BOTH  
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        inc l
        inc e
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        inc l
        ld d, >SHADEBOBS_TABLE_LEFT
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        jr .displayed
.right
        ld d, >SHADEBOBS_TABLE_RIGHT
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        inc l
        ld d, >SHADEBOBS_TABLE_BOTH  
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        inc l
        inc e
        ld e, (hl) 
        ld a, (de)
        ld (hl), a
        nop
        nop
        nop
.displayed
        exx

.delta1 equ $+1
        ld a, -3 ;31
        add l
        ld l, a

.delta2 equ $+1
        ld a, 1 ;197
        add c
        ld c, a



        defs 64-46 + (4-8)

        ret 

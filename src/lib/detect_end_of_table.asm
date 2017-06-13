;;
; Krusty/Benediction
; August 2012
; This file contains macros related to the checking of the end of tables
;
; The way of working of such kind of tables is the following

 if 0


; Original version
;;;;;;;;;;;;;;;;;;;
huge_table_pointer
    ld hl, huge_table       ; ATM we point here in the table
    ld a, (hl)              ; We read one (or several values, depending on the table)
    inc hl                  ; We move one (or several) step ahead of the table
     
    ; Now, before saving this address we need to check that
    ; we are always inside the table
    ld bc, huge_table_end   ; Address of the last authorized place
    or a                    ; Reset carry
    sbc hl, bc              ; Substract the current address to the last authorised
                            ; If carry is set, BC is higher, everything is ok
    jr c, you_can_save_the_table
hey_man_you_are_out_of_the_table
    add hl, bc                      ; Get the original address
    ld bc, huge_table_end - huge_table ; Size of the table
    sbc hl, bc                      ; Git at the (almost) beginning of the table
    jr save_the_table
you_can_save_the_table
    add hl, bc                      ; Get the original address
save_the_table
    ld (huge_table_pointer+1), hl   ; Save the address

    jp $

huge_table defs 5000, 0
huge_table_end
huge_table_can_be_repeated_a_bit_for_an_effect defs 20


; Version with the macro
;;;;;;;;;;;;;;;;;;;;;;;;
huge_table_pointer
    ld hl, huge_table
    ld a, (hl)
    inc hl

    SAFELY_SAVE_TABLE_POINTER_AFTER_MOVING_UP_INSIDE huge_table_pointer+1, huge_table, huge_table_end

    jp $

huge_table defs 5000, 0
huge_table_end
huge_table_can_be_repeated_a_bit_for_an_effect defs 20


 endif


 ;;
 ; Verify if we are not out of the table, and 
 ; save the address at the required place
 ;
 ; ARGUMENTS
 ; - `huge_table_pointer`: Argument where to store the pointer to the table
 ; - `huge_table`: Address of the beginning of the table
 ; - `huge_table_end`: Address of the end of the table
 ;
 ; MODIFIED
 ; - HL (real address of the table after correction)
 ; - BC
 macro SAFELY_SAVE_TABLE_POINTER_AFTER_MOVING_UP_INSIDE , huge_table_pointer , huge_table , huge_table_end

    ; Now, before saving this address we need to check that
    ; we are always inside the table
    or a                    ; Reset carry
    ld bc, \huge_table_end   ; Address of the last authorized place
    sbc hl, bc              ; Substract the current address to the last authorised
                            ; If carry is set, BC is higher, everything is ok
    jr c, .\@_you_can_save_the_table
.\@_hey_man_you_are_out_of_the_table
    add hl, bc                      ; Get the original address
    ld bc, \huge_table_end - \huge_table ; Size of the table
    sbc hl, bc                      ; Git at the (almost) beginning of the table
    jr .\@_save_the_table
.\@_you_can_save_the_table
    add hl, bc                      ; Get the original address
.\@_save_the_table
    ld (\huge_table_pointer), hl   ; Save the address
 endm

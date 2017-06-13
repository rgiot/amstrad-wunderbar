;;
; Macro to wait several cycles
; Maximum is 1024
;
; Stolen to Rhino/Batman Group
; http://cpcrulez.fr/forum/viewtopic.php?p=15827#p15827



    MACRO   WAIT_CYCLES, cycles

    assert \cycles <= 1024, 'Too many nops'
    assert \cycles > 0, 'Wait time must be positive'

    ; Compute the number of loops and extra nop
.\@loops     equ (\cycles-1)/4 
.\@loopsx4   equ .\@loops*4
.\@nops      equ \cycles-.\@loopsx4-1

    ; Produce a loop only if required
    if .\@loops != 0
        ld  b, .\@loops
.\@change_waitLoop
        djnz    .\@change_waitLoop
    endif

    ; Produce extra nops
    defs    .\@nops,0

    endmacro


    ;;
    ; Macro unable to wait more than 1024 nops
    MACRO LONG_WAIT_CYCLES, cycles

        if \cycles <= 1024
            WAIT_CYCLES \cycles
        else
            WAIT_CYCLES 1024
            LONG_WAIT_CYCLES (\cycles - 1024)
        endif
    ENDM


;; Grim/SML
;; Wait N number of CPU-Cycle
;; Input parameter:
;;  1 = Number (n) of cycles to wait
;;      For n=[0,127], output N NOPs (no CPU-register modified)
;;      For n=[128,1024], output a short DJNZ loop (register B and Flags are modified)
;;      For n=[1025,32766], output a big DJNZ loop (registers BC and Flags are modified)
;;      For n>32766, output is 42
    macro GNOP, n
gnop_maxnop set 128 ;<= can be adjusted to any value greater than 3
gnop_n set n
    if not (n - 1025 AND &8000)
        ; GigaLoop with BC
gnop_n set n - 6
gnop_t set 256*4-1 + 4
gnop_c set gnop_n - 3 / gnop_t
gnop_b set -gnop_t*gnop_c + gnop_n / 4
gnop_t set  gnop_t*gnop_c
gnop_t set  4*gnop_b - 1 + gnop_t
gnop_n set gnop_n - gnop_t

        ld bc,gnop_b*256 + gnop_c + 1
\@gnop      djnz $
        dec c
        jr nz,\@gnop

    else
    if not (n - gnop_maxnop AND &8000)
        ; MiniLoop with B
gnop_b set n-1 / 4
gnop_n set -gnop_b*4 - 1 + n

        ld b,gnop_b
        djnz $
    endif
    endif
    ds gnop_n,0
    endmacro

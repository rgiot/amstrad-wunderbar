;;
; VSYNC routines.
; Modify B and A

;   defb 0,1,2,3,4,5,6,7


;;
; Wait a new vsync (i.e., do not stop if we are already in a vsync)
secure_vsync
    ld b, 0xf5
.vsync_detected
    in a, (c)
    rra
    jr c, .vsync_detected
    ; here we leave the vsync

 
vsync
    ld b, 0xf5
.no_vsync_detected
    in a, (c)
    rra 
    jr nc, .no_vsync_detected
    ; here we have detected a vsync
    ret




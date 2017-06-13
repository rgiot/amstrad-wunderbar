;;
; Manage the breakpoints.
; However, there are several ways to add breakpoints:
; - Add bytes interpreted by winape has being breakpoints (take 2 nops)
; - Modify a snapshot to include breakpoints inside it
; The behavior can be controled with the BREAKPOINT_METHOD constant
;
; Krusty/Benediction, 2012

 ifndef __DEFINED_DEBUG__
__DEFINED_DEBUG__ equ 1

;;
; This value represents the breakpoint under winape
; it consists in puting the bytes 0xed, 0xff
BREAKPOINT_WITH_WINAPE_BYTES equ 1

;;
; This value represents the breakpoint with a sna and no code modification
; it consits in adding a local and unique label start with .BRK_
BREAKPOINT_WITH_SNAPSHOT_MODIFICATION equ 2

;;
; BREAKPOINT_METHOD
; This variable allow to select the method to use breakpoints.
; The value can be:
;  - BREAKPOINT_WITH_WINAPE_BYTES
;  - BREAKPOINT_WITH_SNAPSHOT_MODIFICATION
; If not value is selected it is chosen to be BREAKPOINT_WITH_WINAPE_BYTES
 ifndef BREAKPOINT_METHOD
BREAKPOINT_METHOD = BREAKPOINT_WITH_WINAPE_BYTES
    ;print 'No breakpoint method was selected, we selected the winape way'
 endif


    ; Verify if we have selected a write thing
    assert (BREAKPOINT_METHOD = BREAKPOINT_WITH_WINAPE_BYTES) || (BREAKPOINT_METHOD = BREAKPOINT_WITH_SNAPSHOT_MODIFICATION)

 macro BREAKPOINT_WINAPE
        db 0xed
        db 0xff
 endm

 macro BREAKPOINT_SNA
.BRK_\@
 endm
 ;;Breakpoint command for winape
 ; WARNING: Output two bytes
 macro BREAKPOINT
  ifndef NDEBUG
      if BREAKPOINT_METHOD=BREAKPOINT_WITH_WINAPE_BYTES
          BREAKPOINT_WINAPE
      endif

      if BREAKPOINT_METHOD=BREAKPOINT_WITH_SNAPSHOT_MODIFICATION
            BREAKPOINT_SNA
      endif
  endif
 endm

 macro BRK
    BREAKPOINT
 endm


 ;;
 ; Change the color of the border
 macro DEBUG_BORDER, coul
    ifndef NDEBUG
        ld bc, 0x7f10
        ld a, \coul
        out (c), c
        out (c), a
    endif
 endm

;;
 ; Change the color of the ink0
 macro DEBUG_INK0, coul
    ifndef NDEBUG
        ld bc, 0x7f00
        ld a, \coul
        out (c), c
        out (c), a
    endif
 endm


;;
; Duration of the color border change.
; Very important for stable code
 ifndef NDEBUG
DEBUG_BORDER_NOPS = 3+2+4+4
 else
DEBUG_BORDER_NOPS = 0
 endif

 endif

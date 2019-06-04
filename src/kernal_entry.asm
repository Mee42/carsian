[bits 32]
[extern main]
;mov ebx, SSDF
;call print_string_pm
call main
;mov ebx, SSDG
;call print_string_pm
ret
;jmp $

;%include "print_string_pm.asm"

;SSDF:
;  db "Calling main",0
;
;SSDG:
;  db "Done calling main",0

; a boot sector that enters 32-bit protected mode
[org 0x7c00]
  KERNAL_OFFSET equ 0x1000
  
  mov [BOOT_DRIVE], dl
 
  mov bp, 0x9000
  mov sp, bp


  mov bx, MSG_REAL_MODE
  call print_string


  ; call print_string
  call load_kernal
  call switch_to_pm 

  ;this line will never execute
  jmp $

%include "src/print_string.asm"
%include "src/disk_load.asm"
%include "src/gdt.asm"
%include "src/print_string_pm.asm"
%include "src/switch_to_pm.asm"
%include "src/print_hex.asm"

[bits 16]
load_kernal:
  mov bx, MSG_LOAD_KERNAL
  call print_string

  mov bx, KERNAL_OFFSET
  
  mov dh, 31
  mov dl, [BOOT_DRIVE]
  call disk_load 
;  mov bx, MSG_LOAD_DISK
;  call print_string
  ret

[bits 32]

BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm
  call KERNAL_OFFSET 
  mov ebx, 0x5000
  call print_string_pm
  jmp $ ; if the kernal returns, stay here



BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit", 10, 13, 0
MSG_PROT_MODE   db "Started in 32-bit", 0
;MSG_SHOULD_NEVER_PRINT db "FUCK",10,13, 0
MSG_LOAD_KERNAL db "Loading kernal",10,13, 0
;MSG_LOAD_DISK   db "Loaded disk!", 10,13,0
MSG_KERNAL_EXIT db "The kernal has exited",10,13,0



times 510-($-$$) db 0


dw 0xaa55


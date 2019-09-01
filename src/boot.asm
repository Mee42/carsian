; a boot sector that enters 32-bit protected mode
[bits 16]
[org 0x7c00]

boot:
  jmp main_real
  ; this is fake bpb
    TIMES 3-($-$$) DB 0x90   ; Support 2 or 3 byte encoded JMPs before BPB.
   ; Fake BPB filed with 0xAA
   TIMES 59 DB 0xAA
main_real:
  jmp 0x0000:main_entry
main_entry:
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax               ; Set SS to 0
  mov sp, 0x9000           ; Set SP right after SS 


  KERNAL_OFFSET equ 0x1000
  
  mov [BOOT_DRIVE], dl
 


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
; %include "src/print_hex.asm"

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
  ; mov ebx, 0x5000
  mov ebx, MSG_KERNAL_EXIT
  call print_string_pm
  jmp $ ; if the kernal returns, stay here



BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Sted in 16bit", 10, 13, 0
MSG_PROT_MODE   db "Sted in 32bit", 0
;MSG_SHOULD_NEVER_PRINT db "FUCK",10,13, 0
MSG_LOAD_KERNAL db "Loding kernal",10,13, 0
;MSG_LOAD_DISK   db "Loaded disk!", 10,13,0
MSG_KERNAL_EXIT db "kernal has exited",10,13,0



times 510-($-$$) db 0

dw 0xaa55



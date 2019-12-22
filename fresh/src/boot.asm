; 0x7c00 -> 0x7e00 is reserved for boot code
; 0x0500 -> 0x7c00 is for the stack
; 0x7e00 -> 0x9000 is for the stack


[bits 16]
[org 0x7c00]
  xor ax, ax
  mov ds, ax
  mov es, ax
  
  push 0
  pop cs
  push 0
  pop ds
 
  mov bx, 0x8000
  cli ; for old processors. Can't hurt
  mov ss, bx
  mov sp, ax
  cld

  mov bx, STARTED_IN_16_BIT_MODE
  call print_string
  
  mov ax, 0x1234
  call print_ax_hex

  mov bx, NEWLINE
  call print_string

  mov ax, 0xABCD
  call print_ax_hex
  
  mov ax, 0x4321
  call print_ax_hex
  


  mov ax, 0xBBBB
  call print_ax_hex
  
  mov bx, NEWLINE
  call print_string
    

  mov bx, BOOT_CODE_TERMINATED
  call print_string
  jmp $

%include "src/printer_16bit.asm"

STARTED_IN_16_BIT_MODE db "Started in 16 bit mode", 10, 13, 0
BOOT_CODE_TERMINATED db "Boot code has terminated", 10, 13, 0
NEWLINE db 10, 13, 0


times 510-($-$$) db 0

dw 0xAA55

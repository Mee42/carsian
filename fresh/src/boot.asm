[bits 16]
[org 0x7c00]
  mov bx, STARTED_IN_16_BIT_MODE
  call print_string
  
  mov ax, 0xFFFF
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

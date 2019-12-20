[bits 16]
[org 0x7c00]
  mov bx, HELLO_WORLD
  call print_string
  mov ax, 0xFFFF
  ;call print_ax_bin
  call print_ax_hex
  mov bx, NEWLINE
  call print_string
  jmp $

%include "src/printer_16bit.asm"

HELLO_WORLD db "Hello, World!", 10, 13, 0
NEWLINE db 10, 13, 0
ZERO db "[zero]", 0
times 510-($-$$) db 0

dw 0xAA55

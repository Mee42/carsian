; 0x7c00 -> 0x7e00 is reserved for boot code
; 0x0500 -> 0x7c00 is for the stack
; 0x7e00 -> 0x9000 is for the stack


[bits 16]
;[org 0x7c00]

; precondition: dl is the boot drive, cs:ip is 0x7c00
init:
  cli ; this disables interupts
 
    ; setup the stack
  mov ax, 0x90 ; stack is 0x900 - 0x7BFF
  mov ss, ax
  mov sp, 0x7300 ; 0x7300+0x900 (0x7C00)
  mov bp, sp ; base pointer to the top of the stack
 
  mov cx, 256 ; copy 256 words
  mov ax, 0x7C0 ; set ds to 0x07C0:0
  mov ds, ax
   
  mov ax, 0x50 ; we're moving the bootlodaer to 0x500, or 0x50:0
  mov es, ax
  xor di, di ; clear pointers, data is at offset 0
  xor si, si
  cld ; make sure we copy the right way
  rep movsw ; copy the bootloader to 0x500
  mov ds, ax
  
  sti ; enables interupts again
  xor bx, bx
  mov dh, 0x0
  jmp 0x50:main
main: 
  mov ah, 0x0e
  mov al, 'X' 
  int 0x10
  jmp  $
  ; we know:
  ;  ax = 0x50h
  ;  bx = 0x0
  ;  cx = 0x0
  ;  dh = 0x0
  ;  dl = boot drive
  ;  sp = 0x7300
  ;  cs = 0x50
  ;  ds = 0x50
  ;  es = 0x50

  mov bx, STARTED_IN_16_BIT_MODE
  call print_string
   

  mov bx, BOOT_CODE_TERMINATED
  call print_string
  jmp $

%include "src/printer_16bit.asm"

STARTED_IN_16_BIT_MODE db "Started in 16 bit mode", 10, 13, 0
BOOT_CODE_TERMINATED db "Boot code has terminated", 10, 13, 0
NEWLINE db 10, 13, 0
SPACE db 32, 0

times 510-($-$$) db 0

dw 0xAA55

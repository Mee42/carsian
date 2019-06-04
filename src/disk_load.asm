 disk_load:
  pusha
  push bx
  mov bx, DISK_START
  call print_string
  pop bx


  
  push dx
  mov ah, 0x02
  mov al, dh
  mov cl, 0x02
  mov ch, 0x00
  mov dh, 0x00

  int 0x13
  jc disk_error0
  pop dx
  cmp dh, al
  jne disk_error1

  push bx
  mov bx, DISK_SUCC
  call print_string
  pop bx  
  popa
  ret

disk_error0:
;  mov ax, cx
;  call print_hex
  mov bx, DISK_ERROR_0
  call print_string
  jmp $

disk_error1:
  mov bx, DISK_ERROR_1
  call print_string
  jmp $

DISK_ERROR_0 : db "Disk read error - 0!",10,13, 0
DISK_ERROR_1 : db "Disk read error - 1!",10,13, 0
DISK_START : db "Starting disk load", 10,13, 0
DISK_SUCC : db "Loaded disk! - 0", 10,13,0

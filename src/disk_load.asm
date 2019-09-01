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
  loopY:
  cmp ah, 0x0
  je cont
  mov bx, STARTING_DISK_ERROR
  call print_string  
  sub ah, 1
  jmp loopY
cont:
; print a nice little counter
  mov bx,NEWLINE
  call print_string 
  mov ah,8 ; 80 character screen, 10 characters
loopS:
  cmp ah,0x0
  je cont2
  mov bx, NUMBERS
  call print_string
  sub ah, 1
  jmp loopS

cont2:
  mov bx,NEWLINE
  call print_string
  mov bx, DISK_ERROR_0
  call print_string
  jmp $

disk_error1:
  mov bx, DISK_ERROR_1
  call print_string
  jmp $

STARTING_DISK_ERROR : db "X",0
NEWLINE: db 10,13,0
NUMBERS: db "1234567890",0
DISK_ERROR_0 : db "Error0",10,13, 0
DISK_ERROR_1 : db "Error1",10,13, 0
DISK_START : db "Startingdisk", 10,13, 0
DISK_SUCC : db "Loadeddisk", 10,13,0

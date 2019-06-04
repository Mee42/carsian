
; Prints AX in hex

print_hex:
  push ax
  shr al, 0x04
  call print_nibble
  pop ax
  and al, 0x0F
  call print_nibble
  ret

print_nibble:
  cmp al, 0x09
  jg .letter
  add al, 0x30
  mov ah, 0x0E
  int 0x10
  ret

.letter:
  add al, 0x37
  mov ah, 0x0e
  int 0x10
  ret

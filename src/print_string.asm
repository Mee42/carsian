; prints the string at location BX
print_string:
  push ax
  push bx
  mov ah, 0x0e
  loop1:
    mov al, [bx]
    int 0x10
    add bx, 1
    mov dl, [bx]
    cmp dl, 0x0
    jne loop1

  pop bx
  pop ax
  ret


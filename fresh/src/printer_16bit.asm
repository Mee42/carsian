[bits 16]

print_ax_hex:
  push ax ; ax is for printing
  push bx ; bx is for the number inputted
  push cx ; cx is the counter
  push dx ; dx is for storing the bit
  mov bx, ax
  mov ah, 0x0e
  mov cx, 0x0

  mov al, '0'
  int 0x10
  mov al, 'x'
  int 0x10
  print_ax_hex_loop:
    ; print the first nibble in the bx
    mov dx, bx
    and dx, 0xf000 ; take the first nibble
    shr dx, 12 ; make the bytes active 0x000F
    call dx_nibble_to_ascii_in_al
    int 0x10
    add cx, 1
    shl bx, 4
    cmp cx, 4
    jne print_ax_hex_loop
  pop dx
  pop cx
  pop bx
  pop ax
  ret  

; wrecks dx
dx_nibble_to_ascii_in_al:
    mov al, 'Y'
    cmp dx, 0x9
    jle isDigit
      ; is a letter A-F
      sub dx,0xA
      mov al, 'A'
      add al, dl
      ret 
    isDigit:
      mov al, '0'
      add al, dl
    ret
   

print_ax_bin:
  push ax ; ax is for printing
  push bx ; bx is the number inputted
  push cx ; cx is the counter
  push dx ; dx is for storing the bit
  mov bx, ax ; set bx from ax. The input is ax, it's manipulated in bx
  mov ah, 0x0e ; setup ax for printing
  mov cx, 0x0  ; set cx to zero
  
  print_ax_bin_loop:
    ; print the first bit in bx, and exit if wanted
    mov dx, bx ; use dx the temp register
    and dx, 0x8000 ; take only the first bit
    cmp dx, 0x0
    je print_ax_bin_loop_zero
      ; it's a one
      mov al, '1'
    jmp print_ax_bin_loop_fi
    print_ax_bin_loop_zero:
      mov al, '0'
    print_ax_bin_loop_fi:
    int 0x10
    
    ; okay now shift bx over
    shl bx, 1
    ; and increment cx
    add cx, 1
    ; and then make sure cx isn't 16
    cmp cx, 16
    jne print_ax_bin_loop
  pop dx
  pop cx
  pop bx
  pop ax
  ret

print_string:
  push ax
  push bx
  push dx
  mov ah, 0x0e
  loop1:
    mov al, [bx]
    int 0x10
    add bx, 1
    mov dl, [bx]
    cmp dl, 0x0
    jne loop1
  pop dx
  pop bx
  pop ax
  ret


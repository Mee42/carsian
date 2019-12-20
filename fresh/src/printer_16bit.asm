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


dx_nibble_to_ascii_in_al:
    mov al, 'Y'
    cmp dx, 0x0
    je ph_0
    cmp dx, 0x1
    je ph_1
    cmp dx, 0x2
    je ph_2
    cmp dx, 0x3
    je ph_3
    cmp dx, 0x4
    je ph_4
    cmp dx, 0x5
    je ph_5
    cmp dx, 0x6
    je ph_6
    cmp dx, 0x7
    je ph_7
    cmp dx, 0x8
    je ph_8
    cmp dx, 0x9
    je ph_9
    cmp dx, 0xA
    je ph_A
    cmp dx, 0xB
    je ph_B
    cmp dx, 0xC
    je ph_C
    cmp dx, 0xD
    je ph_D
    cmp dx, 0xE
    je ph_E
    cmp dx, 0xF
    je ph_F
    mov al, 'x'
    jmp ph_end

    ph_0:
      mov al, '0'
      jmp ph_end;
    ph_1:
      mov al, '1'
      jmp ph_end;
    ph_2:
      mov al, '2'
      jmp ph_end;
    ph_3:
      mov al, '3'
      jmp ph_end;
    ph_4:
      mov al, '4'
      jmp ph_end;
    ph_5:
      mov al, '5'
      jmp ph_end;
    ph_6:
      mov al, '6'
      jmp ph_end;
    ph_7:
      mov al, '7'
      jmp ph_end;
    ph_8:
      mov al, '8'
      jmp ph_end;
    ph_9:
      mov al, '9'
      jmp ph_end;
    ph_A:
      mov al, 'A'
      jmp ph_end;
    ph_B:
      mov al, 'B'
      jmp ph_end;
    ph_C:
      mov al, 'C'
      jmp ph_end;
    ph_D:
      mov al, 'D'
      jmp ph_end;
    ph_E:
      mov al, 'E'
      jmp ph_end;
    ph_F:
      mov al, 'F'
      jmp ph_end;
    
    ph_end: 
    ret
   

print_ax_bin:
  push ax ; ax is for printing
  push bx ; bx is the number inputted
  push cx ; cx is the counter
  push dx ; dx is for storing the bit
  mov bx, ax ; set bx from ax. The input is ax, it's manipulated in bx
  xor ax, ax
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


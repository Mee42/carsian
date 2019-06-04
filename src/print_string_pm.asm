[bits 32]
VIDEO_MEMORY equ 0xb8000 + 2 * (20 * 80 + 0)
WHITE_ON_BLACK equ 0x0f

; takes in ebx as the begining of the string

print_string_pm:
  push edx
  push ebx
  mov edx, VIDEO_MEMORY
  jmp print_string_pm_loop

print_string_pm_loop:
  mov al, [ebx]
  mov ah, WHITE_ON_BLACK

  cmp al, 0  
  je print_string_pm_done

  mov [edx], ax
  add ebx, 1
  add edx, 2
  jmp print_string_pm_loop

print_string_pm_done:
  pop ebx
  pop edx
  ret

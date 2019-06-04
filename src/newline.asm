new_line:
  pusha
  mov al, 0x0A
  int 0x10
  mov al, 0x0D
  int 0x10
  popa
  ret


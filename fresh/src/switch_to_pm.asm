[bits 16]
switch_to_pm:
  
  cli
  
  lgdt [gdt_descriptor]
  
  mov eax, cr0
  or eax, 0x1
 
  mov cr0, eax
  jmp CODE_SEG:init_pm
  
[bits 32]
init_pm:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
    

  mov ebp, 0x7300
  mov esp, ebp
  jmp $ 
  call BEGIN_PM

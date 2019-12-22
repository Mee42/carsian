
[bits 16]
;[org 0x7c00]

jmp init
nop

OEMLabel db 'CARSIAN_'
BytesSector dw 512
SectorsCluster db 2	;2 Sectors per cluster, FS Data
ReservedSectors dw 1	;1 reserved sector (this sector)
FATCount db 1	;1 FAT, FS Data
RootEntryCount dw 128	;128 root dir entries (files/folders/whatever), FS Data
VolumeSectors dw 0xFFFF
MediaType db 0xF8	;F8 = HDD, disk Data
FATSectors dw 64	;64 sectors for FAT, FS Data
Disk_SectorsHead dw 32	;32 sectors per head, disk Data
Disk_HeadCount dw 2	;2 heads per cylinder, disk Data
HiddenSectors dd 0 
VolumeSectorsLarge dd 0	;Set in VolumeSectors, only used when VolumeSectors=0
DriveNumber db 0x80	;Drive number ID, used for I/O
FS_Reserved1 db 0
NT_Signature db 0x29
VolumeSN dd 1651703934	;Volume Serial Number, hardcoded with random value
VolumeLabel db 'Carsian v0 '
FSType db 'FAT16   '

%include "src/gdt.asm"

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

 
  mov [DriveNumber], dl ; store the drive number somewhere safe
  xor dx, dx ; who needs dx
  xor cx, cx ; already set but whatever
  xor bx, bx ; lol
  xor ax, ax ; for completness
  jmp 0x50:main

main: 
  ; we know:
  ;  ax = 0x0
  ;  bx = 0x0
  ;  cx = 0x0
  ;  dx = 0x0
  ;  sp = 0x7300
  ;  cs = 0x7C00
  ;  ds = 0x7C00
  ;  es = 0x7C00

   mov bx, STARTED_IN_16_BIT_MODE
  call print_string

  mov bx, NEWLINE
 
  mov ax, 0xFFFF
  loopy:
    call print_ax_hex
    call print_string
    sub ax, 0x3333
    cmp ax, 0x0000
    jne loopy

  call switch_to_pm
 
  mov bx, BOOT_CODE_TERMINATED_OH_NO
  call print_string
  jmp $


%include "src/printer_16bit.asm"
;%include "src/gdt.asm"
%include "src/switch_to_pm.asm"

BEGIN_PM:
  ;mov edx, [0xB000]
  ;mov al, 'P'
  ;mov ah, 0x0f
  ;mov [edx], ax
  ret
 
STARTED_IN_16_BIT_MODE db "Started in 16 bit mode", 10, 13, 0
BOOT_CODE_TERMINATED_OH_NO db "Boot code has terminated, uh oh", 10, 13, 0
NEWLINE db 10, 13, 0
SPACE db 32, 0


times 510-($-$$) db 0

dw 0xAA55

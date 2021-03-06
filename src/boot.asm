; a boot sector that enters 32-bit protected mode
[org 0x7c00]
[bits 16]

jmp boot

   TIMES 3-($-$$) DB 0x90   ; Support 2 or 3 byte encoded JMPs before BPB.
   ; Fake BPB filed with 0xAA
   ; TIMES 59 DB 0xAA
    OEMname:           db    "mkfs.fat"  ; mkfs.fat is what OEMname mkdosfs uses
    bytesPerSector:    dw    512
    sectPerCluster:    db    1
    reservedSectors:   dw    1
    numFAT:            db    2
    numRootDirEntries: dw    224
    numSectors:        dw    2880
    mediaType:         db    0xf0
    numFATsectors:     dw    9
    sectorsPerTrack:   dw    18
    numHeads:          dw    2
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0x29
    volumeID:          dd    0x2d7e5a1a
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "


boot:
  mov [BOOT_DRIVE], dl

  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x9000
  KERNAL_OFFSET equ 0x1000
   


  mov bx, MSG_REAL_MODE
  call print_string


  ; call print_string
  call load_kernal
  call switch_to_pm 

  ;this line will never execute
  jmp $

%include "src/print_string.asm"
%include "src/disk_load.asm"
%include "src/gdt.asm"
%include "src/print_string_pm.asm"
%include "src/switch_to_pm.asm"
;%include "src/print_hex.asm"

[bits 16]
load_kernal:
  mov bx, MSG_LOAD_KERNAL
  call print_string

  mov bx, KERNAL_OFFSET
   
  mov dh, 31
  mov dl, [BOOT_DRIVE]
  call disk_load 
;  mov bx, MSG_LOAD_DISK
;  call print_string
  ret

[bits 32]

BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm
  call KERNAL_OFFSET 
  mov ebx, 0x5000
  call print_string_pm
  mov ebx, MSG_KERNEL_EXIT
  call print_string_pm
  jmp $ ; if the kernal returns, stay here



BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Start16bit", 10, 13, 0
MSG_PROT_MODE   db "Start32bit", 0
;MSG_SHOULD_NEVER_PRINT db "FUCK",10,13, 0
MSG_LOAD_KERNAL db "Loading kernal",10,13, 0
;MSG_LOAD_DISK   db "Loaded disk!", 10,13,0
MSG_KERNEL_EXIT db "kernal has exited",10,13,0



times 510-($-$$) db 0


dw 0xaa55



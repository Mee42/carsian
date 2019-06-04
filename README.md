
# Carsian

Carsian is a 32-bit MBR OS that is written in assembly(16-bit elevated to 32 bit gdt) and 32-bit C. Output it through a 80x25 VGA memory buffer, and line-wrapping is handled with a custom implementation.

## How it's structured

Assembly files are kept in `src/`. `boot.asm` is the first thing ran on startup. `kernal_entry.asm` is appended to the boot sector and is ran in 32 bit mode to launch the C file. These files are compiled together and added to the boot sector at KERNAL_OFFSET, which is currently at `0x1000`. 

Kernal files are in `kernal/` and driver files are in `driver/`, both of which are written in C. C is entered with the `main` method in `kernal.c`. There are currently no drivers written.

IO is managed in `in.c` and `out.c`. Both maintain a buffer, which can be set somehow. It defaults to 0xFA0 bytes, which is the same size as the VGA byte buffer. `out.c` will probably. //TODO

## How to build

This needs to be compiled on the base system, so no binaries will be distributed. 

This project can be build using `make`.

##### To build bin file

```
$ make
```
collect your bin file from `out/os.bin`


##### To run in qemu

```
$ make run
```
all dependencies must be installed


## Dependencies
- ld
- gcc
- nasm
- qemu-system-x86_64

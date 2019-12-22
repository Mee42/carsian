SHELL=/bin/bash
KERNAL_SRC := src
BUILD := build

all: os.bin


SOURCE_FILES = $(wildcard src/*.asm)
MAIN_SOURCE_FILE = src/boot.asm

# build the kernal boot module
build/boot.bin : $(SOURCE_FILES)# put other needed asm files here
	@mkdir -p build
	nasm $(MAIN_SOURCE_FILE) -f bin -o $@


os.bin : build/boot.bin
	dd if=/dev/zero of=$@ bs=512 count=32
	dd if=build/boot.bin of=$@ bs=512 conv=notrunc
#	dd if=build/kernal.bin of=$@ bs=512 seek=1 conv=notrunc


runf: os.bin
	qemu-system-x86_64 -drive file=$<,if=floppy,index=0,media=disk,format=raw
run: os.bin
	qemu-system-x86_64 -drive file=$<,format=raw

dep: os.bin
	sudo dd if=$< of=d/drive status=progress


clean :
	@rm -rf build
	@rm -f os.bin
	@rm -rf buildstd




SHELL=/bin/bash
KERNAL_SRC := src
BUILD := build

all: os.bin




# build the kernal boot module
build/boot.bin : src/boot.asm src/printer_16bit.asm # put other needed asm files here
	@mkdir -p build
	nasm $< -f bin -o $@


os.bin : build/boot.bin
	dd if=/dev/zero of=$@ bs=512 count=32
	dd if=build/boot.bin of=$@ bs=512 conv=notrunc
#	dd if=build/kernal.bin of=$@ bs=512 seek=1 conv=notrunc


run: os.bin
	qemu-system-x86_64 -drive file=$<,if=floppy,index=0,media=disk,format=raw
runf: os.bin
	qemu-system-x86_64 -drive file=$<,format=raw

dep: os.bin
	sudo dd if=$< of=d/drive status=progress


clean :
	@rm -rf build
	@rm -f os.bin
	@rm -rf buildstd




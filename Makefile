SHELL=/bin/bash
KERNAL_SRC := src
BUILD := build

all: os.bin


# kernal.o needs to be first so it is properly offset
KERNAL_BUILDS := ./build/kernal.o ./build/kernal_entry.o $(shell bash -c "find -print | grep \"./kernal/.*\.c\"  | sed -r 's/kernal\/([a-zA-Z]*)\.c/build\/\1.o/' | grep -Fv \"./build/kernal.o\" | tr \"\n\" \" \"")

# don't package any other files in kernal.bin for reasons
# KERNAL_BUILDS := ./build/kernal.o

# build the kernal binary
build/kernal.bin : $(KERNAL_BUILDS) 
	echo $(KERNAL_BUILDS)
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386


# build the kernal entry file
build/kernal_entry.o : src/kernal_entry.asm
	@mkdir -p build
	nasm $< -f elf32 -o $@



# build the kernal boot module
build/boot.bin : src/boot.asm src/gdt.asm src/print_string_pm.asm src/switch_to_pm.asm src/print_string.asm src/disk_load.asm
	@mkdir -p build
	nasm $< -f bin -o $@


build/%.o : kernal/%.c
	@mkdir -p build
	gcc -ffreestanding -m32 -fno-pie -c $< -o $@

os.bin : build/boot.bin build/kernal.bin
	dd if=/dev/zero of=$@ bs=512 count=32
	dd if=build/boot.bin of=$@ bs=512 conv=notrunc
	dd if=build/kernal.bin of=$@ bs=512 seek=1 conv=notrunc


run: os.bin
	qemu-system-x86_64 -drive file=$<,if=floppy,index=0,media=disk,format=raw
runf: os.bin
	qemu-system-x86_64 -drive file=$<,format=raw

dep: os.bin
	sudo dd if=$< of=d/boot status=progress


clean :
	@rm -rf build
	@rm -f os.bin
	@rm -rf buildstd




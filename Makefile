KERNAL_SRC := src
BUILD := build

all: out/os.bin
	
KERNAL_BUILDS := $(shell bash -c "find -print | grep \"./kernal/.*\.c\"  | sed -r 's/kernal\/([a-zA-Z]*)\.c/build\/\1.o/' | tr \"\n\" \" \"")





# build the kernal binary
build/kernal.bin : $(KERNAL_BUILDS) 
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386


# build the kernal entry file
build/kernal_entry.o : src/kernal_entry.asm build/
	nasm $< -f elf32 -o $@



# build the kernal boot module
build/boot.bin : src/boot.asm src/gdt.asm src/print_string_pm.asm src/switch_to_pm.asm src/print_string.asm src/disk_load.asm build/
	nasm $< -f bin -o $@


build/%.o : kernal/%.c build/
	gcc -ffreestanding -m32 -fno-pie -c $< -o $@

out/os.bin : build/boot.bin build/kernal.bin out/
	cat build/boot.bin build/kernal.bin > $@

run: out/os.bin
	qemu-system-x86_64 -drive file=$<,if=floppy,index=0,media=disk,format=raw

build/ :
	mkdir build

out/ :
	mkdir out


clean :
	if [ -a build ];then rm -r build;fi
	if [ -a out ];then rm -r out;fi




all:
	mkdir -p build
	nasm -f bin boot/boot.asm -o build/boot.bin
	nasm -f bin boot/shell.asm -o build/shell.bin
	nasm -f bin boot/kernel.asm -o build/kernel.bin

	truncate -s 512 build/shell.bin
	truncate -s 512 build/kernel.bin

	cat build/boot.bin build/shell.bin build/kernel.bin > build/os-image.bin

run: all
	qemu-system-x86_64 -drive format=raw,file=build/os-image.bin

clean:
	rm -f build/*.bin

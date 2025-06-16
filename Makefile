NASM=nasm

all: build/boot.bin disk.img

build/boot.bin: src/boot.asm
	$(NASM) -f bin src/boot.asm -o build/boot.bin

disk.img: build/boot.bin
	dd if=/dev/zero of=disk/disk.img bs=512 count=2880
	dd if=build/boot.bin of=disk/disk.img conv=notrunc

clean:
	rm -rf build/*.bin disk/*.img


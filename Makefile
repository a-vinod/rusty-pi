clean:
	cargo clean
	rm -rf build

rpi-firmware:
	mkdir -p build
	wget -nc https://github.com/raspberrypi/firmware/raw/master/boot/fixup.dat -P build/
	wget -nc https://github.com/raspberrypi/firmware/raw/master/boot/start.elf -P build/
	wget -nc https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin -P build/
	echo "arm_64bit=1" > build/config

kernel-elf:
	cargo rustc --verbose -- -C link-arg=--script=./linker.ld -C relocation-model=static

kernel-img: kernel-elf rpi-firmware
	aarch64-linux-gnu-objcopy -O binary target/aarch64-unknown-none/debug/rusty-pi ./build/kernel8.img
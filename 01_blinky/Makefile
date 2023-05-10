clean:
	rm -rf *.img target

kernel8.elf:
	RUSTFLAGS="-C target-cpu=cortex-a72 -C link-arg=--library-path=$(shell pwd)/../01_blinky -C link-arg=--script=linker.ld -D warnings" cargo rustc --target=aarch64-unknown-none --release

kernel8.img: kernel8.elf
	rust-objcopy -O binary target/aarch64-unknown-none/release/rusty-pi kernel8.img
# rusty-pi

A rusty OS for the Raspberry Pi.

Created for educational purposes. This may or may not bake your Pi.

## Build the Kernel Image
First download Raspberry Pi firmware files
```bash
./rpi-fw-download.sh
```
Then make the image.
```bash
make clean
make kernel-img
```

Copy these four files to a microSD card and you're all set!


## Inspect the ELF
```bash
aarch64-linux-gnu-objdump -D target/aarch64-unknown-none/debug/rusty-pi | less
```

Sources:
- [Writing an OS in Rust, Philipp Oppermann's blog](os.phil-opp.com).
- [Rust on a Raspberry Pi – Part 1](https://harmonicss.co.uk/bare-metal/rust-on-a-raspberry-pi-part-1/)
- [Building an Operating System for the Raspberry Pi](jsandler18.github.io)
- [rust-embedded/rust-raspberrypi-OS-tutorials](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials)
- [AArch64 Bare-Metal program in Rust](https://lowenware.com/blog/aarch64-bare-metal-program-in-rust/#writing-linker-script)
- [juan-iniguez/rustpi](https://github.com/juan-iniguez/rustpi)
- [Raspberry Pi Bare Bones](https://wiki.osdev.org/Raspberry_Pi_Bare_Bones)
- [ChatGPT](chat.openai.com) (No source code taken from here, only code clarification that I later verified against a real source)
// main.rs

// For non-standalone binary applications in Rust, execution starts in crt0
// crt0 contains initial startup code
//  - sets up stack
//  - places arguments in registers
//  - invokes the entry point of the Rust runtime (marked by `start`)
//  - Rust runtime eventually calls main()
// Freestanding Rust binaries do not have access to crt0 provided by the OS or
// the Rust runtime, and the `start` lang item in Rust is responsible for
// initializing the runtime environment. Hence, we need to overwrite the crt0
// entry point by implementing startup routine that does necessary
// initialization and overwrite the OS entry point with our program.

#![no_std]  // Hey compiler, don't link standard library
#![no_main] // Hey compiler, don't use normal entry points

use core::panic::PanicInfo;

// Called on panic
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// Overwrite OS entry point
#[no_mangle] // Hey compiler, don't name-mangle _start()
pub extern "C" fn _start() -> ! {
    // We use `extern "C"` to use C calling convention for this function,
    // making it compatible and callable from other languages using C calling
    // convention. This is a requirement of the target system. The _start fn
    // should also not ever return because it's directly invoked by OS

    loop {}
}
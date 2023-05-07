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

// Link boot.S in compilation to set up stack pointer and put all but one core
// to sleep.
use core::arch::global_asm;
global_asm!(
    include_str!("boot.S"),
);

// Overwrite OS entry point
// We use `extern "C"` to use C calling convention for this function,
// making it compatible and callable from other languages using C calling
// convention. This is a requirement of the target system. 
// This function should also not ever return, so the return type is `!`
#[no_mangle] // Hey compiler, don't name-mangle _start()
pub extern "C" fn _start_rust() -> ! {
    // The Raspberry Pi 4B has a BCM2711 SoC.
    
    // From the BCM2711 datasheet (1.2.4. Legacy master addresses):
    // The peripheral addresses specified in this document are legacy master 
    // addresses.
    // A pheripheral at legacy address 0x7Enn_nnnn is available in the 35-bit 
    // address space at 0x4_7Enn_nnnn, and visible to the ARM at 0x0_FEnn_nnnn 
    // if Low Peripheral mode is enabled.

    // In summary, here is the pheripheral address translation scheme
    // Address          |   Address Space
    // 0x0_7Enn_nnnn    |   Legacy
    // 0x4_7Enn_nnnn    |   35-bit
    // 0x0_FEnn_nnnn    |   ARM (Low-Peripheral mode)

    // Note the Pi 4B boots into Low Peripheral mode by default.

    const PBASE:*mut u32            = 0xFE00_0000 as *mut u32;

    const P_GPIO_OFFSET:isize       = 0x0020_0000;

    const GPIO_GPFSEL1_OFFSET:isize = 0x08;
    const GPIO_GPSET0_OFFSET:isize  = 0x1C;
    const GPIO_GPCLR0_OFFSET:isize  = 0x28;

    unsafe {
        let p_gpio:*mut u32           = PBASE.offset(P_GPIO_OFFSET);
        let p_gpio_gpfsel1:*mut u32   = p_gpio.offset(GPIO_GPFSEL1_OFFSET);
        let p_gpio_gpset0:*mut u32    = p_gpio.offset(GPIO_GPSET0_OFFSET);
        let p_gpio_gpclr0:*mut u32    = p_gpio.offset(GPIO_GPCLR0_OFFSET);

        core::ptr::write_volatile(p_gpio_gpfsel1, 1 << 3);

        loop {
            core::ptr::write_volatile(p_gpio_gpset0, 1 << 21);
            for _ in 0..5000000 {
                core::arch::asm!("nop");
            }
    
            core::ptr::write_volatile(p_gpio_gpclr0, 1 << 21);
            for _ in 0..5000000 {
                core::arch::asm!("nop");
            }
        }
    }
}

// Called on panic
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
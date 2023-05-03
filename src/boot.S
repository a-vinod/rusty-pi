// Place this code in the `text` section of `boot` so that the linker puts it
// it at the start of the kernel image
.section .text._start

// Declare `_start` as globally visible
.global _start

_start:
	// Put all cores other than core 0 to sleep
	// Aff0 bits from MPIDR_EL1 stores the core number in Cortex-A72
	// Aff0 = MPIDR_EL1[1:0]
	// Cortex-A72 is quad-core so Aff0 takes 0x0, 0x1, 0x2, 0x3
	// See: https://developer.arm.com/documentation/100095/0002/system-control/aarch64-register-descriptions/multiprocessor-affinity-register--el1

    mrs     x1, MPIDR_EL1	// Read MPIDR_EL1 to register x1
    and     x1, x1, #3		// Mask around Aff0 bits to get core id
    cbz     x1, halt		// Send cores with non-zero core id to `halt`

	// Only core 0 progresses past this point

	mov sp, #0x80000		// Setup stack
	
	ldr x1, =__bss_start	// BSS start address
	ldr w2, =__bss_size		// BSS size in bytes

clear_bss:
	str     xzr, [x1], #8	// Store zero to address @ x1, increment x1 by 8B
							// Remember ea. x register is 64-bit, or 8-byte
	sub     w2, w2, #1		// We have cleared 8B of BSS
	cbnz    w2, clear_bss	// Loop until BSS is cleared

	bl _start_kernel		// Jump to kernel

halt:
	wfe						// Put core to low-power state and wait for event
	b halt					// Loop if core wakes up due to an event
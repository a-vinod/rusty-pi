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

    mrs     x0, MPIDR_EL1	// Read MPIDR_EL1 to register x0
    and     x0, x1, #3		// Mask around Aff0 bits to get core id
							// 00 -> 00, 01 -> 01, 11 -> 11
    cbnz    x0, halt		// Send cores with non-zero core id to `halt`

	// Only core 0 progresses past this point	

	ldr x1, =__bss_start
	ldr x2, =__bss_end

clear_bss_loop:
	cmp 	x1, x2
	beq		boot_kernel

	stp	xzr, xzr, [x1], #16
	bne		clear_bss_loop

boot_kernel:
	mov	sp, #0x80000
	b _start_rust			// Jump to kernel

halt:
	wfe						// Put core to low-power state and wait for event
	b halt					// Loop if core wakes up due to an event
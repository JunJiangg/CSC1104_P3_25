        .text
        .global main
        .align  2

/* ========= Helpers ========= */
ask_i:
        stp     x29, x30, [sp, -32]!
        stp     x19, x20, [sp, 16]
        mov     x29, sp
        mov     x19, x0
        mov     x20, x2
1:      mov     x0, x19
        mov     w2, w1
        bl      printf
        mov     x0, 0
        bl      fflush
        ldr     x0, =display_int_in
        mov     x1, x20
        bl      scanf
        cmp     w0, 1
        b.eq    2f
        ldr     x0, =err_integer_full
        bl      puts
        ldr     x0, =display_flush
        bl      scanf
        b       1b
2:      ldp     x19, x20, [sp, 16]
        ldp     x29, x30, [sp], 32
        ret

ask_f:
        stp     x29, x30, [sp, -32]!
        stp     x19, x20, [sp, 16]
        mov     x29, sp
        mov     x19, x0
        mov     x20, x2
1:      mov     x0, x19
        mov     w2, w1
        bl      printf
        mov     x0, 0
        bl      fflush
        ldr     x0, =display_double_in
        mov     x1, x20
        bl      scanf
        cmp     w0, 1
        b.eq    2f
        ldr     x0, =err_number_full
        bl      puts
        ldr     x0, =display_flush
        bl      scanf
        b       1b
2:      ldp     x19, x20, [sp, 16]
        ldp     x29, x30, [sp], 32
        ret

/* ========= Main ========= */
main:
        stp     x29, x30, [sp, -32]!
        stp     x19, x20, [sp, 16]
        mov     x29, sp

        ldr     x0, =title
        bl      puts

        /* number of instruction types */
        ldr     x0, =o_instruction_types
        ldr     x2, =instruction_types
        mov     w1, 0
        bl      ask_i

        /* keep stable pointers */
        ldr     x19, =instruction_types      // x19 -> n
        ldr     x20, =total_cycles           // x20 -> total_cycles

        /* total_cycles = 0.0 */
        fmov    d0, xzr
        str     d0, [x20]

        /* loop i = 1..n */
        mov     w21, 1
loop_types:
        ldr     w0, [x19]
        cmp     w21, w0
        b.gt    after_types

        /* counts (int) */
        ldr     x0, =o_count
        ldr     x2, =temporary_count
        mov     w1, w21
        bl      ask_i

        /* cpi (double) */
        ldr     x0, =o_cpi
        ldr     x2, =cpi_value
        mov     w1, w21
        bl      ask_f

        /* total_cycles += count * cpi */
        ldr     x3, =temporary_count
        ldr     w0, [x3]
        scvtf   d2, w0
        ldr     x4, =cpi_value
        ldr     d3, [x4]
        ldr     d1, [x20]
        fmul    d2, d2, d3
        fadd    d1, d1, d2
        str     d1, [x20]

        add     w21, w21, 1
        b       loop_types

after_types:
        ldr     x0, =o_clockCycleValue
        bl      puts

        /* clock cycle numeric value */
        ldr     x0, =o_clockCycle_input
        ldr     x2, =clockCycle_input
        mov     w1, 0
        bl      ask_f

/* ---- unit: validated table ---- */
read_unit:
        ldr     x0, =o_clockCycle_unit
        bl      printf
        mov     x0, 0
        bl      fflush
        ldr     x0, =display_str_in
        ldr     x1, =unitDisplay
        bl      scanf
        cmp     w0, 1
        b.ne    unit_bad

        ldr     x22, =unit_to_seconds_table
        mov     w23, 5
find_unit:
        cbz     w23, unit_bad
        ldr     x0, =unitDisplay
        ldr     x1, [x22]
        bl      strcmp
        cbnz    w0, unit_next
        ldr     x5, [x22, #8]
        b       unit_ok
unit_next:
        add     x22, x22, #16
        sub     w23, w23, #1
        b       find_unit
unit_bad:
        ldr     x0, =err_unit
        bl      puts
        b       read_unit

unit_ok:
        /* clkCycle_Seconds = clockCycle_input * mul_to_seconds */
        ldr     d1, [x5]
        ldr     x0, =clockCycle_input
        ldr     d0, [x0]
        fmul    d0, d0, d1
        ldr     x1, =clkCycle_Seconds
        str     d0, [x1]

        /* totalExecution_time = total_cycles * clkCycle_Seconds */
        ldr     d1, [x20]
        ldr     d0, [x1]
        fmul    d0, d0, d1
        ldr     x4, =totalExecution_time
        str     d0, [x4]

        /* menu */
        ldr     x0, =o_menu_block
        bl      puts
opt_loop:
        ldr     x0, =o_option
        ldr     x2, =option_choice
        mov     w1, 0
        bl      ask_i
        /* RELOAD the pointer; x2 is caller-saved */
        ldr     x2, =option_choice
        ldr     w24, [x2]
        cmp     w24, 1
        b.lt    opt_err
        cmp     w24, 3
        b.gt    opt_err

        ldr     x0, =results_hdr
        bl      puts

        /* cycles if 1 or 3 */
        cmp     w24, 1
        b.eq    show_cycles
        cmp     w24, 3
        b.ne    skip_cycles
show_cycles:
        ldr     x0, =display_cycles
        ldr     d0, [x20]
        bl      printf
skip_cycles:
        /* time if 2 or 3 */
        cmp     w24, 2
        b.eq    show_time
        cmp     w24, 3
        b.ne    done

show_time:
        /* RELOAD address; never rely on old x4/x3 after calls */
        ldr     x11, =totalExecution_time
        ldr     d0, [x11]                    // seconds
        ldr     x6, =clock_conversion_table
        mov     w7, 0
scan_time:
        cmp     w7, 4
        b.ge    do_ps
        add     x9, x6, w7, uxtw #4
        ldr     d1, [x9]                     // threshold
        fcmp    d0, d1
        b.ge    hit_scale
        add     w7, w7, 1
        b       scan_time
hit_scale:
        ldr     x10, [x9, #8]                // -> {scale, fmt}
        ldr     d1,  [x10]
        fmul    d0, d0, d1
        ldr     x0,  [x10, #8]
        bl      printf
        b       done
do_ps:
        ldr     x5, =conversion_s_to_ps
        ldr     d1, [x5]
        fmul    d0, d0, d1
        ldr     x0, =display_time_ps
        bl      printf
        b       done

opt_err:
        ldr     x0, =err_option_range
        bl      puts
        b       opt_loop

done:
        ldp     x19, x20, [sp, 16]
        ldp     x29, x30, [sp], 32
        mov     w0, 0
        ret

/* ========= Data ========= */
        .data
title:                  .asciz "=== Execution Time Calculator ==="
o_instruction_types:    .asciz "Enter number of instruction types: "
o_count:                .asciz "Enter instruction count for type %d: "
o_cpi:                  .asciz "Enter CPI for type %d: "
o_clockCycleValue:      .asciz "\nNow enter the clock cycle time:"
o_clockCycle_input:     .asciz "Enter clock cycle time value (e.g., 2.5): "
o_clockCycle_unit:      .asciz "Enter unit (s / ms / us / ns / ps): "
o_menu_block:           .asciz "\nSelect output:\n  1) Total clock cycles\n  2) Total execution time\n  3) Both"
o_option:               .asciz "Enter option number (1/2/3): "
results_hdr:            .asciz "\n--- Results ---"

display_cycles:         .asciz "Total clock cycles = %.0f\n"
display_time_s:         .asciz "Total execution time = %.6f s\n"
display_time_ms:        .asciz "Total execution time = %.6f ms\n"
display_time_us:        .asciz "Total execution time = %.6f \xC2\xB5s\n"
display_time_ns:        .asciz "Total execution time = %.6f ns\n"
display_time_ps:        .asciz "Total execution time = %.6f ps\n"

display_double_in:      .asciz " %lf"
display_int_in:         .asciz " %d"
display_str_in:         .asciz " %15s"
display_flush:          .asciz " %*[^\n]%*c"

err_number_full:        .asciz "Invalid input. Please enter a numeric value (e.g., 1.5, 2, 0.25)."
err_integer_full:       .asciz "Invalid input. Please enter an integer number only."
err_unit:               .asciz "Invalid unit. Please enter one of: s, ms, us, ns, ps."
err_option_range:       .asciz "Invalid choice. Please enter 1, 2, or 3."

/* unit tokens + multipliers (to seconds) */
        .align 3
tok_s:                  .asciz "s"
tok_ms:                 .asciz "ms"
tok_us:                 .asciz "us"
tok_ns:                 .asciz "ns"
tok_ps:                 .asciz "ps"

conversion_seconds:     .double 1.0
conversion_ms:          .double 1.0e-3
conversion_us:          .double 1.0e-6
conversion_ns:          .double 1.0e-9
conversion_ps_to_s:     .double 1.0e-12

unit_to_seconds_table:
        .quad tok_s,  conversion_seconds
        .quad tok_ms, conversion_ms
        .quad tok_us, conversion_us
        .quad tok_ns, conversion_ns
        .quad tok_ps, conversion_ps_to_s

/* auto-scale (s → s/ms/us/ns) */
clock_conversion_table:
        .double 1.0
        .quad   cct_s
        .double 1.0e-3
        .quad   cct_ms
        .double 1.0e-6
        .quad   cct_us
        .double 1.0e-9
        .quad   cct_ns

cct_s:   .double 1.0
         .quad   display_time_s
cct_ms:  .double 1.0e3
         .quad   display_time_ms
cct_us:  .double 1.0e6
         .quad   display_time_us
cct_ns:  .double 1.0e9
         .quad   display_time_ns

conversion_s_to_ps:     .double 1.0e+12

        .bss
        .align 3
instruction_types:      .skip 4
option_choice:          .skip 4
temporary_count:        .skip 4
                        .align 3
cpi_value:              .skip 8
total_cycles:           .skip 8
clockCycle_input:       .skip 8
clkCycle_Seconds:       .skip 8
totalExecution_time:    .skip 8
unitDisplay:            .skip 16

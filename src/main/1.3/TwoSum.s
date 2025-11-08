/* 
 * This program checks if any two numbers sum to a target value.
 * Uses a preset array and asks user for the target sum.
 */

.global main
.type main, %function
.extern printf
.extern scanf

.section .data
    // Preset array of numbers to search
    numberArray:    .word 10, 15, 3, 7, 22, 8, 12, 5
    arraySize:      .word 8
    
    // String messages for user interaction
    .align 3
    welcome:        .asciz "\n=== Two Sum Checker (ARM64) ===\n"
    arrayMsg:       .asciz "Array: "
    numFormat:      .asciz "%d "
    newlineStr:     .asciz "\n"
    promptMsg:      .asciz "Enter target sum: "
    inputFormat:    .asciz "%d"
    
    foundMsg:       .asciz "There are two numbers in the list summing to the keyed-in number %d\n"
    detailMsg:      .asciz "  -> %d + %d = %d\n\n"
    notFoundMsg:    .asciz "There are not two numbers in the list summing to the keyed-in number %d\n\n"

.section .bss
    .align 3
    .lcomm targetValue, 4           // Space to store target sum

.section .text
.align 2

/*
 * printWelcome: Display welcome message
 */
printWelcome:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    adrp    x0, welcome
    add     x0, x0, :lo12:welcome
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret

/*
 * displayArray: Show all numbers in the array
 * Parameters: x19 = array address, w20 = array size
 */
displayArray:
    stp     x29, x30, [sp, #-48]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    
    // Print "Array: " label
    adrp    x0, arrayMsg
    add     x0, x0, :lo12:arrayMsg
    bl      printf
    
    // Loop through array
    mov     w21, #0                   // counter = 0
    
display_loop:
    cmp     w21, w20                  // compare counter with size
    b.ge    display_done
    
    // Load and print current element
    lsl     w22, w21, #2              // offset = counter * 4
    ldr     w1, [x19, w22, sxtw]      // load element
    
    adrp    x0, numFormat
    add     x0, x0, :lo12:numFormat
    bl      printf
    
    add     w21, w21, #1              // counter++
    b       display_loop
    
display_done:
    // Print newline
    adrp    x0, newlineStr
    add     x0, x0, :lo12:newlineStr
    bl      printf
    
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    ret

/*
 * getUserInput: Prompt and read target sum from user
 * Returns: w0 = target value entered by user
 */
getUserInput:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Print prompt
    adrp    x0, promptMsg
    add     x0, x0, :lo12:promptMsg
    bl      printf
    
    // Read integer from user
    adrp    x0, inputFormat
    add     x0, x0, :lo12:inputFormat
    adrp    x1, targetValue
    add     x1, x1, :lo12:targetValue
    bl      scanf
    
    // Load and return the value
    adrp    x0, targetValue
    add     x0, x0, :lo12:targetValue
    ldr     w0, [x0]
    
    ldp     x29, x30, [sp], #16
    ret

/*
 * findTwoSum: Search for two numbers that sum to target
 * 
 * Algorithm: Nested loop approach
 * - Outer loop: iterate through each element (i)
 * - Inner loop: check elements after i (j = i+1 to end)
 * - If arr[i] + arr[j] == target, we found a match
 * 
 * Parameters:
 *   x19 = array address
 *   w20 = array size
 *   w21 = target sum
 * 
 * Returns:
 *   w0 = 1 if found, 0 if not found
 *   w1 = first number (if found)
 *   w2 = second number (if found)
 */
findTwoSum:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    mov     w22, #0                   // outer loop counter i = 0
    
outer_loop:
    // Check if outer loop is done
    sub     w23, w20, #1              // size - 1
    cmp     w22, w23
    b.ge    not_found                 // if i >= size-1, not found
    
    // Load arr[i]
    lsl     w24, w22, #2              // offset for i
    ldr     w25, [x19, w24, sxtw]     // w25 = arr[i]
    
    // Inner loop starts at i+1
    add     w26, w22, #1              // j = i + 1
    
inner_loop:
    // Check if inner loop is done
    cmp     w26, w20
    b.ge    outer_continue            // if j >= size, continue outer
    
    // Load arr[j]
    lsl     w27, w26, #2              // offset for j
    ldr     w28, [x19, w27, sxtw]     // w28 = arr[j]
    
    // Check if arr[i] + arr[j] == target
    add     w29, w25, w28             // sum = arr[i] + arr[j]
    cmp     w29, w21
    b.eq    found_match               // if equal, we found it!
    
    // Continue inner loop
    add     w26, w26, #1              // j++
    b       inner_loop
    
outer_continue:
    add     w22, w22, #1              // i++
    b       outer_loop
    
found_match:
    // Return success with the two numbers
    mov     w0, #1                    // return found = true
    mov     w1, w25                   // first number
    mov     w2, w28                   // second number
    ldp     x29, x30, [sp], #16
    ret
    
not_found:
    mov     w0, #0                    // return found = false
    ldp     x29, x30, [sp], #16
    ret

/*
 * displayResult: Print the search result
 * Parameters:
 *   w19 = found flag (1 or 0)
 *   w20 = first number
 *   w21 = second number
 *   w22 = target sum
 */
displayResult:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    cmp     w19, #1
    b.eq    print_found
    
    // Print "not found" message
    adrp    x0, notFoundMsg
    add     x0, x0, :lo12:notFoundMsg
    mov     w1, w22                   // target value
    bl      printf
    b       result_done
    
print_found:
    // Print "found" message
    adrp    x0, foundMsg
    add     x0, x0, :lo12:foundMsg
    mov     w1, w22                   // target value
    bl      printf
    
    // Print details: "num1 + num2 = target"
    adrp    x0, detailMsg
    add     x0, x0, :lo12:detailMsg
    mov     w1, w20                   // first number
    mov     w2, w21                   // second number
    mov     w3, w22                   // target (sum)
    bl      printf
    
result_done:
    ldp     x29, x30, [sp], #16
    ret

/*
 * main: Program entry point
 */
main:
    stp     x29, x30, [sp, #-64]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    str     x23, [sp, #48]
    
    // Print welcome message
    bl      printWelcome
    
    // Load array address
    adrp    x19, numberArray
    add     x19, x19, :lo12:numberArray
    
    // Load array size
    adrp    x0, arraySize
    add     x0, x0, :lo12:arraySize
    ldr     w20, [x0]
    
    // Display the array
    bl      displayArray
    
    // Get target sum from user
    bl      getUserInput
    mov     w21, w0                   // save target in w21
    
    // Search for two sum
    bl      findTwoSum
    
    // Save search results
    mov     w19, w0                   // found flag
    mov     w23, w1                   // first number
    
    // Prepare parameters for display
    mov     w20, w23                  // first number
    // w21 already has target
    mov     w22, w21                  // target for display
    // w2 already has second number if found
    mov     w21, w2                   // second number
    
    // Display results
    bl      displayResult
    
    // Return 0
    mov     w0, #0
    
    ldr     x23, [sp, #48]
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #64
    ret

/*
 * Compilation:
 * gcc -o two_sum_checker two_sum_checker.s
 * 
 * Execution:
 * ./two_sum_checker
 * 
 * Example interaction:
 * Array: 10 15 3 7 22 8 12 5
 * Enter target sum: 18
 * There are two numbers in the list summing to the keyed-in number 18
 *   -> 10 + 8 = 18
 */
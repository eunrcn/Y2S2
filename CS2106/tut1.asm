text
data
stack


1. 
    .data
a:  .word 3
b:  .word 4
y:  .word 0

    .text
    .globl main

main:
    # Load addresses of variables a and b into registers $a0 and $a1
    la  $a0, a      # $a0 = &a
    lw  $a0, 0($a0) # $a0 = a

    la  $a1, b      # $a1 = &b
    lw  $a1, 0($a1) # $a1 = b

    jal f           # Call function f

    # Store the result in variable y
    la  $t0, y      # $t0 = &y
    sw  $v0, 0($t0) # y = $v0

    # Exit program
    li  $v0, 10
    syscall

f:
    # Function f(x, y): returns 2 * (x + y)

    # Load parameters x and y into registers $a0 and $a1
    lw  $a0, 0($a0) # $a0 = x
    lw  $a1, 0($a1) # $a1 = y

    # Compute 2 * (x + y)
    add $v0, $a0, $a1 # $v0 = x + y
    sll $v0, $v0, 1   # $v0 = 2 * (x + y)

    # Return to the calling function
    jr $ra

=============================================================
2.
frame pointer point to bottom of stack
stack pointer point to top of stack

load value a=3
frame pointer +4 to shift up
load value b=4



“Pushing” a value in $r0 onto the stack. 
 
sw $r0, 0($sp) 
addi $sp, $sp, 4 
add 4 bc word size is 4
 
“Popping” a value from the stack to $s0: 
 
addi $sp, $sp, -4 
lw $s0, 0($sp)
-4 to reduce address of sp and pops out the value onto the stack


.text
.globl main

main:
    # Initialize some values
    li $t0, 5        # Argument 1
    li $t1, 7        # Argument 2

    # Call the add_numbers function
    jal add_numbers

    # At this point, $v0 contains the result

    # Exit program
    li $v0, 10
    syscall

add_numbers:
    # Save the frame pointer on the stack
    sw $fp, -4($sp)
    addi $fp, $sp, -4

    # Push arguments onto the stack
    sw $t0, 0($fp)
    sw $t1, 4($fp)

    # Perform the addition
    lw $t2, 0($fp)    # Load argument 1
    lw $t3, 4($fp)    # Load argument 2
    add $v0, $t2, $t3 # Add the arguments and store result in $v0

    # Restore the frame pointer
    lw $fp, 0($sp)
    addi $sp, $sp, 4

    # Return from function
    jr $ra
=============================================================
3.

The approach of passing parameters and calling functions using
the stack, as described in Questions 1 and 2, can work for 
recursive or nested function calls in MIPS assembly. 
However, certain considerations need to be taken into account
to ensure correct behavior:

Stack Space:
When a function is called, a new stack frame is created for that 
function call. If the function is recursive or if there are nested 
function calls, each function call creates a new stack frame, 
leading to a potential stack overflow if there are too many nested 
calls. It's important to manage the available stack space properly.

Saving and Restoring Registers:
The approach involves using the stack to save and restore the frame 
pointer, as well as other registers. When dealing with recursive 
or nested calls, it's crucial to save and restore the registers 
properly to prevent unintended interference between different 
function calls.

Register Usage:
In MIPS assembly, certain registers like $fp (frame pointer) and 
$ra (return address) are typically used for managing function calls.
 When a function is called recursively or nested within another 
 function, these registers need to be preserved correctly to avoid 
 conflicts.

Local Variables and Parameters:
Each function call has its own set of local variables and parameters 
stored in the stack frame. Proper indexing or addressing is needed 
to access the correct variables in each frame.

Stack Cleanup:
After each function call, the stack pointer ($sp) needs to be 
adjusted to free up the space allocated for local variables and 
parameters. Incorrect adjustments may lead to stack corruption.

.text
.globl main

main:
    li $a0, 5
    jal recursive_function

    # Exit program
    li $v0, 10
    syscall

recursive_function:
    # Save frame pointer
    sw $fp, -4($sp)
    addi $fp, $sp, -4

    # Push argument onto the stack
    sw $a0, 0($fp)

    # Base case
    li $t0, 1
    beq $a0, $t0, base_case

    # Recursive call
    subi $a0, $a0, 1
    jal recursive_function

base_case:
    # Pop argument
    lw $a0, 0($fp)

    # Restore frame pointer
    lw $fp, 0($sp)
    addi $sp, $sp, 4

    # Return from function
    jr $ra

=============================================================
4.

.text
.globl main

main:
    # Initialize some values
    li $a0, 5
    li $a1, 7

    # Caller: Push $fp and $sp to the stack
    subi $sp, $sp, 8
    sw $fp, 0($sp)
    sw $sp, 4($sp)

    # Copy $sp to $fp
    move $fp, $sp

    # Reserve space for parameters on the stack
    subi $sp, $sp, 8

    # Write parameters to the stack using offsets from $fp
    sw $a0, 0($fp)
    sw $a1, 4($fp)

    # jal to callee
    jal callee_function

    # Caller: Get result from stack
    lw $v0, 0($sp)

    # Caller: Restore $sp and $fp
    lw $sp, 4($sp)
    lw $fp, 0($sp)

    # Exit program
    li $v0, 10
    syscall

callee_function:
    # Callee: Push $ra to stack
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    # Callee: Allocate space for local variables
    subi $sp, $sp, 4

    # Callee: Push registers we intend to use onto the stack
    subi $sp, $sp, 8

    # Callee: Use $fp to access parameters
    lw $t0, 0($fp)  # Load parameter 1
    lw $t1, 4($fp)  # Load parameter 2

    # Callee: Compute result
    add $v0, $t0, $t1

    # Callee: Write result to the stack
    sw $v0, 0($sp)

    # Callee: Restore registers we saved from the stack
    addi $sp, $sp, 8

    # Callee: Get $ra from stack
    lw $ra, 0($sp)

    # Callee: Return to caller
    jr $ra

=============================================================

5. 
In the MIPS architecture, certain registers are designated as callee-saved and caller-saved registers. The convention of saving and restoring registers in the callee (function being called) is crucial for maintaining the state of the calling function (caller). If the callee does not save and restore the callee-saved registers, it can lead to issues such as unintended modifications to the caller's registers.

Here's a breakdown of the consequences if the callee does not save and restore callee-saved registers:

1. **Unintended Modifications:**
   - If the callee modifies callee-saved registers without restoring their original values, it can lead to unintended changes in the caller's state. This is because the callee-saved registers are expected to be preserved across function calls.

2. **Loss of Caller's State:**
   - The callee-saved registers are used by the caller to store important information. If the callee does not restore them, the caller might lose its original register values, potentially leading to incorrect behavior or crashes.

3. **Violation of Calling Convention:**
   - MIPS calling conventions specify which registers are caller-saved and callee-saved. Violating these conventions can result in code that is difficult to understand, maintain, and debug. It can also lead to compatibility issues when integrating with other code.

Now, regarding the question of why we don't do the same thing for `main`:

- The `main` function in MIPS assembly is typically treated as a special case. When the program starts, `main` is the entry point, and its return signifies the end of the program. In many cases, `main` does not call other functions, and the execution terminates after its completion.
  
- Since `main` does not make calls to other functions, there is no need for it to save and restore registers as if it were a callee. The program typically relies on the operating system to handle cleanup after `main` returns.

- Additionally, `main` often interacts with the operating system for program termination, and the operating system is responsible for cleaning up resources and handling the return value of `main`. As a result, `main` does not need to follow the same register preservation conventions as other functions.

In summary, saving and restoring registers are critical for maintaining state during function calls, especially when dealing with nested or recursive calls. However, `main` is often treated as a special case where these considerations are not as relevant due to its specific role in program execution and termination.

6.

In step 7 of the callee, where the `$ra` (return address) is retrieved from the stack before executing `jr $ra`, this sequence of actions is necessary to properly handle the return from the function. Let's break down why retrieving `$ra` from the stack is essential:

1. **Return Address Preservation:**
   - The `$ra` register stores the return address, which is the address in memory where the program should continue execution after the function call completes. The callee saves this value on the stack at the beginning of the function (`jal` instruction automatically updates `$ra` with the return address). It is crucial to preserve this return address, as it ensures that the program can correctly resume execution after the function call.

2. **Stack Cleanup:**
   - The `jr $ra` instruction effectively performs a jump to the address stored in `$ra`, initiating the return to the caller. Before executing `jr $ra`, the callee is often required to clean up the stack by adjusting the stack pointer (`$sp`). The return address (`$ra`) must be retrieved before modifying the stack pointer to ensure the correct value is used in the jump operation.

3. **Order of Operations:**
   - In MIPS assembly, the `jr $ra` instruction is typically the last operation performed by the callee before returning to the caller. By retrieving `$ra` from the stack before the jump, the callee follows the proper order of operations. This ensures that the return address is restored before any other cleanup activities are carried out.

Here's a typical sequence of actions in the callee's epilogue:

   ```assembly
   # Callee Epilogue
   lw $ra, 0($sp)    # Retrieve return address from the stack
   addi $sp, $sp, 4  # Adjust stack pointer to clean up the stack
   jr $ra            # Jump to the return address
   ```

Attempting to directly execute `jr $ra` without retrieving `$ra` from the stack may lead to using an incorrect or stale return address. This can result in unpredictable behavior, including incorrect control flow, crashes, or other issues.

In summary, retrieving `$ra` from the stack before executing `jr $ra` is a critical step in ensuring a proper and orderly return from the function, allowing the program to resume execution at the correct location in the calling code.
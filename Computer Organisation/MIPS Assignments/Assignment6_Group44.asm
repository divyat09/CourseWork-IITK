# Group 44   Assignment 6

# $t0 stores the value of N
# $t1 stores the address to the array of integers
# $t2 stores the current integer
# $t3 stores the previous integer
# $t4 used for intermediate calculations
# $t5 stores the index of integer 

.data

size: .word 0
input1: .asciiz "Please enter the value of N: "
input2: .asciiz "Please enter the value of Integer: "
input3: .asciiz "Input Sequence is: "
newline: .asciiz "\n"
space: .asciiz "  "
output: .asciiz "Ouput Sequence for round "
colon: .asciiz ":"
error: .asciiz "Please enter a valid N i.e N>1"

.text
.globl main

main:

	la $a0, input1			# Printing input message
	li $v0, 4
	syscall

	li $v0, 5				# Taking N as input
	syscall
		
	sw $v0, size   		    # Stroing the number of integers given as input 
	move $t0, $v0
	addi $t4, $zero, 1
	ble $t0, $zero, Error		# Error if N<=1		
	beq $t0, $t4, r2

	mul $a0, $t0, 4			# Setting the size of array as 4*N  	
    li  $v0 9
    syscall 				# Creating an array of size 4*N to hold input  integers

    move $t1, $v0
	li $t5, 0
	j input_loop			

r2:
	la $a0, input2
	li $v0, 4
	syscall

	li $v0, 5               
	syscall

	move $a0, $v0
	li $v0, 1
	syscall
	j EXIT

Error:
	la $a0, error			# Printing error message
	li $v0, 4
	syscall
	j EXIT

input_loop: 				# Here we take each individual integer as input
	
	la $a0, input2
	li $v0, 4
	syscall

	li $v0, 5               
	syscall
	move $t2, $v0

	sw $t2, ($t1)		   # Storing the input integer into array we had created 	

	addi $t1, $t1, 4
	addi $t5, $t5, 1
	bge $t5, $t0, Input_Sequence_Init
	j input_loop

Input_Sequence_Init:       # Printing the input sequence of integers      
	
	la $a0, newline
	li $v0, 4
	syscall
	la $a0, input3
	li $v0, 4
	syscall
	
	mul $t4, $t0, -4
	add $t1, $t1, $t4	   # Setting the array pointer to base of array	
	li $t5, 0
	lw $t4, size
	
	j Input_Sequence

Input_Sequence:           # Printing each input integer	

	lw $t2, ($t1)
	move $a0, $t2
	li $v0, 1
	syscall

	la $a0, space
	li $v0, 4
	syscall

	addi $t1, $t1, 4
	addi $t5, $t5, 1  
	bge $t5, $t0, Bubble_Sort_Init
	j Input_Sequence

Bubble_Sort_Init:
	
	mul $t4, $t0, -4
	add $t1, $t1, $t4	   # Setting the array pointer to base of array			
	
	lw $t3, ($t1)  		  	
	li $t5, 1
	addi $t1, $t1, 4       
	j Bubble_Sort

# This function performs Bubble Sort. It takes the initial element in $t3 and compares it  # with the next element in $t4. If $t3>$t4 then it calls Swapping. Swapping calls the
# function Swap, which swaps the value of 2 regiters given to it.
# If $t3 < $t4, then it does no swapping, and updates array pointer and compares the next
# pair of integers. It assigns the current integer ($t2) to $t3 and updates $t2 to hold 
# value of the next integer. 

# After one step or one complete round ( i.e. when $t5=$t0 and largest element is in 
# correct position), it prints the whole sequence.  Then it updates for the next round. 
# Update: This block updates the $t0, $t5, $t1 for the next round of comparing which leads 
# to second largest element in correct position.
# After N-1 rounds, we have a complete sorted sequence.

Bubble_Sort:				      	
	
	lw $t2, ($t1)
	bgt $t3, $t2, Swapping          # Swap the values of two registers if t3>=t2

	lw $t3, ($t1)					# Updating $t3 to hold value of current integer
	addi $t1, $t1, 4				# Updating the pointer of array
	addi $t5, $t5, 1
	bge $t5, $t0, Print_Init		# Checking the end of first round of Bubble Sort
	j Bubble_Sort

Swapping:
	
	move $a0, $t3
	move $a1, $t2
	jal Swap  						# Calls function Swap that swaps the values of $t2,$t3 
	move $t3, $v0					# Swap function is at end of this file
	move $t2, $v1

	sw $t2, ($t1)    				# Storing the changes due to swap in array of integers
	addi $t1, $t1, -4
	sw $t3, ($t1)
	addi $t1, $t1, 4

	lw $t3, ($t1)					# Updating to compare the next pair of integers
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	bge $t5, $t0, Print_Init		# Checking the end of first round of Bubble Sort	
	j Bubble_Sort


Print_Init:							  # Printing the sequence after first round

	la $a0, newline
	li $v0, 4
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	la $a0, output
	li $v0, 4
	syscall

	lw $t4, size				# Printing the index of current round of Bubble Sort  	
	sub $t4, $t4, $t0
	addi $t4, $t4, 1
	move $a0, $t4
	li $v0, 1
	syscall

	la $a0, colon
	li $v0, 4
	syscall	
	la $a0, space 
	li $v0, 4
	syscall

	mul $t4, $t0, -4			# Initialising for printing the whole sequence
	add $t1, $t1, $t4
	li $t5, 0
	lw $t4, size
	
	j Print

Print:							# Traversing over sequence 

	lw $t2, ($t1)				# Printing the current integer in sequence
	move $a0, $t2
	li $v0, 1
	syscall

	la $a0, space
	li $v0, 4
	syscall

	addi $t1, $t1, 4		    # Traversing over sequence 
	addi $t5, $t5, 1  
	bge $t5, $t4, Update        # Moving to update after printing all integers of sequence
	j Print

Update: 						# Performs required updates for next round of Bubble Sort

	lw $t4, size				
	mul $t4, $t4, -4
	add $t1, $t1, $t4			# Setting the pointer to base
	lw $t3, ($t1)				
	li $t5, 1						

	addi $t1, $t1, 4
	addi $t0, $t0, -1	
	# Decreasing size for next round as other (N-i) elements sorted in prev round

	addi $t4, $zero, 1
	beq $t0, $t4, EXIT		# If only one element, then we are finished with Bubble Sort
	j Bubble_Sort
	
EXIT:						# Terminating the program
	
	li $v0, 10
	syscall


# This function swaps the values of two registers given to it
# It takes two input arguments, swaps them and returs the swapped value

.globl Swap

Swap:						

	addi $sp, $sp, -32				# Setting frame size to 32
	sw $ra, 28($sp)					# Saving return address and frame pointer
	sw $fp, 24($sp)
	addu $fp, $sp, 32               # Pointing frame pointer to base of frame

	move $s0, $a0					# Taking the input parameters into registers	
	move $s1, $a1
	
	add  $s2, $s1, $zero			# Performing the swap
	move $s1, $s0
	move $s0, $s2
	
	move $v0, $s0					# Setting the output of the function
	move $v1, $s1

	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	addi $sp, $sp, 32
	jr $ra	
# Group 44  Assignment 5

#Write a MIPS program to perform the following: Given a positive integer 0 ≤ n ≤ 20, store the first n
#numbers of the Fibonacci series in memory and print them.

# $t0 stores the value of N
# $t1 stores the index of current fibonacci number
# $t2 used for intermediate calculations
# $t3 used to store the index of current fibonacci in myArray

.data

error: .asciiz "Please enter value of N between 0 and 20 "
inputxn: .asciiz "Please enter value for n\n "
outputspace: .asciiz " "
output: .asciiz "The finonacci sequence is: \n "
theNumber: .word 0 		#User Input N 

.align 4
myArray: .space 80						# This array will store the fibonacci sequence

.text
.globl main

main:

	la $a0, inputxn						#Taking input for n 			
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	blt $v0, $zero, Error				# Error if N < 0
	li $t0, 20
	bgt $v0, $t0, Error					# Error if N > 20

	sw $v0, theNumber					# Stroing the input n
	move $t0, $v0  						
	li $t1, 0
	li $t3, 0 						

	j Loop								# Go to Loop that calculates Fib Sequence	

Error:
	la $a0, error			# Printing error message
	li $v0, 4
	syscall
	j EXIT

Loop:					# Loop to calculate and store fibonaaci series upto n in memory
	
	move $a0, $t1
	jal findFib 						# Finding ith Fib number 

	sw $v0, myArray($t3) 			    # Stroing the ith Fib number in memory

	addi $t3, $t3, 4 					# Updating for next Fib number	
	addi $t1, $t1, 1
	bgt $t1, $t0, Print_Init         # If $t1 > n, then all numbers calculate. Go to Print 

	j Loop

Print_Init:
	
	la $a0, output
	li $v0, 4
	syscall
	                  
	lw $t0, theNumber
	li $t3, 0 	  		# Restoring so $t3 becomes base of array containing fib numbers
	li $t1, 0

	j Print

Print:

	lw $t2, myArray($t3)   
	move $a0, $t2          					# Print the fib number	
	li $v0, 1
	syscall

	la $a0, outputspace                     # Print space between two fib numbers
	li $v0, 4
	syscall

	addi $t3, $t3, 4
	addi $t1, $t1, 1
	bgt $t1, $t0, EXIT                  # If $t1>n, all numbers printed. Terminate Program

	j Print

EXIT:										# Terminate Program

	li $v0, 10
	syscall

#Findfib function
# This function calculates the fibonacci numbers. It takes input argument n 
# and returns nth fibonacci number

.globl findFib

findFib:
	
	addi $sp, $sp, -32				# Setting frame size to 32
	sw $ra, 28($sp)					# Saving return address and frame pointer and s1,s2,s3
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addi $fp, $sp, 32               # Pointing frame pointer to base of frame
	
	beq $a0, $zero, fib_base_1		# If n=0 then return 0	

	addi $s3, $zero, 1
	beq $a0, $s3, fib_base_2 		# If n=1 then retuen 1

	move $s0, $a0

	addi $a0, $s0, -1 				# Calculating fib(n-1)
	jal findFib
	move $s1, $v0

	addi $a0, $s0, -2 				# Calculating fib(n-2)
	jal findFib
	move $s2, $v0

	add $v0, $s1, $s2    			# Return fib(n-1) + fib(n-2)

	lw $ra, 28($sp)			# Restoring frame and stack pointer, return address, s1, s2, s3
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	lw $s2, 12($sp)
	addi $sp, $sp, 32
	jr $ra

fib_base_1:

	li $v0, 0 						# Return 0 for n=0 base case

	lw $ra, 28($sp)			# Restoring frame and stack pointer, return address, s1, s2, s3
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	lw $s2, 12($sp)
	addi $sp, $sp, 32
	jr $ra

fib_base_2:

	li $v0, 1						# Return 1 for n=1 base case	

	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	lw $s2, 12($sp)
	addi $sp, $sp, 32
	jr $ra

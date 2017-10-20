# Group 44 Assignment 3
# $t0 contains the number in decimal
# $t1 contains the current digit of binary number
# $t2, $t3 are pointers to the binary number stored 
# $t4 being 1 states negative number and being 0 states positive number
# $t5 holds the value 2
# $s0 stores bit0 and $s1 stores bit1

.data
bit0: .byte '0'
bit1: .byte '1'
binary: .space 33
input:  .asciiz "Please enter the number you want to convert to binary: "
output: .asciiz "Number in the binary form: "
newline: .asciiz "\n"
MaxNumber: .word 2147483647
MinNumber: .word -2147483648
error_max: .asciiz "Please eneter a smaller number, Binary Number will be represented in 32 bits only"
error_min: .asciiz "Please eneter a larger number, Binary Number will be represented in 32 bits only"

.text
.globl main

main:
	
	li $t2, 31
	li $t3, 31 
	li $t4, 0
	li $t5, 2
	lw $t6, MaxNumber 
	lw $t7, MinNumber
	lb $s0, bit0 
	lb $s1, bit1
	
	#Taking the number as input
	la $a0, input
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $t0, $v0

	#Checking whether the magnitude of number is within range representable
	bgt $t0, $t6, ErrorMax
	blt $t0, $t7, ErrorMin

	# Checking whether number is positive or negative
	bge $t0, $zero, Loop1
	li $t4, 1
	mul $t0, $t0, -1
	j Loop1

ErrorMax:

	la $a0, error_max
	li $v0, 4
	syscall
	j EXIT

ErrorMin:

	la $a0, error_min
	li $v0, 4
	syscall
	j EXIT

Loop1:

	# Dividing the number by 2
	div $t0, $t5
	mfhi $t1
	mflo $t0
	
	# Updating 
	beq $t1, $zero, Place_Zero	   # Storing '0' for remainder 0
	sb $s1, binary($t2)            # Storing '1' for remainder 1 
	addi $t2, $t2, -1	       
	beq $t0, $zero, Loop2
	j Loop1

Place_Zero:
	sb $s0, binary($t2)			   # Stroing '0' for remainder 0
	addi $t2, $t2, -1	
	beq $t0, $zero, Loop2
	j Loop1
	
Loop2:

	#Filling the rest bits with zero to make a 32 bit number
	sb $s0, binary($t2)
	addi $t2, $t2, -1
	blt $t2, $zero, Convert
	j Loop2

Convert:

	# Convert to 2's complement if you have a negative number
	beq $t4, $zero, Print 	      # $t4==0 is positive case...head to printing
	lb $t1, binary($t3) 
	bne $t1, $s0, Flip            # Waiting till the first 1 to appear  
	addi $t3, $t3, -1
	j Convert

Flip:

	addi $t3, $t3, -1
	blt $t3, $zero, Print           # Printing if whole number has been flipped  
	lb $t1, binary($t3)             
	beq $t1, $s0, flip              # fliping bit 0 to bit 1                             
	sb $s0,binary($t3)              # fliping bit 1 to bit 0 
	j Flip

flip:					

	sb $s1,binary($t3)
	j Flip
	
Print:	

	# Printing the Binary Number
	la $a0, output
	li $v0, 4
	syscall

	la $a0, newline 
	li $v0, 4
	syscall

	la $a0, binary
	li $v0, 4
	syscall

	la $a0, newline 
	li $v0, 4
	syscall

	j EXIT

EXIT:

	li $v0, 10
	syscall
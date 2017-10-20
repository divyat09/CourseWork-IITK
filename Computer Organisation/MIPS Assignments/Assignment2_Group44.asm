#Variable Declaration
# $t1: Pointer to character array
# $t2: Current character to be analysed for conversion to upper case

.data 

array: .space 50
input: .asciiz "Please enter a string "
output: .asciiz "Output String: "
.text
.globl main

main:

	li $t1, 0

	#Input Message
	la $a0, input
	li $v0, 4
	syscall

	#Loading String
	li $v0, 8
	la $a0, array
	li $a1, 50  
	syscall
	
loop:
	
	#Checking for lower case
	lb $t2, array($t1)
	blt $t2, 'a', NOTLOWER
	bgt $t2, 'z', NOTLOWER 		

	addi $t2, $t2, -32 
	sb $t2, array($t1)
	addi $t1, $t1, 1
	beq $t2, $zero, EXIT
	j loop

NOTLOWER:
	
	addi $t1, $t1, 1
	beq $t2, $zero, EXIT
	j loop

EXIT:

	#Print and Terminate Program

	la $a0, output
	li $v0, 4
	syscall

	la $a0, array
	li $v0, 4
	syscall

	li $v0, 10
	syscall	
	
.end main

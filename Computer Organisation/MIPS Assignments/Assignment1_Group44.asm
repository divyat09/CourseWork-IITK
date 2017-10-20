# Program equivalent to the following C function
#	int func (int x, int y)
#	{
#		int u;
#		u = -5 * x - 7 * y;
#		if (u < -35) return -35;
#		else if (u > 35) return 35;
#		else return u;
#	}

#Registers Used
# $t0 for storing x
# $t1 for storing y
# $t4 displays the output of the function
# $t6 for storing -35
# $t7 for storing 35
# $t2, $t3, $t5 used for in between computations
#data segment

.data
inputx: .asciiz "Please enter value for x "
inputy: .asciiz "Please enter value for y "
output: .asciiz "Output of the function is "
u: .word 0 

.text
.globl main

main: 
	  
	  #Taking Input for x
	  la $a0, inputx
	  li $v0, 4
	  syscall
	  li $v0, 5
	  syscall
	  move $t0, $v0	
	  
	  #Taking Input for y
	  la $a0, inputy
	  li $v0, 4
	  syscall
	  li $v0, 5
	  syscall
	  move $t1, $v0

	  #Computing the value of u
	  mul $t2, $t0, 5
	  mul $t3, $t1, 7
	  add $t4, $t2, $t3
	  add $t5, $zero, -1
	  mul $t4, $t4, $t5
	  
	  #Peforming check on u 
	  addi $t6, $zero, -35
	  addi $t7, $zero, 35 
	  blt $t4,$t6, ret1 
	  bgt $t4,$t7, ret2
	  
	  #Stroing Output
	  sw $t4, u

	  #Printing u
	  la $a0, output
	  li $v0, 4
	  syscall
	  li $v0, 1
      move $a0, $t4
      syscall

      #Terminating
	  li $v0, 10
	  syscall

ret1: 
	  move $t4, $t6 
	  
	  #Storing Output
	  sw $t4, u

	  #Printing -35
	  la $a0, output
	  li $v0, 4
	  syscall
	  li $v0, 1
      move $a0, $t4
      syscall	

      #Terminating	  
	  li $v0, 10
	  syscall

ret2: 
	  move $t4, $t7

	  #Storing Output
	  sw $t4, u
	  
	  #Printing 35
	  la $a0, output
	  li $v0, 4
	  syscall
	  li $v0, 1
      move $a0, $t4
      syscall	

      #Terminating
	  li $v0, 10
	  syscall

.end main




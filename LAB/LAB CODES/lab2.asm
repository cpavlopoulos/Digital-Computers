# Calculator

.data 
string1: .asciiz "\nPlease enter first number: "
operation: .asciiz "\nPlease enter the opearation: "
string2: .asciiz "\n\nPlease enter second number: "
result: .asciiz "\nThe result is: "
string3: .asciiz "\nYou have entered wrong operation! "

.text

main:
#Print of first string
li $v0, 4
la $a0, string1
syscall

#Input of first number
li $v0, 5
syscall

#Input stored in temporary registor $t1
addi $t1, $v0, 0

#Print of operation string
li $v0, 4
la $a0, operation
syscall

#Input of character
li $v0, 12
syscall

#Character stored in temporary registor $t4
move $t4, $v0

#Print of second string
li $v0, 4
la $a0, string2
syscall

#Input of second number
li $v0, 5
syscall

#Input stored in temporary registor $t2
addi $t2, $v0, 0

#using ascii code to find the correct operation according to user's input 
li $t3, 43			#loading 43 (+) in registor $t3
beq $t4, $t3, Addition		#if user's input is + goes to label addition 

li $t3, 45			#loading 45 (-) in registor $t3
beq $t4, $t3, Subtraction	

li $t3, 42			#loading 42 (*) in registor $t3
beq $t4, $t3, Multiplication

li $t3, 47			#loading 47 (/) in registor $t3
beq $t4, $t3, Division


li $v0, 4			#if user doesn't input any correct operation 
la $a0, string3			#program prints that he has entered a wrong operation
syscall				#and moves to the start of the code
j main

#end of main
li $v0,10
syscall


#Cases
Addition:
add $t3, $t1, $t2	#Sum stored in $t3
j exit

Subtraction:
sub $t3, $t1, $t2	#Difference stored in $t3
j exit

Multiplication:
mul $t3, $t1, $t2	#Product stored in $t3
j exit

Division:
div $t3, $t1, $t2	#Quotient stored in $t3
j exit

#print of result and termination of program
exit:
li $v0, 4
la $a0, result
syscall

li $v0, 1
addi $a0, $t3, 0
syscall

li $v0,10 
syscall

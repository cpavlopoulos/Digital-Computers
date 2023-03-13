
#Hello World! (character)
.data		## Data declaration section

give_char: .asciiz "Please enter your character\n" ##user's input
string: .asciiz "\n Hello, World! "

.text		## Assembly language instructions go in text segment

main:		## Start of code section
li $v0,4	#syscall for print string = 4
la $a0, give_char	#load address of string for user to give character
syscall 	#call operating system to perfrom operation
		
		
li $v0, 12 	##syscall for reading char
syscall		

addi $t0, $v0, 0  ##storing user's character on a temporary registor 


li $v0, 4	##syscall for printing Hello, World!
la $a0, string
syscall

li $v0, 11	##syscall for printing user's input
addi $a0, $t0, 0 
syscall

		
li $v0,10 	#terminates program
syscall 

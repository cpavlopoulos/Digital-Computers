
#Hello your_string World!
.data		## Data declaration section

give_string: .asciiz "Please enter your string\n" ##user's input
string1: .asciiz "\n Hello "
string2: .asciiz " World!"
input: .asciiz " "

.text		## Assembly language instructions go in text segment

main:		## Start of code section
li $v0,4	#syscall for print string = 4
la $a0, give_string	#load address of string for user to give input
syscall 	#call operating system to perfrom operation
		#specified in $v0 takes arguments from $a0,$a1..		
		
li $v0, 8 	##syscall for reading string
la $a0, input	## load address of space for user's input
li $a1, 20	## 20 characters space for string
syscall		

li $v0, 4	##syscall for printing hello
la $a0, string1
syscall

li $v0, 4	##syscall for printing user's input
la $a0, input
syscall

li $v0, 4	##syscall for printing world
la $a0, string2
syscall
		
li $v0,10 	#terminates program
syscall 

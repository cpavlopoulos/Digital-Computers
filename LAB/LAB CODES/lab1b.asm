
#Hello World! (2*intreger)
.data		## Data declaration section

give_int: .asciiz "Please enter your intreger\n" ##user's input
string: .asciiz "\n Hello, World! "

.text		## Assembly language instructions go in text segment

main:		## Start of code section
li $v0,4	#syscall for print string = 4
la $a0, give_int	#load address of string for user to give input
syscall 	#call operating system to perfrom operation
		#specified in $v0 takes arguments from $a0,$a1..
		
li $v0, 5 	##syscall for reading intreger
syscall		


addi $t0, $v0, 0   	##storing intreger in a temporary registor
sll $t1, $t0, 1		##multiplying by 2 is equal to shifting left by one bit. Also storing multiplied number on $t1 

li $v0, 4	##syscall for printing Hello, World!
la $a0, string
syscall

li $v0, 1	##syscall for printing user's input
addi $a0, $t1, 0 
syscall

		
li $v0,10 	#terminates program
syscall 

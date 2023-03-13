
# HEXCalculator

.data 
input: .asciiz "Please enter your HEX number \n"
result: .asciiz "\nDecimal is: "

.text

main:
li $v0, 4	#syscall for print string = 4
la $a0, input	#load address of string for user to give number
syscall 	#call operating system to perfrom operation
		
		
li $v0, 12 	##syscall for reading char
syscall


move $t0, $v0
j hex

li $v0,10
syscall

#Cases

hex:
addi    $t1, $zero, 65              # set $t1 = 65
slt     $t2, $t0, $t1               # $t2 = $t0 < 65
bne     $t2, $zero, print_dec    
addi    $t0, $t0, -55               # else calculate decimal value of small hex character
j print_res



print_dec:
li $v0, 4	##syscall for printing result
la $a0, result
syscall

li $v0, 11	##syscall for printing user's input
addi $a0, $t0, 0 
syscall   
                           
li $v0, 10
syscall

print_res:
li $v0, 4	##syscall for printing result
la $a0, result
syscall

li $v0, 1	##syscall for printing user's input
addi $a0, $t0, 0 
syscall

li $v0, 10
syscall


 


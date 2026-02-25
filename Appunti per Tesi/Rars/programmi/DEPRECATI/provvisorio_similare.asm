#controlliamo che gli opcode di tutte le istruzioni del programma passato esistano
.globl main

.data:
	scritta: .asciz "fail\n"
	programma: .word 00001111110000010000010100010111
				

	fineProgramma:     #primo indirizzo dopo programma per far terminare il programma...
.text:			   # questa stringa equivale al programma matrice, l'ho convertito in binario (hex)
	main:
		la t0, programma
		la s0,fineProgramma
		li s1,15
		while:
			bgt t0,s0,endWhile
			lw t1, (t0)
			
			andi s3,t1,127
			# controlliamo se l'operazione è di tipo algebrico
			li s2, 51 #0110011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo algebrico immediato
			li s2, 19
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo caricamento
			li s2, 3 
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo store
			li s2, 35
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo branch
			li s2, 99
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo Jump And Link
			li s2, 111 
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo Jump And Link Reg
			li s2, 103
			beq s2,s3,ok
			# controlliamo se l'operazione è Add Upper Imm to PC
			li s2, 23
			beq s2,s3,ok
			# controlliamo sel'operazione è Load Upper Imm
			li s2, 55 
			beq s2,s3,ok
			# controlliamo se l'operazione è una chiamata a sistema
			li s2, 115
			beq s2,s3,ok
			
			j fail
			
			ok:
		
			j while
			
		endWhile:
		j end
		
		
		end:
		
		fail:
		la a0, scritta
 		li a7, 4
 	 	ecall
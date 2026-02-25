#controlliamo che gli opcode di tutte le istruzioni del programma passato esistano
.globl main

.data:
	scritta: .asciz "fail\n"
	programma: .ascii "1703c10f130303009703c10f83838300130e0000b38e7302330e7e0063ccce01830f03003304f40133037300130313006ff09ffe1703c10f1303c3fc9703c10f838343fd130e0000b38e7302330e7e0063ccce01330373001303f3ff830f03003304f4016ff09ffe"
	fineProgramma:     #primo indirizzo dopo programma per far terminare il programma...
.text:			   # questa stringa equivale al programma matrice, l'ho convertito in binario (hex)
	main:
		la t0, programma
		la s0,fineProgramma
		li s1,15
		while:
			bgt t0,s0,endWhile
			lbu t1, (t0)
			addi t1,t1,-48
			ble t1,s1,continua1
			addi t1,t1,-39
			continua1:
			
			lbu t2, 1(t0)
			addi t2,t2,-48
			ble t2,s1,continua2
			addi t2,t2,-39
			continua2:
			
			lbu t3, 2(t0)
			addi t3,t3,-48
			ble t3,s1,continua3
			addi t3,t3,-39
			continua3:

			lbu t4, 3(t0)
			addi t4,t4,-48
			ble t4,s1,continua4
			addi t4,t4,-39
			continua4:
			
			add t6, t6, t1
			slli t6, t6, 4
			add t6, t6, t2
			slli t6, t6, 4
			add t6, t6, t3
			slli t6, t6, 4
			add t6, t6, t4
			
			
			andi s3,t6,63
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
			li s2, 95 
			beq s2,s3,ok
			# controlliamo se l'operazione è Add Upper Imm to PC
			li s2, 31
			beq s2,s3,ok
			# controlliamo sel'operazione è Load Upper Imm
			li s2, 47 
			beq s2,s3,ok
			# controlliamo se l'operazione è una chiamata a sistema
			li s2, 115
			beq s2,s3,ok
			
			j fail
			ok:
		
			addi t0,t0,4
			li t1,0
			li t2,0
			li t3,0
			li t4,0
			li t6,0
			j while
			
		endWhile:
		j end
		
		
		end:
		
		fail:
		la a0, scritta
 		li a7, 4
 	 	ecall
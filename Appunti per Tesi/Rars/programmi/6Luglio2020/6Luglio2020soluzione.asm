.globl main

.data
# M: .half 0, 1, 2,   3, 4, 5,   6, 7, 8
# N: .byte 3
M: .half 1, 2, 3, 4,   
	 5, 6, 7, 8,   
         9, 10, 11, 12,   
	 13, 14, 15, 16
N: .byte 4

separatore: .asciz "\n"

.text
 main:
 	la a0, M
 	lb a1, N
 	addi a2, a1, -1
 	li a4, 2
 	li t3, 0
 	li t6, 0
 	lb t4, N 			#lunhezza lato matrice
 	mul t5, t4, t4 			#cardinalità matrice
 	li t4, 0
 	jal ra, SommaScacchiera		#salto alla funzione e salvo l'indirizzo della riga dopo di questa (21) in t1, tornerò quì per stampare alla fine
 	
 	li a0, 0
 	add a0, a0, s0
 	li a7, 1
 	 	ecall
 	 
 	la a0, separatore
 	li a7, 4
 	 	ecall
 	 	
 	li a0, 0
 	add a0, a0, s1
 	li a7, 1
 	 	ecall
 	 	
 	li a7, 10
 		ecall
 	
 SommaScacchiera:
 	while:  
 		bge t6, t5, fineWhile
 		ble t3, a2, nonincrementariga
 		 
 	incrementariga:
 		addi t4, t4, 1
 		li t3, 0
 		
 	nonincrementariga:
 		rem s10, t3, a4
 		rem s11, t4, a4
 		bnez s11, rigadispari
 		j rigapari
 		
 	rigadispari:
 		bnez s10,colonnadispari
 		j no
 		
 	colonnadispari:
 		lh s9,(a0)
 		add s1,s1,s9
 		addi a0,a0,2
 		addi t6,t6,1
 		addi t3, t3, 1
 		j while
 			
 	rigapari:
 		beqz s10, colonnapari
 		j no
 		
 	colonnapari:
 	 	lh s9,(a0)
 		add s0,s0,s9
 		addi a0,a0,2
 		addi t6,t6,1
 		addi t3, t3, 1
 		j while
 	no:
 		addi a0,a0,2
 		addi t6,t6,1
 		addi t3, t3, 1
 		j while
 		
 	fineWhile:
		jr ra
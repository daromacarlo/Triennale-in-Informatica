.globl main

.data

matrix : .byte 1,2,3,4,    
 	       4,3,2,1, 
 	       1,2,3,4,      
  	       4,3,2,1
N: .byte 4 
.text
	main:
		la t1, matrix	# salvo l'indirizzo del primo elemento della matrice
		lb t2, N	# salvo N
		li t3, 0	# salvo 0
		mul t4, t2, t2	# salvo la lunghezza di matrix
	forLoopPrimaDiagonale:
		add t3,t3,t2
		bgt t3,t4 endForLoopPrimaDiagonale
		lb t6,(t1)
		add s0, s0,t6
		add t1,t1,t2
		addi t1,t1,1
		j forLoopPrimaDiagonale
		
	endForLoopPrimaDiagonale:
	
		la t1, matrix	# salvo l'indirizzo del primo elemento della matrice
		lb t2, N	# salvo N
		li t3, 0	# salvo 0
		mul t4, t2, t2	# salvo la lunghezza di matrix
	forLoopSecondaDiagonale:
		add t3,t3,t2
		bgt t3,t4 endForLoopSecondaDiagonale
		add t1,t1,t2
		addi t1,t1,-1
		lb t6,(t1)
		add s0, s0,t6
		j forLoopSecondaDiagonale
			
endForLoopSecondaDiagonale:

.data
	vettore: .word 11,35,2,17,29,95
	N: 	 .word 6
	
.text
	la s0, vettore
	lw t0, 0(s0)
	lw t1, N
	li t2, 1
  for:  bge t2, t1, endFor
      slli t3,t2,2
       add t3,t3,s0
       	lw t4, (t3)
       ble t4, t0, else
        mv t0, t4 
  else:
  	addi t2,t2,1
  	j for
  endFor:
  
  # viene passato un vettore di word 32 bit e l'algoritmo ritorna il più grande tra i numeri in questo vettore.
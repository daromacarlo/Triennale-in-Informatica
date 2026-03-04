.globl main
.data
	vettore: .word 11,35,2,17,29,95,100,843901,894271
	N: 	 .word 9
	
.text
	main:
	la s0, vettore
	lw t0, 0(s0)
	lw t1, N
	li t2, 1
  for: bge t2, t1, endFor
      slli t3, t2, 2		 #SE HO 1 DEVENTA 4, SE HO 2 DIVENTA 8 ... SE HO 4 DIVENTA 16... MOLTIPLICAZIONE PER 4.
       add t3, t3, s0
       	lw t4,(t3)
       ble t4, t0, else
        mv t0, t4 		#in t0 salvo il valore più grande.
  else:
  	addi t2, t2, 1
  	j for
  endFor:

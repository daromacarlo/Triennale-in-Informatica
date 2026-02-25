.data
	vettore: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	N: 	 .word 20
	# modifica questi valori insime se vuoi sommare valori diversi
.text
	la s0, vettore
	lw t0, 0(s0)
	lw t1, N
	li t2, 1
	li s9, 2
  for: bgt t2, t1, endFor
       add t3, t3, s0
        lw t0, (t3)
        slli t3, t2, 2	# SE HO 1 DEVENTA 4, SE HO 2 DIVENTA 8 ... SE HO 4 DIVENTA 16... MOLTIPLICAZIONE PER 4.
       rem t4, t2, s9	# calcola resto
       ble t4, zero, pari
     dispari:	
       add s4, s4, t0
     	j fine	
     pari:
       add s5, s5, t0
     	 j fine
     fine: 
      addi t2, t2, 1
         j for
  endFor:
  
  # Questo programma somma i numeri in posizione pari e li colloca in s5 il risultato,
  # somma i numeri in posizione dispari e colloca in s4 il risultato. 
  # Modifica i valori in .data se vuoi sommare numeri diversi.
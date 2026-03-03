.globl controllo_word_intere

.data
	testo: .asciz "fail_word_intere\n"

.text
	controllo_word_intere:
	    sub t2, s0, t0 # t2 = lunghezza in byte del programma
	    addi t4, t4, 8
	    rem t3, t2, t4   
	    beqz t3, ok_len    
	
 # se la lunghezza non è multipla di 8
	    j errore_lunghezza
	
	errore_lunghezza:
	    la a0, testo
	    li a7, 4
	    ecall
	    li a7, 10
	    ecall
	    li a0, 1 # Ritorna 1 (errore)
	    
	ok_len:
	    li a0, 0 # Ritorna 0 (successo)
	    jr ra

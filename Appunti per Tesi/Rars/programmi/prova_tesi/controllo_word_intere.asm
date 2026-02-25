.globl controllo_word_intere

.data
	testo: .asciz "fail_word_intere"

.text
	controllo_word_intere:
	    sub t2, s0, t0      # t2 = lunghezza in byte del programma
	    addi t4, t4, 8
	    rem t3, t2, t4     # t3 = t2 % 8
	    beqz t3, ok_len     # se resto == 0 tutto a posto
	
	    # se la lunghezza non è multipla di 8
	    j errore_lunghezza
	
	errore_lunghezza:
	    la a0, testo
	    li a7, 4
	    ecall
	    li a7, 10
	    ecall
	    
	ok_len:
		jr ra
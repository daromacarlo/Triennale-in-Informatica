.globl controllo_word_intere

.section .data
	testo: .asciz "fail_word_intere\n"

.text
	controllo_word_intere:
	    sub t2, s0, t0 # t2 = lunghezza in byte del programma
	    li t4, 8
	    rem t3, t2, t4   
	    beqz t3, ok_len  
	
 # se la lunghezza non è multipla di 8
	    j errore_lunghezza
	
errore_lunghezza:
    li a4, 0x60004000           # Base GPIO ESP32-C3
    li a5, (1 << 8)             # Maschera Pin 8

blink_loop:
    sw a5, 0x0004(a4)           # LED OFF
    jal ra, delay
    sw zero, 0x0004(a4)         # LED ON
    jal ra, delay
    j blink_loop


ok_len:
    li a0, 0                # valido 
    jr ra

delay:
    li a6, 2500000
1:  addi a6, a6, -1
    bnez a6, 1b
    ret
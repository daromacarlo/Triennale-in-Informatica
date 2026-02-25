.globl main

.data:
	testo_ok: .asciz "tutto a posto\n"
	
	# La stringa seguente (programma) è un programma assembly RISC-V convertito in binario (hex)
	programma: .ascii "6704c10f13040400832204001703c10f0323430493031000930c200063487302330e8e0083220e00139e2300b3ee93036356d001330a5a006f00c000b38a5a006f004000938313006ff05ffd"
	
	# Quando realizzerò il vero progetto questa stringa si troverà su un buffer e lo trasferirò su questo buffer tramite interfaccia USB
	
	fineProgramma:     # Primo indirizzo dopo programma per far terminare il programma... DEVO TROVARE UN ALTRO METODO PER FARE CIO' (TERMINARE)
.text:			
	main:
		la t0, programma
		la s0, fineProgramma
		li s1, 15
		
###################################################################################################################################################################################################		
		
		while:
			bge t0, s0, FINEWhile							# IN QUESTO "CICLO WHILE" QUELLO CHE FACCIO E' SCANDIRE 					
			lbu t1, (t0)								# BYTE PER BYTE IL VETTORE IN INGRESSO, SALVANDO OGNI BYTE
			addi t1, t1 -48								# IN UN REGISTRO SPECIFICO, PURTROPPO E' PER ORA L'UNICO MODO
			ble t1, s1, continua1							# CHE MI VIENE IN MENTE PER SALVARE I BYTE CHE VANNO A FORMARE LE WORD
			addi t1, t1, -39							# PERCHE' 'SARS' CREA LA STRINGA DEGLI ESADECIMALI IN MANIERA STRANA.
			continua1:
			
			lbu t2, 1(t0)
			addi t2, t2, -48							# CONVERTO IL CARATTERE ASCII IN INTERO SOTTRAENDO 48 (SE IL CARATTERE E' UN VALORE NUMERICO)
			ble t2, s1, continua2
			addi t2, t2, -39							# SE IL CARATTERE E' UN VALORE NON NUMERICO.
			continua2:
			
			lbu t3, 2(t0)
			addi t3, t3, -48							# RIPETO PER TUTTI I Byte DELLA WORD
			ble t3, s1, continua3
			addi t3, t3, -39
			continua3:

			lbu t4, 3(t0)
			addi t4, t4, -48
			ble t4, s1, continua4
			addi t4, t4, -39
			continua4:
			
			lbu t5, 4(t0)
			addi t5, t5, -48
			ble t5, s1, continua5
			addi t5, t5, -39
			continua5:
			
			lbu s9, 5(t0)
			addi s9, s9, -48
			ble s9, s1, continua6
			addi s9, s9, -39
			continua6:
			
			lbu s10, 6(t0)
			addi s10, s10,-48
			ble s10, s1, continua7
			addi s10, s10, -39
			continua7:
			
			lbu s11, 7(t0)
			addi s11, s11, -48
			ble s11, s1, continua8
			addi s11, s11, -39
			continua8:
			
			add t6, t6, s10
			slli t6, t6, 4
			add t6, t6, s11
			slli t6, t6, 4
			add t6, t6, t5
			slli t6, t6, 4
			add t6, t6, s9
			slli t6, t6, 4
			add t6, t6, t3
			slli t6, t6, 4
			add t6, t6, t4
			slli t6, t6, 4
			add t6, t6, t1
			slli t6, t6, 4
			add t6, t6, t2
				
			li t1,  0		# VUOTO ORA TUTTI I REGISTRI, MI SERVONO PER ALTRE OPERAZIONI
			li t2,  0
			li t3,  0
			li t4,  0
			li t5,  0
			li s9,  0
			li s10, 0
			li s11, 0
			
			# Sicuramente c'è un modo più pulito per fare quello quì sopra
			
			jal ra, controllo_opcode 	# Primo controllo: vedo se tutti gli opcode sono validi. # RARAMENTESONO SONO SBAGLIATI
			
			
							
			li t6, 0
			addi t0, t0, 8			# Vado avanti alla prossima word
			j while				# Torno su
			
###################################################################################################################################################################################################
		
		FINEWhile:				# Se va tutto bene dico che va tutto bene, nel programma della tesi si accenderà un led.
		j tuttoOK
 	 	
 	 	tuttoOK:
 	 	la a0, testo_ok
 		li a7, 4
 	 	ecall
 	 	li a7, 10
 		ecall

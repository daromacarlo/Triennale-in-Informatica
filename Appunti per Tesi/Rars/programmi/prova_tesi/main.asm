.globl main

.data:
	testo_ok: .asciz "tutto a posto\n"
	
	# La stringa seguente (programma) è un programma assembly RISC-V convertito in binario (hex)
	programma: .ascii "1705c10f130505009705c10f838585011386f5ff13072000130e0000930f0000970ec10f838e0e00338fde03930e0000ef00c003130500003305850093081000730000001705c10f1305d5fd9308400073000000130500003305950093081000730000009308a0007300000063d8ef076356c601938e1e00130e0000336dee02b3edee0263940d006f00400263140d006f00c003831c0500b384940113052500938f1f00130e1e006ff05ffc63040d006f00c001831c05003304940113052500938f1f00130e1e006ff05ffa13052500938f1f00130e1e006ff05ff967800000"
       #programma: .ascii "1705c10f130505009705c10f82000130e0000930f0000970ec10f838e0e00338fde03930e0000ef00c003130500003305850093081000730000001705c10f1305d5fd9308400073000000130500003305950093081000730000009308a0007300000063d8ef076356c601938e1e00130e0000336dee02b3edee0263940d006f00400263140d006f00c003831c0500b384940113052500938f1f00130e1e006ff05ffc63040d006f00c001831c05003304940113052500938f1f00130e1e006ff05ffa13052500938f1f00130e1e006ff05ff9678001111111111111111119000" # corrotto
	
	# Quando realizzerò il vero progetto questa stringa si troverà su un buffer e lo trasferirò su questo buffer tramite interfaccia USB
	
	fineProgramma:     # Primo indirizzo dopo programma per far terminare il programma... DEVO TROVARE UN ALTRO METODO PER FARE CIO' (TERMINARE)
.text:			
	main:
		
		la t0, programma
		la s0, fineProgramma
		li s1, 15
		
		jal ra, controllo_word_intere	#Primo controllo, verifico che le word in input siano tutte intere (32bit completi)
		
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
			
			jal ra, controllo_opcode 	# Secondo controllo: vedo se tutti gli opcode sono validi. RARAMENTESONO SONO SBAGLIATI.
			jal ra, controllo_sintassi	# Terzo controllo: vedo se tutte le operazioni sono corrette a livello sintattico.
			
							
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

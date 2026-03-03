#include <soc/gpio_reg.h>

.section .text
.global main_validator

main_validator:

    # L'indirizzo iniziale è in a0
		# L'indirizzo finale è in a1
    mv t0, a0 
    mv s4, a0         
    mv s0, a1
    li s1, 15

###################################################################################################################################################################################################		
		
	 jal ra, controllo_word_intere

		# Uso i registri in maniera inpropria nella prossima sezione (registri "s" per salvare dati temporanei)
		
		while:
			bge t0, s0, tutto_ok				# IN QUESTO "CICLO WHILE" QUELLO CHE FACCIO E' SCANDIRE 					
			lbu t1, (t0)								# BYTE PER BYTE IL VETTORE IN INGRESSO, SALVANDO OGNI BYTE
			addi t1, t1, -48						# IN UN REGISTRO SPECIFICO, PURTROPPO E' PER ORA L'UNICO MODO
			ble t1, s1, continua1				# CHE MI VIENE IN MENTE PER SALVARE I BYTE CHE VANNO A FORMARE LE WORD
			addi t1, t1, -39						# PERCHE' 'SARS' CREA LA STRINGA DEGLI ESADECIMALI IN MANIERA STRANA.
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
			
			# Sicuramente c'è un modo più pulito per fare quello che ho fatto quì sopra
			
			jal ra, controllo_opcode
			jal ra, controllo_sintassi
			jal ra, controllo_memoria
			jal ra, controllo_registro_zero
			jal ra, controllo_registri_critici

			# Controllo di flusso
			
			# Quarto controllo: verifico che  i salti siano tutti validi (un salto è valido se l'indirizzo di destinazione è mutiplo di 4 e se
			# questo ricade tra Programma e fineProgramma)
			# inoltre questo controllo rileva la presenza di loop infiniti.
			
			# cerchiamo l'opcode dell'istruzione
			andi s3,t6,127 
			
			# controlliamo se l'operazione è di tipo branch
			li s2, 99 #opcode 1100011
			
			beq s2, s3, vai_controllo_salti
			
			# controlliamo se l'operazione è di tipo Jump And Link
			li s2, 111 #opcode 1100111
			beq s2, s3, vai_controllo_salti
			
			# controlliamo se l'operazione è di tipo Jump And Link Reg
			li s2, 103 #opcode 1100111
			beq s2, s3, vai_controllo_salti
			
			j NO_vai_controllo_salti
			
			vai_controllo_salti:
			
			jal controllo_salti
			
			NO_vai_controllo_salti:

			li t6, 0
			addi t0, t0, 8			# Vado avanti alla prossima word
			j while				# Torno su
									
# tutto a posto (LED Fisso Acceso)

tutto_ok:
    li a4, 0x60004000
    li a5, (1 << 8)
    sw zero, 0x0004(a4)         # LED ON
    j .                         # Stop quà

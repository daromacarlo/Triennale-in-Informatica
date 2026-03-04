#include <soc/gpio_reg.h>

# Secondo il famoso Halting problem quello che voglio fare in questa sezione è impossibile e in verità lo è... non voglio effettivamente verificare che ci
# sia la presenza di un loop infinito ma bensì creare un watchdog che stoppa il programma se le istruzioni sono troppe, dato che il codice usato in ambito didattico
# è corto e termina entro poche istruzione questo controllo penso vada più che bene se il limite di istruzioni è molto alto.
# Concettualmente non va bene ma fa il suo.

.data
    .align 4
    testo_ok: .asciz "tutto a posto"
    testo_errore: .asciz "successo casotto"
    virtual_regs: .zero 128          # 32 registri da 4 byte ciascuno
    virtual_pc:   .word 0            # Program Counter simulato
    step_count:   .word 0            # Contatore per evitare loop infiniti
    MAX_STEPS:    .word 5000         # Limite massimo di istruzioni eseguibili
    

.text
.globl controllo_dinamico_loop

controllo_dinamico_loop:
    # Setup iniziale
    la t0, virtual_regs
    sw zero, 0(t0)                   # x0 virtuale deve essere sempre 0
    mv s2, a0                        # s2 = inizio buffer (inizio programma) 
    mv s3, a1                        # s3 = fine buffer 
    li s4, 0                         # s4 = contatore step attuali
    la s5, MAX_STEPS
    lw s5, 0(s5)                     # Carica il limite 5000

ciclo_simulazione:
    # Controllo limite passi (Anti-Loop Infinito)

    # Il prossimo ciclo while è simile a quello presente nel main... so che non è il modo più carino ed efficiente per prendere le istruzioni ma è quello più semplice che mi 
    # è venuto in mente. 

		while:
      addi s4, s4, 1
			bge s2, s3, ok			            	
      bgt s4, s5, errore_loop_infinito			  # IN QUESTO "CICLO WHILE" QUELLO CHE FACCIO E' SCANDIRE 	
			lbu t1, (s2)								            # BYTE PER BYTE IL VETTORE IN INGRESSO, SALVANDO OGNI BYTE
			addi t1, t1, -48						            # IN UN REGISTRO SPECIFICO, PURTROPPO E' PER ORA L'UNICO MODO
			ble t1, s1, continua1				            # CHE MI VIENE IN MENTE PER SALVARE I BYTE CHE VANNO A FORMARE LE WORD
			addi t1, t1, -39						            # PERCHE' 'SARS' CREA LA STRINGA DEGLI ESADECIMALI IN MANIERA STRANA.
			continua1:
			
			lbu t2, 1(s2)
			addi t2, t2, -48							# CONVERTO IL CARATTERE ASCII IN INTERO SOTTRAENDO 48 (SE IL CARATTERE E' UN VALORE NUMERICO)
			ble t2, s1, continua2
			addi t2, t2, -39							# SE IL CARATTERE E' UN VALORE NON NUMERICO.
			continua2:
			
			lbu t3, 2(s2)
			addi t3, t3, -48							# RIPETO PER TUTTI I Byte DELLA WORD
			ble t3, s1, continua3
			addi t3, t3, -39
			continua3:

			lbu t4, 3(s2)
			addi t4, t4, -48
			ble t4, s1, continua4
			addi t4, t4, -39
			continua4:
			
			lbu t5, 4(s2)
			addi t5, t5, -48
			ble t5, s1, continua5
			addi t5, t5, -39
			continua5:
			
			lbu s9, 5(s2)
			addi s9, s9, -48
			ble s9, s1, continua6
			addi s9, s9, -39
			continua6:
			
			lbu s10, 6(s2)
			addi s10, s10,-48
			ble s10, s1, continua7
			addi s10, s10, -39
			continua7:
			
			lbu s11, 7(s2)
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
    
    # ora estraggo l'opcode per capire che tipo di operazione è

    andi s3,t6,127

    # controlliamo se l'operazione è di tipo algebrico
    li s2, 51                                                   #opcode 0110011
    beq s2, s3, vai_simula_alg
    
    # controlliamo se l'operazione è di tipo algebrico immediato
    li s2, 19                                                   #opcode 0010011
    beq s2, s3, vai_simula_algimm
    
    # controlliamo se l'operazione è di tipo caricamento
    li s2, 3                                                    #opcode 0000011
    beq s2, s3, vai_simula_load
    
    # controlliamo se l'operazione è di tipo store
    li s2, 35                                                   #opcode 0100011
    beq s2, s3, vai_simula_store
    
    # controlliamo se l'operazione è di tipo branch
    li s2, 99                                                   #opcode 1100011
    beq s2, s3, vai_simula_branch
    
    # controlliamo se l'operazione è di tipo Jump And Link
    li s2, 111                                                  #opcode 1100111
    beq s2, s3, vai_simula_jumplink
    
    # controlliamo se l'operazione è di tipo Jump And Link Reg
    li s2, 103                                                  #opcode 1100111
    beq s2, s3, vai_simula_jumplinkreg
    
    # controlliamo se l'operazione è Add Upper Imm to PC
    li s2, 23                                                   #opcode 0010111
    beq s2, s3, vai_simula_auipc
    
    # controlliamo sel'operazione è Load Upper Imm
    li s2, 55                                                   #opcode 0110111
    beq s2, s3, vai_simula_luimm
    
    # controlliamo se l'operazione è una chiamata a sistema
    #li s2, 115                                                  #opcode 1110011
    #beq s2, s3, vai_simula_callsis

    # Se l'istruzione non è supportata o è la fine
    vai_simula_alg:
      jal simula_alg
      j continua
    vai_simula_algimm:
      jal simula_algimm
      j continua
    vai_simula_load:
      jal simula_load
      j continua
    vai_simula_store:
      #jal simula_store
      #j continua
    vai_simula_branch:
      #jal simula_branch
      #j continua
    vai_simula_jumplink:
      #jal simula_jumplink
      #j continua
    vai_simula_jumplinkreg:
      #jal simula_jumplinkreg
      #j continua
    vai_simula_auipc:
      #jal simula_auipc
      #j continua
    vai_simula_luimm:
      #jal simula_luimm
      #j continua
    vai_simula_callsis:
      #jal simula_callsis
     # j continua

    continua:
    j prossimo_step

prossimo_step:
		addi s2, s2, 8			# Vado avanti alla prossima word
		j while							# Torno su

errore_loop_infinito:
	     	la a0, testo_errore
 		li a7, 4
 	 	ecall
 	 	li a7, 10
 		ecall
    #li a0, 1	# Per dire che non va tutto bene
    #li a4, 0x60004000           # Base GPIO ESP32-C3
    #li a5, (1 << 8)             # Maschera Pin 8

blink_loop:
    #sw a5, 0x0004(a4)           # LED OFF
    #jal ra, delay
    #sw zero, 0x0004(a4)         # LED ON
    #jal ra, delay
    #j blink_loop

        # invece se tutto va bene

ok:
     	 	la a0, testo_ok
 		li a7, 4
 	 	ecall
 	 	li a7, 10
 		ecall

delay:
 #   li a6, 2500000
#1:  addi a6, a6, -1
 #   bnez a6, 1b
  #  ret

.globl controllo_dinamico_loop

.data
    #programma: .ascii "1705c10f130505009705c10f838585011386f5ff13072000130e0000930f0000970ec10f838e0e00338fde03930e0000ef00c003130500003305850093081000730000001705c10f1305d5fd9308400073000000130500003305950093081000730000009308a0007300000063d8ef076356c601938e1e00130e0000336dee02b3edee0263940d006f00400263140d006f00c003831c0500b384940113052500938f1f00130e1e006ff05ffc63040d006f00c001831c05003304940113052500938f1f00130e1e006ff05ffa13052500938f1f00130e1e006ff05ff967800000"
    programma: .ascii "13091900b3042901"
    fineprogramma:
    testo_ok: .asciz "tutto a posto"
    testo_errore: .asciz "successo casotto"
    
    CONTAPASSI:    .word 0
    MAXPASSI:      .word 1024
    REGISTRI_VIRTUALI: .word 128  # 32 registri da 4 byte, inizializzati a 0
    MEMORIA_VIRTUALE: .space 4096  # 4KB di memoria simulata possono bastare per provare progetti didattici.

.text
controllo_dinamico_loop:
la a1, MEMORIA_VIRTUALE
    la a5, REGISTRI_VIRTUALI
    la s2, programma          
    la s3, fineprogramma 
    li s4, 0                  
    
    # Caricamento sicuro di MAXPASSI
  la t0, MAXPASSI
    lw s5, 0(t0)              # Carica il VALORE di MAXPASSI in s5
    li s1, 0                  # Opzionale: usa s1 o direttamente zero
    sb zero, 0(a5)            # Ora dovrebbe funzionare
    sb zero, 1(a5)            # Ora dovrebbe funzionare
    sb zero, 2(a5)            # Ora dovrebbe funzionare
    sb zero, 3(a5)            # Ora dovrebbe funzionare

ciclo_simulazione:
   while:
      li s1, 15
      addi s4, s4, 1
      bge s2, s3, ok			            	
      bgt s4, s5, errore_loop_infinito

      # Lettura e conversione della stringa HEX in t6 (logica originale mantenuta)
      lbu t1, (s2)
      addi t1, t1, -48
      ble t1, s1, continua1 # Usato zero invece di s1 se non inizializzato
      addi t1, t1, -39
    continua1:
      lbu t2, 1(s2)
      addi t2, t2, -48
      ble t2, s1, continua2
      addi t2, t2, -39
    continua2:
      lbu t3, 2(s2)
      addi t3, t3, -48
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
      addi s10, s10, -48
      ble s10, s1, continua7
      addi s10, s10, -39
    continua7:
      lbu s11, 7(s2)
      addi s11, s11, -48
      ble s11, s1, continua8
      addi s11, s11, -39
    continua8:

      # Ricostruzione della word in t6
      li t6, 0
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

      andi s10, t6, 127               # Estraggo Opcode
      
      li s11, 99                     
      beq s10, s11, vai_simula_B
      li s11, 51                      
      beq s10, s11, vai_simula_R
      li s11, 35
      beq s10, s11, vai_simula_S
      li s11,19
      beq s10, s11, vai_simula_I
      li s11,3
      beq s10, s11, vai_simula_I
      li s11,103
      beq s10, s11, vai_simula_I
      li s11,115
      beq s10, s11, vai_simula_I             
     
     j while
vai_simula_B:
	jal ra, simula_B
	j while
vai_simula_R:
	jal ra, simula_R
	j while
vai_simula_S:
	jal ra, simula_S
	j while
vai_simula_I:
	jal ra, simula_I
	j while

errore_loop_infinito:
    la a0, testo_errore
    li a7, 4
    ecall
    li a7, 10
    ecall

ok:
    la a0, testo_ok
    li a7, 4
    ecall
    li a7, 10
    ecall

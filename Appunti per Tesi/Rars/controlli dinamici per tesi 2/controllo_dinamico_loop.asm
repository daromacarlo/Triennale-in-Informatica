.globl controllo_dinamico_loop, ok
.data
    programma: .ascii "130101ff130d40382324a101ef008001130101011308a0009308a0006302180173000000130fcf5db38beb012320710167800000"
    fineprogramma:
    testo_ok: .asciz "tutto a posto"
    testo_errore: .asciz "successo casotto"
    testo_prov: .asciz "successo casotto (prov)"
    
    CONTAPASSI:    .word 0
    MAXPASSI:      .word 4096
    REGISTRI_VIRTUALI: .space 128 
    MEMORIA_VIRTUALE: .space 4096 

.text
controllo_dinamico_loop:
    addi sp, sp, -48        
    sw ra, 44(sp)           
    sw s0, 40(sp)           
    sw s1, 36(sp)
    sw s2, 32(sp)
    sw s3, 28(sp)
    sw s4, 24(sp)
    sw s9, 20(sp)
    sw s10, 16(sp)
    sw s11, 12(sp)


    la s8, MEMORIA_VIRTUALE
    la a5, REGISTRI_VIRTUALI
    la s2, programma           
    la s3, fineprogramma
    li s4, 0                  
  
    la t0, MAXPASSI
    lw s5, 0(t0)     
                          
    sb zero, 0(a5)            
    sb zero, 1(a5)           
    sb zero, 2(a5)            
    sb zero, 3(a5)   
    
    # inizializzo lo stackPointer simulato, lo faccio puntare a fine memoria simulata
    li   t0, 4096
    sw   t0, 8(a5)             

ciclo_simulazione:
   while:
      sw zero, 0(a5)
      li s1, 15
      addi s4, s4, 1
      bge s2, s3, ok			            	
      bgt s4, s5, errore_loop_infinito

      lbu t1, (s2)
      addi t1, t1, -48
      ble t1, s1, continua1 
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
      li s11,111
      beq s10, s11, vai_simula_J  
      li s11, 55  
      beq s10, s11, vai_simula_U 
      li s11, 23
      beq s10, s11, vai_simula_U 
      j esci   # in teoria è impossibile che si arrivi a questa parte del codice vista la strutura del mio codice 

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
vai_simula_J:
	jal ra, simula_J
	j while
vai_simula_U:
	jal ra, simula_U
	j while


errore_loop_infinito:
    li a0, 1                 # inSuccesso
    lw ra, 44(sp)
    lw s0, 40(sp)
    lw s1, 36(sp)
    lw s2, 32(sp)
    lw s3, 28(sp)
    lw s4, 24(sp)
    lw s9, 20(sp)
    lw s10, 16(sp)
    lw s11, 12(sp)
    addi sp, sp, 48
     	 	la a0, testo_errore
 		li a7, 4
 	 	ecall
 	 	li a7, 10
 		ecall

ok:
    li a0, 0                 # Successo
    lw ra, 44(sp)
    lw s0, 40(sp)
    lw s1, 36(sp)
    lw s2, 32(sp)
    lw s3, 28(sp)
    lw s4, 24(sp)
    lw s9, 20(sp)
    lw s10, 16(sp)
    lw s11, 12(sp)
    addi sp, sp, 48
     	 	la a0, testo_ok
 		li a7, 4
 	 	ecall
 	 	li a7, 10
 		ecall

esci:
    li a0, 0                 # inSuccesso
    lw ra, 44(sp)
    lw s0, 40(sp)
    lw s1, 36(sp)
    lw s2, 32(sp)
    lw s3, 28(sp)
    lw s4, 24(sp)
    lw s9, 20(sp)
    lw s10, 16(sp)
    lw s11, 12(sp)
    addi sp, sp, 48
     	 la a0, testo_prov
	 li a7, 4
	  ecall
	  li a7, 10
	 ecall

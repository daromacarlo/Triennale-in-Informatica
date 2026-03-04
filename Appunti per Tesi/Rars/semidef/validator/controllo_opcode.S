.section .text
.global controllo_opcode

controllo_opcode:
    andi s3,t6,127
    # controlliamo se l'operazione è di tipo algebrico
    li s2, 51 #opcode 0110011
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo algebrico immediato
    li s2, 19 #opcode 0010011
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo caricamento
    li s2, 3 #opcode 0000011
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo store
    li s2, 35 #opcode 0100011
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo branch
    li s2, 99 #opcode 1100011
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo Jump And Link
    li s2, 111 #opcode 1100111
    beq s2, s3, ok
    
    # controlliamo se l'operazione è di tipo Jump And Link Reg
    li s2, 103 #opcode 1100111
    beq s2, s3, ok
    
    # controlliamo se l'operazione è Add Upper Imm to PC
    li s2, 23 #opcode 0010111
    beq s2, s3, ok
    
    # controlliamo sel'operazione è Load Upper Imm
    li s2, 55 #opcode 0110111
    beq s2, s3, ok
    
    # controlliamo se l'operazione è una chiamata a sistema
    li s2, 115 #opcode 1110011
    beq s2, s3, ok


# Segnalazione Errore (LED Lampeggia)

errore_lampeggio:
    li a4, 0x60004000           # Base GPIO ESP32-C3
    li a5, (1 << 8)             # Maschera Pin 8

blink_loop:
    sw a5, 0x0004(a4)           # LED OFF
    jal ra, delay
    sw zero, 0x0004(a4)         # LED ON
    jal ra, delay
    j blink_loop


ok:
    li a0, 0                # Opcode valido 
    jr ra

delay:
    li a6, 2500000
1:  addi a6, a6, -1
    bnez a6, 1b
    ret
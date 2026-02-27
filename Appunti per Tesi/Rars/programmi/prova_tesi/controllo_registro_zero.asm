.globl controllo_registro_zero
.data
    avviso_x0: .asciz "Warning: l'istruzione tenta di scrivere in x0. Il risultato sara' perso.\n"

.text
controllo_registro_zero:
    andi t1, t6, 0x7F
    
    # Opcodes che hanno rd e NON sono salti (che usano x0 normalmente)
    li t2, 51       # R-type
    beq t1, t2, verifica_rd
    li t2, 19       # I-type arithmetic
    beq t1, t2, verifica_rd
    li t2, 3        # Load
    beq t1, t2, verifica_rd
    li t2, 55       # LUI
    beq t1, t2, verifica_rd
    li t2, 23       # AUIPC
    beq t1, t2, verifica_rd
    
    # Se è un JAL (111) o JALR (103), di solito x0 è intenzionale (istruzione 'j')
    # quindi non controlliamo rd per evitare falsi positivi.
    
    j fine_check

verifica_rd:
    srli t1, t6, 7
    andi t1, t1, 0x1F
    bnez t1, fine_check     
    
    # Escludiamo il NOP (addi x0, x0, 0)
    li t2, 0x00000013
    beq t6, t2, fine_check
    
    la a0, avviso_x0
    li a7, 4
    ecall

fine_check:
    jr ra
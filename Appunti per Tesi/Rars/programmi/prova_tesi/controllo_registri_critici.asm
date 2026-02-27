.globl controllo_registri_critici

.data
    msg_sp: .asciz "Avviso: Modifica del registro Stack Pointer (sp/x2) rilevata.\n"
    msg_gp: .asciz "Avviso: Modifica del registro Global Pointer (gp/x3) rilevata.\n"
    msg_tp: .asciz "Avviso: Modifica del registro Thread Pointer (tp/x4) rilevata.\n"

.text
controllo_registri_critici:
    # t6 = istruzione a 32 bit
    
    # 1. Filtriamo gli opcode che hanno un registro di destinazione 'rd'
    andi t1, t6, 0x7F
    
    # Opcodes che usano rd: 51(R), 19(I), 3(Load), 103(jalr), 55(LUI), 23(AUIPC), 111(JAL)
    li t2, 51
    beq t1, t2, verifica_rd_critico
    li t2, 19
    beq t1, t2, verifica_rd_critico
    li t2, 3
    beq t1, t2, verifica_rd_critico
    li t2, 103
    beq t1, t2, verifica_rd_critico
    li t2, 55
    beq t1, t2, verifica_rd_critico
    li t2, 23
    beq t1, t2, verifica_rd_critico
    li t2, 111
    beq t1, t2, verifica_rd_critico
    
    j fine_critici

verifica_rd_critico:
    # 2. Estraiamo il campo rd (bit 7-11)
    srli t1, t6, 7
    andi t1, t1, 0x1F
    
    # 3. Controllo se rd è uno dei registri riservati
    li t2, 2                # x2 = sp (Stack Pointer)
    beq t1, t2, warn_sp
    
    li t2, 3                # x3 = gp (Global Pointer)
    beq t1, t2, warn_gp
    
    li t2, 4                # x4 = tp (Thread Pointer)
    beq t1, t2, warn_tp
    
    j fine_critici

warn_sp:
    la a0, msg_sp
    li a7, 4
    ecall
    j fine_critici

warn_gp:
    la a0, msg_gp
    li a7, 4
    ecall
    j fine_critici

warn_tp:
    la a0, msg_tp
    li a7, 4
    ecall

fine_critici:
    jr ra
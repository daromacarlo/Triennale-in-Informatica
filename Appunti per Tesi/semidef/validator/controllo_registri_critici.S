#include <soc/gpio_reg.h>

.section .data
    .align 4
    msg_sp: .asciz "Avviso: Modifica dello Stack Pointer (sp) rilevata.\n"
    msg_gp: .asciz "Avviso: Modifica del Global Pointer (gp) rilevata.\n"
    msg_tp: .asciz "Avviso: Modifica del Thread Pointer (tp) rilevata.\n"

.section .text
.globl controllo_registri_critici

controllo_registri_critici:
    # t6 contiene l'istruzione a 32 bit
    
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
    
    # 3. Controllo se rd è uno dei registri riservati (x2, x3, x4)
    li t2, 2                # x2 = sp (Stack Pointer)
    beq t1, t2, errore_critici_morse
    
    li t2, 3                # x3 = gp (Global Pointer)
    beq t1, t2, errore_critici_morse
    
    li t2, 4                # x4 = tp (Thread Pointer)
    beq t1, t2, errore_critici_morse
    
    j fine_critici

# --- SEGNALAZIONE ERRORE MORSE "RGC" (LENTO E LIMITATO) ---
# R: . - .  |  G: - - .  |  C: - . - .

errore_critici_morse:
    li a4, 0x60004000       # Base GPIO ESP32-C3
    li a5, (1 << 8)         # Maschera Pin 8 (LED)
    li t5, 3                # CONTATORE: 3 ripetizioni

morse_repeat_loop:
    # --- Lettera R (· - ·) ---
    jal ra, dot
    jal ra, dash
    jal ra, dot
    jal ra, letter_space

    # --- Lettera G (- - ·) ---
    jal ra, dash
    jal ra, dash
    jal ra, dot
    jal ra, letter_space

    # --- Lettera C (- · - ·) ---
    jal ra, dash
    jal ra, dot
    jal ra, dash
    jal ra, dot
    
    jal ra, word_space      # Pausa lunga prima della ripetizione
    
    addi t5, t5, -1
    bnez t5, morse_repeat_loop

    sw a5, 0x0004(a4)       # Spegne il LED
    li a0, 1                # Ritorna 1 (errore)
    ret

fine_critici:
    li a0, 0                # Ritorna 0 (successo)
    ret

# --- SUBROUTINE MORSE (RALLENTATE) ---

dot:
    addi sp, sp, -4
    sw ra, 0(sp)
    sw zero, 0x0004(a4)     # LED ON
    li a6, 2500000          
    jal ra, delay
    sw a5, 0x0004(a4)       # LED OFF
    li a6, 2500000          
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

dash:
    addi sp, sp, -4
    sw ra, 0(sp)
    sw zero, 0x0004(a4)     # LED ON
    li a6, 7500000          
    jal ra, delay
    sw a5, 0x0004(a4)       # LED OFF
    li a6, 2500000          
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

letter_space:
    li a6, 7500000
    j delay

word_space:
    li a6, 17500000
    j delay

delay:
1:  addi a6, a6, -1
    bnez a6, 1b
    ret
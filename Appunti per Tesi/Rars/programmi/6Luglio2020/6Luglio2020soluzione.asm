.globl main

.data
# Matrice 4x4 di half-word (2 byte l'una)
M: .half 1, 2, 3, 4,   
         5, 6, 7, 8,   
         9, 10, 11, 12,   
         13, 14, 15, 16
N: .byte 4

msg_pari:    .asciz "Somma celle bianche (pari-pari): "
msg_dispari: .asciz "\nSomma celle nere (dispari-dispari): "

.text
main:
    la a0, M            # Indirizzo base matrice
    lb t4, N            # N (lato matrice)
    mul t5, t4, t4      # N*N (totale elementi)
    
    li t6, 0            # Contatore totale elementi (0 a N*N - 1)
    li s0, 0            # Accumulatore Somma Pari (Bianchi)
    li s1, 0            # Accumulatore Somma Dispari (Neri)
    li a4, 2            # Divisore per il modulo

SommaScacchiera:
    bge t6, t5, fineCiclo
    
    # Calcolo riga e colonna correnti
    # t4 è il lato della matrice (N)
    div t1, t6, t4      # t1 = riga = t6 / N
    rem t2, t6, t4      # t2 = colonna = t6 % N
    
    # Controllo parità riga e colonna
    rem s10, t1, a4     # riga % 2
    rem s11, t2, a4     # colonna % 2
    
    # Logica Scacchiera:
    # Se (riga%2 == colonna%2), la cella appartiene a un set
    # Se (riga%2 != colonna%2), la cella appartiene all'altro
    bne s10, s11, somma_nero
    
somma_bianco:
    lh s9, 0(a0)        # Carica elemento (half)
    add s0, s0, s9      # Aggiungi a somma bianchi
    j avanti
    
somma_nero:
    lh s9, 0(a0)
    add s1, s1, s9      # Aggiungi a somma neri

avanti:
    addi a0, a0, 2      # Prossimo elemento (.half = 2 byte)
    addi t6, t6, 1      # Incrementa contatore
    j SommaScacchiera

fineCiclo:
    # --- Stampa Risultati ---
    
    # Stampa stringa bianchi
    li a7, 4
    la a0, msg_pari
    ecall
    # Stampa valore s0
    li a7, 1
    mv a0, s0
    ecall
    
    # Stampa stringa neri
    li a7, 4
    la a0, msg_dispari
    ecall
    # Stampa valore s1
    li a7, 1
    mv a0, s1
    ecall

    # Exit
    li a7, 10
    ecall
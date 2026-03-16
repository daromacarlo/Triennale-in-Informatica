.data
vettore: .word 11,35,2,17,29,95
N:       .word 6

.text
.globl main

main:

    la s0, vettore      # base address vettore
    lw t1, N            # N

    lw t0, 0(s0)        # max = vettore[0]

    addi t2, zero, 1    # i = 1

for:
    bge t2, t1, endFor  # if i >= N exit

    slli t3, t2, 2      # offset = i*4
    add t3, s0, t3      # address vettore[i]

    lw t4, 0(t3)        # vettore[i]

    ble t4, t0, skip    # se <= max salta
    add t0, t4, zero    # max = vettore[i]

skip:
    addi t2, t2, 1
    jal zero, for

endFor:
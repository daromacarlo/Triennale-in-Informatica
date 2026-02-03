#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Othello, o Reversi (https://en.wikipedia.org/wiki/Reversi), è un gioco da tavolo
giocato da due giocatori su una scacchiera 8x8. Pur avendo regole
relativamente semplici, Othello è un gioco di notevole profondità strategica.
In questo esercizio bisognerà simulare una versione semplificata di othello,
chiamata Dumbothello, in cui un giocatore cattura le pedine dell'avversario in
prossimità della propria pedina appena giocata.
Ecco le regole di Dumbothello:
- ogni giocatore ha un colore associato: bianco, nero;
- il giocatore con il nero è sempre il primo a giocare;
- a turno, ogni giocatore deve mettere una pedina del suo colore in modo tale
  da catturare una o più pedine avversarie;
- catturare una o più pedine avversarie vuol dire che la pedina giocata dal
  giocatore trasforma nel colore del giocatore tutte le pedine avversarie
  direttamente adiacenti, in una qualunque direzione orizzontale, verticale o diagonale;
- dopo aver giocato la propria pedina, le pedine avversarie catturate cambiano
  tutte colore e diventano dello stesso colore del giocatore che ha appena giocato;
- quando il giocatore di turno non può aggiungere ulteriori pedine in gioco,
  la partita termina. Vince il giocatore che ha più pedine sulla scacchiera
  oppure avviene un pareggio se il numero di pedine dei due giocatori è uguale;
- il giocatore di turno non può aggiungere ulteriori pedine se non ha modo di
  catturare nessuna pedina avversaria con nessuna mossa, oppure non ci sono
  più caselle libere sulla scacchiera.

Si deve scrivere una funzione dumbothello(filename) che legga da un file di testo
indicato dalla stringa filename una configurazione della scacchiera e,
seguendo le regole di Dumbothello, generi ricorsivamente l'albero di gioco completo
delle possibili evoluzioni della partita, in modo tale che ogni foglia dell'albero
sia una configurazione da cui non sia più possibile effettuare alcuna mossa.

La configurazione inziale della scacchiera nel file è rappresentata riga per
riga nel file. Una lettera "B" identifica una pedina del nero, una "W" una
pedina del bianco e il carattere "." una casella vuota. Le lettere sono
separate da uno o più caratteri di spaziatura.

In particolare, la funzione dumbothello restituirà una tripla (a, b, c), in cui:
- a è il numero totale di evoluzioni che terminano con una vittoria del nero;
- b è il numero totale di evoluzioni che terminano con una vittoria del bianco;
- c è il numero totale di evoluzioni che terminano con un pari.

Ad esempio, dato in input un file di testo contenente la scacchiera:
. . W W
. . B B
W W W B
W B B W

La funzione ritornerà la tripla:
(2, 16, 0)

ATTENZIONE: la funzione dumbothello o qualche altra 
funzione usata per la soluzione deve essere ricorsiva.

'''


def mossapossibile(matrice, colore):
    listamosse=[]

    mosse=[(0,1),(1,0),(0,-1),(-1,0),(1,1),(-1,-1),(1,-1),(-1,1)]
    
    for y in range(len(matrice)):
        for x in range(len(matrice[0])):
            if matrice[y][x]=='.':
                for tupla in mosse:
                    y_traslato=(y+tupla[0])
                    x_traslato=(x+tupla[1])
                    try:
                        if matrice[y_traslato][x_traslato]!='.' and matrice[y_traslato][x_traslato]!= colore:
                            if y_traslato>=0 and x_traslato>=0:
                                listamosse+=[(y,x)]
                                break
                    except:
                        pass
            else:
                continue               
    return listamosse

def applicamossa(matrice, colore):
    listamosse=mossapossibile(matrice, colore)
    listamatrici=[]
    
    cambiacolore=[(0,1),(1,0),(0,-1),(-1,0),(1,1),(-1,-1),(1,-1),(-1,1)]
    
    for mossa in listamosse:
        newmatrice=list(map(list.copy, matrice))
        newmatrice[mossa[0]][mossa[1]]=colore
        for tupla in cambiacolore:
            y_traslato=(mossa[0]+tupla[0])
            x_traslato=(mossa[1]+tupla[1])
            try:
                if matrice[y_traslato][x_traslato]!='.':
                    if y_traslato>=0 and x_traslato>=0:
                        newmatrice[y_traslato][x_traslato]=colore
            except:
                pass
        listamatrici+=[newmatrice]
    return listamatrici    
          
def ricorsione(mossaapplicata, colore, lista):
    colore=chigioca(colore)
    for matrice in mossaapplicata:
        if applicamossa(matrice,colore)==[]:
            chivince(matrice, lista)
        else:
            ricorsione(applicamossa(matrice,colore),colore,lista)
    return tuple(lista)
    
def chivince(matrice, lista):
    contatoreB=0
    contatoreW=0
    for y in range(len(matrice)):
        for x in range(len(matrice[0])):
            if matrice[y][x]=='B':
                contatoreB+=1
            if matrice[y][x]=='W':
                contatoreW+=1
    if contatoreW>contatoreB:
        (lista[1])+=1
    elif contatoreW==contatoreB:
        (lista[2])+=1
    elif contatoreW<contatoreB:
        (lista[0])+=1

def chigioca(colore):
    if colore == 'W':
        colore = 'B'
    elif colore == 'B':
        colore='W'
    return colore

def dumbothello(filename : str) -> tuple[int,int,int] :
    matrice=[]
    colore='B'
    lista=[0,0,0]
    with open(filename) as F:
        righe = F.readlines()
        for riga in righe: 
            rigasplittata=(riga.split())
            matrice+=[rigasplittata]
    return ricorsione(applicamossa(matrice,colore), colore, lista)
       
    
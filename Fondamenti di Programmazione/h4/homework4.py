#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
Obiettivo dello homework è leggere alcune stringhe contenute in una serie di
file e generare una nuova stringa a partire da tutte le stringhe lette.
Le stringhe da leggere sono contenute in diversi file, collegati fra loro a
formare una catena chiusa. Infatti, la prima stringa di ogni file è il nome di
un altro file che appartiene alla catena: partendo da un qualsiasi file e
seguendo la catena, si ritorna sempre nel file di partenza.

Esempio: il contenuto di "A.txt" inizia con "B.txt", il file "B.txt", inizia
con "C.txt" e il file "C.txt" inizia con "A.txt", formando la catena
"A.txt"-"B.txt"-"C.txt".

Oltre alla stringa con il nome del file successivo, ogni file contiene anche
altre stringhe separate da spazi, tabulazioni o caratteri di a capo. La
funzione deve leggere tutte le stringhe presenti nei file della catena e
costruire la stringa che si ottiene concatenando i caratteri con la più alta
frequenza in ogni posizione. Ovvero, nella stringa da costruire, alla
posizione p ci sarà il carattere che ha frequenza massima nella posizione p di
ogni stringa letta dai file. Nel caso in cui ci fossero più caratteri con
la stessa frequenza, si consideri l'ordine alfabetico.
La stringa da costruire ha lunghezza pari alla
lunghezza massima delle stringhe lette dai file.

Quindi, si deve scrivere una funzione che prende in ingresso una stringa A 
che rappresenta il nome di un file e restituisce una stringa.
La funzione deve costruire la stringa secondo le indicazioni illustrate sopra
e ritornare le stringa così costruita.
Esempio: se il contenuto dei tre file A.txt, B.txt e C.txt nella directory
test01 è il seguente

test01/A.txt          test01/B.txt         test01/C.txt                                                                 
-------------------------------------------------------------------------------
test01/B.txt          test01/C.txt         test01/A.txt
house                 home                 kite                                                                       
garden                park                 hello                                                                       
kitchen               affair               portrait                                                                     
balloon                                    angel                                                                                                                                               
                                           surfing                                                               

la funzione most_frequent_chars("test01/A.txt") dovrà restituire la stringa
"hareennt".
'''

def load_file(filename:str): 
     with open(filename, encoding='utf8') as f:
         return f.read()

def most_frequent_chars(filename: str) -> str:
    wordlist=[]
    file=(load_file(filename)).split()
    wordlist+=(file[1:])
    while(file[0])!= filename:
        file=(load_file(file[0])).split()
        wordlist+=(file[1:])
    wordlistsorted=sorted(wordlist, key=len)
    List=[]
    for i in range(len(wordlistsorted[-1])):
        dic=dict()
        for word in wordlist:
            if i >= len(word):
                continue
            else:
                if word[i] in dic:
                    dic[word[i]]+=1 
                else:
                    dic[word[i]]=1   
        d={k: v for k, v in sorted(dic.items())}
        List.append(d)
    stringa=''
    for dictionary in List:
        x = max(dictionary, key=dictionary.get)
        stringa+=x
    return stringa
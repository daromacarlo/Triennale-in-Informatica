'''
Siete stati appena ingaggiati in una software house di videogiochi e
dovete renderizzare su immagine il giochino dello snake salvando
l'immagine finale del percorso dello snake e restituendo la lunghezza
dello snake.
Si implementi la funzione generate_snake che prende in ingresso un
percorso di un file immagine, che e' l'immagine di partenza
"start_img" che puo' contenere pixel di background neri, pixel di
ostacolo per lo snake di colore rosso e infine del cibo di colore
arancione. Lo snake deve essere disegnato di verde. Inoltre bisogna
disegnare in grigio la scia che lo snake lascia sul proprio
cammino. La funzione inoltre prende in ingresso una posizione iniziale
dello snake, "position" come una lista di due interi X e Y. I comandi
del giocatore su come muovere lo snake nel videogioco sono disponibili
in una stringa "commands".  La funzione deve salvare l'immagine finale
del cammino dello snake al percorso "out_img", che e' passato come
ultimo argomento di ingresso alla funzione. Inoltre la funzione deve
restituire la lunghezza dello snake al termine del gioco.

Ciascun comando in "commands" corrisponde ad un segno cardinale ed e
seguito da uno spazio. I segni cardinali possibli sono:

| NW | N | NE |
| W  |   | E  |
| SW | S | SE |

che corrispondono a movimenti dello snake di un pixel come:

| alto-sinistra  | alto  | alto-destra  |
| sinistra       |       | destra       |
| basso-sinistra | basso | basso-destra |

Lo snake si muove in base ai comandi passati e nel caso in cui
mangia del cibo si allunga di un pixel.

Lo snake puo' passare da parte a parte dell'immagine sia in
orizzontale che in verticale. Il gioco termina quando sono finiti i
comandi oppure lo snake muore. Lo snake muore quando:
- colpisce un ostacolo
- colpisce se stesso quindi non puo' passare sopra se stesso
- si incrocia in diagonale in qualsiasi modo. Ad esempio, un percorso
  1->2->3-4 come quello sotto a sinistra non e' lecito mentre quello a
  destra sotto va bene.

  NOT OK - diagonal cross        OK - not a diagonal cross
       | 4 | 2 |                    | 1 | 2 |
       | 1 | 3 |                    | 4 | 3 |

Ad esempio considerando il caso di test data/input_00.json
lo snake parte da "position": [12, 13] e riceve i comandi
 "commands": "S W S W W W S W W N N W N N N N N W N" 
genera l'immagine in visibile in data/expected_end_00.png
e restituisce 5 in quanto lo snake e' lungo 5 pixels alla
fine del gioco.

NOTA: analizzate le immagini per avere i valori esatti dei colore da usare.

NOTA: non importate o usate altre librerie
'''

import images
 
def draw_pixel(start_img, x, y, colore):        
    start_img[y][x] = colore    
    return(start_img)


def pixel_control(start_img, position, Verde, Rosso):
    if start_img[position[1]][position[0]] == Verde or start_img[position[1]][position[0]] == Rosso:
        return False
    else:
        return True


def controllo_diagonali(start_img, position_vecchia, position, command, Larghezza, Altezza, Movimenti, Verde):
    for key,value in Movimenti.items():
        if command==key:
            if start_img[position[1]][position_vecchia[0]]==Verde and start_img[position_vecchia[1]][position[0]]==Verde:
                return False
            else:
                return True
        

def effetto_pacman(value, position, Altezza, Larghezza):
     if position[0]+value[0]>Larghezza-1:
         position[0]=0
     elif position[0]+value[0]<0:
         position[0]=Larghezza-1
     else:
         position[0]+=value[0]
     if position[1]+value[1]>Altezza-1:
         position[1]=0
     elif position[1]+value[1]<0:
         position[1]=Altezza-1
     else:
         position[1]+=value[1]
     return position
    
    
def hai_mangiato_bellodenonna(start_img, Posizione_nuova , Posizione_vecchia , Verde, Arancione):
    if  start_img[Posizione_nuova[1]][Posizione_nuova[0]] == Arancione:
        return True
        draw_pixel(start_img,Posizione_nuova[0],Posizione_nuova[1],Verde)
        draw_pixel(start_img,Posizione_vecchia[0],Posizione_vecchia[1],Verde)
    else:
        return False
    

def generate_snake(start_img:str, position:list[int, int],
                   commands:str, out_img:str) -> int:
    
    start_img= images.load(start_img)
    commands=commands.split()
    Larghezza=(len(start_img[0]))
    Altezza=(len(start_img))
    
    Movimenti={'NW':[-1,-1],'N':[0,-1], 'NE':[+1,-1], 
                'W':[-1,0], 'E':[+1,0],
                'SW':[-1,+1], 'S':[0,+1], 'SE':[+1,+1]}
    
    Rosso     = (255,   0,   0)
    Verde     = (  0, 255,   0)
    Grigio    = (128, 128, 128)
    Arancione = (255, 128,   0)
    
    listaposizioni=[position]
    Lunghezza_serpente=1

    for command in commands:
        
        Posizione_vecchia=position[::]
        
        for key,value in Movimenti.items():
            if command==key:        
                position=effetto_pacman(value, position, Altezza, Larghezza)
        
        diagonali=controllo_diagonali(start_img , Posizione_vecchia, position, command, Larghezza, Altezza, Movimenti, Verde)
        
        Posizione_nuova=position[::]
        
        ceck=pixel_control(start_img, Posizione_nuova, Rosso, Verde)
        
        listaposizioni.append(Posizione_vecchia)
        
        cibo=hai_mangiato_bellodenonna(start_img, Posizione_nuova, Posizione_vecchia, Verde, Arancione)
        
        if ceck == False or diagonali== False:
            break
        else:
            draw_pixel(start_img,Posizione_nuova[0],Posizione_nuova[1],Verde)
            if cibo==True:
                Lunghezza_serpente+=1
            else:
                draw_pixel(start_img,Posizione_nuova[0],Posizione_nuova[1],Verde)
                draw_pixel(start_img,((listaposizioni[-Lunghezza_serpente])[0]),((listaposizioni[-Lunghezza_serpente])[1]),Grigio) 
   
    images.save(start_img, out_img)
    return Lunghezza_serpente

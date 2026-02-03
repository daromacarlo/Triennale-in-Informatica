Esempio [2-colorazione, bipartizione]
Consideriamo il seguente problema. Dobbiamo preparare il calendario degli esami per un corso di laurea.
Conosciamo per ognuno dei k studenti quali tra gli n esami vuole sostenere. Ci sono solamente due settimane a
disposizione e ognuno degli n esami deve essere messo in una sola delle due settimane. Vogliamo, se possibile,
trovare un calendario che eviti che qualche studente debba sostenere due o più esami nella stessa settimana.
Come possiamo risolvere il problema?

IDEA: 
	rappresenterei gli esami di una singola persona come componente fortemente connessa di un grafo, e "colorerei" gli esami (i nodi della componente fortemente connessa)che vuole preparare con 2 colori diversi che rappresentano settima1 e settimana2.

def main(g, V(g), E(g))          //g: grafo, E(g): archi del grafo, V(g): vertici del grafo
	studente[0...0]
	settimanaUno[]
	settimanaDue[]
	counter = 0
	for v in V(g){
		if studente[v] == 0{
			ricercaComponenteEColora(v, counter++, settimanaUno, SettimanaDue, parità = 0)
		}
	}
	return settimanaUno, SettimanaDue

def ricercaComponenteEColora(v, counter, settimanaUno, settimanaDue, parità)
	studente[v] = counter
	for w in v.addiacenti
		if parità == 0{ 
			settimanaUno += [v]
			pari = 1
		}
		else{
			settimanaDue += [v]
			parità = 0
		}
		ricercaComponenteEColora(w, counter, settimanaUno, SettimanaDue, parità)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Esercizio [ordine]
Gli ingegneri che progettano una fabbrica di automobili hanno suddiviso il processo di produzione delle automobili
in n lavorazioni. Alcune di queste possono essere effettuate in parallelo (ad es. l'assemblaggio del motore e la
saldatura della scocca), ma altre necessitano prima di poter essere iniziate che altre lavorazioni siano state ultimate
(ad es. non si può montare la carrozzeria prima di aver preparato il telaio). Per ogni lavorazione L, gli ingegneri
hanno specificato una lista (eventualmente vuota) di lavorazioni che devono essere ultimate prima che L possa
essere iniziata. Vogliamo sapere se le specifiche date sono fattibili, cioè, esiste almeno un ordine di esecuzione
delle lavorazioni che rispetta i vincoli dati dalle liste? E poi, se è così, come possiamo trovare un tale ordine?

1) soluzione senza conoscere la teoria

IDEA (per il primo punto):
	dobbiamo verificare che non ci siano cicli.

def aciclico(g, V(g), E(g)){
	for v in V(g){
		stack = [v]
		stack. push(v)
		while stack != NULL{
			cur = v
			vis = []
			while cur.uscenti() != NULL{
				w = cur.uscenti[0]
				delete(cur.uscenti[0])
				if w not in vis{
					vis += [w]
					stack.push(w)
				}
				else{
					return FALSE
				}
			}
			cur = stack.pop()
		}
	}
	return TRUE
}

- il costo coumputazionale è molto alto ma fa il suo dovere.

IDEA (per il secondo punto)
	cerco un ordine topologico.ù

def(g, V(g), E(g)){
	if aciclico(g, V(g), E(g)) == TRUE{
		return ordinetopologico(g, V(g), E(g))
	}
	else: return -1
}

def ordinetopologico(g, V(g), E(g)){
	ordine = []
	while V(g) is not empty{
		if x.entranti == []
		ordine += [x]
		remove(x)
	}
	return ordine
}

- il costo computazioneale di questo algoritmo è molto alto, è infatti O(n(n+m)) (dove n sono i nodi e m gli archi del grafo)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Esercizio [ordine]
Gli ingegneri che progettano una fabbrica di automobili hanno suddiviso il processo di produzione delle automobili
in n lavorazioni. Alcune di queste possono essere effettuate in parallelo (ad es. l'assemblaggio del motore e la
saldatura della scocca), ma altre necessitano prima di poter essere iniziate che altre lavorazioni siano state ultimate
(ad es. non si può montare la carrozzeria prima di aver preparato il telaio). Per ogni lavorazione L, gli ingegneri
hanno specificato una lista (eventualmente vuota) di lavorazioni che devono essere ultimate prima che L possa
essere iniziata. Vogliamo sapere se le specifiche date sono fattibili, cioè, esiste almeno un ordine di esecuzione
delle lavorazioni che rispetta i vincoli dati dalle liste? E poi, se è così, come possiamo trovare un tale ordine?

2) soluzione conoscendo la teoria

1)	def search_cycle(G,v,u,P)
		P[v] = -u
		for w in v.adiacente{
			if P[w] == 0{
				z = search_cycle(G,w,v,P)
				if z != 0{
					P[v] = -(P[v])
				}
				return z
			}
			else{
				P[w] = 0
				P[v] = u
			}
			return v
		}
		P[v] = u
		return 0

		//(tempo lineare)

	def check(G,v,u,P)
		search_cycle(G,v,u,P)
		L = empty list
		if 0 in empty list -> return true
		else -> return false
		// ritorna false se non ci sono cicli, true se ci sono.


		//(tempo lineare)


		//(tutto l'algoritmo ha costo lineare)

2)	def linear_topological_order(G,v,u,P)
		if search_cycle(G,v,u,P) == 0{
			vis = [0...0]
			L = "empty list"
			for v in (V(G)){
				aux(v,vis,L)
			}
			return L
		}
		else 
		{
		 perror("ci sono dei cicli")
		 return -1
		}

	def aux(v,vis,L)
		vis[v] = 1
		for w adiacente di v{
			if vis(w) == 0{
				aux(w,vis,L)
			}
		}
		L.insert(v)

		//(complessità O(n+m))
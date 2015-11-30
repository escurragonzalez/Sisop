BEGIN{
	signos[")"]  = "("
	signos["]"]  = "["
	signos["}"]  = "{"
	signos["?"]  = "¿"
	signos["!"]  = "¡"
	signos["\""] = "\""
	signos["'"]  = "'"

	#pila contiene los signos de puntuacion que se van encontrando
	elementos = 0 #cantidad de elementos en la pila

	#Verifica si hay o no una comilla en la pila, se opto por esta opcion debido a que no
	#se podia distinguir si una comilla es de apertura o cierre
	hayComilla = 0 
}

{
	#recorro cada letra de cada linea
	for (i=1; i <= length($0); i++){

		#guardo un solo caracter para evaluarlo
		caracter = substr($0, i, 1)

		#si el caracter es algun signo de apertura
		if(caracter == "(" || caracter == "[" || caracter == "{" || caracter == "¿" || 
			caracter == "¡"){
			#guardo el caracter en la pila junto al numero de linea
			pila[++elementos] = caracter "|" NR
		}

		#si el caracter es algun signo de cierre
		else if(caracter == ")" || caracter == "]" || caracter == "}" || caracter == "?" || 
			caracter == "!"){

			#verifico que el caracter de cierre coincida con su caracter de apertura
			split(pila[elementos--], array, "|")
			if(signos[caracter] != array[1]){
				printf ("%-11s %-30s %d\n","PUNTUACION",array[1] caracter,NR)
			}
		}

		#si el caracter es alguna comilla
		else if(caracter == "\"" || caracter == "'"){
			
			#si hay alguna comilla en la pila
			if(hayComilla > 0){

				#verifico que coincida con otra comilla de apertura
				if(signos[caracter] != pila[elementos--])
					printf ("%-11s %-30s %d\n","PUNTUACION",pila[elementos] caracter,NR)
				hayComilla--
			}

			#si no hay comillas la agrego a la pila
			else{
				pila[++elementos] = caracter
				hayComilla++
			}
		}
	}
}
END{
	#si hay caracteres de mas
	if(elementos > 0){
		while(elementos > 0){
			split (pila[elementos--], array, "|")
			printf ("%-11s %-30s %d\n","PUNTUACION",array[1],array[2])
		}
	}	
}
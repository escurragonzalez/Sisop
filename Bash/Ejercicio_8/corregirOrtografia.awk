#Este script recibe de parametro "pal" que es una palabra que no se encuentra en el
#diccionario.
{
	i=1
	#Recorro toda la linea del archivo original
	while(i<=NF ){
		#si una palabra del texto original coincide con "pal" entonces imprimo la linea
		#con el tipo de error
		if(tolower($i) == pal){
			printf ("%-11s %-30s %d\n","ORTOGRAFIA",pal,NR)
			i=NF
		}
		i++
	}
}
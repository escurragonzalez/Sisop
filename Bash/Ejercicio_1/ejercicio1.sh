################################################################################
# PROGRAM-ID.  ejercicio1				                                           #
# OBJETIVO DEL PROGRAMA: Cuenta cantidad de filas, caracteres de un archivo    #
# TIPO DE PROGRAMA: .sh                                                        #
# ARCHIVOS DE ENTRADA : un archivo con texto                                   #
# PARAMENTROS : Un caracter que define que tiene que contar el programa        #
# ALUMNOS :                                                                    #                                                                              #
#           -Bogado, Sebastian                                                 #
#           -Camacho, Manfred                                                  #
#           -Gonzalez, Gustavo                                                 #
#           -Rey, Juan Cruz                                                    #
#           -Valenzuela, Santiago                                              #
# Ejemplo Ej.:                                                                 #
# $ .\ejercicio1.sh miArchivo L                                                #
################################################################################

#!/bin/bash
ErrorS()
{
echo "Error. La sintaxis del script es la siguiente:"
echo "Cantidad de lineas: $0 nombre_archivo L"
echo "Cantidad de caracteres: $0 nombre_archivo C"
echo "Largo de la linea mas larga: $0 nombre_archivo M"
}
ErrorP()
{
echo "Error. nombre_archivo no existe o no tiene permiso de lectura."
}
if test $# -lt 2; then #Si la cantidad de parametros es menor a 2
	ErrorS	#Llama a la funcion ErrorS

elif ! test -r $1; then #Si el archivo no tiene permiso de lectura o no existe
	ErrorP #Llama a la funcion de ErrorP
elif test -f $1 && (test $2 = "L" || test $2 = "C" || test $2 = "M"); then
#Si es un archivo regular y el caracter es L, C o M
	if test $2 = "L"; then #Si el segundo parametro es L
		res=`wc -l < $1` #Cuenta la cantidad de lineas del archivo
		echo "La cantidad de filas del archivo es de: $res"
	elif test $2 = "C"; then #Si el segundo parametro es C
		res=`wc -m < $1` #Cuenta la cantidad de caracteres del archivo
		echo "La cantidad de caracteres del archivo es de: $res"
	elif test $2 = "M"; then
		res=`wc -L < $1` #Imprime el tamaño de la fila mas larga
		echo "El tamaño de la fila mas larga del archivo es de: $res"
	fi
else #Si no es un archivo regular o el caracter no es L, C o M
	ErrorS #Llama a la funcion ErrorS
fi

#	a) ¿Cuál es el objetivo de este script?
#		Dependiendo de los parametros Cuenta la cantidad de lineas, la cantidad 
#		de caracteres o muestra el largo de la linea mas larga .
#
#	b) ¿Qué parámetros recibe?
#		El programa recibe por parametro la ruta de un archivo y un caracter que 
#		especifica si se cuentan lineas (L), caracteres (C) o mostrar el largo de
#		de la linea mas larga (M).
#
#	e) ¿Qué información brinda la variable “$#”? ¿Qué otras variables similares 
#		conoce? Explíquelas.
#		$# -> indica la cantidad de parametros que recibio el script.
#		$0 -> Contiene el nombre del script(Nombre del archivo).
#		$1 - $9 -> Representan a los parametros que el script recibe en ese orden.
#		$? -> Contiene el estado del ultimo comando ejecutado.
#		$* -> Contiene todos los vaores de parametros separados por un espacio.
#
#	f) Explique las diferencias entre los distintos tipos de comillas que se 
#		pueden utilizar en Shell scripts.
#		Comilla dobles(").- O comillas debiles, logran que el espacio deje de ser
#			un caracter especial, pero el resto sigue siendo especial.
#		Comillas simples(').- O comillas fuertes, hacen que todos los caracteres
#			(excepto la misma comilla simple) dejen de ser especiales y los toma
#			como una cadena cualquiera.
#		Comillas invertidas(`).- Ejecutan el comando al que encierran.


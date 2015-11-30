#!/bin/bash
# Indica el shell con que se debe ejecutar el script

########################################################################
# PROGRAM-ID.  ejercicio6.sh					                       #
# OBJETIVO DEL PROGRAMA: Generar un listado de informacion de una base #
# de datos de personas			                                       #
# TIPO DE PROGRAMA: .sh                                                #
# ARCHIVOS DE ENTRADA: BaseDeDatos.file, acronimos.file                #
# ARCHIVOS DE SALIDA : salisda.txt			                           #
# ALUMNOS : -Bogado, Sebastian                                         #
#           -Camacho, Manfred					                       #
#           -Gonzalez, Gustavo                                         #
#           -Rey, Juan Cruz                                            #
#           -Valenzuela, Santiago 				                       #
# COMENTARIOS: N/A						                               #
# EjemploEj.:.	./ejercicio6.sh ./BaseDeDatos.file ./Acronimos.file    #
########################################################################
#----------------------------------Funciones----------------------------------------------
ModoDeUso()
{
	echo
	echo "Uso:" $0 " BASEDEDATOS ACRONIMOS"  
	echo             	
	echo "Opciones:"
	echo "	-?, -h, -help		muestra esta ayuda y sale"
	echo
	echo "Ejemplos:"
	echo
	echo $0 " ./bd/personas ./acronimos"
	echo 
	echo $0 " -?"
	echo
	exit 1
} 

Error()
{
	echo "Error - Error en la cantidad de parametros."
	ModoDeUso
}

obtienePath() 
{
	pathCompletoPersonas=$1
	directorioPersonas=`dirname $pathCompletoPersonas`

	pathCompletoAcronimos=$2
	directorioAcronimos=`dirname $pathCompletoAcronimos`

}

DirectorioInvalido() 
{
	echo "Directorio a procesar inexistente"
	ModoDeUso
}

FicheroInvalido() 
{
	echo "Fichero a procesar inexistente"
	ModoDeUso
}


############################### Programa Principal #######################################

if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
	ModoDeUso #Ayuda muestra modo de uso
fi

#verificamos si la cantidad de argumentos es distinta de 2
if [ $# -ne 2 ]; then 
	Error #Error cantidad de parametros
fi

obtienePath $1 $2

######
if [ ! -d $directorioPersonas -o ! -d $directorioAcronimos ]; then 
	DirectorioInvalido
fi

if [ ! -w $directorioPersonas -o ! -w $directorioAcronimos ]; then
	echo "No posee permisos en el directorio" 
	exit
fi

if [ ! -f $pathCompletoPersonas -o ! -f $pathCompletoAcronimos ]; then
	FicheroInvalido #Si no es un archivo regular
fi

if [ ! -r $pathCompletoPersonas -o ! -r $pathCompletoAcronimos ]; then
	echo "No se posee permiso de lectura sobre alguno de los archivos"
	exit 1
fi

if [ ! -s $pathCompletoPersonas -o ! -s $pathCompletoAcronimos ]; then
	echo "El archivo esta vacio"
	exit 1
fi

#Creo tres archivos temporales con un nombre aleaorio
temp1=$(mktemp)
temp2=$(mktemp)
temp3=$(mktemp)

#ordeno el archivo personas por nombre, luego con personas.awk valido y agrupo a los 
#registros de acuerdo al pais de nacimiento y guardo el resultado en el archivo temp1

sort $pathCompletoPersonas | awk -f personas.awk -v temp1=$temp1 

#Elimino el pipe final del archivo temp1 que fue agregado en personas.awk y grabo en temp3
sed 's/|$//' $temp1 > $temp3

#valido los acronimos
awk -f acronimos.awk $pathCompletoAcronimos 

#Elimino espacios en blanco iniciales y finales.
#Elimino las ciudades (registros que empiezan por C) y para los paises elimino el primer
#campo de los registros (P). Finalmente reemplazo los espacios por el separador "|" y 
#grabo los resultados en el archivo temp2
sed 's/^[ \t]*//;s/[ \t]*$//;/^C/d;s/^P //;s/ /|/' $pathCompletoAcronimos > $temp2 

#Seteo mi nuevo separador interno de campos para usarlos con read
IFS="|"

#Leo temp2 mientras tenga registros (cada linea contiene dos campos acronimo|nombre)
while read acronimo nombre
do
	#Reemplazo el acronimo por su nombre en temp3
	sed -i "s/$acronimo/$nombre/" $temp3
done < $temp2

#ordeno temp3 por el pais y muestro por pantalla
sort $temp3 | awk -f grabar.awk

#Remuevo los archivos temporales
rm $temp1
rm $temp2
rm $temp3
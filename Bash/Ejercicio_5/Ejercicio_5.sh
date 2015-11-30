#!/bin/bash
# Indica el shell con que se debe ejecutar el script

########################################################################
# PROGRAM-ID.  ejercicio5.sh					       #
# OBJETIVO DEL PROGRAMA: filtre los productos que comienzan con	       # 
# una letra determinada.			                       #
# TIPO DE PROGRAMA: .sh                                                #
# ARCHIVOS DE ENTRADA: listaProductos                                  #
# ARCHIVOS DE SALIDA : N/A			                       #
# ALUMNOS : -Bogado, Sebastian                                         #
#           -Camacho, Manfred					       #
#           -Gonzalez, Gustavo                                         #
#           -Rey, Juan Cruz                                            #
#           -Valenzuela, Santiago 				       #
# COMENTARIOS: N/A						       #
# EjemploEj.:.	./listaProductos productos b			       #
########################################################################
#----------------------------------Funciones-----------------------------------------------
ModoDeUso()
{
	echo "Uso:" $0 "./listaProductos productos b"        
	echo "Uso:" $0 "./listaProductos productos b g"        	
	echo "Con -h o -? o -help esta ayuda"
	exit 1
} 

Error()
{
	echo "Error - Error en la cantidad de parametros."
	ModoDeUso
}

obtienePath() 
{
	pathCompleto=$1
	archivo=`basename $pathCompleto`
	directorio=`dirname $pathCompleto`
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

leerArchivo(){
	while read linea
	do
		echo $linea
	done <"$1"
}

############################### Programa Principal ########################################

#verificamos si la cantidad de argumentos es distinta de 1

if [ $# -lt 1 -o $# -gt 4 ]; then 
	Error #Error cantidad de parametros
fi

if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
	ModoDeUso #Ayuda muestra modo de uso
fi

obtienePath $1

if [ ! -d $directorio ]; then 
	DirectorioInvalido
fi

if [ ! -w $directorio ]; then
	echo "No posee permisos en el directorio: $directorio"
	exit
fi

if [ ! -f $1 ]; then
	FicheroInvalido #Si no es un archivo regular
fi

if [ ! -r $1 ]; then
	echo "No se poseen los permisos necesarios sobre el archivo $archivo para continuar con la ejecucion del programa"
	exit 1
fi

if [ ! -s $1 ]; then
	echo "El archivo $archivo esta vacio"
	exit 1
fi


#Validacion de Rango de filtro
if [[ ! -z $4 && ! -z $3 ]]; then
	if [ $4 \< $3 ]; then 
		echo "Rango invalido"
		ModoDeUso
	fi
fi

if [ $# -le 2 ]; then 
#Si no pasa los parametros de filtro muestra todo el archivo
	cat $archivo 
else
#Filtra por los parametros de filtro 
	sed -ne "/^[$3-$4]/p" "$archivo">"Archivo.txt"
	leerArchivo "Archivo.txt"
fi

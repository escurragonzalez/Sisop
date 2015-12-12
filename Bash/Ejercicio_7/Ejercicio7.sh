#!/bin/bash

#####################################################################################################
 
ayuda() {
	echo
	echo "Demonio que crea un backup del directorio especificado cada x min/seg"
	echo
	echo "Comandos aceptados por el script:"
	echo
	echo "start: Empieza a realizar los backups."
	echo "	$ ./Ejercicio7 start <directorio a salvar> <directorio donde salvar> <tiempo> <unidad de tiempo>"
	echo
	echo "stop: Finalizar el demonio."
	echo "	$ ./Ejercicio7 stop"
	echo
	echo "count: Indica la cantidad de archivos de backup que hay."
	echo "	$ ./Ejercicio7 count"
	echo 
	echo "clear: Limpia el directorio de backup manteniendo los n últimos generados."
	echo "	$ ./Ejercicio7 clear <cantidad de backups a mantener>"
	echo
	echo "play: Se realiza un backup en ese instante."
	echo "	$ ./Ejercicio7 play"
	echo 
	echo "Ejemplos:"
	echo
	echo "Iniciar el demonio, toma backups cada 30 minutos:"
	echo "	$ ./Ejercicio7 start archivos/ backup/ 30 m"
	echo
	echo "Iniciar el demonio, toma backups cada 60 segundos:"
	echo "	$ ./Ejercicio7 start archivos/ backup/ 60 s"
	echo
	echo "Limpia la carpeta de backups, dejando solo los 5 últimos backups:"
	echo "	$ ./Ejercicio7 clear 5"
}
 

#####################################################################################################

function CheckearDemonio {     #Verifico si el demonio fue instanciado o no

    if test -f $TEMP && test -e /proc/$pid     #Si existe el archivo temporal con el pid del demonio
    then
        (( hayDemonio= 1 ))    	#Hay otra instancia del demonio en ejecución
    else
        (( hayDemonio= 0 ))        #El demonio no esta en ejecución
    fi
}

#####################################################################################################

func_start()
{
	CheckearDemonio
	
	if [ $hayDemonio -eq 1 ]
	then
		echo "El demonio ya se encuetra iniciado"
		exit 1
	else
		path_origen=$1
		path_destino=$2
		tiempo=$3
		unidad=$4
		#Lanzo el demonio
		./demonio.sh $path_origen $path_destino $tiempo $unidad &
		pid=$!
		echo "Ejecutando Demonio con PID: $pid"
		#Almaceno el PID del demonio en un archivo temporal
	fi
	exit
}

#####################################################################################################

func_stop()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $hayDemonio -eq 1 ]
    then
		#señal de STOP (19)
		kill -SIGTERM $pid
		#Elimino el archivo temporal con el PID del demonio
		rm -f $TEMP 2>/dev/null
		sleep 1 #Solo por cuestiones estéticas =P
    else
        echo "El demonio no fue instanciado"
    fi
    exit
}

#####################################################################################################

func_count()
{
	CheckearDemonio   #Verifico el estado del demonio

	if [ $hayDemonio -eq 1 ]
	then
		kill -SIGUSR1 $pid
		sleep 1 #Solo por cuestiones estéticas =P
	else
		echo "El demonio no fue instanciado"
	fi
	exit

}

#####################################################################################################

func_play()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $hayDemonio -eq 1 ]
    then
		kill -SIGUSR2 $pid
		sleep 1 #Solo por cuestiones estéticas =P
    else
        echo "El demonio no fue instanciado"
    fi
    exit

}

#####################################################################################################

func_clear()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $hayDemonio -eq 1 ]
    then
    	#Creo un archivo para pasarle la cantidad de archivos a mantener
    	echo $1 > "/tmp/clearDemonio"
		kill -SIGHUP $pid
		sleep 1 #Solo por cuestiones estéticas =P
    else
        echo "El demonio no fue instanciado"
    fi
    exit
}

########################################## PROGRAMA PRINCIPAL #######################################

if [ "$1" = "-?" -o "$1" = "-h" -o "$1" = "--help" ];then
	ayuda
	exit
fi

if [ $# -ne 1 -a $# -ne 2 -a $# -ne 5 ];then
	echo "Cantidad de parametros inválida, para mas información ejecute la ayuda."
	echo
	echo "	$ ejercicio7.sh -?"
	echo
	exit
fi

TEMP="/tmp/demonio.pid"
#si el demonio esta en ejecucion , cargo su PID
if [ -e /tmp/demonio.pid ]
then
	pid=`cat /tmp/demonio.pid`
fi

#$1: nombre del comando start, stop, count, clear, play

case "$1" in
	start)
		#$2: path_origen, $3: path_destino,	#$4: tiempo, #$5: unidad
		if ! test -d "$2";then
			echo "Directorio a salvar inexistente."
			exit;
		fi

		if ! test -d "$3";then
			echo "Directorio donde guardar inexistente."
			exit;
		fi		
		
		if ! test $4 -gt 0 2>/dev/null;then
			echo "El tiempo debe ser mayor a 0."
			exit;
		fi

		if test "$5" != "m" && test "$5" != "s";then
			echo "Unidad de tiempo erronea, debe ingresar m (minutos) o s (segundos)"
			exit;
		fi
		func_start $2 $3 $4 $5
	;;
	stop)
		func_stop
	;;
	count)
		func_count
	;;
	clear)
		#$2: cantidad de backups a mantener
		# si no me paso la cantidad de backups a mantener por defecto es cero.
		if test $# == 1;then 
			func_clear 0
		else
			if test $2 -ge 0 2>/dev/null;then
				func_clear $2
			else
				echo "La cantidad de backups a mantener debe ser mayor o igual a cero."
			fi
		fi
	;;
	play)
		func_play
	;;
	*)
		if [ -z "$1" ]; then
			echo
			echo "Debe ingresar un comando válido, para más información ejecute la ayuda."
			echo
			echo "	$ ejercicio7.sh -?"
			echo
		else
			echo
			echo "$1 no es un comando válido, para más información ejecute la ayuda."
			echo
			echo "	$ ejercicio7.sh -?"
			echo
		fi
	;;
esac

#!/bin/bash

#####################################################################################################
 
ayuda() {
     
	echo "Los comandos aceptados para el manejo del demonio son:"
	echo "  start: Inicia la ejecución del demonio. Se debe ingresar "
	echo "por parámetros el directorio al que se le desea realizar el/los"
	echo " backup/s, el directorio donde desea guardar los mismos y el "
	echo "intervalo de tiempo entre backups expresado en segundos."
	echo "  Stop: Finalizar el demonio."
	echo "  count: Indica la cantidad de archivos de backup que hay "
	echo "en el directorio"
	echo "  clear: Limpia el directorio de backup, recibe por parametro"
	echo "la cantidad de backup que mantiene la carpeta, siendo estos "
	echo "los últimos generados. Ningún parametro equivale a cero."
	echo "  play: El demonio crea el backup en ese instante."
	echo ""
	echo "Ejemplo de ejecucion comando Start:"
	echo  "bash ./Ejercicio7.sh Opcion Path-Origen Path-Destino Intervalo"
	echo  "bash ./Ejercicio7.sh start /root/Desktop/Origen/ /root/Desktop/Destino/ 5"
	echo "Nota:Solo se puede ejecutar un demonio al mismo tiempo."
	echo "Segunda Nota: El archivo demonio.pid se debe encontrar en el path /tmp/"	
}
 

#####################################################################################################

function CheckearDemonio {     #Verifico si el demonio fue instanciado o no
    if [ -f $TEMP ]     #Si existe el archivo temporal con el pid del demonio
    then
        DEM=`ps -fea |grep $( head -1 $TEMP ) |grep -v grep -c`  #tomo el pid
        if [ $DEM = 0 ]             #verifico si sigue en ejecucion el demonio
        then               
            rm $TEMP $PARAMETROS    #borro los archivos temporales que no se pudieron borrar en la ejecucion pasada
	#rm /tmp/datostemporales.txt
            (( IsReady= 1 ))    #Guardo el resultado en la variable IsReady
        else
            (( IsReady= 0 ))
        fi
    else
        (( IsReady= 1 ))        #si no existe el archivo $TEMP entonces el demonio no esta en ejecucion seguramente
    fi
}

#####################################################################################################

func_start()
{
	CheckearDemonio
	
	if [ $IsReady -eq 0 ]
	then
		echo "El demonio ya se encuetra iniciado"
		exit 1
	else
		path_origen=$1
		path_destino=$2
		intervalo=$3
		#if [ ! -e /tmp/datostemporales.txt ]
		if [  -e /tmp/datostemporales.txt ]
		then
			rm /tmp/datostemporales.txt
		fi
		#si no existe el archivo significa que no se ejecuto entonces lo ejecuto
		if [ ! -f "/var/run/demonio.pid" ]; then
			#creo canal fifo de comunicacion
			touch /tmp/datostemporales.txt
			chmod +rwx /tmp/datostemporales.txt
			#$path_origen = "$1"
			#$path_destino="$2"
			#$intervalo=$3
			echo "$path_origen" >> /tmp/datostemporales.txt
			echo "$path_destino" >> /tmp/datostemporales.txt
			echo "$intervalo" >> /tmp/datostemporales.txt
			echo "Ejecutando Damonio"
			nohup /tmp/demonio.sh&
			#bg
			pid_hijo=$!
			#Cuando creo el proceso , creo el canal de comunicacion que contiene el pid de ejecucion
		else
			echo "El proceso esta corriendo...Recuperando PID del demonio"
			#como esta ejecutado busco su pid
			pid_hijo=$(`cat /tmp/demonio.pid`)
		fi
		#echo "el pid delproceso es " $pid_hijo
		#wait $pid_hijo
	fi
	
}

#####################################################################################################

func_stop()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $IsReady -eq 0 ]
    then
        echo "Finalizando proceso..."
	#señal de STOP (19)
	kill -SIGTERM $pid_hijo
    else
        echo "El demonio no fue instanciado"
        exit 1
    fi

}

#####################################################################################################

func_count()
{
	CheckearDemonio   #Verifico el estado del demonio

	if [ $IsReady -eq 0 ]
	then
		echo "$1" > /tmp/demfifo
		kill -SIGUSR1 $pid_hijo
		sleep 1
		read cantidad < /tmp/demfifo
		echo "la cantidad es: $cantidad"
		if [ -f "/tmp/demfifo" ]
		then
			rm /tmp/demfifo
		fi
	else
		echo "El demonio no fue instanciado"
		exit 1
	fi


}

#####################################################################################################

func_play()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $IsReady -eq 0 ]
    then
        echo "iniciando backup instantaneo"
	kill -SIGUSR2 $pid_hijo
    else
        echo "El demonio no fue instanciado"
        exit 1
    fi

}

#####################################################################################################

func_clear()
{
    CheckearDemonio   #Verifico el estado del demonio
    if [ $IsReady -eq 0 ]
    then
       	echo "limpiando carpeta"
	kill -SIGALRM $pid_hijo
    else
        echo "El demonio no fue instanciado"
        exit 1
    fi
}

#####################################################################################################

TEMP="/tmp/demonio.pid"
#si el demonio esta en ejecucion , cargo su PID
if [ -e /tmp/demonio.pid ]
then
	pid_hijo=`cat /tmp/demonio.pid`
fi
case "$1" in
	start)
		func_start $2 $3 $4
	;;
	stop)
		#Envio señal para que finalice el proceso
		func_stop
	;;
	count)
		func_count $2
	;;
	clear)
		func_clear $2
	;;
	play)
		func_play
	;;
	help)
		ayuda
	;;
#opcion por default
*)
ayuda
esac

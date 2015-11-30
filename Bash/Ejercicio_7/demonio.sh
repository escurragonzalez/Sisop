#!/bin/bash

#####################################################################################################
 
BackUp()
{
    echo "Realizando Backup..."
    DIA=`date +"%d-%m-%Y"`
    HORA=`date +"%H:%M:%S"`
    cp -a "$path_origen" $path_destino"/Backup "$DIA" "$HORA
    echo "Backup "$DIA" "$HORA" Realizado"
}

#####################################################################################################
 
play()
{
	echo "haciendo backup instantaneo de $path_origen a $path_destino"
	BackUp
}

#####################################################################################################
 
count()
{
	read path_origen < /tmp/demfifo
	#Lista los archivos y los pasa a la tuberia al comando wc para contarlos
	#cuento todos los backups en la carpeta e informo el numero por pantalla	

	C=`ls "$path_destino"|grep "Backup "|wc -l` #cuento todos los backups en la carpeta e informo el numero por pantalla
    	echo $C > /tmp/demfifo
	
}

#####################################################################################################
 
func_clear()
{
	echo "Iniciando la funcion clear."
	echo "Borrando archivos de $path_destino"
	for a in `ls $path_destino| grep -v "Backup "`; do rm -fr $a; done
}

#####################################################################################################
 
iteracion()
{
	sleep $interval &
	wait $!
}

#####################################################################################################
 
salir()
{
	if [ -f /tmp/demonio.pid ]
	then
		# El fichero PID existe
		if [ `cat /tmp/demonio.pid` -eq $$ ]
		then
			# El PID nos corresponde
			echo "borrando el fichero PID, porque es de esta ejecucion."
			rm -f /tmp/demonio.pid
		fi
	fi
	if [ -f /tmp/demfifo ]
	then
		rm /tmp/demfifo
	fi
	exit 0
}

trap salir SIGTERM SIGKILL
trap count SIGUSR1
trap play SIGUSR2
trap func_clear SIGALRM

echo "Iniciando demonio..."

### VERIFICO SI EL DEMONIO YA ESTA EN EJECUCION:
if [ ! -f "/tmp/demonio.pid" ]
then
	# no existe el fichero PID
	echo $$ > "/tmp/demonio.pid"
else
	# El fichero PID existe
	if [ `cat /tmp/demonio.pid` -ne $$ ]
	then
		echo "Imposible ejecutar, este binario ya se está ejecutando."
		salir
	fi
fi


###
#recibo los parametros
read path_origen < "/tmp/datostemporales.txt"
path_destino=$(head -2 "/tmp/datostemporales.txt" | tail -1)
#intervalo de ejecucion de los backup
intervalo=$(head -3 "/tmp/datostemporales.txt" | tail -1)

echo "path_origen: $path_origen"
echo "path_destino: $path_destino"
echo "intervalo: $intervalo"




#intervalo que uso con los sleeps
interval=1


#si existe borro el archivo que uso como canal
if [ -f /tmp/datostemporales.txt ]
then
	rm "/tmp/datostemporales.txt"
fi


contador=0
echo "arrancando el demonio con PID=$$"
while true
do
	# hacer lo que sea
	echo "iteracion"
	# esperar
	echo "esperando $interval segundos"
	iteracion
	if [ $contador -eq $intervalo ]
	then
		$contador=0
		play
	fi
	contador=$((contador+1))
done
##fin de demonio

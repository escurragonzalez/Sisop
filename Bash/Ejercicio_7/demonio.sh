#!/bin/bash

#####################################################################################################
 
#El problema con esta version de la funcion backup, es que hace backups cuando se envia count, 
#play o clear, la dejamos por cualquier problema que puedan surgir con la nueva version
backup2() 
{
	while true
	do
		case "$unidad" in
			m)
				tiempo=`expr 60 \* $tiempo` 
				sleep $tiempo & 
				wait $!
				play				 
			;;
			s)
				sleep $tiempo &
				wait $!
				play			
			;;
		esac
	done
}

backup() #Nueva version y usada actualmente
{
	contador=0

	if test $unidad = "m";then
		tiempo=`expr 60 \* $tiempo` 	
	fi

	while true
	do
		iteracion
		if [ $contador -eq $tiempo ]
		then
			contador=0
			play 1 #pasamos un parametro para distinguir del backup instantaneo
		fi
		contador=`expr $contador + 1`
	done
}
#####################################################################################################
 
play()
{
	DIA=`date +"%d-%m-%Y"`
    HORA=`date +"%H:%M:%S"`
    cp -a "$path_origen" $path_destino"/Backup_"$DIA"_"$HORA
    if test -z $1;then
    	echo "Backup instantaneo realizado."
    fi
}

#####################################################################################################
 
count()
{
	 #cuento todos los backups en la carpeta e informo el numero por pantalla
	C=`ls "$path_destino" | grep "Backup" | wc -l`
    echo "Actualmento existen " $C "backups."
	
}

#####################################################################################################
 
func_clear()
{
	cantidadAMantener=`cat "/tmp/clearDemonio"`
	cantidadBackups=`ls "$path_destino" | grep "Backup" | wc -l`
	contador=0
	limite=`expr $cantidadBackups - $cantidadAMantener`

	if test $limite -le 0 ;then
		echo "La cantidad de backups actual es menor a la cantidad que desea mantener."
	else
		archivosABorrar=`ls $path_destino | grep "Backup"`
		for a in $archivosABorrar; 
		do 
			if test $contador -lt $limite ; then
				echo "Borrando: $path_destino"/"$a"
				rm -r "$path_destino"/"$a"
				contador=`expr $contador + 1`
			fi
		done
	fi
	rm "/tmp/clearDemonio"
}


#####################################################################################################
 
salir()
{
	echo "Demonio Finalizado."
	exit 0
}

####################################################################################################

iniciar_demonio()
{
	TEMP='/tmp/demonio.pid'
	echo $$ > $TEMP
	backup
}

####################################################################################################

iteracion()
{
	sleep 1 & #iteracion de 1 segundo
	wait $!
}

####################################################################################################

trap salir SIGTERM SIGKILL
trap count SIGUSR1
trap play SIGUSR2
trap func_clear SIGHUP


#recibo los parametros
path_origen=$1
path_destino=$2
tiempo=$3
unidad=$4

#Inicio el demonio
iniciar_demonio
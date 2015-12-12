#!/bin/bash
ingreso_dia()
{
   archivo=$1
   fecha=$2
   fechaRepetida=${2:0:9}
   buscarFechaArchivo=`grep $fechaRepetida $archivo`
  if [ -n "$buscarFechaArchivo" ];then
   echo La fecha ingresada ya existe en el archivo
   exit
  else
      #cuentos las lineas del archivo
      cantLineas=`awk 'END{print NR}' $archivo`
      #veo si existe una fecha sin finalizacion
      cantSeparadores=`awk -v cant=$cantLineas -F '|' 'NR==cant{print NF}' $archivo`
     
      if [ "$cantSeparadores" = 2 ]; then
    	    reg=`tail -1 $archivo`
    	    echo Hay registro incompleto.Es el siguiente $reg
    	    exit
    	fi
    	
    	#si existiera un reporte mensual previo lo borro
      sed -i "/|[0-9.]*$/d" $archivo

      #grabo en la ultima linea 
    	echo "$fecha|">>$archivo 
  fi
 }

egreso_dia(){
   archivo=$1
   cantLineas=`awk 'END{print NR}' $archivo`
  #veo si existe una fecha sin finalizacion
  cantSeparadores=`awk -v cant=$cantLineas -F '|' 'NR==cant{print NF}' $archivo`
  if [ "$cantSeparadores" != 3 ]; then
	    echo No hay registro incompleto.
	    exit
	fi
	reg=`tail -1 $archivo`
	finalizacion=${2:11:18} 
	cadena=$reg$finalizacion
	#echo $cadena
	cantHoras=`echo $cadena | awk -F "|" -f horas.awk` #calculo la cantidad de horas que trabajo redirecionando flujo
    cantHoras="$finalizacion|$cantHoras"
   
    sed -i "$ s/|/|$cantHoras/2" $archivo  #grabo en la ultima linea 
    cat $archivo | awk -F "|" '{print substr($1,1,10)}' | sort -n -t "/"  -k3 -k2 -k1 -o $archivo $archivo #ordeno el archivo por fecha 
    awk -v ultimo=$archivo -F "|" -f reportemes.awk "$archivo"
}

reporte_mensual(){
  dir=$(dir -1)
  for file in $dir;
  do
# comprobamos que la cadena no este vacía
   if [ -n $file ]; then
    #echo $file
    if [ -f $file ]; then
	     mes="$( cut -d '.' -f 2 <<< "$file" )"
       anio="$( cut -d '.' -f 1 <<< "$file" )"	
       if [ $2 = "$anio"  -a  $mes = "$3" ] ; then
          reg=`tail -1 $file`
          echo $reg | awk -v mes=$mes -f reporteMensual.awk
    	 	  exit
       fi    
    fi
  fi
 done

}
reporte_anual(){
 echo
 echo "         REPORTE ANUAL"
 echo

 diasTrabajados=0
 horasReales=0
 diferencia=0

 temp=$(mktemp)

 dir=$(dir -1)
 for file in $dir;
  do
# comprobamos que la cadena no este vacía
   if [ -n $file ]; then
    #Si es un archivo
    if [ -f $file ]; then
	    anio="$( cut -d '.' -f 1 <<< "$file" )"
      mes="$( cut -d '.' -f 2 <<< "$file" )"
    	if [ "$3" = "$anio" ]; then
	 	     reg=`tail -1 $file`
         echo $reg >> $temp
      fi    
    fi
   fi
 done
 cat $temp | awk -f "reporteAnual.awk"
 rm $temp
}

scriptErrorParametro(){
echo "Debe ingresar como minimo 2 parametros. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio4.sh -h"
echo "bash ejercicio4.sh -help"
echo "bash ejercicio4.sh -?"
}
ofrecerAyuda(){
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [-i] o  [-f] o [-r]  o [-y] "
echo ""
echo "Ejemplos:"
echo "se ingresa un registro "
echo 'bash ejercicio4.sh -i "20/04/2014|12:00:00"'
echo "sirve para finalizar un registro existente"
echo 'bash ejercicio4.sh -f "20/04/2014|20:00:00"' 
echo "en este caso, se hara un reporte del mes 08 del año 2014"
echo 'bash ejercicio4.sh -r "08/2014"' 
echo "en este caso, se usara el año 2014"
echo 'bash ejercicio4.sh -y 2014'
echo "en este caso, se usara el año actual"
echo 'bash ejercicio4.sh -y'
exit 0
}
if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ];then
    ofrecerAyuda
elif [ $# -eq 0 ];then  
  scriptErrorParametro
fi  
DIR=`pwd`
cd $DIR
if [ "$1" = "-i" -o "$1" = "-f"  ]; then
  if [[ -z $2 ]]; then
    scriptErrorParametro
  else  
     fecha=${2:0:10} 
     anio="$( cut -d '/' -f 3 <<< "$fecha" )"
     mes="$( cut -d '/' -f 2 <<< "$fecha" )"
     archivo=$anio.$mes.'ch'
     if [ ! -e $archivo ]; then
       touch $archivo 2>/dev/null
       marca=1
       estado=$?
     fi
   	
   	if [ "$marca" = 1 -a "$estado" != 0 ]; then
     echo no se pudo crear
     exit
   	fi
   	if [ ! -w  $archivo -a ! -r $archivo ]; then
      echo no tiene permisos sobre el archivo
   	  exit
    fi
  	if [ "$1" = "-i" ];then
  	   ingreso_dia $archivo $2
 		exit 	
  	else
  	  egreso_dia $archivo $2
  	  exit
  	fi
  fi
fi

if [ "$1" = "-r" -o "$1" = "-y" ]; then
  if [ "$1" = "-y" ]; then 
	   if [[ -z $2 ]]; then
    	  anio=`date +%Y`
     else
	  	  anio=$2
	   fi
	   reporte_anual $DIR $1 $anio
	   exit
  else
  		anio="$( cut -d '/' -f 2 <<< "$2" )"
     	mes="$( cut -d '/' -f 1 <<< "$2" )"
  		reporte_mensual $DIR $anio $mes
  		exit
  fi
else #parametro invalido
	scriptErrorParametro
fi





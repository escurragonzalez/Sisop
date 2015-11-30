#!/bin/bash

esArchivoDeBash(){
VAR1=$(sed -n 1p "$1" 2>>$2) #tomo 1er linea archivo y sino redirecciono salida error
estado=$? 
hora=`date +%T%t`
fecha=`date +%d-%m-%y`
evento="$hora $fecha"
if [ "$estado" = 0 ]; then  #si estado=0 se pudo leer correctamente archivo 
   if [ "$VAR1" = '#!/bin/bash' ];then
     sed -i "$ a #$evento" $1 2>>$2 #agrego a ultima linea del .sh #la fecha y hora, sino redirecciono salida error
     estado=$?
      #sino puedo agregarle la ultima linea al archivo .sh le agrego fecha-hora log  remplazando 'sed'
      if [ "$estado" != 0 ];then  
        sed -i "$ s/sed/[$evento]/" $2
      fi
        #busco la extension 
	ext=${1##*.}
        #corto la cadena hasta la extension
        archivo=${1%$ext}
        #si el archivo no tiene extension
        if [[ -z $archivo ]]; then
          nombre=${ext^^} #le asigno en mayusculas la extension
	else
          ext=${ext,,} #convierto la extension en minusculas
          archivo=${archivo^^} #convierto en mayusculas el nombre
          nombre=$archivo$ext #concateno el nombre y extension
	fi
	mv $1 $nombre 2>>$2  #renombro archivo, sino puedo redicciono salida eero
        estado=$?
        #sino puedo renombrar
          if [ "$estado" != 0 ];then #sino pude renombrar le agrego fecha-hora log remplazando 'sed'
             sed -i "$ s/mv/[$evento]/" $2 
	  else
            #sed -i "$ a [$evento]:$nombre">> $2
            echo "[$evento]:$nombre" >> $2 #en la ultima linea archivo registro la fecha-hora y el nuevo nombre archivo
          fi
    fi 
else
   #no se puede leer archivo que recibo
   sed -i "$ s/sed/[$evento]/" $2 #remplazo la palabra sed por [fecha-hora]
fi
}

recorrer_directorio(){
 dir=$(dir -1)
 for file in $dir;
  do
# comprobamos que la cadena no este vacía
   if [ -n $file ]; then
    if [ -d "$file" ]; then
     cd $file 2>>/dev/null
     estado=$? 
        if [ "$estado" != 0 ];then 
          echo "Directorio $file no se puede acceder" >> $2
        else
          recorrer_directorio ./ $2
          cd ..
        fi
    else
      esArchivoDeBash $file $2
    fi;
   fi;
 done;
}

explorarDirectorio(){
DIR=$1
cd $DIR
recorrer_directorio $DIR $2
}


scriptErrorParametro(){
echo "Debe ingresar aunque sea dos parametro. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio3.sh -h"
echo "bash ejercicio3.sh -help"
echo "bash ejercicio3.sh -?"
exit 0
}

ofrecerAyuda(){
echo "Debe pasarse como parametro el nombre del directorio de entrada y el de salida. Debe escapearse los espacios de la siguiente forma: '\ '"
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [archivo de entrada o directorio] [-i o -ni]"
echo ""
echo ""
echo ""
echo "Ejemplos:"
echo ""
echo ""
echo ""
echo "bash ejercicio3.sh archivito.sh registro.log"

exit 0
}

#fin bloque funciones

#compruebo si invocan a la ayuda o sino valido la cantidad de parametros recibidos
  if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ];then
    ofrecerAyuda
  elif [ $# -ge 0 -a $# -lt 2 ];then   #si tengo menos de 2 parametros 
    scriptErrorParametro
  fi  
archivoLog="${!#}"
  for (( i=1; i<$#; i++ ))
  do
   if [ -f ${!i} ]; then #verifico si es archivo el parametro
      esArchivoDeBash ${!i} $archivoLog
    elif [ -d ${!i}  ]; then 
      logDirectorio=`pwd`/$archivoLog   #envio el log asi ya que para recorrer directorio uso una funcion recursiva
      explorarDirectorio ${!i} $logDirectorio
    else   
      hora=`date +%T%t`
      fecha=`date +%d-%m-%y`
      evento="$hora $fecha"
      evento="$hora $fecha"
      echo "[$evento]:${!i} es un directorio o carpeta inexistente" >> $archivoLog
   fi
done


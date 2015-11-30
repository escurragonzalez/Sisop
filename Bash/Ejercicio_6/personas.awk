#!/bin/awk
BEGIN{
	FS=","; #Cambio el separador de campos por defecto.
	campos=4;	#Nombre y Apellido ; Documento ; Direccion ; acronimo pais de nacimiento
}
{
	if($1!="" && $2!="" && $3!="" && $4!=""){ #verifico que los campos no esten vacios
		#Elimino espacios en blanco
		gsub(/ /, "", $4)
		#verifico que el acronimo solo tenga dos mayusculas		
		if(match($4,/[A-Z][A-Z]/) && length($4) == 2){ 
			if(NF == campos){ #validacion de cantidad de campos del registro
				#concateno todos los registros que tengan el mismo acronimo en un array
				#asociativo, separados por un pipe.				 
				personas[$4] = personas[$4] $1 "|" 
			}
		}else{
			print "ERROR ("$4"): El acronimo es invalido."
		}	
	}else{
		print "ERROR: El registro contiene un parametro nulo."
	}
}
END{
	#almaceno los registros agrupados por su acronimo en un archivo temporal
	for(key in personas){
		print key "|" personas[key] > temp1
	}
}

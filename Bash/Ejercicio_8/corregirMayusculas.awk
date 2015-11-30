#Funciones para eliminar espacios iniciales y finales de una cadena
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }
BEGIN{
	FS = " "
}
{
	#separo la primer letra de la frase
	letra = substr(trim($1), 0, 1)

	#verifico que el caracter no sea nulo, sea una letra y además verifico si es minuscula
	if(letra != "" &&  match(letra, "[a-zA-Z]")  && letra == tolower(letra) ){
		#si la primer letra esta en minuscula, imprimo error
		printf ("%-11s %-30s %d\n","MAYUSCULAS",trim($1),NR)
	}
}
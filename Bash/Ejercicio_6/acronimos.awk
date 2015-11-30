#!/bin/awk
$1 ~ /[^PC]/ || length($1) != 1{
	print "ERROR ("$1"): El tipo de registro debe ser \"P\" o \"C\""
}
$2 ~ /[^A-Z][^A-Z]/ || length($2) != 2{
	print "ERROR ("$2"): El acronimo es incorrecto"
}
$3 ~ /[^A-Za-zñÑáéíóúÁÉÍÓÚ\- ]/{
	print "ERROR ("$3"): El nombre del pais es invalido"
}
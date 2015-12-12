BEGIN{
   split("enero_febrero_marzo_abril_mayo_junio_julio_agosto_septiembre_octubre_noviembre_diciembre",mesesArray,"_")
   FS = "|"
}
{
	split($2, horas, ":")

	print "Mes: " mes,mesesArray[(mes+0)]
	print "Dias trabajados: ",$1
	print "Horas estimadas: ",$1*8,"hs"
	print "Horas reales: ",horas[1]+horas[2]/60, "hs"
	print "Diferencia: ", $3
}


BEGIN{
	FS="|"
	dt=0
	hr=0
	d=0
}
{
	split($2, horas, ":")
	dt+=$1
	hr+=horas[1]+horas[2]/60
	d+=$3
}

END{
	print "Dias trabajados: ",dt
	print "Horas estimadas: ",dt*8,"hs"
	print "Horas reales: ",hr,"hs"
	print "Diferencia: ",d
}
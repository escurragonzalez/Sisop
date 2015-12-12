
{
    split($1,fechaCampo,"/")
    split( $4,horas,":" )
    resultado+=horas[1]*3600+horas[2]*60+horas[3]
	 diasCantidadReporteMes++
     mesParametro=int(fechaCampo[2])
}
END{
    horasTrabajadas=int(resultado/3600)
    minTrabajados=int((resultado - 3600*horasTrabajadas)) / 60
    segTrabajados=int(resultado %  3600)- int(minTrabajados) * 60 
    horasEstimadas=diasCantidadReporteMes * 8
    diferencia= resultado - horasEstimadas * 3600 
    horaDiferencia=(diferencia/3600) 
    print diasCantidadReporteMes"|"horasTrabajadas":"minTrabajados":"segTrabajados"|"horaDiferencia >> ultimo
    
}
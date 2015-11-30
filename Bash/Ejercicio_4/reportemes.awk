BEGIN{
   resultado=0
   split("ene_feb_mar_abr_may_jun_jul_ago_sep_oct_nov_dic",mesesArray,"_")
   diasCantidadReporteMes=0
}
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
     horaDiferencia=int(diferencia/3600) 
     minDiferencia= int((diferencia - 3600 * horaDiferencia )/60)
     segDiferencia= int((diferencia %  3600)- (minDiferencia * 60))
     printf("Mes: %s-%2d|Dias trabajados: %d|Horas estimadas: %02d:00:00|Horas reales: %02d:%02d:%02d|Diferencia: %02d:%02d:%02d", mesesArray[mesParametro], mesParametro,diasCantidadReporteMes, horasEstimadas, horasTrabajadas,
     minTrabajados,segTrabajados,horaDiferencia, minDiferencia,segDiferencia)>>ultimo

}
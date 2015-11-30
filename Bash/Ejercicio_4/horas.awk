{
    split($2,hora1,":")
    split($3,hora2,":")
    segundos1=hora1[1]*3600+hora1[2]*60+hora1[3]
    segundos2=hora2[1]*3600+hora2[2]*60+hora2[3]
    diferencia=segundos2-segundos1
    horaDiferencia=int(diferencia/3600) 
    minDiferencia= int((diferencia - 3600 * horaDiferencia )/60)
    segDiferencia= int((diferencia %  3600)- (minDiferencia * 60))
    #sed 's/\n/foo\n/'   
    printf("%02d:%02d:%02d", horaDiferencia,minDiferencia,segDiferencia)
}

#############################################################################################
# PROGRAM-ID.  ejercicio6.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Muestra el modelo de CPU, cantidad de memoria RAM, placas de red y #
# versión del sistema operativo.                                                            #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              #
#           -Bogado, Sebastian                                                              #
#           -Camacho, Manfred                                                               #
#           -Gonzalez, Gustavo                                                              #
#           -Rey, Juan Cruz                                                                 #
#           -Valenzuela, Santiago                                                           #
# Ejemplo Ej.:                                                                              #
# C:\PS> .\ejercicio6.ps1                                                                   #
#############################################################################################

<#
.SYNOPSIS
Muestra el modelo de CPU, cantidad de memoria RAM, placas de red y versión del sistema operativo en formato de tabla.

.DESCRIPTION
Muestra el modelo de CPU, cantidad de memoria RAM, placas de red y versión del sistema operativo en formato de tabla.

.EXAMPLE
    C:\PS> .\ejercicio6.ps1 

	
#>

Get-WmiObject -class win32_Processor | Format-Table
Get-WmiObject -Class Win32_OperatingSystem | Format-Table
Get-WmiObject -Class Win32_PhysicalMemory|Format-Table Description, ConfiguredClockSpeed, Manufacturer, Name, PartNumber, Capacity
$hola=Get-WmiObject Win32_NetworkAdapter -filter "AdapterType != NULL" 
$i=0
foreach($tarjeta in $hola){
    $i++
}
echo "La cantidad de tarjetas de red que hay en este equipo es/son: $i"

#############################################################################################
# PROGRAM-ID.  ejercicio1.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Guarda en un archivo txt los procesos que estan corriendo          #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ARCHIVOS DE SALIDA : un archivo txt con los procesos                                      #
# ALUMNOS :                                                                                 #                                                                              #
#           -Bogado, Sebastian                                                              #
#           -Camacho, Manfred                                                               #
#           -Gonzalez, Gustavo                                                              #
#           -Rey, Juan Cruz                                                                 #
#           -Valenzuela, Santiago                                                           #
# Ejemplo Ej.:                                                                              #
# C:\PS> .\ejercicio1.ps1 -pathSalida :\test\                                               #
#############################################################################################

<#
.SYNOPSIS
Guarda en un archivo txt los procesos que estan corriendo en el sistema.

.DESCRIPTION
Guarda en un archivo txt los procesos que estan corriendo en el sistema en formato de lista,
adicionalmente muestra por defecto los tres primeros procesos de la lista.

.PARAMETER pathSalida
Ruta donde se guardará la lista de procesos.

.PARAMETER cantidad
Cantidad de procesos que se imprimiran por pantalla

.EXAMPLE
    C:\PS> .\ejercicio1.ps1 

    Formato por defecto, ruta de salida es el directorio actual desde donde se ejecuta el comando, la cantidad de procesos por defecto mostrados por pantalla es 3.
.EXAMPLE
    C:\PS> .\ejercicio1.ps1 -pathSalida C:\test\

    Se especifica la ruta de salida y se deja la cantidad de procesos a listar por defecto.
.EXAMPLE
    C:\PS> .\ejercicio1.ps1 -pathSalida C:\test\ -cantidad 5

    Cuando se especifica la cantidad de procesos a listar es necesario ingresar el nombre del parametro -cantidad.
.EXAMPLE
    C:\PS> .\ejercicio1.ps1 C:\test\ -cantidad 0

    Es posible omitir el nombre del parametro -pathSalida, no asi el parametro -cantidad
#>

Param
(
    [Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
    [int] $cantidad = 3
)
$existe = Test-Path $pathsalida
if ($existe -eq $true)
{
    $listaproceso = Get-Process
    foreach ($proceso in $listaproceso)
    {
        $proceso | Format-List -Property Id,Name >> $pathsalida"/procesos.txt"
    }

    for ($i = 0; $i -lt $cantidad ; $i++)
    {
        Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
    }
}
else
{
    Write-Host "El path no existe"
}

<#
a. ¿Cuál es el objetivo del script?
    Listar los procesos del equipo en un archivo de texto y muestra por pantalla los 3 primeros procesos de la lista.
b. ¿Agregaría alguna otra validación a los parámetros?¿Cuál/es (detallar el código de las validaciones que incorporaría?

    *   $cantidad -> validar que sea menor o igual a la cantidad de procesos en la lista
            if($cantidad > $listaproceso.Length)
            {
                echo "La cantidad de procesos a mostrar es mayor a la cantidad de procesos existentes"
                exit
            }
    *   $cantidad -> validar que sea mayor o igual a cero.
            [Parameter()][ValidateRange(0,2147483647)][int] $cantidad
    
    *   $cantidad -> agregar position=2 para evitar escribir -cantidad al pasarle dicho parametro 
              [Parameter(Position = 2)][int] $cantidad = 3
    *   Adicionales, el script guarda el archivo procesos.txt en la ruta $home del usuario, para poder guardar en el 
        pathSalida se debe concatenar las variables
            $pathsalida"/procesos.txt"
#>

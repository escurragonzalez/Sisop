#############################################################################################
# PROGRAM-ID.  ejercicio2.ps1                                                               #
# OBJETIVO DEL PROGRAMA: Copia archivos de un directorio a otro                             #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ARCHIVOS DE SALIDA : Log                                                                  #
# COMENTARIOS: El script Copia a un directorio todos los archivos de texto que contengan    #
# una cadena determinada. Debe recibir por parámetro la cadena a buscar, el directorio     #
# de origen  y el de destino.                                                               #
# directorio. Ambos directorios deben ser pasados por parámetro                            #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Camacho, Manfred                                                               #
#           -Gonzalez, Gustavo                                                              #
#           -Rey, Juan Cruz                                                                 #
#           -Valenzuela, Santiago                                                           #
# Ejemplo:                                                                                  #
# PS D:\tp> .\Ejercicio2.ps1 -pathOrigen 'E:\DC COMICS' -pathDestino E:\tp  -cadena Prueba  #
#############################################################################################

<#

.SYNOPSIS
El script Copia a un directorio todos los archivos de texto que contengan una cadena determinada

.DESCRIPTION
El script Copia a un directorio todos los archivos de texto que contengan una cadena determinada
Debe recibir por parámetro la cadena a buscar, el directorio de origen y el de destino.
Al finalizar la copia, se debe crear un archivo de log en donde se indique el directorio de origen, 
el tamaño y la fecha de modificación de cada uno de los archivos copiados.

.PARAMETER pathOrigen
Ruta del directorio que se desea buscar archivos que contengan la cadena determinada

.PARAMETER pathDestino
Ruta donde se copiaran los arhcivos

.EXAMPLE
C:\PS> .\ejercicio2.ps1 -pathOrigen 'E:\DC COMICS' -pathDestino E:\tp  -cadena Prueba

.EXAMPLE
C:\PS> .\ejercicio2.ps1 .\DirectorioOrigen d:\DirrecorioLog cadena

.EXAMPLE
C:\PS> .\ejercicio2.ps1 .\ejercicio2.ps1 -pathDestino ./log -pathOrigen ./ cadena
#>

Param
(
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $pathOrigen,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $pathDestino,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $cadena
)

$cantPar = ($psboundparameters.Count + $args.Count)
if( $cantPar -ne 3 )
{
  Write-Output "La cantidad parametros fue distinta a 3!"
  exit
}
#Validaciones de Path 
$pathValidDest = Test-Path $pathDestino;
$pathValidOrigen = Test-Path $pathOrigen;
if($pathValidDest -eq $false)
{
    echo "Path de destino no valido";
    exit;
}
if($pathValidOrigen -eq $false)
{
    echo "Path de origen no valido";
    exit;

}
if($pathDestino -eq $pathOrigen)
{
    echo "Path de origen y de destino no peden ser el mismo";
    exit;
}

if($pathValidOrigen -eq $true -and $pathValidDest -eq $true )
{
$lista = @()
    try{
    #Obtengo lista de archivos txt
    $archivos = ls -Path $pathOrigen -Recurse -Include "*.txt"
    foreach($item in $archivos)
    {
         $aux = Get-Content $item
          #si contiene el parametro lo agrego a la lista a copiar
         if ($aux -match $cadena) {
                $lista += $item
         }       
    }
    }
    Catch [UnauthorizedAccessException],[DirUnauthorizedAccessError]{
    Write-Output "No tiene permisos"
    }
    Catch{
    Write-Output "Error al copiar archivos"
    }
}
foreach($item in $archivos)
{
    try{
    if($lista.Count -ne 0)
    {   
        cp $lista $pathDestino;
    }
    }
    Catch [UnauthorizedAccessException],[DirUnauthorizedAccessError]{
    Write-Output "No tiene permisos"
    }
    Catch
    {
        Write-Output "Error al copiar arhcivos"
    }
    #Genero Log
    if($lista.Length -ne 0){
        $lista | Format-List -Property Directory,Length,LastWriteTime > $pathDestino\Log.txt
    }
}

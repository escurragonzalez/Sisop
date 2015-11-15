#############################################################################################
# PROGRAM-ID.  ejercicio3.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Realiza un backup de su base de datos en un archivo de texto plano #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ARCHIVOS DE SALIDA : .csv                                                                 #
# COMENTARIOS: Lee el archivo de backup y genere un archivo CSV. La primer fila del archivo #
# CSV contiener los nombres de los campos                                                   #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Camacho, Manfred                                                               #
#           -Gonzalez, Gustavo                                                              #
#           -Rey, Juan Cruz                                                                 #
#           -Valenzuela, Santiago                                                           #
# EjemploEj.:                                                                               #
# C:\PS> .\ejercicio3.ps1 -pathOrigen D:\Prueba.txt -pathDestino D:\Backup\Salida.csv       #
#############################################################################################

<#

.SYNOPSIS
Realiza un backup de su base de datos en un archivo de texto plano

.DESCRIPTION
Lee el archivo de backup y genere un archivo CSV. La primer fila del archivo CSV contiener los nombres de los campos 

.PARAMETER pathEntrada
Ruta archivo que se migrara al csv

.PARAMETER pathSalida
Ruta donde se exportara el archivo csv

.EXAMPLE
C:\PS> .\ejercicio3.ps1 -pathEntrada D:\Prueba.txt -pathSalida D:\Backup\Salida.csv       

.EXAMPLE
C:\PS> .\ejercicio3.ps1 -pathEntrada .\file.txt ./salida.c

.EXAMPLE
C:\PS> .\ejercicio3.ps1 .\file.txt ./salida.csv

#>
param(
    [Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()][string] $pathEntrada,
    [Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()][string] $pathSalida
)

$cantPar = ($psboundparameters.Count + $args.Count)

if( $cantPar -ne 2 )
{
  echo "La cantidad parametros fue distinta a 2!"
  exit
}


try{
    $linea = (Get-Content $pathEntrada)
}
catch{
    Write-Output "Error al leer el archivo"
    exit
}
$cont = 0

$registroArray =@() #inicializo array


foreach($aux in  $linea)
{   
    if($aux -eq "***"){
        $cont = 0
    }
    else
    {
            if($aux.Contains('='))
            {
                $partes = $aux.Split('=')     
              if($cont -eq 0) #es un nuevo registro de la BD
              {
                 #creo un objeto y le agrego como clave el nombre del campo y valor el contenido del campo
                 $registro = new-object PSObject
                 $registro | add-member -membertype NoteProperty -name $partes[0] -Value $partes[1]     
              }
              else
              {
                if ($cont -eq 1)
                {
                    $registro  | add-member -membertype NoteProperty -name $partes[0] -Value $partes[1]     
                }
                else
                {
                     $registro | add-member -membertype NoteProperty -name $partes[0] -Value $partes[1]     
                }
            }
            $cont++
            if($cont -eq 3) #fin del registro BD 
            {
                $registroArray += $registro 
            }  
       }
                   
    }
   
}
try{
    $registroArray| Export-csv -Delimiter ";" $pathSalida -NoTypeInformation #el -notypeinformation sirve para que no grabe que tipo de objeto que exporto 
}
catch
{
    Write-Output "Error al exportar archivo csv"
}



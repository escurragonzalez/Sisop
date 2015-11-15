#############################################################################################
# PROGRAM-ID.  ejercicio7.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Analiza la estructura de una matriz y determina el tipo al         #
# que corresponde.                                                                          #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Camacho, Manfred                                                               #
#           -Gonzalez, Gustavo                                                              #
#           -Rey, Juan Cruz                                                                 #
#           -Valenzuela, Santiago                                                           #
# EjemploEj.:                                                                               #
# C:\PS> .\ejercicio4.ps1 C:/miarchivo.txt                                                  #
#############################################################################################

<#
.SYNOPSIS 
Analiza la estructura de una matriz y determina el tipo al que corresponde.

.DESCRIPTION
Lee y analiza la estructura de una Matriz cargarda en un Archivo separada por un caracter que llega de parametro y filas por salto de linea.

.PARAMETER Path
Especifica el path del archivo que contiene la matriz.

.PARAMETER delim
Especifica el caracter separador de las columnas.

.EXAMPLE
c:\PS> ./ejercicio7.ps1 -path C:/matriz.txt -delim '&'

.EXAMPLE
c:\PS> ./ejercicio7.ps1 -path C:/matriz.txt '&'
    
.EXAMPLE
c:\PS> ./ejercicio7.ps1 C:/matriz.txt '&'    
            
#>

Param
(
    [parameter(Position=0, Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $Path,
    [parameter(Position=1, Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $delim
)

#VALIDACION
$cantPar = ($psboundparameters.Count + $args.Count)
if($cantPar -ne 2)
{
echo "Cantidad de parametros incorrecta."
exit
}

$pathValido = Test-Path $Path;
if($pathValido -eq $false)
{
echo "Path de archivo no valido.";
exit;
}

if(test-path $Path -PathType Container)
{
echo "Debe especificar un archivo de texto, no un directorio.";
exit;
}

if($(Get-Content $Path).Length -eq 0){
echo "Es un archivo vacio.";
exit;
}

if($delim.Length -ne 1){
echo "Debe ingresar un caracter."
exit
}

#FUNCIONES
function Cargar_Matriz_De_Archivo([String]$file,[char]$Delimitador)
{
  $f = get-content $file
  $lines = $f | Measure-Object -Line
  [int]$filas = $f.count
   if($filas -eq 1)
   {
        $columnas = ($f.ToCharArray() | Where-Object {$_ -ne $Delimitador} | Measure-Object).Count
   }
   else
   {
         $columnas = ($f[0].ToCharArray() | Where-Object {$_ -ne $Delimitador} | Measure-Object).Count
   }
  [double[][]] $resultado = new-object double[][] $filas
  for ($i = 0; $i -lt $resultado.Length; $i++) {
    $resultado[$i] = new-object double[] $columnas
  }

  $i = 0
  foreach ($linea in $f) {
    $tokens = $linea.split($Delimitador)
    for ($j = 0; $j -lt $tokens.Length; $j++) {
      $resultado[$i][$j] = $tokens[$j].trim()
    }
    $i++
  }
  , $resultado
}


function Mostrar_Matriz([double[][]] $m)
{
    write-host "Mostrando Matriz:"
  #Recorre las filas una por una
  for ($i = 0; $i -lt $m.Length; $i++) {
    #Recorre las columnas una por una
    for ($j = 0; $j -lt $m[$i].Length; $j++) {
      $x = $m[$i][$j]
      write-host -nonewline $x " "
    }
    write-host ""
  }
}

function Verificar_Tipo_Matriz([double[][]] $matriz)
{    
    #Cantidad de filas
    $cant_filas = $matriz.Length
    #Cantidad de columnas
    $cant_columnas = $matriz[0].Length
    
    if($cant_filas -eq $cant_columnas)
    {
        write-host "Matriz Cuadrada, Orden $($cant_filas * $cant_columnas)"
    }
    
    if($cant_filas -eq 1)
    {
        write-host "Matriz Fila"
    }
    
    
    if($cant_columnas -eq 1)
    {
        write-host "Matriz Columna"
    }
    
    if($cant_columnas -ne $cant_filas)
    {
        write-host "Matriz Rectangular"
    }
    
    $es_matriz_nula=$TRUE
    $es_matriz_identidad=$TRUE
    #Recorre las filas una por una
    for($i = 0; $i -lt $matriz.Length; $i++) 
    {
        #Recorre las columnas una por una
        for ($j = 0; $j -lt $matriz[$i].Length; $j++) 
        {
            if($i -eq $j -and $matriz[$i][$j] -ne 1){
                $es_matriz_identidad=$FALSE
            }
            if($i -ne $j -and $matriz[$i][$j] -ne 0){
                $es_matriz_identidad=$FALSE
            }
            if($matriz[$i][$j] -ne 0)
            {
                $es_matriz_nula = $FALSE
            }
        }
    }
    if($es_matriz_nula -eq $TRUE)
    {
        write-host "Matriz Nula"
    }
    
    if($cant_filas -eq $cant_columnas -and $es_matriz_identidad -eq $TRUE)
    {
        write-host "Matriz identidad"
    }
}

try{
    $matriz = Cargar_Matriz_De_Archivo $Path $delim
    Verificar_Tipo_Matriz $matriz
    Mostrar_Matriz $matriz
}
catch{
    Write-Host "El formato del archivo o el delimitador no es el correcto."
    exit
}

            

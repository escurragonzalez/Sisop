#############################################################################################
# PROGRAM-ID.  ejercicio4.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Cuenta las ocurrencias de una palabra en un archivo o              #
# a traves de una redireccion con pipe.                                                     #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ARCHIVOS DE SALIDA :                                                                      #
# COMENTARIOS:                                                                              #
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
Cuenta las ocurrencias de una palabra.
.DESCRIPTION
Cuenta las ocurrencias de una palabra en un archivo. Este archivo se puede especificar mediante el
parametro -path o a traves de una redireccion con pipe.
    
.EXAMPLE
    C:\PS> .\ejercicio4.ps1 -path C:\miArchivo.txt
.EXAMPLE
    C:\PS> .\ejercicio4.ps1 C:\miArchivo.txt
.EXAMPLE
    C:\PS> .\ejercicio4.ps1 cat C:\miArchivo.txt | ./ejercicio4.ps1

.PARAMETER path
Ruta del archivo que desea contar las palabras.

#>
  
  param
  (
    [Parameter(ValueFromPipeline=$true, mandatory = $false)][string]
    $path
  )
   
   
    Function contarPalabras([String]$texto)
    {
        $palabras = @{}
        $cont = 0
        #dejo 1 solo espacio de separacion entre palabras
        $linea = $texto -replace '\s+', ' '
        #remplazo los caracteres que no forman palabras con vacio
        $regex = $linea -replace '[^\sa-zA-Z0-9]', ''
        $camposLinea = $regex.Split(" ")
        foreach($auxCampos in $camposLinea)
        {             
                $marca = 0
                #recorro el hashtable para ver si existe la palabra de la linea en el 
                foreach($auxPalabras in $palabras.Keys)
                {                
                    if($auxPalabras -eq $auxCampos)
                    {
                   
                        $palabras[$auxPalabras]++
                        $marca = 1
                        break
                    }
                }   
                if($marca -eq 0 -and $auxCampos -ne "")
                {
                    $palabras.Add($auxCampos,1)
                }
         }        
          $palabras |  Format-Table -hideTableHeaders  
    } 
   
   
  $cantPar = ($psboundparameters.Count + $args.Count)

  #VALIDACION 
  if($cantPar -ne 1 -or $path -eq "")
  {
    echo "Llamada invalida"
    exit
  }

   if($input)
   {
       contarPalabras $input
       exit
   }
   else
   {
        $pathValido = Test-Path $path;
        if($pathValido -eq $false)
        {
        echo "Path de archivo no valido.";
        exit;
        }

        if(test-path $path -PathType Container)
        {
        echo "Debe especificar un archivo de texto, no un directorio.";
        exit;
        }
       try{
           $cadena = (Get-Content $path -Delimiter "\n")
           contarPalabras $cadena
           exit
       }
       catch
       {
           Write-Output "Error al leer archivo"
       }
   }
   
  
#!/bin/bash
V_FLAG=0;
MensajeVersion(){
        echo "SCRIPT 3 - Sistemas Operativos" 
        echo "Version 1.0.1"
        echo "GRUPO 7"
}
MensajeUso(){
        echo "Uso: ./script3 [-v] <numero>"
        echo
        echo "Opciones:"
        echo "  -v        Mostrar version"
        echo
        echo "Argumentos:"
        echo "  numero    Numero a calcular potenica cúbica"
        echo
        echo "Ejemplo:"
        echo "  ./script3 3.5"
}
MensajeError(){
        echo "#############################"
        echo "#ERROR: MAL USO DEL COMANDO!#"
        echo "#############################"
}
# main
# OPCIONES
while getopts ":v" option; do
        case $option in
                v) # Mostrar version e info
                        V_FLAG=1;
                        shift $((OPTIND - 1));;
                \?) # Opcion invalida
                        MensajeError
                        MensajeUso
                        exit;;
        esac
done
# Verifico flag VERSION
if [[ V_FLAG -eq 1 ]]; then 
        MensajeVersion
        MensajeUso
        exit 0
fi
# Verifico si se ingresó num o lo pido
numeroIngresado="$1"
if [[ -z "$numeroIngresado" ]]; then
    read -p "Ingrese el numero a operar: " numeroIngresado
fi

# Validar que sea un número entero o flotante
if ! [[ $numeroIngresado =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    MensajeError
    exit 1
fi

# Calcular la cúbica usando bc (admite flotante)
cubicaNumero=$(echo "$numeroIngresado^3" | bc -l)

# Mensaje
mensajeResultado="La cúbica de $numeroIngresado es: $cubicaNumero"

# Enviar a todos los usuarios conectados
wall "$mensajeResultado"

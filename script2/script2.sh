#!/bin/bash
V_FLAG=0;
MensajeVersion(){
        echo "SCRIPT 2 - Sistemas Operativos" 
        echo "Version 1.0.1"
        echo "GRUPO 7"
}
MensajeUso(){
        echo "Uso: ./script2 [-v] <nombre_archivo>"
        echo
        echo "Opciones:"
        echo "  -v        Mostrar version"
        echo
        echo "Argumentos:"
        echo "  nombre_archivo    Nombre de archivo a modificar"
        echo
        echo "Ejemplo:"
        echo "  ./script2 documento_1.docx"
}
MensajeError(){
        echo "#############################"
        echo "#ERROR: MAL USO DEL COMANDO!#"
        echo "#############################"
}

## MAIN
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
# Verifico si se ingresó archivo o lo leo
archivo_a_buscar="$1"
if [[ -z "$archivo_a_buscar" ]]; then
    read -p "Ingrese el nombre del archivo: " archivo_a_buscar
fi

archivos_a_modificar=$(find / -type f -name "$archivo_a_buscar" 2>/dev/null)
archivos_modificados_lista=()

# Buscar archivos con ese nombre en todo el sistema
while IFS= read -r archivo; do
    # Agrego permiso escritura a resto
    chmod a+w $archivo
    # Agrego nombre archivo a lista
    archivos_modificados+=("$archivo")
done <<< $archivos_a_modificar

# Mostrar archivos modificados
echo "Archivos modificados:"
for f in "${archivos_modificados[@]}"; do
    echo "  $f"
done

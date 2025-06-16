#!/bin/bash
# INSTALACION:
# Guardar 4 scripts en ~/scripts-so
# 
# Agregar al archivo ~/.bash_profile la linea:
# ~/scripts-so/script4.sh
MensajeVersion(){
    echo "========================="
    echo " SCRIPT 4 - Sistemas Operativos" 
    echo " Version 1.0.1"
    echo " GRUPO 7"
    echo "========================="
}

MensajeVersion
while true; do
    clear
    echo "1) Ejecutar script 1 (FS HOME DIR por usuario)"
    echo "2) Ejecutar script 2 (Permisos escritura archivo)" 
    echo "3) Ejecutar script 3 (Cubica de numero)"
    echo "4) Salir"
    echo
    read -p "Ingrese una opción [1-4]: " opcion

    case "$opcion" in
        1) ~/scripts-so/script1.sh ;;
        2) ~/scripts-so/script2.sh ;;
        3) ~/scripts-so/script3.sh ;;
        4) echo "Saliendo..."; break ;;
        *) echo "Opción inválida. Presione Enter para continuar..."; read ;;
    esac
    read -p "Presione Enter... " 
done

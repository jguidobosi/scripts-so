#!/bin/bash
T_FLAG=0;
MB_FLAG=0;
V_FLAG=0;

# Imprimir fila de tabla
ImprimirComoTabla(){
        printf "%-20s %-25s %-25s %-15s %-15s\n" "$1" "$2" "$3" "$4" "$5"
}
MensajeVersion(){
        echo "SCRIPT 1 - Sistemas Operativos" 
        echo "Version 1.0.1"
        echo "GRUPO 7"
}
MensajeUso(){
        echo "Uso: ./script1 [-v] [-t] [-M] <usuario>"
        echo
        echo "Opciones:"
        echo "  -v        Mostrar version"
        echo "  -t        Incluir todos los usuarios del sistema"
        echo "  -M        Usar MegaByte como unidad"
        echo
        echo "Argumentos:"
        echo "  usuario    Nombre de usuario o UID"
        echo
        echo "Ejemplo:"
        echo "  ./script1 -M fulano_de_tal"
}
MensajeError(){
        echo "#############################"
        echo "#ERROR: MAL USO DEL COMANDO!#"
        echo "#############################"
}
# Procesa un usuario pasado como argumento e imprime el resultado
ProcesarUsuario() {
        # Consigo datos de usuario
        DATAUSR=$(getent passwd $1)
        USRUID=$(echo $DATAUSR | cut -d: -f3)
        NOMUSR=$(echo $DATAUSR | cut -d: -f1)
        HOME_DIR=$(echo $DATAUSR | cut -d: -f6)
        # Consigo montaje FS donde se encuentra HOME
        FS=$(df -P $HOME_DIR 2> /dev/null | tail -n1 | awk '{print $6}')
        # Espacio del FS
	ESPACIO_FS_KB=$(df $FS | tail -n1 | awk '{print $2}')
        ESPACIO_FS_MB=$(( ESPACIO_FS_KB / 1024 ))
        # Espacio HOME
        ESPACIO_OCUPADO_POR_HOME_KB=$(du $HOME_DIR 2>/dev/null | tail -n1 | awk '{print $1}')
	# Porcentaje de HOME en FS (Protejo división por 0)
        if [[ $ESPACIO_FS_KB -le "0" ]]; then	
		PORC_OCUPADO_POR_HOME=0
	else
		PORC_OCUPADO_POR_HOME="$(( ESPACIO_OCUPADO_POR_HOME_KB * 100 / ESPACIO_FS_KB ))%"
	fi
        # Porcentaje total ocupado del FS
        PORC_OCUPADO_DEL_FS=$(df $FS 2>/dev/null | tail -n1 | awk '{print $5}')

        # Imprimo (MB o KB)
        if [[ $MB_FLAG == 1 ]]
        then
                ImprimirComoTabla "$NOMUSR UID:$USRUID" $HOME_DIR "$ESPACIO_FS_MB MB" $PORC_OCUPADO_POR_HOME $PORC_OCUPADO_DEL_FS >> /tmp/script1_output.txt
        else
                ImprimirComoTabla "$NOMUSR UID:$USRUID" $HOME_DIR "$ESPACIO_FS_KB KB" $PORC_OCUPADO_POR_HOME $PORC_OCUPADO_DEL_FS >> /tmp/script1_output.txt
        fi
}

# Procesa a todos los usuarios del sistema e imprime resultado
ProcesarTodosLosUsuarios(){
        # Usuarios ordenados por nombre de grupo
        ALL_USERS_ORDERED=$(getent passwd | while IFS=: read -r NOMUSR _ _ IDGRP _ _ _; do
                NOMGRP=$(getent group "$IDGRP" | cut -d: -f1)
                echo "$NOMGRP $NOMUSR"
        done | sort | awk '{ print $2 }')
        # Proceso usuarios ordenados 
        while IFS= read -r USER; do
                ProcesarUsuario $USER
        done <<< "$ALL_USERS_ORDERED"
}

### MAIN ###
# OPCIONES
while getopts ":tMv" option; do
        case $option in
                t) # Todos los usuarios
                        T_FLAG=1;
                        shift $((OPTIND - 1));;
                M) # FS en MB
                        MB_FLAG=1;
                        shift $((OPTIND - 1));;
                v) # Mostrar version e info
                        V_FLAG=1;
                        shift $((OPTIND - 1));;
                \?) # Opcion invalida
                        echo "Error: Opcion invalida"
                        exit;;
        esac
done
# Verifico uso correcto del comando
if [[ ($# -eq 0 && $T_FLAG -eq 0) || ( $V_FLAG && ($MB_FLAG -eq 1 || $T_FLAG -eq 1) ) ]]; then
        MensajeError
        MensajeUso
        exit 1
fi
# Verifico flag VERSION
if [[ V_FLAG -eq 1 ]]; then 
        MensajeVersion
        MensajeUso
        exit 0
fi
# Verifico si se ingresó usuario
USER_INGRESADO="$1"
if [[ -z "$USER_INGRESADO" && $T_FLAG -eq 0 ]]; then
    read -p "Ingrese el nombre de usuario: " USER_INGRESADO
fi
# Primer linea de tabla en archivo temporal
ImprimirComoTabla "Usuario" "Home" "FileSystem" "Ocupa" "% Ocupado FS" > /tmp/script1_output.txt
# Verif opcion t
if [[ $T_FLAG == 1 ]]
then
        ProcesarTodosLosUsuarios
else
        ProcesarUsuario $USER_INGRESADO
fi
# Escribo con CAT o LESS en base a num. de paginas
if [[ "$(wc -l < "/tmp/script1_output.txt")" -gt "$(tput lines)" ]]; then
        less /tmp/script1_output.txt
else
        cat /tmp/script1_output.txt
fi
# Borro archivo temporal
rm -f /tmp/script1_output.txt
# FIN

#!/bin/bash
echo "
                                                           ############
                                                           ################
                                                                       ######
                                                          #########       ####
                                                         #############     ####
                       ####                                       ######    ####
                      #######                                        ####    ###
                      ########                              ##        ####   ####
                     ####  #####                          ########     ###    ###
                    ####     #####                             ####    ####   ###
                    ####       #####                  #######   ###     ###  ####
                    ###          #####               #########  ###    ####  ###
                   ####            #####             ###   ###         ###
                   ###              ######           #########
                   ###                #####        #########
                   ###                  #####    #####
                   ####                   ##########
                    ###                     #######
                    ###                       ####
                    ####                       #####
                     ###                         #####
                      ###                          #####
                      ####                           #####
                       ####                            #####
                        #####                           ######
                          ####                            #####
                           #####                            #####
                             #####                            #####
                               ######                           #####
                              ##########                         #####
                              ####  #########              #########
                            ####        #########################
                            ####            ##############
                           ####              ###
                          ####                ###
                         ####                 ####
                        ####                   ####
                       ####                     ####
                      ####                       ####
                     ####                         ####
                    ##################################
                     ################################

"
# Función para mostrar una barra de progreso con calaveras grandes y porcentaje
show_progress() {
    local duration=$1
    local interval=1
    local total_steps=$((duration / interval))
    local progress=0

    while [ $progress -lt $total_steps ]; do
        progress=$((progress + 1))
        local percent=$((progress * 100 / total_steps))
        local skulls=$((percent / 10))
        local spaces=$((10 - skulls))

        echo -ne "["
        for ((i = 0; i < skulls; i++)); do echo -ne "💀"; done
        for ((i = 0; i < spaces; i++)); do echo -ne " "; done
        echo -ne "] $percent%\\r"

        sleep $interval
    done
    echo -ne "\n"
}

# Iniciar la barra de progreso en segundo plano
show_progress 50 &  # Duración estimada de 50 segundos
PROGRESS_PID=$!

# Medir la velocidad de Internet
echo "Realizando la medición........"
result=$(speedtest-cli --json)

# Detener la barra de progreso
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null

# Guardar los resultados en variables usando jq para parsear el JSON
DOWNLOAD_SPEED=$(echo $result | jq '.download' | awk '{print $1/1000000}')
UPLOAD_SPEED=$(echo $result | jq '.upload' | awk '{print $1/1000000}')
PING=$(echo $result | jq '.ping')
SERVER_NAME=$(echo $result | jq -r '.server.name')
SERVER_LOCATION=$(echo $result | jq -r '.server.location')
SERVER_COUNTRY=$(echo $result | jq -r '.server.country')

# Mostrar los resultados de forma vistosa
echo -e "\n\033[1;34m-----------------------------------------------\033[0m"
echo -e "\n\033[1;34mResultados de la prueba de velocidad de Internet:\033[0m"
echo -e "\033[1;34mLatencia (Ping):\033[0m  \033[1;32m$PING ms\033[0m"
echo -e "\033[1;34mVelocidad de descarga:\033[0m  \033[1;32m$DOWNLOAD_SPEED Mbps\033[0m"
echo -e "\033[1;34mVelocidad de subida:\033[0m  \033[1;32m$UPLOAD_SPEED Mbps\033[0m"
echo -e "\033[1;34mServidor:\033[0m  \033[1;32m$SERVER_NAME\033[0m"
echo -e "\033[1;34mUbicación del servidor:\033[0m  \033[1;32m$SERVER_LOCATION, $SERVER_COUNTRY\033[0m"
echo -e "\n\033[1;34m-----------------------------------------------\033[0m"
echo -e "\n\033[1;31m------------------------------------------------\033[1;31m-"
# Línea del autor
echo -e "\033[1;31m- Autor: DANIEL GIL MARTINEZ \033[0m"

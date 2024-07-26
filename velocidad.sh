
#!/bin/bash

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
show_progress 30 &  # Duración estimada de 30 segundos
PROGRESS_PID=$!

# Medir la velocidad de Internet
echo "Midiendo la velocidad de Internet..."
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
echo -e "\n\033[1;34mResultados de la prueba de velocidad de Internet:\033[0m"
echo -e "-----------------------------------------------"
echo -e "Latencia (Ping): \033[1;32m$PING ms\033[0m"
echo -e "Velocidad de descarga: \033[1;32m$DOWNLOAD_SPEED Mbps\033[0m"
echo -e "Velocidad de subida: \033[1;32m$UPLOAD_SPEED Mbps\033[0m"
echo -e "Servidor: \033[1;32m$SERVER_NAME\033[0m"
echo -e "Ubicación del servidor: \033[1;32m$SERVER_LOCATION, $SERVER_COUNTRY\033[0m"
echo -e "-----------------------------------------------"

# Despedida con arte ASCII "ADIOS"

echo -e "\033[1;31m"
echo -e "  _____   ____  _      ____  _____ \n / ____| / __ \\| |    / __ \\|  __ \\ \n| (___  | |  | | |   | |  | | |  | |\n \\___ \\ | |  | | |   | |  | | |  | |\n ____) || |__| | |___| |__| | |__| |\n|_____/  \\____/|______ \\____/ \\____/ \n                   |____/           "
echo -e " \033[0m"

# Línea del autor
echo -e "\033[1;31m- Creado por: DANIEL GIL MARTINEZ \033[0m"

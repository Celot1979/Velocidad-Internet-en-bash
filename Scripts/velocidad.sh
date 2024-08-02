#!/bin/bash

# Arte ASCII de una antena parabólica
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
                              ####  #########              ##########                               
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
show_progress 30 &  # Duración estimada de 30 segundos
PROGRESS_PID=$!

# Crear y activar el entorno virtual
VENV_DIR="/home/dani/entorno_vir"
if [ ! -d "$VENV_DIR" ]; then
    echo "El entorno virtual no existe. Creándolo..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Verificar e instalar las bibliotecas necesarias
pip install --upgrade pip
pip install --upgrade speedtest requests

# Crear el script de Python para medir la velocidad de Internet
cat << 'EOF' > /tmp/speedtest_script.py
import speedtest
import requests
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def test_speedtest():
    st = speedtest.Speedtest()
    st.download()
    st.upload()
    results = st.results.dict()
    return {
        'download': results["download"] / 1_000_000,  # Convertir a Mbps
        'upload': results["upload"] / 1_000_000,      # Convertir a Mbps
        'ping': results["ping"],
        'server': results["server"]["name"],
        'location': results["server"]["location"]
    }

def test_requests():
    # Implementa una prueba de velocidad utilizando la biblioteca requests
    # Aquí solo se muestra un ejemplo simplificado
    download_speed = requests.get('https://speed.hetzner.de/100MB.bin').elapsed.total_seconds()
    upload_speed = download_speed * 1.2  # Solo como ejemplo, debes implementar la lógica real
    ping = requests.get('https://www.google.com').elapsed.total_seconds() * 1000
    return {
        'download': download_speed,
        'upload': upload_speed,
        'ping': ping,
        'server': 'Hetzner Online GmbH',
        'location': 'Germany'
    }

# Realizar las pruebas de velocidad
results_speedtest = test_speedtest()
results_requests = test_requests()

# Crear el mensaje de correo electrónico
sender = "tu_correo@example.com"
receiver = "zata_k@hotmail.com"
subject = "Resultados de la prueba de velocidad de Internet"
body = f"""
Resultados de la prueba de velocidad de Internet utilizando speedtest:
-----------------------------------------------
Latencia (Ping): {results_speedtest['ping']} ms
Velocidad de descarga: {results_speedtest['download']:.2f} Mbps
Velocidad de subida: {results_speedtest['upload']:.2f} Mbps
Servidor: {results_speedtest['server']}
Ubicación del servidor: {results_speedtest['location']}

Resultados de la prueba de velocidad de Internet utilizando requests:
-----------------------------------------------
Latencia (Ping): {results_requests['ping']} ms
Velocidad de descarga: {results_requests['download']:.2f} Mbps
Velocidad de subida: {results_requests['upload']:.2f} Mbps
Servidor: {results_requests['server']}
Ubicación del servidor: {results_requests['location']}
-----------------------------------------------
"""

msg = MIMEMultipart()
msg['From'] = sender
msg['To'] = receiver
msg['Subject'] = subject
msg.attach(MIMEText(body, 'plain'))

# Enviar el correo electrónico
try:
    with smtplib.SMTP('smtp.example.com', 587) as server:
        server.starttls()
        server.login(sender, 'tu_contraseña')
        server.sendmail(sender, receiver, msg.as_string())
except Exception as e:
    print(f"Error al enviar el correo electrónico: {e}")

# Imprimir los resultados en la consola
print(body)

# Firma
print("\033[1;31m- Creado por: DANIEL GIL MARTINEZ \033[0m")
EOF

# Ejecutar el script de Python
python /tmp/speedtest_script.py

# Detener la barra de progreso
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null

# Desactivar el entorno virtual
deactivate

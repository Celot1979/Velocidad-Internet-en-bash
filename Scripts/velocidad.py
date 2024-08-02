import requests
import time
from ping3 import ping
import tempfile
import os

# URL para prueba de velocidad de descarga
DOWNLOAD_URL = 'https://speed.hetzner.de/100MB.bin'  # Archivo grande para prueba de velocidad

# URL para prueba de subida (debe ser un endpoint de prueba que acepte archivos)
UPLOAD_URL = 'https://httpbin.org/post'

def measure_download_speed(url):
    try:
        # Descarga un archivo grande para medir la velocidad de descarga
        start_time = time.time()
        response = requests.get(url, stream=True)
        total_size = 0
        for chunk in response.iter_content(chunk_size=8192):
            total_size += len(chunk)
        end_time = time.time()
        elapsed_time = end_time - start_time
        speed_mbps = (total_size * 8) / (elapsed_time * 1_000_000)  # Convertir a Mbps
        return speed_mbps
    except Exception as e:
        print(f"Error en la medición de descarga: {e}")
        return None

def measure_upload_speed(url):
    try:
        # Crear un archivo temporal de prueba de tamaño fijo
        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
            file_name = temp_file.name
            temp_file.write(b'0' * 100_000_000)  # 100 MB

        start_time = time.time()
        with open(file_name, 'rb') as f:
            response = requests.post(url, files={'file': f})
        end_time = time.time()

        elapsed_time = end_time - start_time
        os.remove(file_name)  # Eliminar el archivo temporal
        speed_mbps = 100 / elapsed_time  # Convertir a Mbps
        return speed_mbps
    except Exception as e:
        print(f"Error en la medición de subida: {e}")
        return None

def measure_ping(host):
    try:
        ping_time = ping(host) * 1000  # Convertir segundos a milisegundos
        return ping_time
    except Exception as e:
        print(f"Error en la medición de ping: {e}")
        return None

def main():
    # Medir la velocidad de descarga
    download_speed = measure_download_speed(DOWNLOAD_URL)
    if download_speed is not None:
        print(f"Velocidad de descarga: {download_speed:.2f} Mbps")

    # Medir la velocidad de subida
    upload_speed = measure_upload_speed(UPLOAD_URL)
    if upload_speed is not None:
        print(f"Velocidad de subida: {upload_speed:.2f} Mbps")

    # Medir el ping
    ping_time = measure_ping('google.com')
    if ping_time is not None:
        print(f"Latencia (Ping): {ping_time:.2f} ms")

if __name__ == "__main__":
    main()

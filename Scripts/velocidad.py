import tkinter as tk
from tkinter import messagebox
import speedtest
import threading

class InternetSpeedTestApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Test de velocidad")

        self.label = tk.Label(root, text="Test de velocidad", font=("Arial", 16))
        self.label.pack(pady=10)

        self.test_button = tk.Button(root, text="Comenzar test", command=self.start_test)
        self.test_button.pack(pady=10)

        self.result_label = tk.Label(root, text="", font=("Arial", 12))
        self.result_label.pack(pady=10)

    def start_test(self):
        self.result_label.config(text="Haciendo la medición ...")
        self.test_button.config(state=tk.DISABLED)
        threading.Thread(target=self.run_speedtest).start()

    def run_speedtest(self):
        try:
            st = speedtest.Speedtest()
            st.download()
            st.upload()
            results = st.results.dict()

            download_speed = results["download"] / 1_000_000  # Convert to Mbps
            upload_speed = results["upload"] / 1_000_000      # Convert to Mbps
            ping = results["ping"]
            server = results["server"]["name"]
            location = results["server"].get("location", "Unknown")  # Manejar la ausencia de 'location'

            result_text = (
                f"Velocidad de descarga: {download_speed:.2f} Mbps\n"
                f"Velocidad de subida: {upload_speed:.2f} Mbps\n"
                f"Ping: {ping} ms\n"
                f"Servidor: {server}\n"
                f"Localización: {location}"
            )

            self.result_label.config(text=result_text)
        except KeyError as e:
            self.result_label.config(text="No se pudieron recuperar algunos resultados de la prueba.")
            messagebox.showerror("Error", f"Falta clave en los resultados: {e}")
        except Exception as e:
            self.result_label.config(text="No se pudo realizar la prueba de velocidad.")
            messagebox.showerror("Error", str(e))
        finally:
            self.test_button.config(state=tk.NORMAL)

if __name__ == "__main__":
    root = tk.Tk()
    app = InternetSpeedTestApp(root)
    root.mainloop()

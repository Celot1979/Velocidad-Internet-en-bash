import tkinter as tk
from tkinter import messagebox
import speedtest
import threading

class InternetSpeedTestApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Internet Speed Test")

        self.label = tk.Label(root, text="Internet Speed Test", font=("Arial", 16))
        self.label.pack(pady=10)

        self.test_button = tk.Button(root, text="Start Test", command=self.start_test)
        self.test_button.pack(pady=10)

        self.result_label = tk.Label(root, text="", font=("Arial", 12))
        self.result_label.pack(pady=10)

    def start_test(self):
        self.result_label.config(text="Testing...")
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
                f"Download Speed: {download_speed:.2f} Mbps\n"
                f"Upload Speed: {upload_speed:.2f} Mbps\n"
                f"Ping: {ping} ms\n"
                f"Server: {server}\n"
                f"Location: {location}"
            )

            self.result_label.config(text=result_text)
        except KeyError as e:
            self.result_label.config(text="Failed to retrieve some test results.")
            messagebox.showerror("Error", f"Missing key in results: {e}")
        except Exception as e:
            self.result_label.config(text="Failed to perform the speed test.")
            messagebox.showerror("Error", str(e))
        finally:
            self.test_button.config(state=tk.NORMAL)

if __name__ == "__main__":
    root = tk.Tk()
    app = InternetSpeedTestApp(root)
    root.mainloop()

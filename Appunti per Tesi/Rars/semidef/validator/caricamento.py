import serial
import time
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import threading

# Configurazione porta (modifica se necessario)
PORTA = 'COM3'
BAUD = 115200

class SerialApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Invio File a Arduino")
        self.root.geometry("400x200")

        self.file_path = None
        self.ser = None

        # Pulsanti
        self.btn_select = tk.Button(root, text="Seleziona File", command=self.seleziona_file)
        self.btn_select.pack(pady=10)

        self.label_file = tk.Label(root, text="Nessun file selezionato")
        self.label_file.pack()

        self.btn_send = tk.Button(root, text="Invia alla ESP32c3", command=self.invia_file)
        self.btn_send.pack(pady=10)

        # Area log
        self.log_area = scrolledtext.ScrolledText(root, height=15)
        self.log_area.pack(fill="both", expand=True, padx=10, pady=10)

    def log(self, messaggio):
        self.log_area.insert(tk.END, messaggio + "\n")
        self.log_area.see(tk.END)

    def seleziona_file(self):
        self.file_path = filedialog.askopenfilename()
        if self.file_path:
            self.label_file.config(text=self.file_path)
            self.log(f"File selezionato: {self.file_path}")

    def invia_file(self):
        if not self.file_path:
            messagebox.showerror("Errore", "Seleziona prima un file!")
            return
        
        threading.Thread(target=self._invia_thread).start()

    def _invia_thread(self):
        try:
            self.log("Connessione alla ESP32c3...")
            self.ser = serial.Serial(PORTA, BAUD, timeout=1)
            time.sleep(2)
            self.ser.reset_input_buffer()

            with open(self.file_path, 'rb') as f:
                dati_binari = f.read()

            if not dati_binari:
                self.log("connessione alla ESP32c3.")
                return

            contenuto_hex = dati_binari.hex()
            messaggio = contenuto_hex + '\n'

            self.ser.write(messaggio.encode('utf-8'))

            self.log(f"File letto ({len(dati_binari)} byte)")
            self.log(f"Inviati {len(contenuto_hex)} caratteri esadecimali")
            self.log("Guarda l'esito sulla scheda.")

            time.sleep(20)

            while self.ser.in_waiting > 0:
                risposta = self.ser.readline().decode(errors='ignore').strip()
                self.log("ESP: " + risposta)

            self.ser.close()
            self.log("Connessione chiusa.")

        except Exception as e:
            self.log(f"Errore: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = SerialApp(root)
    root.mainloop()
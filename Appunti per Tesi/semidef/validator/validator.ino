extern "C" {
  void main_validator(const char* inizio, const char* fine); 
}

#define MAX_BUFFER_SIZE 1000 // Sovradimensionato per 414 char
char inputBuffer[MAX_BUFFER_SIZE];
int bufferIndex = 0;

void setup() {
  // 1. AUMENTIAMO IL BUFFER DI RICEZIONE A LIVELLO HARDWARE
  // Lo impostiamo a 512 così i tuoi 414 char entrano tutti in un colpo solo
  Serial.setRxBufferSize(512); 
  
  Serial.begin(115200);
  
  pinMode(8, OUTPUT);
  digitalWrite(8, HIGH); 

}

void loop() {
  // 2. USIAMO UN CICLO WHILE AGGRESSIVO
  // Finché c'è roba nel buffer, non fare nient'altro
  while (Serial.available() > 0) {
    char c = Serial.read();

    // Se arrivano caratteri di fine riga, processiamo
    if (c == '\n' || c == '\r') {
      if (bufferIndex > 0) {
        inputBuffer[bufferIndex] = '\0'; // Terminatore stringa
        
        Serial.print("Ricevuti: ");
        Serial.print(bufferIndex);
        Serial.println(" caratteri.");

        // Chiamata alla tua funzione C
        main_validator(inputBuffer, inputBuffer + bufferIndex);
        
        bufferIndex = 0; // Reset
      }
    } 
    else {
      if (bufferIndex < MAX_BUFFER_SIZE - 1) {
        inputBuffer[bufferIndex++] = c;
      }
    }
  }
  
  // 3. PICCOLO TRUCCO: Evita che il processore faccia altro per un istante
  yield(); 
}
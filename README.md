# Script per la Gestione della Carica della Batteria su ThinkPad X230

Questo repository contiene una serie di script per gestire le soglie di carica della batteria su portatili ThinkPad (specificamente testato su un X230 con Fedora) che espongono le interfacce di controllo tramite `sysfs`.

L'obiettivo è quello di estendere la vita utile della batteria limitando la carica massima quando il portatile è usato prevalentemente con l'alimentatore collegato.

## Contenuto

- `scripts/batt`: Uno script da riga di comando per cambiare facilmente i profili di carica.
- `systemd/`: Contiene i file di servizio `systemd` per applicare i profili in modo persistente o al bisogno.

## Prerequisiti

Assicurati che il tuo sistema supporti nativamente il controllo della carica. Verifica l'esistenza dei seguenti file:

```bash
ls /sys/class/power_supply/BAT0/charge_control_end_threshold
```

Se il file esiste, sei pronto per procedere.

## Installazione

### 1. Script `batt`

Copia lo script `batt` in una cartella inclusa nel tuo `$PATH` e rendilo eseguibile.

```bash
# Copia lo script
sudo cp scripts/batt /usr/local/bin/batt

# Rendi lo script eseguibile
sudo chmod +x /usr/local/bin/batt
```

### 2. Servizi `systemd`

Copia i file `.service` nella cartella dei servizi di sistema.

```bash
# Copia i file di servizio
sudo cp systemd/*.service /etc/systemd/system/

# Ricarica il demone di systemd per fargli leggere i nuovi file
sudo systemctl daemon-reload
```

## Utilizzo

### Comando `batt`

Lo script `batt` è il modo più semplice per gestire le soglie al volo.

- **Imposta profilo longevità (carica 40%-80%):**
  ```bash
  sudo batt 80
  ```

- **Sblocca la carica al 100%:**
  ```bash
  sudo batt 100
  ```

- **Controlla le soglie correnti:**
  ```bash
  batt status
  ```

- **Mostra l'aiuto:**
  ```bash
  batt help
  ```

### Profili all'avvio (Systemd)

Se vuoi che un profilo specifico venga applicato automaticamente ad ogni avvio del sistema, abilita il servizio corrispondente.

- **Per abilitare il profilo longevità (40-80) all'avvio:**
  ```bash
  sudo systemctl enable battery-threshold-40-80.service
  ```

- **Per disabilitare il profilo all'avvio e tornare al comportamento di default (0-100):**
  ```bash
  sudo systemctl disable battery-threshold-40-80.service
  ```

**Nota:** Puoi usare i comandi `systemctl start <nome-servizio>` per attivare un profilo una tantum, ma l'uso dello script `batt` è generalmente più comodo.

## Note e Conflitti

Se utilizzi altri strumenti di gestione energetica come **TLP**, potrebbero sovrascrivere queste impostazioni. I servizi `systemd` forniti sono configurati per essere eseguiti *dopo* TLP (`After=tlp.service`), ma se TLP è configurato per gestire le soglie di carica, potrebbe comunque interferire.

In caso di conflitti, puoi:

1.  Disabilitare la gestione delle soglie di carica in TLP (commentando le righe `START_CHARGE_THRESH_BAT0` e `STOP_CHARGE_THRESH_BAT0` in `/etc/tlp.conf`).
2.  Disabilitare completamente TLP con `sudo systemctl disable --now tlp`.

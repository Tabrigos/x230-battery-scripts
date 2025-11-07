# Script per la Gestione della Carica della Batteria su ThinkPad

Questo repository contiene uno script per gestire le soglie di carica della batteria su portatili (specificamente testato su un ThinkPad X230 con Fedora) che espongono le interfacce di controllo tramite `sysfs`.

L'obiettivo è quello di estendere la vita utile della batteria limitando la carica massima quando il portatile è usato prevalentemente con l'alimentatore collegato.

## Architettura

La logica è centralizzata nello script `scripts/batt`. Questo strumento si occupa di:
- Trovare il percorso corretto della batteria.
- Impostare le soglie di carica.
- Gestire l'abilitazione e la disabilitazione del servizio `systemd` per la persistenza al riavvio.
- **Avvisare l'utente se rileva software in conflitto come TLP.**

Un singolo file di servizio `systemd` (`set-battery-threshold.service`) viene usato come trigger per eseguire `batt 80` all'avvio del sistema, se abilitato.

## Prerequisiti

Lo script rileva automaticamente la batteria, ma richiede che il sistema esponga i file di controllo in `/sys/class/power_supply/BAT*/`.

## Installazione

1.  **Copia lo script `batt`** in un percorso di sistema e rendilo eseguibile:

    ```bash
    sudo cp scripts/batt /usr/local/bin/batt
    sudo chmod +x /usr/local/bin/batt
    ```

2.  **Copia il file di servizio `systemd`**:

    ```bash
    sudo cp systemd/set-battery-threshold.service /etc/systemd/system/
    ```

3.  **Ricarica il demone di `systemd`** per fargli riconoscere il nuovo servizio:

    ```bash
    sudo systemctl daemon-reload
    ```

## Utilizzo

Lo script `batt` è l'unico comando di cui hai bisogno.

- **Imposta profilo longevità (carica 40%-80%) al volo:**
  ```bash
  sudo batt 80
  ```

- **Sblocca la carica al 100% al volo:**
  ```bash
  sudo batt 100
  ```

- **Abilita il profilo longevità all'avvio del sistema:**
  ```bash
  sudo batt enable
  ```

- **Disabilita il profilo longevità all'avvio:**
  ```bash
  sudo batt disable
  ```

- **Controlla le soglie correnti:**
  ```bash
  batt status
  ```

- **Mostra l'aiuto:**
  ```bash
  batt help
  ```

## Note e Conflitti

Se utilizzi altri strumenti di gestione energetica come **TLP**, questi potrebbero sovrascrivere le impostazioni dello script. 

Per migliorare l'esperienza utente, **lo script rileva se il servizio TLP è attivo e mostra un avviso** in caso di potenziale conflitto. Si raccomanda comunque di disabilitare la gestione delle soglie di carica direttamente in TLP (commentando le righe `START_CHARGE_THRESH_BAT0` e `STOP_CHARGE_THRESH_BAT0` in `/etc/tlp.conf`) per evitare comportamenti inattesi.

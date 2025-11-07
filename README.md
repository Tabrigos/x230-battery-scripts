# Script per la Gestione della Carica della Batteria su ThinkPad

Questo repository contiene uno script per gestire le soglie di carica della batteria su portatili (specificamente testato su un ThinkPad X230 con Fedora) che espongono le interfacce di controllo tramite `sysfs`.

L'obiettivo è quello di estendere la vita utile della batteria limitando la carica massima quando il portatile è usato prevalentemente con l'alimentatore collegato.

## Novità

- **Installazione e Disinstallazione Semplificate**: Introdotti gli script `install.sh` e `uninstall.sh` per una gestione più agevole del tool.
- **Miglioramenti alla Sicurezza**: Lo script `batt` ora implementa il Principio del Minimo Privilegio. Non è più necessario eseguirlo interamente con `sudo`; la richiesta di password avverrà solo per le operazioni che modificano lo stato del sistema.

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

Per installare il tool, clona il repository ed esegui lo script `install.sh` con privilegi di root:

```bash
# Esegui lo script di installazione
sudo ./install.sh
```

Lo script si occuperà di copiare i file nelle posizioni corrette e di ricaricare i servizi di sistema.

## Disinstallazione

Per rimuovere completamente il tool dal sistema, esegui lo script `uninstall.sh` con privilegi di root dalla directory del progetto:

```bash
# Esegui lo script di disinstallazione
sudo ./uninstall.sh
```

## Utilizzo

Lo script `batt` è l'unico comando di cui hai bisogno. **Non è più necessario eseguirlo interamente con `sudo`**. La richiesta di password avverrà automaticamente solo per le operazioni che richiedono privilegi elevati (es. impostare le soglie o abilitare/disabilitare il servizio systemd).

- **Imposta profilo longevità (carica 40%-80%) al volo:**
  ```bash
  batt 80
  ```

- **Sblocca la carica al 100% al volo:**
  ```bash
  batt 100
  ```

- **Abilita il profilo longevità all'avvio del sistema:**
  ```bash
  batt enable
  ```

- **Disabilita il profilo longevità all'avvio:**
  ```bash
  batt disable
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

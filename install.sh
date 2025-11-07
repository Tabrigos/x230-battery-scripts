#!/usr/bin/env bash

set -euo pipefail

echo "Installazione di 'batt'..."

# Controlla i privilegi di root
if [[ $EUID -ne 0 ]]; then
  echo "Errore: Questo script deve essere eseguito con privilegi di root (sudo)." >&2
  exit 1
fi

# Definisci i percorsi relativi allo script per robustezza
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_SOURCE="$SCRIPT_DIR/scripts/batt"
SERVICE_SOURCE="$SCRIPT_DIR/systemd/set-battery-threshold.service"

# Definisci le destinazioni
SCRIPT_DEST="/usr/local/bin/batt"
SERVICE_DEST="/etc/systemd/system/set-battery-threshold.service"

# Controlla che i file sorgente esistano
if [ ! -f "$SCRIPT_SOURCE" ]; then
    echo "Errore: File dello script non trovato in '$SCRIPT_SOURCE'." >&2
    echo "Assicurati di eseguire lo script dalla directory principale del progetto o che la struttura sia intatta." >&2
    exit 1
fi

if [ ! -f "$SERVICE_SOURCE" ]; then
    echo "Errore: File di servizio non trovato in '$SERVICE_SOURCE'." >&2
    exit 1
fi

echo "1. Copia dello script in $SCRIPT_DEST..."
cp "$SCRIPT_SOURCE" "$SCRIPT_DEST"

echo "2. Impostazione dei permessi di esecuzione..."
chmod +x "$SCRIPT_DEST"

echo "3. Copia del file di servizio systemd in $SERVICE_DEST..."
cp "$SERVICE_SOURCE" "$SERVICE_DEST"

echo "4. Ricaricamento del demone systemd..."
systemctl daemon-reload

echo ""
echo "Installazione completata con successo!"
echo "Usa 'batt help' per vedere le opzioni disponibili."
echo "Per abilitare il profilo di longevità all'avvio, esegui: sudo batt enable"

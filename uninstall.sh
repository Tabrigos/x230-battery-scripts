#!/usr/bin/env bash

set -euo pipefail

echo "Disinstallazione di 'batt'..."

# Controlla i privilegi di root
if [[ $EUID -ne 0 ]]; then
  echo "Errore: Questo script deve essere eseguito con privilegi di root (sudo)." >&2
  exit 1
fi

# Definisci i percorsi dei file installati
SCRIPT_DEST="/usr/local/bin/batt"
SERVICE_NAME="set-battery-threshold.service"
SERVICE_DEST="/etc/systemd/system/$SERVICE_NAME"

# Rimuovi lo script
if [ -f "$SCRIPT_DEST" ]; then
    echo "1. Rimozione dello script da $SCRIPT_DEST..."
    rm -f "$SCRIPT_DEST"
else
    echo "Info: Lo script '$SCRIPT_DEST' non è stato trovato. Salto."
fi

# Disabilita e rimuovi il servizio systemd
if [ -f "$SERVICE_DEST" ]; then
    echo "2. Disabilitazione del servizio '$SERVICE_NAME' (se attivo)..."
    # Ignora l'errore se il servizio non è abilitato o non esiste più
    systemctl disable "$SERVICE_NAME" >/dev/null 2>&1 || true
    
    echo "3. Rimozione del file di servizio da $SERVICE_DEST..."
    rm -f "$SERVICE_DEST"
else
    echo "Info: Il file di servizio '$SERVICE_DEST' non è stato trovato. Salto."
fi

echo "4. Ricaricamento del demone systemd..."
systemctl daemon-reload

echo ""
echo "Disinstallazione completata."

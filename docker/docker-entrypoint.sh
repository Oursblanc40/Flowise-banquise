#!/bin/sh
set -e

# Créer le répertoire s'il n'existe pas
mkdir -p /opt/flowise/.flowise/storage

# Fixer les permissions si on est root
if [ "$(id -u)" = "0" ]; then
    chown -R node:node /opt/flowise/.flowise
    # Exécuter la commande en tant qu'utilisateur node
    exec su-exec node "$@"
else
    # Si on n'est pas root, exécuter directement
    exec "$@"
fi

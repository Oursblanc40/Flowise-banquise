#!/bin/sh
set -e

mkdir -p /opt/flowise/.flowise/storage

if [ "$(id -u)" = "0" ]; then
    chown -R node:node /opt/flowise/.flowise
    exec su-exec node "$@"
else
    exec "$@"
fi

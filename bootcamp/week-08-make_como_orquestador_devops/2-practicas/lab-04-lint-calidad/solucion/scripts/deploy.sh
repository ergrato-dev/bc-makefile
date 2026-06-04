#!/bin/bash
# Script de despliegue de ejemplo
set -e

APP_DIR=${APP_DIR:-/opt/app}
LOG_FILE=${LOG_FILE:-/var/log/deploy.log}

echo "Desplegando en $APP_DIR..."
mkdir -p "$APP_DIR"
echo "Despliegue completado." | tee -a "$LOG_FILE"

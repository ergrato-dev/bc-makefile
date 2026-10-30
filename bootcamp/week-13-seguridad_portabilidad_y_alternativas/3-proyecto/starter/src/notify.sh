#!/usr/bin/env bash
# notify: envía una notificación al canal del equipo (versión de ejemplo)
set -euo pipefail

msg="${1:?uso: notify.sh MENSAJE}"
printf '[notify] %s\n' "$msg"

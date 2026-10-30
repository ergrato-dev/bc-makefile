#!/usr/bin/env bash
# Convierte un .txt de una línea en un .c que define msg_<idioma>.
# Uso: txt2c.sh IN.txt OUT.c
# Con FALLAR=<idioma> en el entorno, escribe medio archivo y falla (paso 4).
set -euo pipefail

in="$1"
out="$2"
lang="$(basename "$in" .txt)"

echo "const char *msg_${lang} =" > "$out"
if [[ "${FALLAR:-}" == "$lang" ]]; then
  echo "[gen]  $out: fallo simulado a mitad de escritura" >&2
  exit 1
fi
echo "    \"$(cat "$in")\";" >> "$out"
echo "[gen]  $in → $out"

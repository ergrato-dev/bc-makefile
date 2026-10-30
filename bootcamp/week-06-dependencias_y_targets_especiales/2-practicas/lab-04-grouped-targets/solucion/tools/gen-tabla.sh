#!/usr/bin/env bash
# Generador de código: convierte un .def ("nombre valor" por línea) en un par
# NOMBRE.c + NOMBRE.h dentro de OUT_DIR. Una ejecución escribe LOS DOS.
#
# Uso: gen-tabla.sh DEF_FILE OUT_DIR
set -euo pipefail

def_file="$1"
out_dir="$2"
name="$(basename "$def_file" .def)"
upper="$(echo "$name" | tr '[:lower:]' '[:upper:]')"
count="$(grep -c . "$def_file")"

# Simula un generador real (protoc, bison...): tarda un poco
sleep 0.2

{
  echo "#ifndef ${upper}_H"
  echo "#define ${upper}_H"
  echo
  echo "struct entrada { const char *nombre; unsigned valor; };"
  echo "#define ${upper}_N ${count}"
  echo "extern const struct entrada ${name}[${upper}_N];"
  echo
  echo "#endif"
} > "$out_dir/$name.h"

{
  echo "#include \"$name.h\""
  echo
  echo "const struct entrada ${name}[${upper}_N] = {"
  while read -r key value; do
    [[ -n "$key" ]] && echo "    { \"$key\", $value },"
  done < "$def_file"
  echo "};"
} > "$out_dir/$name.c"

echo "[gen]  $out_dir/$name.c + $name.h"

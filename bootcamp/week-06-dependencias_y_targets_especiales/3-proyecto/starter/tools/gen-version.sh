#!/usr/bin/env bash
# Generador de código: lee el archivo VERSION y escribe version.c y version.h
# en el directorio de salida. Produce LOS DOS archivos en cada ejecución.
#
# Uso: gen-version.sh VERSION_FILE OUT_DIR
set -euo pipefail

version_file="$1"
out_dir="$2"
version="$(tr -d '[:space:]' < "$version_file")"

cat > "$out_dir/version.h" <<H
#ifndef VERSION_H
#define VERSION_H

const char *version_string(void);

#endif
H

cat > "$out_dir/version.c" <<C
#include "version.h"

const char *version_string(void) { return "$version"; }
C

echo "[gen]  $out_dir/version.c + version.h (v$version)"

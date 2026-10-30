#!/usr/bin/env bash
# Generador: lee VERSION y escribe build_info.c Y build_info.h en OUT_DIR.
# Uso: gen-info.sh VERSION_FILE OUT_DIR
set -euo pipefail

version="$(tr -d '[:space:]' < "$1")"
out_dir="$2"
sleep 0.2

printf '#ifndef BUILD_INFO_H\n#define BUILD_INFO_H\n\nconst char *build_version(void);\n\n#endif\n' \
  > "$out_dir/build_info.h"
printf '#include "build_info.h"\n\nconst char *build_version(void) { return "%s"; }\n' "$version" \
  > "$out_dir/build_info.c"

echo "[gen]  $out_dir/build_info.c + build_info.h (v$version)"

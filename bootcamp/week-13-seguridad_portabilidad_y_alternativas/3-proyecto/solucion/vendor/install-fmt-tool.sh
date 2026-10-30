#!/bin/sh
# Instalador de fmt-tool 1.2.0 (simulado). En un proyecto real lo descargarías
# de https://...; aquí vive en vendor/ para que el proyecto funcione sin red.
# Uso: PREFIX=directorio sh install-fmt-tool.sh
set -eu
: "${PREFIX:?PREFIX no definido}"
mkdir -p "$PREFIX"
cat > "$PREFIX/fmt-tool" <<'TOOL'
#!/bin/sh
# fmt-tool 1.2.0 (simulado): comprueba la sintaxis de scripts bash
for f in "$@"; do bash -n "$f" || exit 1; done
echo "fmt-tool 1.2.0: $# archivo(s) OK"
TOOL
chmod 755 "$PREFIX/fmt-tool"
echo "fmt-tool 1.2.0 instalado en $PREFIX"

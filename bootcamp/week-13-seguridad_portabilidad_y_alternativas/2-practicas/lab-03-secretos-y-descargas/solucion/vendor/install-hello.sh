#!/bin/sh
# Instalador de hello 2.0.1 (simulado, sin red). Uso: PREFIX=dir sh install-hello.sh
set -eu
: "${PREFIX:?PREFIX no definido}"
mkdir -p "$PREFIX"
printf '#!/bin/sh\necho "hola desde hello 2.0.1"\n' > "$PREFIX/hello"
chmod 755 "$PREFIX/hello"
echo "hello 2.0.1 instalado en $PREFIX"

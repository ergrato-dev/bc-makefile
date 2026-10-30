# Glosario — Semana 03: Shell en recetas y modo estricto

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `SHELL` | Programa que ejecuta las recetas; por defecto `/bin/sh` y nunca se toma del entorno | `SHELL := bash` |
| `.SHELLFLAGS` | Opciones que Make pasa al shell antes de cada línea; por defecto `-c`, que debe ir siempre al final | `.SHELLFLAGS := -eu -o pipefail -c` |
| dash | Shell POSIX mínimo que es `/bin/sh` en Debian/Ubuntu; sin `[[ ]]`, llaves ni `pipefail` | `make mode SHELL=/bin/dash` |
| `-e` (errexit) | El shell para en el primer comando que falla, aunque no sea el último de la línea | `test -f config.ini; echo ok` falla |
| `-u` (nounset) | Una variable de shell sin definir es un error en vez de una cadena vacía | `echo "$${DEST_DIR:-dist}"` |
| `pipefail` | Una tubería falla si falla cualquiera de sus etapas, no solo la última | `awk ... \| sort > $@` |
| Preámbulo estricto | Las tres líneas con las que empieza todo Makefile del bootcamp desde la Semana 03 | `SHELL := bash` + `.SHELLFLAGS` + `.DELETE_ON_ERROR:` |
| `.DELETE_ON_ERROR` | Target especial: si la receta de un archivo falla, Make borra ese archivo | `.DELETE_ON_ERROR:` |
| `.ONESHELL` | Target especial: cada receta completa va a un único shell, en todo el Makefile | `.ONESHELL:` |
| `$$` | Escapa `$` para que lo expanda el shell y no Make | `for f in *.txt; do echo "$$f"; done` |
| Continuación `\` | Une varias líneas de receta en una sola línea lógica, ejecutada por un solo shell | `@for f in a b; do \` |
| Prefijo `-` | Ignora el código de salida de esa línea de receta | `-notify-send "build listo"` |
| Prefijo `+` | Ejecuta la línea incluso con `make -n`; solo para llamadas a `$(MAKE)` | `+$(MAKE) -C lib` |
| `make -n` / `-k` / `-i` | Previsualizar sin ejecutar / seguir con lo independiente tras un error / ignorar todos los errores | `make -n clean` |
| Guarda de `rm -rf` | Línea de Make que detiene la receta si la variable a borrar está vacía | `$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))` |

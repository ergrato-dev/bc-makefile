# ============================================================
# Lab 06 — Shell roto: siete fallos en un Makefile de eventos (SOLUCIÓN)
# Semana 03: Shell en recetas y modo estricto
# ============================================================

SHELL       := bash
# FIX: A — sin SHELL, Make usa /bin/sh (dash en Debian/Ubuntu), que no tiene [[ ]].
.SHELLFLAGS := -eu -o pipefail -c
# FIX: B — sin pipefail, la tubería de levels devolvía el código de uniq, no el de awk.
.DELETE_ON_ERROR:
# FIX: C — sin .DELETE_ON_ERROR, el levels.txt a medias quedaba como "al día".

.PHONY: all check levels warnings list archive clean help
.DEFAULT_GOAL := help

DATA      := data/eventos.csv
BUILD_DIR := build
AWK       := awk

LEVELS    := $(BUILD_DIR)/levels.txt
WARNINGS  := $(BUILD_DIR)/warnings.txt
ARCHIVE   := $(BUILD_DIR)/eventos.tar.gz

all: check levels warnings archive ## Valida, genera los reportes y los empaqueta

check: ## Comprueba que el CSV de entrada no está vacío
	@if [[ ! -s $(DATA) ]]; then echo "$(DATA) está vacío" >&2; exit 1; fi
	@echo "datos OK: $(DATA)"

levels: $(LEVELS) ## Cuenta eventos por nivel

$(LEVELS): $(DATA)
	mkdir -p $(BUILD_DIR)
	$(AWK) -F, 'NF != 3 { print FILENAME ":" NR ": línea corrupta" > "/dev/stderr"; exit 1 } { print $$2 }' $(DATA) \
		| sort | uniq -c > $@

warnings: $(WARNINGS) ## Extrae los mensajes de nivel WARN

$(WARNINGS): $(DATA)
	mkdir -p $(BUILD_DIR)
	{ grep ',WARN,' $(DATA) || test $$? -eq 1; } | cut -d, -f3 > $@
# FIX: F — con pipefail, grep sin coincidencias (exit 1) tumbaba el build. Se
# tolera solo el 1; un exit 2 (archivo ilegible) sigue siendo un error.

list: ## Lista los CSV de data/ con su número de líneas
	@for f in data/*.csv; do \
		echo "$$f: $$($(AWK) 'END { print NR }' $$f) líneas"; \
	done
# FIX: E — $f lo expandía Make (variable f, vacía). $$f le llega al shell como $f.

archive: $(ARCHIVE) ## Empaqueta los reportes en build/eventos.tar.gz

$(ARCHIVE): $(LEVELS) $(WARNINGS)
	cd $(BUILD_DIR) && tar -czf eventos.tar.gz levels.txt warnings.txt
# FIX: D — cada línea es un shell nuevo: el cd no llegaba al tar.

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
# FIX: G — $(OUTDIR) no existe y se expandía a vacío: rm -rf sin argumentos.
# La guarda habría parado justo en ese typo. Comillas y -- para rutas raras.

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

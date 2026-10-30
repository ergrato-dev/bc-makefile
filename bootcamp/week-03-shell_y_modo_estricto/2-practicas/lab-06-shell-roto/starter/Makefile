# ============================================================
# Lab 06 — Shell roto: siete fallos en un Makefile de eventos
# Semana 03: Shell en recetas y modo estricto
# ============================================================
# Este Makefile tiene 7 bugs (A-G). La tabla del README da el síntoma de
# cada uno, no su ubicación. Debajo de cada corrección escribe un comentario
# "# FIX: <letra> — qué cambiaste y por qué", en columna 0.
# ============================================================

.SHELLFLAGS := -eu -c

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
	grep ',WARN,' $(DATA) | cut -d, -f3 > $@

list: ## Lista los CSV de data/ con su número de líneas
	@for f in data/*.csv; do \
		echo "$f: $$($(AWK) 'END { print NR }' $$f) líneas"; \
	done

archive: $(ARCHIVE) ## Empaqueta los reportes en build/eventos.tar.gz

$(ARCHIVE): $(LEVELS) $(WARNINGS)
	cd $(BUILD_DIR)
	tar -czf eventos.tar.gz levels.txt warnings.txt

clean: ## Borra build/
	rm -rf $(OUTDIR)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

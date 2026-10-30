SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all setup process backup clean help

.DEFAULT_GOAL := help

STEMS   := alpha beta gamma
PROC    := $(addsuffix .processed, $(STEMS))
BACKUPS := $(addsuffix .backup, $(STEMS))

## setup: crea los archivos .raw de prueba
setup:
	@for name in $(STEMS); do \
		echo "contenido de $$name" > $$name.raw; \
		echo "[setup] $$name.raw creado"; \
	done

## process: convierte todos los .raw a .processed
process: $(PROC)

## backup: convierte todos los .raw a .backup
backup: $(BACKUPS)

%.processed: %.raw
	@cp $< $@
	@echo "[ok] $@"

%.backup: %.raw
	@cp $< $@
	@echo "[backup] $@"

## clean: elimina todos los archivos generados
clean:
	@rm -f *.raw *.processed *.backup
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

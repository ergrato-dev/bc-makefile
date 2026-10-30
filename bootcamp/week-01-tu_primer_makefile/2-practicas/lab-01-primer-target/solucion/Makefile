# ============================================================
# Lab 01 — Tu primer target (SOLUCIÓN)
# ============================================================

.PHONY: saludar info check-make donde help

.DEFAULT_GOAL := help

## saludar: imprime un saludo en pantalla
saludar:
	@echo "Hola desde Make!"

## info: muestra información del sistema
info:
	@echo "Fecha:       $(shell date)"
	@echo "Usuario:     $(shell whoami)"
	@echo "Directorio:  $(shell pwd)"

## check-make: falla si GNU Make es anterior a 4.3
check-make:
	@echo "Usando GNU Make $(MAKE_VERSION)"
	@printf '%s\n' 4.3 $(MAKE_VERSION) | sort -V -C \
		|| (echo "Error: necesitas GNU Make >= 4.3" && exit 1)
	@echo "Versión OK."

## donde: demuestra que cada línea de receta usa su propia shell
donde:
	@cd /tmp
	@pwd
	@cd /tmp && pwd

## help: muestra esta ayuda
help:
	@echo "Targets disponibles:"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

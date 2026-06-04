# ============================================================
# Lab 01 — Tu primer target (SOLUCIÓN)
# ============================================================

.PHONY: all saludar info help

.DEFAULT_GOAL := help

## saludar: imprime un saludo en pantalla
saludar:
	@echo "Hola desde Make!"

## info: muestra información del sistema
info:
	@echo "Fecha:       $(shell date)"
	@echo "Usuario:     $(shell whoami)"
	@echo "Directorio:  $(shell pwd)"

## help: muestra esta ayuda
help:
	@echo "Targets disponibles:"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

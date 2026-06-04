# ============================================================
# Lab 01 — Tu primer target
# Semana 01: Tu primer Makefile
# ============================================================
# Instrucciones:
#   1. Lee cada TODO y completa la implementación
#   2. Ejecuta `make help` para ver los targets disponibles
#   3. Verifica con `make saludar` y luego `make info`
# ============================================================

.PHONY: all saludar info help

.DEFAULT_GOAL := help

## saludar: imprime un saludo en pantalla
saludar:
	# TODO: agrega un @echo que imprima exactamente: Hola desde Make!

## info: muestra información del sistema
info:
	# TODO: imprime tres líneas con este formato:
	#   Fecha:       <resultado de $(shell date)>
	#   Usuario:     <resultado de $(shell whoami)>
	#   Directorio:  <resultado de $(shell pwd)>

## help: muestra esta ayuda
help:
	@echo "Targets disponibles:"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

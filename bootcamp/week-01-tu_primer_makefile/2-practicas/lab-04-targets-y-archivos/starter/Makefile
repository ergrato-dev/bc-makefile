# ============================================================
# Lab 04 — Targets que crean archivos vs targets PHONY
# Semana 01: Tu primer Makefile
# ============================================================
# Instrucciones:
#   1. Ejecuta `make preparar` para crear datos.csv
#   2. Ejecuta `make reporte.txt` dos veces — observa qué pasa
#   3. Agrega la dependencia (ver TODO) y repite el experimento
# ============================================================

.PHONY: all preparar clean help

.DEFAULT_GOAL := help

## preparar: crea datos.csv con datos de ejemplo
preparar:
	@echo "nombre,edad,ciudad" > datos.csv
	@echo "Ana,30,Bogotá" >> datos.csv
	@echo "Luis,25,Medellín" >> datos.csv
	@echo "Sara,28,Cali" >> datos.csv
	@echo "datos.csv creado."

# TODO: agrega 'datos.csv' como dependencia de este target
#       →  reporte.txt: datos.csv
## reporte.txt: genera el reporte a partir de datos.csv
reporte.txt:
	@echo "Generando reporte.txt..."
	@echo "=== REPORTE ===" > reporte.txt
	@echo "Generado: $(shell date)" >> reporte.txt
	@echo "---" >> reporte.txt
	@cat datos.csv >> reporte.txt
	@echo "reporte.txt generado."

## all: prepara datos y genera reporte
all: preparar reporte.txt

## clean: elimina archivos generados
clean:
	@rm -f datos.csv reporte.txt
	@echo "Limpio."

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

# ============================================================
# Lab 04 — Targets que crean archivos vs targets PHONY (SOLUCIÓN)
# ============================================================

.PHONY: all preparar clean help

.DEFAULT_GOAL := help

preparar: ## crea datos.csv con datos de ejemplo
	@echo "nombre,edad,ciudad" > datos.csv
	@echo "Ana,30,Bogotá" >> datos.csv
	@echo "Luis,25,Medellín" >> datos.csv
	@echo "Sara,28,Cali" >> datos.csv
	@echo "datos.csv creado."

reporte.txt: datos.csv ## genera el reporte a partir de datos.csv
	@echo "Generando reporte.txt..."
	@echo "=== REPORTE ===" > reporte.txt
	@echo "Generado: $(shell date)" >> reporte.txt
	@echo "---" >> reporte.txt
	@cat datos.csv >> reporte.txt
	@echo "reporte.txt generado."

resumen.txt: reporte.txt ## cuenta las líneas de reporte.txt
	@echo "Generando resumen.txt..."
	@echo "Líneas del reporte: $$(wc -l < reporte.txt)" > resumen.txt

all: preparar reporte.txt ## prepara datos y genera reporte

clean: ## elimina archivos generados
	@rm -f datos.csv reporte.txt resumen.txt
	@echo "Limpio."

help: ## muestra esta ayuda
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# ============================================================
# Lab 01 — Variable automática $@
# Semana 04: Variables automáticas
# ============================================================
# Instrucciones:
#   1. Completa las recetas usando $@ en lugar del nombre literal del target
#   2. Verifica con: make reporte-html | make reporte-pdf | make reporte-csv
#   3. Agrega reporte-json como reto
# ============================================================

.PHONY: reporte-html reporte-pdf reporte-csv archivos limpiar help

.DEFAULT_GOAL := help

# ── Fecha de build (capturada una sola vez con :=) ────────────
FECHA := $(shell date +%F)

# ── Targets ───────────────────────────────────────────────────

reporte-html: ## genera el informe en formato HTML
	# TODO: imprime "[generando] <nombre-del-target>" usando $@
	# TODO: imprime "[listo] Archivo: $(FECHA)-<nombre-del-target>.html"
	#       Escribe: @echo "[listo] Archivo: $(FECHA)-$@.html"
	#       Nota: NO escribas "reporte-html" literalmente

reporte-pdf: ## genera el informe en formato PDF
	# TODO: misma estructura que reporte-html
	# TODO: cambia solo la extensión: .pdf
	# Tip: $@ resuelve a "reporte-pdf" automáticamente

reporte-csv: ## genera el informe en formato CSV
	# TODO: mismo patrón; extensión: .csv

archivos: ventas.txt gastos.txt ## genera ventas.txt y gastos.txt con una sola regla

# TODO (paso 7): una sola regla con DOS targets. Receta, sin escribir ningún nombre:
#   escribe "Informe <target> del <FECHA>" en el archivo del target (> $@)
#   imprime "[listo] <target> creado"
ventas.txt gastos.txt:
	@echo "TODO: implementa la regla de archivos"

limpiar: ## borra los archivos generados
	@rm -f ventas.txt gastos.txt
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

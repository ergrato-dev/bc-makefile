# ============================================================
# Lab 01 — Solución: Variable automática $@
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: reporte-html reporte-pdf reporte-csv reporte-json archivos limpiar help

.DEFAULT_GOAL := help

FECHA := $(shell date +%F)

reporte-html: ## genera el informe en formato HTML
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.html"

reporte-pdf: ## genera el informe en formato PDF
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.pdf"

reporte-csv: ## genera el informe en formato CSV
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.csv"

reporte-json: ## genera el informe en formato JSON
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.json"

archivos: ventas.txt gastos.txt ## genera ventas.txt y gastos.txt con una sola regla

# Una regla, dos targets: Make la ejecuta una vez por cada uno y $@ cambia
ventas.txt gastos.txt:
	@echo "Informe $@ del $(FECHA)" > $@
	@echo "[listo] $@ creado"

limpiar: ## borra los archivos generados
	@rm -f ventas.txt gastos.txt
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

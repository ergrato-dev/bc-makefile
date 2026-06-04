# ============================================================
# Lab 01 — Solución: Variable automática $@
# Semana 03: Variables automáticas
# ============================================================

.PHONY: reporte-html reporte-pdf reporte-csv reporte-json help

.DEFAULT_GOAL := help

FECHA := $(shell date +%F)

## reporte-html: genera el informe en formato HTML
reporte-html:
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.html"

## reporte-pdf: genera el informe en formato PDF
reporte-pdf:
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.pdf"

## reporte-csv: genera el informe en formato CSV
reporte-csv:
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.csv"

## reporte-json: genera el informe en formato JSON
reporte-json:
	@echo "[generando] $@"
	@echo "[listo] Archivo: $(FECHA)-$@.json"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

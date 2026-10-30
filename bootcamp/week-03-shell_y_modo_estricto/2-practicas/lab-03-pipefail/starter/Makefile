# ============================================================
# Lab 03 — pipefail: tuberías que no esconden fallos
# Semana 03: Shell en recetas y modo estricto
# ============================================================

SHELL       := bash
# TODO (paso 2): añade -o pipefail entre -eu y -c.
.SHELLFLAGS := -eu -c

.PHONY: demo countries amounts sigpipe-demo top3 clean help
.DEFAULT_GOAL := help

DATA      := data/pedidos.csv
COUNTRY   := ES
BUILD_DIR := build
AWK       := awk
export LC_ALL := C

demo: ## Ejecuta false | true
	false | true

# TODO (paso 4): añade a la primera etapa una validación que pare la tubería
# si una línea no tiene 4 columnas (id,cliente,pais,importe).
countries: ## Cuenta pedidos por país en build/countries.txt
	mkdir -p $(BUILD_DIR)
	cat $(DATA) | cut -d, -f3 | sort | uniq -c | sort -rn > $(BUILD_DIR)/countries.txt
	cat $(BUILD_DIR)/countries.txt

# TODO (paso 5): un país sin pedidos no es un error; un archivo ilegible, sí.
amounts: ## Importes de COUNTRY, ordenados, en build/amounts.txt
	mkdir -p $(BUILD_DIR)
	grep ",$(COUNTRY)," $(DATA) | cut -d, -f4 | sort -n > $(BUILD_DIR)/amounts.txt
	echo "importes de $(COUNTRY): $$(paste -sd' ' $(BUILD_DIR)/amounts.txt)"

sigpipe-demo: ## Primeras 3 líneas de un millón
	seq 1 1000000 | head -n 3

# TODO (paso 6): los 3 pedidos de mayor importe, sin usar head.
top3: ## Los 3 pedidos de mayor importe
	@echo "TODO: implementa top3 (paso 6)"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

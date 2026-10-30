# ============================================================
# Lab 03 — pipefail: tuberías que no esconden fallos (SOLUCIÓN)
# Semana 03: Shell en recetas y modo estricto
# ============================================================

SHELL       := bash
# Sin pipefail, el código de salida de una tubería es el de su ÚLTIMA etapa.
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo countries amounts sigpipe-demo top3 clean help
.DEFAULT_GOAL := help

DATA      := data/pedidos.csv
COUNTRY   := ES
BUILD_DIR := build
AWK       := awk
export LC_ALL := C

# Con pipefail, este target falla: es lo esperado.
demo: ## Ejecuta false | true
	false | true

# La validación va en la PRIMERA etapa: si encuentra una línea corrupta sale
# con 1, y pipefail impide que sort, el último, tape ese fallo.
countries: ## Cuenta pedidos por país en build/countries.txt
	mkdir -p $(BUILD_DIR)
	$(AWK) -F, 'NF != 4 { print FILENAME ":" NR ": línea corrupta" > "/dev/stderr"; exit 1 } { print $$3 }' $(DATA) \
		| sort | uniq -c | sort -rn > $(BUILD_DIR)/countries.txt
	cat $(BUILD_DIR)/countries.txt

# grep: 0 = hay coincidencias, 1 = no hay, 2 = error. Solo toleramos el 1.
amounts: ## Importes de COUNTRY, ordenados, en build/amounts.txt
	mkdir -p $(BUILD_DIR)
	{ grep ",$(COUNTRY)," $(DATA) || test $$? -eq 1; } | cut -d, -f4 | sort -n > $(BUILD_DIR)/amounts.txt
	echo "importes de $(COUNTRY): $$(paste -sd' ' $(BUILD_DIR)/amounts.txt)"

# head sale tras 3 líneas; seq muere con SIGPIPE (141) y pipefail lo cuenta.
# awk 'NR <= 3' lee la entrada entera y no cierra la tubería antes de tiempo.
sigpipe-demo: ## Primeras 3 líneas de un millón
	seq 1 1000000 | $(AWK) 'NR <= 3'

top3: ## Los 3 pedidos de mayor importe
	sort -t, -k4 -rn $(DATA) | $(AWK) 'NR <= 3'

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

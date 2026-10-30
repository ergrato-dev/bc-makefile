# ============================================================
# Lab 04 — Testing de Makefiles (STARTER)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# Genera build/report.txt a partir de data/*.csv. Funciona con `make all`...
# casi siempre. Tu trabajo: escribir el target `check` que lo demuestre, y
# arreglar lo que encuentre.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean check help
.DEFAULT_GOAL := help

BUILD_DIR := build
DATA      := $(sort $(wildcard data/*.csv))
TITLE     ?= Informe de ventas

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

all: $(BUILD_DIR)/header.txt $(BUILD_DIR)/report.txt ## Genera build/report.txt

$(BUILD_DIR):
	mkdir -p '$@'

$(BUILD_DIR)/header.txt: | $(BUILD_DIR)
	printf '# %s\n' '$(TITLE)' > '$@'

$(BUILD_DIR)/total.txt: $(DATA) | $(BUILD_DIR)
	awk -F, '{ s += $$2 } END { print "Total:", s }' $(DATA) > '$@'

$(BUILD_DIR)/report.txt: $(BUILD_DIR)/total.txt
	cat '$(BUILD_DIR)/header.txt' '$<' > '$@'
	@echo "Informe '$(REPORT_TITLE)' listo"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

# TODO (paso 4): autoprueba del Makefile. Cada comprobación, una línea que
# falla (exit != 0) si el Makefile tiene el problema.
check: ## Autoprueba del Makefile
	@echo "TODO: implementa la autoprueba"
	@exit 1

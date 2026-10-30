# ============================================================
# Lab 04 — Testing de Makefiles (SOLUCIÓN)
# ============================================================

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

# FIX: la receta lee header.txt, así que es prerrequisito. $< sigue siendo total.txt.
$(BUILD_DIR)/report.txt: $(BUILD_DIR)/total.txt $(BUILD_DIR)/header.txt
	cat '$(BUILD_DIR)/header.txt' '$<' > '$@'
	@echo "Informe '$(TITLE)' listo"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

# --- Autoprueba -------------------------------------------------------------
# Cada línea falla (exit != 0) si el Makefile tiene el problema que comprueba.
SELFTEST := $(BUILD_DIR)/selftest
SUBMAKE  := $(MAKE) --no-print-directory

check: ## Autoprueba del Makefile
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(SELFTEST)'
	@echo "1/4 sin variables indefinidas"
	@out=$$($(SUBMAKE) --warn-undefined-variables -n -B all 2>&1) \
		&& ! grep 'undefined variable' <<<"$$out"
	@echo "2/4 el dry-run coincide con tests/dry-run.expected"
	@$(SUBMAKE) -n -B all | diff -u tests/dry-run.expected -
	@echo "3/4 cada target se construye aislado, desde cero"
	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/a' '$(SELFTEST)/a/report.txt'
	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/b' '$(SELFTEST)/b/total.txt'
	@echo "4/4 tras construir, make -q dice que todo está al día"
	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/c' all
	@$(SUBMAKE) -q BUILD_DIR='$(SELFTEST)/c' all
	@rm -rf -- '$(SELFTEST)'
	@echo "check: OK"

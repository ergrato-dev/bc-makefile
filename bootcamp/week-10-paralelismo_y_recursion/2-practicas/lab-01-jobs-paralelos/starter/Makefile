# ============================================================
# Lab 01 — -j: cuántas tareas a la vez
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean concurrency help
.DEFAULT_GOAL := help

# --- Configuración -------------------------------------------
OUT_DIR := out
DELAY   ?= 1
SERIAL  ?=
TRACE   := $(OUT_DIR)/trace.log
NAMES   := ventas compras stock clientes envios devoluciones
REPORTS := $(addprefix $(OUT_DIR)/,$(addsuffix .txt,$(NAMES)))

# TODO 3: si SERIAL vale 1, declara .NOTPARALLEL: (sin prerrequisitos)
#         para que este Makefile ignore -j. Usa ifeq ($(SERIAL),1).

# --- Build ---------------------------------------------------
all: $(REPORTS) ## Genera los seis informes

# TODO 1: deja rastro en $(TRACE): una línea "start <nombre>" antes del
#         sleep y otra "end <nombre>" después de escribir el informe.
#         El nombre es el stem: $*. Usa >> (añadir), nunca >.
$(OUT_DIR)/%.txt: | $(OUT_DIR)
	@echo "[$*] generando..."
	@sleep $(DELAY)
	@echo "informe $*" > $@

$(OUT_DIR):
	@mkdir -p $@

# TODO 2: recorre $(TRACE) con awk: cada línea start suma 1, cada end
#         resta 1. Imprime el máximo alcanzado como
#         "Máximo simultáneo: N". Si $(TRACE) no existe, avisa y sal con 1.
concurrency: ## Máximo de informes generados a la vez en el último build
	@echo "TODO: implementa concurrency"

# --- Utilidades ----------------------------------------------
clean: ## Borra out/
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(OUT_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

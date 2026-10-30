# ============================================================
# Lab 01 — -j: cuántas tareas a la vez (SOLUCIÓN)
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

# SERIAL=1 desactiva el paralelismo de todo este Makefile, aunque pases -j.
ifeq ($(SERIAL),1)
.NOTPARALLEL:
endif

# --- Build ---------------------------------------------------
all: $(REPORTS) ## Genera los seis informes

# Cada informe tarda DELAY segundos y no depende de ningún otro:
# es exactamente el trabajo que -j sabe repartir.
# "start" y "end" dejan rastro en TRACE para contar solapes.
$(OUT_DIR)/%.txt: | $(OUT_DIR)
	@echo "start $*" >> $(TRACE)
	@echo "[$*] generando..."
	@sleep $(DELAY)
	@echo "informe $*" > $@
	@echo "end $*" >> $(TRACE)

$(OUT_DIR):
	@mkdir -p $@

# Recorre TRACE en orden: cada start suma uno, cada end resta uno.
# El máximo alcanzado es cuántos informes se generaron a la vez.
concurrency: ## Máximo de informes generados a la vez en el último build
	@test -f $(TRACE) || { echo "No hay $(TRACE): ejecuta antes un build desde cero"; exit 1; }
	@awk '/^start/ {n++; if (n > m) m = n} /^end/ {n--} END {print "Máximo simultáneo: " m}' $(TRACE)

# --- Utilidades ----------------------------------------------
clean: ## Borra out/
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(OUT_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

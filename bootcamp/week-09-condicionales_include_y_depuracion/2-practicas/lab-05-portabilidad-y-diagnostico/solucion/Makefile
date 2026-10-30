SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# --- Portabilidad: versión mínima y features ------------------------------
# Se evalúa al leer el archivo: falla antes de ejecutar ningún target.
# $(sort) compara como texto: 3.81 < 4.3 < 4.4.1, pero un futuro 4.10 < 4.3.
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Este Makefile requiere GNU Make >= $(MIN_MAKE_VERSION) y estás usando $(MAKE_VERSION). En macOS: brew install make y ejecuta gmake)
endif

# Comprobar la feature concreta que usamos es más robusto que la versión.
ifeq ($(filter grouped-target,$(.FEATURES)),)
  $(error Este Makefile usa grouped targets (&:) y tu Make no los soporta)
endif

.PHONY: all clean publish doctor help
.DEFAULT_GOAL := help

# --- Rutas -----------------------------------------------------------------
PROJECT := ventas
OUT_DIR := out
DATA    := $(sort $(wildcard data/*.csv))
REPORT  := $(OUT_DIR)/report.csv
SUMMARY := $(OUT_DIR)/summary.txt
TOTALS  := $(OUT_DIR)/totals.txt
COUNTS  := $(OUT_DIR)/counts.txt

# --- Validación solo cuando se pide publish -------------------------------
# MAKECMDGOALS contiene los targets pedidos en la línea de comandos.
ifneq ($(filter publish,$(MAKECMDGOALS)),)
  ifndef DEST
    $(error publish necesita DEST: make publish DEST=/ruta/destino)
  endif
endif

all: $(SUMMARY) ## Generar el informe y el resumen

# Une todos los CSV en uno, con una sola cabecera.
$(REPORT): $(DATA)
	@mkdir -p $(@D)
	@{ head -n1 $<; tail -q -n +2 $^; } > $@
	@echo "[report] $@ <- $(words $^) archivos"

# Una sola ejecución produce los dos archivos (grouped target, Make 4.3+).
$(TOTALS) $(COUNTS) &: $(REPORT)
	@awk -F, 'NR>1 {u[$$2]+=$$3} END {for (p in u) print p, u[p]}' $< | sort > $(TOTALS)
	@awk -F, 'NR>1 {n[$$1]++} END {for (r in n) print r, n[r]}' $< | sort > $(COUNTS)
	@echo "[totals] $(TOTALS) y $(COUNTS)"

$(SUMMARY): $(TOTALS) $(COUNTS)
	@echo "Resumen de $(PROJECT): $$(wc -l < $(REPORT)) líneas" > $@
	@cat $^ >> $@
	@echo "[summary] $@"

publish: all ## Copiar el resumen a DEST (obligatorio)
	@mkdir -p '$(DEST)'
	@cp $(SUMMARY) '$(DEST)/'
	@echo "Publicado en $(DEST)"

doctor: ## Mostrar versión, features y flags de Make
	$(info MAKE_VERSION   = $(MAKE_VERSION) (mínimo $(MIN_MAKE_VERSION)))
	$(info grouped-target = $(if $(filter grouped-target,$(.FEATURES)),sí,no))
	$(info MAKECMDGOALS   = $(MAKECMDGOALS))
	$(info MAKEFLAGS      = $(MAKEFLAGS))
	@echo "Diagnóstico OK"

clean: ## Borrar OUT_DIR
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(OUT_DIR)'

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# --------------------------------------------------------------------------
# TODO 1 (paso 2): guarda de versión mínima, sin $(shell).
#   MIN_MAKE_VERSION := 4.3
#   Si $(MIN_MAKE_VERSION) no es el primero de $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION)),
#   detén Make con $(error ...) diciendo qué versión hace falta, cuál se usa
#   y cómo arreglarlo en macOS.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2 (paso 3): este Makefile usa grouped targets (&:). Si la palabra
#   grouped-target no está en $(.FEATURES), detén Make con un $(error ...)
#   que lo explique.
# --------------------------------------------------------------------------

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

# --------------------------------------------------------------------------
# TODO 3 (paso 6): solo si publish está en $(MAKECMDGOALS) y DEST no está
#   definida, detén Make con:
#   publish necesita DEST: make publish DEST=/ruta/destino
#   'make all' y 'make help' tienen que seguir funcionando sin DEST.
# --------------------------------------------------------------------------

all: $(SUMMARY) ## Generar el informe y el resumen

# Une todos los CSV en uno, con una sola cabecera.
$(REPORT): $(DATA)
	@mkdir -p $(@D)
	@{ head -n1 $<; tail -q -n +2 $^; } > $@
	@echo "[report] $@ <- $(words $(DATOS)) archivos"

# Una sola ejecución produce los dos archivos (grouped target, Make 4.3+).
$(TOTALS) $(COUNTS) &: $(REPORT)
	@awk -F, 'NR>1 {u[$$2]+=$$3} END {for (p in u) print p, u[p]}' $< | sort > $(TOTALS)
	@awk -F, 'NR>1 {n[$$1]++} END {for (r in n) print r, n[r]}' $< | sort > $(COUNTS)
	@echo "[totals] $(TOTALS) y $(COUNTS)"

$(SUMMARY): $(TOTALS) $(COUNTS)
	@echo "Resumen de $(PROYECT): $$(wc -l < $(REPORT)) líneas" > $@
	@cat $^ >> $@
	@echo "[summary] $@"

publish: all ## Copiar el resumen a DEST (obligatorio)
	@mkdir -p '$(DEST)'
	@cp $(SUMMARY) '$(DEST)/'
	@echo "Publicado en $(DEST)"

# --------------------------------------------------------------------------
# TODO 4 (paso 7): 'doctor' muestra con $(info ...) una línea por dato:
#   MAKE_VERSION   = <versión> (mínimo <MIN_MAKE_VERSION>)
#   grouped-target = sí | no      (pista: $(if $(filter ...),sí,no))
#   MAKECMDGOALS   = ...
#   MAKEFLAGS      = ...
# --------------------------------------------------------------------------
doctor: ## Mostrar versión, features y flags de Make
	@echo "Diagnóstico OK"

clean: ## Borrar OUT_DIR
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(OUT_DIR)'

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

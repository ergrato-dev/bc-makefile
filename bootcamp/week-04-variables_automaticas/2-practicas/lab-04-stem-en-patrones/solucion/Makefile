# ============================================================
# Lab 04 — Solución: Variable automática $*
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all setup limpiar help

.DEFAULT_GOAL := help

ENTRADAS := alfa.entrada beta.entrada gamma.entrada
SALIDAS  := $(ENTRADAS:.entrada=.resultado)

all: $(SALIDAS) ## procesa todos los archivos .entrada → .resultado

# $* = stem que coincidió con %
# Para "alfa.resultado": $* = alfa, $< = alfa.entrada, $@ = alfa.resultado
%.resultado: %.entrada
	@echo "[proceso] Stem:    $*"
	@echo "[proceso] Entrada: $<"
	@echo "[proceso] Salida:  $@"
	@cp $< $@
	@mkdir -p logs
	@echo "$* procesado desde $<" > logs/$(*F).log
	@echo "[proceso] Log:     logs/$(*F).log"

setup: ## crea archivos .entrada de prueba
	@echo "datos de alfa"  > alfa.entrada
	@echo "datos de beta"  > beta.entrada
	@echo "datos de gamma" > gamma.entrada
	@mkdir -p sub
	@echo "datos de delta" > sub/delta.entrada
	@echo "[setup] Archivos creados: $(ENTRADAS)"

limpiar: ## elimina los archivos generados
	@rm -f $(SALIDAS) $(ENTRADAS)
	@rm -rf -- logs sub
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target | <nombre>.resultado]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

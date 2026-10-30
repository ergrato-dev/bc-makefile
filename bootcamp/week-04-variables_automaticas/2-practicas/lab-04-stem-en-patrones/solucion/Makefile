# ============================================================
# Lab 04 — Solución: Variable automática $*
# Semana 04: Variables automáticas
# ============================================================

.PHONY: all setup limpiar help

.DEFAULT_GOAL := help

ENTRADAS := alfa.entrada beta.entrada gamma.entrada
SALIDAS  := $(ENTRADAS:.entrada=.resultado)

## all: procesa todos los archivos .entrada → .resultado
all: $(SALIDAS)

# $* = stem que coincidió con %
# Para "alfa.resultado": $* = alfa, $< = alfa.entrada, $@ = alfa.resultado
%.resultado: %.entrada
	@echo "[proceso] Stem:    $*"
	@echo "[proceso] Entrada: $<"
	@echo "[proceso] Salida:  $@"
	@echo "[proceso] Log:     logs/$*.log"
	@cp $< $@

## setup: crea archivos .entrada de prueba
setup:
	@echo "datos de alfa"  > alfa.entrada
	@echo "datos de beta"  > beta.entrada
	@echo "datos de gamma" > gamma.entrada
	@echo "[setup] Archivos creados: $(ENTRADAS)"

## limpiar: elimina los archivos generados
limpiar:
	@rm -f $(SALIDAS) $(ENTRADAS)
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target | <nombre>.resultado]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'

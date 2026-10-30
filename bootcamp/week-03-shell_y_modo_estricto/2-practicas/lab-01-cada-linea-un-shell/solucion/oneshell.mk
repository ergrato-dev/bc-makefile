# ============================================================
# Lab 01 — .ONESHELL y su trampa (SOLUCIÓN)
# Uso: make -f oneshell.mk deploy   (después de make prepare)
# ============================================================

# Con .ONESHELL toda la receta va a un único shell, y Make solo mira el
# código de salida del final. Sin -e, un fallo en mitad no detiene nada.
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.ONESHELL:

.PHONY: deploy help
.DEFAULT_GOAL := help

BUILD_DIR := build

deploy: ## Comprueba los artefactos y "despliega"
	cd $(BUILD_DIR)
	echo "comprobando artefactos en $$PWD"
	test -f marzo.txt
	echo "desplegado"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

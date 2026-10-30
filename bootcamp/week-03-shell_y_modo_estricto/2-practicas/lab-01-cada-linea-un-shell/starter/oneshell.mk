# ============================================================
# Lab 01 — .ONESHELL y su trampa (paso 7)
# Uso: make -f oneshell.mk deploy   (después de make prepare)
# ============================================================

# Con .ONESHELL, TODA la receta va a un único shell. Afecta a todas las
# recetas de este archivo, no se puede activar solo para un target.
.ONESHELL:

# TODO (paso 7): deploy imprime "desplegado" y sale con 0 aunque
# test -f falle. Añade aquí las dos líneas que lo hacen parar.

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

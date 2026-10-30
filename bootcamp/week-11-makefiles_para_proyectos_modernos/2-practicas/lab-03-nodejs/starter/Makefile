# TODO 0: Preámbulo estricto (Semana 03), antes de cualquier otra línea:
#         SHELL := bash
#         .SHELLFLAGS := -eu -o pipefail -c
#         .DELETE_ON_ERROR:

.PHONY: all install build test lint clean help
.DEFAULT_GOAL := help

PNPM     := pnpm
NODE     := node
SRC_DIR  := src
DIST_DIR := dist

# TODO 1: Define el target 'node_modules/.installed' con dependencias
#         package.json y pnpm-lock.yaml
#   Receta:
#     $(PNPM) install --frozen-lockfile
#     @mkdir -p $(@D)
#     @touch $@
#   --frozen-lockfile instala exactamente lo del lockfile. El mkdir asegura
#   que node_modules/ exista aunque el proyecto no tenga dependencias.


# TODO 2: Define el target 'install' como alias del sentinel file
#   install: node_modules/.installed ## Descripción aquí


# TODO 3: Define el target 'build' que dependa de install y ejecute pnpm run build


# TODO 4: Define el target 'test' que dependa de install y ejecute pnpm test


# TODO 5: Define el target 'lint' que dependa de install y ejecute pnpm run lint


# TODO 6: Define el target 'clean' que elimine node_modules/ y dist/
#   Guarda antes de borrar: $(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
#   Imprime "Limpiado." al terminar


# TODO 7: Build incremental. 'build' es phony y llama a pnpm siempre.
#   - Target de archivo $(DIST_DIR)/index.js con prerrequisitos
#     $(SRC_DIR)/index.js y node_modules/.installed; receta: $(PNPM) run build
#   - 'build' pasa a ser un alias: build: $(DIST_DIR)/index.js


help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

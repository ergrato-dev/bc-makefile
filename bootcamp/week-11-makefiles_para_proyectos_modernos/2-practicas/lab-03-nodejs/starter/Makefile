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
#   Imprime "Limpiado." al terminar


help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

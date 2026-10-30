.PHONY: all install build test lint clean help
.DEFAULT_GOAL := help

NPM      := npm
NODE     := node
SRC_DIR  := src
DIST_DIR := dist

# TODO 1: Define el target 'node_modules/.package-lock.json' con dependencia package.json
#   Receta:
#     $(NPM) install
#     @touch $@
#   Nota: npm install genera node_modules/.package-lock.json automáticamente.
#   El touch garantiza que Make actualice la fecha aunque el archivo ya exista.


# TODO 2: Define el target 'install' como alias del sentinel file
#   install: node_modules/.package-lock.json ## Descripción aquí


# TODO 3: Define el target 'build' que dependa de install y ejecute npm run build


# TODO 4: Define el target 'test' que dependa de install y ejecute npm test


# TODO 5: Define el target 'lint' que dependa de install y ejecute npm run lint


# TODO 6: Define el target 'clean' que elimine node_modules/ y dist/
#   Imprime "Limpiado." al terminar


help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
